# C4 Context

English version of [../../architecture/c4-context.md](../../architecture/c4-context.md).

```mermaid
flowchart LR
    kam([KAM / executive])
    admin([Administrator])
    b2c([B2C client])
    crm[RTK CRM]
    db[(PostgreSQL)]
    cache[(Redis / KeyDB)]
    files[(S3 / MinIO)]
    lms[University LMS / CMS]
    export[Reports XLSX / XLS / PDF / JSON]

    kam -->|HTTPS, JWT| crm
    admin -->|HTTPS, JWT, RBAC| crm
    b2c -->|HTTPS, JWT, B2C funnel| crm
    crm -->|SQL via asyncpg| db
    crm -->|report cache, TTL 30 s| cache
    crm -->|files| files
    crm -.->|integration groundwork| lms
    crm --> export
```

The system accepts user actions, runs two independent workflows (B2B — 14 stages of the IT
School, B2C — a simplified funnel), stores working data in PostgreSQL, caches report
aggregates and produces exports in four formats.
