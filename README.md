# PūteaMātai

> *To Study Money* - Personal finance tracking and analysis webapp with predictive analytics

PūteaMātai is a serverless personal finance application built on AWS that helps you understand your spending patterns, predict future expenses, and make informed financial decisions.

## Features

- 📊 **Smart Transaction Analysis**: Import CSV/QIF statements with automatic categorization
- 🔍 **Duplicate Detection**: Intelligent handling of overlapping statement uploads  
- 📈 **Predictive Analytics**: ML-powered expense forecasting with recurring pattern detection
- 💰 **Multi-Currency Support**: Handle transfers between accounts in different currencies
- 🏷️ **Flexible Tagging**: Custom categories, annotations, and notes on transactions
- 🎯 **Gap Detection**: Identify missing periods in your financial data
- 📱 **Modern Web UI**: TypeScript-powered responsive interface

## Architecture

- **Backend**: Go Lambda functions with DynamoDB Single Table Design
- **Frontend**: TypeScript with modern web technologies  
- **Infrastructure**: AWS serverless (Lambda, DynamoDB, S3, API Gateway, Cognito)
- **Deployment**: Terraform Infrastructure as Code with GitHub Actions CI/CD

## Quick Start

### Prerequisites

Ensure you have the required development tools:

```bash
make env-check    # Verify required tools are installed
make env-setup    # Install missing tools automatically
```

### Development

```bash
make dev          # Start development environment
make test         # Run all tests
make lint         # Run code linters
make fmt          # Format code
```

### Testing

```bash
make test-languages    # Test all language scaffolds
make test-go          # Test Go components
make test-node        # Test Node.js components  
make test-metadata    # Validate project metadata
```

## Project Structure

```
├── backend/          # Go Lambda functions and data access layer
├── frontend/         # TypeScript UI components  
├── terraform/        # Infrastructure definitions
├── tests/           # Test suites for all components
├── scripts/         # Build and utility scripts
└── docs/           # Additional documentation
```

## Contributing

This project follows Test-Driven Development (TDD) practices:

1. Write failing tests first (Red phase)
2. Implement minimal code to make tests pass (Green phase)  
3. Refactor and improve while keeping tests green

### Development Commands

Run `make help` to see all available commands.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Name & Meaning

**PūteaMātai** derives from te reo Māori:
- **Pūtea**: funds, money, financial resources
- **Mātai**: to study, investigate, examine closely

Together meaning "to study money" - perfectly capturing our app's purpose.