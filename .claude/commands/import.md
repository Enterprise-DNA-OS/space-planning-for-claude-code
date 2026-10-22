# Import

Read docs/replace-accruent-space-intelligence.md. Inspect headers, preview, reconcile counts, then import on the operator instruction.

Read CLAUDE.md first. Read the full record before changing it. Use exact IDs if a name is ambiguous.

```bash
node scripts/spaces.mjs import asi --file="<buildings.csv>" --dry-run --actor="<operator>"
```

Use `--json` for precise results. Placeholders must come from supplied facts or record IDs. Do not run placeholder text.

Keep records and drafts private. Do not send messages, approve a move on behalf of a person, or claim a reference proves a building is safe.
