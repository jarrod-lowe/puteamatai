# Data Tests

| Record Type                                   | PK                                  | SK                           | GSI(s)                                                                        | Access / Query Scenario                                                                                   | Relevant Tests                                                                                                                                    |
| --------------------------------------------- | ----------------------------------- | ---------------------------- | ----------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| **User Profile**                              | `USER#<userId>`                     | `@PROFILE`                   | None                                                                          | Fetch profile on startup, fetch current user                                                              | Auth required, returns correct user, fields present, update tests, partial update tests                                                           |
| **Account**                                   | `USER#<userId>#ACCOUNT#<accountId>` | `@ACCOUNT`                   | None                                                                          | List all accounts for a user, fetch specific account                                                      | Auth required, returns correct accounts, creation, update, deletion tests, hot shard considerations                                               |
| **Tag**                                       | `USER#<userId>#TAG#<tagId>`         | `@TAG`                       | None                                                                          | List all tags for user, fetch/edit/delete tag                                                             | Auth required, returns all tags, creation/update/delete, projection tests, lightweight record test                                                |
| **Upload**                                    | `USER#<userId>#UPLOAD#<uploadId>`   | `@UPLOAD`                    | None                                                                          | Fetch upload metadata, reference S3 object                                                                | Auth required, only owner can access, S3 reference correct, deduplication triggered                                                               |
| **Transaction**                               | `USER#<userId>#ACCOUNT#<accountId>` | `YYYY-MM-DD#<transactionId>` | **GSI1**: `GSI1PK=USER#<userId>`, `GSI1SK=<accountId>#<date>#<transactionId>` | - List transactions for account in date range<br>- Fetch single transaction<br>- List transactions by tag | - Query returns correct transactions<br>- Date filtering works<br>- Annotations present<br>- Pagination handled<br>- Hot shard and sharding tests |
| **Transaction (startup)**                     | same as above                       | same                         | **GSI1**                                                                      | Fetch all transactions for startup (profile → accounts → tags → transactions)                             | Correct ordering, projection efficiency, annotations included                                                                                     |
| **Annotation / Tag Reference on Transaction** | Embedded in Transaction             | Embedded in Transaction      | N/A                                                                           | Fetch transaction with annotations                                                                        | Annotations correctly embedded, displayed in REST query, predictions respect annotations                                                          |

## Notes

1. **Single Table Design Principle**:

   * All records use `USER#<userId>` as the prefix in PK.
   * All queries are scoped to the user, preventing cross-user access by design.

2. **GSI1 Usage**:

   * Supports queries that need to scan all transactions for a user across accounts and date ranges.
   * Efficient projections allow embedding tags/annotations without creating additional GSIs.

3. **Hot Shard Considerations**:

   * Transactions per account could become large.
   * PK includes `ACCOUNT#<accountId>` to spread transactions across accounts.
   * For extremely active accounts, consider adding a **month/day suffix** in PK or SK to further partition data.

4. **Annotations**:

   * Embedded inside transactions, not separate records.
   * Each transaction carries an array of tags and optional notes, which simplifies access and avoids extra queries.

5. **Startup Access Pattern**:

   * Query user profile (`@PROFILE`), followed by accounts (`@ACCOUNT`), then tags (`@TAG`).
   * Uses PK-sorted ordering to reduce queries to **one batch query** for efficient app startup.
