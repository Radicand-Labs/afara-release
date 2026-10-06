# `afara` (the interactive shell)

```sh
afara
```

Running `afara` with no arguments opens the interactive shell. It is a chat interface with a command palette:

- **Type a question** in plain English and press `Enter`. The question is answered by the Afara backend using your chosen AI model, and the answer streams into the transcript as it is written. Follow-up questions keep the earlier conversation as context.
- **Type `/`** to open the command palette. It lists every command and filters as you type.

If output is piped or redirected, or there is no terminal (for example in CI), `afara` prints its help instead of opening the shell.

## Keys

| Key | What it does |
| --- | --- |
| `Enter` | Send the question, or run the slash command. |
| `Ctrl+J` or `Shift+Enter` | Insert a newline. The input box grows to fit several lines. |
| `/` | Open the command palette, filtering as you type. |
| `Tab` | Complete the highlighted command, or open the full command list. |
| `↑` `↓` | Move through the palette or command list. |
| `↑` `↓` at an empty prompt, `PgUp` `PgDn` | Scroll the transcript. |
| `Ctrl+Y` | Copy the last answer to the clipboard. |
| `Esc` | Cancel whatever is running, close the palette, or clear the input. It never exits. |
| `Ctrl+L` | Redraw the screen. |
| `Ctrl+C` or `/exit` | Leave the shell. |

`Shift+Enter` only works in terminals that report it separately from `Enter` (Ghostty, Kitty, WezTerm, recent iTerm2). In other terminals it arrives as a plain `Enter`, so `Ctrl+J` is the newline key that always works. The help line at the bottom of the shell names the one your terminal supports.

## Mouse and text selection

By default the mouse belongs to your terminal, so you can highlight and copy text as you would anywhere else. Scroll with the keys above. If you prefer to scroll with the mouse wheel, run `/mouse`: the wheel then scrolls the transcript, but the terminal can no longer select text. Run `/mouse` again to switch back.

## Slash commands

| Slash command | Equivalent | Notes |
| --- | --- | --- |
| `/auth login` | `afara auth login` | Signs in without leaving the shell. |
| `/generate <feature>` | `afara generate --feature "<feature>"` | With two or more pending commits, a picker asks which belong to the feature first. |
| `/link` | `afara link` | With no value, opens a list of the project's open tickets. |
| `/link <issue>` | `afara link --issue <issue>` | |
| `/push` | `afara push` | Pushes the current feature. |
| `/push <feature>` | `afara push "<feature>"` | |
| `/compare <feature>` | `afara compare "<feature>"` | The feature name is required. |
| `/patterns` | `afara patterns` | Lists the patterns for this repository. Flags work too: `/patterns --all`, `/patterns --level service`. |
| `/inject` | `afara inject` | Flags work too: `/inject --all-tools`, `/inject --remove`. |
| `/init` | `afara init` | |
| `/model` | `afara model` | Lists the installed AI tools. |
| `/model <tool>` | `afara model <tool>` | |
| `/model --backend` | `afara model --backend` | Lists the backend's models. |
| `/model --backend <id>` | `afara model --backend <id>` | |
| `/copy` | | Copies the last answer to the clipboard. |
| `/mouse` | | Switches between text selection and wheel scrolling. |
| `/exit` | | Leaves the shell. |

Everything typed after the command name is passed as a single value, so spaces are safe: `/generate card payment with 3-D Secure` documents the feature `card payment with 3-D Secure`. The exception is a value that starts with `-`: it is split into words as your shell would split it, so flags work (`/model --backend claude-opus-5`, `/patterns --level service`). Picking a command from the palette fills it in for you.

Only one thing runs at a time. While an answer is streaming or a command is running, new input waits until it finishes, or until you cancel it with `Esc`.

If you are not signed in, questions fail with a reminder to run `/auth login`.

## Shell-only commands: `/copy`, `/mouse`, `/exit`

These only do something inside the interactive shell.

| Command | What it does |
| --- | --- |
| `/copy` | Copies the most recent answer to the clipboard (the same as `Ctrl+Y`). On Linux this needs `xclip` or `xsel` installed. |
| `/mouse` | Switches between terminal text selection (the default) and mouse-wheel scrolling. |
| `/exit` | Leaves the shell (the same as `Ctrl+C`). |

---

[← Afara CLI documentation](README.md)
