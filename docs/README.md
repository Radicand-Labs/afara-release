# Afara CLI documentation

Afara turns the code you actually shipped into context every other team can work from, and flags when the user story stops matching the build.

This documentation covers every command in the `afara` CLI: what it does, the options it takes, what it prints, and how the commands fit together. For installation, see the [README](https://github.com/Radicand-Labs/afara-release/blob/main/README.md).

## Commands

| Command | What it does |
| --- | --- |
| [`afara`](shell.md) | Open the interactive shell: ask questions, and run any command as a slash command. |
| [`afara auth login`](auth-login.md) | Sign in through your browser. |
| [`afara model`](model.md) | Choose the AI model the Afara backend uses for you. |
| [`afara init`](init.md) | Set a repository up: install the pre-push hook and set the baseline. |
| [`afara generate`](generate.md) | Build a feature's code wireframe from your new commits, on your machine. |
| [`afara link`](link.md) | Attach the Jira, Linear or GitHub ticket that describes a feature. |
| [`afara push`](push.md) | Publish a generated wireframe to the dashboard. |
| [`afara compare`](compare.md) | Find where the ticket and the build disagree. |
| [`/copy`, `/mouse`, `/exit`](shell.md#shell-only-commands-copy-mouse-exit) | Commands that only work inside the shell. |

## Topics

| Page | |
| --- | --- |
| [The pre-push hook](pre-push-hook.md) | How pushes wait for Afara, which branches are checked, and how to skip it. |
| [Using Afara in CI](ci.md) | Running without a terminal, and failing builds on divergences. |
| [Configuration and files](configuration.md) | Environment variables, and every file Afara keeps. |
| [Troubleshooting](troubleshooting.md) | Error messages and what to do about them. |

---

## How Afara works

Afara works with three things:

- **A feature** is a named piece of your product, such as `card payment` or `checkout redesign`. Each feature has an ID derived from its name (`card-payment`). Once a feature has an ID, the ID never changes, even if you later type the name a little differently, so the feature's history stays attached to it.
- **A code wireframe** is a flow graph of the feature as it is built: the screens a user sees, the steps that happen, the API endpoints involved, and the order between them. Every node points back to the file and lines it came from. `afara generate` builds it from your code.
- **A story wireframe** is the same kind of graph, read from the ticket (Jira, Linear or GitHub issue) that describes the feature. Every node points back to the sentence of the ticket it came from. `afara link` produces it.

`afara compare` lines the two graphs up and reports where they disagree: behaviour that was built but never written down, steps the ticket asks for that were not built, and steps built in a different order. The results appear in your terminal and on the Afara dashboard, where your team can accept or resolve each finding.

Two principles run through the whole CLI:

1. **Afara reads commits, never your working tree.** Uncommitted changes are never sent anywhere. If you have uncommitted work, commands print a note to remind you, and carry on with what is committed.
2. **The code is read on your machine.** `generate` and `compare` run an AI coding tool you already have installed (Claude Code, Codex CLI or Gemini CLI), in a temporary read-only copy of your repository. Your source code is not uploaded for analysis; only the resulting wireframe is published, and only when you run `afara push`.

---

## Before you start

You need:

| Requirement | Why |
| --- | --- |
| `afara` installed | See the [README](https://github.com/Radicand-Labs/afara-release/blob/main/README.md#install). |
| `git` | Afara reads your repository's commits. |
| A repository with an `origin` remote on GitHub | Afara matches the repository to an Afara project using the `owner/name` of the `origin` remote. SSH and HTTPS remotes both work, including GitHub Enterprise hosts. |
| An Afara project for that repository | Create one in the dashboard under **Projects → New project**. Without it, feature commands stop with `no Afara project for owner/name`. |
| An AI coding tool (for `generate` and `compare`) | One of [Claude Code](https://claude.com/claude-code) (`npm install -g @anthropic-ai/claude-code`), [OpenAI Codex CLI](https://github.com/openai/codex) (`npm install -g @openai/codex`) or [Gemini CLI](https://github.com/google-gemini/gemini-cli) (`npm install -g @google/gemini-cli`). Install it and sign in to it once. |
| A tracker connected to the project (for `link` and `compare`) | GitHub, Linear or Jira, connected in the dashboard. Afara fetches tickets through these integrations. |

---

## The everyday workflow

Setting up a repository once:

```sh
afara auth login     # sign in and choose an AI model
cd your-repository
afara init           # install the pre-push hook and set the baseline
```

Then, for each feature you work on:

```sh
git checkout -b PAY-981-card-payment
# ...write code, commit as usual...

afara generate --feature "card payment"   # map the feature from your new commits
afara link --issue PAY-981                # attach the ticket that describes it
afara push                                # publish the code wireframe to the dashboard
afara compare "card payment"              # find where the story and the build differ

git push                                  # the pre-push hook lets it through
```

After the first `generate`, the feature becomes the *current feature* for this repository, so `link` and `push` need no `--feature` unless you switch to another one.

Everything above can also be done from inside the interactive shell (`afara`) with slash commands such as `/generate card payment`.

---

## Running commands

Every command can be run in two ways:

- **From your shell:** `afara <command> [flags]`. This is the form to use in scripts and CI.
- **From the interactive shell:** type `/` followed by the command, for example `/push` or `/link PAY-981`. It runs exactly the same code path, and its output appears in the transcript. An error is shown in the transcript and the session keeps running.

`afara --help` and `afara <command> --help` print built-in help. `afara --version` prints the installed version.

While a command waits on the network or on the AI tool, Afara shows a spinner with a line such as `Afara is pondering…`. The word changes every few seconds, so a long run (a `generate` can take a few minutes) visibly has not frozen. Press `Ctrl-C` to cancel a running command from your shell, or `Esc` inside the interactive shell.
