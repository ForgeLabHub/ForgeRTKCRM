# RTK CRM administrator guide

English version of [../ADMIN_GUIDE.md](../ADMIN_GUIDE.md).

## 1. The administrator role

The administrator is responsible for users, reference data, workflow stages and system
availability. Operational actions are performed after checking permissions and business
constraints.

## 2. Users

User management lives in the **Users** section (the "Users" tab). For every user an e-mail, a
name, a role and activity are set. Deactivation closes access without deleting history.

To create a user: fill in the full name, e-mail, password and role, then press "Add". The role
and activity can be changed right in the list; deletion is available for any account except
your own.

The minimum set of roles:

- **KAM** — working with interactions;
- **Executive** — viewing reports, controlling the process and assigning KAMs;
- **Administrator** — settings and reference data.

The executive and the administrator assign the responsible KAM when creating an interaction
and can hand an existing card over to another employee. A KAM works only with their own
interactions: other people's cards are unreachable by direct id.

## 3. Workflow stages

Open **Users** and switch to the **Workflow stages** tab. The constructor shows all stages,
including disabled ones. Every row offers sorting, editing, an activity toggle and deletion.
The **B2B / B2C** switch on the same tab selects the funnel: each has its own set of stages.

![Workflow constructor](../images/08-workflow-constructor.png)

### Enabling and disabling

The toggle works both ways. On error the interface rolls back the optimistic change. A stage
with active interactions cannot be disabled: move the interactions first, or delete the stage
with a target stage selected.

### Renaming and sorting

Change the name in the stage row and confirm the save. To change the order, drag the row by its
drag-and-drop area.

### Deleting with a transfer

Before deleting, the system shows the number of active and of all interactions. If there is
data, choose a target stage. The transfer happens before the source stage is deleted.

## 4. Reference data

The **Directories** section maintains universities, IT directions and IT products. Check the
related data before deleting. Do not put personal data into a comment field without a legal
basis.

![Directories](../images/05-directories.png)

## 5. Import and export

Report export happens on the **Reports** page in XLSX, XLS or PDF. For bulk loading use the
import in the **Directories** section: the dialogue accepts XLS/XLSX and JSON, shows a preview
and offers to map the file columns to the reference-data fields. Make a backup and check the
mapping before starting — rows with errors can be skipped by importing only the valid ones.

![Importing directories from XLSX](../images/06-import-xlsx-mapping.png)

## 6. Integration with LMS and CMS

The **Integration** tab describes the exchange with the customer's external systems. Here the
administrator checks the contract and manages package loading.

Procedure:

1. Open **Integration** and look at the **exchange schema** — the list of contract fields and
   whether each is mandatory.
2. Paste a JSON package into the input field or press **Load sample**.
3. Press **Preview**: the package is validated against the contract without writing to the
   database. This is how the format is checked before a real import (dry run).
4. Press **Import** if the preview showed no errors.

The import is idempotent by `contract_number`: reloading the same package updates the existing
interaction instead of creating a second one. That makes it safe to repeat an exchange after a
network failure.

The tab also builds an **outgoing package** — an export for handing over to the external system
in the contract format.

In the prototype the integration works through a mock adapter: it returns deterministic data
under the same contract. Connecting real LMS and CMS instances is a matter of implementing the
same interface, with no changes to the rest of the system.

![Integration with LMS and CMS](../images/11-integration.png)

## 7. Audit and security

Changes are recorded by the audit middleware (POST/PUT/PATCH/DELETE). The log opens in the
**Journal** section: time, employee, action, entity and IP. Filters by action, entity and
employee are available, sorted from the newest records. During an investigation note the user,
the entity, the time and the operation identifier. Never pass JWTs, passwords or `.env` files
in tickets or repositories.

In a working contour use HTTPS, a restricted CORS policy, JWT/RBAC and minimal database
privileges.

![Audit log](../images/12-audit-log.png)

## 8. Backup

For Yandex Cloud the daily backup is started by `infra/yandex-cloud/backup.sh`. By default the
last 7 days are kept. Verify a restore on a test database from time to time.

## 9. Troubleshooting

**A user cannot sign in:** check that the account is active, the CORS policy and the backend
state at `/api/health`.

**An export does not download:** make sure the request comes from an authorized session and
that the response carries `Content-Disposition`.

**A stage cannot be disabled:** this is protection when active interactions exist.

**Empty charts:** check the data range, stage activity and the response of
`GET /api/reports`.

![Administrative settings](../images/09-settings.png)
