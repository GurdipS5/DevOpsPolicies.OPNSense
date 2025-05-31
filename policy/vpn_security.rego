package opnsense.vpn.security

import rego.v1

# Deny VPN configurations with weak encryption
deny contains msg if {
    vpn := input.vpn.configurations[_]
    vpn.encryption_algorithm in ["des", "3des", "rc4"]
    msg := sprintf("VPN '%s' uses weak encryption algorithm '%s'", [vpn.name, vpn.encryption_algorithm])
}

# Deny VPN configurations with weak authentication
deny contains msg if {
    vpn := input.vpn.configurations[_]
    vpn.authentication_method in ["psk", "none"]
    vpn.type != "site-to-site"
    msg := sprintf("VPN '%s' uses weak authentication method '%s' for remote access", [vpn.name, vpn.authentication_method])
}

# Deny VPN configurations without perfect forward secrecy
deny contains msg if {
    vpn := input.vpn.configurations[_]
    not vpn.perfect_forward_secrecy
    msg := sprintf("VPN '%s' must enable Perfect Forward Secrecy (PFS)", [vpn.name])
}

# Deny VPN configurations with weak DH groups
deny contains msg if {
    vpn := input.vpn.configurations[_]
    vpn.dh_group < 14
    msg := sprintf("VPN '%s' uses weak Diffie-Hellman group %d - use group 14 or higher", [vpn.name, vpn.dh_group])
}

# Deny VPN configurations without proper certificate validation
deny contains msg if {
    vpn := input.vpn.configurations[_]
    vpn.type == "ssl"
    not vpn.certificate_validation
    msg := sprintf("SSL VPN '%s' must have certificate validation enabled", [vpn.name])
}

# Deny VPN configurations with overly long session timeouts
deny contains msg if {
    vpn := input.vpn.configurations[_]
    vpn.session_timeout > 28800  # 8 hours
    msg := sprintf("VPN '%s' session timeout of %d seconds is too long - maximum should be 8 hours", [vpn.name, vpn.session_timeout])
}

# Deny VPN configurations without logging
deny contains msg if {
    vpn := input.vpn.configurations[_]
    not vpn.logging_enabled
    msg := sprintf("VPN '%s' must have logging enabled for security monitoring", [vpn.name])
}

# Deny VPN configurations allowing split tunneling for sensitive environments
deny contains msg if {
    vpn := input.vpn.configurations[_]
    vpn.split_tunneling == true
    input.environment == "high_security"
    msg := sprintf("VPN '%s' should not allow split tunneling in high security environments", [vpn.name])
}

# Deny VPN configurations without multi-factor authentication
deny contains msg if {
    vpn := input.vpn.configurations[_]
    vpn.type == "ssl"
    not vpn.multi_factor_auth
    input.environment in ["enterprise", "high_security"]
    msg := sprintf("SSL VPN '%s' must require multi-factor authentication in enterprise environments", [vpn.name])
}

# Deny VPN configurations with weak ciphers
deny contains msg if {
    vpn := input.vpn.configurations[_]
    cipher := vpn.allowed_ciphers[_]
    cipher in ["rc4", "des", "3des", "null"]
    msg := sprintf("VPN '%s' allows weak cipher '%s'", [vpn.name, cipher])
}

# Warn about VPN configurations without dead peer detection
warn contains msg if {
    vpn := input.vpn.configurations[_]
    vpn.type == "ipsec"
    not vpn.dead_peer_detection
    msg := sprintf("IPSec VPN '%s' should enable Dead Peer Detection (DPD)", [vpn.name])
}

# Deny VPN configurations with default or weak pre-shared keys
deny contains msg if {
    vpn := input.vpn.configurations[_]
    vpn.authentication_method == "psk"
    count(vpn.pre_shared_key) < 20
    msg := sprintf("VPN '%s' pre-shared key is too short - minimum 20 characters required", [vpn.name])
}

# Deny VPN configurations without IP address restrictions
deny contains msg if {
    vpn := input.vpn.configurations[_]
    vpn.type == "ssl"
    not vpn.allowed_ip_ranges
    input.environment in ["enterprise", "high_security"]
    msg := sprintf("SSL VPN '%s' should restrict access to specific IP ranges", [vpn.name])
}