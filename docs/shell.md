# `afara` (the interactive shell)

```sh
afara
```

Running `afara` with no arguments opens the interactive shell. It is a chat interface with a command palette:

- **Type a question** about Afara in plain English and press `Enter`: what it is, how it works, or how to do something with it. The AI tool on your machine answers it from the Afara documentation and the CLI's own help. See [Asking questions](#asking-questions).
- **Type `/`** to open the command palette. It lists every command and filters as you type.

If output is piped or redirected, or there is no terminal (for example in CI), `afara` prints its help instead of opening the shell.

## Asking questions

Anything typed that is not a slash command is a question about Afara. Questions are answered on your machine and never sent to the Afara backend, so they work before you sign in.

How a question is answered:

1. Afara finds your local AI tool, the same one `generate` uses (Claude Code, Codex CLI or Gemini CLI).
2. The first time you ask in a session, Afara loads the documentation page at `AFARA_DOC_URL`. Markdown, plain text and HTML all work. HTML is reduced to its text.
3. Afara builds a command reference from the CLI's own help: every command with its description, usage, examples and flags. Answers about commands and flags always match the version you have installed.
4. The tool runs read-only in a temporary folder that holds only those two files. It answers from them alone, and says so when they don't cover the question. It never invents commands, flags or features.
5. Follow-up questions include the conversation so far.

The tool can't run anything for you. It tells you what to run.

Answers are plain text. Each one starts with a one- or two-sentence answer. A how-to question also gets:

- **Steps:** each `afara …` command on its own line.
- **Notes:** anything else you need to know, when there is something.
- **From:** the documentation section or command the answer came from.

**Where the documentation comes from.** Set `AFARA_DOC_URL` to one page holding the Afara documentation (see [Configuration](configuration.md#environment-variables)). Without it, answers come from the CLI's own help only, and the shell says so the first time you ask. If the page can't be loaded, that answer also uses the CLI's help only, and the next question tries the page again.

## Keys

| Key | What it does |
| --- | --- |
| `Enter` | Send the question, or run the slash command. |
| `Ctrl+J` or `Shift+Enter` | Insert a newline. The input box grows to fit several lines. |
| `/` | Open the command palette, filtering as you type. |
| `Tab` | Complete the highlighted command, or open the full command list. |
| `↑` `↓` | Move through the palette or command list. |
| `↑` `↓` at an empty prompt, `PgUp` `PgDn` | Scroll the transcript. |
| `Ctrl+Y` | Copy the last answer to the clipboard. On Linux this needs `xclip` or `xsel` installed. |
| `Esc` | Cancel whatever is running, close the palette, or clear the input. It never exits. |
| `Ctrl+L` | Redraw the screen. |
| `Ctrl+C` | Leave the shell. |

`Shift+Enter` only works in terminals that report it separately from `Enter` (Ghostty, Kitty, WezTerm, recent iTerm2). In other terminals it arrives as a plain `Enter`, so `Ctrl+J` is the newline key that always works. The help line at the bottom of the shell names the one your terminal supports.

## Mouse and text selection

The mouse always belongs to your terminal, so you can highlight and copy text as you would anywhere else. Scroll the transcript with `↑` `↓` at an empty prompt, or `PgUp` `PgDn`.

## Slash commands

| Slash command | Equivalent | Notes |
| --- | --- | --- |
| `/login` | `afara login` | Signs in without leaving the shell. |
| `/generate <feature>` | `afara generate --feature "<feature>"` | With two or more pending commits, a picker asks which belong to the feature first. |
| `/link` | `afara link` | With no value, opens a list of the project's open tickets. |
| `/link <issue>` | `afara link --issue <issue>` | |
| `/push` | `afara push` | Pushes the current feature. |
| `/push <feature>` | `afara push "<feature>"` | |
| `/compare <feature>` | `afara compare "<feature>"` | The feature name is required. |
| `/ship <feature>` | `afara ship "<feature>"` | Asks which commits first, like `/generate`. There is no ticket list in the shell: see [In the interactive shell](ship.md#in-the-interactive-shell). |
| `/layers` | `afara layers` | Shows this project's layer and the projects linked to it. |
| `/layers list` | `afara layers list` | Flags work too: `/layers list --layer frontend`. |
| `/layers link <layer> <project>` | `afara layers link <layer> <project>` | Without a project, prints the choices instead of asking. |
| `/layers unlink <layer>` | `afara layers unlink <layer>` | |
| `/layers context <feature>` | `afara layers context "<feature>"` | Flags work after the feature name: `/layers context card payment --from frontend`. |
| `/patterns` | `afara patterns` | Lists the patterns for this repository. Flags work too: `/patterns --all`, `/patterns --level service`. |
| `/inject` | `afara inject` | Flags work too: `/inject --all-tools`, `/inject --remove`. |
| `/init` | `afara init` | |
| `/model` | `afara model` | Lists the installed AI tools. |
| `/model <tool>` | `afara model <tool>` | |
| `/model --backend` | `afara model --backend` | Lists the backend's models. |
| `/model --backend <id>` | `afara model --backend <id>` | |

Everything typed after the command name is passed as a single value, so spaces are safe: `/generate card payment with 3-D Secure` documents the feature `card payment with 3-D Secure`. The exception is a value that starts with `-`: it is split into words as your shell would split it, so flags work (`/model --backend claude-opus-5`, `/patterns --level service`). Picking a command from the palette fills it in for you.

Only one thing runs at a time. While a question is being answered or a command is running, new input waits until it finishes, or until you cancel it with `Esc`.

If you are not signed in, the shell says so when it opens. Questions still work, but commands that reach Afara need `/login` first.

---

[← Afara CLI documentation](README.md)
