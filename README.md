# Space Planning for Claude Code

Your workplace allocations, attendance evidence and move scenarios in a database you own. Free MIT code from Enterprise DNA. Works with Claude Code, Codex, OpenCode or Cursor.

| Do it yourself | We customise it | We run it for you |
|---|---|---|
| Free code. Install and run the demo. Hosting and coding-agent costs are yours. | Your buildings, capacity rules, exports and screens. [Get your version built](https://enterprisedna.co/omni/book?offer=replace-software&utm_source=github&utm_medium=readme&utm_campaign=accruent-space-intelligence). | Installed and operated through Omni by Enterprise DNA. One setup fee, then a retainer. [Book a call](https://enterprisedna.co/omni/book?offer=replace-software&utm_source=github&utm_medium=readme&utm_campaign=accruent-space-intelligence). |

## The workplace planning desk

Run the weekly space review, compare a proposed move, check peak attendance assumptions, chase move tasks and prepare the decision pack. Drafts show over-capacity floors and incomplete assignments. Approval waits until the record checks pass and a person supplies their decision. If inputs change afterwards, activation requires fresh approval.

Accruent lists Space Intelligence Basic at US$10,000 a year and Advanced at US$30,000 a year, both plus headcount costs. These are vendor list prices, not verified customer invoices. [Vendor pricing](https://www.accruent.com/product-pricing), checked 22 October 2026. This base is a focused planning desk. Read [why no front end](docs/why-no-front-end.md) for the boundary around maps, sensors and booking.

## Quick start

Node 20 or newer. The local demo needs no database server.

```bash
git clone https://github.com/Enterprise-DNA-OS/space-planning-for-claude-code.git
cd space-planning-for-claude-code
npm install
npm test
npm run demo
```

All people, offices, counts and evidence references are fictional. The demo includes a proposed floor over capacity, insufficient seats for one team's peak assumption, an overdue accessibility task and an office with no recent attendance sample. Demo data lives in .data/demo and output in .data/demo-output, isolated even when DATABASE_URL is set.

For further demo questions set DATA_DIR=.data/demo in Bash, or $env:DATA_DIR='.data/demo' in PowerShell. Use a fresh directory and npm run migrate for real records. Never seed a real business database. [CLI reference](docs/cli.md).

## The weekly rituals

| Command | Result |
|---|---|
| /space-review | Active footprint, people, seats and capacity. |
| /occupancy | Actual attendance counts, sample dates and gaps. |
| /compare | Proposed seats beside the current footprint. |
| /move-readiness | Scenario deadlines, owners and blockers. |
| /compliance | Evidence references and planning exceptions. |
| /weekly-review | Monday review from current space, attention and checks. |
| /draft-move-brief | Proposed changes, decisions and move checklist. |
| /customise | Your fields and rules through a tested migration. |
| /new-view | Another read-only answer in your business brand. |

39 recipes live in .claude/commands and route through one CLI. All mutations have an actor label and an audit record. They send nothing. See CLAUDE.md for the full routing table.

## Ten questions across the records

1. Which draft scenarios exceed floor capacity?
2. Which departments have fewer seats than their peak attendance assumption?
3. Which occupied floors lack a recent observation?
4. Which plans depend on an overdue emergency-plan review?
5. Which owners have overdue blocking move tasks?
6. Which floors have spare assigned seats and low observed attendance?
7. Which scenarios do not account for every department headcount?
8. Which move scenarios have no note in the last fourteen days?
9. Which recorded observations exceed the floor capacity?
10. Which imported buildings still need a floor register and emergency reference?

Every question is implemented by the insights command and runs on the demo today. These are connected questions you can own and adapt. They are not a claim that a configured incumbent report can never answer them.

## Your first hour: ten things to ask for

1. Show the current footprint by building and floor.
2. Explain the Harbour consolidation blockers.
3. Compare that proposal with the active footprint.
4. Show which attendance counts are missing or old.
5. Draft the Monday space review.
6. Draft the move brief with named task owners.
7. Import my building export after a trial run.
8. Add our floor capacity and its review reference.
9. Add our workplace coordinator field through a migration.
10. Add a read-only view of overdue tasks by owner.

## Records and review packs

npm run view renders the week, move-readiness and evidence dashboards. npm run docs renders draft move briefs and workplace capacity records. Set the business name, logo and colours in brand.json. Outputs are read-only HTML with no action buttons or server.

[Compliance checks](docs/compliance.md) cite New Zealand emergency-plan and workplace-facilities sources. They check recorded references and internal planning rules. A competent person must assess the actual workplace. No code here calculates legal fire capacity or certifies a move. Peak attendance assumptions and observed counts remain separate.

## Bring the building register across

ASI documents CSV export from Facilities. One command imports the building register, retaining original CSV, raw fields and source identity. It supports mapped headers, validates the full batch, previews without saving, and refuses changed source rows until reconciled. The fixture uses documented field labels and fictional data, not a customer export.

```bash
node scripts/spaces.mjs import asi --file="imports/asi/buildings.csv" --dry-run --actor="Workplace planner"
```

Floors, allocation scenarios, sensor history, drawings and approvals need separate reconciliation. A building import is not a complete enterprise migration. [Switching guide](docs/replace-accruent-space-intelligence.md).

## Storage and verification

Plain PostgreSQL migrations also run on PGlite. UUIDs, foreign keys, timestamps and uniqueness constraints support the record model. Mutations serialize through database locks. RLS denies public access; the CLI operates as database owner. Shared production use needs authenticated access, scoped permissions, backup and tested restore. Actor labels and audit history are not tamper-proof signatures.

npm test uses temporary local data and output, exercises the reads and writes, and proves approval gates, stale-input detection, rollback, repeat imports, source preservation, drafts and escaped HTML. To test PostgreSQL, point TEST_DATABASE_URL only at an empty disposable database. Tests refuse a nonempty public schema. CI runs PGlite on Linux and Windows with Node 20 and 22, plus PostgreSQL 16. See Actions for actual platform results.

## Licence

MIT. Copyright (c) 2026 Enterprise DNA. Accruent and Accruent Space Intelligence belong to their owners. This independent project is not affiliated with or endorsed by Accruent.
