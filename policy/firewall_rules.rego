package opnsense.firewall.rules

import rego.v1

# Deny rules that allow traffic from any source to any destination
deny contains msg if {
    input.firewall.rules[_].source == "any"
    input.firewall.rules[_].destination == "any"
    input.firewall.rules[_].action == "pass"
    msg := "Firewall rule allows traffic from any source to any destination - this is too permissive"
}

# Deny rules without proper logging enabled for security-critical rules
deny contains msg if {
    rule := input.firewall.rules[_]
    rule.action == "pass"
    rule.destination_port in ["22", "3389", "443", "80"]
    not rule.log
    msg := sprintf("Security-critical rule for port %s must have logging enabled", [rule.destination_port])
}

# Deny rules that use weak protocols
deny contains msg if {
    rule := input.firewall.rules[_]
    rule.protocol in ["telnet", "ftp", "http"]
    rule.action == "pass"
    msg := sprintf("Rule allows insecure protocol %s - consider using secure alternatives", [rule.protocol])
}

# Deny rules without descriptions
deny contains msg if {
    rule := input.firewall.rules[_]
    not rule.description
    msg := "All firewall rules must have a description for documentation purposes"
}

# Deny rules that allow administrative access from external networks
deny contains msg if {
    rule := input.firewall.rules[_]
    rule.action == "pass"
    rule.destination_port in ["22", "3389", "443"]
    not startswith(rule.source, "192.168.")
    not startswith(rule.source, "10.")
    not startswith(rule.source, "172.")
    rule.source != "localhost"
    msg := sprintf("Administrative access on port %s should not be allowed from external networks", [rule.destination_port])
}

# Deny rules with overly broad port ranges
deny contains msg if {
    rule := input.firewall.rules[_]
    rule.destination_port == "1-65535"
    rule.action == "pass"
    msg := "Firewall rule allows access to all ports - this is too permissive"
}

# Deny disabled rules that should be cleaned up
warn contains msg if {
    rule := input.firewall.rules[_]
    rule.enabled == false
    msg := sprintf("Disabled rule '%s' should be reviewed and potentially removed", [rule.description])
}

# Ensure default deny policy exists
deny contains msg if {
    not input.firewall.default_policy
    msg := "Firewall must have a default deny policy configured"
}

deny contains msg if {
    input.firewall.default_policy != "deny"
    msg := "Firewall default policy should be 'deny' for security"
}