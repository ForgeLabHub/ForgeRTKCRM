# Architectural diagrams

English version of [../../architecture/README.md](../../architecture/README.md).
The diagrams describe the current contour and the target migration. They are written in
Mermaid and render on GitHub, GitLab and compatible Markdown viewers. The sources are
versioned with the code; a separate PNG/PDF export is not needed for review.

## C4

- [C4 Level 1 — System Context](c4-context.md)
- [C4 Level 2 — Containers / Components](c4-components.md)

## More

- [Functional architecture](functional.md) — the user path from the specification and the
  supporting services.
- [Data model (ER)](er-model.md) — entities, relationships and integrity rules.

## Models in Archi

Requirement 6.7 of the specification asks for a functional and a component architecture in
Archi. All models are ArchiMate 3, open in [Archi](https://www.archimatetool.com/) for free,
and the files sit in the repository next to the Mermaid diagrams.

- [`functional.archimate`](../../architecture/functional.archimate) — the functional model: the KAM user path
  in 5 steps (authorization, browsing, filtering, status update, report) and the supporting
  services. A ready [PDF version](../../architecture/functional.pdf) is included, the Mermaid source is
  [`functional.mmd`](../../architecture/functional.mmd).
- [`rtk-crm.archimate`](../../architecture/rtk-crm.archimate) — the component model: containers, external
  systems and the target deployment.
- [`er.archimate`](../../architecture/er.archimate) — the data (ER) model in ArchiMate 3: 14 domain entities
  and the relationships between them with `ON DELETE` rules. A ready
  [PDF version of the diagram](../../architecture/er-model.pdf) is attached. The Mermaid source is
  [`er.mmd`](../../architecture/er.mmd), rebuild with `python scripts/extract_er_diagram.py`.

## Deployment

- [The main contour in Yandex Cloud](deployment-yandex-cloud.md) — VM, nginx, PostgreSQL,
  Object Storage, KeyDB.
- [The external contour](deployment-current.md) — Vercel → Render → Supabase.

The main contour is Yandex Cloud: data is stored in Russia, as required by Federal Law
152-FZ. The external contour is kept as a public demo stand and is deployed from the same
code without changes.

The full description of the architecture, the stack and the scaling strategy is in
[`ARCHITECTURE.md`](ARCHITECTURE.md).
