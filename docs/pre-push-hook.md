# The pre-push hook

`afara init` installs a pre-push hook so that work does not reach the remote without Afara having seen it.

**When a push is checked.** Only branches whose name contains a ticket key are checked. Afara recognises:

| Branch | Ticket |
| --- | --- |
| `chu-1-onboarding` | `CHU-1` |
| `alice/PAY-981-refunds` | `PAY-981` |
| `418-fix-totals` (GitHub's own format) | `#418` |
| `issue-418`, `gh-418`, `fix/issue_418` | `#418` |

Common words are not mistaken for ticket prefixes: `release-2024`, `hotfix-3`, `feature-12`, `v-2` and dependency-bot branches are not checked, and version numbers such as `lodash-4.17.21` are not read as tickets.

**What is checked.** For each branch being pushed, Afara looks at the commits that are new to the remote, ignoring merge commits, commits at or before the baseline, and commits that touch no source files. The push goes through if all of them have been generated. Otherwise it is held back:

- If the ticket has not been linked to a feature in this repository:

  ```
  afara: push of PAY-981-card-payment blocked for PAY-981.
    PAY-981 isn't linked to a feature in this repository yet.

    Run Afara on this repository first. In the shell (run `afara`), or directly:
      afara generate --feature "<the feature this ticket is about>"
      afara link --issue PAY-981

    Then push again. To skip this check once: git push --no-verify
  ```

- If some commits have not been generated:

  ```
  afara: push of PAY-981-card-payment blocked for PAY-981.
    2 commits being pushed have not been generated: e67658b, 0113454.

    Run Afara on this repository first. In the shell (run `afara`), or directly:
      afara generate --feature "card payment"

    Then push again. To skip this check once: git push --no-verify
  ```

**Good to know:**

- **The check is offline.** It reads only the local record in `.git/afara`, never the network, so it adds no noticeable time to a push.
- **Commits are never blocked**, only pushes.
- **Tags and branch deletions** are never checked.
- **Your own pre-push hook** is kept and runs first.
- **Skip the check once** with `git push --no-verify`.
- If the `afara` binary cannot be found when the hook runs, the push stops with instructions to install it or push with `--no-verify`.
- The record of generated commits is per clone. A teammate's clone keeps its own.

---

[← Afara CLI documentation](README.md)
