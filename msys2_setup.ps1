# This piece of code will stop the code when account any error
$PSNativeCommandUseErrorActionPreference = $true
$ErrorActionPreference = 'Stop'

# Check if MSYS2 installed correctly
if (Test-Path "C:\msys64\msys2.exe") {
    Write-Host "MSYS2 installed successfully"
} else {
    Write-Host "MSYS2 installation failed"
}

Start-Sleep -Seconds 2

try {
    # Copy bundled packages to MSYS2 cache
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    Copy-Item "$scriptDir\pkg\*" "C:\msys64\var\cache\pacman\pkg\" -Force

    # Install from local cache — no internet needed
    Start-Process -FilePath "C:\msys64\usr\bin\bash.exe" -ArgumentList '--login -c "pacman -S --needed --noconfirm base-devel mingw-w64-ucrt-x86_64-toolchain"' -Wait -NoNewWindow
} catch {
    Write-Host "Warning: pacman failed - $($_.Exception.Message)"
}

# Add to PATH
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
[Environment]::SetEnvironmentVariable("Path", $currentPath + ";C:\msys64\ucrt64\bin", "User")
$env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")

# Verify GCC
$gcc = Get-Command gcc -ErrorAction SilentlyContinue
if ($gcc) {
    Write-Host "GCC installed at: $($gcc.Source)"
} else {
    Write-Host "GCC not found - something went wrong"
}