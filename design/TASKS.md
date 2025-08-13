# Tasks

## 🚀 Project Setup

### **T01 — Project Bootstrap**

* **Description**: Initialize GitHub repo, CI/CD, Docker environment, `Makefile`, and test harnesses for Go, TypeScript, and Terraform.
* **Explanation**: Foundation for development and testing pipelines.
* **Depends on**: None

## 📦 Infrastructure-as-Code (Terraform)

### **T02a — Define Tests for DynamoDB Schema**

* **Description**: Write `terratest` or equivalent checks for DynamoDB single-table layout, key structure, and sharding rules.
* **Explanation**: Validates PK/SK patterns and prevents schema drift.
* **Depends on**: T01

### **T02b — Implement DynamoDB Schema**

* **Description**: Write Terraform for the DynamoDB single-table design.
* **Depends on**: T02a

### **T03a — Define Tests for S3, Cognito, and API Gateway**

* **Description**: Write Terraform test cases to validate creation, access policies, and expected behaviors of S3 buckets, Cognito pools, and API Gateway routes.
* **Explanation**: Ensures correct IAC layout and access isolation.
* **Depends on**: T01

### **T03b — Implement S3, Cognito, and API Gateway**

* **Description**: Write Terraform definitions for all AWS infrastructure not covered by T02b.
* **Depends on**: T03a

## 🧱 Data Access Layer (Go)

### **T04a — Define Tests for Data Access Layer**

* **Description**: Write unit tests for CRUD/query functions for User, Account, Tag, Transaction, and Upload objects.
* **Explanation**: All logic must pass before real DynamoDB access is attempted.
* **Depends on**: T02b

### **T04b — Implement Data Access Layer**

* **Description**: Create Go modules abstracting DynamoDB operations using domain types.
* **Depends on**: T04a

## 🔐 Authentication

### **T05a — Define Tests for Cognito Token Middleware**

* **Description**: Write Go test stubs and mock JWT validation for middleware ensuring token auth.
* **Explanation**: Required for endpoint security.
* **Depends on**: T03b

### **T05b — Implement Cognito Token Middleware**

* **Description**: Implement the middleware logic in Go Lambdas or API Gateway integration.
* **Depends on**: T05a

## 👤 User Profile

### **T06a — Define Tests for `/users/me` API**

* **Description**: Define endpoint tests for fetching and updating user profiles, including validation and error cases.
* **Depends on**: T05b, T04b

### **T06b — Implement `/users/me` API**

* **Description**: Create the Lambda handler and route for fetching/updating user profiles.
* **Depends on**: T06a

## 💳 Accounts

### **T07a — Define Tests for `/accounts` API**

* **Description**: Write test coverage for account CRUD, ownership validation, currency checks.
* **Depends on**: T06b

### **T07b — Implement `/accounts` API**

* **Description**: Implement the REST endpoints to list, create, update, and delete accounts.
* **Depends on**: T07a

## 🏷 Tags

### **T08a — Define Tests for `/tags` API**

* **Description**: Write API and data-layer tests for tag CRUD, including optional fields and isolation.
* **Depends on**: T07b

### **T08b — Implement `/tags` API**

* **Description**: Implement tag REST endpoints.
* **Depends on**: T08a

## 📤 Upload Pipeline

### **T09a — Define Tests for Uploads**

* **Description**: Test file uploads, invalid formats, deduplication, gap detection, and metadata.
* **Depends on**: T08b

### **T09b — Implement Uploads & Processing Logic**

* **Description**: Implement `/uploads` POST/GET and processing Lambda for CSV/QIF parsing.
* **Depends on**: T09a

## 💰 Transactions

### **T10a — Define Tests for `/transactions` API**

* **Description**: Write tests for filters, pagination, annotations, user isolation.
* **Depends on**: T09b

### **T10b — Implement `/transactions` API**

* **Description**: Implement transaction list/create/edit/delete endpoints.
* **Depends on**: T10a

## 📈 Prediction & Analysis

### **T11a — Define Tests for Prediction Logic**

* **Description**: Write tests for recurring detection, smoothing, user annotations, one-off identification.
* **Depends on**: T10b

### **T11b — Implement Prediction Lambda**

* **Description**: Add backend logic for predicting expenses and visual smoothing.
* **Depends on**: T11a

## ⚡️ Optimized Startup

### **T12a — Define Tests for Startup Query**

* **Description**: Test one-shot query fetching profile → accounts → tags efficiently.
* **Depends on**: T08b

### **T12b — Implement Startup Query Endpoint**

* **Description**: Implement a single API route for fast initial data loading.
* **Depends on**: T12a

## 🖥 UI Development

### **T13a — Define Component and Flow Tests (UI)**

* **Description**: Define test specs for user flows: uploads, tagging, viewing predictions, etc.
* **Depends on**: T12b

### **T13b — Implement UI Components and Views**

* **Description**: Create frontend components in TypeScript.
* **Depends on**: T13a

## 🔁 End-to-End Verification

### **T14a — Define E2E Flow Tests**

* **Description**: Specify tests simulating full flows: login → upload → annotate → predict.
* **Depends on**: T13b

### **T14b — Implement E2E Flow Tests**

* **Description**: Implement and run tests using black-box tools (e.g., Cypress, Playwright).
* **Depends on**: T14a

## 🔐 Security & Quality Gatekeeping

### **T15a — Define Security & Regression Tests**

* **Description**: Specify contract, isolation, encryption, and role enforcement tests.
* **Depends on**: T14b

### **T15b — Implement Security Scanning and CI Gates**

* **Description**: Implement static scans, token checks, and enforce test/coverage in CI.
* **Depends on**: T15a
