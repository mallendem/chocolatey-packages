$ErrorActionPreference = "Stop"
$packageToolsDir        = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$executablePath         = Join-Path $packageToolsDir 'docker-compose.exe'

$executableTargetDir    = 'C:\Program Files\Docker\cli-plugins\'
$executableTargetPath   = Join-Path $executableTargetDir 'docker-compose.exe'

# create plugin directory if it doesn't exist
if (-not (Test-Path -Path $executableTargetDir)) {
    $null = New-Item -Path $executableTargetDir -ItemType Directory
}

# remove docker-compose shim if it still exists
Uninstall-BinFile -name docker-compose -ErrorAction:Ignore

# clean up old installation location (backward compatibility)
$oldExecutableDir  = 'C:\ProgramData\Docker\cli-plugins\'
$oldExecutablePath = Join-Path $oldExecutableDir 'docker-compose.exe'
$oldDockerPath     = Split-Path -Path $oldExecutableDir -Parent

if (Test-Path -Path $oldExecutablePath) {
    Remove-Item -Path $oldExecutablePath -Force
}

# remove old plugin directory if empty
if (Test-Path -Path $oldExecutableDir) {
    if ($null -eq (Get-ChildItem -Path $oldExecutableDir)) {
        Remove-Item -Path $oldExecutableDir -Force
    }
}

# remove old docker directory if empty
if (Test-Path -Path $oldDockerPath) {
    if ($null -eq (Get-ChildItem -Path $oldDockerPath)) {
        Remove-Item -Path $oldDockerPath -Force
    }
}

# move executable
Move-Item -Path $executablePath -Destination $executableTargetPath -Force
