# `afara model`

Chooses the AI that does Afara's work. There are two choices, made separately:

- **The AI tool** on your machine that `generate`, `compare` and `inject` use: Claude Code, Codex CLI or Gemini CLI. This is what `afara model` chooses.
- **The backend model** the Afara backend runs for questions in the shell and for reading tickets in `link`. This is what `afara model --backend` chooses.

```sh
afara model                    # choose the AI tool from a list
afara model <tool>             # set the AI tool directly: claude, codex or gemini
afara model --backend          # choose the backend model from a list
afara model --backend <id>     # set the backend model directly
```

**Arguments and flags:**

| | Description |
| --- | --- |
| `tool` or `id` (optional) | The tool to use (`claude`, `codex` or `gemini`), or with `--backend`, the ID of the model as shown in the list. Matching is case-insensitive. |
| `--backend` | Choose the backend's AI model instead of the local tool. Needs you to be signed in. |

## Choosing the AI tool

```
AI tools on this machine, for generate and compare:
  1. Claude Code 2.1.0 (claude)  /usr/local/bin/claude  [in use]
  2. Codex CLI 0.40.0 (codex)  /opt/homebrew/bin/codex

Also supported, not installed:
  Gemini CLI:       npm install -g @google/gemini-cli          (https://github.com/google-gemini/gemini-cli)

Tool for generate and compare [claude]:
```

- **With a tool's name**, it is saved immediately: `generate and compare now use Codex CLI 0.40.0.` The tool must be installed.
- **Without a name, in a terminal**, Afara lists the installed tools and asks. Enter the number or the name. Pressing `Enter` with nothing typed keeps the one in use.
- **Without a name, outside a terminal** (and with `/model` in the shell), Afara lists the tools and tells you how to set one.
- With only one tool installed, there is nothing to choose: it is listed as in use.
- With none installed, it lists how to install each one and fails.

The choice is saved in `~/.config/afara/tool` and applies to every repository on this machine. `--tool` on `generate` or `compare` still overrides it for one run. If the chosen tool is uninstalled later, Afara quietly falls back to the first installed one, in the order Claude Code, Codex CLI, Gemini CLI. Until you choose, that order is what is used.

## Choosing the backend model (`--backend`)

```
Choose the AI model Afara runs for you:
  1. Claude Opus 5 (claude-opus-5)  [current, default]
     The most capable model for complex reasoning.
  2. Claude Sonnet 5 (claude-sonnet-5)
     Fast and capable for everyday work.
Model [claude-opus-5]:
```

The models you see depend on what the backend offers.

- **With an ID**, the model is saved immediately and Afara prints `Using <name> (<id>).` If the ID is not one the backend offers, the available models are listed and the command fails.
- **Without an ID, in a terminal**, Afara shows the numbered list and asks. Enter the number or the ID. Pressing `Enter` with nothing typed keeps your current model, or takes the backend's default if you have none.
- **Without an ID, outside a terminal** (and with `/model --backend` in the shell), Afara lists the models and tells you how to set one.

The choice is saved in `~/.config/afara/model`. `afara auth login` asks for it after you sign in. If none has been chosen yet, the first command that needs one asks in a terminal, or uses the backend's default and says so (``No AI model chosen; using …. Change it with `afara model --backend`.``).

---

[← Afara CLI documentation](README.md)
