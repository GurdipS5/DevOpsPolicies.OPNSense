# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial project setup with OPNSense Conftest policies
- MCP (Model Context Protocol) server integration
- Notion MCP server for documentation and knowledge management
- Comprehensive policy validation for firewall rules, VPN security, network security, access control, system configuration, and compliance
- Support for multiple compliance frameworks (PCI DSS, HIPAA, SOX, GDPR, ISO 27001, NIST CSF)
- Nuke build system with automated testing and packaging
- Docker Compose setup with OPA server and monitoring stack
- Regal linting for policy quality assurance
- Harbor OCI registry support for policy bundles

### Changed
- Updated README.md with comprehensive badges and MCP integration documentation

### Fixed
- N/A

### Removed
- N/A

## [1.0.0] - Initial Release

### Added
- Initial release of OPNSense Conftest Policies
- Complete policy framework for OPNSense firewall validation
- CI/CD integration with multiple build systems
- Comprehensive documentation and examples