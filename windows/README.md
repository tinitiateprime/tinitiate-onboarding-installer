# Windows student setup

<p align="center">&copy; TINITIATE.COM</p>

## Install basic software (Python + Java)

Open **PowerShell as administrator**, paste this single command, and press **Enter**:

```powershell
iex (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/tinitiateprime/tinitiate-onboarding-installer/main/windows/install.ps1" -UseBasicParsing).Content
```

This installs Docker Desktop, Notepad++, VS Code, DBeaver, Python and libraries, Java 21, IntelliJ IDEA, Node.js and npm, Git, Zoom, Zoho Cliq, and the common, Python, and Java VS Code extensions.

Wait for **installation is complete**, then restart Windows. Open Docker Desktop and complete its setup prompts.

## Verify

Open a new PowerShell window and run:

```powershell
choco --version
python --version
java -version
javac -version
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
python -m pip show pandas numpy requests pyspark jupyter pytest python-dotenv
code --list-extensions
```

If a command is unavailable, restart PowerShell and run the installer once more. Chocolatey exit codes `1641` and `3010` mean a restart is required.
