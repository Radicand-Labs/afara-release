# Configuration and files

## Environment variables

Everything is optional. A fresh install needs no configuration.

| Variable | Default | Description |
| --- | --- | --- |
| `AFARA_WEB_URL` | `https://app-beta.afara.dev` | The dashboard. Sign-in opens here, and printed links point here. |
| `AFARA_API_URL` | `https://api-beta.afara.dev` | The backend the CLI calls. |
| `XDG_CONFIG_HOME` | `~/.config` | Where Afara keeps its per-user files. |

Values are read from the environment first, then from a `.env` file in the current directory if there is one, then the built-in defaults.

## Files on your machine

| Location | Contents |
| --- | --- |
| `~/.config/afara/credentials` | Your API key, readable only by you. Delete it to sign out. |
| `~/.config/afara/model` | The ID of the AI model you chose. |
| `~/.config/afara/session` | A random identifier for this installation. |
| `<repo>/.git/afara/state.json` | Per-clone state: feature names and IDs, the current feature, linked tickets, the commits already generated, and the baseline. |
| `<repo>/.git/afara/features/<id>.json` | The last generated wireframe for each feature, kept until it is pushed (and after). |
| `<repo>/.git/hooks/pre-push` | The hook `afara init` installs. |

Per-repository state lives inside `.git`, so it can never be committed by accident.

**Resetting a repository:** deleting `.git/afara/` makes Afara forget everything about that clone, including which commits were generated and the baseline. Run `afara init` again afterwards.

---

[← Afara CLI documentation](README.md)
