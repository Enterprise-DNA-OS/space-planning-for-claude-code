# Space Planning for Claude Code

## Business context

Business: [your workplace planning team]. Operator: [your name and role]. Priorities: usable capacity, evidence-backed move decisions and space records the business owns.

Use scripts/spaces.mjs as the one CLI. Read docs/cli.md and docs/compliance.md. All demo businesses, people, counts and evidence references are fictional.

## Recurring work

| Command | Result |
|---|---|
| /space-review | Review allocated people, seats and spare capacity in the active footprint. |
| /buildings | Read the building register and emergency-plan references. |
| /floors | Read floor capacity and the evidence behind it. |
| /departments | Read department headcounts and peak attendance assumptions. |
| /plans | List draft, approved, active and archived scenarios. |
| /plan | Read one scenario with allocations, checks, tasks and notes. |
| /occupancy | Review actual counts from the last thirty days. Missing samples mean unknown. |
| /move-readiness | List scenarios, owners, deadlines and blockers. |
| /compliance | Read docs/compliance.md, then report record checks without claiming legal compliance. |
| /attention | Find overdue scenarios, move tasks and emergency-review dates. |
| /compare | Compare one scenario with the active footprint. |
| /insights | Answer ten questions across allocations, observations and move tasks. |
| /activity | Read mutation history and operator labels. These labels are not authenticated identities. |
| /add-building | Create a building from supplied facts. Import carries no safety approval. |
| /update-building | Record a supplied emergency-plan reference and internal review date. |
| /add-floor | Record capacity supplied by a competent reviewer. Never infer a legal occupancy limit. |
| /update-floor | Update a supplied planning capacity or evidence reference. Prior approvals become stale. |
| /add-department | Record headcount, accountable owner and the peak attendance assumption. |
| /update-department | Update confirmed headcount or peak attendance assumption. Read affected scenarios. |
| /create-plan | Create a scenario, optionally copying allocations from another plan. Tasks and approvals do not copy. |
| /allocate | Set one department allocation in a draft scenario. Read the resulting checks. |
| /unassign | Zero a draft allocation while preserving the record and audit trail. |
| /observe | Record a real count, date, counting method and evidence. Never manufacture sensor output. |
| /add-task | Add a named move task with an owner and deadline. It blocks approval unless explicitly nonblocking. |
| /complete-task | Record completion only after the operator supplies evidence of work done. |
| /approve | Record an explicit human decision with evidence after all checks pass. Never decide approval yourself. |
| /activate | After the operator explicitly chooses the approved scenario, make it active and archive the prior footprint. No physical move or external instruction occurs. |
| /reopen | Return an approved scenario to draft with a reason. A fresh approval will be needed. |
| /log | Add a factual planning note from the operator. |
| /weekly-review | Draft the Monday review from space-review, attention and compliance. Read the draft and present owners and blockers. |
| /draft-move-brief | Draft the proposed change, unresolved checks and move checklist. Present it in chat. Nothing sends. |
| /draft-capacity-review | Draft observed attendance beside allocated seats. Explain sample gaps and preserve the difference between observation and forecast. |
| /import | Read docs/replace-accruent-space-intelligence.md. Inspect headers, preview, reconcile counts, then import on the operator instruction. |
| /export | Export all records, source CSV and audit events to a private, new path. |
| /view | Render the read-only week, move and evidence views. Inspect the files. |
| /documents | Render branded move briefs and capacity records. They remain drafts. |
| /customise | Read the existing schema and workflows. Add a new numbered migration, update CLI and meaningful tests, migrate a trial database, inspect the result, then apply the operator-authorised change. Never rewrite applied migrations. |
| /new-view | Ask the database the requested question, prove the result, then add a read-only SELECT to views.json and render it. Views run in a read-only transaction. Never add action buttons or writes. |

## Operating rules

- Start with the operator's actual request and current records. Never invent headcounts, evidence or approvals.
- A competent person determines usable planning capacity. This code does not calculate fire capacity, design layouts, approve evacuation routes or certify compliance.
- Peak attendance is an explicit department assumption. Actual observations stay separate. No observation means unknown.
- Approval requires complete headcount allocation, sufficient seats, no floor overage, emergency-plan references with current internal review dates, capacity evidence and completed blocking tasks.
- Human approval is a supplied decision. Actor labels are unauthenticated operator labels. A populated reference says nothing about the quality of the referenced assessment.
- Approved scenarios are frozen. Reopen with a reason to edit. Activation rechecks blockers and the approval snapshot. It archives the prior active plan and performs no physical work.
- Read the source and destination before reallocating. Unassign zeroes an allocation and retains its history in the audit record.
- Import ASI building exports with a preview. Original CSV and raw fields are retained. Repeats leave local records intact. Changed source rows stop for reconciliation.
- Keep imports, exports, drafts and rendered output private. Never commit real occupancy or business records.
- DATABASE_URL selects PostgreSQL. Otherwise DATA_DIR selects PGlite. Demo and default tests isolate their data even if a database URL is present.
- TEST_DATABASE_URL is only for an empty disposable test database. Tests refuse a nonempty database.
- RLS denies public access. CLI use requires the database owner. A team installation needs authenticated users, scoped permissions, backup and tested restore controls.
- Local audit records are not tamper-proof. A database owner can bypass application checks. No deletion command or outward send exists.
- Use main. Add numbered migrations for changes. Run npm test. Follow the same .claude/commands recipes with Claude Code, Codex, OpenCode or Cursor.

Omni by Enterprise DNA builds and runs your version: https://enterprisedna.co/omni/book?offer=replace-software&utm_source=github&utm_medium=instructions&utm_campaign=accruent-space-intelligence
