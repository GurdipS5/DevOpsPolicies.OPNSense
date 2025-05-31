# OPNSense Conftest Policies

[![Open Policy Agent](https://img.shields.io/badge/OPA-Open%20Policy%20Agent-blue?logo=openpolicyagent)](https://www.openpolicyagent.org/)
[![Rego](https://img.shields.io/badge/Language-Rego-blue?logo=openpolicyagent)](https://www.openpolicyagent.org/docs/latest/policy-language/)
[![C#](https://img.shields.io/badge/Build-C%23-239120?logo=csharp)](https://docs.microsoft.com/en-us/dotnet/csharp/)
[![.NET](https://img.shields.io/badge/.NET-8.0-512BD4?logo=dotnet)](https://dotnet.microsoft.com/)
[![Nuke](https://img.shields.io/badge/Build%20System-Nuke-orange?logo=nuget)](https://nuke.build/)
[![TeamCity](https://img.shields.io/badge/CI%2FCD-TeamCity-000000?logo=teamcity)](https://www.jetbrains.com/teamcity/)
[![Docker](https://img.shields.io/badge/Container-Docker-2496ED?logo=docker)](https://www.docker.com/)
[![Harbor](https://img.shields.io/badge/Registry-Harbor-60B932?logo=harbor)](https://goharbor.io/)
[![Conftest](https://img.shields.io/badge/Testing-Conftest-326CE5?logo=kubernetes)](https://www.conftest.dev/)
[![Regal](https://img.shields.io/badge/Linting-Regal-FF6B6B?logo=styra)](https://github.com/StyraInc/regal)
[![MCP](https://img.shields.io/badge/Integration-MCP-4A90E2?logo=anthropic)](https://modelcontextprotocol.io/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

This repository contains Open Policy Agent (OPA) policies for validating OPNSense firewall configurations using Conftest. These policies help ensure your OPNSense firewall follows security best practices and compliance requirements.

## MCP Server Integration

This project includes MCP (Model Context Protocol) server integrations for enhanced automation and AI-assisted operations:

- **Notion MCP Server** - Integrates with Notion for documentation and knowledge management
  - Server: `github.com/makenotion/notion-mcp-server`
  - Configuration: [`mcp_settings.json`](mcp_settings.json)
  - Documentation: [`mcp-servers/notion-setup.md`](mcp-servers/notion-setup.md)

See the [`mcp-servers/`](mcp-servers/) directory for detailed setup instructions and capabilities.

## Overview

The policies are organized into several modules covering different aspects of firewall security:

- **[`policy/firewall_rules.rego`](policy/firewall_rules.rego)** - Validates firewall rules for security best practices
- **[`policy/interface_config.rego`](policy/interface_config.rego)** - Ensures proper interface configuration and security
- **[`policy/vpn_security.rego`](policy/vpn_security.rego)** - Validates VPN configurations for strong encryption and authentication
- **[`policy/network_security.rego`](policy/network_security.rego)** - Checks network-level security settings
- **[`policy/access_control.rego`](policy/access_control.rego)** - Validates user access controls and authentication policies
- **[`policy/system_config.rego`](policy/system_config.rego)** - Validates general system configuration including DNS, hostname, NTP, and SSH settings
- **[`policy/compliance.rego`](policy/compliance.rego)** - Ensures compliance with industry standards like PCI DSS, HIPAA, SOX, GDPR, ISO 27001, and NIST

## Installation

1. Install Conftest:
   ```bash
   # Using Homebrew (macOS/Linux)
   brew install conftest
   
   # Using Go
   go install github.com/open-policy-agent/conftest@latest
   
   # Download binary from GitHub releases
   # https://github.com/open-policy-agent/conftest/releases
   ```

2. Clone this repository:
   ```bash
   git clone <repository-url>
   cd opnsense-conftest-policies
   ```

3. (Optional) Install .NET 8.0 SDK for using the Nuke build pipeline:
   ```bash
   # Download from https://dotnet.microsoft.com/download/dotnet/8.0
   # Or use package managers:
   # Windows: winget install Microsoft.DotNet.SDK.8
   # macOS: brew install --cask dotnet
   # Linux: See https://docs.microsoft.com/en-us/dotnet/core/install/linux
   ```

## Usage

### Basic Validation

Validate your OPNSense configuration file:

```bash
conftest test your-opnsense-config.json
```

### Using Configuration File

The repository includes a [`conftest.yaml`](conftest.yaml) configuration file:

```bash
conftest test --config conftest.yaml your-opnsense-config.json
```

### Example Configurations

The [`examples/`](examples/) directory contains sample configurations:

- **[`examples/opnsense-config.json`](examples/opnsense-config.json)** - A compliant configuration example
- **[`examples/bad-config.json`](examples/bad-config.json)** - A non-compliant configuration showing common security issues

Test the examples:

```bash
# Test compliant configuration
conftest test examples/opnsense-config.json

# Test non-compliant configuration (will show violations)
conftest test examples/bad-config.json
```

### Using Nuke Build Pipeline

The project includes a comprehensive Nuke build pipeline for automated testing, validation, and packaging:

```bash
# Windows
.\build.cmd Test

# Linux/macOS
./build.sh Test

# PowerShell (cross-platform)
pwsh build.ps1 Test
```

Available build targets:

- **`Clean`** - Clean output directories
- **`Restore`** - Validate project structure
- **`CheckTools`** - Verify required tools (conftest, OPA)
- **`ValidatePolicies`** - Validate OPA policy syntax and formatting
- **`Validate`** - Test policies against example configurations
- **`Test`** - Run all validation tests
- **`Lint`** - Run Regal linting on policy files
- **`CreateBundle`** - Create OPA bundles for distribution
- **`Package`** - Create distribution packages
- **`PushToHarbor`** - Push OPA bundles to Harbor registry as OCI artifacts
- **`Publish`** - Publish artifacts (customize for your needs)
- **`CI`** - Complete CI pipeline (test + package)
- **`Release`** - Full release pipeline

Examples:
```bash
# Run all tests
./build.sh Test

# Create a package with custom version
./build.sh Package --version 2.1.0

# Run CI pipeline
./build.sh CI

# Create OPA bundle
./build.sh CreateBundle --version 2.1.0

# Run Regal linting
./build.sh Lint

# Push bundle to Harbor registry
./build.sh PushToHarbor --version 2.1.0 \
  --harbor-registry harbor.company.com \
  --harbor-project opnsense-policies \
  --harbor-username myuser \
  --harbor-password mypassword

# Skip conftest check (useful in environments where conftest isn't available)
./build.sh Test --skip-conftest-check

# Skip Regal linting
./build.sh Test --skip-regal
```

### Regal Linting

The project includes [Regal](https://github.com/StyraInc/regal) linting for policy quality assurance:

```bash
# Install Regal
go install github.com/StyraInc/regal@latest

# Run linting
./build.sh Lint

# Skip linting if needed
./build.sh Test --skip-regal
```

Regal checks for:
- **Policy best practices** and style guidelines
- **Performance optimizations** and anti-patterns
- **Security issues** in policy logic
- **Code quality** and maintainability

### Harbor OCI Registry

Push OPA bundles to Harbor registry as OCI artifacts:

```bash
# Install ORAS CLI
# Download from: https://oras.land/

# Push to Harbor
./build.sh PushToHarbor \
  --version 1.0.0 \
  --harbor-registry harbor.company.com \
  --harbor-project opnsense-policies \
  --harbor-username $HARBOR_USERNAME \
  --harbor-password $HARBOR_PASSWORD

# The bundle will be available at:
# harbor.company.com/opnsense-policies/opnsense-policies:1.0.0
# harbor.company.com/opnsense-policies/opnsense-policies:latest
```

Benefits of Harbor OCI storage:
- **Version management** with semantic versioning
- **Access control** and authentication
- **Vulnerability scanning** of policy bundles
- **Replication** across multiple registries
- **Integration** with CI/CD pipelines

### OPA Bundle Support

The project supports creating OPA bundles for distribution and use with OPA servers:

```bash
# Create OPA bundle
./build.sh CreateBundle

# The bundle will be created in artifacts/ directory
# - opnsense-policies-bundle-{version}.tar.gz
# - opnsense-policies-bundle-{version}.sha256
```

### Running OPA Server

Use the included Docker Compose setup to run an OPA server with the policies:

```bash
# Build the bundle first
./build.sh CreateBundle

# Start OPA server with monitoring stack
docker-compose up -d

# Test the OPA server
curl http://localhost:8181/v1/data/opnsense/firewall/rules

# Access bundle server
curl http://localhost:8080/bundles/

# Access Grafana dashboard (admin/admin)
open http://localhost:3000

# Access Prometheus
open http://localhost:9090
```

The OPA server configuration includes:
- **Bundle serving** from local files or HTTP
- **Decision logging** for audit trails
- **Metrics collection** with Prometheus
- **Health checks** and monitoring
- **Grafana dashboards** for visualization

### Using OPA Bundles with External Systems

The generated OPA bundles can be used with various systems:

```bash
# Load bundle into OPA server
curl -X PUT http://localhost:8181/v1/policies/opnsense \
  --data-binary @artifacts/opnsense-policies-bundle-1.0.0.tar.gz

# Query policies via OPA API
curl -X POST http://localhost:8181/v1/data/opnsense/firewall/rules \
  -H "Content-Type: application/json" \
  -d @your-config.json

# Use with Envoy External Authorization
# Configure Envoy to use OPA for policy decisions

# Use with Kubernetes Admission Controller
# Deploy OPA Gatekeeper with the bundle
./build.sh Test --skip-conftest-check
```

## Policy Categories

### Firewall Rules ([`policy/firewall_rules.rego`](policy/firewall_rules.rego))

- Prevents overly permissive rules (any-to-any)
- Ensures logging for security-critical ports
- Blocks insecure protocols
- Requires rule descriptions
- Validates administrative access restrictions
- Enforces default deny policy

### Interface Configuration ([`policy/interface_config.rego`](policy/interface_config.rego))

- Ensures WAN interfaces have firewall enabled
- Validates VPN encryption standards
- Requires VLAN segmentation in enterprise environments
- Prevents default passwords
- Validates MTU settings
- Ensures monitoring is enabled

### VPN Security ([`policy/vpn_security.rego`](policy/vpn_security.rego))

- Enforces strong encryption algorithms
- Requires proper authentication methods
- Validates Perfect Forward Secrecy (PFS)
- Ensures strong Diffie-Hellman groups
- Requires certificate validation for SSL VPNs
- Validates session timeout limits
- Enforces multi-factor authentication

### Network Security ([`policy/network_security.rego`](policy/network_security.rego))

- Requires IDS/IPS to be enabled
- Validates DNS configuration
- Ensures secure service configurations
- Validates NTP security
- Checks SNMP security settings
- Enforces proper logging
- Validates TLS configurations

### Access Control ([`policy/access_control.rego`](policy/access_control.rego))

- Enforces strong password policies
- Requires MFA for administrative users
- Validates account lockout policies
- Ensures privilege separation
- Requires audit logging
- Validates role-based access control
- Enforces API security

### System Configuration ([`policy/system_config.rego`](policy/system_config.rego))

- Validates hostname and domain settings
- Ensures proper DNS configuration
- Requires NTP synchronization with secure servers
- Validates backup and update policies
- Enforces secure SSH configuration
- Checks console timeout settings
- Validates SNMP security settings
- Ensures proper system monitoring
- Validates kernel security settings

### Compliance ([`policy/compliance.rego`](policy/compliance.rego))

- **PCI DSS** - Payment card industry requirements
- **HIPAA** - Healthcare data protection
- **SOX** - Financial reporting controls
- **GDPR** - European data protection
- **ISO 27001** - Information security management
- **NIST CSF** - Cybersecurity framework
- **CIS Controls** - Security best practices
- Industry-specific requirements (financial, healthcare, government)
- Regional compliance (EU, US)

## Configuration Schema

Your OPNSense configuration should follow this JSON structure:

```json
{
  "environment": "enterprise|production|high_security",
  "compliance_requirements": ["pci_dss", "hipaa", "sox", "gdpr", "iso_27001", "nist_csf", "cis_controls"],
  "industry": "financial_services|healthcare|government",
  "region": "us|eu",
  "system": {
    "hostname": "unique-hostname",
    "domain": "company.com",
    "timezone": "UTC",
    "dns_servers": [...],
    "ntp": {...},
    "backup": {...},
    "ssh": {...}
  },
  "firewall": {
    "default_policy": "deny",
    "rules": [...]
  },
  "interfaces": [...],
  "vpn": {
    "configurations": [...]
  },
  "security": {...},
  "network": {...},
  "services": {...},
  "logging": {...},
  "users": [...],
  "roles": [...],
  "certificates": [...],
  "documentation": {...}
}
```

## Environment Types

The policies support different environment types with varying security requirements:

- **`enterprise`** - Standard enterprise security requirements
- **`production`** - Production environment with enhanced security
- **`high_security`** - Maximum security requirements for sensitive environments

## Customization

### Adding Custom Policies

1. Create a new `.rego` file in the [`policy/`](policy/) directory
2. Use the package naming convention: `package opnsense.your_module`
3. Add your custom rules using [`deny`](policy/firewall_rules.rego:5) and [`warn`](policy/firewall_rules.rego:55) rules
4. Update [`conftest.yaml`](conftest.yaml) to include your new namespace

### Modifying Existing Policies

Edit the relevant `.rego` files to adjust thresholds, add new checks, or modify existing rules. Each policy file is well-commented to explain the security rationale.

## CI/CD Integration

The Nuke build pipeline provides comprehensive automation capabilities for any CI/CD system:

### Core Build Pipeline

```bash
# Install dependencies and verify tools
./build.sh CheckTools

# Run complete test suite (includes Regal linting)
./build.sh Test

# Create OPA bundles
./build.sh CreateBundle --version $BUILD_NUMBER

# Push to Harbor registry
./build.sh PushToHarbor \
  --harbor-registry harbor.company.com \
  --harbor-project opnsense-policies \
  --harbor-username $HARBOR_USERNAME \
  --harbor-password $HARBOR_PASSWORD

# Full CI pipeline (test + package)
./build.sh CI
```

### GitLab CI Example

```yaml
stages:
  - test
  - package
  - deploy

variables:
  DOTNET_VERSION: "8.0"

test_policies:
  stage: test
  image: mcr.microsoft.com/dotnet/sdk:${DOTNET_VERSION}
  before_script:
    - apt-get update && apt-get install -y wget tar curl
    # Install tools
    - wget https://github.com/open-policy-agent/conftest/releases/latest/download/conftest_Linux_x86_64.tar.gz
    - tar xzf conftest_Linux_x86_64.tar.gz && mv conftest /usr/local/bin/
    - curl -L -o opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64_static
    - chmod 755 opa && mv opa /usr/local/bin/
    - curl -L -o regal https://github.com/StyraInc/regal/releases/latest/download/regal_Linux_x86_64
    - chmod 755 regal && mv regal /usr/local/bin/
  script:
    - chmod +x ./build.sh
    - ./build.sh Test
  artifacts:
    reports:
      junit: output/regal-report.json
    when: always

package_policies:
  stage: package
  image: mcr.microsoft.com/dotnet/sdk:${DOTNET_VERSION}
  script:
    - chmod +x ./build.sh
    - ./build.sh CreateBundle --version $CI_PIPELINE_ID
  artifacts:
    paths:
      - artifacts/
  only:
    - main

deploy_to_harbor:
  stage: deploy
  image: mcr.microsoft.com/dotnet/sdk:${DOTNET_VERSION}
  before_script:
    - curl -LO https://github.com/oras-project/oras/releases/latest/download/oras_0.16.0_linux_amd64.tar.gz
    - tar -zxf oras_0.16.0_*.tar.gz && mv oras /usr/local/bin/
  script:
    - chmod +x ./build.sh
    - ./build.sh PushToHarbor --version $CI_PIPELINE_ID
  only:
    - main
  when: manual

### Azure DevOps Example

```yaml
trigger:
  - main

pool:
  vmImage: 'ubuntu-latest'

variables:
  buildVersion: '$(Build.BuildNumber)'

stages:
- stage: Test
  jobs:
  - job: PolicyValidation
    steps:
    - task: UseDotNet@2
      inputs:
        version: '8.0.x'
    - script: |
        chmod +x ./build.sh
        ./build.sh CheckTools
        ./build.sh Test
      displayName: 'Run Policy Tests'

- stage: Package
  dependsOn: Test
  jobs:
  - job: CreateBundle
    steps:
    - script: |
        chmod +x ./build.sh
        ./build.sh CreateBundle --version $(buildVersion)
      displayName: 'Create OPA Bundle'
    - publish: artifacts/
      artifact: PolicyBundles
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add or modify policies
4. Test your changes with the example configurations
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Security Best Practices

These policies enforce industry-standard security practices including:

- **Defense in Depth** - Multiple layers of security controls
- **Principle of Least Privilege** - Minimal necessary access rights
- **Zero Trust** - Never trust, always verify
- **Compliance** - Adherence to security frameworks and regulations
- **Monitoring** - Comprehensive logging and alerting

## Support

For questions or issues:

1. Check the example configurations
2. Review the policy documentation
3. Open an issue in the repository
4. Consult the OPNSense and Conftest documentation

## References

- [Open Policy Agent (OPA)](https://www.openpolicyagent.org/)
- [Conftest](https://www.conftest.dev/)
- [OPNSense Documentation](https://docs.opnsense.org/)
- [Rego Language Reference](https://www.openpolicyagent.org/docs/latest/policy-language/)