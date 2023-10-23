program TorControlPanel;

uses
  System.SysUtils,
  Vcl.Forms,
  Vcl.Styles,
  Winapi.Windows,
  synautil,
  Main in 'Main.pas' {Tcp},
  Functions in 'Functions.pas',
  Languages in 'Languages.pas',
  Addons in 'Addons.pas',
  ConstData in 'ConstData.pas';

var
  i, Locker: Integer;
  AppDataDir, DataDir: string;

{$IFDEF RELEASE}
  {$SETPEFlAGS
    IMAGE_FILE_DEBUG_STRIPPED or
    IMAGE_FILE_LINE_NUMS_STRIPPED or
    IMAGE_FILE_LOCAL_SYMS_STRIPPED or
    IMAGE_FILE_RELOCS_STRIPPED or
    IMAGE_FILE_LARGE_ADDRESS_AWARE
    }
  {$WEAKLINKRTTI ON}
  {$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
{$ENDIF}

{$SETPEOSVERSION 5.0}
{$SETPESUBSYSVERSION 5.0}

{$R *.res}

begin
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}
  UserProfile := 'User';
  if ParamCount > 0 then
  begin
    for i := 1 to ParamCount do
    begin
      if pos('-profile=', ParamStr(i)) <> 0 then
        UserProfile := SeparateRight(ParamStr(i), '=');
    end;
  end;
  ProgramDir := ExtractShortPathName(GetCurrentDir + '\');
  DataDir := ProgramDir + 'Data\' + UserProfile + '\';
  AppDataDir := GetEnvironmentVariable('appdata') + '\Tcp\' + UserProfile + '\';

  if IsDirectoryWritable(ProgramDir) and not DirectoryExists(AppDataDir) then
    UserDir := DataDir
  else
    UserDir := AppDataDir;

  ForceDirectories(UserDir);

  Locker := FileCreate(UserDir + 'lock.tcp');
  if Locker = -1 then
    Exit;
  UserDir := ExtractShortPathName(UserDir);

  Application.Initialize;
  Application.MainFormOnTaskbar := False;
  Application.ShowMainForm := False;
  Application.Title := 'Панель управления Tor';
  Application.CreateForm(TTcp, Tcp);
  Application.Run;
end.

