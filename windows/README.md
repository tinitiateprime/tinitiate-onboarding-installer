# Windows student setup

<p align="center">&copy; TINITIATE.COM</p>

## Install

1. Open the Start menu and search for **PowerShell**.
2. Right-click PowerShell and select **Run as administrator**.
3. Change to this repository and run:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
& .\windows\install.ps1
```

The installer configures Chocolatey, Docker Desktop, Notepad++, Visual Studio Code, DBeaver Community, Python, Python libraries, Node.js, npm, Git, Zoom, and the standard VS Code extensions. Microsoft Teams is not included.

Restart Windows when the installer finishes. Open Docker Desktop once and complete any WSL 2 or license prompts it displays.

## Verify

Open a new PowerShell window and run:

```powershell
choco --version
python --version
python -m pip --version
node --version
npm --version
git --version
docker --version
docker compose version
code --version
```

Check the Python packages and VS Code extensions:

```powershell
python -m pip show pandas numpy requests boto3 psycopg2-binary SQLAlchemy pyspark jupyter pytest python-dotenv
code --list-extensions
```

If a command is unavailable, restart PowerShell and run the installer once more. Chocolatey exit codes `1641` and `3010` mean a restart is required.
