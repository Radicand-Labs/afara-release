# Afara CLI

**Afara turns the code you actually shipped into context every other team can work from, and flags when the user story stops matching the build.**

This repository holds the CLI's releases and installer. The source lives in a private repository; every release here is built from it by CI.

## Install

### macOS and Linux

```sh
curl -fsSL https://raw.githubusercontent.com/Radicand-Labs/afara-release/main/install.sh | sh
```

The script downloads the latest release for your platform, checks it against the release's `checksums.txt`, and installs `afara` to `~/.local/bin`. It needs no `sudo`.

| Variable | Default | |
| --- | --- | --- |
| `AFARA_VERSION` | the latest release | a tag to install instead, e.g. `v0.2.0` |
| `AFARA_INSTALL_DIR` | `~/.local/bin` | where to put the binary |

```sh
curl -fsSL https://raw.githubusercontent.com/Radicand-Labs/afara-release/main/install.sh | AFARA_VERSION=v0.2.0 sh
```

### Homebrew

```sh
brew install --cask radicand-labs/tap/afara
```

### Windows (Scoop)

```powershell
scoop bucket add afara https://github.com/Radicand-Labs/scoop-bucket
scoop install afara
```

### By hand

Download the archive for your platform from [Releases](https://github.com/Radicand-Labs/afara-release/releases), check it against `checksums.txt`, and put `afara` somewhere on your `PATH`.

| Platform | Archive |
| --- | --- |
| macOS, Apple Silicon | `afara_darwin_arm64.tar.gz` |
| macOS, Intel | `afara_darwin_amd64.tar.gz` |
| Linux, x86-64 | `afara_linux_amd64.tar.gz` |
| Linux, ARM | `afara_linux_arm64.tar.gz` |
| Windows | `afara_windows_amd64.zip`, `afara_windows_arm64.zip` |

## What else it needs

- **git.** Afara reads your repository's commits.
- **An AI coding tool**, for `afara generate` and `afara compare`. They run on your machine with one of these, whichever is installed:

  | Tool | Install |
  | --- | --- |
  | Claude Code | `npm install -g @anthropic-ai/claude-code` |
  | OpenAI Codex CLI | `npm install -g @openai/codex` |
  | Gemini CLI | `npm install -g @google/gemini-cli` |

## Get started

```sh
afara auth login      # sign in; also asks which AI model the backend should use
cd your-repository
afara init            # pre-push hook, and a baseline for the history before Afara
afara                 # the interactive shell
```

## Update and uninstall

- **Update:** run the install command again, or `brew upgrade --cask afara`, or `scoop update afara`.
- **Uninstall:** delete `~/.local/bin/afara` (or `brew uninstall --cask afara`, `scoop uninstall afara`). Your sign-in is in `~/.config/afara/`; a repository's local state is in its `.git/afara/`.

## Verifying a download

Every release publishes `checksums.txt` with the SHA-256 of each archive:

```sh
shasum -a 256 -c checksums.txt --ignore-missing
```
