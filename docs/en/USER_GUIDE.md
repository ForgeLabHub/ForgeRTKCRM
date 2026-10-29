# RTK CRM user guide

English version of [../USER_GUIDE.md](../USER_GUIDE.md).

## 1. Purpose of the system

RTK CRM helps KAMs and executives drive interaction with universities: from the first contact
to controlling the outcome. The system offers a Kanban board, interaction cards, tasks,
comments, files and reports.

## 2. Signing in

The sign-in method depends on the contour the system runs in.

**Single sign-on (Keycloak).** Press **Sign in with Keycloak**. The browser goes to the
corporate sign-in page where you enter your credentials. The password is entered on the
Keycloak side and never reaches the application. After a successful sign-in you return to RTK
CRM already authenticated.

**CRM account sign-in.** If single sign-on is unavailable or the contour runs in local mode,
use the form below the separator: enter your work e-mail and password and press **Sign in**.

If the account is blocked or the password is unknown, contact the administrator. Passwords are
never passed in chats or written into documents.

![Sign-in screen](../images/01-login.png)

## 3. Dashboard and navigation

After signing in the Kanban board opens. The top menu offers:

- **Board** — current interactions by active stage;
- **Reports** — indicators, charts and export;
- **Directories** — universities, products and directions;
- **Help** — this documentation inside the application.

A manager additionally sees the **Integration** tab, and an administrator sees the **Users**,
**Journal** and **Integration** sections. Workflow stage configuration lives inside the
**Users** section on the "Workflow stages" tab and is described in the administrator guide.

Light, dark and "follow the system" themes are switched by a button on the right of the header.

On a mobile screen the menu opens with a three-line button.

![Interaction board](../images/02-kanban-board.png)

## 4. The Kanban board

Each column is an active stage of the process. To move an interaction, drag the card to another
column. On a phone, first choose the stage in the filter, then open the card.

A card shows the university, the product, the assignee and the counters of tasks, comments and
files. Inactive stages are not shown on the board, but the interaction data is preserved.

Above the board are filters: search by university name, product, a date range and stage selection
on a phone. The date range selects interactions by creation date: choose the start and the end
of the period or a ready preset ("Today", "7 days", "30 days", "This month", "Last month",
"Quarter", "Year"). The end of the period is included in full, so interactions created late on
the last day stay in the selection.

![Board filters](../images/04-board-filters.png)

## 5. The interaction card

Open a card with a click. It offers:

- the main details about the university, the product and the contract;
- tasks with dates and completion status;
- comments and the change history;
- attached files.

Changes are saved by the action button in the respective section.

![Interaction card](../images/03-interaction-card.png)

## 6. Creating an interaction

1. Open the board.
2. Press **Add interaction**.
3. Choose the university, the product and the initial stage.
4. Save the form.

Constraint: a university can have no more than two active interactions. If the limit is
reached, the system shows a clear error message.

## 7. Reports and export

The **Reports** page offers KPIs, the distribution by stage, the distribution by product and the
interaction dynamics over 30 days.

The **B2B / B2C** switch selects the funnel: each has its own set of stages, and the report
shows only the selected one. The same choice affects the preview table and all exports.

Press **Export XLSX**, **Export XLS** or **Export PDF**. The file is downloaded through an
authorized request.

![Reports page](../images/07-reports.png)

## 8. AI summary for an interaction

The interaction card has an **AI summary** button. It collects the accumulated history — stage,
tasks, comments — and returns a short recap: which stage the interaction is at, what has been
done and what remains. This saves time when handing a card over to a colleague and when
preparing for a meeting.

The summary is produced by the GigaChat service. If it is not configured, the behaviour depends
on the contour:

- in demo mode a summary assembled from the card fields is returned, with an explicit note that
  the model was not called;
- in production mode without a key the feature answers with error code 503 — which means the
  service is unavailable, not that there is no data.

Pressing again rebuilds the summary from the current state of the card.

![Interaction card](../images/03-interaction-card.png)

## 9. Integration with LMS and CMS

The **Integration** section connects the CRM with the customer's external systems: the learning
platform (LMS) and the website (CMS). The exchange goes in JSON packages under a contract — a
described field schema.

**Inbound flow (import from the LMS).** Paste a package into the input field or press **Load
sample**, then **Preview**. The system validates the package against the contract and shows what
would be imported, without writing to the database. If the check passes, press **Import**.

**Idempotency.** The import relies on `contract_number` — the contract number. Reloading the
same package updates the existing record instead of creating a duplicate. A repeated exchange is
therefore safe.

**Outbound flow (export to the LMS).** The **Export package** button assembles a set of records
for handing over to the external system in the same contract format.

**Exchange schema.** The page shows the structure of the contract: which fields are mandatory
and what they are called. This description is the basis for integrating real systems — the
prototype uses a mock adapter that returns deterministic data under the same contract.

![Integration with LMS and CMS](../images/11-integration.png)

## 10. Cookies and privacy

On the first visit a consent banner appears. You can accept all categories, reject the optional
ones or open **Customise**. Necessary cookies are always enabled. The choice can be changed in
the footer through **Customise cookies**.

The policies are available at `/cookie-policy` and `/privacy`.

## 11. Frequently asked questions

**Why is a stage missing from the board?** The administrator may have disabled it. Check the
workflow settings.

**Why did an export fail?** Check that you are signed in, then repeat the download. On a
repeated failure tell the administrator the time and the file format.

**How do I get access to the directories?** Access depends on the role. Contact the
administrator if the section you need is hidden.

## 12. In-app help

The **Help** section contains this guide, the administrator guide and a description of the
security measures and the architecture. On the left there is a search across sections and a list
of headings: the current section is highlighted while scrolling, and a click jumps to it. For
the user and administrator guides a **Download PDF** button provides a print version.

![The Help section](../images/10-help-docs.png)

The illustrations in the sections above were captured on demo data; they contain no real
personal data.
