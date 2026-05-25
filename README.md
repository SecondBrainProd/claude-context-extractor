# claude-context-extractor

Claude Code plugin marketplace for extracting As-Is business context from meeting transcripts.

## What it does

Drop a meeting transcript into `_inbox/`, run one command in Claude Code, and the plugin:

1. Extracts 8 categories: processes, roles, systems, rules, problems, decisions, terms, open questions.
2. Reads your `glossary.md` for canonical-name resolution; new entities go into a single batched clarification round.
3. Routes results into 19 (or your own) functional folders, handling "general + functional" intersections by producing two paired files.
4. Shows the full plan in Plan Mode — nothing is written without your approval.
5. After approve, writes files into `_review/` for manual relocation into your main knowledge base.
6. A `glossary-steward` sub-agent maintains `glossary.md` with case-insensitive duplicate detection.

Designed originally for a medical-franchise network with 19 functional departments, but the folder list and rules live in plain Markdown (`skills/transcript-router/SKILL.md`) and can be adapted by editing one file.

## Install

In Claude Code:

```
/plugin marketplace add SecondBrainProd/claude-context-extractor
/plugin install context-extractor@claude-context-extractor
```

After install:

- Run `bin/create-workspace.ps1` (Windows) to scaffold the working folder with `_inbox`, `_review`, `glossary.md`, and the functional sub-folders.
- Open Claude Code in that working folder.
- Run `/context-extractor:process-transcript`.

Full per-plugin docs: [plugins/context-extractor/README.md](plugins/context-extractor/README.md).

## License

MIT — see `LICENSE`.
