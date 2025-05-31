package opnsense.compliance

import rego.v1

# Deny configurations that don't meet PCI DSS requirements
deny contains msg if {
    input.compliance_requirements[_] == "pci_dss"
    not input.security.encryption_at_rest
    msg := "PCI DSS requires encryption at rest for sensitive data"
}

deny contains msg if {
    input.compliance_requirements[_] == "pci_dss"
    not input.logging.centralized_logging
    msg := "PCI DSS requires centralized logging for audit trails"
}

deny contains msg if {
    input.compliance_requirements[_] == "pci_dss"
    input.logging.retention_days < 365
    msg := "PCI DSS requires log retention of at least 1 year"
}

# Deny configurations that don't meet HIPAA requirements
deny contains msg if {
    input.compliance_requirements[_] == "hipaa"
    not input.security.data_encryption
    msg := "HIPAA requires encryption of electronic protected health information"
}

deny contains msg if {
    input.compliance_requirements[_] == "hipaa"
    not input.security.access_logging
    msg := "HIPAA requires logging of all access to protected health information"
}

deny contains msg if {
    input.compliance_requirements[_] == "hipaa"
    not input.security.automatic_logoff
    msg := "HIPAA requires automatic logoff for workstations"
}

# Deny configurations that don't meet SOX requirements
deny contains msg if {
    input.compliance_requirements[_] == "sox"
    not input.security.change_management
    msg := "SOX requires documented change management processes"
}

deny contains msg if {
    input.compliance_requirements[_] == "sox"
    input.logging.retention_days < 2555  # 7 years
    msg := "SOX requires log retention of at least 7 years"
}

# Deny configurations that don't meet GDPR requirements
deny contains msg if {
    input.compliance_requirements[_] == "gdpr"
    not input.security.data_protection_impact_assessment
    msg := "GDPR may require Data Protection Impact Assessment for high-risk processing"
}

deny contains msg if {
    input.compliance_requirements[_] == "gdpr"
    not input.security.breach_notification_process
    msg := "GDPR requires breach notification processes within 72 hours"
}

# Deny configurations that don't meet ISO 27001 requirements
deny contains msg if {
    input.compliance_requirements[_] == "iso_27001"
    not input.security.information_security_policy
    msg := "ISO 27001 requires documented information security policy"
}

deny contains msg if {
    input.compliance_requirements[_] == "iso_27001"
    not input.security.risk_assessment_process
    msg := "ISO 27001 requires regular risk assessment processes"
}

deny contains msg if {
    input.compliance_requirements[_] == "iso_27001"
    not input.security.incident_response_plan
    msg := "ISO 27001 requires documented incident response plan"
}

# Deny configurations that don't meet NIST requirements
deny contains msg if {
    input.compliance_requirements[_] == "nist_csf"
    not input.security.asset_inventory
    msg := "NIST CSF requires comprehensive asset inventory"
}

deny contains msg if {
    input.compliance_requirements[_] == "nist_csf"
    not input.security.vulnerability_management
    msg := "NIST CSF requires vulnerability management program"
}

# Deny configurations that don't meet CIS Controls
deny contains msg if {
    input.compliance_requirements[_] == "cis_controls"
    not input.security.authorized_software_inventory
    msg := "CIS Controls require inventory of authorized software"
}

deny contains msg if {
    input.compliance_requirements[_] == "cis_controls"
    not input.security.secure_configuration_management
    msg := "CIS Controls require secure configuration management"
}

# General compliance checks
deny contains msg if {
    count(input.compliance_requirements) > 0
    not input.security.security_awareness_training
    msg := "Compliance frameworks require security awareness training"
}

deny contains msg if {
    count(input.compliance_requirements) > 0
    not input.security.regular_security_assessments
    msg := "Compliance frameworks require regular security assessments"
}

deny contains msg if {
    count(input.compliance_requirements) > 0
    not input.security.vendor_risk_management
    msg := "Compliance frameworks require vendor risk management"
}

# Warn about missing compliance documentation
warn contains msg if {
    count(input.compliance_requirements) > 0
    not input.documentation.compliance_documentation
    msg := "Compliance frameworks typically require comprehensive documentation"
}

warn contains msg if {
    count(input.compliance_requirements) > 0
    not input.security.business_continuity_plan
    msg := "Most compliance frameworks recommend business continuity planning"
}

# Industry-specific compliance checks
deny contains msg if {
    input.industry == "financial_services"
    not input.security.data_loss_prevention
    msg := "Financial services require data loss prevention controls"
}

deny contains msg if {
    input.industry == "healthcare"
    not input.security.patient_data_encryption
    msg := "Healthcare industry requires encryption of patient data"
}

deny contains msg if {
    input.industry == "government"
    not input.security.fips_140_2_compliance
    msg := "Government systems may require FIPS 140-2 compliant encryption"
}

# Regional compliance requirements
deny contains msg if {
    input.region == "eu"
    not input.security.data_residency_controls
    msg := "EU operations require data residency controls for GDPR compliance"
}

deny contains msg if {
    input.region == "us"
    input.industry == "healthcare"
    not input.security.hipaa_compliance
    msg := "US healthcare organizations must comply with HIPAA"
}