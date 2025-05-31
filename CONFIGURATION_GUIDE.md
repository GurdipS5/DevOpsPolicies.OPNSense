# Configuration Guide: Changelog and Commit Management

## 📋 What You Need for Your Requirements

Based on your setup, here's what each configuration file provides:

### ✅ **Required Files (Already Created)**

#### 1. **`.auto-changelog`** - Changelog Generation with Emojis
- **Purpose**: Configures automatic changelog generation with emoji support
- **Features**: 
  - ✨ Features (feat)
  - 🐛 Bug Fixes (fix)
  - 📚 Documentation (docs)
  - 💎 Styles (style)
  - 📦 Refactoring (refactor)
  - 🚀 Performance (perf)
  - 🚨 Tests (test)
  - 🛠 Build System (build)
  - ⚙️ CI (ci)
  - ♻️ Chores (chore)
  - 🗑 Reverts (revert)

#### 2. **`.commitlintrc.json`** - Commit Message Validation
- **Purpose**: Ensures consistent commit message format
- **Features**:
  - Validates conventional commit format
  - Provides interactive prompts with emojis
  - Enforces commit message rules
  - Integrates with `czg` for better UX

### 🚀 **Usage Examples**

#### Generate Changelog with Emojis
```bash
# Using npm script
npm run changelog

# Direct command
npx auto-changelog --output CHANGELOG.md

# Result: Changelog with emoji categories like:
# ✨ Features
# 🐛 Bug Fixes
# 📚 Documentation
```

#### Interactive Commit with Emojis
```bash
# Using npm script
npm run commit

# Direct command
npx czg

# Result: Interactive prompt with emoji options
```

#### Validate Commit Messages
```bash
# Using npm script (for git hooks)
npm run lint:commit

# Direct command
npx commitlint --edit
```

#### Get Current Version
```bash
# Using npm script
npm run version

# Direct command
npx nbgv get-version --variable NuGetPackageVersion
```

### 🎯 **What Each Tool Does**

| Tool | Purpose | Emojis | Configuration File |
|------|---------|--------|-------------------|
| **auto-changelog** | Generates changelog from git history | ✅ Yes | `.auto-changelog` |
| **czg** | Interactive conventional commits | ✅ Yes | `.commitlintrc.json` |
| **commitlint** | Validates commit messages | ✅ Yes | `.commitlintrc.json` |
| **nbgv** | Automatic versioning | ❌ No | `version.json` |

### 📁 **File Summary**

#### **`.auto-changelog`**
- Configures changelog generation
- Maps commit types to emoji sections
- Sets output format and templates
- **Result**: Beautiful changelogs with emoji categories

#### **`.commitlintrc.json`**
- Validates commit message format
- Provides interactive prompts with emojis
- Enforces conventional commit rules
- **Result**: Consistent, emoji-rich commit messages

### 🔧 **Integration with Build System**

The build system (`Build.cs`) automatically:
1. **Detects version** using nbgv
2. **Parses commit messages** for changelog updates
3. **Generates changelog entries** with appropriate emojis
4. **Commits and pushes** changelog changes (in CI)

### ✨ **Example Workflow**

```bash
# 1. Make changes to your code
git add .

# 2. Create conventional commit with emojis
npm run commit
# Choose: ✨ feat
# Scope: firewall
# Description: add new rule validation
# Result: "feat(firewall): add new rule validation"

# 3. Generate updated changelog
npm run changelog
# Result: CHANGELOG.md updated with:
# ## [Unreleased]
# ### ✨ Features
# - add new rule validation

# 4. Check current version
npm run version
# Result: 1.0.2 (automatically incremented)

# 5. Build and test
./build.ps1 Test

# 6. In CI/CD: Automatic changelog update and commit
```

### 🎉 **Benefits You Get**

1. **Visual Changelog**: Emojis make changelog sections easy to scan
2. **Consistent Commits**: Enforced conventional commit format
3. **Interactive UX**: `czg` provides guided commit creation
4. **Automatic Versioning**: nbgv handles version management
5. **CI Integration**: Automated changelog updates in TeamCity
6. **Professional Output**: Industry-standard changelog format

### 🔍 **Do You Need Both Files?**

**Yes, for the complete experience:**

- **`.auto-changelog`** → Beautiful changelog generation with emojis
- **`.commitlintrc.json`** → Consistent commit messages with emoji prompts

**Minimal setup (if you want simpler):**
- Keep just **`.auto-changelog`** for emoji changelogs
- Use `czg` without commitlint for basic conventional commits

### 📝 **Recommendation**

**Keep both files** - they work together to provide:
- ✅ Emoji-rich changelogs
- ✅ Consistent commit format
- ✅ Interactive commit experience
- ✅ Automated CI/CD integration
- ✅ Professional documentation

Your setup is now complete with industry-standard tooling! 🚀