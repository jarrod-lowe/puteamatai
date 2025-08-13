# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

PūteaMātai is a personal finance tracking and analysis webapp built with AWS serverless infrastructure. The name derives from te reo Māori meaning "to study money" - the app imports financial statements, categorizes transactions, and provides predictive analytics.

## Architecture & Technology Stack

### Backend
- **Language**: Go (for Lambda functions and data access layer)
- **Infrastructure**: AWS serverless (Lambda, DynamoDB, S3, API Gateway, Cognito)
- **Infrastructure-as-Code**: Terraform
- **Database**: DynamoDB using Single Table Design with monthly transaction sharding
- **Authentication**: AWS Cognito

### Frontend
- **Language**: TypeScript
- **Deployment**: Static files served from S3/CloudFront

### Development Environment
- **Containerization**: Docker for local development
- **Build System**: Makefile for all operations
- **CI/CD**: GitHub Actions

## Data Model (DynamoDB Single Table Design)

All entities stored in one DynamoDB table with this key structure:

| Entity      | Partition Key (PK)                          | Sort Key (SK)                              |
| ----------- | ------------------------------------------- | ------------------------------------------ |
| User        | `USER#<userId>`                             | `@PROFILE`                                 |
| Account     | `USER#<userId>`                             | `ACCOUNT#<accountId>`                      |
| Tag         | `USER#<userId>`                             | `TAG#<tagId>`                              |
| Transaction | `USER#<userId>#ACCOUNT#<accountId>#YYYY-MM` | `TRANSACTION#<YYYY-MM-DD>#<transactionId>` |
| Upload      | `USER#<userId>#ACCOUNT#<accountId>`         | `UPLOAD#<uploadId>`                        |

**Key Design Points:**
- Transactions are sharded by month to prevent hot partitions
- Annotations are embedded within transaction records
- Single query can fetch user profile, accounts, and tags for fast startup
- No GSIs required due to careful key design

## Development Workflow

### Test-Driven Development
- **All tests must be written before implementation code**
- Test types: Unit, Integration, Contract, Black-box, Security
- Coverage and quality gates enforced in CI/CD

### Task Structure
Tasks follow dependency-aware pattern:
- `T##a` - Define tests and validation rules
- `T##b` - Implement functionality (depends on corresponding `a` task)

### Common Commands
```bash
# Development setup (when implemented)
make dev          # Start local development environment
make test         # Run all tests
make lint         # Run linters for all languages
make fmt          # Format code
make build        # Build all components

# Infrastructure
make terraform-plan    # Plan infrastructure changes
make terraform-apply   # Apply infrastructure changes

# Deployment
make deploy-staging    # Deploy to staging
make deploy-prod      # Deploy to production
```

## Key Features & Business Logic

### Transaction Processing
- CSV/QIF import with deduplication
- Gap detection for missing statement periods
- Automatic categorization with user feedback
- Currency conversion handling for transfers

### Analytics & Predictions
- Recurring vs one-off expense detection
- Expense smoothing over configurable periods
- User annotations affect prediction models
- Error bars for one-off expenses

### Security Requirements
- All endpoints require Cognito authentication
- User data isolation enforced at data layer
- No secrets in code or commits
- Encryption in transit and at rest

## File Structure Expectations

```
/
├── design/           # Design documentation (existing)
├── terraform/        # Infrastructure definitions
├── backend/          # Go Lambda functions and data access layer
├── frontend/         # TypeScript UI components
├── docker/           # Development containers
├── scripts/          # Build and utility scripts
├── .github/          # CI/CD workflows
└── Makefile          # Build system entry point
```

## Development Guidelines

### Code Organization
- Data access layer abstracts DynamoDB Single Table Design complexity
- Domain entities should not expose DynamoDB key structure
- Use existing patterns and libraries discovered in the codebase
- Follow established naming conventions

### AWS Resource Naming
- All resources prefixed with project name
- Environment-specific suffixes (-dev, -staging, -prod)
- Consistent tagging for cost allocation

### Testing Strategy
- Mock DynamoDB clients for data layer tests
- Contract tests between Lambda functions and API Gateway
- End-to-end tests using Cypress or Playwright
- Security scans integrated in CI pipeline

## Important Constraints

- **Cost Optimization**: Use serverless infrastructure only, no always-on resources
- **Zero-Install Development**: Everything runs in Docker containers
- **Security First**: Authentication required, data isolation enforced
- **Test Coverage**: Comprehensive testing required before any implementation