# `afara push`

Publishes the code wireframe that `generate` produced to the Afara dashboard.

```sh
afara push [feature] [--branch <name>]
```

**Arguments and flags:**

| | Description |
| --- | --- |
| `feature` (optional) | The feature to push. Defaults to the current feature (the last one generated). |
| `-f`, `--feature <name>` | The same, as a flag. If you give both, they must agree. |
| `--branch <name>` | The branch to push to. Defaults to the checked-out branch. See [Branches](compare.md#branches). |

**Examples:**

```sh
afara push
afara push "card payment"
afara push --branch main
```

**Output:**

```
Pushed card-payment @ 0113454 to feature/card-payment (14 nodes, 12 edges)
https://app-beta.afara.dev/p/shop/f/card-payment?branch=feature%2Fcard-payment
```

The second line is the feature's page on the dashboard, on the branch you pushed to. For the project's default branch, the link has no `?branch=`.

**Notes:**

- `push` uploads exactly what the last `generate` saved for that feature. It does not read the code again.
- If you have committed since you generated, `push` warns you: `this wireframe was generated at e67658b, and HEAD is now 0113454`. It still pushes the wireframe as it was generated. Run `generate` again first if you want the newer commits included.
- If nothing has been generated for the feature on this machine, `push` stops with `nothing generated for card-payment yet`.
- The branch must be tracked by the project (dashboard, **Settings → Branches**). On an untracked branch, `push` stops before uploading anything. See [Branches](compare.md#branches).
- `afara push` publishes to Afara only. It does not run `git push`.

---

[← Afara CLI documentation](README.md)
