# `afara compare`

Compares a feature's linked ticket with its pushed code wireframe, prints what differs, and saves the result to the dashboard.

```sh
afara compare "<feature>" [--fail-on <kind>] [--tool <tool>]
```

**Arguments and flags:**

| | Description |
| --- | --- |
| `feature` | **Required.** The feature to compare, as an argument or with `--feature`. |
| `-f`, `--feature <name>` | The feature name, instead of the argument. |
| `--fail-on <kind>` | Exit with a non-zero status while open findings of this kind exist: `extra`, `missing`, `reordered` or `any`. For CI. |
| `--tool <tool>` | The local AI tool to use: `claude`, `codex` or `gemini`. Defaults to the first one installed. |

**Examples:**

```sh
afara compare "card payment"
afara compare "card payment" --fail-on extra
afara compare "card payment" --fail-on any --tool gemini
```

## What it needs

- The feature has been **pushed** (`afara push`).
- The feature has a **ticket linked** (`afara link`).
- An AI coding tool installed, as for `generate`.

If any of these is missing, `compare` stops and tells you which command to run.

## What happens

1. Afara fetches the feature, its pushed code wireframe and its linked ticket.
2. **The story side.** If the ticket is unchanged since it was linked, Afara uses the story wireframe read at link time, so finding IDs stay the same between runs. If the ticket has been edited since, Afara reads it again locally with your AI tool (`Reading PAY-981 with Claude Code … (it changed since it was linked …)`).
3. **Too thin?** If the story has fewer than 4 steps, there is not enough to compare. The result is recorded as *too thin*, with no AI involved, along with what the ticket is missing.
4. **Lining up.** Otherwise your AI tool pairs each story step with the code that implements it. It runs in a read-only checkout of the pushed commit, so it can open the files the code wireframe cites to check its judgement. If the pushed commit is not in your clone, it judges from the two graphs alone.
5. **Saving.** The result is saved to the dashboard, then printed **as the dashboard recorded it**. Findings someone already accepted or resolved keep that status.

## Reading the output

```
card-payment: story 3f9a0c1b2d4e vs code 0113454

Extra: built but not in the story (1)
  • step.retry-authorisation  0.86 high
    The code retries a declined authorisation once before showing the
    error. The story says nothing about retries; a second attempt can
    double-authorise the card.

Missing: in the story but not built (1)
  • step.send-receipt  0.72 medium
    The ticket says a receipt is emailed after payment. No code in this
    feature sends one; it may happen in another service.

Reordered: built in a different order (1)
  • step.save-card ↔ step.store-payment-method  0.64 medium
    The story saves the card after payment succeeds; the code saves it
    before authorising.

2 accepted, 1 resolved

Couldn't match these (1). A limit of the matcher, not a defect:
  • step.emit-metrics (code)
    An infrastructure step with no user-visible effect.

Saved. https://app-beta.afara.dev/p/shop/f/card-payment
```

The first line names the ticket revision and the commit that were compared. Then, in order:

| Section | Meaning |
| --- | --- |
| **Extra** | Built, but not in the story. Listed first because undocumented behaviour is usually the most valuable thing to find. |
| **Missing** | In the story, but not built. |
| **Reordered** | Both sides have the steps, but in a different order. |
| **accepted / resolved** | Findings your team has already dealt with on the dashboard, shown as counts. |
| **Couldn't match these** | Nodes the matcher could not place with confidence: two equally good candidates, a best candidate below the threshold, an infrastructure step a story would never mention, or behaviour in shared code outside the feature. These are limits of the matcher, not defects in your code. |

Each finding shows the node IDs involved, a confidence from 0 to 1 with its band (**high** ≥ 0.8, **medium** ≥ 0.6, **low** below that, the same bands the dashboard uses), and a plain-language explanation written for a product manager.

If there are no open findings, you see `No open divergences: the code matches the story.`

If the story is too thin, you see `The story is too thin to compare.` with what the ticket describes and what to add.

## `--fail-on` and exit status

- Without `--fail-on`, `compare` exits 0 whenever the comparison ran and was saved, whatever it found.
- With `--fail-on extra`, `missing` or `reordered`, it exits non-zero while any **open** finding of that kind exists (`2 open divergences (--fail-on extra)`). Accepted and resolved findings never fail a run.
- With `--fail-on any`, any open finding fails the run.
- A *too thin* result never fails on `--fail-on`.
- If the result could not be saved, it is still printed, and `compare` exits non-zero.

An invalid `--fail-on` value is rejected before any network call, so a typo in CI fails immediately.

---

[← Afara CLI documentation](README.md)
