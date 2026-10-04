# `afara generate`

Builds the code wireframe for one feature from your new commits, and saves it locally until you run `afara push`.

```sh
afara generate --feature "<name>" [--commits <ids>] [--since <commit>] [--existing] [--tool <tool>]
```

**Flags:**

| Flag | Description |
| --- | --- |
| `-f`, `--feature <name>` | **Required.** The feature to document. Use a name your team will recognise; it becomes the feature's name on the dashboard. |
| `--commits <ids>` | Generate only these pending commits, comma-separated. Any unambiguous prefix of a commit ID works, as do branch names and other git refs. Without it, Afara asks (in a terminal) or takes them all. |
| `--since <commit>` | Measure the change from this commit or branch instead, and include every commit after it, even ones already generated. |
| `--existing` | Map the feature from the code as it is now, instead of from commits. For features that existed before Afara. Cannot be combined with `--since` or `--commits`. |
| `--tool <tool>` | The local AI tool to use: `claude`, `codex` or `gemini`. Defaults to the first one installed, in that order. |

**Examples:**

```sh
afara generate --feature "card payment"
afara generate --feature "card payment" --commits a1b2c3d,e4f5g6h
afara generate --feature "card payment" --since main
afara generate --feature "card payment" --existing
afara generate --feature "card payment" --tool codex
```

## Which commits it reads

By default, `generate` looks at this branch's **unpushed commits**:

- If the branch has an upstream (or an `origin/<branch>` exists), the unpushed commits are those after it.
- Otherwise, they are the commits since the branch left the default branch (`origin/HEAD`, `origin/main`, `origin/master`, `main` or `master`).
- On the default branch with no upstream, it is the latest commit.

From those, it drops:

- **Commits already generated.** Every commit a `generate` covers is recorded by its ID, and is never offered again, whichever feature it went into. Running `generate` with no new commits does nothing, and tells you which feature the latest commit went into.
- **Commits at or before the baseline** set by `afara init`.

What remains are the *pending* commits.

`--since` overrides all of this: it takes every commit after the commit or branch you name, including ones already generated. Use it to deliberately redo a range.

## Choosing commits for a feature

When **two or more** commits are pending, some of them may belong to a different feature. Afara asks which ones are this feature's:

- **In a terminal**, a picker lists the pending commits, all ticked to start.
- **In the interactive shell**, `/generate` opens the same picker before it runs.
- **With `--commits`**, you choose up front and are not asked.
- **With no terminal** (CI, a pipe), all pending commits are used, with a note suggesting `--commits`.

Picker keys:

| Key | What it does |
| --- | --- |
| `↑` `↓` (or `k` `j`) | Move. |
| `Space` or `x` | Tick or untick the highlighted commit. |
| `a` | Tick all, or untick all when all are ticked. |
| `Enter` | Generate the ticked commits. |
| `Esc`, `q` or `Ctrl+C` | Cancel. Nothing is generated. |

Commits you leave unticked stay pending, ready for the feature they belong to:

```sh
afara generate --feature "card payment"   # tick the payment commits
afara generate --feature "refunds"        # the remaining commits are offered here
```

If you untick everything and press `Enter`, nothing is generated (`No commits chosen, so nothing was generated.`).

## Which files it reads

Afara reads the files the chosen commits touched, **as they are at `HEAD`**, plus whatever code around them the AI tool needs to follow the flow. Only source files count:

- **Included:** `.go`, `.ts`, `.tsx`, `.js`, `.jsx`, `.mjs`, `.vue`, `.svelte`, `.html`, `.py`, `.rb`, `.erb`, `.java`, `.kt`, `.swift`, `.dart`, `.php`, `.cs`, `.rs`, `.ex`, `.exs`, `.graphql`, `.proto`, and `.json`/`.yaml`/`.yml` files that describe an API (paths containing `openapi`, `swagger` or an `api/` directory).
- **Skipped:** tests (`_test.go`, `.test.ts`, `.spec.js`, `_spec.rb`, `__tests__/` and so on), dependencies and build output (`node_modules/`, `vendor/`, `dist/`, `build/`, `.next/`, `coverage/`), fixtures, migrations, type declarations, stories, minified files, lockfiles and `package.json`/`tsconfig.json`.

If the chosen commits touch no source files, nothing is generated (`… touch no source files, so there is nothing to generate`).

## Where the work runs

The wireframe is built **on your machine** by your AI coding tool. Afara:

- creates a temporary checkout of `HEAD`, so your working tree is never touched,
- runs the tool there with no saved session and permission to read only:
  - **Claude Code** runs in restricted mode with only its Read, Grep and Glob tools, and none of your settings, MCP servers or hooks,
  - **Codex CLI** runs `codex exec --sandbox read-only`,
  - **Gemini CLI** runs headless without `--yolo`, so no tool that needs approval can run,
- removes the checkout when it finishes.

If no supported tool is installed, `generate` stops and tells you how to install one. If you name a tool with `--tool` that is not installed, it says so.

If the feature has been generated before, the previous wireframe is given to the tool, so node IDs stay stable across runs.

## Output

```
Reading the 7 files touched by 3 commits (e67658b..0113454) for "card payment" with Claude Code 2.1.0...

card payment  (card-payment, 3 commits: e67658b..0113454)
  2 screens · 9 steps · 3 endpoints · 12 edges
  Labels: ok

Saved locally. Run `afara push` to publish it.
```

- **screens** are pages, views or modals; **steps** are actions and system responses; **endpoints** are steps that call an API; **edges** are the connections between them.
- `N screens inferred: there is no frontend source for them` means the repository has no user-facing code (a backend-only service), so the screens were inferred from its endpoints.
- `Labels: failed` means human-readable names could not be produced. Raw code identifiers stand in for them, and the dashboard shows that the names are not real. Running `generate` again usually fixes it.

The feature you generate becomes the **current feature** for this repository, so `link` and `push` default to it.

## Documenting existing features (`--existing`)

For a feature that was built before you adopted Afara, there are no new commits to read. Use `--existing`:

```sh
afara generate --feature "checkout" --existing
```

Afara gives the AI tool an outline of the repository and asks it to find the feature by name in the code at `HEAD`. Use the name the code uses where you can. If nothing is found, you get `found no code for "checkout" at a1b2c3d; try the name the code uses`.

`--existing` records no commits: your pending commits stay pending.

## Feature names and IDs

The feature ID is derived from the name the first time you generate it: `Card payment with 3-D Secure` becomes `card-payment-with-3-d-secure`. Names are matched without regard to case or extra spaces, so `Card payment` and `card  payment` are the same feature. If the project already has a feature with that name or ID (because a teammate created it), Afara reuses it.

---

[← Afara CLI documentation](README.md)
