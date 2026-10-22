# Add Task

Add a named move task with an owner and deadline. It blocks approval unless explicitly nonblocking.

Read CLAUDE.md first. Read the full record before changing it. Use exact IDs if a name is ambiguous.

```bash
node scripts/spaces.mjs add-task "<scenario>" --name="<task>" --owner="<owner>" --due=YYYY-MM-DD --actor="<operator>"
```

Use `--json` for precise results. Placeholders must come from supplied facts or record IDs. Do not run placeholder text.

Keep records and drafts private. Do not send messages, approve a move on behalf of a person, or claim a reference proves a building is safe.
