# Module: reports and exports

English version of [../../modules/reports.md](../../modules/reports.md).

## 1. Purpose and boundaries
Key indicators, the distribution of interactions across stages, Excel/JSON exports and PDF
guides. It reads interaction data and changes nothing in it.
It does not: modify stages or cards; it is not the source of truth — that lives in the
interactions module.

## 2. Use cases
- A report by stage and product for a period.
- Role-based filtering: an executive sees everything, a KAM only their own interactions.
- Excel export with correct Cyrillic; JSON export.
- Failure: an empty period → an empty report with an explicit zero, not an error.

## 3. Contract
`/api/reports/*`, `/api/reports/export/*`. Report columns are canonical and shared with the
frontend: `config/report_columns.json` (synchronised by `scripts/sync_report_columns.py`).

## 4. Data
No tables of its own: aggregates are computed from interactions. The aggregate cache is
Redis/KeyDB (`services/report_cache.py`); when the cache is unavailable the computation
happens directly.

## 5. Permissions
The visibility scope of a report depends on the role (`tests/test_report_scope.py`): an
executive sees everything, a KAM only their own. This is enforced by a test, not by
convention.

## 6. Dependencies
Outbound: the database, the cache, the `openpyxl`/`python-pptx` export stack. Inbound:
`api.reports`, the `ReportPage` page.

## 7. Configuration
Redis settings (`REDIS_URL`), export limits. With the cache disabled reports are slower but
still correct.

## 8. Build and debugging
```bash
python -m pytest tests/test_report_columns.py tests/test_report_scope.py -q
python -m pytest tests/test_excel_export_cyrillic.py -q
```

## 9. Tests
`test_report_columns.py` (the canonical column set), `test_report_scope.py` (role →
visibility), `test_excel_export_cyrillic.py` (Cyrillic in Excel), `test_json_export.py`,
`test_pdf_layout.py`, `test_guide_pdf.py`.

## 10. Observability
Cache and export logs; no audit is written (a read operation). Errors: `report_scope_denied`,
`export_failed`.

## 11. Limitations and readiness
- Reports are computed on request: large volumes need the cache.
- There is no ad-hoc report builder.
- Readiness: the visibility scope is covered by a test; Cyrillic does not break in Excel.
