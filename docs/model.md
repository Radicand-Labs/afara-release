# `afara model`

Chooses the AI model the Afara backend uses for you: for questions in the shell, for reading tickets in `link`, and for any other work the backend runs on a model.

```sh
afara model              # choose from a list (or list the choices, outside a terminal)
afara model <id>         # set a model directly
```

**Arguments:**

| Argument | Description |
| --- | --- |
| `id` (optional) | The ID of the model to use, as shown in the list. Matching is case-insensitive. |

**Behaviour:**

- **With an ID**, the model is saved immediately and Afara prints `Using <name> (<id>).` If the ID is not one the backend offers, the available models are listed and the command fails.
- **Without an ID, in a terminal**, Afara shows a numbered list and asks you to choose. Enter the number or the ID. Pressing `Enter` with nothing typed keeps your current model, or takes the backend's default if you have none.
- **Without an ID, outside a terminal** (and with `/model` in the shell), Afara lists the models and tells you how to set one.

Example list (the models you see depend on what the backend offers):

```
Choose the AI model Afara runs for you:
  1. Claude Opus 5 (claude-opus-5)  [current, default]
     The most capable model for complex reasoning.
  2. Claude Sonnet 5 (claude-sonnet-5)
     Fast and capable for everyday work.
Model [claude-opus-5]:
```

The choice is saved in `~/.config/afara/model` and applies to every repository on this machine. If no model has been chosen yet, the first command that needs one asks in a terminal, or uses the backend's default and says so (`No AI model chosen; using …`).

This setting does not choose which local AI tool `generate` and `compare` run. That is the `--tool` flag on those commands.

You must be signed in to run `afara model`.

---

[← Afara CLI documentation](README.md)
