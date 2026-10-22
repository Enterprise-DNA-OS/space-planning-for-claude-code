# Update Floor

Update a supplied planning capacity or evidence reference. Prior approvals become stale.

Read CLAUDE.md first. Read the full record before changing it. Use exact IDs if a name is ambiguous.

```bash
node scripts/spaces.mjs update-floor "<floor>" --capacity=<count> --evidence="<reference>" --actor="<operator>"
```

Use `--json` for precise results. Placeholders must come from supplied facts or record IDs. Do not run placeholder text.

Keep records and drafts private. Do not send messages, approve a move on behalf of a person, or claim a reference proves a building is safe.
