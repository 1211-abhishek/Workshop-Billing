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

[Icons]
Name: "{group}\Workshop Billing System"; Filename: "{app}\flutter_billing_system.exe"
Name: "{commondesktop}\Workshop Billing System"; Filename: "{app}\flutter_billing_system.exe"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop shortcut"; GroupDescription: "Additional icons:"

[Run]
Filename: "{app}\flutter_billing_system.exe"; Description: "Launch Workshop Billing System"; Flags: nowait postinstall skipifsilent