# `afara ship`

Runs `generate`, `push`, `link` and `compare` for one feature, in that order, in a single command.

```sh
afara ship [feature] [--issue <key-or-url>] [--fail-on <kind>] [--commits <ids>] [--since <commit>] [--existing] [--tool <tool>] [--branch <name>]
```

**Arguments and flags:**

| | Description |
| --- | --- |
| `feature` | **Required.** The feature to ship, as an argument or with `--feature`. |
| `-f`, `--feature <name>` | The feature name, instead of the argument. |
| `-i`, `--issue <issue>` | The ticket to link: a key (`PAY-981`), a GitHub issue number (`#418`), or the ticket's URL. Defaults to the ticket the feature is already linked to, then the one the branch is named for. See [Which ticket it links](#which-ticket-it-links). |
| `--system <tracker>` | Which tracker a bare key belongs to: `linear` (default), `github` or `jira`. As for [`link`](link.md). |
| `--commits <ids>` | Generate only these pending commits, comma-separated. As for [`generate`](generate.md). |
| `--since <commit>` | Measure the change from this commit or branch instead. As for [`generate`](generate.md). |
| `--existing` | Map the feature from the code as it is now, not from commits. As for [`generate`](generate.md#documenting-existing-features---existing). |
| `--fail-on <kind>` | Exit with a non-zero status while open findings of this kind exist: `extra`, `missing`, `reordered` or `any`. As for [`compare`](compare.md#--fail-on-and-exit-status). |
| `--tool <tool>` | The local AI tool for `generate` and `compare`: `claude`, `codex` or `gemini`. |
| `--branch <name>` | The branch to push to and compare on. Defaults to the checked-out branch. See [Branches](compare.md#branches). |

**Examples:**

```sh
afara ship "card payment"                          # the ticket comes from an earlier link, the branch, or a list
afara ship "card payment" --issue PAY-981
afara ship "card payment" --commits a1b2c3d,e4f5g6h
afara ship "card payment" --fail-on missing        # CI
```

## What happens

`ship` runs four steps, each under a heading:

```
1/4 generate
…
2/4 push
…
3/4 link
…
4/4 compare
…
```

Each step is the command of the same name with the same flags, so its output is what that command prints on its own.

- **Generate.** With two or more pending commits, a picker asks which belong to the feature first, as with [`generate`](generate.md#choosing-commits-for-a-feature). If you untick every commit, `ship` stops there and nothing is pushed.
- **No new commits** is fine: `ship` pushes the wireframe generated last for the feature. If nothing has ever been generated for it, it stops: `nothing is generated for "card payment", so there is nothing to push`.
- **Compare** fails the run only when `--fail-on` is set, as on its own.

## When a step fails

`ship` stops at the first step that fails and says which:

```
ship stopped at push: feature/card-payment isn't tracked by Shop …
```

The steps before it have already run. Fix the problem and run `ship` again. `generate` skips the commits it already covered, so the run picks up where it stopped.

## Which ticket it links

The first of these wins:

1. `--issue`.
2. The ticket the feature is already linked to. `ship` prints `Already linked to PAY-981 (linear)` and skips linking, so the ticket is not read again.
3. The ticket the branch is named for: on `PAY-981-card-payment`, it links `PAY-981` (`Linking PAY-981, which PAY-981-card-payment is named for`).
4. In a terminal, a list of the project's open tickets to choose from, as with [`link`](link.md#choosing-from-a-list).

If `--issue` names the ticket the feature is already linked to, linking is skipped too.

With no terminal and none of the first three, `ship` stops at link: `which ticket? Pass --issue PAY-981, #418 or a URL, or link one with afara link and ship again`.

## In the interactive shell

`/ship card payment` opens the commit picker first, like `/generate`.

There is no ticket list inside the shell. If neither the branch nor an earlier link names a ticket, `ship` stops at link. The feature is pushed by then, so run `/link` to choose its ticket, then `/ship card payment` again.

To pass a ticket in the shell, use `--feature` and `--issue`: `/ship --feature onboarding --issue PAY-981`. This only works for a one-word feature name, because the shell splits a line that starts with `-` into words. For a longer name, `/link` the ticket first.

## In CI

```sh
afara ship "card payment" --issue PAY-981 --fail-on extra
```

Without a terminal, `generate` uses every pending commit (pass `--commits` to choose), and the ticket must come from `--issue`, an earlier link or the branch name. An invalid `--fail-on` value is rejected before any work starts. See [Using Afara in CI](ci.md).

---

[← Afara CLI documentation](README.md)
