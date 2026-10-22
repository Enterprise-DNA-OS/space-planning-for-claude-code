# Reopen

Return an approved scenario to draft with a reason. A fresh approval will be needed.

Read CLAUDE.md first. Read the full record before changing it. Use exact IDs if a name is ambiguous.

```bash
node scripts/spaces.mjs reopen "<scenario>" --reason="<reason>" --actor="<operator>"
```

Use `--json` for precise results. Placeholders must come from supplied facts or record IDs. Do not run placeholder text.

Keep records and drafts private. Do not send messages, approve a move on behalf of a person, or claim a reference proves a building is safe.
