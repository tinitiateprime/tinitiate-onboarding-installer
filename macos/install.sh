#!/usr/bin/env bash
set -euo pipefail

step() {
  printf '\n==> %s\n' "$1"
}

step "Installing Homebrew when needed"
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is not available in PATH. Restart Terminal and rerun this script." >&2
  exit 1
fi

step "Updating Homebrew"
brew update

step "Installing command-line development tools"
brew install git python node

step "Installing desktop applications"
for application in docker visual-studio-code dbeaver-community zoom; do
  if brew list --cask "$application" >/dev/null 2>&1; then
    brew upgrade --cask "$application" || printf '%s is already current or could not be upgraded.\n' "$application"
  else
    brew install --cask "$application"
  fi
done

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
requirements_file="$script_dir/../config/requirements.txt"
extensions_file="$script_dir/../config/vscode-extensions.txt"

if [[ ! -f "$requirements_file" ]]; then
  requirements_file="$(mktemp)"
  curl -fsSL "https://raw.githubusercontent.com/tinitiateprime/tinitiate-onboarding-installer/main/config/requirements.txt" -o "$requirements_file"
fi

if [[ ! -f "$extensions_file" ]]; then
  extensions_file="$(mktemp)"
  curl -fsSL "https://raw.githubusercontent.com/tinitiateprime/tinitiate-onboarding-installer/main/config/vscode-extensions.txt" -o "$extensions_file"
fi

step "Creating the Tinitiate Python environment"
python3 -m venv "${HOME}/.tinitiate/venv"
"${HOME}/.tinitiate/venv/bin/python" -m pip install --upgrade pip
"${HOME}/.tinitiate/venv/bin/python" -m pip install -r "$requirements_file"

step "Installing Visual Studio Code extensions"
code_command="$(command -v code || true)"
if [[ -z "$code_command" && -x "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ]]; then
  code_command="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
fi

if [[ -n "$code_command" ]]; then
  while IFS= read -r extension; do
    [[ -z "$extension" || "$extension" == \#* ]] && continue
    "$code_command" --install-extension "$extension" --force
  done < "$extensions_file"
else
  echo "VS Code was installed, but its command-line launcher was not found. Rerun this script after opening VS Code." >&2
fi

printf '\nTinitiate student software installation is complete.\n'
printf 'Start Docker Desktop and see macos/README.md for verification.\n'
printf 'Activate Python with: source ~/.tinitiate/venv/bin/activate\n'
printf 'Microsoft Teams was not installed.\n'
