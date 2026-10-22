# CLI reference

Run node scripts/spaces.mjs help for names. Every read accepts --json. Every mutation requires --actor. Use exact IDs, unique ID prefixes or case-insensitive names. Ambiguous matches list candidates and exit 1.

Set DATA_DIR to a private directory for local PGlite or DATABASE_URL for PostgreSQL. Bash: `export DATA_DIR=/private/path`. PowerShell: `$env:DATA_DIR='C:\private\path'`. Run npm run migrate before real imports. Demo runs in .data/demo regardless of DATABASE_URL. All dates use YYYY-MM-DD and calendar comparisons use UTC.

## Read

buildings, floors, departments, plans, space-review, occupancy, move-readiness, compliance [plan], attention, insights and activity.

plan <plan> reads its whole history. compare <plan> compares the proposal with the active footprint, or use --from=<plan>. occupancy shows only samples from the last thirty days and includes sample counts. It does not treat missing data as zero or extrapolate a full week's utilisation from a handful of counts.

## Write

`node scripts/spaces.mjs add-building --name="<name>" --owner="<owner>" --actor="<operator>"`

Create a building from supplied facts. Import carries no safety approval.

`node scripts/spaces.mjs update-building "<building>" --emergency="<reference>" --review-due=YYYY-MM-DD --actor="<operator>"`

Record a supplied emergency-plan reference and internal review date.

`node scripts/spaces.mjs add-floor --building="<building>" --name="<floor>" --capacity=<count> --evidence="<reference>" --actor="<operator>"`

Record capacity supplied by a competent reviewer. Never infer a legal occupancy limit.

`node scripts/spaces.mjs update-floor "<floor>" --capacity=<count> --evidence="<reference>" --actor="<operator>"`

Update a supplied planning capacity or evidence reference. Prior approvals become stale.

`node scripts/spaces.mjs add-department --name="<team>" --headcount=<count> --peak=<percent> --owner="<owner>" --actor="<operator>"`

Record headcount, accountable owner and the peak attendance assumption.

`node scripts/spaces.mjs update-department "<team>" --headcount=<count> --peak=<percent> --actor="<operator>"`

Update confirmed headcount or peak attendance assumption. Read affected scenarios.

`node scripts/spaces.mjs create-plan --name="<scenario>" --from="<baseline>" --owner="<owner>" --due=YYYY-MM-DD --rationale="<reason>" --actor="<operator>"`

Create a scenario, optionally copying allocations from another plan. Tasks and approvals do not copy.

`node scripts/spaces.mjs allocate "<scenario>" --floor="<floor>" --department="<team>" --people=<count> --seats=<count> --actor="<operator>"`

Set one department allocation in a draft scenario. Read the resulting checks.

`node scripts/spaces.mjs unassign <allocation-id> --actor="<operator>"`

Zero a draft allocation while preserving the record and audit trail.

`node scripts/spaces.mjs observe "<floor>" --date=YYYY-MM-DD --present=<count> --method="<method>" --evidence="<reference>" --actor="<operator>"`

Record a real count, date, counting method and evidence. Never manufacture sensor output.

`node scripts/spaces.mjs add-task "<scenario>" --name="<task>" --owner="<owner>" --due=YYYY-MM-DD --actor="<operator>"`

Add a named move task with an owner and deadline. It blocks approval unless explicitly nonblocking.

`node scripts/spaces.mjs complete-task <task-id> --evidence="<reference>" --actor="<operator>"`

Record completion only after the operator supplies evidence of work done.

`node scripts/spaces.mjs approve "<scenario>" --evidence="<decision reference>" --actor="<approver>"`

Record an explicit human decision with evidence after all checks pass. Never decide approval yourself.

`node scripts/spaces.mjs activate "<scenario>" --actor="<operator>"`

After the operator explicitly chooses the approved scenario, make it active and archive the prior footprint. No physical move or external instruction occurs.

`node scripts/spaces.mjs reopen "<scenario>" --reason="<reason>" --actor="<operator>"`

Return an approved scenario to draft with a reason. A fresh approval will be needed.

`node scripts/spaces.mjs log "<scenario>" --note="<note>" --actor="<operator>"`

Add a factual planning note from the operator.

add-building also accepts --region and --tenure=leased|owned|unknown. add-floor accepts integer --area in square metres. add-task accepts --blocking=false only for an explicitly nonblocking task. create-plan --from copies allocations, never tasks or approvals. unassign keeps a zero allocation and its history.

Each allocation records people assigned and seats reserved. Required seats are ceil(people * department peak percent / 100), calculated separately per allocation. Splitting a department across floors therefore rounds up each part. Sum people must exactly equal the department headcount. Drafts may be incomplete or exceed capacity so the comparison can show why a proposal fails. Approval and activation reject those exceptions.

weekly-review, draft-move-brief <plan>, draft-capacity-review write Markdown under drafts. npm run view and npm run docs render branded read-only HTML under views and docs-out. OUTPUT_DIR overrides the private output root. The renderer escapes record text. Keep brand.json under trusted operator control.

import asi --file=<csv> --dry-run --actor=<operator> previews a building import. --map=<json> maps vendor labels. See the replacement guide for the exact migration boundary. export --file=<new-path> writes all data as JSON and refuses to overwrite an existing file. Without --file it prints all data, so choose the destination deliberately.

Mutations use one database transaction and serialize writes through table locks. Actor labels and audit events are local records, not an identity service. Use backups and production identity controls for a shared installation. Do not run multiple PGlite processes against one data directory.
