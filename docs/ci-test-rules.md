# CI Test Rules and Enforcement Policies

This document defines the continuous integration test rules, coverage requirements, linting policies, and enforcement mechanisms for PūteaMātai.

## Test Requirements

### Mandatory Test Categories

All pull requests and main branch commits MUST pass these test categories:

1. **Language-Specific Tests**
   - Go: Unit tests via `go test` with PASS requirement
   - Node.js: Jest test suites with zero failures
   - Terraform: Configuration validation via `terraform validate`

2. **Environment Validation**
   - Required development tools availability check
   - Cross-platform compatibility (Ubuntu, macOS)

3. **Project Metadata Validation** 
   - Essential files presence (README.md, LICENSE, .editorconfig)
   - Project structure integrity
   - Documentation completeness

4. **Pipeline Integrity**
   - GitHub Actions workflow configuration validation
   - CI/CD infrastructure health checks

### Test Execution Requirements

- Tests MUST complete within 10 minutes maximum
- All test output MUST be captured and preserved
- Test failures MUST halt the pipeline immediately

## Coverage

### Current Coverage Policy

- **Go Code**: No minimum coverage enforced (bootstrap phase)
- **TypeScript/JavaScript**: No minimum coverage enforced (bootstrap phase)
- **Future Target**: 80% line coverage for production code

### Coverage Reporting

- Coverage reports generated but not enforced during bootstrap
- Coverage trends tracked for improvement visibility
- Critical path code requires higher coverage standards

## Linting

### Linting Standards

Each language follows established community standards:

1. **Go**: 
   - `go vet` for static analysis
   - `golangci-lint` with standard ruleset (when implemented)
   - `gofmt` formatting enforcement

2. **TypeScript/JavaScript**:
   - ESLint with recommended rules
   - Prettier for code formatting
   - Import/export validation

3. **Terraform**:
   - `terraform fmt` formatting checks
   - `tflint` for Terraform-specific rules
   - Security scanning with `tfsec`

4. **Shell Scripts**:
   - `shellcheck` static analysis
   - POSIX compliance where possible

### Linting Enforcement

- Linting rules are **advisory** during bootstrap phase
- Linting failures do NOT block merges initially
- Progressive enforcement as codebase matures

## Fail Fast

### Fail-Fast Policies

The CI pipeline implements fail-fast behavior:

1. **Environment Setup Failure**: Halt immediately if required tools missing
2. **Test Compilation Failure**: Stop pipeline if code doesn't compile
3. **Critical Test Failure**: Abort on language test failures
4. **Security Scan Failure**: Block on high/critical security issues

### Exception Handling

- Metadata validation warnings are non-blocking
- Optional component failures logged but don't halt pipeline
- Repository protection checks skipped in CI (require admin access)

## Language-Specific

### Go Requirements

```bash
# Test execution
cd tests/go && go test -v

# Success criteria
- All tests PASS
- No compilation errors
- Test execution < 30 seconds
```

### Node.js Requirements

```bash
# Test execution  
npm test

# Success criteria
- Jest test suites: 0 failures
- All assertions pass
- Test coverage collected
- Test execution < 60 seconds
```

### Terraform Requirements

```bash
# Validation execution
cd tests/terraform && terraform validate

# Success criteria
- Configuration validates successfully
- No syntax errors
- Provider configurations valid
- Validation execution < 10 seconds
```

## Pipeline Integration

### GitHub Actions Enforcement

The test pipeline (`.github/workflows/test.yml`) enforces these rules:

1. **Sequential Validation**: Environment → Tests → Metadata → Pipelines
2. **Isolated Testing**: Each language tested independently
3. **Comprehensive Coverage**: All defined test categories executed
4. **Clear Reporting**: Test results visible in PR status checks

### Local Development

Developers can verify compliance locally:

```bash
make test           # Run complete test suite
make test-ci-rules  # Validate CI rule compliance
make env-check      # Verify environment setup
```

### Continuous Improvement

- Rules reviewed and updated with each major feature
- Coverage thresholds increased as codebase stabilizes  
- Additional quality gates added based on project needs
- Community feedback incorporated into rule refinements

---

*This document is part of T01.5a - Define CI Test Rules*