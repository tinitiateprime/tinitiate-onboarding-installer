# macOS student setup

<p align="center">&copy; TINITIATE.COM</p>

## Install

Open **Terminal** and run:

```bash
installer_file="$(mktemp)"
curl -fsSL https://raw.githubusercontent.com/tinitiateprime/tinitiate-onboarding-installer/main/macos/install.sh -o "$installer_file" && bash "$installer_file"
```

The installer configures Homebrew, Docker Desktop, Visual Studio Code, DBeaver Community, Python and libraries, Temurin JDK 21, IntelliJ IDEA, Node.js, npm, Git, Zoom, Zoho Cliq, and the common, Python, and Java VS Code extensions. Python and Java are included in this single basic installer; no separate language installer is needed. Notepad++ is Windows-only, so Visual Studio Code is the primary editor on macOS.

Open Docker Desktop once after installation and complete its prompts.

## Python environment

Python packages are isolated in a virtual environment to avoid modifying Homebrew's managed Python installation:

```bash
source ~/.tinitiate/venv/bin/activate
```

## Verify

```bash
brew --version
python3 --version
java -version
javac -version
node --version
npm --version
git --version
docker --version
docker compose version
code --version
~/.tinitiate/venv/bin/python -m pip show pandas numpy requests pyspark jupyter pytest python-dotenv
code --list-extensions
```
