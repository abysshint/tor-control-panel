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
  i, FH: Integer;

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

  if IsDirectoryWritable(ProgramDir) then
    UserDir := ProgramDir + 'Data\' + UserProfile + '\'
  else
    UserDir := GetEnvironmentVariable('appdata') + '\Tcp\' + UserProfile + '\';

  ForceDirectories(UserDir);

  FH := FileCreate(UserDir + 'lock.tcp');
  if FH = -1 then
    Exit;
  UserDir := ExtractShortPathName(UserDir);

  Application.Initialize;
  Application.MainFormOnTaskbar := False;
  Application.ShowMainForm := False;
  Application.Title := 'Панель управления Tor';
  Application.CreateForm(TTcp, Tcp);
  Application.Run;
end.

