# GOALS.md

## PūteaMātai — Project Goals and Constraints

### Name & Meaning

**PūteaMātai** derives from te reo Māori, the Indigenous language of Aotearoa New Zealand:

* **Pūtea** means funds, money, or financial resources.
* **Mātai** means to study, investigate, or examine closely.

Together, **PūteaMātai** means “to study money,” perfectly capturing the app’s purpose: to examine personal financial transactions, uncover patterns, and provide insightful analysis.

---

### Purpose

PūteaMātai is a personal finance tracking and analysis webapp designed to:

* Import user financial statements in standard formats (initially **CSV** and **QIF**).
* Record and store transaction data reliably, managing overlapping and partial statement uploads gracefully.
* Detect and handle **duplicate records** to prevent double-counting when users upload overlapping statements for the same account.
* Detect and **advise on gaps** in transaction data uploads for continuous coverage (e.g., missing days between uploaded date ranges).
* Automatically **categorise transactions** with a combination of heuristics and user feedback; users can also add annotations, tags, and notes on transactions, categories, and groups.
* Identify and distinguish **recurring vs one-off expenses** to improve analysis accuracy. One-off expenses contribute to prediction error bars rather than being ignored.
* Incorporate user-added **annotations and advisories** about unusual or upcoming expenses to refine future spending predictions.
* Predict future expenses and cash flow based on historical data, accounting for recurring patterns and user annotations.
* Smooth expense views over detected intervals (daily, weekly, monthly, yearly, or custom) to visualize financial impact as spread evenly rather than spiky.
* Support multi-account tracking with awareness of account currencies, including transfers that may involve currency conversions and associated fees.

---

### Infrastructure & Deployment

* The application will use **AWS serverless infrastructure** exclusively (e.g., Lambda, DynamoDB, S3), avoiding always-on resources such as EC2 or OpenSearch to minimise steady-state costs.
* Infrastructure will be defined and deployed using **Terraform**.
* The web user interface will be implemented using **TypeScript**.
* All production deployments, including infrastructure and application code, will be performed via **GitHub pipelines** targeting the production AWS account.
* All deployment and operational commands, including intermediate file generation, will be run through **Make**.
* Local development tooling and servers will run inside **Docker containers**, enabling zero-install setups outside Make and Docker.
* The GitHub repository configuration (branch protections, security scanners, PR rules) will be self-managed by the project to enforce secure and high-quality development workflows.
* User authentication and authorization (e.g., AWS Cognito) will be designed to securely manage access.

### Data Handling Constraints & Features

* **Initial import formats:** CSV and QIF. The import pipeline will be extensible for future formats.
* **Duplicate detection:** Heuristic-based deduplication will identify overlapping transactions when statements overlap in date ranges or content.
* **Gap detection:** The system will notify users when there are missing date ranges in uploaded data for an account, prompting corrective uploads.
* **Categorisation:** Automatic but tunable with user input; users can edit categories, add tags, and annotate transactions.
* **Annotations:** Users can add notes on individual transactions, categories, and groups of transactions, as well as provide advisory notes for upcoming or unusual expenses.
* **Currencies:** Each account operates in a single currency; currency conversions and fees will be accounted for in transfers between accounts.

### Predictions & Insights

* Expense predictions will leverage historical data, recurring pattern detection, and user annotations.
* One-off expenses will influence prediction error margins but not be excluded from forecasts.
* Users can define or modify annotations that affect the prediction model, such as marking expenses as recurring, one-off, or advisory.
* The UI will offer smoothed views that distribute periodic expenses (daily, monthly, yearly, etc.) evenly to give a clearer picture of ongoing financial impact.

### Testing & Quality Assurance

* Rigorous testing is mandatory from the project start; **tests will be written before code** following Test-Driven Development (TDD) principles.
* Testing types include:
  * **Unit tests** for isolated logic components.
  * **Integration tests** for system parts working together, including infrastructure.
  * **Black-box tests** focusing on API inputs/outputs without internal knowledge.
  * **Contract tests** to verify agreements between system components (e.g., API contracts).
  * **Security scans and audits** as part of CI/CD pipelines.
* Tests will cover normal, edge, and error cases thoroughly to guarantee production stability and prevent regressions.

### User Experience & Interaction

* Users can annotate, tag, and comment on transactions, categories, and grouped data to customise analysis and improve predictions.
* The interface will provide clear visualisations of trends, category spending, and predicted cash flows.
* Smooth expense spreading will be available for flexible period views, enhancing understanding of financial patterns.

### Future Considerations

* Multi-currency support beyond per-account currency handling may be considered later.
* API endpoints may be designed for third-party integrations after core functionality stabilises.

## Summary

PūteaMātai aims to be a secure, cost-efficient, and user-friendly personal finance analytics platform that leverages serverless infrastructure and rigorous engineering discipline to provide actionable insights and predictive analytics. The project balances usability (e.g., flexible uploads, annotations) with technical robustness (e.g., duplicate & gap detection, comprehensive testing), paving the way for scalable and maintainable development.
