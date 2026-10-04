# `afara init`

Sets a repository up for Afara: it installs the pre-push hook and sets the baseline.

```sh
cd your-repository
afara init
```

Run it once per clone. Running it again is safe.

**1. The pre-push hook.** `init` installs a git `pre-push` hook. On a branch named for a ticket, a push waits until every commit being pushed has been through `afara generate`, and the ticket has been linked with `afara link`. Commits are never blocked; only pushes are checked. See [The pre-push hook](pre-push-hook.md) for the full rules.

- If the repository already has a `pre-push` hook of its own, Afara keeps it as `pre-push.afara-prev` and runs it first. If that hook fails, the push stops there.
- If a `pre-push.afara-prev` already exists alongside another hook, `init` stops and asks you to move one aside.
- The hook is installed wherever git looks for hooks, including a custom `core.hooksPath` and worktrees.
- Running `init` again rewrites Afara's own hook and leaves yours alone.
- Earlier versions of Afara installed a `pre-commit` hook. `init` removes it and restores any hook it had set aside.

**2. The baseline.** `init` marks the current commit (`HEAD`) as the *baseline*. That commit and everything before it count as history from before Afara: `generate` will not offer those commits, and the pre-push hook will not wait for them. This is what lets you adopt Afara in a repository with years of history without having to generate all of it.

- To document a feature that already exists in that history, use [`afara generate --existing`](generate.md#documenting-existing-features---existing).
- Running `init` again keeps the baseline where it was (`The baseline is already set at a1b2c3d.`). Moving it would hide commits someone is still waiting to generate.
- In a repository with no commits yet, no baseline is set; nothing came before Afara.

**Example output:**

```
Installed the Afara pre-push hook in /Users/you/code/shop/.git/hooks.

On a branch named for a ticket (chu-1-onboarding, alice/PAY-981-refunds,
418-fix-totals), a push now waits until Afara has generated the commits
being pushed. Commits are never blocked, and branches without a ticket
key are not checked.

Skip the check once with: git push --no-verify

Set the baseline at 9f3e2a1: it and every commit before it are history from before
Afara, which generate and the pre-push hook skip. Document features that
already exist with: afara generate --feature "<name>" --existing
```

`init` must be run inside a git repository. It does not need you to be signed in.

---

[← Afara CLI documentation](README.md)
