# `afara link`

Attaches a ticket to a feature. The Afara backend fetches the ticket through your company's tracker integrations and reads it into a story wireframe, which `compare` checks the code against.

```sh
afara link [--issue <key-or-url>] [--system <tracker>] [--feature <name>]
```

**Flags:**

| Flag | Description |
| --- | --- |
| `-i`, `--issue <issue>` | The ticket: a key (`PAY-981`), a GitHub issue number (`#418` or `418`), or the ticket's URL. Without it, Afara shows a list to choose from. |
| `--system <tracker>` | Which tracker a bare key belongs to: `linear` (default), `github` or `jira`. |
| `-f`, `--feature <name>` | The feature to link. Defaults to the current feature (the last one generated). |

**Examples:**

```sh
afara link                                               # choose from the project's open tickets
afara link --issue PAY-981                               # a Linear key
afara link --issue PAY-981 --system jira                 # a Jira key
afara link --issue "#418" --feature "card payment"       # a GitHub issue in this repository
afara link --issue https://linear.app/acme/issue/CHK-212 # any tracker, by URL
```

## How the ticket is interpreted

| You type | Afara treats it as |
| --- | --- |
| A URL (`https://…`) | That ticket, in whichever tracker the URL belongs to. This works for every tracker and is the most reliable form. |
| `#418` or `418` | Issue 418 in this repository on GitHub. |
| `PAY-981` | A **Linear** key, unless you pass `--system jira` (or `--system github`). Keys are upper-cased. |

For a Jira ticket, pass either `--system jira` or the ticket's URL.

## Choosing from a list

Run `afara link` (or `/link` in the shell) without `--issue` and Afara lists the project's open tickets from GitHub and Linear, most recently updated first. Each row shows the key, the title, where it lives and its status.

| Key | What it does |
| --- | --- |
| `↑` `↓` (or `k` `j`) | Move. |
| `PgUp` `PgDn`, `Home` `End` | Jump. |
| `Enter` | Link the highlighted ticket. On the last row, **load more** fetches the next page. |
| `Esc`, `q` or `Ctrl+C` | Cancel. |

If a tracker is not connected or could not be read, the list says so, so a short or empty list explains itself. The list needs a terminal: outside one, `link` without `--issue` fails with `which ticket? Pass --issue PAY-981, #418 or a URL`.

## Output

```
Linked PAY-981 (linear) to card-payment
  Read revision 3f9a0c1b2d4e
  8 nodes extracted from the story
```

- **Read revision** identifies the version of the ticket's text that was read. If someone edits the ticket later, `compare` notices and reads it again.
- **nodes extracted from the story** is the size of the story wireframe. If it is **fewer than 4**, Afara warns that a comparison will come back as *too thin to compare*: add the screens, actions, and success and failure outcomes to the ticket, and link again.

## Notes

- The feature must already be on the dashboard. If it is not, `link` says `card-payment isn't on the dashboard yet. Run afara push before linking a ticket`. Run `generate` and `push` first.
- `link` remembers which feature the ticket belongs to in this repository. The pre-push hook uses that to match a branch named for the ticket to its feature.
- Linking another ticket to the same feature replaces the previous one.
- Reading the ticket runs a model on the Afara backend, so `link` needs a model chosen (see [`afara model`](model.md)) and can take up to a few minutes.

---

[← Afara CLI documentation](README.md)
