# Module specification: template

English version of [../../modules/module-template.md](../../modules/module-template.md).
Copy this into `docs/modules/<name>.md`. All 11 sections are mandatory —
`scripts/docs-check.sh` verifies their presence in CI.

## 1. Purpose and boundaries
What the module does, what it does not do, where its responsibility ends.

## 2. Use cases
User/system → what happens → what is observable, including failures.

## 3. Contract
Routes, schemas, events, error codes; a reference to `backend/openapi.json`.

## 4. Data
Which tables/files the module writes (as the single writer) and what it reads through
other modules' contracts. Snapshot, aggregates, provenance.

## 5. Permissions
Who has access, what happens on denial, how that is verified.

## 6. Dependencies
Inbound (who calls it) and outbound (what it calls), a port/adapter for an external system.

## 7. Configuration
`AEZA_*` variables with defaults, whether they are mandatory, and the consequences of a
wrong value.

## 8. Build and debugging
How to run this module alone, how to reproduce the behaviour locally.

## 9. Tests
Which tests prove what (files, test names).

## 10. Observability
Logs, metrics, error codes, what the operator does on failure.

## 11. Limitations and readiness
Known limitations, what is deliberately not done, readiness criteria.
