package opnsense.interfaces

import rego.v1

# Deny interfaces without proper security configurations
deny contains msg if {
    interface := input.interfaces[_]
    interface.type == "wan"
    not interface.firewall_enabled
    msg := sprintf("WAN interface '%s' must have firewall enabled", [interface.name])
}

# Deny interfaces with weak encryption
deny contains msg if {
    interface := input.interfaces[_]
    interface.type == "vpn"
    interface.encryption in ["des", "3des", "md5"]
    msg := sprintf("VPN interface '%s' uses weak encryption '%s'", [interface.name, interface.encryption])
}

# Deny interfaces without proper VLAN configuration in enterprise environments
deny contains msg if {
    interface := input.interfaces[_]
    interface.type == "lan"
    not interface.vlan_id
    input.environment == "enterprise"
    msg := sprintf("LAN interface '%s' should use VLAN segmentation in enterprise environments", [interface.name])
}

# Deny interfaces with default passwords
deny contains msg if {
    interface := input.interfaces[_]
    interface.authentication.password in ["admin", "password", "123456", "default"]
    msg := sprintf("Interface '%s' uses a default or weak password", [interface.name])
}

# Deny interfaces without proper MTU settings
deny contains msg if {
    interface := input.interfaces[_]
    interface.type == "wan"
    interface.mtu > 1500
    not interface.jumbo_frames_enabled
    msg := sprintf("WAN interface '%s' has MTU > 1500 but jumbo frames not properly configured", [interface.name])
}

# Warn about interfaces without monitoring
warn contains msg if {
    interface := input.interfaces[_]
    not interface.monitoring_enabled
    msg := sprintf("Interface '%s' should have monitoring enabled for better visibility", [interface.name])
}

# Deny interfaces with insecure protocols enabled
deny contains msg if {
    interface := input.interfaces[_]
    protocol := interface.enabled_protocols[_]
    protocol in ["telnet", "rsh", "ftp"]
    msg := sprintf("Interface '%s' has insecure protocol '%s' enabled", [interface.name, protocol])
}

# Ensure critical interfaces have redundancy
deny contains msg if {
    interface := input.interfaces[_]
    interface.critical == true
    not interface.backup_interface
    msg := sprintf("Critical interface '%s' must have a backup interface configured", [interface.name])
}

# Deny interfaces without proper access control
deny contains msg if {
    interface := input.interfaces[_]
    interface.type in ["wan", "dmz"]
    not interface.access_control_list
    msg := sprintf("Interface '%s' of type '%s' must have access control list configured", [interface.name, interface.type])
}