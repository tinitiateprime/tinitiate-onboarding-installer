# Tinitiate Student Onboarding Installer

One-command installation of the basic workstation tools and separate Docker development environments for new students.

<p align="center">&copy; TINITIATE.COM</p>

## What is included

| Tool | Windows host | macOS host | Docker workspace |
| --- | :---: | :---: | :---: |
| Docker Desktop | Yes | Yes | Required on host |
| Notepad++ | Yes | No (Windows only) | No |
| Visual Studio Code | Yes | Yes | Browser-based code-server |
| DBeaver Community | Yes | Yes | No |
| Python and libraries | Yes | Yes | Yes |
| Node.js and npm | Yes | Yes | Yes |
| VS Code extensions | Yes | Yes | Yes |
| Git | Yes | Yes | Yes |
| Zoom | Yes | Yes | No |

## Student Docker choices

Students select one Compose file. Every choice provides Python, Node.js, Git, the shared libraries, and browser-based VS Code, plus the tools for that platform.

| Choice | Compose file | Additional tools/services |
| --- | --- | --- |
| Basic | `compose.yaml` | Shared development tools only |
| [AWS](environments/aws/README.md) | `environments/aws/compose.yaml` | AWS CLI v2, boto3, Floci AWS emulator, Floci UI |
| [Azure](environments/azure/README.md) | `environments/azure/compose.yaml` | Azure CLI, Azure Python SDKs, Floci Azure emulator, Floci UI |
| [GCP](environments/gcp/README.md) | `environments/gcp/compose.yaml` | Google Cloud CLI, Google Cloud Python SDKs, Floci GCP emulator, Floci UI |
| [Snowflake](environments/snowflake/README.md) | `environments/snowflake/compose.yaml` | Snowflake CLI, connector, and Snowpark |
| [Databricks](environments/databricks/README.md) | `environments/databricks/compose.yaml` | Databricks CLI, SDK, SQL connector, and Delta Lake |

The AWS, Azure, and GCP choices default to local Floci endpoints and dummy/local credentials where applicable. Students can learn without a paid cloud account. Snowflake and Databricks connect to real accounts after the student configures authentication; no credentials are stored in this repository.

## Option 1: Install the desktop software

### Windows

For a new computer, create `C:\Code` and download the project into that folder. If Git is already installed, run:

```powershell
New-Item -ItemType Directory -Path C:\Code -Force
Set-Location C:\Code
git clone https://github.com/tinitiateprime/tinitiate-onboarding-installer.git
Set-Location tinitiate-onboarding-installer
```

Then open **PowerShell as Administrator** and run:

```powershell
Set-Location C:\Code\tinitiate-onboarding-installer
Set-ExecutionPolicy Bypass -Scope Process -Force
& .\windows\install.ps1
```

Press **Enter after each line**. If using one line, separate the last two commands with a semicolon: `Set-ExecutionPolicy Bypass -Scope Process -Force; & .\windows\install.ps1`.

The script is safe to run again. Restart Windows after it finishes, start Docker Desktop, and rerun the script if an installer requested a reboot.

To run it directly from GitHub after this repository is published:

```powershell
iex (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/tinitiateprime/tinitiate-onboarding-installer/main/windows/install.ps1" -UseBasicParsing).Content
```

If Git is not installed or you are using Administrator Command Prompt, see the complete [Windows download, installation, and verification instructions](windows/README.md).

### macOS

From Terminal, change to this repository and run:

```bash
chmod +x macos/install.sh
./macos/install.sh
```

See [macOS installation and verification](macos/README.md).

## Option 2: Start a Docker development workspace

Docker Compose provides Python, Node.js, common libraries, Git, and VS Code in the browser. Desktop applications still need the host installer above.

1. Copy `.env.example` to `.env` and replace the sample passwords.
2. Start Docker Desktop.
3. Choose one environment and build it from the repository root. For example, start AWS with:

```bash
docker compose -f environments/aws/compose.yaml up -d --build
```

Other choices:

```bash
docker compose -f environments/azure/compose.yaml up -d --build
docker compose -f environments/gcp/compose.yaml up -d --build
docker compose -f environments/snowflake/compose.yaml up -d --build
docker compose -f environments/databricks/compose.yaml up -d --build
```

Use `docker compose up -d --build` without `-f` for the basic environment.

4. Open <http://localhost:8080> and sign in using `CODE_SERVER_PASSWORD` from `.env`. For AWS, Azure, and GCP, the Floci dashboard is at <http://localhost:4500>.

Only run one student environment at a time unless you assign different ports in `.env`.

Useful commands:

```bash
docker compose -f environments/aws/compose.yaml ps
docker compose -f environments/aws/compose.yaml logs -f dev
docker compose -f environments/aws/compose.yaml down
```

Replace `aws` with the selected environment. Use `docker compose -f environments/aws/compose.yaml down -v` only when you intentionally want to delete that environment's editor, CLI configuration, and emulator data volumes.

### Verify the selected tools

Open the code-server terminal and run the matching commands:

```bash
# AWS
aws --version
aws s3 ls

# Azure
az version
az storage container list --connection-string "$AZURE_STORAGE_CONNECTION_STRING"

# GCP
gcloud version
gcloud storage buckets list

# Snowflake
snow --version

# Databricks
databricks version
```

The cloud-specific Compose files intentionally mount the Docker socket into Floci. Floci needs it to create local containers for services such as functions and databases. Only use these teaching environments with trusted images and code.

## Python libraries

The same library list is used by both host installers and the Docker image. Edit [config/requirements.txt](config/requirements.txt) to change it.

## VS Code extensions

Desktop VS Code uses [config/vscode-extensions.txt](config/vscode-extensions.txt). Browser-based code-server uses [config/code-server-extensions.txt](config/code-server-extensions.txt), because Microsoft's Pylance extension is not distributed through the Open VSX marketplace; BasedPyright supplies equivalent Python type checking there.

## Troubleshooting

- Run the Windows installer from an elevated PowerShell window.
- Docker Desktop requires hardware virtualization; on Windows it may also request WSL 2 features and a restart.
- If `code` is not found immediately after installation, restart the terminal and rerun the installer.
- On macOS, Python libraries are installed in `~/.tinitiate/venv`. Activate it with `source ~/.tinitiate/venv/bin/activate`.
- Change all values marked `change-me` before using the Docker environment.
