# macOS student setup

<p align="center">&copy; TINITIATE.COM</p>

## Install

From Terminal, change to this repository and run:

```bash
chmod +x macos/install.sh
./macos/install.sh
```

The installer configures Homebrew, Docker Desktop, Visual Studio Code, DBeaver Community, Python, Python libraries, Node.js, npm, Git, Zoom, and the standard VS Code extensions. Microsoft Teams is not included. Notepad++ is Windows-only, so Visual Studio Code is the primary editor on macOS.

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
node --version
npm --version
git --version
docker --version
docker compose version
code --version
~/.tinitiate/venv/bin/python -m pip show pandas numpy requests boto3 psycopg2-binary SQLAlchemy pyspark jupyter pytest python-dotenv
code --list-extensions
```
