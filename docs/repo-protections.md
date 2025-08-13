# Repository Protection Rules

This document defines the GitHub repository protection rules and validation checks for PūteaMātai, implementing **T01.1a — Define Repo Rules and Protections**.

## Overview

Repository protections ensure code quality, security, and collaboration standards are maintained throughout the development lifecycle. This is critical for a financial application handling sensitive transaction data.

## Protection Rules Defined

### Branch Protection (main branch)

1. **Pull Request Reviews**
   - Disabled for solo development phase
   - Can be re-enabled when team grows by updating protection scripts

2. **Status Checks**
   - Require status checks to pass before merging
   - Require branches to be up to date before merging
   - Required contexts will be added when CI/CD is implemented

3. **Push Restrictions**
   - Block force pushes to protected branch
   - Block deletion of protected branch
   - Enforce rules for administrators

### Security Settings

1. **Vulnerability Management**
   - Enable vulnerability alerts
   - Enable automated security fixes (Dependabot)

2. **Repository Access**
   - Repository should be public (contains no secrets, only code and infrastructure)
   - Proper access controls via code ownership and branch protection

### Required Files

The validation checks ensure these critical files exist:
- `README.md` - Project documentation
- `LICENSE` - Legal requirements
- `.gitignore` - Prevent sensitive data commits
- `CLAUDE.md` - AI assistant guidance
- `CODEOWNERS` - Code review requirements

## Implementation Files

### Scripts

- **`scripts/validate-repo-protections.sh`**
  - Validates all protection rules are properly configured
  - Uses GitHub CLI to check current repository settings
  - Returns exit code 0 for success, 1 for failures
  - Provides detailed output of what's configured vs expected

- **`scripts/setup-repo-protections.sh`**
  - Applies the defined protection rules to the repository
  - Sets branch protections, security settings, and metadata
  - Will be used by T01.1b to implement the actual protections

### Configuration

- **`CODEOWNERS`**
  - Defines code ownership patterns
  - Ensures @jarrod-lowe reviews all changes
  - Special attention to security-critical paths:
    - `/terraform/` - Infrastructure changes
    - `/scripts/` - Build and deployment scripts
    - `/.github/` - CI/CD workflows
    - `/backend/auth/` - Authentication logic
    - `/backend/data/` - Data access layer

### Testing

- **`tests/validate-repo-protections.test.sh`**
  - Comprehensive test suite for validation logic
  - Tests script existence, permissions, and functionality
  - Includes mocking for GitHub API responses
  - Validates CODEOWNERS configuration

## Usage

### Validate Current Protections
```bash
./scripts/validate-repo-protections.sh
```

### Apply Protection Rules (T01.1b)
```bash
./scripts/setup-repo-protections.sh
```

### Run Tests
```bash
./tests/validate-repo-protections.test.sh
```

## Security Rationale

Given PūteaMātai handles personal financial data, these protections ensure:

1. **Code Quality**: All changes reviewed before merging
2. **Security**: Automated vulnerability scanning and fixes
3. **Compliance**: Audit trail via required reviews and status checks
4. **Data Protection**: Public repository with no secrets stored in code
5. **Infrastructure Safety**: Special protection for Terraform and scripts

## Dependencies

- GitHub CLI (`gh`) installed and authenticated
- Repository owner permissions to apply protections
- Proper authentication tokens for CI/CD (when implemented)

## Next Steps (T01.1b)

1. Run the setup script to apply protections
2. Verify protections with validation script
3. Configure branch protection status check contexts when CI is ready
4. Add additional reviewers to CODEOWNERS as team grows