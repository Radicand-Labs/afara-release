# Troubleshooting

| Message | What to do |
| --- | --- |
| `not signed in. Run afara auth login first` | Run `afara auth login`. |
| `Afara rejected the saved key. Run afara auth login to sign in again` | Your key has expired or been revoked. Sign in again. |
| `not inside a git repository` | Run the command from inside the repository the feature lives in. |
| `this repository has no origin remote` | Add a GitHub `origin` remote. Afara uses it to find the project. |
| `no Afara project for owner/name` | Create the project in the dashboard (**Projects → New project**) for that repository. |
| `note: uncommitted changes are not sent` | Informational. Commit the work you want Afara to see. |
| `Every commit on this branch is pushed, so there is nothing to generate` | Commit new work, or use `--since` to redo a range, or `--existing` to map existing code. |
| `Every unpushed commit has been generated: a1b2c3d went into "…"` | Nothing new to generate. Commit more work first. |
| `… is not a pending commit: it is already generated, pushed, before the baseline, or not on this branch` | Check the IDs passed to `--commits`. Use `--since` to include generated commits on purpose. |
| `… is not installed. Install it with: …` | `afara model <tool>` only accepts an installed tool. Install it first, or pick another. |
| `generate needs an AI coding tool on this machine, and none is installed` | Install Claude Code, Codex CLI or Gemini CLI, sign in to it, and run again. |
| `found no flow in …` / `found no code for "…"` | The tool found nothing that forms a user-facing flow. For `--existing`, try the name the code uses for the feature. |
| `note: "…" is a new feature. Did you mean "…"?` | The name is close to an existing feature's. Features are matched by exact name, so this started a new one. If you meant the existing feature, generate again with its name (using `--since` to take the commits again). |
| `note: N earlier commits of "…" not in this branch's history` | Commits generated for the feature before were rebased away or made on another branch. The wireframe is built without them. |
| `can't tell which branch this is: HEAD is detached` | Pass `--branch <name>` to `push` or `compare`. On GitHub Actions the branch is read from `GITHUB_HEAD_REF` or `GITHUB_REF_NAME`. |
| `<branch> isn't tracked by <project>` | Track the branch in the dashboard (**Settings → Branches**), or switch to a tracked branch. Your plan limits how many branches can be tracked. |
| `"…" isn't pushed to <branch> yet` | Features are kept per branch. Generate and push the feature on this branch before comparing. |
| `No patterns apply to owner/name` | No pattern names this repository, and none applies to every repository. `afara patterns --all` lists every one; owners add patterns in the dashboard. |
| `--all lists every pattern, so it takes no --repo` | Use one or the other. |
| `it has an Afara start marker but no end marker` (or the reverse) | Part of the block `afara inject` writes was deleted by hand. Remove the rest of the block, then run `afara inject` again. |
| `nothing generated for <id> yet` | Run `afara generate --feature "<name>"` before `push`. |
| `no feature selected` | Pass `--feature`, or run `generate` first so there is a current feature. |
| `<id> isn't on the dashboard yet. Run afara push before linking a ticket` | Push the feature, then link. |
| `which ticket? Pass --issue PAY-981, #418 or a URL` | There is no terminal to show the ticket list. Pass `--issue`. |
| `"…" has no ticket to compare against` | Link one with `afara link --feature "<name>"`. |
| `"…" has no pushed code wireframe` | Run `afara push "<name>"`. |
| `ticket … could not be found; it may have been deleted or moved` | Link the current ticket with `afara link`. |
| `The story is too thin to compare` | Add the screens the user sees, what they do, and what happens on success and failure to the ticket, then run `compare` again. |
| `Could not reach the clipboard` | On Linux, install `xclip` or `xsel`. |
| `Sign-in … timed out` | Finish signing in within 2 minutes, or run `afara auth login` again. |
| A push is blocked and you need it through now | `git push --no-verify` skips the check once. |

---

[← Afara CLI documentation](README.md)
