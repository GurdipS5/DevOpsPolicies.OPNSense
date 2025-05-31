package opnsense.system.config

import rego.v1

# Deny configurations with weak or default hostnames
deny contains msg if {
    hostname := input.system.hostname
    hostname in ["opnsense", "firewall", "router", "gateway", "localhost", "pfsense"]
    msg := sprintf("Hostname '%s' is a default value - use a descriptive, unique hostname", [hostname])
}

deny contains msg if {
    hostname := input.system.hostname
    count(hostname) < 3
    msg := sprintf("Hostname '%s' is too short - minimum 3 characters required", [hostname])
}

# Deny configurations without proper domain settings
deny contains msg if {
    not input.system.domain
    input.environment in ["enterprise", "production"]
    msg := "Domain name must be configured in enterprise/production environments"
}

# Deny configurations with insecure DNS settings
deny contains msg if {
    dns := input.system.dns_servers[_]
    dns in ["8.8.8.8", "1.1.1.1", "208.67.222.222"]
    input.environment == "high_security"
    msg := sprintf("Public DNS server '%s' should not be used in high security environments", [dns])
}

deny contains msg if {
    count(input.system.dns_servers) < 2
    msg := "At least two DNS servers should be configured for redundancy"
}

# Deny configurations without proper time zone settings
deny contains msg if {
    not input.system.timezone
    msg := "System timezone must be configured"
}

# Deny configurations without NTP synchronization
deny contains msg if {
    not input.system.ntp.enabled
    msg := "NTP synchronization must be enabled for accurate time keeping"
}

deny contains msg if {
    ntp := input.system.ntp
    ntp.enabled == true
    count(ntp.servers) < 2
    msg := "At least two NTP servers should be configured for redundancy"
}

# Deny configurations with insecure NTP servers
deny contains msg if {
    ntp_server := input.system.ntp.servers[_]
    startswith(ntp_server, "pool.ntp.org")
    input.environment == "high_security"
    msg := sprintf("Public NTP server '%s' should not be used in high security environments", [ntp_server])
}

# Deny configurations without proper backup settings
deny contains msg if {
    not input.system.backup.enabled
    input.environment in ["enterprise", "production"]
    msg := "Automated backup must be enabled in enterprise/production environments"
}

deny contains msg if {
    backup := input.system.backup
    backup.enabled == true
    backup.retention_days < 30
    msg := sprintf("Backup retention of %d days is too short - minimum 30 days required", [backup.retention_days])
}

# Deny configurations without proper update settings
deny contains msg if {
    updates := input.system.updates
    updates.auto_check == false
    msg := "Automatic update checking should be enabled for security patches"
}

deny contains msg if {
    updates := input.system.updates
    updates.auto_install == true
    input.environment == "production"
    msg := "Automatic update installation should be disabled in production - use controlled updates"
}

# Deny configurations with weak console settings
deny contains msg if {
    console := input.system.console
    console.timeout == 0
    msg := "Console timeout should be set to prevent unauthorized access"
}

deny contains msg if {
    console := input.system.console
    console.timeout > 1800  # 30 minutes
    msg := sprintf("Console timeout of %d seconds is too long - maximum should be 30 minutes", [console.timeout])
}

# Deny configurations without proper MOTD
warn contains msg if {
    not input.system.motd
    msg := "Message of the Day (MOTD) should be configured to display legal notices"
}

# Deny configurations with insecure SSH settings
deny contains msg if {
    ssh := input.system.ssh
    ssh.enabled == true
    ssh.port == 22
    msg := "SSH should use a non-standard port for security"
}

deny contains msg if {
    ssh := input.system.ssh
    ssh.enabled == true
    ssh.password_auth == true
    input.environment in ["enterprise", "high_security"]
    msg := "SSH password authentication should be disabled - use key-based authentication"
}

deny contains msg if {
    ssh := input.system.ssh
    ssh.enabled == true
    ssh.root_login == true
    msg := "SSH root login should be disabled for security"
}

# Deny configurations without proper language/locale settings
deny contains msg if {
    not input.system.language
    msg := "System language must be configured"
}

# Deny configurations with weak SNMP settings
deny contains msg if {
    snmp := input.system.snmp
    snmp.enabled == true
    snmp.location == ""
    msg := "SNMP location field should be configured for asset management"
}

deny contains msg if {
    snmp := input.system.snmp
    snmp.enabled == true
    snmp.contact == ""
    msg := "SNMP contact field should be configured for support purposes"
}

# Deny configurations without proper hardware monitoring
warn contains msg if {
    not input.system.hardware_monitoring.enabled
    msg := "Hardware monitoring should be enabled to track system health"
}

# Deny configurations with insufficient disk space monitoring
deny contains msg if {
    monitoring := input.system.disk_monitoring
    monitoring.warning_threshold > 85
    msg := sprintf("Disk space warning threshold of %d%% is too high - should be 85%% or lower", [monitoring.warning_threshold])
}

deny contains msg if {
    monitoring := input.system.disk_monitoring
    monitoring.critical_threshold > 95
    msg := sprintf("Disk space critical threshold of %d%% is too high - should be 95%% or lower", [monitoring.critical_threshold])
}

# Deny configurations without proper kernel tuning for security
deny contains msg if {
    kernel := input.system.kernel
    kernel.disable_loading_kernel_modules == false
    input.environment == "high_security"
    msg := "Kernel module loading should be disabled in high security environments"
}

# Deny configurations with insecure sysctl settings
deny contains msg if {
    sysctl := input.system.sysctl_settings
    sysctl["net.inet.ip.forwarding"] == "0"
    msg := "IP forwarding must be enabled for firewall functionality"
}

deny contains msg if {
    sysctl := input.system.sysctl_settings
    sysctl["net.inet.ip.redirect"] == "1"
    msg := "IP redirects should be disabled for security"
}