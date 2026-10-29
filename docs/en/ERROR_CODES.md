# API error code catalogue

English version of [../ERROR_CODES.md](../ERROR_CODES.md).
Requirement NFT-3 of the specification: errors must have stable codes so the frontend can
show a clear message by code, not only by HTTP status.

Error response format:

```json
{
  "detail": "Human-readable message",
  "code": "MACHINE_READABLE_CODE"
}
```

| Code | HTTP | When it occurs | Example message |
|---|---|---|---|
| `AUTH_INVALID_CREDENTIALS` | 401 | Wrong e-mail or password | "Wrong e-mail or password" |
| `AUTH_TOKEN_EXPIRED` | 401 | The JWT expired or is malformed | "The session has expired, sign in again" |
| `FORBIDDEN_ROLE` | 403 | The role lacks the rights | "Insufficient permissions" |
| `ACCOUNT_DISABLED` | 403 | The account is disabled | "The account is disabled" |
| `RESOURCE_NOT_FOUND` | 404 | The entity was not found | "University not found" |
| `STATUS_HAS_ACTIVE_REQUESTS` | 409 | Deleting a stage that has requests | "The stage has N interactions. Specify a transfer" |
| `DUPLICATE_INTERACTION` | 409 | A duplicate university/product pair | "This interaction is already registered" |
| `DUPLICATE_VUZ_NAME` | 409 | A duplicate university on import | "The university already exists" |
| `MAX_PARALLEL_INTERACTIONS` | 409 | More than 2 active interactions for a university | "The university already has 2 active interactions" |
| `WORKFLOW_SCOPE_MISMATCH` | 409 | A stage from another workflow | "The stage belongs to another workflow" |
| `VALIDATION_FAILED` | 422 | A Pydantic schema error | "Field X is required" |
| `IMPORT_FILE_CORRUPTED` | 422 | Broken encoding or file structure | "The file is corrupted, check the encoding" |
| `RATE_LIMITED` | 429 | The sign-in attempt limit was exceeded | "Too many attempts, try again in a minute" |
| `INTERNAL_ERROR` | 500 | An unexpected error | "Internal error, try again later" |

## Implementation

- `MAX_PARALLEL_INTERACTIONS` and `WORKFLOW_SCOPE_MISMATCH` are returned in
  `backend/api/interactions.py`.
- `RATE_LIMITED` — in `backend/middleware/rate_limit.py`.
- `VALIDATION_FAILED` — the global `RequestValidationError` handler in `backend/main.py`.
