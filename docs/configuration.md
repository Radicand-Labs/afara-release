# Configuration and files

## Environment variables

Everything is optional. A fresh install needs no configuration.

| Variable | Default | Description |
| --- | --- | --- |
| `AFARA_WEB_URL` | `https://app-beta.afara.dev` | The dashboard. Sign-in opens here, and printed links point here. |
| `AFARA_API_URL` | `https://api-beta.afara.dev` | The backend the CLI calls. |
| `AFARA_DOC_URL` | none | The Afara documentation page the shell answers questions from: markdown, plain text or HTML, up to a size limit. Without it, questions are answered from the CLI's own help only. See [Asking questions](shell.md#asking-questions). |
| `XDG_CONFIG_HOME` | `~/.config` | Where Afara keeps its per-user files. |

Values are read from the environment first, then from a `.env` file in the current directory if there is one, then the built-in defaults.

## Files on your machine

| Location | Contents |
| --- | --- |
| `~/.config/afara/credentials` | Your API key, readable only by you. Delete it to sign out. |
| `~/.config/afara/tool` | The local AI tool you chose with `afara model` for `generate`, `compare` and `inject`. |
| `~/.config/afara/model` | The ID of the backend model you chose with `afara model --backend`. |
| `~/.config/afara/session` | A random identifier for this installation. |
| `<repo>/.git/afara/state.json` | Per-clone state: feature names and IDs, the current feature, linked tickets, the commits already generated, the baseline, and where each local context file came from. |
| `<repo>/.git/afara/features/<id>.json` | The last generated wireframe for each feature, kept until it is pushed (and after). |
| `<repo>/.git/hooks/pre-push` | The hook `afara init` installs. |
| `<repo>/.afara/context/<id>.<layer>.md` | Written by [`afara layers context`](layers.md#afara-layers-context): what a linked layer expects of this project. A local working file, kept out of git through `.git/info/exclude`. `--clear` removes it. |
| `<repo>/CLAUDE.local.md` (or `AGENTS.md`, `GEMINI.md`) | `afara layers context` adds a marked block here that points your AI tool at the context files. `--clear` removes it. See [Keeping it local](layers.md#keeping-it-local). |
| `<repo>/CLAUDE.md`, `AGENTS.md`, `GEMINI.md` | Written by `afara inject`: the architecture patterns for your AI tool, in a marked block. These are meant to be committed. |

Per-repository state lives inside `.git`, so it can never be committed by accident. The instruction files `afara inject` writes are the exception: they live in the working tree, so they can be shared.

**Resetting a repository:** deleting `.git/afara/` makes Afara forget everything about that clone, including which commits were generated and the baseline. Run `afara init` again afterwards.

---

[← Afara CLI documentation](README.md)
