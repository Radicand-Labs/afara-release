# `afara inject`

Writes the architecture patterns that apply to this repository into the instruction file your AI coding tool reads at the start of every session. The tool then follows your company's rules while it writes code here.

```sh
afara inject                  # the file of the AI tool you use
afara inject --tool codex     # a particular tool's file
afara inject --all-tools      # the file of every installed tool
afara inject --remove         # take the patterns out again
```

**Flags:**

| Flag | Description |
| --- | --- |
| `--tool <tool>` | Write this tool's file: `claude`, `codex` or `gemini`. The tool does not need to be installed, so you can write a file for teammates who use a different one. |
| `--all-tools` | Write the file of every AI tool installed on this machine. Cannot be combined with `--tool`. |
| `--remove` | Take the patterns out of the file instead of writing them. Does not need you to be signed in. |

Without `--tool` or `--all-tools`, Afara writes the file of the tool you use: the one chosen with [`afara model`](model.md), or else the first one installed.

## Which file

The file is written at the root of the repository:

| Tool | File |
| --- | --- |
| Claude Code | `CLAUDE.md` |
| Codex CLI | `AGENTS.md` |
| Gemini CLI | `GEMINI.md` |

## What it writes

The patterns are the ones [`afara patterns`](patterns.md) lists for this repository: those that name it, and those that apply to every repository. They go in a marked block, enterprise patterns first:

```markdown
<!-- afara:patterns:start (managed by `afara inject`; run it again to update, edits here are overwritten) -->
## Architecture patterns

These are the organisation's architecture rules for this repository (acme/checkout), from Afara. Follow them when you write or change code here; if a change cannot follow one, say so and why.

### Hexagonal architecture (enterprise pattern)

- Domain code imports nothing from infrastructure
- Adapters depend on ports

### Payments service rules (service pattern)

- Every charge is idempotent on a client-supplied key, so a retried request never charges twice.
<!-- afara:patterns:end -->
```

- If the file does not exist, it is created holding just the block.
- If it exists, the block is added at the end. Everything else in the file is left as it is.
- Running `inject` again **replaces only the block**, so it is safe to run whenever the patterns change. If nothing changed, the file is not touched (`already up to date`).
- Do not edit inside the block: your changes are overwritten on the next run. Edit the patterns in the dashboard instead.

## Removing the patterns

`afara inject --remove` takes the block out, along with the blank line before it. If the file held nothing but the block, the file is deleted.

If no patterns apply to the repository any more, a plain `afara inject` also removes an old block, and says there is nothing to inject.

## Output

```
CLAUDE.md (Claude Code): wrote 2 patterns.
AGENTS.md (Codex CLI): already up to date.

Commit CLAUDE.md so everyone's AI tool gets the same rules. Run `afara inject` again when the patterns change.
```

**Commit the file.** That way everyone who works in the repository, and every AI tool run in CI, gets the same rules.

## Notes

- Run it inside the repository. It must have an `origin` remote on GitHub, which is how Afara knows which patterns apply.
- You must be signed in, except for `--remove`.
- If the block's start or end marker has been deleted by hand, `inject` stops rather than guess (`it has an Afara start marker but no end marker`). Remove the rest of the block by hand, then run it again.
- In the interactive shell, use `/inject`, with the same flags: `/inject --all-tools`.

---

[← Afara CLI documentation](README.md)
