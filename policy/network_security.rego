package opnsense.network.security

import rego.v1

# Deny configurations without intrusion detection/prevention
deny contains msg if {
    not input.security.ids_enabled
    msg := "Intrusion Detection System (IDS) must be enabled"
}

deny contains msg if {
    not input.security.ips_enabled
    msg := "Intrusion Prevention System (IPS) must be enabled"
}

# Deny weak DNS configurations
deny contains msg if {
    dns := input.network.dns_servers[_]
    dns in ["8.8.8.8", "1.1.1.1"]
    input.environment == "high_security"
    msg := "High security environments should use internal or trusted DNS servers, not public DNS"
}

# Deny configurations without DNS filtering
deny contains msg if {
    not input.security.dns_filtering_enabled
    msg := "DNS filtering must be enabled to block malicious domains"
}

# Deny configurations allowing unnecessary services
deny contains msg if {
    service := input.services.enabled[_]
    service in ["telnet", "ftp", "tftp", "rsh", "rlogin"]
    msg := sprintf("Insecure service '%s' should be disabled", [service])
}

# Deny configurations without proper NTP security
deny contains msg if {
    ntp := input.network.ntp
    not ntp.authentication_enabled
    msg := "NTP authentication must be enabled to prevent time-based attacks"
}

# Deny configurations with weak SNMP settings
deny contains msg if {
    snmp := input.services.snmp
    snmp.enabled == true
    snmp.version in ["v1", "v2c"]
    msg := "SNMP version 1 and 2c are insecure - use SNMPv3 with authentication"
}

deny contains msg if {
    snmp := input.services.snmp
    snmp.enabled == true
    snmp.community_string in ["public", "private", "admin"]
    msg := "SNMP uses default community string - change to a secure value"
}

# Deny configurations without proper logging
deny contains msg if {
    not input.logging.remote_syslog_enabled
    input.environment in ["enterprise", "high_security"]
    msg := "Enterprise environments must use remote syslog for centralized logging"
}

# Deny configurations with insufficient log retention
deny contains msg if {
    input.logging.retention_days < 90
    input.environment in ["enterprise", "high_security"]
    msg := "Log retention must be at least 90 days for compliance requirements"
}

# Deny configurations without network segmentation
deny contains msg if {
    count(input.network.vlans) < 2
    input.environment == "enterprise"
    msg := "Enterprise environments should implement network segmentation with VLANs"
}

# Deny configurations allowing ping responses from WAN
deny contains msg if {
    input.network.wan_ping_response == true
    msg := "WAN interface should not respond to ping requests for security"
}

# Deny configurations without proper bandwidth monitoring
warn contains msg if {
    not input.monitoring.bandwidth_monitoring
    msg := "Bandwidth monitoring should be enabled for network visibility"
}

# Deny configurations with weak web interface security
deny contains msg if {
    web := input.web_interface
    web.protocol == "http"
    msg := "Web interface must use HTTPS for secure administration"
}

deny contains msg if {
    web := input.web_interface
    not web.certificate_validation
    web.protocol == "https"
    msg := "Web interface HTTPS must use proper certificate validation"
}

# Deny configurations without session timeout
deny contains msg if {
    web := input.web_interface
    web.session_timeout > 3600  # 1 hour
    msg := "Web interface session timeout should not exceed 1 hour"
}

# Deny configurations allowing weak TLS versions
deny contains msg if {
    tls := input.security.tls
    version := tls.allowed_versions[_]
    version in ["1.0", "1.1"]
    msg := sprintf("TLS version %s is deprecated and insecure - use TLS 1.2 or higher", [version])
}

# Deny configurations without proper certificate management
deny contains msg if {
    cert := input.certificates[_]
    cert.self_signed == true
    input.environment == "production"
    msg := sprintf("Certificate '%s' is self-signed - use CA-signed certificates in production", [cert.name])
}

# Warn about certificates nearing expiration
warn contains msg if {
    cert := input.certificates[_]
    cert.days_until_expiry < 30
    msg := sprintf("Certificate '%s' expires in %d days - renewal required", [cert.name, cert.days_until_expiry])
}