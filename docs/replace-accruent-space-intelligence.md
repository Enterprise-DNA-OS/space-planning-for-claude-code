# Bring your Accruent Space Intelligence building register

The vendor documents CSV export from the Facilities lists. This importer brings the building register across in one command. It does not claim that ASI exposes a single complete export of floor plans, allocation scenarios, badge events or approval history.

## Export and trial

1. In ASI, open Facilities > Buildings. Clear filters and inspect the columns and pagination. Use Export. Keep the original CSV privately.
2. Inspect the header row. The importer accepts Name, UUID or Id, Region, Leased / owned, Show and any additional columns. Headers are case-insensitive. UUID is optional. Without it, the building name is the source identity, so renaming needs reconciliation.
3. Select a fresh local DATA_DIR or an empty trial database. Run npm run migrate. Never seed real records.
4. Run the preview, reconcile the building count and names, then repeat without --dry-run to commit.

```bash
node scripts/spaces.mjs import asi --file="buildings.csv" --dry-run --actor="Workplace planner"
node scripts/spaces.mjs import asi --file="buildings.csv" --actor="Workplace planner"
```

The sample imports/asi/buildings.csv is fictional and follows documented field labels. It is not a captured customer export. The documentation does not guarantee every exported column label. Inspect yours and use --map="mapping.json" if labels differ:

```json
{"name":"Building label","id":"Identifier","region":"Region","tenure":"Ownership","visible":"Visible"}
```

Only provide mappings for columns your export has. Visibility accepts Show/Hide, true/false, yes/no or 1/0. Missing tenure remains unknown. Extra columns, including vendor timestamps, are preserved in the original row. They do not overwrite local timestamps or safety evidence.

## What carries over

Building name, region, ownership and visibility populate the local register. Source IDs stay text, including leading zeros. Original CSV, original row fields, file digest and actor label are retained. Every import is one transaction. Duplicate keys, invalid fields or any conflicting row abort the batch. Repeat imports do not overwrite local owner or review evidence. A changed source row stops for deliberate reconciliation rather than silently replacing work.

## Finish the planning baseline

Reconcile floors, capacities, department headcounts and allocation scenarios against source records separately. Use add-floor, add-department, create-plan and allocate with the operator's confirmed data. Source drawings, sensor history, employee identifiers, integrations and historical approvals are separate migration work. Imported buildings have no assumed emergency-plan evidence or floor capacity. They cannot supply an approved move until those records exist and pass the local checks.

The one-day promise applies to the building-register import and a bounded, reconciled baseline. A full enterprise platform migration needs a scoped cutover. Keep the old system until totals, evidence, floor references and a restore test are accepted. Export all local records with export --file=<new-private-file.json>. That JSON preserves every domain record and source row; PostgreSQL/PGlite backups and restores remain a separate operational procedure.

Sources checked 22 October 2026:

- [ASI buildings and CSV export](https://help.accruent.com/asi/content/configuration/buildings.htm).
- [ASI floors and capacity fields](https://help.accruent.com/asi/content/configuration/floors.htm).
- [ASI allocation fields](https://help.accruent.com/asi/content/user_guide/assign_allocate_plans.htm).
