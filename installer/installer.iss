[Setup]
AppName=Workshop Billing System
AppVersion=1.0
DefaultDirName={pf}\WorkshopBillingSystem
DefaultGroupName=Workshop Billing System
UninstallDisplayIcon={app}\flutter_billing_system.exe
OutputDir=.
OutputBaseFilename=WorkshopBillingSystemInstaller
Compression=lzma
SolidCompression=yes

[Files]
Source: "MyBillingApp\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "vc_redist.x64.exe"; DestDir: "{tmp}"; Flags: dontcopy

[Icons]
Name: "{group}\Workshop Billing System"; Filename: "{app}\flutter_billing_system.exe"
Name: "{commondesktop}\Workshop Billing System"; Filename: "{app}\flutter_billing_system.exe"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop shortcut"; GroupDescription: "Additional icons:"

[Run]
Filename: "{tmp}\vc_redist.x64.exe"; Parameters: "/install /quiet /norestart"; StatusMsg: "Installing Microsoft Visual C++ Redistributable..."; Check: NeedsVC
Filename: "{app}\flutter_billing_system.exe"; Description: "Launch Workshop Billing System"; Flags: nowait postinstall skipifsilent

[Code]
function NeedsVC(): Boolean;
begin
  // Check if the VC++ 2015-2022 redistributable is installed
  Result := not RegKeyExists(HKLM, 'SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64');
end;