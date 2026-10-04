#!/bin/sh
# Installs the Afara CLI from its GitHub Releases.
#
#   curl -fsSL https://raw.githubusercontent.com/Radicand-Labs/afara-release/main/install.sh | sh
#
# Settings (environment variables, all optional):
#   AFARA_VERSION      a release tag, e.g. v1.2.0 (default: the latest release)
#   AFARA_INSTALL_DIR  where to put the binary (default: ~/.local/bin)
#   AFARA_REPO         owner/name the releases are published in
#   AFARA_DOWNLOAD_URL where the release files are, instead of GitHub (for
#                      releases hosted elsewhere, or a local dist/ to test)
#
# It needs no root: the default directory is the user's own. It checks the
# download against the release's checksums before installing anything.
set -eu

REPO="${AFARA_REPO:-Radicand-Labs/afara-release}"
VERSION="${AFARA_VERSION:-latest}"
INSTALL_DIR="${AFARA_INSTALL_DIR:-$HOME/.local/bin}"

say() { printf '%s\n' "$*"; }
fail() { printf 'afara install: %s\n' "$*" >&2; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

# --- platform --------------------------------------------------------------

case "$(uname -s)" in
  Darwin) os=darwin ;;
  Linux) os=linux ;;
  MINGW* | MSYS* | CYGWIN*) fail "on Windows, install with Scoop instead: scoop install afara" ;;
  *) fail "unsupported system $(uname -s); build from source with: go install github.com/afara/cli@latest" ;;
esac

case "$(uname -m)" in
  x86_64 | amd64) arch=amd64 ;;
  arm64 | aarch64) arch=arm64 ;;
  *) fail "unsupported processor $(uname -m)" ;;
esac

# An Intel shell on an Apple Silicon Mac (Rosetta) reports x86_64; the native
# binary is the better one to install.
if [ "$os" = darwin ] && [ "$arch" = amd64 ] && [ "$(sysctl -n sysctl.proc_translated 2>/dev/null || echo 0)" = 1 ]; then
  arch=arm64
fi

archive="afara_${os}_${arch}.tar.gz"
if [ -n "${AFARA_DOWNLOAD_URL:-}" ]; then
  base="${AFARA_DOWNLOAD_URL%/}"
elif [ "$VERSION" = latest ]; then
  base="https://github.com/$REPO/releases/latest/download"
else
  base="https://github.com/$REPO/releases/download/$VERSION"
fi

# --- download ----------------------------------------------------------------

if have curl; then
  fetch() { curl -fsSL "$1" -o "$2"; }
elif have wget; then
  fetch() { wget -q "$1" -O "$2"; }
else
  fail "needs curl or wget to download"
fi

tmp="$(mktemp -d 2>/dev/null || mktemp -d -t afara)"
trap 'rm -rf "$tmp"' EXIT INT TERM

say "Downloading afara ($VERSION) for $os/$arch..."
fetch "$base/$archive" "$tmp/$archive" ||
  fail "could not download $base/$archive. Check the release exists, and that $REPO is public."
fetch "$base/checksums.txt" "$tmp/checksums.txt" ||
  fail "could not download the release's checksums"

# --- verify ------------------------------------------------------------------

want="$(grep " $archive\$" "$tmp/checksums.txt" | cut -d' ' -f1)"
[ -n "$want" ] || fail "$archive is not listed in the release's checksums"
if have sha256sum; then
  got="$(sha256sum "$tmp/$archive" | cut -d' ' -f1)"
elif have shasum; then
  got="$(shasum -a 256 "$tmp/$archive" | cut -d' ' -f1)"
else
  fail "needs sha256sum or shasum to verify the download"
fi
[ "$got" = "$want" ] || fail "checksum mismatch for $archive: the download is corrupt or was tampered with"

# --- install -----------------------------------------------------------------

tar -xzf "$tmp/$archive" -C "$tmp" afara
mkdir -p "$INSTALL_DIR"
# Into place by rename, so a running afara is never half-overwritten.
mv "$tmp/afara" "$INSTALL_DIR/afara.new"
chmod 0755 "$INSTALL_DIR/afara.new"
mv "$INSTALL_DIR/afara.new" "$INSTALL_DIR/afara"
# Downloaded by curl, so not quarantined; clear it anyway in case it was.
if [ "$os" = darwin ] && have xattr; then
  xattr -d com.apple.quarantine "$INSTALL_DIR/afara" 2>/dev/null || true
fi

say "Installed $("$INSTALL_DIR/afara" --version 2>/dev/null || echo afara) to $INSTALL_DIR/afara"

# --- what else it needs --------------------------------------------------------

case ":$PATH:" in
  *":$INSTALL_DIR:"*) ;;
  *)
    say ""
    say "$INSTALL_DIR is not on your PATH. Add it, e.g. for zsh:"
    say "  echo 'export PATH=\"$INSTALL_DIR:\$PATH\"' >> ~/.zshrc && exec zsh"
    ;;
esac

if ! have git; then
  say ""
  say "Afara reads your repository with git, which is not installed."
fi

if ! have claude && ! have codex && ! have gemini; then
  say ""
  say "generate and compare need an AI coding tool on this machine. Install one of:"
  say "  Claude Code:      npm install -g @anthropic-ai/claude-code"
  say "  OpenAI Codex CLI: npm install -g @openai/codex"
  say "  Gemini CLI:       npm install -g @google/gemini-cli"
fi

say ""
say "Next: afara auth login, then afara init in your repository."
