#Requires -Version 5.1
# Tinitiate basic installer: common tools, Python, and Java.
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
    'temurin21',
    'intellijidea-community',
    'nodejs-lts',
    'git',
    'zoom'
)

$packageFailures = [Collections.Generic.List[string]]::new()
foreach ($package in $packages) {
    Write-Step "Installing $package if needed"
    & choco.exe install $package --yes --no-progress
    if ($LASTEXITCODE -notin @(0, 1641, 3010)) {
        $packageFailures.Add($package)
    }
}

Update-ProcessPath

if ($packageFailures.Count -gt 0) {
    throw "These packages failed to install: $($packageFailures -join ', '). Restart Windows if requested, then rerun the installer."
}

Write-Step 'Installing Zoho Cliq if needed'
$cliqInstalled = Get-ItemProperty -Path @(
    'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
    'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
) -ErrorAction SilentlyContinue | Where-Object {
    $_.DisplayName -in @('Cliq Deployment Tool', 'Cliq Machine-Wide Installer')
}
if (-not $cliqInstalled) {
    # Official Zoho MSI; checksum from microsoft/winget-pkgs Zoho.Cliq 1.8.4.
    $cliqArchitecture = 'x64'
    $cliqHash = '4491F31D16D3BD97A9CB10973B9474158E93CE6BF5C69732E56488DB007C0D92'
    if (-not [Environment]::Is64BitOperatingSystem) {
        $cliqArchitecture = 'x32'
        $cliqHash = 'AE97D2AFA36DE53DA72C72EDF23FBE4E75D24F9D1A17BE3A08009FABB1C31D8C'
    }
    $cliqMsi = Join-Path $env:TEMP ('tinitiate-cliq-' + [guid]::NewGuid().ToString('N') + '.msi')
    $cliqLog = Join-Path $env:TEMP 'tinitiate-cliq-install.log'
    try {
        Invoke-WebRequest -Uri "https://downloads.zohocdn.com/chat-desktop/windows/Cliq-1.8.4-$cliqArchitecture.msi" -OutFile $cliqMsi -UseBasicParsing
        if ((Get-FileHash -LiteralPath $cliqMsi -Algorithm SHA256).Hash -ne $cliqHash) {
            throw 'The Zoho Cliq installer checksum did not match.'
        }
        $cliqProcess = Start-Process -FilePath 'msiexec.exe' -ArgumentList "/i `"$cliqMsi`" /qn /norestart /L*v `"$cliqLog`"" -WindowStyle Hidden -Wait -PassThru
        if ($cliqProcess.ExitCode -notin @(0, 1641, 3010)) {
            throw "Zoho Cliq installation failed with exit code $($cliqProcess.ExitCode). See $cliqLog"
        }
    } finally {
        if (Test-Path -LiteralPath $cliqMsi) { Remove-Item -LiteralPath $cliqMsi -Force }
    }
}

Write-Step 'Configuring Java 21'
$jdkRoot = Join-Path $env:ProgramFiles 'Eclipse Adoptium'
$jdk = Get-ChildItem -LiteralPath $jdkRoot -Directory -Filter 'jdk-21*' -ErrorAction SilentlyContinue |
    Where-Object { Test-Path (Join-Path $_.FullName 'bin\javac.exe') } |
    Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $jdk) {
    throw 'Temurin JDK 21 was not found. Restart Windows and rerun this installer.'
}
$env:JAVA_HOME = $jdk.FullName
[Environment]::SetEnvironmentVariable('JAVA_HOME', $env:JAVA_HOME, 'Machine')
$javaBin = Join-Path $env:JAVA_HOME 'bin'
$machinePathEntries = [Environment]::GetEnvironmentVariable('Path', 'Machine') -split ';' |
    Where-Object { $_ -and $_.TrimEnd('\') -ine $javaBin.TrimEnd('\') }
[Environment]::SetEnvironmentVariable('Path', (@($javaBin) + $machinePathEntries -join ';'), 'Machine')
$env:Path = "$env:JAVA_HOME\bin;$env:Path"
& "$env:JAVA_HOME\bin\javac.exe" -version
if ($LASTEXITCODE -ne 0) { throw 'Java compiler verification failed.' }

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
if ($LASTEXITCODE -ne 0) { throw 'Updating pip failed. Rerun the installer after resolving the error above.' }
& $pythonCommand.Source @pythonArgs -m pip install -r $requirementsPath
if ($LASTEXITCODE -ne 0) { throw 'Installing Python libraries failed. Rerun the installer after resolving the error above.' }

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
        ForEach-Object {
            & $codeCommand.Source --install-extension $_.Trim() --force
            if ($LASTEXITCODE -ne 0) { throw "Installing VS Code extension $($_.Trim()) failed." }
        }
} else {
    throw 'VS Code was installed but code.cmd is not in PATH. Restart PowerShell and rerun this script to install extensions.'
}

Write-Host "`nTinitiate student software installation is complete." -ForegroundColor Green
Write-Host 'Restart Windows, start Docker Desktop, and follow windows/README.md to verify the tools.'
Write-Host 'Basic tools, Python, Java 21, IntelliJ IDEA, and Zoho Cliq are installed.'
