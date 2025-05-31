# Setup Summary: Versioning and Changelog Automation

This document summarizes the comprehensive versioning and changelog automation setup implemented for the OPNSense Conftest Policies project.

## 🎯 What Was Accomplished

### 1. Nerdbank.GitVersioning (nbgv) Integration
- **Installed**: `nerdbank-gitversioning` npm package
- **Configured**: [`version.json`](version.json) with semantic versioning rules
- **Features**:
  - Automatic version calculation based on git history
  - Semantic versioning with build height
  - Public release detection on main/master branches
  - Pre-release versions with `alpha` suffix on feature branches

**Current Version**: `1.0.1` (automatically calculated)

### 2. Automated Changelog Management
- **Installed**: `auto-changelog` and `czg` npm packages
- **Created**: [`CHANGELOG.md`](CHANGELOG.md) with Keep a Changelog format
- **Features**:
  - Conventional commit parsing
  - Automatic section categorization (Added, Fixed, Changed)
  - Integration with build pipeline for automated updates

### 3. Enhanced Build System
- **Updated**: [`build/Build.cs`](build/Build.cs) with versioning integration
- **Added**: Version management methods and changelog automation
- **Features**:
  - Automatic version detection using nbgv
  - Conventional commit parsing for changelog updates
  - Git integration for automated commits and pushes
  - TeamCity-specific build targets

### 4. TeamCity Integration
- **Created**: [`teamcity-build.ps1`](teamcity-build.ps1) - PowerShell build script
- **Created**: [`teamcity-config-example.xml`](teamcity-config-example.xml) - Complete TeamCity configuration
- **Features**:
  - Automatic build number synchronization
  - Environment variable integration
  - Conditional changelog updates on main/master branches
  - Harbor OCI artifact publishing

### 5. Documentation Updates
- **Updated**: [`README.md`](README.md) with comprehensive versioning documentation
- **Added**: Sections for version management, changelog automation, and TeamCity integration
- **Included**: Usage examples and configuration details

## 🚀 Key Features

### Automatic Version Management
```bash
# Get current version
npx nbgv get-version --variable NuGetPackageVersion
# Output: 1.0.1

# Get detailed version info
npx nbgv get-version --format json
```

### Changelog Automation
```bash
# Generate changelog from git history
npx auto-changelog --output CHANGELOG.md --template keepachangelog

# Use conventional commits
npx czg

# Build system integration (TeamCity)
./build.ps1 UpdateChangelog --commit-message "feat: add new feature"
```

### TeamCity Build Pipeline
```powershell
# Complete CI build with changelog updates
./teamcity-build.ps1 -Target CI -UpdateChangelog

# Environment variables automatically used:
# - BUILD_VCS_BRANCH
# - BUILD_VCS_COMMIT_MESSAGE
# - HARBOR_REGISTRY, HARBOR_PROJECT
```

## 📁 Files Created/Modified

### New Files
- [`version.json`](version.json) - nbgv configuration
- [`CHANGELOG.md`](CHANGELOG.md) - Project changelog
- [`teamcity-build.ps1`](teamcity-build.ps1) - TeamCity build script
- [`teamcity-config-example.xml`](teamcity-config-example.xml) - TeamCity configuration
- [`SETUP_SUMMARY.md`](SETUP_SUMMARY.md) - This summary document

### Modified Files
- [`package.json`](package.json) - Added versioning and changelog dependencies
- [`build/Build.cs`](build/Build.cs) - Enhanced with versioning and changelog automation
- [`README.md`](README.md) - Added comprehensive versioning documentation
- [`global.json`](global.json) - Updated to .NET 9.0
- [`.gitignore`](.gitignore) - Added Node.js and build artifact exclusions

## 🔧 Build Targets Added

### New Nuke Build Targets
- **`UpdateChangelog`** - Updates changelog with conventional commit messages
- **`CommitAndPushChanges`** - Commits and pushes changelog changes (CI only)

### Enhanced Existing Targets
- All targets now use automatic versioning from nbgv
- Version parameter is optional (falls back to nbgv)
- Build version is displayed during restore

## 🏗️ TeamCity Configuration

### Build Features
- **Automatic Version Detection**: Uses nbgv for semantic versioning
- **Build Number Sync**: TeamCity build number matches semantic version
- **Conditional Changelog Updates**: Only on main/master branches
- **Git Integration**: Automated commit and push of changelog changes
- **Harbor Publishing**: OCI artifact publishing with semantic versions

### Environment Variables
```bash
BUILD_VCS_BRANCH=refs/heads/main
BUILD_VCS_COMMIT_MESSAGE="feat: add new feature"
HARBOR_REGISTRY=harbor.company.com
HARBOR_PROJECT=opnsense-policies
HARBOR_USERNAME=myuser
HARBOR_PASSWORD=mypassword
```

## 📋 Usage Examples

### Development Workflow
```bash
# 1. Make changes and commit with conventional format
git commit -m "feat: add new firewall rule validation"

# 2. Check version (automatically incremented)
npx nbgv get-version --variable NuGetPackageVersion

# 3. Build and test
./build.ps1 Test

# 4. Create package (version automatic)
./build.ps1 Package
```

### TeamCity Workflow
```bash
# 1. TeamCity detects commit on main branch
# 2. Runs: ./teamcity-build.ps1 -Target CI -UpdateChangelog
# 3. Automatically:
#    - Detects version using nbgv
#    - Updates build number
#    - Updates changelog with commit message
#    - Commits and pushes changelog
#    - Builds and packages with semantic version
#    - Publishes to Harbor registry
```

## ✅ Verification

### Test Version Management
```bash
npx nbgv get-version --format json
# Should return detailed version information
```

### Test Changelog Generation
```bash
npx auto-changelog --output CHANGELOG.md --template keepachangelog
# Should update CHANGELOG.md with git history
```

### Test Conventional Commits
```bash
npx czg
# Should provide interactive conventional commit interface
```

## 🎉 Benefits Achieved

1. **Automated Versioning**: No manual version management required
2. **Consistent Changelog**: Automatic updates based on conventional commits
3. **CI/CD Integration**: Seamless TeamCity integration with automated workflows
4. **Semantic Versioning**: Proper SemVer compliance with automatic incrementing
5. **Documentation**: Comprehensive documentation and examples
6. **Harbor Integration**: Automatic OCI artifact publishing with semantic versions

## 🔮 Next Steps

1. **Set up TeamCity**: Import the provided configuration
2. **Configure Harbor**: Set up registry credentials
3. **Train Team**: Educate on conventional commit format
4. **Monitor**: Verify automated workflows in CI/CD pipeline

---

**Setup completed successfully!** 🚀

The project now has comprehensive versioning and changelog automation that integrates seamlessly with TeamCity and follows industry best practices.