# `afara layers`

Shows which layer of the product this repository's project is, links the projects that are its other layers, and writes down what a linked layer expects of this one.

```sh
afara layers
afara layers list [--layer <layer>]
afara layers link <layer> [project]
afara layers unlink <layer>
afara layers context [feature] [--from <layer>] [--pull] [--source-branch <name>] [--tool <tool>] [--branch <name>]
afara layers context [feature] --clear [--from <layer>]
afara layers context [feature] --list
```

## Layers

Each project is one layer of the product: `frontend`, `backend`, `fullstack`, `mobile`, `cli`, `library` or `other`. A project's own layer is set in the dashboard (**Settings → Layer**). Projects created before layers existed have none until someone sets it.

A project can link other projects as its layers, so a backend knows which web app and which mobile app it serves. A link names one of `frontend`, `backend`, `mobile`, `cli` or `library`, and each layer holds at most one project.

A `fullstack` project counts as both a frontend and a backend. A project with no layer, or with `other`, never counts as any layer.

## `afara layers`

Shows this repository's project, its layer, and the projects linked to it.

```sh
afara layers
```

**Output:**

```
Shop API  (shop-api, backend)

  frontend  Checkout Web (checkout-web)  acme/checkout-web  linked 2026-10-02 by dana
  mobile    Shop App (shop-app)          acme/shop-app      linked 2026-10-05 by dana

Linked from (usable with `afara layers context --from <layer>`):
  frontend  Admin (admin)  acme/admin

Working with (local context):
  card payment  frontend  from Checkout Web @ e67658b  .afara/context/card-payment.frontend.md
  Checkout Web has pushed "card payment" since e67658b (now 7d370da). Update: afara layers context "card payment" --from frontend

Not linked: cli, library. Link one with `afara layers link <layer>`.
```

- The first line is the project's name, then its slug and layer. With no layer set, a line below it says to set one in the dashboard.
- Each linked layer shows the linked project, its repository, and when and by whom it was linked.
- **Linked from** lists the projects that linked this one as one of their layers, and what each is to this project. A link works from either side, so these can be read with [`afara layers context`](#afara-layers-context) too. The section only appears when there are such links.
- **Working with** lists the context files in this checkout, as [`afara layers context --list`](#listing-your-local-contexts) does. For each one, Afara asks the dashboard whether the other project has pushed the feature since the context was built, and if it has, prints the command that updates it. If the dashboard can't be reached, or the other project can't be read, the check is skipped and `afara layers` still succeeds. The section only appears when there are context files.
- **Not linked** lists the layers with nothing linked. The project's own layer is left out: a backend is not offered a backend, and a fullstack project is offered neither a frontend nor a backend.

## `afara layers list`

Lists every project you can see, with its layer.

```sh
afara layers list [--layer <layer>]
```

| Flag | Description |
| --- | --- |
| `--layer <layer>` | Only the projects that can be this layer: `frontend`, `backend`, `mobile`, `cli` or `library`. A `fullstack` project matches both `frontend` and `backend`. |

**Examples:**

```sh
afara layers list
afara layers list --layer frontend
```

**Output:**

```
LAYER      PROJECT       SLUG          REPOSITORY
backend    Shop API      shop-api      acme/shop-api
frontend   Checkout Web  checkout-web  acme/checkout-web
fullstack  Admin         admin         acme/admin
mobile     Shop App      shop-app      acme/shop-app
no layer   Legacy        legacy        acme/legacy
```

Projects are grouped by layer, then sorted by name. Projects with no layer come last.

`list` needs you to be signed in, but not to be in a repository. Use it to find the slug to pass to `link`.

## `afara layers link`

Links another project as one of this project's layers. Only project owners can link.

```sh
afara layers link <layer> [project]
```

| | Description |
| --- | --- |
| `layer` | **Required.** `frontend`, `backend`, `mobile`, `cli` or `library`. |
| `project` (optional) | The slug of the project to link. Without it, Afara offers the projects that can be that layer. |

**Examples:**

```sh
afara layers link frontend checkout-web
afara layers link frontend                # choose from the projects that can be a frontend
```

**Output:**

```
Linked Checkout Web as Shop API's frontend (acme/checkout-web)
```

- **Without a slug**, a terminal shows a numbered list of the projects that can be that layer, leaving out this project. Type a number or a slug. With no terminal (CI, a pipe, or the interactive shell), the list is printed with a reminder to pass the slug, and nothing is linked.
- **Linking a layer that is already linked** replaces the project linked there.
- If no other project can be that layer, `link` stops: `no other project is a mobile. Set a project's layer in the dashboard, then link it`.
- The dashboard checks every link. Linking a project to itself, linking the project's own layer, or linking a project whose layer does not fit is refused, and Afara prints the dashboard's reason.
- If you are not an owner of the project: `only a project owner can change its layers`.

## `afara layers unlink`

Removes the project linked as one of this project's layers. Only project owners can unlink.

```sh
afara layers unlink <layer>
```

**Example:**

```sh
afara layers unlink frontend
```

**Output:**

```
Unlinked Shop API's frontend
```

## `afara layers context`

Reads the code wireframe a linked project pushed for a feature, and checks it against this repository. Run it in a backend to see what the frontend calls: each endpoint, the fields it sends and reads, and whether this code serves it yet. The result is markdown, stored on the feature for your teammates and the dashboard, and written into your checkout as a local working file that your AI tool is pointed at while you build the feature.

```sh
afara layers context [feature] [--from <layer>] [--pull] [--source-branch <name>] [--tool <tool>] [--branch <name>]
```

```sh
afara layers context [feature] --clear [--from <layer>]
afara layers context [feature] --list
```

| | Description |
| --- | --- |
| `feature` | The feature, as an argument or with `--feature`. Defaults to the current feature (the last one worked on). |
| `-f`, `--feature <name>` | The feature name, instead of the argument. |
| `--from <layer>` | The linked layer to read: `frontend`, `backend`, `mobile`, `cli` or `library`. Without it, every linked layer that has pushed the feature is read, each into its own file. |
| `--pull` | Download the stored context instead of writing it. No AI runs. Cannot be combined with `--tool` or `--source-branch`. |
| `--clear` | Remove the feature's local context files and the AI tool's pointer to them. With `--from`, only that layer's. The copy on the server stays. Takes no other flag except `--from` and `--feature`. See [Clearing it when you're done](#clearing-it-when-youre-done). |
| `--list` | Show the context files in this checkout and where each came from. With a feature, only that feature's. Takes no other flag. See [Listing your local contexts](#listing-your-local-contexts). |
| `--source-branch <name>` | The linked project's branch to read. Defaults to its default branch. |
| `--tool <tool>` | The local AI tool to use: `claude`, `codex` or `gemini`. As for [`generate`](generate.md). |
| `--branch <name>` | This project's branch to store the context on. Defaults to the checked-out branch. See [Branches](compare.md#branches). |

**Examples:**

```sh
afara layers context "card payment" --from frontend
afara layers context "card payment"                    # every linked layer that pushed the feature
afara layers context "card payment" --pull             # download the stored copy
afara layers context "card payment" --clear            # the feature is done: remove the local copy
afara layers context --list                            # the contexts in this checkout
afara layers context "card payment" --from mobile --source-branch release/2.4
```

### What it needs

- The layer is **linked**, from either side: this project linked it with [`afara layers link`](#afara-layers-link), or the other project linked this one. This project's own links come first. With `--from` and no such link, it stops: `no frontend is linked to Shop API. Link one with afara layers link frontend`.
- If several projects that can be that layer linked this one, and this project linked none of them, Afara can't tell which to read. It lists them and asks you to choose with `afara layers link <layer> <slug>`.
- The linked project has **pushed** the feature, with a code wireframe. Afara finds the feature there by its ID, or else by its name. With `--from`, a layer that has not pushed it is an error. Without `--from`, that layer is skipped with a note, and the command fails only if no linked layer has pushed it.
- This branch is **tracked** by the project. This is checked before the AI tool runs, so an untracked branch costs nothing.
- Read access to the linked project, and an AI coding tool installed, as for `generate`.

### What happens

1. Afara fetches the linked project's feature and its pushed code wireframe.
2. Your AI tool is given that graph: the screens and steps in flow order, and each endpoint with the fields it sends and reads. It runs in a read-only checkout of `HEAD`, as `generate` does, and searches this repository for the handlers that serve those endpoints.
3. The markdown is written to `.afara/context/<feature-id>.<layer>.md`, for example `.afara/context/card-payment.frontend.md`.
4. The same markdown is stored on this project's feature, for this branch.
5. The local file is kept out of git, and your AI tool is pointed at it. See [Keeping it local](#keeping-it-local).
6. Where the file came from is recorded in `.git/afara/state.json`: the feature and layer, the other project with the branch and commit it was built from, the commit of this repository it was checked against, when it was written, and whether it was built here or pulled. `--list` and `afara layers` read this record.

```
Reading Checkout Web's "card payment" (14 nodes) against Shop API at 0113454 with Claude Code 2.1.0...
Wrote .afara/context/card-payment.frontend.md
Stored on Shop API's card-payment (feature/card-payment)
Pointed CLAUDE.local.md at it
Clear it when the feature is done: afara layers context --clear
```

Running it again rewrites the file and the stored copy. Edits made to the file by hand are overwritten.

The stored context is limited to 256 KB. Anything larger is refused before it is uploaded.

### The context file

A header says where the context came from: the linked project, its repository, the commit (and branch) it pushed, and the commit of this repository it was checked against. Then the AI tool writes four sections:

| Section | What it holds |
| --- | --- |
| **Screens** | Each screen of the linked layer, in the order a user meets them, and the endpoints it calls. |
| **Endpoints** | A table of every endpoint, in the order the linked layer calls them: where it is called from, the fields it sends and reads, and **Here**. **Here** is the `file:line` of the handler in this repository that serves it, `to build` if there is none, or the handler followed by `missing: <fields>` when it does not return a field the other layer reads. |
| **To build** | A checklist of what this repository must add or change, most important first. |
| **Notes** | Anything the table cannot hold, such as an order the calls depend on or an endpoint served at a different path. Left out when there is nothing. |

### Keeping it local

The local file is a working aid for the feature you are building, not part of the repository. The copy your teammates and the dashboard use is the one on the server.

- **Kept out of git.** Afara adds `/.afara/context/` to `.git/info/exclude`. That file applies to your clone only, so your `.gitignore` is not touched.
- **Your AI tool is pointed at it.** Afara adds a marked block to the instruction file of the AI tool in use. The block lists each context file in the checkout and tells the tool to read the one for the feature it is changing.

| AI tool | File |
| --- | --- |
| Claude Code | `CLAUDE.local.md` |
| Codex CLI | `AGENTS.md` |
| Gemini CLI | `GEMINI.md` |

The block is kept up to date in any of these files that already has it, so switching tools doesn't leave a stale list behind.

Codex and Gemini have no local-only instruction file, so their block goes in `AGENTS.md` or `GEMINI.md`, which are usually committed. Don't commit the block: clear it when the feature is done. Afara does not add `CLAUDE.local.md` to git's exclude file either, so if your repository doesn't ignore it, keep it out of commits too.

### Clearing it when you're done

```sh
afara layers context "card payment" --clear
afara layers context "card payment" --clear --from frontend
```

```
Removed .afara/context/card-payment.frontend.md
Updated CLAUDE.local.md
```

`--clear` removes the feature's context files (with `--from`, only that layer's) and updates the AI tool's block to match. When no context files are left, the block is removed, and an instruction file that held only the block is deleted. An empty `.afara/` directory is removed too.

`--clear` also removes the files' records from `.git/afara/state.json`. It only touches local files: it needs no sign-in and no network, and the copy on the server stays. Without a feature name it clears the current feature's files.

### Fields sent and read

The **Sends** and **Reads** columns come from the linked project's code wireframe. `generate` records them on each endpoint when the code shows them. A wireframe generated before this was added has none, so those columns say `not shown`. Run `generate` and `push` again in the linked project to fill them in.

### Listing your local contexts

```sh
afara layers context --list
afara layers context "card payment" --list
```

```
FEATURE       LAYER     FROM                              CHECKED AT  WRITTEN                    FILE
card payment  frontend  Checkout Web @ e67658b            0113454     2026-10-15 14:02           .afara/context/card-payment.frontend.md
card payment  mobile    Shop App @ 3c1d2e4 (release/2.4)  0113454     2026-10-15 14:05 (pulled)  .afara/context/card-payment.mobile.md
```

| Column | |
| --- | --- |
| **FROM** | The other project, the commit its graph was at, and its branch when it wasn't the default. |
| **CHECKED AT** | The commit of this repository the context was checked against. |
| **WRITTEN** | When the file was written, in your local time. `(pulled)` means it was downloaded with `--pull`, not built here. |

`--list` reads only local files and `.git/afara/state.json`, so it works offline and needs no sign-in. It doesn't check whether a context is out of date: run [`afara layers`](#afara-layers) for that.

A context file that Afara has no record of, such as one copied in by hand, is listed with `-` in the columns the record would fill.

### Downloading the stored context (`--pull`)

```sh
afara layers context "card payment" --pull
afara layers context "card payment" --from frontend --pull
```

`--pull` writes the stored markdown to `.afara/context/` without running an AI tool, for a teammate who wants the context someone else wrote. As with a written context, the files are kept out of git and your AI tool is pointed at them. Without `--from`, it downloads every linked layer's context, with a note for each layer that has none stored. It fails if none is stored for this branch.

## In the interactive shell

| Slash command | Equivalent |
| --- | --- |
| `/layers` | `afara layers` |
| `/layers list` | `afara layers list` |
| `/layers list --layer <layer>` | `afara layers list --layer <layer>` |
| `/layers link <layer> <project>` | `afara layers link <layer> <project>` |
| `/layers unlink <layer>` | `afara layers unlink <layer>` |
| `/layers context <feature>` | `afara layers context "<feature>"` |
| `/layers context <feature> --from <layer>` | `afara layers context "<feature>" --from <layer>` |
| `/layers context <feature> --clear` | `afara layers context "<feature>" --clear` |
| `/layers context --list` | `afara layers context --list` |

There is no project list to choose from in the shell. `/layers link frontend` with no slug prints the projects that can be a frontend: run it again with the slug, for example `/layers link frontend checkout-web`.

Flags typed after the feature name work, even for a name of several words: `/layers context card payment --from frontend`.

---

[← Afara CLI documentation](README.md)
