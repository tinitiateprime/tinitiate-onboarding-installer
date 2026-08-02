#Requires -Version 5.1
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

function Write-Step {
    param([Parameter(Mandatory)][string]$Message)
    Write-Host "`n==> $Message" -ForegroundColor Cyan
}

function Test-Administrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Update-ProcessPath {
    $machinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path = "$machinePath;$userPath"
}

if (-not (Test-Administrator)) {
    throw 'Run this installer from PowerShell using Run as administrator.'
}

Write-Step 'Installing Chocolatey when needed'
if (-not (Get-Command choco.exe -ErrorAction SilentlyContinue)) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    Invoke-Expression ((New-Object Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    Update-ProcessPath
}

if (-not (Get-Command choco.exe -ErrorAction SilentlyContinue)) {
    throw 'Chocolatey was not found after installation. Restart PowerShell and run this script again.'
}

$packages = @(
    'docker-desktop',
    'notepadplusplus',
    'vscode',
    'dbeaver',
    'python',
    'nodejs-lts',
    'git',
    'zoom'
)

$packageFailures = [Collections.Generic.List[string]]::new()
foreach ($package in $packages) {
    Write-Step "Installing or upgrading $package"
    & choco.exe upgrade $package --yes --no-progress
    if ($LASTEXITCODE -notin @(0, 1641, 3010)) {
        $packageFailures.Add($package)
    }
}

Update-ProcessPath

Write-Step 'Installing Python libraries'
$requirementsUrl = 'https://raw.githubusercontent.com/tinitiateprime/tinitiate-onboarding-installer/main/config/requirements.txt'
$requirementsPath = Join-Path $env:TEMP 'tinitiate-requirements.txt'

if ($PSScriptRoot -and (Test-Path (Join-Path $PSScriptRoot '..\config\requirements.txt'))) {
    $requirementsPath = (Resolve-Path (Join-Path $PSScriptRoot '..\config\requirements.txt')).Path
} else {
    Invoke-WebRequest -Uri $requirementsUrl -OutFile $requirementsPath -UseBasicParsing
}

$pythonCommand = Get-Command python.exe -ErrorAction SilentlyContinue
if (-not $pythonCommand) {
    $pythonCommand = Get-Command py.exe -ErrorAction SilentlyContinue
}
if (-not $pythonCommand) {
    throw 'Python was installed but is not available in PATH. Restart PowerShell and rerun this script.'
}

$pythonArgs = @()
if ($pythonCommand.Name -eq 'py.exe') {
    $pythonArgs += '-3'
}
& $pythonCommand.Source @pythonArgs -m pip install --upgrade pip
& $pythonCommand.Source @pythonArgs -m pip install -r $requirementsPath

Write-Step 'Installing Visual Studio Code extensions'
$extensionsUrl = 'https://raw.githubusercontent.com/tinitiateprime/tinitiate-onboarding-installer/main/config/vscode-extensions.txt'
$extensionsPath = Join-Path $env:TEMP 'tinitiate-vscode-extensions.txt'
if ($PSScriptRoot -and (Test-Path (Join-Path $PSScriptRoot '..\config\vscode-extensions.txt'))) {
    $extensionsPath = (Resolve-Path (Join-Path $PSScriptRoot '..\config\vscode-extensions.txt')).Path
} else {
    Invoke-WebRequest -Uri $extensionsUrl -OutFile $extensionsPath -UseBasicParsing
}

$codeCommand = Get-Command code.cmd -ErrorAction SilentlyContinue
if ($codeCommand) {
    Get-Content $extensionsPath |
        Where-Object { $_ -and -not $_.TrimStart().StartsWith('#') } |
        ForEach-Object { & $codeCommand.Source --install-extension $_.Trim() --force }
} else {
    Write-Warning 'VS Code was installed but code.cmd is not in PATH. Restart PowerShell and rerun this script to install extensions.'
}

if ($packageFailures.Count -gt 0) {
    throw "These packages failed to install: $($packageFailures -join ', ')"
}

Write-Host "`nTinitiate student software installation is complete." -ForegroundColor Green
Write-Host 'Restart Windows, start Docker Desktop, and follow windows/README.md to verify the tools.'
Write-Host 'Microsoft Teams was not installed.'
