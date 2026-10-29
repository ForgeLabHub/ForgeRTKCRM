# RTK CRM pitch — 11 slides

English version of [../pitch.md](../pitch.md).
Format 16:9, the official LCT 2026 template, the Montserrat typeface, the palette `#FF0053` /
`#520977` / `#310F53`. Below is the text version of `RTK-CRM-LCT2026.pptx` for the spoken
defence.

The organisers require slides 7–11 to keep the original template design, so the solution
presentation occupies positions 1–6 and the mandatory block positions 7–11 (those are the
template's slides 7–11 one to one).

## Slide 1 — Detailed description of the solution (01)

- Kanban board: drag-and-drop between stages, search by university, filter by product
- Interaction card: university, product, direction and contract
- Tasks with deadlines and assignees
- Comments, files and the change history
- Stage configuration by the administrator
- Report export to XLSX, XLS, PDF and JSON

**Speech:** The user sees the state of the portfolio on one screen and can immediately update a
stage or record the outcome of a conversation.

## Slide 2 — Technical elaboration (04)

- Frontend: React 18, TypeScript, Vite, Ant Design 5, Zustand, Recharts, dnd-kit
- Backend: Python 3.11, FastAPI, SQLAlchemy 2 async, asyncpg, Pydantic v2, JWT, bcrypt
- Data and infrastructure: PostgreSQL for production, SQLite for a local run, Docker Compose
  and Nginx

**Speech:** Container packaging leaves a clear path to a Russian cloud contour without breaking
the current production.

## Slide 3 — Marketing part (02)

- Need: the interaction status and the agreements are scattered across spreadsheets and chats,
  so deadlines and history get lost
- Promotion and growth: the product is deployed inside Rostelecom as a ready contour and then
  rolled out to divisions with a similar process

**Speech:** What we close is not the absence of data but the absence of a single working context
and of a clear next action.

## Slide 4 — Business part (03)

- One contour instead of spreadsheets and chats
- Transparent stages and assignees
- A report for the executive in seconds, not a day
- A preserved interaction history
- Constraint: no more than 2 active interactions per university
- Indicators: 14 B2B stages, 4 B2C stages, 4 export formats, 2 roles

**Speech:** The effect is measured not by the number of screens but by the time to a management
decision.

## Slide 5 — Uniqueness of the solution (05) and the roadmap

- Configurable workflow: the administrator changes stages, order and colours without code
  changes
- Two funnels in one product: B2B on 14 stages, B2C on 4; the scope is respected in board
  filters, request creation and reports
- Plans: a browser smoke test of the scenarios, Locust load testing on a stand, backup restore in
  CI, confirmation of a data-storage contour in Russia, moving to production after approval

**Speech:** The next steps are separated from an already working product and have a verifiable
outcome.

## Slide 6 — Demonstration, results and contacts

- Kanban board: the portfolio with filters and a B2B/B2C switch
- Reports and export: indicators, distribution by stage, export in 4 formats honouring the
  selected funnel
- Load run (locally): 50 users / 60 s — 1613 requests, 0 errors, p95 — 93 ms; mixed read/write —
  4673 requests, 0 errors, PDF export — 210 ms. Not a production SLA
- Demo: **https://crm-rtk.pixel-minds.ru** — a deployed contour (Yandex Cloud, domain, HTTPS
  Let's Encrypt)
- The repository and a QR code on the slide; contact: sabadaspaha@gmail.com

**Speech:** We are ready to show the path from an interaction card to a management report and to
discuss the further migration.

## Slide 7 — RTK CRM (title slide, the LCT block)

This slide opens the mandatory block of the template (positions 7–11).

- A system for controlling the interaction of the Rostelecom IT School with universities
- Leaders of Digital Transformation 2026, case 6
- A team of 5, Rostov-on-Don
- Repository: github.com/Pavel1778/rtk-crm

**Speech:** RTK CRM turns scattered communication with universities into a single managed
process with transparent stages and assignees.

## Slide 8 — About the team, the solution and its uniqueness

- Captain: Pavel Sabadash, backend and infrastructure
- Members: 5, Rostov-on-Don
- Met at RKSI (Rostov-on-Don) — studied together
- Solution: a CRM from the first contact to the result — Kanban, card, tasks, comments, files and
  reports with export
- Uniqueness: a configurable workflow and separate B2B and B2C funnels

**Speech:** We met at RKSI and came to LCT 2026 as the same team around the IT School task,
building a product that changes together with the process, not after a release.

## Slide 9 — The team

| Member | Role | Telegram |
| --- | --- | --- |
| Pavel Sabadash | Captain, backend and infrastructure | `@Pasha1778` |
| Timofey Kobzev | Frontend and the design system | `@T1mka_Z` |
| Aleksandr Sazonov | Backend, API and integrations | `@saneik_me` |
| Ivan Melnikov | Data, reports and export | `@GooolZZ` |
| Nikita Predkov | QA, documentation and the pitch | `@pretuan` |

**Speech:** Roles were split by strengths, and we worked in iterations with a daily sync. If
there are fewer members than slots on the slide, the extra cards are removed.

## Slide 10 — Team history, motivation and difficulties

- The team formed at RKSI during our studies: backend, frontend, analytics, reports and QA
- We chose the IT School task because it is a real process, not a training case
- The main difficulty: bringing the B2B (14 stages) and B2C (4 stages) funnels together without
  mixing them in filters, request creation and reports
- We worked separately on the layout of the PDF reports and the dark theme contrast

**Speech:** We met at RKSI, studied together and came to LCT 2026 as an established team. The
challenge was not the amount of code but keeping the two funnels separated at every level — UI,
API and reports.

## Slide 11 — The solution in brief

- Technical essence: React 18 + TypeScript + Ant Design; FastAPI, SQLAlchemy 2 async, PostgreSQL
  and JWT
- Role-based access and an audit log of modifying operations
- Marketing essence: the product is rolled out to divisions with a similar process — sales,
  partnerships, work with branches

**Speech:** We chose mature components with a low maintenance threshold and a clear contract
between the UI, the API and the database.
