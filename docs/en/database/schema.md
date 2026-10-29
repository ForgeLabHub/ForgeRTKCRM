# Data schema

English version of [../../database/schema.md](../../database/schema.md).
The full ER model is in [architecture/er-model.md](../architecture/er-model.md) (plus
`er.mmd`, `er-model.pdf`). This page covers data ownership and the rules.

## Business model

```
University ──┐
             ├──► Interaction ──► WorkflowStage
ITProduct  ──┘        │
ITDirection ── ITProduct   ├── Action (task with a deadline)
                           └── Comment
```

`University`, `ITProduct`, `ITDirection` are reference data.
`Interaction` is the main entity: the "university + product" pair moving through the stages.

## Data ownership

| Domain | Writer | Reader |
| --- | --- | --- |
| Reference data (universities, products, directions) | `api.directories`, `admin` only | all modules, reports |
| Workflow stages | `api.stages`, `admin` only | interactions, reports |
| Interactions, tasks, comments | `api.interactions` | reports, notifications, audit |
| Audit | `middleware.audit` | the administrator |
| Files | `services.file_storage` (S3/MinIO), references in the database | export, PDF guides |

## Rules

1. **The limit "at most 2 active interactions per university"** is enforced by the
   application. There is no schema constraint — a known limitation (see the audit).
2. **Reference data is never deleted physically** while it is referenced: deactivate first.
3. **Cyrillic in exports** is a cross-cutting requirement: the Excel export is covered by a
   test.
4. **Production is PostgreSQL 16**, SQLite is acceptable locally; SQLite-only changes are
   not considered sufficient.

## Verification

- Model/migration consistency — `make alembic-check`.
- Installation from scratch and re-application — `portability.yml` (`alembic-fresh`,
  `alembic-upgrade-path`).
- Restoring a backup — `portability.yml` (`backup-restore`).
