# API

## 1. Users

### 1.1 REST Endpoints

| Endpoint    | Method | Purpose                    | Tests                                                                                                                               |
| ----------- | ------ | -------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| `/users/me` | GET    | Fetch current user profile | - Auth required<br>- Returns correct user only<br>- Missing/invalid token returns 401<br>- Returns all expected fields (`@PROFILE`) |
| `/users/me` | PATCH  | Update user profile        | - Auth required<br>- Invalid fields rejected<br>- Successful update persists in DB<br>- Validation errors handled                   |

### 1.2 DynamoDB Operations

* Fetch user by PK=`USER#<userId>` SK=`@PROFILE`
* Update user attributes
* Tests:

  * Correct PK/SK generation
  * Invalid updates rejected
  * Partial updates preserved

## 2. Accounts

### 2.1 REST Endpoints

| Endpoint         | Method | Purpose                        | Tests                                                                                                                        |
| ---------------- | ------ | ------------------------------ | ---------------------------------------------------------------------------------------------------------------------------- |
| `/accounts`      | GET    | List accounts for current user | - Auth required<br>- Returns all accounts for user<br>- Fields correct (ID, name, currency, balance)<br>- Empty list handled |
| `/accounts`      | POST   | Create new account             | - Auth required<br>- Unique account ID enforced<br>- Invalid currency rejected<br>- Successful creation persisted            |
| `/accounts/<id>` | PATCH  | Update account info            | - Auth required<br>- Only account owner allowed<br>- Valid updates persisted<br>- Invalid updates rejected                   |
| `/accounts/<id>` | DELETE | Remove account                 | - Auth required<br>- Only account owner allowed<br>- Cascades or prevents deletion if transactions exist                     |

### 2.2 DynamoDB Operations

* PK=`USER#<userId>#ACCOUNT#<accountId>`, SK=`@ACCOUNT`
* Tests:

  * Correct PK/SK usage
  * Query all accounts for user
  * Ensure deletion or cascade rules
  * Test partition sharding for hot accounts

## 3. Tags

### 3.1 REST Endpoints

| Endpoint     | Method | Purpose                | Tests                                                                                                                        |
| ------------ | ------ | ---------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `/tags`      | GET    | List all tags for user | - Auth required<br>- Returns all tags<br>- Fields correct (`text`, color, optional notes)<br>- Empty list handled            |
| `/tags`      | POST   | Create tag             | - Auth required<br>- Duplicate text allowed?<br>- Correct PK/SK and indexing<br>- Persisted in DB                            |
| `/tags/<id>` | PATCH  | Update tag             | - Auth required<br>- Fields updated correctly<br>- Validation errors handled                                                 |
| `/tags/<id>` | DELETE | Remove tag             | - Auth required<br>- Deleting tag does not break transactions (transactions retain reference)<br>- Cascading behavior tested |

### 3.2 DynamoDB Operations

* PK=`USER#<userId>#TAG#<tagId>`, SK=`@TAG`
* Tests:

  * Query all tags for user
  * Single tag CRUD
  * Minimal impact on hot shards

## 4. Uploads (Statement References)

### 4.1 REST Endpoints

| Endpoint        | Method | Purpose                  | Tests                                                                                                                                                                     |
| --------------- | ------ | ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `/uploads`      | POST   | Upload statement CSV/QIF | - Auth required<br>- Invalid file format rejected<br>- S3 upload succeeds<br>- Deduplication logic triggered<br>- Missing date periods detected<br>- Returns reference ID |
| `/uploads/<id>` | GET    | Retrieve upload metadata | - Auth required<br>- Only owner can access<br>- Returns correct S3 reference and metadata                                                                                 |

### 4.2 Lambda/Processing

* Parse CSV/QIF
* Deduplicate transactions
* Detect missing periods
* Assign tags
* Tests:

  * Deduplication accuracy
  * Gap detection between periods
  * Multi-account transfer detection with currency conversion
  * Edge cases (overlapping uploads, missing dates)
  * Correct generation of transaction records

## 5. Transactions

### 5.1 REST Endpoints

| Endpoint             | Method | Purpose                                  | Tests                                                                                                                                   |
| -------------------- | ------ | ---------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| `/transactions`      | GET    | List transactions by account, date range | - Auth required<br>- Returns correct transactions<br>- Filters by date range<br>- Embedded annotations returned<br>- Pagination handled |
| `/transactions/<id>` | GET    | Get single transaction                   | - Auth required<br>- Correct transaction returned<br>- Annotations included                                                             |
| `/transactions/<id>` | PATCH  | Update transaction                       | - Auth required<br>- Fields update correctly<br>- Add/modify annotations<br>- Validation errors handled                                 |
| `/transactions/<id>` | DELETE | Delete transaction                       | - Auth required<br>- Only allowed by owner<br>- Cascading tag/annotation behavior tested                                                |

### 5.2 DynamoDB Operations

* PK=`USER#<userId>#ACCOUNT#<accountId>`, SK=`YYYY-MM-DD#<transactionId>`
* Embedded annotations as transaction fields
* Tests:

  * Query all transactions in range (date filtering)
  * Ensure annotations correctly embedded
  * Deduplication validation
  * Hot shard testing for large accounts
  * Monthly partition sharding

## 6. Analysis & Predictions

### 6.1 Lambda / Backend Logic

* Detect recurring vs one-off transactions
* Predict future expenses
* Spread large transactions over appropriate period
* Tests:

  * Recurring transaction detection
  * Prediction accuracy
  * One-off error bars correct
  * Smoothing/spreading correctness
  * Handling of missing periods
  * User-added annotations affecting predictions

## 7. Startup / Fast Load

### 7.1 Backend Queries

* Fetch profile → accounts → tags in one query for fast startup
* Tests:

  * Query ordering correct
  * Returns all necessary fields
  * Correct projections used for efficiency

## 8. Security

* Test that all endpoints require authentication
* Test token validation and expiry
* Test access isolation between users
* Test encryption in transit and at rest

## 9. UI

* Component and integration tests
* Simulate user flows for:

  * Uploads
  * Transaction creation and editing
  * Tag creation and editing
  * Dashboard display
  * Missing period alerts
  * Prediction visualization
* Tests:

  * Render correctness
  * Data binding accuracy
  * Edge cases (empty lists, overlapping transactions, missing tags)
