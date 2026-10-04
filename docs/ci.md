# Using Afara in CI

Every command except the interactive shell works without a terminal. Without one:

- `afara` prints help instead of opening the shell.
- `generate` uses all pending commits (pass `--commits` to choose).
- `link` requires `--issue`.
- `model` lists the choices instead of asking, and any command that needs a model uses the backend's default if none is chosen.

A typical CI check that fails a build when the code contains behaviour the ticket does not describe:

```sh
afara compare "card payment" --fail-on extra
```

CI needs a signed-in credential in `~/.config/afara/credentials` (or under `$XDG_CONFIG_HOME/afara/`), and an AI coding tool installed and authenticated for `generate` and `compare`.

---

[← Afara CLI documentation](README.md)
