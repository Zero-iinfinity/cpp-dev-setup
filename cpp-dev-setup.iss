; C++ Development Environment Installer
; Author: Zero_iinfinity | https://github.com/Zero-iinfinity

#define MyAppName "C++ Dev Environment"
#define MyAppVersion "1.0"
#define MyAppPublisher "Zero_iinfinity"
#define MyAppURL "https://github.com/Zero-iinfinity"

[Setup]
AppId={{DE26384C-6EDE-4B15-B4D2-B15417304E05}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
CreateAppDir=no

PrivilegesRequired=admin
OutputBaseFilename=cpp-dev-setup
SolidCompression=yes

WizardStyle=modern
UsedUserAreasWarning=no
SetupIconFile=setup-icon.ico

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

; Checkbox shown to user during install — unchecking skips VS Code install
[Tasks]
Name: "installvscode"; Description: "Install Visual Studio Code (uncheck if already installed)"
[Files]
Source: "msys2-x86_64-20241208.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall
Source: "VSCodeSetup.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall
Source: "msys2_setup.ps1"; DestDir: "{tmp}"; Flags: deleteafterinstall
Source: "final_setup.ps1"; DestDir: "{tmp}"; Flags: deleteafterinstall
Source: "pkg\*"; DestDir: "{tmp}\pkg"; Flags: deleteafterinstall recursesubdirs

[Run]
; Step 1 — MSYS2 (user controlled)
Filename: "{tmp}\msys2-x86_64-20241208.exe"; StatusMsg: "Installing MSYS2..."; Flags: waituntilterminated

; Step 2 — VS Code silently (already works fine)
Filename: "{tmp}\VSCodeSetup.exe"; Parameters: "/VERYSILENT /NORESTART /MERGETASKS=addcontextmenufiles,addcontextmenufolders,addtopath,associatewithfiles,!runcode"; StatusMsg: "Installing VS Code..."; Flags: waituntilterminated; Tasks: installvscode

; Step 3 — pacman + PATH
Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File ""{tmp}\msys2_setup.ps1"""; StatusMsg: "Installing GCC Compiler..."; Flags: runhidden waituntilterminated

; Step 4 — folders + JSON + Test.cpp
Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File ""{tmp}\final_setup.ps1"""; StatusMsg: "Configuring VS Code for C++..."; Flags: runhidden waituntilterminated

; Step 5 — Launch VS Code
Filename: "C:\Program Files\Microsoft VS Code\Code.exe"; Parameters: """{userdesktop}\C++_learning"""; Description: "Launch VS Code"; Flags: nowait postinstall skipifsilent runasoriginaluser

Filename: "cmd.exe"; Parameters: "/c ""C:\Program Files\Microsoft VS Code\bin\code.cmd"" --install-extension ms-vscode.cpptools --force"; StatusMsg: "Installing C++ Extension..."; Flags: runhidden waituntilterminated runasoriginaluser

Filename: "cmd.exe"; Parameters: "/c ""C:\Program Files\Microsoft VS Code\bin\code.cmd"" --install-extension ms-vscode.cpptools-extension-pack --force"; StatusMsg: "Installing C++ Extension Pack..."; Flags: runhidden waituntilterminated runasoriginaluser
[Code]
function IsVSCodeInstalled(): Boolean;
begin
  Result := FileExists('C:\Program Files\Microsoft VS Code\Code.exe');
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = wpSelectTasks then
  begin
    if IsVSCodeInstalled() then
      WizardSelectTasks('!installvscode')  // auto-uncheck if found
    else
      WizardSelectTasks('installvscode');  // auto-check if not found
  end;
end;