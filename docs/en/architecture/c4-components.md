# C4 Components

English version of [../../architecture/c4-components.md](../../architecture/c4-components.md).

```mermaid
flowchart TB
    browser[Browser]
    app[React + Ant Design]
    client[Axios API client]
    api[FastAPI routers]
    auth[JWT auth + RBAC]
    ratelimit[Rate limit middleware]
    audit[Audit middleware]
    domain[Domain services]
    workflow[Workflow B2B / B2C]
    imports[Import: XLS / XLSX / JSON]
    exports[Export: XLSX / XLS / PDF / JSON]
    scheduler[APScheduler: stalled requests]
    orm[SQLAlchemy async]
    cache[Report cache Redis/KeyDB]
    postgres[(PostgreSQL)]
    storage[File storage S3/MinIO]

    browser --> app --> client --> api
    api --> ratelimit --> auth
    api --> domain
    api --> audit --> orm
    domain --> workflow --> orm
    api --> imports --> orm
    api --> exports --> orm
    api --> cache --> orm
    domain --> storage
    scheduler --> orm
    orm --> postgres
```

The frontend is responsible for presentation and interactions, the backend for authorization,
validation, business rules, audit and data access. The report aggregate cache and the
notification scheduler are separate services so that request processing is never blocked.
