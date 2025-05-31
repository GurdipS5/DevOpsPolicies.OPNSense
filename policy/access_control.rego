package opnsense.access.control

import rego.v1

# Deny configurations without proper user authentication
deny contains msg if {
    user := input.users[_]
    not user.password_policy_compliant
    msg := sprintf("User '%s' password does not meet policy requirements", [user.username])
}

# Deny users with administrative privileges without MFA
deny contains msg if {
    user := input.users[_]
    user.privileges[_] == "admin"
    not user.multi_factor_auth
    msg := sprintf("Administrative user '%s' must have multi-factor authentication enabled", [user.username])
}

# Deny default or weak usernames
deny contains msg if {
    user := input.users[_]
    user.username in ["admin", "root", "administrator", "user", "guest"]
    msg := sprintf("Default username '%s' should be changed for security", [user.username])
}

# Deny users without proper session management
deny contains msg if {
    user := input.users[_]
    user.session_timeout > 1800  # 30 minutes
    user.privileges[_] == "admin"
    msg := sprintf("Administrative user '%s' session timeout should not exceed 30 minutes", [user.username])
}

# Deny configurations without account lockout policies
deny contains msg if {
    not input.security.account_lockout.enabled
    msg := "Account lockout policy must be enabled to prevent brute force attacks"
}

deny contains msg if {
    lockout := input.security.account_lockout
    lockout.enabled == true
    lockout.max_attempts > 5
    msg := sprintf("Account lockout threshold of %d attempts is too high - maximum should be 5", [lockout.max_attempts])
}

# Deny configurations without proper password policies
deny contains msg if {
    policy := input.security.password_policy
    policy.min_length < 12
    msg := sprintf("Password minimum length of %d is too short - should be at least 12 characters", [policy.min_length])
}

deny contains msg if {
    policy := input.security.password_policy
    not policy.require_complexity
    msg := "Password policy must require complexity (uppercase, lowercase, numbers, symbols)"
}

deny contains msg if {
    policy := input.security.password_policy
    policy.max_age > 90
    msg := sprintf("Password maximum age of %d days is too long - should not exceed 90 days", [policy.max_age])
}

# Deny configurations without proper privilege separation
deny contains msg if {
    user := input.users[_]
    count(user.privileges) > 3
    msg := sprintf("User '%s' has too many privileges - implement principle of least privilege", [user.username])
}

# Deny configurations allowing concurrent sessions without limits
deny contains msg if {
    user := input.users[_]
    user.max_concurrent_sessions == 0  # unlimited
    user.privileges[_] == "admin"
    msg := sprintf("Administrative user '%s' should have limited concurrent sessions", [user.username])
}

# Deny configurations without proper audit logging for privileged actions
deny contains msg if {
    not input.security.audit_logging.privileged_actions
    msg := "Audit logging for privileged actions must be enabled"
}

# Deny configurations without proper role-based access control
deny contains msg if {
    role := input.roles[_]
    not role.description
    msg := sprintf("Role '%s' must have a clear description of its purpose", [role.name])
}

# Deny overly permissive roles
deny contains msg if {
    role := input.roles[_]
    "all" in role.permissions
    msg := sprintf("Role '%s' grants all permissions - implement specific permissions instead", [role.name])
}

# Deny configurations without regular access reviews
warn contains msg if {
    not input.security.access_review.enabled
    msg := "Regular access reviews should be enabled to maintain security"
}

# Deny configurations allowing password reuse
deny contains msg if {
    policy := input.security.password_policy
    policy.history_count < 12
    msg := "Password history should prevent reuse of last 12 passwords"
}

# Deny configurations without proper certificate-based authentication for critical access
deny contains msg if {
    user := input.users[_]
    user.privileges[_] == "admin"
    user.access_method == "password_only"
    input.environment == "high_security"
    msg := sprintf("Administrative user '%s' should use certificate-based authentication in high security environments", [user.username])
}

# Deny configurations with inactive user accounts
deny contains msg if {
    user := input.users[_]
    user.last_login_days > 90
    user.enabled == true
    msg := sprintf("User '%s' has not logged in for %d days - account should be disabled", [user.username, user.last_login_days])
}

# Deny configurations without proper API access controls
deny contains msg if {
    api := input.api_access
    api.enabled == true
    not api.authentication_required
    msg := "API access must require authentication"
}

deny contains msg if {
    api := input.api_access
    api.enabled == true
    not api.rate_limiting
    msg := "API access must implement rate limiting to prevent abuse"
}