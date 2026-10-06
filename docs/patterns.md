# `afara patterns`

Lists your company's architecture patterns: the rules your architects have written down for how code should be built, and the repositories each set of rules applies to.

```sh
afara patterns                     # the patterns for the repository you are in
afara patterns --repo acme/api     # the patterns for another repository
afara patterns --all               # every pattern in the company
afara patterns --level service     # only one level
```

**Flags:**

| Flag | Description |
| --- | --- |
| `--repo <owner/name>` | List the patterns for this repository instead of the one you are in. Give it as `owner/name`. |
| `--all` | List every pattern, not only those for one repository. Cannot be combined with `--repo`. |
| `--level enterprise\|service` | List only enterprise patterns or only service patterns. Matching is case-insensitive. Without it, both levels are listed. Works with any of the above. |

## Pattern levels

- **Enterprise patterns** apply across the whole organisation, for example *Hexagonal architecture* or *No direct database access from handlers*.
- **Service patterns** apply to particular services, for example the rules a payments service must follow.

A pattern is either taken **from a preset** (a ready-made pattern such as hexagonal architecture, which the owner may have adjusted) or written from scratch (**custom**).

A pattern applies either to the repositories it names, or, if it names none, to **every** repository.

## Which patterns are listed

| Where you run it | What is listed |
| --- | --- |
| Inside a repository | The patterns that apply to it: those that name it, and those that apply to every repository. |
| With `--repo owner/name` | The same, for that repository. |
| With `--all` | Every pattern. Inside a repository, the ones that apply to it are marked `← applies to owner/name`. |
| Outside a repository | Every pattern, as with `--all`. |

The repository you are in is identified by the `owner/name` of its `origin` remote.

## Output

Patterns are grouped by level, enterprise first. Each one shows its name, whether it is custom or from a preset, its rules, and the repositories it applies to (`Repositories: all` for a pattern that names none).

Run in `acme/checkout`:

```
Patterns for acme/checkout (`--all` for every one)

Enterprise patterns (1)

  • Hexagonal architecture  (from a preset)
      - Domain code imports nothing from infrastructure
      - Adapters depend on ports
    Repositories: all

Service patterns (1)

  • Payments service rules  (custom)
      - Every charge is idempotent on a client-supplied key, so a retried
        request never charges twice.
    Repositories: acme/checkout
```

- A repository that Afara's GitHub App can no longer read is shown with `(Afara can no longer read it)`. Reconnect it, or remove it from the pattern, in the dashboard.
- If no patterns apply to the repository, Afara prints `No patterns apply to owner/name.` and points you to `--all`.
- If the company has no patterns at all, it prints `No patterns yet. Owners should add them in the dashboard.`

## Notes

- `afara patterns` only reads. Patterns are created, edited and assigned to repositories by owners in the dashboard.
- To have your AI coding tool follow these patterns while it writes code, run [`afara inject`](inject.md).
- You must be signed in. Without a sign-in it stops with ``not signed in. Run `afara auth login` first``.
- In the interactive shell, `/patterns` takes the same flags: `/patterns --all`, `/patterns --level service`.

---

[← Afara CLI documentation](README.md)
