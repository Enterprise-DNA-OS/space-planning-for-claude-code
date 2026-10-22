# Create Plan

Create a scenario, optionally copying allocations from another plan. Tasks and approvals do not copy.

Read CLAUDE.md first. Read the full record before changing it. Use exact IDs if a name is ambiguous.

```bash
node scripts/spaces.mjs create-plan --name="<scenario>" --from="<baseline>" --owner="<owner>" --due=YYYY-MM-DD --rationale="<reason>" --actor="<operator>"
```

Use `--json` for precise results. Placeholders must come from supplied facts or record IDs. Do not run placeholder text.

Keep records and drafts private. Do not send messages, approve a move on behalf of a person, or claim a reference proves a building is safe.
