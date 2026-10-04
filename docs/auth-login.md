# `afara auth login`

Signs this machine in to Afara through your browser, then asks which AI model Afara should use.

```sh
afara auth login
```

**What happens:**

1. Afara starts a temporary callback server on `localhost` and opens your browser at the Afara sign-in page. If the browser cannot be opened, the URL is printed so you can open it yourself.
2. You sign in in the browser. The browser is sent back to the local callback with your API key, and then on to a confirmation page.
3. The key is saved to `~/.config/afara/credentials`, readable only by you.
4. Afara lists the AI models available to you and asks you to choose one (see [`afara model`](model.md)). If you have already chosen a model, this step is skipped.

The flow waits up to **2 minutes** for you to finish in the browser, then gives up with `timed out after 2m0s waiting for the callback`. Run the command again to retry.

**Signing in again** replaces the saved key. Do this whenever a command reports `Afara rejected the saved key`.

**Signing out:** delete `~/.config/afara/credentials`.

Inside the shell, `/auth login` runs the same flow and reports each step in the transcript.

---

[← Afara CLI documentation](README.md)
