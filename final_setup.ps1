# This piece of code will stop the code when account any error
$PSNativeCommandUseErrorActionPreference = $true
$ErrorActionPreference = 'Stop'

# List of the extensions that are required to run C++ code in VScode
# $extensions = @(
#     "ms-vscode.cpptools",
#     "ms-vscode.cpptools-extension-pack"
# )

# # Checks if device is connected to internet or not
# if ((Test-NetConnection -ComputerName 8.8.8.8 -InformationLevel Quiet) -eq $true) {
#     # Loop through the list of the extensions and install them one by one if already installed --force to update
#     foreach($i in $extensions){
#     try {
#         & "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd" --install-extension $i --force
#     } catch {
#         Write-Host "Warning: Could not install extension $i - skipping"
#     }
# }
# } else {
#     Write-Output "No Network Connection....Can Not complete the installation of the extension require to run C++ in vs code"
# }


$ProjectPath = "$([Environment]::GetFolderPath('Desktop'))\C++_learning"

$VSCodePath  = "$ProjectPath\.vscode"

# Creates a C++ Directory To check the code and for the compiler settings 
New-Item -ItemType Directory $ProjectPath -Force

# Create .vscode folder for the vscode configuration to run C++ code
New-Item -ItemType Directory $VSCodePath  -Force

$FilePath1 = "$VSCodePath\launch.json"
$FilePath2 = "$VSCodePath\tasks.json"
$FilePath3 = "$VSCodePath\settings.json"

# REquired configuration file for the Vs code to run C++ code

# ── launch.json ──────────────────────────────────────────
$launchJson = @'
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Debug C++ File",
            "type": "cppdbg",
            "request": "launch",
            "program": "${fileDirname}\\${fileBasenameNoExtension}.exe",
            "args": [],
            "stopAtEntry": false,
            "cwd": "${fileDirname}",
            "environment": [],
            "externalConsole": true,
            "MIMode": "gdb",
            "miDebuggerPath": "C:\\msys64\\ucrt64\\bin\\gdb.exe",
            "setupCommands": [
                {
                    "description": "Enable pretty-printing for gdb",
                    "text": "-enable-pretty-printing",
                    "ignoreFailures": true
                }
            ],
            "preLaunchTask": "Build C++ File"
        }
    ]
}
'@

# ── tasks.json ───────────────────────────────────────────
$tasksJson = @'
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Build C++ File",
            "type": "shell",
            "command": "C:\\msys64\\ucrt64\\bin\\g++.exe",
            "args": [
                "-g",
                "${file}",
                "-o",
                "${fileDirname}\\${fileBasenameNoExtension}.exe"
            ],
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "problemMatcher": ["$gcc"],
            "detail": "Build the active C++ file"
        }
    ]
}
'@

# ── settings.json ────────────────────────────────────────
$settingsJson = @'
{
    "C_Cpp.default.compilerPath": "C:\\msys64\\ucrt64\\bin\\g++.exe",
    "C_Cpp.default.cStandard": "c17",
    "C_Cpp.default.cppStandard": "c++17",
    "C_Cpp.default.intelliSenseMode": "windows-gcc-x64",
    "files.autoSave": "afterDelay",
    "editor.formatOnSave": true
}
'@

New-Item -ItemType File $FilePath1 -Force
Set-Content -Path $FilePath1 -Value $launchJson

New-Item -ItemType File $FilePath2 -Force
Set-Content -Path $FilePath2 -Value $tasksJson

New-Item -ItemType File $FilePath3 -Force
Set-Content -Path $FilePath3 -Value $settingsJson



# Sample C++ code to run and verify if the setup is sucessful or not 
# ── Test.cpp ────────────────────────────────────────
$TestCPP = @'
#include<iostream>
using namespace std;

int main(){
    cout<<"Hello World!";
    return 0;
}
'@


# Create first .cpp that user can test itself
$FilePath4 = "$ProjectPath\Test.cpp"
New-Item -ItemType File $FilePath4 -Force
Set-Content -Path $FilePath4 -Value $TestCPP

