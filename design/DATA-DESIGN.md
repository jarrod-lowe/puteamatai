# Data Design

## 1. Introduction

PūteaMātai uses DynamoDB Single Table Design to efficiently store and query all entities in one table. This document defines the data model, key schemas, access patterns, and examples.

All transaction annotations are embedded inside the transaction record to allow efficient bulk access and analysis.
To prevent hot partitions, **transaction records are sharded by month**.

## 2. Core Entities

* **User:** Authenticated user identified by Cognito user ID.
* **Account:** Financial account belonging to a user.
* **Tag:** Flat list of tags for categorization; `text` attribute used uniformly.
* **Transaction:** Financial transaction linked to user and account. Embedded annotations. Sharded by month.
* **Upload:** Metadata for statement uploads referencing S3 objects.

## 3. Key Schema Design

### 3.1 Table Keys

| Entity      | Partition Key (PK)                          | Sort Key (SK)                              | Description                                       |
| ----------- | ------------------------------------------- | ------------------------------------------ | ------------------------------------------------- |
| User        | `USER#<userId>`                             | `@PROFILE`                                 | User profile (prefixed to sort first)             |
| Account     | `USER#<userId>`                             | `ACCOUNT#<accountId>`                      | User’s accounts                                   |
| Tag         | `USER#<userId>`                             | `TAG#<tagId>`                              | Flat user tags (text attribute for name)          |
| Transaction | `USER#<userId>#ACCOUNT#<accountId>#YYYY-MM` | `TRANSACTION#<YYYY-MM-DD>#<transactionId>` | Transactions partitioned by month, sorted by date |
| Upload      | `USER#<userId>#ACCOUNT#<accountId>`         | `UPLOAD#<uploadId>`                        | Upload metadata referencing S3 files              |

> Monthly sharding prevents hot partitions for accounts with many transactions.

### 3.2 Global Secondary Index (GSI)

* **No GSIs required**.

## 4. Access Patterns and Queries

### 4.1 Startup Access Pattern

* **Fetch user profile, accounts, and tags in one query for fast app startup:**

```text
PK = USER#<userId>
```

Returns:

* Profile first (`@PROFILE`)
* Accounts next (`ACCOUNT#`)
* Tags last (`TAG#`)

### 4.2 Fetch Transactions for Account

* **Query a single month:**

```text
PK = USER#<userId>#ACCOUNT#<accountId>#YYYY-MM
SK between TRANSACTION#<startDate> and TRANSACTION#<endDate>
```

Returns transactions and embedded annotations.

* **Query multiple months:**
  Execute multiple queries for each month’s PK. Combine results in application code.

### 4.3 Fetch Uploads for an Account

```text
PK = USER#<userId>#ACCOUNT#<accountId>
SK begins_with UPLOAD#
```

### 4.4 Fetch All Tags for a User

```text
PK = USER#<userId>
SK between 'TAG#' and 'TAG#\uffff'
```

* Efficient because tags are lightweight and per-user.

## 5. Entity Examples

### User Item

```json
{
  "PK": "USER#user-1234abcd",
  "SK": "@PROFILE",
  "email": "user@example.com",
  "preferences": {
    "currency": "NZD",
    "timezone": "Pacific/Auckland"
  }
}
```

### Account Item

```json
{
  "PK": "USER#user-1234abcd",
  "SK": "ACCOUNT#account-5678efgh",
  "name": "Everyday Checking",
  "currency": "NZD",
  "createdAt": "2023-05-01T12:00:00Z"
}
```

### Tag Item

```json
{
  "PK": "USER#user-1234abcd",
  "SK": "TAG#tag-001",
  "text": "Groceries"
}
```

### Transaction Item (Sharded by Month, with Embedded Annotations)

```json
{
  "PK": "USER#user-1234abcd#ACCOUNT#5678efgh#2025-08",
  "SK": "TRANSACTION#2025-08-13#txn-abc123",
  "amount": 150.75,
  "currency": "NZD",
  "merchant": "Supermarket X",
  "tagIds": ["tag-001"],
  "tags": ["Groceries"],
  "date": "2025-08-13",
  "notes": "Weekly shopping",
  "annotations": [
    {
      "annotationId": "ann-456def",
      "text": "Expected increase in grocery costs next month",
      "type": "advisory",
      "createdAt": "2025-08-14T09:00:00Z"
    }
  ]
}
```

### Upload Item

```json
{
  "PK": "USER#user-1234abcd#ACCOUNT#5678efgh",
  "SK": "UPLOAD#upload-789xyz",
  "uploadedAt": "2025-08-15T14:30:00Z",
  "dateRange": {
    "start": "2025-07-01",
    "end": "2025-07-31"
  },
  "s3ObjectKey": "uploads/user-1234abcd/account-5678efgh/statement-2025-07.csv",
  "status": "processed"
}
```

## Summary

| Partition Key (PK)                          | Sort Key (SK)                     | Record Type |
| ------------------------------------------- | --------------------------------- | ----------- |
| USER#user-1234abcd                          | @PROFILE                          | Profile     |
| USER#user-1234abcd                          | ACCOUNT#account-5678efgh          | Account     |
| USER#user-1234abcd                          | TAG#tag-001                       | Tag         |
| USER#user-1234abcd                          | TAG#tag-002                       | Tag         |
| USER#user-1234abcd#ACCOUNT#5678efgh         | UPLOAD#upload-789xyz              | Upload      |
| USER#user-1234abcd#ACCOUNT#5678efgh#2025-08 | TRANSACTION#2025-08-01#txn-abc123 | Transaction |
| USER#user-1234abcd#ACCOUNT#5678efgh#2025-08 | TRANSACTION#2025-08-13#txn-def456 | Transaction |

## Diagram

```mermaid
%% Single Table Design for PūteaMātai (Monthly Sharded Transactions)
%% PK = Partition Key, SK = Sort Key

erDiagram
    USER_PROFILE {
        string PK "USER#<userId>"
        string SK "@PROFILE"
        string email
        object preferences
    }
    ACCOUNT {
        string PK "USER#<userId>"
        string SK "ACCOUNT#<accountId>"
        string name
        string currency
        string createdAt
    }
    TAG {
        string PK "USER#<userId>"
        string SK "TAG#<tagId>"
        string text
    }
    UPLOAD {
        string PK "USER#<userId>#ACCOUNT#<accountId>"
        string SK "UPLOAD#<uploadId>"
        string s3ObjectKey
        string uploadedAt
        object dateRange
        string status
    }
    TRANSACTION {
        string PK "USER#<userId>#ACCOUNT#<accountId>#YYYY-MM"
        string SK "TRANSACTION#YYYY-MM-DD#<transactionId>"
        string merchant
        number amount
        string currency
        string[] tags
        object[] annotations
        string date
        string notes
    }

    %% Startup ordering
    USER_PROFILE ||--|| ACCOUNT : fetch all accounts for user
    USER_PROFILE ||--|| TAG : fetch all tags for user
    ACCOUNT ||--|| UPLOAD : fetch uploads per account
    ACCOUNT ||--|| TRANSACTION : monthly-sharded transactions
```

```mermaid
graph TD
    %% Users
    U[USER#user-1234abcd] -->|@PROFILE| UP[Profile<br>email: user@example.com<br>currency: NZD]

    %% Accounts
    U -->|ACCOUNT#account-5678efgh| A1[Account<br>name: Everyday Checking<br>currency: NZD]

    %% Tags
    U -->|TAG#tag-001| T1[Tag<br>text: Groceries]
    U -->|TAG#tag-002| T2[Tag<br>text: Entertainment]

    %% Uploads
    A1 -->|UPLOAD#upload-789xyz| UL1[Upload<br>s3ObjectKey: uploads/...<br>status: processed]

    %% Transactions (sharded by month)
    A1 -->|PK: USER#user-1234abcd#ACCOUNT#5678efgh#2025-08| TXShard1[Monthly Shard: 2025-08]

    TXShard1 -->|TRANSACTION#2025-08-01#txn-abc123| TX1[Transaction<br>merchant: Supermarket X<br>amount: 150.75 NZD<br>tags: Groceries]
    TXShard1 -->|TRANSACTION#2025-08-13#txn-def456| TX2[Transaction<br>merchant: Cafe Y<br>amount: 12.50 NZD<br>tags: Entertainment]

    %% Labels for clarity
    classDef pk fill:#e0f7fa,stroke:#006064,stroke-width:1px;
    classDef sk fill:#fff9c4,stroke:#f57f17,stroke-width:1px;

    class U,TXShard1,UL1,A1,T1,T2 pk;
    class UP,TX1,TX2 sk;
```
