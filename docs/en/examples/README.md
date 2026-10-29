# Sample data from the case holder

The data was provided by the LCT 2026 case holder as format samples for testing the CRM
import features. Working prototype: https://crm-rtk.pixel-minds.ru

## IMPORTANT: the data is anonymised

The `users_b2c.xlsx` file is **deliberately anonymised**: the personal-data fields (SNILS,
passport series and number, issued by and when, department code, registration address, postal
code) are replaced with generated placeholders. This follows Federal Law 152-FZ "On Personal
Data" — a public repository and a demo contour must not hold real personal data.

Rebuilding the anonymised copy from the original:
`python scripts/anonymize_case_data.py <path to "Загрузка пользователей.xlsx">`.
The original is stored outside the repository.

## Files

| File | Purpose | Personal-data status |
| --- | --- | --- |
| `vendors.xlsx` | Catalogue of IT products and vendors | Contacts are test data |
| `payments_b2c.json` | B2C requests: courses for the product catalogue | Names/phones are test data |
| `users_b2c.xlsx` | An individual's questionnaire (accounts) | **Personal data anonymised** |

## How to use it

All three files go through the "Directories" and "Integration" sections:

1. **Vendor catalogue** — `vendors.xlsx` through the UI → Directories → Import, catalogue
   type "Products" (endpoint `POST /api/catalogs/import/preview`). The "Product" column is
   recognised as the name of an IT product.
2. **Course catalogue** — `payments_b2c.json` through the UI → Directories → Import JSON,
   catalogue type "Products" (endpoint `POST /api/catalogs/import/json/preview`). The
   "Course" column also describes an IT product (specification 4.1), so B2C requests fill the
   course catalogue. The file starts with `null` — that service line is skipped.
3. **Accounts** — `users_b2c.xlsx` through the UI → Directories → Import, catalogue type
   "Users". The `Email` column is mandatory; personal-data columns are ignored.

> **Important:** the "Integration" section (mock LMS/CMS) accepts a different contract —
> the mandatory fields `external_id` and `university` (see `GET /api/integration/schema`).
> A B2C request export does not match that contract and is not loaded through "Integration" —
> use item 2 above.

This corresponds to specification section 4.1 (catalogues and import) and to the jury
questions (dialog-based mapping, XLS/XLSX/JSON support) — see `docs/qa-jury.md`.

Verification on the real files: `tests/test_examples_import.py` opens the samples from this
folder and runs them through the same parsers the UI uses.

## API from the case holder

The LMS/CMS API was officially **not provided** (a notice from the LCT 2026 organisers). The
project implements an adapter layer with mock adapters. Switching to real adapters is one line
in the configuration (`INTEGRATION_MODE=real`).

## Sample reports

Next to this file are PDF reports produced by the generator on demo data. They contain no
personal data of real individuals: import fixtures are built in memory by tests
(`tests/test_excel_import.py`, `tests/test_import_report.py`) and use fictitious values.

| File | What it shows |
| --- | --- |
| `report-b2b-2026-09-24.pdf` | A report on interactions with universities for a period |
| `report-longnames-2026-09-24.pdf` | A report with long names: checking column layout |

UI screenshots are in `docs/images/`, the full guides are in `docs/USER_GUIDE.md` and
`docs/ADMIN_GUIDE.md`.
