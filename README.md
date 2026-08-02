# Tinitiate Basic Student Onboarding Installer

One-command installation of the basic workstation tools and a matching basic Docker development environment for new students.

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

Microsoft Teams is intentionally not installed.

## Scope

This repository contains only the basic student installers. It does not install AWS, Azure, Google Cloud, cloud CLIs, cloud SDKs, cloud credentials, or cloud-specific services. Each cloud environment will be defined later in its own Compose YAML file.

## Option 1: Install the desktop software

### Windows

Open **PowerShell as Administrator**, change to this repository, and run:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
& .\windows\install.ps1
```

The script is safe to run again. Restart Windows after it finishes, start Docker Desktop, and rerun the script if an installer requested a reboot.

To run it directly from GitHub after this repository is published:

```powershell
iex (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/tinitiateprime/tinitiate-onboarding-installer/main/windows/install.ps1" -UseBasicParsing).Content
```

See [Windows installation and verification](windows/README.md).

### macOS

From Terminal, change to this repository and run:

```bash
chmod +x macos/install.sh
./macos/install.sh
```

See [macOS installation and verification](macos/README.md).

## Option 2: Start the basic Docker development workspace

Docker Compose provides Python, Node.js, common libraries, Git, and VS Code in the browser. Desktop applications still need the host installer above.

1. Copy `.env.example` to `.env` and replace the sample passwords.
2. Start Docker Desktop.
3. Build and start the environment:

```bash
docker compose up -d --build
```

4. Open <http://localhost:8080> and sign in using `CODE_SERVER_PASSWORD` from `.env`.

Useful commands:

```bash
docker compose ps
docker compose logs -f dev
docker compose down
```

Use `docker compose down -v` only when you intentionally want to delete the editor data volume.

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
