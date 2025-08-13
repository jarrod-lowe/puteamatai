# PūteaMātai — High-Level Design

## 1. Overview

Brief summary of the app purpose, users, and high-level goals (from GOALS.md)

## 2. Architecture & AWS Services

### 2.1 Core Components & Design Choices

* **API Layer:** REST API exposed via API Gateway
* **Business Logic:** Lambda functions where needed, prefer API Gateway and Step Functions direct integrations for simple workflows
* **Data Store:** DynamoDB using **Single Table Design** to optimize performance, cost, and scalability
* **Authentication:** AWS Cognito for secure user auth and authorization
* **File Storage:** S3 for statement uploads
* **Event Orchestration:** SNS/SQS/Step Functions for decoupled async processes

## 3. Data Model Overview

### 3.1 DynamoDB Single Table Design Approach (Summary)

* All entities (User, Account, Transaction, Category, Tag, Annotation, StatementUpload) stored in a **single DynamoDB table**.
* Use **Partition Key (PK)** and **Sort Key (SK)** to differentiate entity types and enable efficient querying by user, account, or transaction.
* Use **GSIs** (Global Secondary Indexes) to support alternative access patterns (e.g., querying all transactions by category or date range).
* Store entity attributes in JSON or flattened attributes, designed to minimize item size and optimize read/write costs.
* Maintain strict item size limits (max 400KB) and consider attribute projections carefully.

> See **DATA-DESIGN.md** for detailed schema diagrams, key design, access patterns, and examples.

## 4. Backend Code Structure & Data Access Layer

* Backend will include a **data access layer** abstracting DynamoDB interactions to encapsulate Single Table Design complexities.
* Modules will operate on domain entities without exposing DynamoDB key structure to business logic.
* Data access layer will expose clear CRUD and query methods per entity type, optimized for performance.
* Tests will cover data layer with mocked DynamoDB clients to validate correct key and attribute handling.
