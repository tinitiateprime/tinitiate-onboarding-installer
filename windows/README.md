# Windows student setup

<p align="center">&copy; TINITIATE.COM</p>

## Download the installer to `C:\Code`

### Method 1: Download the ZIP file

Use this method when Git is not installed yet.

1. Open File Explorer and select **This PC** > **Local Disk (C:)**.
2. Create a folder named `Code` so the full path is `C:\Code`.
3. Open <https://github.com/tinitiateprime/tinitiate-onboarding-installer> in a browser.
4. Select **Code** > **Download ZIP**.
5. Extract the ZIP file into `C:\Code`.
6. Rename the extracted folder to `tinitiate-onboarding-installer` if necessary.

The installer must now be located at:

```text
C:\Code\tinitiate-onboarding-installer\windows\install.ps1
```

### Method 2: Clone with Git

Use this method when Git is already installed. Open Command Prompt and run:

```cmd
mkdir C:\Code
cd /d C:\Code
git clone https://github.com/tinitiateprime/tinitiate-onboarding-installer.git
cd tinitiate-onboarding-installer
```

## Install from Administrator Command Prompt

1. Open the Start menu and search for **Command Prompt**.
2. Right-click **Command Prompt** and select **Run as administrator**.
3. Run these commands:

```cmd
cd /d C:\Code\tinitiate-onboarding-installer
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\windows\install.ps1"
```

Do not enter `Set-ExecutionPolicy` directly in Command Prompt. It is a PowerShell command.

## Install from Administrator PowerShell

1. Open the Start menu and search for **PowerShell**.
2. Right-click PowerShell and select **Run as administrator**.
3. Run these commands:

```powershell
Set-Location C:\Code\tinitiate-onboarding-installer
Set-ExecutionPolicy Bypass -Scope Process -Force
& .\windows\install.ps1
```

PowerShell prompts start with `PS`, such as `PS C:\Code>`.

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
python -m pip show pandas numpy requests pyspark jupyter pytest python-dotenv
code --list-extensions
```

If a command is unavailable, restart PowerShell and run the installer once more. Chocolatey exit codes `1641` and `3010` mean a restart is required.
