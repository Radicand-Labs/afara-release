# Using Afara in CI

Every command except the interactive shell works without a terminal. Without one:

- `afara` prints help instead of opening the shell.
- `generate` uses all pending commits (pass `--commits` to choose).
- `link` requires `--issue`.
- `model` lists the choices instead of asking, and any command that needs a backend model uses the backend's default if none is chosen.

## The branch

CI usually checks out a detached `HEAD`, with no branch. `push` and `compare` then take the branch from `GITHUB_HEAD_REF` (a pull request's source branch) or `GITHUB_REF_NAME`, which GitHub Actions sets. On other CI systems, pass `--branch <name>`. The branch must be tracked by the project (dashboard, **Settings → Branches**), or the command stops. See [Branches](compare.md#branches).

## Failing a build

A typical CI check that fails a build when the code contains behaviour the ticket does not describe:

```sh
afara compare "card payment" --fail-on extra
```

## What CI needs

- A signed-in credential in `~/.config/afara/credentials` (or under `$XDG_CONFIG_HOME/afara/`).
- An AI coding tool installed and authenticated, for `generate` and `compare`. Without a saved choice from `afara model`, the first installed one is used; pass `--tool` to pick one.
- If an AI tool writes code in CI and should follow the company's architecture patterns, commit the file [`afara inject`](inject.md) writes.

---

[← Afara CLI documentation](README.md)
