unit Functions;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ActiveX, Winapi.ShlObj, System.Classes,
  Winapi.ShellApi, Winapi.WinSock, System.StrUtils, System.SysUtils, System.IniFiles,
  System.Variants, System.Masks, System.DateUtils, System.Generics.Collections, System.Math,
  System.Win.ComObj, System.Win.Registry, Vcl.Graphics, Vcl.Forms, Vcl.Controls, Vcl.Grids,
  Vcl.Menus, Vcl.Imaging.pngimage, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Clipbrd, Vcl.Dialogs,
  Vcl.Themes, synacode, blcksock, pingsend, synautil, ConstData, Addons;

const
  JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE = $00002000;
  CREATE_BREAKAWAY_FROM_JOB = $01000000;

type
  TBridge = record
    Ip: string;
    Port: Word;
    Hash: string;
    Transport: string;
    Params: string;
  end;

  TCharUpCaseTable = array [Char] of Char;
  TPing = class(TPINGSend)
  public
    constructor Create(Timeout: Integer);
  end;
  TUserGrid = class(TCustomGrid);

var
  CharUpCaseTable: TCharUpCaseTable;

  function CreateJob(lpJobAttributes: PSecurityAttributes; lpName: LPCSTR): THandle; stdcall;
    external 'kernel32.dll' name 'CreateJobObjectA';

  function CompareNaturalText(psz1, psz2: PWideChar): Integer; stdcall;
    external 'shlwapi.dll' name 'StrCmpLogicalW';

  function BoolToStrDef(Value: Boolean): string;
  function GetCommandLineFileName(const CommandLine: string): string;
  function CheckSplitButton(Button: TButton; DirectClick: Boolean): Boolean;
  function GetAssocUpDown(AName: string): TUpdown;
  function GetCountryValue(IpStr: string): Byte;
  function GetIntDef(const Value, Default, Min, Max: Integer): Integer;
  function GetPortProtocol(PortID: Word): string;
  function GetFileVersionStr(const FileName: string): string;
  function FindStr(Mask, Str: string): Boolean;
  function CtrlKeyPressed(Key: Char): Boolean;
  function GetArrayIndex(Data: array of string; Value: string): Integer;
  function GetConstantIndex(Key: string): Integer;
  function GetDefaultsValue(Key: string; Default: string = ''): string;
  function GetSystemDir(CSIDL: Integer): string;
  function RegistryFileExists(Root: HKEY; Key, Param: string): Boolean;
  function RegistryGetValue(Root: HKEY; Key, Param: string): string;
  function CreateShortcut(const CmdLine, Args, WorkDir, LinkFile, IconFile: string): IPersistFile;
  function GetFullFileName(FileName: string): string;
  function GetHost(Host: string): string;
  function GetAddressFromSocket(SocketStr: string): string;
  function GetPortFromSocket(SocketStr: string): Word;
  function GetRouterBySocket(SocketStr: string): string;
  function FormatHost(HostStr: string): string;
  function ExtractDomain(Url: string; HasPort: Boolean = False): string;
  function GetAvailPhysMemory: Cardinal;
  function GetCPUCount: Integer;
  function AnsiStrToHex(const Value: AnsiString): string;
  function StrToHex(Value: string): string;
  function HexToStr(hex: string): string;
  function AuthStageReady(AuthMethod: Integer): Boolean;
  function Crypt(str, Key: string): string;
  function Decrypt(str, Key: string): string;
  function FileGetString(Filename: string; Hex: Boolean = False): string;
  function ExecuteProcess(CmdLine: string; Flags: TProcessFlags = []; JobHandle: THandle = 0): TProcessInfo;
  function RandomString(StrLen: Integer): string;
  function GetPasswordHash(const password: string): string;
  function CheckFileVersion(FileVersion, StaticVersion: string): Boolean;
  function Explode(sPart, sInput: string): ArrOfStr;
  function GetDirFromArray(Data: array of string; FileName: string = ''; ShowFileName: Boolean = False): string;
  function GetLogFileName(SeparateType: Integer): string;
  function GetRoutersParamsCount(Mask: Integer): Integer;
  function GetTorConfig(const Param, Default: string; Flags: TConfigFlags = []; ParamType: TParamType = ptString; MinValue: Integer = 0; MaxValue: Integer = 0; Prefix: string = ''): string;
  function BytesFormat(Bytes: Double): string;
  function FormatSizeToBytes(SizeStr: string): Int64;
  function UTCToLocalTime(AValue: TDateTime): TDateTime;
  function TorDateFormat(Date: string): string;
  function CheckEditSymbols(Key: Char; UserSymbols: AnsiString = ''; EditMsg: string = ''): string;
  function CheckEditString(Str: string; UserSymbols: AnsiString = ''; AllowNumbersFirst: Boolean = True; EditMsg: string = ''; edComponent: TEdit = nil): string;
  function IsEmptyRow(aSg: TStringGrid; ARow: Integer): Boolean;
  function IsEmptyGrid(aSg: TStringGrid): Boolean;
  function IsDirectoryWritable(const Dir: string): Boolean;
  function PortTCPIsOpen(Port: Word; IpStr: string; Timeout: Integer): Boolean;
  function GetBridgeCert: string;
  function InsensPosEx(const SubStr, S: string; Offset: Integer = 1): Integer;
  function GetPrefixSize(Prefix: string; Localize: Boolean = False): Int64;
  function ConvertSize(SizeStr: string; Prefix: string = ''): Int64;
  function HasBrackets(Str: string): Boolean;
  function IsIPv4(IpStr: string): Boolean;
  function IsIPv6(IpStr: string): Boolean;
  function GetNodeType(NodeStr: string): TListType;
  function ValidData(Str: string; ListType: TListType; State: Boolean = False): Boolean;
  function ValidSize(SizeStr: string; Min, Max: Int64; Prefix: string): Boolean;
  function ValidInt(IntStr: string; Min, Max: Integer): Boolean; overload;
  function ValidInt(IntStr: string; Min, Max: Int64): Boolean; overload;
  function ValidHash(HashStr: string): Boolean;
  function ValidAddress(AddrStr: string; AllowCidr: Boolean = False; ReqBrackets: Boolean = False): Byte;
  function ValidHost(HostStr: string; AllowRootDomain: Boolean = False; AllowIp: Boolean = True; ReqBrackets: Boolean = False): Boolean;
  function ValidBridge(BridgeStr: string; BridgeType: TBridgeType): Boolean;
  function ValidTransport(TransportStr: string): Boolean;
  function ValidSocket(SocketStr: string; AllowHostNames: Boolean = False): Byte;
  function ValidPolicy(PolicyStr: string): Boolean;
  function GetMsgCaption(Caption: string; MsgType: TMsgType): string;
  function TryParseBridge(BridgeStr: string; out Bridge: TBridge): Boolean;
  function IpToInt(IpStr: string): Cardinal;
  function IntToIp(Ip: Cardinal): string;
  function CidrToRange(CidrStr: string): TIPv4Range;
  function IpInRanges(const IpStr: string; RangesData: array of string): Boolean;
  function CompIntObjectAsc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
  function CompIntObjectDesc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
  function CompIntDesc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
  function CompIntAsc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
  function CompTextAsc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
  function CompTextDesc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
  function CompSizeAsc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
  function CompSizeDesc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
  function CompParamsAsc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
  function CompParamsDesc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
  function GetTaskBarPos: TTaskBarPos;
  function SendPing(const Host: string; Timeout: Integer): Integer;
  function RemoveBrackets(Str: string; Square: Boolean = False): string;
  function SearchEdit(EditControl: TCustomEdit; const SearchString: String; Options: TFindOptions; FindFirst: Boolean = False): Boolean;
  function ShowMsg(Msg: string; Caption: string = ''; MsgType: TMsgType = mtInfo; Question: Boolean = False): Boolean;
  function MemoToLine(Memo: TMemo; ListType: TListType; Sorted: Boolean = False; Separator: string = ','; State: Boolean = False): string;
  function MenuToInt(Menu: TMenuItem): Integer;
  function GetTransportID(TypeStr: string): Byte;
  function GetTransportChar(TransportID: Byte): string;
  function TryUpdateMask(var Mask: Byte; Param: Byte; Condition: Boolean): Boolean;
  function TryGetDataFromStr(Str: string; DataType: TListType; out DatatStr: string): Boolean;
  function SampleDown(Data: ArrOfPoint; Threshold: Integer): ArrOfPoint;
  function FileTimeToDateTime(const FileTime: TFileTime): TDateTime;
  function GetPortsValue(const PortsData, PortStr: string): Integer;
  function GetFileID(FileName: string; SkipFileExists: Boolean = False; ConstData: string = ''): string;
  procedure DeleteFiles(const FileMask: string; TimeOffset: Integer = 0);
  procedure DeleteDir(const DirName: string);
  procedure LineToMemo(Line: string; Memo: TMemo; ListType: TListType; Sorted: Boolean = False; Separator: string = ',');
  procedure IntToMenu(Menu: TMenuItem; Mask: Integer; DisableUnchecked: Boolean = False);
  procedure GetNodes(var Nodeslist: string; NodeType: TNodeType; Favorites: Boolean; ini: TMemIniFile = nil);
  procedure SetTorConfig(const Param, Value: string; Flags: TConfigFlags = []; Separator: string = '|');
  procedure DeleteTorConfig(const Param: string; Flags: TConfigFlags = []);
  procedure SetConfigBoolean(Section, Ident: string; Value: Boolean);
  procedure SetConfigInteger(Section, Ident: string; Value: Integer); overload;
  procedure SetConfigInteger(Section, Ident: string; Value: Int64); overload;
  procedure SetConfigString(Section, Ident: string; Value: string);
  procedure SaveToLog(str: string; LogFile: string);
  procedure AddUPnPEntry(Port: Integer; Desc, LanIp: string; Test: Boolean; var Msg: string);
  procedure RemoveUPnPEntry(First: Integer; Second: Integer = 0; Third: Integer = 0);
  procedure SetGridLastCell(aSg: TStringGrid; Show: Boolean = True; ScrollTop: Boolean = False; ManualSort: Boolean = False; ARow: Integer = -1; ACol: Integer = -1; FindCol: Integer = 0);
  procedure ClearCol(aSg: TStringGrid; ACol: Integer);
  procedure ClearRow(aSg: TStringGrid; ARow: Integer);
  procedure ClearGrid(aSg: TStringGrid; DeleteBlankRows: Boolean = True);
  procedure FindInGridColumn(aSg: TStringGrid; ACol: Integer; Key: Char);
  procedure InitCharUpCaseTable(var Table: TCharUpCaseTable);
  procedure DeleteARow(aSg: TStringGrid; ARow: Integer);
  procedure CheckFileEncoding(FileName, BackupFile: string);
  procedure Flush(FileName: string);
  procedure UpdateConfigFile(ini: TMemIniFile);
  procedure CheckLabelEndEllipsis(lbComponent: TLabel; MaxWidth: Integer; EllipsisType: TEllipsisPosition; UseHint: Boolean; IgnoreFormSize: Boolean);
  procedure BeginUpdateTable(aSg: TStringGrid);
  procedure EndUpdateTable(aSg: TStringGrid);
  procedure sgSort(aSg: TStringGrid; aCol: Integer; aCompare: TStringListSortCompare);
  procedure GetLocalInterfaces(ComboBox: TComboBox; RecentHost: string = '');
  procedure ComboBoxAutoWidth(const AComboBox: TCombobox);
  procedure GridDrawIcon(aSg: TStringGrid; Rect: TRect; ls: TImageList; Index: Integer; W: Integer = 16; H: Integer = 16);
  procedure GridDrawSortArrows(aSg: TStringGrid; Rect: TRect);
  procedure GridSetKeyboardLayout(aSg: TStringGrid; ACol: Integer);
  procedure GridSetFocus(aSg: TStringGrid);
  procedure GridShowHints(aSg: TStringGrid);
  procedure GridScrollCheck(aSg: TStringGrid; ACol, ColWidth: Integer);
  procedure GridSelectCell(aSg: TStringGrid; ACol, ARow: Integer);
  procedure GridKeyDown(aSg: TStringGrid; Shift: TShiftState; var Key: Word);
  procedure GridCheckAutoPopup(aSg: TStringGrid; ARow: Integer; AllowEmptyRows: Boolean = False);
  procedure GoToInvalidOption(PageID: TTabSheet; Msg: string = ''; edComponent: TCustomEdit = nil);
  procedure DeleteDuplicatesFromList(List: TStringList; ListType: TListType = ltNoCheck);
  procedure SortNodesList(ls: TStringList; DescSort: Boolean = False);
  procedure ControlsDisable(Control: TWinControl);
  procedure ControlsEnable(Control: TWinControl);
  procedure LoadTorConfig;
  procedure SaveTorConfig;
  procedure LoadIconsFromResource(ImageList: TImageList; ResourceName: string);
  procedure LoadThemesList(ThemesList: TComboBox; LastStyle: string);
  procedure LoadStyle(ThemesList: TCombobox);
  procedure EditMenuHandle(MenuType: TEditMenuType);
  procedure EditMenuEnableCheck(MenuItem: TMenuItem; MenuType: TEditMenuType);
  procedure MenuSelectPrepare(SelMenu: TMenuItem = nil; UnSelMenu: TMenuItem = nil; HandleDisabled: Boolean = False);
  procedure ShellOpen(Url: string);
  procedure GetSettings(Section: string; UpDownControl: TUpDown; ini: TMemIniFile); overload;
  procedure GetSettings(Section: string; CheckBoxControl: TCheckBox; ini: TMemIniFile); overload;
  procedure GetSettings(Section: string; MenuControl: TMenuItem; ini: TMemIniFile; Default: Boolean = True); overload;
  procedure GetSettings(Section: string; ComboBoxControl: TComboBox; ini: TMemIniFile; Default: Integer = 0); overload;
  procedure GetSettings(Section: string; EditControl: TEdit; ini: TMemIniFile; RemoveSquareBrackets: Boolean = False); overload;
  procedure GetSettings(UpDownControl: TUpDown; Flags: TConfigFlags = []); overload;
  procedure GetSettings(CheckBoxControl: TCheckBox; Flags: TConfigFlags = []); overload;
  procedure GetSettings(MenuControl: TMenuItem; Flags: TConfigFlags = []; Default: Boolean = True); overload;
  procedure SetSettings(Section: string; UpDownControl: TUpDown; ini: TMemIniFile); overload;
  procedure SetSettings(Section: string; CheckBoxControl: TCheckBox; ini: TMemIniFile); overload;
  procedure SetSettings(Section: string; MenuControl: TMenuItem; ini: TMemIniFile); overload;
  procedure SetSettings(Section: string; ComboBoxControl: TComboBox; ini: TMemIniFile; SaveIndex: Boolean = True; UseFormatHost: Boolean = False); overload;
  procedure SetSettings(Section: string; EditControl: TEdit; ini: TMemIniFile; UseFormatHost: Boolean = False); overload;
  procedure SetSettings(Section, Ident: string; Value: string; ini: TMemIniFile); overload;
  procedure SetSettings(Section, Ident: string; Value: Integer; ini: TMemIniFile); overload;
  procedure SetSettings(Section, Ident: string; Value: Int64; ini: TMemIniFile); overload;
  procedure SetSettings(Section, Ident: string; Value: Boolean; ini: TMemIniFile); overload;
  procedure DeleteSettings(Section, Ident: string; ini: TMemIniFile);
  function GetSettings(Section, Ident: string; Default: string; ini: TMemIniFile): string; overload;
  function GetSettings(Section, Ident: string; Default: Integer; ini: TMemIniFile): Integer; overload;
  function GetSettings(Section, Ident: string; Default: Int64; ini: TMemIniFile): Int64; overload;
  function GetSettings(Section, Ident: string; Default: Boolean; ini: TMemIniFile): Boolean; overload;
  procedure EnableComposited(WinControl: TWinControl);

implementation

uses
  Main, Languages;


constructor TPing.Create(Timeout: Integer);
begin
  inherited Create;
  FTimeout := Timeout;
end;

function GetPortsValue(const PortsData, PortStr: string): Integer;
var
  ParseStr: ArrOfStr;
  Search, i: Integer;
begin
  if PortsData <> '' then
  begin
    ParseStr := Explode('|', PortsData);
    for i := 0 to Length(ParseStr) - 1 do
    begin
      Search := Pos(PortStr + ':', ParseStr[i]);
      if Search = 1 then
      begin
        Result := StrToIntDef(Copy(ParseStr[i], Length(PortStr) + 2), 0);
        Exit;
      end;
    end;
  end;
  Result := 0;
end;

function BoolToStrDef(Value: Boolean): string;
begin
  if Value then
    Result := '1'
  else
    Result := '0'
end;

function SendPing(const Host: string; Timeout: Integer): Integer;
begin
  with TPing.Create(Timeout) do
  try
    Result := -1;
    if Ping(Host) then
      if ReplyError = IE_NoError then
        Result := PingTime;
  finally
    Free;
  end;
end;

function GetAssocUpDown(AName: string): TUpdown;
begin
  Result := TUpdown(Tcp.FindComponent('ud' + copy(AName, 3)));
end;

function GetCountryValue(IpStr: string): Byte;
var
  GeoIpInfo: TGeoIpInfo;
begin
  if GeoIpDic.TryGetValue(IpStr, GeoIpInfo) then
    Result := GeoIpInfo.cc
  else
    Result := DEFAULT_COUNTRY_ID;
end;

function GetArrayIndex(Data: array of string; Value: string): Integer;
var
  i: Integer;
begin
  for i := 0 to Length(Data) - 1 do
  begin
    if Data[i] = Value  then
    begin
      Result := i;
      Exit;
    end;
  end;
  Result := -1;
end;

function GetConstantIndex(Key: string): Integer;
var
  Index: Integer;
begin
  if ConstDic.TryGetValue(Key, Index) then
    Result := Index
  else
    Result := -1;
end;

function GetDefaultsValue(Key: string; Default: string = ''): string;
var
  Value: string;
begin
  if DefaultsDic.TryGetValue(Key, Value) then
  begin
    if Trim(Value) <> '' then
    begin
      Result := Value;
      Exit;
    end;
  end;
  Result := Default;
end;

function FindStr(Mask, Str: string): Boolean;
begin
  if not MatchesMask(Mask, '*[*?-!]*') then
    Result := InsensPosEx(Mask, Str) <> 0
  else
    Result := MatchesMask(Str, Mask);
end;

procedure ShellOpen(Url: string);
var
  Port: Word;
  Address: string;
begin
  if Url = '' then
    Exit;
  if (Pos('://', Url) <> 0) or (Pos(':\', Url) <> 0) or (Pos('mailto:', Url) = 1) then
    ShellExecute(Application.Handle, 'open', PChar(Url), nil, nil, SW_NORMAL)
  else
  begin
    Port := GetPortFromSocket(Url);
    if Port = 0 then
      Port := 80;
    Address := ExtractDomain(Url, True);
    ShellExecute(Application.Handle, 'open', PChar(GetPortProtocol(Port) + '://' + FormatHost(Address) + ':' + IntToStr(Port)), nil, nil, SW_NORMAL);
  end;
end;

procedure GridDrawIcon(aSg: TStringGrid; Rect: TRect; ls: TImageList; Index: Integer; W: Integer = 16; H: Integer = 16);
begin
  ls.Draw(aSg.Canvas, Rect.Left + (Rect.Width - W) div 2, Rect.Top + (Rect.Height - H) div 2, Index, True);
end;

procedure GridDrawSortArrows(aSg: TStringGrid; Rect: TRect);
begin
  case aSg.SortType of
    SORT_ASC: Tcp.lsMain.Draw(aSg.Canvas, Rect.Right - 14, Rect.Top + (Rect.Height - 16) div 2, 13, True);
    SORT_DESC: Tcp.lsMain.Draw(aSg.Canvas, Rect.Right - 14, Rect.Top + (Rect.Height - 16) div 2, 14, True);
  end;
end;

procedure GridSetKeyboardLayout(aSg: TStringGrid; ACol: Integer);
var
  EN_COLS, LOCALE_COLS: set of Byte;
begin
  case aSg.Tag of
    GRID_FILTER:
    begin
      EN_COLS := [0];
      LOCALE_COLS := [2];
    end;
    GRID_ROUTERS:
    begin
      EN_COLS := [1];
      LOCALE_COLS := [4];
    end;
  end;
  if ACol in EN_COLS then
    ActivateKeyboardLayout(1033, 0)
  else
    if ACol in LOCALE_COLS then
      ActivateKeyboardLayout(CurrentLanguage, 0);
end;

procedure GridSelectCell(aSg: TStringGrid; ACol, ARow: Integer);
begin
  if not aSg.ScrollKeyDown then
  begin
    aSg.SelCol := ACol;
    if aSg.Focused then
      GridSetKeyboardLayout(aSg, ACol)
  end
  else
    aSg.ScrollKeyDown := False;
  aSg.SelRow := ARow;
end;

procedure GridKeyDown(aSg: TStringGrid; Shift: TShiftState; var Key: Word);
var
  i: Integer;
begin
  if (ssCtrl in Shift) and (Key = 67) then
    Clipboard.AsText := aSg.Cells[aSg.SelCol, aSg.SelRow];

  if Key in [VK_PRIOR, VK_NEXT, VK_END, VK_HOME, VK_LEFT, VK_UP, VK_RIGHT, VK_DOWN] then
    aSg.ScrollKeyDown := True
  else
    aSg.ScrollKeyDown := False;

  case Key of
    VK_APPS:
    begin
      case aSg.Tag of
        GRID_HS, GRID_HSP: GridCheckAutoPopup(aSg, aSg.Row, True);
        else
          GridCheckAutoPopup(aSg, aSg.Row);
      end;
    end;
    VK_LEFT:
    begin
      Key := 0;
      if (aSg.SelCol > 0) then
      begin
        if (aSg.ColWidths[aSg.SelCol - 1] > 0) then
          dec(aSg.SelCol)
        else
        begin
          for i := aSg.SelCol - 1 downto 0 do
          begin
            if (aSg.ColWidths[i] > 0) then
            begin
              aSg.SelCol := i;
              Break;
            end;
          end;
        end;
      end;
      aSg.Col := aSg.SelCol;
      GridSetKeyboardLayout(aSg, aSg.SelCol)
    end;
    VK_RIGHT:
    begin
      Key := 0;
      if (aSg.SelCol < aSg.ColCount - 1) then
      begin
        if aSg.ColWidths[aSg.SelCol + 1] > 0 then
          inc(aSg.SelCol)
        else
        begin
          for i := aSg.SelCol + 1 to aSg.ColCount - 1 do
          begin
            if (aSg.ColWidths[i] > 0) then
            begin
              aSg.SelCol := i;
              Break;
            end;
          end;
        end;
      end;
      aSg.Col := aSg.SelCol;
      GridSetKeyboardLayout(aSg, aSg.SelCol)
    end;
  end;
end;

procedure CheckLabelEndEllipsis(lbComponent: TLabel; MaxWidth: Integer; EllipsisType: TEllipsisPosition; UseHint: Boolean; IgnoreFormSize: Boolean);
begin
  if ((FormSize = 0) or IgnoreFormSize) and (lbComponent.Canvas.TextWidth(lbComponent.Caption) > Round(MaxWidth * Scale)) then
  begin
    lbComponent.EllipsisPosition := EllipsisType;
    lbComponent.Width := Round(MaxWidth * Scale);
    if UseHint then
      lbComponent.Hint := lbComponent.Caption;
  end
  else
  begin
    lbComponent.EllipsisPosition := epNone;
    lbComponent.AutoSize := True;
    if UseHint then
      lbComponent.Hint := '';
  end;
end;

procedure GridSetFocus(aSg: TStringGrid);
begin
  if aSg.Focused then
    Exit
  else
  begin
    if aSg.CanFocus and (Tcp.FindDialog.Handle = 0) then
      aSg.SetFocus;
  end;
end;

procedure GridShowHints(aSg: TStringGrid);
begin
  if (aSg.MovCol > -1) and (aSg.Canvas.TextWidth(aSg.Cells[aSg.MovCol, aSg.MovRow]) + 2 > aSg.ColWidths[aSg.MovCol]) then
  begin
    aSg.Hint := aSg.Cells[aSg.MovCol, aSg.MovRow];
    Application.ActivateHint(Mouse.CursorPos);
  end
  else
  begin
    Application.CancelHint;
    aSg.Hint := '';
  end;
end;

procedure GridCheckAutoPopup(aSg: TStringGrid; ARow: Integer; AllowEmptyRows: Boolean = False);
begin
  if not Assigned(aSg.PopupMenu) then
    Exit;
  if (ARow > 0) and (not IsEmptyRow(aSg, ARow) or AllowEmptyRows) then
    aSg.PopupMenu.AutoPopup := True
  else
    aSg.PopupMenu.AutoPopup := False;
end;

procedure InitCharUpCaseTable(var Table: TCharUpCaseTable);
var
  n: cardinal;
begin
  for n := 0 to Length(Table) - 1 do
    Table[Char(n)] := Char(n);
  CharUpperBuff(@Table, Length(Table));
end;

function InsensPosEx(const SubStr, S: string; Offset: Integer = 1): Integer;
var
  n: Integer;
  SubStrLength: Integer;
  SLength: Integer;
label
  Fail;
begin
  Result := 0;
  if S = '' then Exit;
  if Offset <= 0 then Exit;

  SubStrLength := Length(SubStr);
  SLength := Length(s);

  if SubStrLength > SLength then Exit;

  Result := Offset;
  while SubStrLength <= (SLength - Result + 1) do
  begin
    for n := 1 to SubStrLength do
      if CharUpCaseTable[SubStr[n]] <> CharUpCaseTable[s[Result+n-1]] then
        goto Fail;
      Exit;
Fail:
    Inc(Result);
  end;
  Result := 0;
end;

procedure ClearRow(aSg: TStringGrid; ARow: Integer);
var
  i: Integer;
begin
  for i := aSg.FixedCols to aSg.ColCount - 1 do
    aSg.Cells[i, ARow] := '';
end;

procedure ClearCol(aSg: TStringGrid; ACol: Integer);
var
  i: Integer;
begin
  for i := aSg.FixedRows to aSg.RowCount - 1 do
    aSg.Cells[ACol, i] := '';
end;

procedure ClearGrid(aSg: TStringGrid; DeleteBlankRows: Boolean = True);
var
  i, j: Integer;
begin
  for i := 1 to aSg.RowCount - 1 do
    for j := 0 to aSg.ColCount - 1 do
      aSg.Cells[j, i] := '';
  if DeleteBlankRows then
    aSg.RowCount := 2;
end;

function IsEmptyRow(aSg: TStringGrid; ARow: Integer): Boolean;
var
  i: Integer;
begin
  Result := True;
  for i := 0 to aSg.ColCount - 1 do
    if aSg.Cells[i, ARow] <> '' then
    begin
      Result := False;
      Break;
    end;
end;

function IsEmptyGrid(aSg: TStringGrid): Boolean;
begin
  if (aSg.RowCount = 2) and (IsEmptyRow(aSg, 1)) then
    Result := True
  else
    Result := False;
end;

procedure FindInGridColumn(aSg: TStringGrid; ACol: Integer; Key: Char);
var
  i: Integer;
begin
  if GetTickCount > SearchTimer + 1000 then
    SearchStr := '';
  SearchStr := SearchStr + Key;
  for i := 1 to aSg.RowCount - 1 do
    if AnsiLowerCase(copy(aSg.Cells[ACol, i], 1, Length(SearchStr))) = SearchStr then
    begin
      aSg.Row := i;
      aSg.Col := ACol;
      SearchTimer := GetTickCount;
      break;
    end;
end;

procedure GoToInvalidOption(PageID: TTabSheet; Msg: string = ''; edComponent: TCustomEdit = nil);
begin
  if LastPlace <> 0 then
    Tcp.sbShowOptions.Click;
  Tcp.pcOptions.ActivePage := PageID;
  if Msg <> '' then
  begin
    ShowMsg(Msg, TransStr('324'), mtWarning);
    if Assigned(edComponent) and (edComponent.CanFocus) then
    begin
      edComponent.SetFocus;
      edComponent.SelectAll;
    end;
  end;
  SetConfigInteger('Main', 'LastPlace', LastPlace);
  SetConfigInteger('Main', 'OptionsPage', PageID.TabIndex);
end;

function CheckEditString(Str: string; UserSymbols: AnsiString = ''; AllowNumbersFirst: Boolean = True; EditMsg: string = ''; edComponent: TEdit = nil): string;
var
  i: Integer;
  Temp: string;
  ParentBox: TGroupBox;
begin
  Result := '';
  ParentBox := nil;
  if Assigned(edComponent) then
  begin
    if edComponent.GetParentComponent is TGroupBox then
    begin
      ParentBox := TGroupBox(edComponent.GetParentComponent);
      EditMsg := TTabSheet(ParentBox.GetParentComponent).Caption + ' - ' + ParentBox.Caption + ' - ' + EditMsg + BR + BR
    end
    else
      EditMsg := TTabSheet(edComponent.GetParentComponent).Caption + ' - ' + EditMsg + BR + BR;
  end;
  if Length(Str) > 0 then
  begin
    if not AllowNumbersFirst and ValidInt(Str[1], 0, MAXINT) then
    begin
      Result := TransStr('398');
    end;

    if Result = '' then
    begin
      for i := 1 to Length(Str) do
      begin
        Temp := CheckEditSymbols(Str[i], UserSymbols, EditMsg);
        if Temp <> '' then
        begin
          Result := Temp;
          Break;
        end;
      end;
    end;

  end;
  if Assigned(edComponent) and (Result <> '') then
  begin
    if Assigned(ParentBox) then
      GoToInvalidOption(TTabSheet(ParentBox.GetParentComponent), Result, edComponent)
    else
      GoToInvalidOption(TTabSheet(edComponent.GetParentComponent), Result, edComponent);
  end;
end;

function CheckEditSymbols(Key: Char; UserSymbols: AnsiString = ''; EditMsg: string = ''): string;
var
  i: Integer;
  UserCharSet: TSysCharSet;
  UserMsg: string;
begin
  UserMsg := EditMsg + TransStr('269');
  UserCharSet := [];
  if UserSymbols <> '' then
  begin
    UserMsg := StringReplace(UserMsg, ' ' + TransStr('270') + ' ', ', ', []) + ' ' + TransStr('270') + ' ';
    for i := 1 to Length(UserSymbols) do
    begin
      Include(UserCharSet, UserSymbols[i]);
      UserMsg := UserMsg + Char(UserSymbols[i]);
    end;
  end;
  if not CharInSet(Key, ['0'..'9', 'A'..'Z', 'a'..'z', #8]) and
     not CharInSet(Key, UserCharSet) then
    Result := UserMsg
  else
    Result := '';
end;

function MenuToInt(Menu: TMenuItem): Integer;
var
 i: Integer;
begin
  Result := 0;
  for i := 0 to Menu.Count - 1 do
    if Menu.Items[i].AutoCheck and Menu.Items[i].Checked then
      Inc(Result, Menu.Items[i].Tag);
end;

procedure IntToMenu(Menu: TMenuItem; Mask: Integer; DisableUnchecked: Boolean = False);
var
 i: Integer;
 Max, Default: Integer;
begin
  Default := 0;
  Max := 0;
  case Menu.Tag of
    1: begin Default := SHOW_NODES_FILTER_DEFAULT; Max := SHOW_NODES_FILTER_MAX; end;
    2: begin Default := ROUTER_FILTER_DEFAULT; Max := ROUTER_FILTER_MAX; end;
    3: begin Default := CIRCUIT_FILTER_DEFAULT; Max := CIRCUIT_FILTER_MAX;end;
  4,5: begin Default := TPL_MENU_DEFAULT; Max := TPL_MENU_MAX; end;
    6: begin Default := AUTOSEL_NODES_DEFAULT; Max := AUTOSEL_NODES_MAX; end;
  end;
  if (Mask < 0) or (Mask > Max) then
    Mask := Default;
  for i := Menu.Count - 1 downto 0 do
  begin
    if Menu.Items[i].AutoCheck then
    begin
      if Mask and Menu.Items[i].Tag <> 0 then
      begin
        Menu.Items[i].Checked := True;
        Menu.Items[i].Enabled := True;
        Dec(Mask, Menu.Items[i].Tag);
      end
      else
      begin
        Menu.Items[i].Checked := False;
        Menu.Items[i].Enabled := not DisableUnchecked;
      end;
    end;

  end;
end;

procedure MenuSelectPrepare(SelMenu: TMenuItem = nil; UnSelMenu: TMenuItem = nil; HandleDisabled: Boolean = False);
var
  i: Integer;
  SelCount, UnSelCount, EnableCount: Integer;
  Parent: TMenuItem;
begin

  if Assigned(SelMenu) then
    Parent := SelMenu.Parent
  else
    if Assigned(UnSelMenu) then
      Parent := UnSelMenu.Parent
    else
      Exit;

  SelCount := 0;
  UnSelCount := 0;
  EnableCount := 0;

  for i := 0 to Parent.Count - 1 do
  begin
    if Parent.Items[i].AutoCheck and (Parent.Items[i].Enabled or HandleDisabled) then
    begin
      Inc(EnableCount);
      if Parent.Items[i].Checked then
        Inc(SelCount)
      else
        Inc(UnSelCount);
    end;
  end;
  if Assigned(SelMenu) then
  begin
    SelMenu.Enabled := (EnableCount > 0) and (UnSelCount > 0);
    SelMenu.Tag := 1;
    SelMenu.HelpContext := Integer(HandleDisabled);
  end;
  if Assigned(UnSelMenu) then
  begin
    UnSelMenu.Enabled := (EnableCount > 0) and (SelCount > 0);
    UnSelMenu.Tag := 0;
    UnSelMenu.HelpContext := Integer(HandleDisabled);
  end;

end;

function TorDateFormat(Date: string): string;
var
  fs: TFormatSettings;
begin
  fs.DateSeparator := '-';
  fs.ShortDateFormat := 'yyyy-MM-dd';
  fs.TimeSeparator := ':';
  fs.ShortTimeFormat := 'hh:mm';
  fs.LongTimeFormat := 'hh:mm:ss';
  Result := DateTimeToStr(UTCToLocalTime(StrToDateTime(Date, fs)));
end;

function UTCToLocalTime(AValue: TDateTime): TDateTime;
var
  ST1, ST2: TSystemTime;
  TZ: TTimeZoneInformation;
begin
  GetTimeZoneInformation(TZ);
  DateTimeToSystemTime(AValue, ST1);
  SystemTimeToTzSpecificLocalTime(@TZ, ST1, ST2);
  Result := SystemTimeToDateTime(ST2);
end;

function LocalTimeToUTC(AValue: TDateTime): TDateTime;
var
  ST1, ST2: TSystemTime;
  TZ: TTimeZoneInformation;
begin
  GetTimeZoneInformation(TZ);
  TZ.Bias := -TZ.Bias;
  TZ.StandardBias := -TZ.StandardBias;
  TZ.DaylightBias := -TZ.DaylightBias;
  DateTimeToSystemTime(AValue, ST1);
  SystemTimeToTzSpecificLocalTime(@TZ, ST1, ST2);
  Result := SystemTimeToDateTime(ST2);
end;

function HasBrackets(Str: string): Boolean;
begin
  Result := (Str[1] = '[') and (Str[Length(Str)] = ']');
end;

function RemoveBrackets(Str: string; Square: Boolean = False): string;
begin
  if Square then
  begin
    Result := StringReplace(Str, '[', '', [rfReplaceAll]);
    Result := StringReplace(Result, ']', '', [rfReplaceAll]);
  end
  else
  begin
    Result := StringReplace(Str, '{', '', [rfReplaceAll]);
    Result := StringReplace(Result, '}', '', [rfReplaceAll]);
  end;
end;

procedure GetNodes(var Nodeslist: string; NodeType: TNodeType; Favorites: Boolean; ini: TMemIniFile = nil);
var
  Count, i: Integer;
  Nodes: ArrOfStr;
  FilterInfo: TFilterInfo;
  FNodeType: TNodeTypes;
  NodeStr: string;
  lbComponent: TLabel;
begin
  Count := 0;
  if Nodeslist <> '' then
  begin
    if Favorites then
    begin
      Nodes := Explode(',', AnsiUpperCase(StringReplace(RemoveBrackets(Nodeslist), '$', '', [rfReplaceAll])));
      for i := 0 to Length(Nodes) - 1 do
      begin
        if ValidData(Nodes[i], ltNode) then
        begin
          if Length(Nodes[i]) = 2 then
            Nodes[i] := AnsiLowerCase(Nodes[i]);
          if Pos('/', Nodes[i]) <> 0 then
            RangesDic.AddOrSetValue(Nodes[i], CidrToRange(Nodes[i]));
          NodesDic.TryGetValue(Nodes[i], FNodeType);
          Include(FNodeType, NodeType);
          NodesDic.AddOrSetValue(Nodes[i], FNodeType);
          Inc(Count);
        end
        else
          Nodes[i] := '';
      end;
      lbComponent := Tcp.GetFavoritesLabel(Byte(NodeType));
      if (lbComponent.Tag = 0) and (lbComponent.HelpContext = 0) and (Count > 0) then
        lbComponent.HelpContext := 1;
      lbComponent.Tag := Count;
    end
    else
    begin
      Nodes := Explode(',', AnsiLowerCase(RemoveBrackets(Nodeslist)));
      for i := 0 to Length(Nodes) - 1 do
      begin
        if FilterDic.TryGetValue(Nodes[i], FilterInfo) then
        begin
          Include(FilterInfo.Data, NodeType);
          FilterDic.AddOrSetValue(Nodes[i], FilterInfo);
          Inc(Count);
        end
        else
          Nodes[i] := '';
      end;
    end;
    if (ini <> nil) and (Length(Nodes) <> Count) then
    begin
      Nodeslist := '';
      NodeStr := '';
      for i := 0 to Length(Nodes) - 1 do
        if Nodes[i] <> '' then
        begin
          if Length(Nodes[i]) = 2 then
            Nodes[i] := '{' + Nodes[i] + '}';
          Nodeslist := Nodeslist + ',' + Nodes[i];
        end;
      Delete(Nodeslist, 1, 1);
      case NodeType of
        ntEntry: NodeStr := 'EntryNodes';
        ntMiddle: NodeStr := 'MiddleNodes';
        ntExit: NodeStr := 'ExitNodes';
        ntExclude: NodeStr := 'ExcludeNodes';
      end;
      if Favorites then
        SetSettings('Routers', NodeStr, Nodeslist, ini)
      else
        SetSettings('Filter', NodeStr, Nodeslist, ini);
    end;
  end;
end;

function BytesFormat(Bytes: Double): string;
var
  i: Integer;
begin
  i := 0;
  while Bytes > 1024 do
  begin
    Bytes := Bytes / 1024;
    inc(i);
  end;
  Result := FloatToStrF(Bytes, ffFixed, 4, 1) + ' ' + Prefixes[i];
end;

function FormatSizeToBytes(SizeStr: string): Int64;
begin
  Result := Round(GetPrefixSize(SeparateRight(SeparateLeft(SizeStr, '/'), ' '), True) * StrToFloatDef(SeparateLeft(SizeStr, ' '), 0.0));
end;

function GetHost(Host: string): string;
begin
  if Host = '0.0.0.0' then
    Result := '127.0.0.1'
  else
    if Host = '::' then
      Result := '::1'
    else
      Result := Host;
end;

function GetAvailPhysMemory: Cardinal;
var
  MS: TMemoryStatusEx;
begin
  MS.dwLength := SizeOf(MS);
  GlobalMemoryStatusEx(MS);
  Result := Round(MS.ullAvailPhys / 1024 / 1024);
end;

function GetCPUCount: Integer;
var
  s: TSystemInfo;
begin
  GetSystemInfo(s);
  Result := s.dwNumberOfProcessors;
end;

function AnsiStrToHex(const Value: AnsiString): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(Value) do
    Result := Result + IntToHex(Byte(Value[i]), 2);
end;

function StrToHex(Value: string): string;
var
  i: Integer;
  c: Char;
begin
  Result := '';
  for i := 1 to Length(Value) do
  begin
    c := Value[i];
    Result := Result + IntToHex(Integer(c), 2); ;
  end;
end;

function HexToStr(hex: string): string;
var
  i: Integer;
begin
  for i := 1 to Length(hex) div 2 do
    Result := Result + Char(StrToInt('$' + copy(hex, (i - 1) * 2 + 1, 2)));
end;

function Crypt(str, Key: string): string;
var
  i, T: Integer;
begin
  if (str = '') or (Key = '') then
    Exit;
  for i := 1 to Length(str) do
  begin
    T := (ord(str[i]) + (ord(Key[(pred(i) mod Length(Key)) + 1]) - ord('0')));
    str[i] := Char(T);
  end;
  Result := StrToHex(str);
end;

function Decrypt(str, Key: string): string;
var
  i, T: Integer;
begin
  if (str = '') or (Key = '') then
    Exit;
  str := HexToStr(str);
  for i := 1 to Length(str) do
  begin
    T := (ord(str[i]) - (ord(Key[(pred(i) mod Length(Key)) + 1]) - ord('0')));
    str[i] := Chr(T);
  end;
  Result := str;
end;

function FileGetString(Filename: string; Hex: Boolean = False): string;
var
  Buf: array of Byte;
  F: File of Byte;
  FSize, i: Integer;
  Str: string;
begin
  if FileExists(Filename) then
  begin
    AssignFile(F, Filename);
    try
      Reset(F);
      FSize := FileSize(F);
      SetLength(Buf, FSize);
      BlockRead(F, Buf[0], FSize);
    finally
      Closefile(F);
    end;
    for i := 0 to FSize - 1 do
      Str := Str + Chr(Buf[i]);
  end;
  if Hex then
    Result := StrToHex(Str)
  else
    Result := Str;
end;

function AuthStageReady(AuthMethod: Integer): Boolean;
var
  Time: TDateTime;
begin
  Result := False;
  if AuthMethod = 1 then
    Result := True
  else
  begin
    if FileAge(UserDir + 'control_auth_cookie', Time) = True then
    begin
      if LastAuthCookieDate <> Time then
        Result := True;
    end;
  end;
end;

function ExecuteProcess(CmdLine: string; Flags: TProcessFlags = []; JobHandle: THandle = 0): TProcessInfo;
var
  hStdOutRead, hStdOutWrite: THandle;
  SA: SECURITY_ATTRIBUTES;
  SI: STARTUPINFO;
  PI: PROCESS_INFORMATION;
  CreationFlags: Cardinal;
begin
  Result.hProcess := 0;
  Result.hStdOutput := 0;
  UniqueString(CmdLine);
  SA.nLength := SizeOf(SECURITY_ATTRIBUTES);
  SA.bInheritHandle := True;
  SA.lpSecurityDescriptor := nil;
  if pfReadStdOut in Flags then
    if not CreatePipe(hStdOutRead, hStdOutWrite, @SA, BUFSIZE) then
      Exit;
  FillChar(SI, SizeOf(SI), 0);
  SI.cb := SizeOf(SI);
  if pfReadStdOut in Flags then
    SI.dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES
  else
    SI.dwFlags := STARTF_USESHOWWINDOW;
  if pfReadStdOut in Flags then
    SI.hStdOutput := hStdOutWrite;
  if pfHideWindow in Flags then
    SI.wShowWindow := SW_HIDE
  else
    SI.wShowWindow := SW_SHOWDEFAULT;
  if JobHandle <> 0 then
    CreationFlags := CREATE_BREAKAWAY_FROM_JOB
  else
    CreationFlags := 0;
  if CreateProcess(nil, PWideChar(CmdLine), nil, nil, True, CreationFlags, nil, nil, SI, PI) then
  begin
    if JobHandle <> 0 then
      AssignProcessToJobObject(JobHandle, PI.hProcess);
    if pfReadStdOut in Flags then
      Result.hStdOutput := hStdOutRead;
    Result.hProcess := PI.hProcess;
  end;
  if pfReadStdOut in Flags then
    CloseHandle(hStdOutWrite);
  CloseHandle(PI.hThread);
end;

function RandomString(StrLen: Integer): string;
var
  Str: string;
begin
  Result := '';
  str := 'abcdefghijklmnopqrstuvwxyz' + 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' + '0123456789';
  Randomize;
  repeat
    Result := Result + str[Random(Length(str)) + 1];
  until (Length(Result) = StrLen)
end;

function GetPasswordHash(const password: string): string;
var
  tmp, hash, salt: string;
  count: Integer;
begin
  if password = '' then
    Exit;
  salt := RandomString(8);
  count := (16 + (96 and 15)) shl ((96 shr 4) + 6);
  tmp := salt + password;
  while count > 0 do
  begin
    if count > Length(tmp) then
    begin
      insert(tmp, hash, Length(hash) + 1);
      count := count - Length(tmp);
    end
    else
    begin
      insert(copy(tmp, 0, count), hash, Length(hash) + 1);
      count := 0;
    end;
  end;
  salt := salt + Chr(96);
  Result := '16:' + StrToHex(salt) + AnsiStrToHex(SHA1(AnsiString(hash)));
end;

function Explode(sPart, sInput: string): ArrOfStr;
begin
  Result := nil;
  while Pos(sPart, sInput) <> 0 do
  begin
    SetLength(Result, Length(Result) + 1);
    Result[Length(Result) - 1] := copy(sInput, 0, Pos(sPart, sInput) - 1);
    Delete(sInput, 1, Pos(sPart, sInput));
  end;
  SetLength(Result, Length(Result) + 1);
  Result[Length(Result) - 1] := sInput;
end;

function GetDirFromArray(Data: array of string; FileName: string = ''; ShowFileName: Boolean = False): string;
var
  i, DataLength: Integer;
  Dir: string;
  Found: Boolean;
begin
  Result := '';
  DataLength := Length(Data);
  for i := 0 to DataLength - 1 do
  begin
    Dir := Data[i];
    Dir := StringReplace(Dir, '%UserDir%', UserDir, [rfReplaceAll, rfIgnoreCase]);
    Dir := StringReplace(Dir, '%ProgramDir%', ProgramDir, [rfReplaceAll, rfIgnoreCase]);
    Dir := StringReplace(Dir, '\\', '\', [rfReplaceAll]);
    if FileName <> '' then
      Found := FileExists(Dir + FileName)
    else
      Found := DirectoryExists(Dir);
    if Found then
    begin
      Result := Dir;
      Break;
    end;
  end;
  if (Result = '') and (DataLength > 0) then
    Result := Data[DataLength - 1];

  if ShowFileName then
    Result := Result + FileName;
end;

function GetLogFileName(SeparateType: Integer): string;
var
  FileName: string;
  CurrentDate: TDateTime;
begin
  CurrentDate := Now;
  case SeparateType of
    1: FileName := FormatDateTime('yyyy-mm', CurrentDate);
    2: FileName := FormatDateTime('yyyy-mm-', CurrentDate) + IntToStr(WeekOfTheMonth(CurrentDate)) + 'W';
    3: FileName := FormatDateTime('yyyy-mm-dd', CurrentDate);
    else
      FileName := 'console';
  end;
  Result := LogsDir + FileName + '.log';
end;

procedure SaveToLog(str: string; LogFile: string);
var
  log: TextFile;
begin
  AssignFile(log, LogFile);
{$i-}
  if FileExists(LogFile) then
    Append(log)
  else
    Rewrite(log);
{$i+}
  WriteLn(log, str);
  Closefile(log);
end;

procedure DeleteDir(const DirName: string);
var
  Path: string;
  F: TSearchRec;
begin
  Path:= DirName + '\*.*';
  if FindFirst(Path, faAnyFile, F) = 0 then
  begin
    try
      repeat
        if (F.Attr and faDirectory <> 0) then
        begin
          if (F.Name <> '.') and (F.Name <> '..') then
            DeleteDir(DirName + '\' + F.Name);
        end
        else
          DeleteFile(DirName + '\' + F.Name);
      until FindNext(F) <> 0;
    finally
      FindClose(F);
    end;
  end;
  RemoveDir(DirName);
end;

procedure DeleteFiles(const FileMask: string; TimeOffset: Integer = 0);
var
  SearchRec: TSearchRec;
  CurrentDate: Int64;
begin
  CurrentDate := DateTimeToUnix(Now);
  try
    if FindFirst(ExpandFileName(FileMask), faAnyFile, SearchRec) = 0 then
    repeat
      if (SearchRec.Name[1] <> '.') and (SearchRec.Attr and faDirectory <> faDirectory) then
      begin
        if (TimeOffset = 0) or (CurrentDate >= DateTimeToUnix(SearchRec.TimeStamp) + TimeOffset) then
          DeleteFile(ExtractFilePath(FileMask) + SearchRec.Name);
      end;
    until FindNext(SearchRec) <> 0;
  finally
    FindClose(SearchRec);
  end;
end;

function GetIntDef(const Value, Default, Min, Max: Integer): Integer;
begin
  if InRange(Value, Min, Max) then
    Result := Value
  else
    Result := Default;
end;

procedure GetSettings(Section: string; EditControl: TEdit; ini: TMemIniFile; RemoveSquareBrackets: Boolean = False);
var
  Str: string;
begin
  if FirstLoad then
    EditControl.ResetValue := EditControl.Text;
  Str := ini.ReadString(Section, StringReplace(EditControl.Name, 'ed', '', [rfIgnoreCase]), EditControl.ResetValue);

  if RemoveSquareBrackets then
    EditControl.Text := RemoveBrackets(Str, True)
  else
    EditControl.Text := Str;
end;

procedure SetSettings(Section: string; EditControl: TEdit; ini: TMemIniFile; UseFormatHost: Boolean = False); overload;
var
  Str: string;
begin
  if UseFormatHost then
    Str := FormatHost(EditControl.Text)
  else
    Str := EditControl.Text;
  ini.WriteString(Section, StringReplace(EditControl.Name, 'ed', '', [rfIgnoreCase]), Str);
end;

procedure GetSettings(Section: string; ComboBoxControl: TComboBox; ini: TMemIniFile; Default: Integer = 0);
var
  Value: Integer;
begin
  if FirstLoad then
    ComboBoxControl.ResetValue := Default;

  Value := ini.ReadInteger(Section, StringReplace(ComboBoxControl.Name, 'cbx', '', [rfIgnoreCase]), Default);
  if InRange(Value, 0, ComboBoxControl.Items.Count - 1) then
    ComboBoxControl.ItemIndex := Value
  else
    ComboBoxControl.ItemIndex := Default;
end;

procedure SetSettings(Section: string; ComboBoxControl: TComboBox; ini: TMemIniFile; SaveIndex: Boolean = True; UseFormatHost: Boolean = False);
var
  Ident, Str: string;
begin
  Ident := StringReplace(ComboBoxControl.Name, 'cbx', '', [rfIgnoreCase]);
  if SaveIndex then
    ini.WriteInteger(Section, Ident, ComboBoxControl.ItemIndex)
  else
  begin
    if UseFormatHost then
      Str := FormatHost(ComboBoxControl.Text)
    else
      Str := ComboBoxControl.Text;
    ini.WriteString(Section, Ident, Str);
  end;
end;

procedure GetSettings(Section: string; UpDownControl: TUpDown; ini: TMemIniFile);
var
  Value: Integer;
  Ident: string;
begin
  if FirstLoad then
    UpDownControl.ResetValue := UpDownControl.Position;
  Ident := StringReplace(UpDownControl.Name, 'ud', '', [rfIgnoreCase]);

  Value := ini.ReadInteger(Section, Ident, UpDownControl.ResetValue);
  if InRange(Value, UpDownControl.Min, UpDownControl.Max) then
    UpDownControl.Position := Value
  else
    UpDownControl.Position := UpDownControl.ResetValue;
end;

procedure SetSettings(Section: string; UpDownControl: TUpDown; ini: TMemIniFile); overload;
begin
  ini.WriteInteger(Section, StringReplace(UpDownControl.Name, 'ud', '', [rfIgnoreCase]), UpDownControl.Position)
end;

procedure GetSettings(UpDownControl: TUpDown; Flags: TConfigFlags = []);
begin
  if FirstLoad then
    UpDownControl.ResetValue := UpDownControl.Position;
  UpDownControl.Position := StrToInt(GetTorConfig(StringReplace(UpDownControl.Name, 'ud', '', [rfIgnoreCase]), IntToStr(UpDownControl.ResetValue), Flags, ptInteger, UpDownControl.Min, UpDownControl.Max));
end;

procedure GetSettings(Section: string; CheckBoxControl: TCheckBox; ini: TMemIniFile);
begin
  if FirstLoad then
    CheckBoxControl.ResetValue := CheckBoxControl.Checked;
  CheckBoxControl.Checked := ini.ReadBool(Section, StringReplace(CheckBoxControl.Name, 'cb', '', [rfIgnoreCase]), CheckBoxControl.ResetValue)
end;

procedure SetSettings(Section: string; CheckBoxControl: TCheckBox; ini: TMemIniFile);
begin
  ini.WriteBool(Section, StringReplace(CheckBoxControl.Name, 'cb', '', [rfIgnoreCase]), CheckBoxControl.Checked);
end;

procedure GetSettings(CheckBoxControl: TCheckBox; Flags: TConfigFlags = []);
begin
  if FirstLoad then
    CheckBoxControl.ResetValue := CheckBoxControl.Checked;
  CheckBoxControl.Checked := StrToBool(GetTorConfig(StringReplace(CheckBoxControl.Name, 'cb', '', [rfIgnoreCase]), BoolToStrDef(CheckBoxControl.ResetValue), Flags, ptBoolean));
end;

procedure GetSettings(Section: string; MenuControl: TMenuItem; ini: TMemIniFile; Default: Boolean = True);
begin
  MenuControl.Checked := ini.ReadBool(Section, StringReplace(MenuControl.Name, 'mi', '', [rfIgnoreCase]), Default)
end;

procedure SetSettings(Section: string; MenuControl: TMenuItem; ini: TMemIniFile);
begin
  ini.WriteBool(Section, StringReplace(MenuControl.Name, 'cb', '', [rfIgnoreCase]), MenuControl.Checked);
end;

procedure GetSettings(MenuControl: TMenuItem; Flags: TConfigFlags = []; Default: Boolean = True);
begin
  MenuControl.Checked := StrToBool(GetTorConfig(StringReplace(MenuControl.Name, 'mi', '', [rfIgnoreCase]), BoolToStrDef(Default), Flags, ptBoolean));
end;

procedure SetSettings(Section, Ident: string; Value: string; ini: TMemIniFile);
begin
  ini.WriteString(Section, Ident, Value)
end;

procedure SetSettings(Section, Ident: string; Value: Integer; ini: TMemIniFile);
begin
  ini.WriteInteger(Section, Ident, Value)
end;

procedure SetSettings(Section, Ident: string; Value: Int64; ini: TMemIniFile);
begin
  ini.WriteInt64(Section, Ident, Value)
end;

procedure SetSettings(Section, Ident: string; Value: Boolean; ini: TMemIniFile);
begin
  ini.WriteBool(Section, Ident, Value)
end;

procedure DeleteSettings(Section, Ident: string; ini: TMemIniFile);
begin
  ini.DeleteKey(Section, Ident)
end;

function GetSettings(Section, Ident: string; Default: string; ini: TMemIniFile): string;
begin
  Result := ini.ReadString(Section, Ident, Default)
end;

function GetSettings(Section, Ident: string; Default: Integer; ini: TMemIniFile): Integer;
begin
  Result := ini.ReadInteger(Section, Ident, Default)
end;

function GetSettings(Section, Ident: string; Default: Int64; ini: TMemIniFile): Int64;
begin
  Result := ini.ReadInt64(Section, Ident, Default)
end;

function GetSettings(Section, Ident: string; Default: Boolean; ini: TMemIniFile): Boolean;
begin
  Result := ini.ReadBool(Section, Ident, Default)
end;

procedure LoadTorConfig;
var
  i: Integer;
begin
  if Assigned(TorConfig) then
    Exit
  else
  begin
    TorConfig := TStringList.Create;
    if FileExists(TorConfigFile) then
      TorConfig.LoadFromFile(TorConfigFile, EncodingNoBom);
    for i := 0 to TorConfig.Count - 1 do
      TorConfig[i] := Trim(TorConfig[i]);
  end;
end;

procedure SaveTorConfig;
var
  i: Integer;
begin
  LoadTorConfig;
  for i := TorConfig.Count - 1 downto 0 do
    if (i <> 1) and (TorConfig[i] = '') then
      TorConfig.Delete(i);
  TorConfig.SaveToFile(TorConfigFile, EncodingNoBom);
  FreeAndNil(TorConfig);
  FileAge(TorConfigFile, LastTorrcDate);
end;

function GetTorConfig(const Param, Default: string; Flags: TConfigFlags = []; ParamType: TParamType = ptString; MinValue: Integer = 0; MaxValue: Integer = 0; Prefix: string = ''): string;
var
  i, p, ParamSize, CommentPos: Integer;
  ls: TStringList;
  Values: set of Byte;
  Search: Boolean;

  procedure Reset;
  begin
    if (Default <> '') and (GetDefaultsValue(Param) <> Default) then
      TorConfig[i] := Param + ' ' + Default
    else
      TorConfig[i] := '';
    Result := Default;
  end;

begin
  LoadTorConfig;

  if cfFindComments in Flags then
    Values := [1,2,3]
  else
    Values := [1];
  Search := False;

  if cfMultiLine in Flags then
    ls := TStringList.Create
  else
    ls := nil;

  for i := 0 to TorConfig.Count - 1 do
  begin
    p := InsensPosEx(Param + ' ', TorConfig[i]);
    Search := p in Values;
    if Search then
    begin
      if cfExistCheck in Flags then
      begin
        Result := '1';
        Exit;
      end;
      ParamSize := Length(Param);
      CommentPos := Pos('#', TorConfig[i]);
      if CommentPos > p + ParamSize then
        Result := Trim(copy(TorConfig[i], p + ParamSize + 1, CommentPos - ParamSize - 2))
      else
        Result := Trim(copy(TorConfig[i], p + ParamSize + 1, Length(TorConfig[i]) - ParamSize - 1));
      case ParamType of
        ptString:
          if (MinValue > 0) or (MaxValue > 0) then
          begin
            ParamSize := Length(Result);
            if (ParamSize < MinValue) or (ParamSize > MaxValue) then
              Reset;
          end;
        ptInteger:
          if not ValidInt(Result, MinValue, MaxValue) then
            Reset;
        ptBoolean:
        begin
          if not ValidInt(Result, 0, 1) then
            Reset
          else
          begin
            if cfBoolInvert in Flags then
              Result := BoolToStrDef(not StrToBool(Result));
          end;
        end;
        ptSocket:
          if ValidSocket(Result, Boolean(MinValue)) = 0 then
            Reset;
        ptHost:
          if not ValidHost(Result, False, True, Boolean(MinValue)) then
            Reset;
        ptSize:
          if not ValidSize(Result, MinValue, MaxValue, Prefix) then
            Reset;
        ptBridge:
          if not ValidBridge(Result, btList) then
          begin
            TorConfig[i] := '';
            Continue;
          end;
      end;
      if cfMultiLine in Flags then
      begin
        if Result <> '' then
          ls.Append(Result)
      end
      else
        Break;
    end;
  end;

  if cfMultiLine in Flags then
  begin
    if ls.Count = 0 then
      Result := Default
    else
    begin
      Result := '';
      DeleteDuplicatesFromList(ls);
      for i := 0 to ls.Count - 1 do
        Result := Result + '|' + ls[i];
      Delete(Result, 1, 1);
    end;
    ls.Free;
  end
  else
  begin
    if not Search then
    begin
      Result := Default;
      if cfAutoAppend in Flags then
        TorConfig.Append(Param + ' ' + Default);
    end;
  end;

  if cfAutoSave in Flags then
    SaveTorConfig;
end;

procedure SetTorConfig(const Param, Value: string; Flags: TConfigFlags = []; Separator: string = '|');
var
  i, p: Integer;
  Values: set of Byte;
  ParseStr: ArrOfStr;
begin
  LoadTorConfig;
  if cfMultiLine in Flags then
  begin
    if Value <> '' then
    begin
      ParseStr := Explode(Separator, Value);
      for i := 0 to Length(ParseStr) - 1 do
        if ParseStr[i] <> '' then
          TorConfig.Append(Param + ' ' + ParseStr[i]);
    end
    else
      DeleteTorConfig(Param, [cfMultiLine]);
  end
  else
  begin
    p := 0;
    if cfFindComments in Flags then
      Values := [1,2,3]
    else
      Values := [1];
    for i := TorConfig.Count - 1 downto 0 do
    begin
      p := InsensPosEx(Param + ' ', TorConfig[i]);
      if p in Values then
        Break;
    end;
    if p in Values then
    begin
      if (Value <> '') and (GetDefaultsValue(Param) <> Value) then
        TorConfig[i] := Param + ' ' + Value
      else
        TorConfig.Delete(i);
    end
    else
    begin
      if (Value <> '') and (GetDefaultsValue(Param) <> Value) then
        TorConfig.Append(Param + ' ' + Value);
    end;
  end;
  if cfAutoSave in Flags then
    SaveTorConfig;
end;

procedure DeleteTorConfig(const Param: string; Flags: TConfigFlags = []);
var
  i,j: Integer;
  Values: set of Byte;
  ParseStr: ArrOfStr;
begin
  LoadTorConfig;
  if cfFindComments in Flags then
    Values := [1,2,3]
  else
    Values := [1];
  ParseStr := Explode(',', Param);
  for i := TorConfig.Count - 1 downto 0 do
  begin
    for j := 0 to Length(ParseStr) - 1 do
    begin
      if InsensPosEx(ParseStr[j] + ' ', TorConfig[i]) in Values then
      begin
        TorConfig.Delete(i);
        if not (cfMultiLine in Flags) then
          Break;
      end;
    end;
  end;
  if cfAutoSave in Flags then
    SaveTorConfig;
end;

procedure SetConfigBoolean(Section, Ident: string; Value: Boolean);
var
  ini: TMemIniFile;
begin
  ini := TMemIniFile.Create(UserConfigFile, TEncoding.UTF8);
  try
    ini.WriteBool(Section, Ident, Value);
  finally
    UpdateConfigFile(ini);
  end;
end;

procedure SetConfigInteger(Section, Ident: string; Value: Int64); overload;
var
  ini: TMemIniFile;
begin
  ini := TMemIniFile.Create(UserConfigFile, TEncoding.UTF8);
  try
    ini.WriteInteger(Section, Ident, Value);
  finally
    UpdateConfigFile(ini);
  end;
end;

procedure SetConfigInteger(Section, Ident: string; Value: Integer); overload;
var
  ini: TMemIniFile;
begin
  ini := TMemIniFile.Create(UserConfigFile, TEncoding.UTF8);
  try
    ini.WriteInt64(Section, Ident, Value);
  finally
    UpdateConfigFile(ini);
  end;
end;

procedure SetConfigString(Section, Ident: string; Value: string);
var
  ini: TMemIniFile;
begin
  ini := TMemIniFile.Create(UserConfigFile, TEncoding.UTF8);
  try
    ini.WriteString(Section, Ident, Value);
  finally
    UpdateConfigFile(ini);
  end;
end;

procedure DeleteDuplicatesFromList(List: TStringList; ListType: TListType = ltNoCheck);
var
  ls: TDictionary<string, Byte>;
  SocketStr: string;
  i: Integer;

  procedure UpdateList(Str: string);
  begin
    if ls.ContainsKey(Str) then
      List.Delete(i)
    else
      ls.AddOrSetValue(Str, 0);
  end;

begin
  ls := TDictionary<string, Byte>.Create;
  try
    if ListType = ltBridge then
    begin
      for i := List.Count - 1 downto 0 do
      begin
        if TryGetDataFromStr(List[i], ltSocket, SocketStr) then
          UpdateList(SocketStr)
        else
          UpdateList(List[i]);
      end;
    end
    else
    begin
      for i := List.Count - 1 downto 0 do
        UpdateList(List[i]);
    end;
  finally
    ls.Free;
  end;
end;

procedure SortNodesList(ls: TStringList; DescSort: Boolean = False);
var
  i: Integer;
  Hashes, Addresses, CountryCodes: TStringList;
begin
  Addresses := TStringList.Create;
  CountryCodes := TStringList.Create;
  Hashes := TStringList.Create;
  try
    for i := 0 to ls.Count - 1 do
    begin
      if ValidHash(ls[i]) then
        Hashes.Append(ls[i])
      else
      begin
        if FilterDic.ContainsKey(AnsiLowerCase(ls[i])) then
          CountryCodes.Append(ls[i])
        else
          Addresses.Append(ls[i])
      end;
    end;
    Addresses.CustomSort(CompTextAsc);
    CountryCodes.Sort;
    Hashes.Sort;
    ls.Clear;
    if DescSort then
    begin
      ls.AddStrings(Hashes);
      ls.BeginUpdate;
      try
        for i := Addresses.Count - 1 downto 0 do
          ls.AddObject(Addresses[i], Addresses.Objects[i]);
        for i := CountryCodes.Count - 1 downto 0 do
          ls.AddObject(CountryCodes[i], CountryCodes.Objects[i]);
      finally
        ls.EndUpdate;
      end;
    end
    else
    begin
      ls.AddStrings(CountryCodes);
      ls.AddStrings(Addresses);
      ls.AddStrings(Hashes);
    end;
  finally
    Hashes.Free;
    Addresses.Free;
    CountryCodes.Free;
  end;
end;

function GetNodeType(NodeStr: string): TListType;
begin
  Result := ltNoCheck;
  if Length(NodeStr) < 2 then
    Exit;
  if ValidHash(NodeStr) then
    Result := ltHash
  else
  begin
    if ValidAddress(NodeStr, True) = 1 then
    begin
      if Pos('/', NodeStr) <> 0 then
        Result := ltCidr
      else
        Result := ltIp;
    end
    else
    begin
      if FilterDic.ContainsKey(AnsiLowerCase(NodeStr)) then
        Result := ltCode
    end;
  end;
end;

function ValidData(Str: string; ListType: TListType; State: Boolean = False): Boolean;
begin
  case ListType of
    ltHost: Result := ValidHost(Str, True, True);
    ltHash: Result := ValidHash(Str);
    ltPolicy: Result := ValidPolicy(Str);
    ltBridge:
    begin
      if State then
        Result := ValidBridge(Str, btNone)
      else
        Result := ValidBridge(Str, btList);
    end;
    ltNode: Result := ValidHash(Str) or (ValidAddress(Str, True, True) = 1) or FilterDic.ContainsKey(AnsiLowerCase(Str));
    ltSocket: Result := ValidSocket(Str) <> 0;
    ltTransport: Result := ValidTransport(Str);
    else
      Result := True;
  end;
end;

procedure LineToMemo(Line: string; Memo: TMemo; ListType: TListType; Sorted: Boolean = False; Separator: string = ',');
var
  ParseStr: ArrOfStr;
  i: Integer;
  ls: TStringList;
  Str: string;
begin
  ParseStr := Explode(Separator, Line);
  Memo.Tag := Length(ParseStr);
  if (Memo.Tag = 1) and (Trim(ParseStr[0]) = '') then
    Memo.Tag := 0;
  ls := TStringList.Create;
  try
    if ListType = ltNoCheck then
    begin
      if Memo.Tag <> 0 then
        for i := 0 to Length(ParseStr) - 1 do
          ls.Append(ParseStr[i]);
    end
    else
    begin
      for i := 0 to Length(ParseStr) - 1 do
      begin
        Str := Trim(ParseStr[i]);
        if Str <> '' then
        begin
          if ValidData(Str, ListType) then
          begin
            if ListType = ltNode then
            begin
              if Length(Str) = 2 then
                Str := AnsiUpperCase(Str);
            end;
            ls.Append(Str);
          end;
        end;
      end;
      DeleteDuplicatesFromList(ls, ListType);
      if Sorted then
      begin
        if ListType = ltNode then
          SortNodesList(ls)
        else
          ls.CustomSort(CompTextAsc);
      end;
    end;
    Memo.Text := ls.Text;
  finally
    ls.Free;
  end;
end;

function MemoToLine(Memo: TMemo; ListType: TListType; Sorted: Boolean = False; Separator: string = ','; State: Boolean = False): string;
var
  ls: TStringList;
  i: Integer;
  Str: string;
begin
  ls := TStringList.Create;
  try
    if ListType = ltNoCheck then
      ls.Text := Memo.Text
    else
    begin
      ls.Text := StringReplace(Memo.Text, ',', BR, [rfReplaceAll]);
      if ListType = ltNode then
        ls.Text := RemoveBrackets(ls.Text);
      for i := ls.Count - 1 downto 0 do
      begin
        Str := Trim(ls[i]);
        if Str = '' then
          ls.Delete(i)
        else
        begin
          case ListType of
            ltHost: Str := ExtractDomain(Str);
            ltHash: Str := AnsiUpperCase(Str);
            ltPolicy: Str := AnsiLowerCase(Str);
            ltNode: Str := AnsiUpperCase(Str);
          end;
          if not ValidData(Str, ListType, State) then
            ls.Delete(i)
          else
            ls[i] := Str;
        end;
      end;
      DeleteDuplicatesFromList(ls, ListType);
      if Sorted then
      begin
        if ListType = ltNode then
          SortNodesList(ls)
        else
          ls.CustomSort(CompTextAsc);
      end;
      Memo.Text := ls.Text;
    end;
    Result := '';
    for i := 0 to ls.Count - 1 do
      Result := Result + Separator + ls[i];
    Delete(Result, 1, Length(Separator));
  finally
    ls.Free;
  end;
end;

procedure AddUPnPEntry(Port: Integer; Desc, LanIp: string; Test: Boolean; var Msg: string);
var
  Nat: OleVariant;
  Ports: OleVariant;
begin
  try
    Nat := CreateOleObject('HNetCfg.NATUPnP');
    Ports := Nat.StaticPortMappingCollection;
    if not VarIsClear(Ports) then
    begin
      Ports.Add(Port, 'TCP', Port, LanIp, True, Desc);
      if Test then
      begin
        Msg := Msg + LanIp + ' : ' + inttostr(Port) + ' - ' + TransStr('245') + BR;
        if ConnectState = 0 then
          Ports.Remove(Port, 'TCP');
      end;
    end;
  except
    on E:Exception do
      Exit
  end;
end;

procedure RemoveUPnPEntry(First: Integer; Second: Integer = 0; Third: Integer = 0);
var
  Nat: Variant;
  Ports: Variant;
begin
  if (First = 0) and (Second = 0) and (Third = 0) then
    Exit;
  try
    Nat := CreateOleObject('HNetCfg.NATUPnP');
    Ports := Nat.StaticPortMappingCollection;
    if not VarIsClear(Ports) then
    begin
      if First > 0 then
        Ports.Remove(First, 'TCP');
      if Second > 0 then
        Ports.Remove(Second, 'TCP');
      if Third > 0 then
        Ports.Remove(Third, 'TCP');
    end;
  except
    on E:Exception do
      Exit;
    end;
end;

function IsDirectoryWritable(const Dir: string): Boolean;
var
  TempFile: array[0..MAX_PATH] of Char;
begin
  if GetTempFileName(PChar(Dir), 'Tmp', 0, TempFile) <> 0 then
    Result := DeleteFile(TempFile)
  else
    Result := False;
end;

function GetFullFileName(FileName: string): string;
var
   ppshf: IShellFolder;
   lpItemID: PItemIDList;
   NumChars: Cardinal;
   Flags: Cardinal;
   s: array[0..MAX_PATH] of Char;
   P: PWideChar;
begin
   NumChars := Length(FileName);
   Flags := SFGAO_FILESYSTEM;
   SHGetDesktopFolder(ppshf);
   P := StringToOleStr(FileName);
   ppshf.ParseDisplayName(Application.Handle, nil, P, NumChars, lpItemID, Flags);
   ShGetPathFromIDList(lpItemID, s);
   SetString(Result, s, StrLen(s));
end;

function CreateShortcut(const CmdLine, Args, WorkDir, LinkFile, IconFile: string): IPersistFile;
var
  MyObject: IUnknown;
  MySLink: IShellLink;
  MyPFile: IPersistFile;
  WideFile: WideString;
begin
   MyObject := CreateComObject(CLSID_ShellLink);
   MySLink := MyObject as IShellLink;
   MyPFile := MyObject as IPersistFile;
   with MySLink do
   begin
      SetPath(PChar(CmdLine));
      SetIconLocation(PChar(IconFile), 0 );
      SetArguments(PChar(Args));
      SetWorkingDirectory(PChar(WorkDir));
   end;
   WideFile := LinkFile;
   MyPFile.Save(PWideChar(WideFile), false);
   Result := MyPFile;
end;

function GetSystemDir(CSIDL: Integer): string;
var
  Dir: array[0..MAX_PATH] of WideChar;
begin
  if SHGetFolderPath(0, CSIDL, 0, SHGFP_TYPE_CURRENT, @Dir) = S_OK then
    Result := Dir;
end;

function GetCommandLineFileName(const CommandLine: string): string;
var
  Count: Integer;
  Args: PPWideChar;
  DataStr: array[0..MAX_PATH] of WideChar;
begin
  Args := CommandLineToArgvW(PWideChar(CommandLine), Count);
  if Assigned(Args) and (Count > 0) then
  begin
    if ExpandEnvironmentStrings(Args^, DataStr, MAX_PATH) > 0 then
      Result := DataStr
    else
      Result := Args^;
    Exit;
  end;
  Result := '';
end;

function RegistryFileExists(Root: HKEY; Key, Param: string): Boolean;
begin
  Result := FileExists(GetCommandLineFileName(RegistryGetValue(Root, Key, Param)));
end;

function RegistryGetValue(Root: HKEY; Key, Param: string): string;
var
  Reg: TRegistry;
begin
  Result := '';
  Reg := TRegistry.Create;
  try
    Reg.RootKey := Root;
    Reg.OpenKey(Key, False);
    case Reg.GetDataType(Param) of
      rdInteger: Result := IntToStr(Reg.ReadInteger(Param));
      rdString, rdExpandString: Result := Reg.ReadString(Param);
    end;
    Reg.CloseKey;
  finally
    Reg.Free;
  end;
end;

function TryGetDataFromStr(Str: string; DataType: TListType; out DatatStr: string): Boolean;
var
  i: Integer;
  ParseStr: ArrOfStr;
begin
  if Str <> '' then
  begin
    ParseStr := Explode(' ', Str);
    for i := 0 to Length(ParseStr) - 1 do
    begin
      if ValidData(ParseStr[i], DataType) then
      begin
        Result := True;
        DatatStr := ParseStr[i];
        Exit;
      end;
    end;
  end;
  Result := False;
  DatatStr := '';
end;

function PortTCPIsOpen(Port: Word; IpStr: string; Timeout: Integer): Boolean;
var
  Socket: TTCPBlockSocket;
begin
  Socket := TTCPBlockSocket.Create;
  Socket.ConnectionTimeout := Timeout;
  Socket.SetLinger(True, 0);
  try
    Socket.Connect(IpStr, IntToStr(Port));
    Result := Socket.LastError = 0;
    CloseSocket(Socket.Socket);
  finally
    Socket.Free;
  end;
end;

function GetBridgeCert: string;
var
  ls: TStringList;
  i, p: Integer;
  Bridgeline: string;
begin
  Result := '';
  ls := TStringList.Create;
  try
    Bridgeline := UserDir + 'pt_state\obfs4_bridgeline.txt';
    if FileExists(Bridgeline) then
    begin
      ls.LoadFromFile(Bridgeline, EncodingNoBom);
      for i := ls.Count - 1 downto 0 do
      begin
        p := Pos('cert=', ls[i]);
        if (p <> 0) then
        begin
          Result := Trim(copy(ls[i], p));
          break;
        end;
      end;
    end;
  finally
    ls.Free;
  end;
end;

function GetMsgCaption(Caption: string; MsgType: TMsgType): string;
begin
  if Caption = '' then
  begin
    case MsgType of
      mtInfo:
        Result := TransStr('235');
      mtWarning:
        Result := TransStr('246');
      mtError:
        Result := TransStr('247');
      mtQuestion:
        Result := TransStr('262');
    end;
  end
  else
    Result := Caption;
end;

function ShowMsg(Msg: string; Caption: string = ''; MsgType: TMsgType = mtInfo; Question: Boolean = False): Boolean;
var
  MsgCode, MsgButtons, MsgResult: Integer;
begin
  MsgCode := 0;
  case MsgType of
    mtInfo:
      MsgCode := MB_ICONINFORMATION;
    mtWarning:
      MsgCode := MB_ICONWARNING;
    mtError:
      MsgCode := MB_ICONERROR;
    mtQuestion:
      MsgCode := MB_ICONQUESTION;
  end;
  if Question then
  begin
    MsgButtons := MB_YESNO;
    MsgResult := IDYES;
  end
  else
  begin
    MsgButtons := MB_OK;
    MsgResult := ID_OK;
  end;

  if MessageBox(Application.Handle, PChar(Msg), PChar(GetMsgCaption(Caption, MsgType)), MsgButtons + MsgCode) = MsgResult then
    Result := True
  else
    Result := False;
end;

procedure DeleteARow(aSg: TStringGrid; ARow: Integer);
begin;
  if aSg.RowCount = 2 then
    ClearGrid(aSg)
  else
  begin
    ClearRow(aSg, ARow);
    TUserGrid(aSg).DeleteRow(ARow);
  end;
end;

procedure CheckFileEncoding(FileName, BackupFile: string);
var
  AStream: TFileStream;
  Options: TStringList;
  Hdr: string;
begin
  if not FileExists(FileName) then
  begin
    if not FileExists(BackupFile) then
      Exit
    else
    begin
      RenameFile(BackupFile, FileName);
      Flush(FileName);
    end;
  end;
  Hdr := '';
  AStream := TFileStream.Create(FileName, fmOpenRead);
  try
    AStream.Seek(0,soFromBeginning);
    SetLength(Hdr, 2);
    if AStream.Size > 2 then
    begin
      AStream.ReadBuffer(Hdr[1], 3);
      if (StrToHex(Hdr) = 'BBEFBF') and (AStream.Size <> 3) then
        Exit;
    end;
  finally
    AStream.Free;
  end;
  Options := TStringList.Create;
  try
    Options.LoadFromFile(FileName);
    if FileExists(BackupFile) then
    begin
      if Length(Trim(Options.Text)) = 0 then
      begin
        Options.Clear;
        Options.LoadFromFile(BackupFile);
      end;
    end;
    Options.SaveToFile(FileName, TEncoding.UTF8);
    Flush(FileName);
  finally
    Options.Free;
  end;
end;

procedure Flush(FileName: string);
var
  Handle: HFILE;
begin
  if not FileExists(FileName) then
    Exit;
  Handle := CreateFile(PWideChar(FileName),
    GENERIC_READ or GENERIC_WRITE, 0, nil,
    OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
  );
  if Handle <> INVALID_HANDLE_VALUE then
  begin
    FlushFileBuffers(Handle);
    CloseHandle(Handle)
  end;
end;

procedure UpdateConfigFile(ini: TMemIniFile);
begin
  try
    if ini.Modified then
    begin
      DeleteFile(UserBackupFile);
      RenameFile(UserConfigFile, UserBackupFile);
      Flush(UserBackupFile);
      try
        ini.UpdateFile;
      except
        DeleteFile(UserConfigFile);
        RenameFile(UserBackupFile, UserConfigFile);
      end;
      Flush(UserConfigFile);
    end;
  finally
    ini.Free;
  end;
end;

function CompIntObjectAsc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
begin
  Result := CompareValue(Integer(aSl.Objects[aIndex1]), Integer(aSl.Objects[aIndex2]));
end;

function CompIntObjectDesc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
begin
  Result := CompareValue(Integer(aSl.Objects[aIndex2]), Integer(aSl.Objects[aIndex1]));
end;

function CompIntAsc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
begin
  Result := CompareValue(StrToIntDef(aSl[aIndex1], 0), StrToIntDef(aSl[aIndex2], 0));
end;

function CompIntDesc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
begin
  Result := CompareValue(StrToIntDef(aSl[aIndex2], 0), StrToIntDef(aSl[aIndex1], 0));
end;

function CompTextAsc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
begin
  Result := CompareNaturalText(PWideChar(aSl[aIndex1]), PWideChar(aSl[aIndex2]));
end;

function CompTextDesc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
begin
  Result := CompareNaturalText(PWideChar(aSl[aIndex2]), PWideChar(aSl[aIndex1]));
end;

function CompSizeAsc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
begin
  Result := CompareValue(FormatSizeToBytes(aSl[aIndex1]), FormatSizeToBytes(aSl[aIndex2]));
end;

function CompSizeDesc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
begin
  Result := CompareValue(FormatSizeToBytes(aSl[aIndex2]), FormatSizeToBytes(aSl[aIndex1]));
end;

function CompParamsAsc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
begin
  Result := CompareValue(RoutersDic.Items[aSl[aIndex1]].Params, RoutersDic.Items[aSl[aIndex2]].Params);
end;

function CompParamsDesc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
begin
  Result := CompareValue(RoutersDic.Items[aSl[aIndex2]].Params, RoutersDic.Items[aSl[aIndex1]].Params);
end;

procedure SgSort(aSg: TStringGrid; aCol: Integer; aCompare: TStringListSortCompare);
var
  SlSort, SlRow: TStringList;
  i, j: Integer;
begin
  SlSort := TStringList.Create;
  for i := aSg.FixedRows to aSg.RowCount - 1 do
  begin
    SlRow := TStringList.Create;
    SlRow.Assign(aSg.Rows[i]);
    SlSort.AddObject(aSg.Cells[aCol, i], SlRow);
  end;
  SlSort.CustomSort(aCompare);
  j := 0;
  for i := aSg.FixedRows to aSg.RowCount - 1 do
  begin
    SlRow := Pointer(SlSort.Objects[j]);
    aSg.Rows[i].Assign(SlRow);
    SlRow.Free;
    Inc(j);
  end;
  FreeAndNil(SlSort);
end;

procedure SetGridLastCell(aSg: TStringGrid; Show: Boolean = True; ScrollTop: Boolean = False; ManualSort: Boolean = False; ARow: Integer = -1; ACol: Integer = -1; FindCol: Integer = 0);
var
  RowIndex, ColIndex: Integer;
begin
  if ARow = -1 then
  begin
    if ScrollTop and ManualSort then
      RowIndex := 1
    else
      RowIndex := aSg.Cols[FindCol].IndexOf(aSg.RowID);
  end
  else
    RowIndex := ARow;

  if not (goRowSelect in aSg.Options) then
  begin
    if aSg.Row = RowIndex then
    begin
      if (RowIndex = 1) and (aSg.RowCount > 2) then
        aSg.Row := RowIndex + 1
      else
        if aSg.RowCount > 2 then
          aSg.Row := RowIndex - 1;
    end;
  end;

  if (RowIndex > 0) then
  begin
    if ACol > -1 then
      ColIndex := ACol
    else
      ColIndex := aSg.SelCol;
    TUserGrid(aSg).MoveColRow(ColIndex, RowIndex, True, Show);
  end;
end;

procedure BeginUpdateTable(aSg: TStringGrid);
var
  i: Integer;
begin
  for i := 0 to aSg.ColCount - 1 do
    aSg.Cols[i].BeginUpdate;
end;

procedure EndUpdateTable(aSg: TStringGrid);
var
  i: Integer;
begin
  for i := 0 to aSg.ColCount - 1 do
    aSg.Cols[i].EndUpdate;
end;

function GetTaskBarPos: TTaskBarPos;
var
  hTaskbar: HWND;
  T: TRect;
  ScrW, ScrH: Integer;
begin
  Result := tbNone;
  hTaskbar := FindWindow('Shell_TrayWnd', nil);
  if hTaskbar <> 0 then
  begin
    GetWindowRect(hTaskbar, T);
    ScrW := Screen.Width;
    ScrH := Screen.Height;
    if (T.Top > ScrH div 2) and (T.Right >= ScrW) then
      Result := tbBottom
    else if (T.Top < ScrH div 2) and (T.Bottom <= ScrW div 2) then
      Result := tbTop
    else if (T.Left < ScrW div 2) and (T.Top <= 0) then
      Result := tbLeft
    else if T.Left >= ScrW div 2 then
      Result := tbRight;
  end;
end;

procedure LoadThemesList(ThemesList: TComboBox; LastStyle: string);
var
  Search: TSearchRec;
  ls: TStringList;
  Index: Integer;
begin
  if LastStyle = 'Windows' then
    LastStyle := TransStr('104')
  else
    if LastStyle = '' then
      LastStyle := ThemesList.Text;
  ls := TStringList.Create;
  try
    ls.Append(TransStr('104'));
    if FindFirst(ThemesDir + '*.vsf', faAnyFile, Search) = 0 then
    begin
      try
        repeat
          if (Search.Attr and faDirectory = 0)then
            ls.Append(Copy(Search.Name, 1, RPos('.', Search.Name) - 1));
        until FindNext(Search) <> 0;
      finally
        FindClose(Search);
      end;
    end;
    ThemesList.Items := ls;
    Index := ThemesList.Items.IndexOf(LastStyle);
    if Index = -1 then
      ThemesList.ItemIndex := 0
    else
      ThemesList.ItemIndex := Index;
  finally
    ls.Free;
  end;
  ComboBoxAutoWidth(ThemesList);
end;

procedure LoadStyle(ThemesList: TCombobox);
var
  SI: TStyleInfo;
  i: Integer;
  FileName, StyleName: string;
begin
  if ThemesList.ItemIndex = 0 then
    TStyleManager.SetStyle(TStyleManager.SystemStyle)
  else
  begin
    FileName := ThemesDir + ThemesList.Text + '.vsf';
    if not FileExists(FileName) then
      Exit;
    if TStyleManager.IsValidStyle(FileName, SI) then
    begin
      if TStyleManager.ActiveStyle.Name <> SI.Name then
      begin
        if TStyleManager.Style[SI.Name] = nil then
          TStyleManager.LoadFromFile(FileName);
        TStyleManager.SetStyle(TStyleManager.Style[SI.Name]);
      end;
    end;
  end;
  for i := Length(TStyleManager.StyleNames) - 1 downto 0 do
  begin
    StyleName := TStyleManager.StyleNames[i];
    if (StyleName <> 'Windows') and (StyleName <> TStyleManager.ActiveStyle.Name) then
      TStyleManager.RemoveStyle(StyleName);
  end;
end;

procedure GetLocalInterfaces(ComboBox: TComboBox; RecentHost: string = '');
var
  i, Index: Integer;
  ls: TStringList;
  TcpSock: TTCPBlockSocket;
  FindIPv6, ShowIPv6, ShowMask: Boolean;

  procedure AddToList(Str: string);
  var
    Search: Integer;
  begin
    Search := ls.IndexOf(Str);
    if Search <> -1 then
      ls.Delete(Search);
    Inc(Index);
    ls.Insert(Index, Str);
  end;

begin
  if RecentHost = '' then
    RecentHost := Combobox.Text
  else
    RecentHost := RemoveBrackets(RecentHost, True);
  ShowMask := ComboBox <> Tcp.cbxHsAddress;
  FindIPv6 := False;

  ls := TStringList.Create;
  try
    TcpSock := TTCPBlockSocket.create;
    try
      TcpSock.ResolveNameToIP(TcpSock.LocalName, ls);
    finally
      TcpSock.Free;
    end;

    for i := ls.Count - 1 downto 0 do
    begin
      if not IsIPv4(ls[i]) then
      begin
        FindIPv6 := True;
        if Tcp.cbHideIPv6Addreses.Checked or (Pos('%', ls[i]) <> 0) then
          ls.Delete(i);
      end;
    end;
    ShowIPv6 := FindIPv6 and not Tcp.cbHideIPv6Addreses.Checked;
    Index := -1;
    AddToList('127.0.0.1');
    if ShowIPv6 then
      AddToList('::1');
    if ShowMask then
      AddToList('0.0.0.0');
    if ShowMask and ShowIPv6 then
      AddToList('::');

    ComboBox.items := ls;
    ComboBox.ItemIndex := ComboBox.Items.IndexOf(RecentHost);
    if ComboBox.ItemIndex = -1 then
      ComboBox.ItemIndex := 0;
    ComboBoxAutoWidth(ComboBox);
  finally
    ls.Free;
  end;
end;

function ExtractDomain(Url: string; HasPort: Boolean = False): string;
var
  Search: Integer;
begin
  Result := AnsiLowerCase(Url);
  Search := Pos('@', Result);
  if Search > 0  then
    Delete(Result, 1, Search)
  else
  begin
    Search := Pos('://', Result);
    if Search > 0  then
      Delete(Result, 1, Search + 2);
  end;
  Search := Pos('/', Result);
  if Search > 0 then
    SetLength(Result, Pred(Search));
  Search := RPos(':', Result);
  if (Search > 0) then
  begin
    if (Result[1] = '[') and (Result[Search - 1] = ']') then
      SetLength(Result, Pred(Search))
    else
      if (Search = Pos(':', Result)) or HasPort then
        SetLength(Result, Pred(Search));
    Result := RemoveBrackets(Result, True);
  end;
  Search := Pos('.$', Result);
  if Search > 0 then
    SetLength(Result, Pred(Search));
end;

function GetAddressFromSocket(SocketStr: string): string;
var
  Search: Integer;
begin
  Search := RPos(':', SocketStr);
  if Search > 0 then
    Result := RemoveBrackets(Copy(SocketStr, 1, Search - 1), True)
  else
    Result := SocketStr;
end;

function GetPortFromSocket(SocketStr: string): Word;
begin
  Result := StrToIntDef(Copy(SocketStr, RPos(':', SocketStr) + 1), 0);
end;

function FormatHost(HostStr: string): string;
begin
  if IsIPv6(HostStr) then
    Result := '[' + HostStr + ']'
  else
    Result := HostStr;
end;

function GetRouterBySocket(SocketStr: string): string;
var
  Item: TPair<string, TRouterInfo>;
  SocketID: Byte;
  IpStr: string;
  Port: Word;
begin
  Result := '';
  SocketID := ValidSocket(SocketStr);
  if SocketID <> 0 then
  begin
    Port := GetPortFromSocket(SocketStr);
    IpStr := GetAddressFromSocket(SocketStr);
    if SocketID = 2 then
      IpStr := FormatHost(IpStr);

    for Item in RoutersDic do
    begin
      case SocketID of
        1:
        if (Item.Value.IPv4 = IpStr) and (Item.Value.OrPort = Port) then
        begin
          Result := Item.Key;
          Break;
        end;
        2:
        if (Item.Value.IPv6 = IpStr) and (Item.Value.OrPort = Port) then
        begin
          Result := Item.Key;
          Break;
        end;
      end;
    end;
  end;
end;

function GetPrefixSize(Prefix: string; Localize: Boolean = False): Int64;
var
  Index: Integer;
begin
  if Localize then
    ConstDic.TryGetValue(Prefix, Index)
  else
  begin
    if Length(Prefix) > 1 then
      Index := GetArrayIndex(PrefixSizes, Prefix)
    else
      Index := GetArrayIndex(PrefixShortSizes, Prefix)
  end;
  case Index of
    0: Result := Int64(1);
    1: Result := Int64(1) shl 10;
    2: Result := Int64(1) shl 20;
    3: Result := Int64(1) shl 30;
    4: Result := Int64(1) shl 40;
    else
      Result := -1;
  end;
end;

function ConvertSize(SizeStr: string; Prefix: string = ''): Int64;
var
  Search: Integer;
  ParseStr: ArrOfStr;
  Value: Int64;
  XPrefix, XPostfix: string;
begin
  Result := -1;
  ParseStr := Explode(' ', AnsiLowerCase(SizeStr));
  if TryStrToInt64(ParseStr[0], Value) then
  begin
    case Length(ParseStr) of
      1:
        Result := Value;
      2:
      begin
        Search := Pos('b', ParseStr[1]);
        if Search > 0 then
        begin
          XPrefix := Copy(ParseStr[1], 1, Search - 1);
          XPostfix := Copy(ParseStr[1], Search);
          case GetArrayIndex(DataSizes, XPostfix) of
          0,1,2: Result := Value * GetPrefixSize(XPrefix);
            3,4: Result := Trunc(Value/8) * GetPrefixSize(XPrefix);
            else
              Exit;
          end;
        end;
      end;
      else
        Exit;
    end;
    if Prefix <> '' then
      Result := Trunc(Result/GetPrefixSize(Prefix));
  end;
end;

function ValidSize(SizeStr: string; Min, Max: int64; Prefix: string): Boolean;
begin
  Result := ValidInt(IntToStr(ConvertSize(SizeStr, Prefix)), Min, Max);
end;

function ValidInt(IntStr: string; Min, Max: Integer): Boolean; overload;
var
  n: Integer;
begin
  if TryStrToInt(IntStr, n) then
  begin
    if (n >= Min) and (n <= Max) then
    begin
      Result := True;
      Exit;
    end;
  end;
  Result := False;
end;

function ValidInt(IntStr: string; Min, Max: Int64): Boolean; overload;
var
  n: Int64;
begin
  if TryStrToInt64(IntStr, n) then
    if (n >= Min) and (n <= Max) then
    begin
      Result := True;
      Exit;
    end;
  Result := False;
end;

function ValidHash(HashStr: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  if Length(HashStr) = 40 then
  begin
    for i := 1 to Length(HashStr) do
      if not CharInSet(HashStr[i], ['0'..'9', 'A'..'F']) then
        Exit;
    Result := True;
  end;
end;

function IsIPv4(IpStr: string): Boolean;
var
  ParseStr: ArrOfStr;
  n, i: Integer;
begin
  Result := False;
  ParseStr := Explode('.', IpStr);
  if Length(ParseStr) <> 4 then
    Exit;
  for i := 0 to 3 do
  begin
    if TryStrToInt(ParseStr[i], n) then
    begin
      if (n < 0) or (n > 255) then
        Exit;
      if ParseStr[i][1] = '$' then
        Exit;
      if ParseStr[i][1] = '-' then
        Exit;
      if ParseStr[i][1] = '0' then
      begin
        if n <> 0 then
          Exit
        else
          if ParseStr[i][2] = '0' then
            Exit;
      end;
    end
    else
      Exit;
  end;
  Result := True;
end;

function IsIPv6(IpStr: string): Boolean;
var
  Parts, Words: ArrOfStr;
  Flag: Boolean;
  i, j, n, WordCount, PartsCount, Totals: Integer;
begin
  Result := IpStr = '::';
  if Result then
    Exit;
  Flag := False;
  IpStr := StringReplace(IpStr, '::', '|', [rfReplaceAll]);
  Parts := Explode('|', IpStr);
  PartsCount := Length(Parts);
  if PartsCount > 2 then
    Exit;
  Totals := 0;
  for i := 0 to PartsCount - 1 do
  begin
    if Parts[i] = '' then
      Continue;
    Words := Explode(':', Parts[i]);
    WordCount := Length(Words);
    for j := 0 to WordCount - 1 do
    begin
      if TryStrToInt('$' + Words[j], n) then
      begin
        if (n < 0) or (n > 65535) then
          Exit;
      end
      else
      begin
        if (j = WordCount - 1) and (i = PartsCount - 1) and IsIPv4(Words[j]) then
          Flag := True
        else
          Exit;
      end;
    end;
    Inc(Totals, WordCount);
  end;
  if not Assigned(Words) then
    Exit;
  if Flag then
    Inc(Totals);
  case PartsCount of
    1: if Totals <> 8 then Exit;
    2: if (Totals + 1) > 8 then Exit;
  end;
  Result := True;
end;

function ValidAddress(AddrStr: string; AllowCidr: Boolean = False; ReqBrackets: Boolean = False): Byte;
var
  Search: Integer;
  Mask: Byte;
  IpStr: string;
begin
  Result := 0;
  Search := Pos('/', AddrStr);
  if Search = 0 then
  begin
    if IsIPv4(AddrStr) then
      Result := 1
    else
    begin
      if ReqBrackets then
      begin
        if not HasBrackets(AddrStr) then
          Exit;
        if IsIPv6(Copy(AddrStr, 2, Length(AddrStr) - 2)) then
          Result := 2;
      end
      else
        if IsIPv6(AddrStr) then
          Result := 2;
    end;
  end
  else
  begin
    if AllowCidr then
    begin
      IpStr := Copy(AddrStr, 1, Search - 1);
      if IsIPv4(IpStr) then
        Mask := 32
      else
      begin
        if ReqBrackets then
        begin
          if not HasBrackets(IpStr) then
            Exit;
          IpStr := Copy(IpStr, 2, Length(IpStr) - 2);
        end;
        if IsIPv6(IpStr) then
          Mask := 128
        else
          Exit;
      end;
      if ValidInt(Copy(AddrStr, Search + 1), 1, Mask) then
      begin
        case Mask of
          32: Result := 1;
         128: Result := 2;
        end;
      end;
    end;
  end;
end;

function ValidHost(HostStr: string; AllowRootDomain: Boolean = False; AllowIp: Boolean = True; ReqBrackets: Boolean = False): Boolean;
var
  i, j, SubLen, Count: Integer;
  SubDomains: ArrOfStr;
begin
  Result := False;
  if AllowRootDomain and (HostStr = '.') then
  begin
    Result := True;
    Exit;
  end;
  if ValidAddress(HostStr, False, ReqBrackets) <> 0 then
  begin
    if AllowIp then
    begin
      Result := True;
      Exit;
    end
    else
      Exit;
  end;
  if Length(HostStr) > 255 then
    Exit;
  SubDomains := Explode('.', HostStr);
  Count := Length(SubDomains);
  if Count < 2 then
    Exit;
  for i := 0 to Count - 1 do
  begin
    if (i = 0) and (SubDomains[i] = '') then
    begin
      if AllowRootDomain then
        continue
      else
        Exit;
    end;
    SubLen := Length(SubDomains[i]);
    if ((SubLen < 2) and (i >= Count - 2)) or (SubLen > 63) then
      Exit;
    for j := 1 to SubLen do
    begin
      if ((j = 1) or (j = SubLen)) and not CharInSet(SubDomains[i][j], ['0'..'9', 'a'..'z']) then
        Exit
      else
        if not CharInSet(SubDomains[i][j], ['0'..'9', 'a'..'z', '-']) then
          Exit;
    end;
  end;
  if SubDomains[Count - 1] = 'exit' then
    Exit;
  if SubDomains[Count - 1] = 'onion' then
    Exit;
  Result := True;
end;

function ValidSocket(SocketStr: string; AllowHostNames: Boolean = False): Byte;
var
  Search: Integer;
begin
  Result := 0;
  Search := RPos(':', SocketStr);
  if Search = 0 then
    Exit;
  if AllowHostNames then
  begin
    if ValidHost(Copy(SocketStr, 1, Search - 1), False, True, True) then
      Result := 3;
  end
  else
    Result := ValidAddress(Copy(SocketStr, 1, Search - 1), False, True);
  if Result <> 0 then
    if not ValidInt(Copy(SocketStr, Search + 1), 1, 65535) then
      Result := 0;
end;

function ValidPolicy(PolicyStr: string): Boolean;
var
  ParseStr, Ports: ArrOfStr;
  Search, i: Integer;
  Address, Port: string;
  PolicyType, AddressType, MaskType: Integer;
begin
  Result := False;
  ParseStr := Explode(' ', PolicyStr);
  if Length(ParseStr) <> 2 then
    Exit;
  PolicyType := GetArrayIndex(PolicyTypes, ParseStr[0]);
  if PolicyType = -1 then
    Exit;
  if ParseStr[1] <> '*' then
  begin
    Search := RPos(':', ParseStr[1]);
    if Search = 0 then
      Exit;
    Port := Copy(ParseStr[1], Search + 1);
    if Port <> '*' then
    begin
      Ports := Explode('-', Port);
      if Length(Ports) > 2 then
        Exit;
      for i := 0 to Length(Ports) - 1 do
        if not ValidInt(Ports[i], 1, 65535) then
          Exit;
    end;
    Address := Copy(ParseStr[1], 1, Search - 1);
    MaskType := GetArrayIndex(MaskTypes, Address);
    case MaskType of
      -1:
      begin
        AddressType := ValidAddress(Address, True, True);
        case AddressType of
          0: Exit;
          1: if PolicyType > 1 then Exit;
        end;
      end;
      1,3: if PolicyType > 1 then Exit;
    end;
  end;
  Result := True;
end;

function GetTransportID(TypeStr: string): Byte;
begin
  Result := TRANSPORT_CLIENT;
  if Length(TypeStr) > 0 then
  begin
    case AnsiChar(TypeStr[1]) of
      SELECT_CHAR: Result := TRANSPORT_SERVER;
      BOTH_CHAR: Result := TRANSPORT_BOTH;
    end;
  end;
end;

function GetTransportChar(TransportID: Byte): string;
begin
  case TransportID of
    TRANSPORT_SERVER: Result := SELECT_CHAR;
    TRANSPORT_BOTH: Result := BOTH_CHAR;
    else
      Result := FAVERR_CHAR;
  end;
end;

function TryParseBridge(BridgeStr: string; out Bridge: TBridge): Boolean;
var
  ParseStr: ArrOfStr;
  ParamsState: Byte;
  ParamsStr: string;
  i: Integer;
begin
  Bridge.Ip := '';
  Bridge.Port := 0;
  Bridge.Hash := '';
  Bridge.Transport := '';
  Bridge.Params := '';
  Result := ValidBridge(BridgeStr, btNone);
  if Result then
  begin
    ParamsState := 0;
    ParamsStr := '';
    ParseStr := Explode(' ', BridgeStr);
    for i := 0 to Length(ParseStr) - 1 do
    begin
      case ParamsState of
        1:
        begin
          ParamsState := 2;
          if ValidHash(ParseStr[i]) then
            Bridge.Hash := ParseStr[i]
          else
            ParamsStr := ParamsStr + ' ' + ParseStr[i];
          Continue;
        end;
        2:
        begin
          ParamsStr := ParamsStr + ' ' + ParseStr[i];
          Continue;
        end;
      end;
      if ValidTransport(ParseStr[i]) then
      begin
        Bridge.Transport := ParseStr[i];
        Continue;
      end;
      if ValidSocket(ParseStr[i]) <> 0 then
      begin
        Bridge.Ip := GetAddressFromSocket(ParseStr[i]);
        Bridge.Port := GetPortFromSocket(ParseStr[i]);
        ParamsState := 1;
        Continue;
      end;
    end;
    Bridge.Params := Trim(ParamsStr);
  end;
end;

function ValidTransport(TransportStr: string): Boolean;
var
  T: TTransportInfo;
begin
  if TransportsDic.TryGetValue(TransportStr, T) then
  begin
    Result := T.TransportID <> TRANSPORT_SERVER;
    Exit;
  end;
  Result := False;
end;

function ValidBridge(BridgeStr: string; BridgeType: TBridgeType): Boolean;
var
  ParseStr: ArrOfStr;
  ParamCount: Integer;
  T: TTransportInfo;
begin
  Result := False;
  BridgeStr := Trim(BridgeStr);
  if (BridgeStr = '') or (Pos('|', BridgeStr) <> 0)  then
    Exit;
  ParseStr := Explode(' ', BridgeStr);
  ParamCount := Length(ParseStr);

  if ParamCount > 1 then
  begin
    if TransportsDic.TryGetValue(ParseStr[0], T) then
    begin
      if (T.TransportID <> TRANSPORT_SERVER) and (ValidSocket(ParseStr[1]) <> 0) then
      begin
        if BridgeType <> btNone then
        begin
          Include(T.BridgeType, BridgeType);
          TransportsDic.AddOrSetValue(ParseStr[0], T);
        end;
        Result := True;
      end;
    end
    else
      Result := (ValidSocket(ParseStr[0]) <> 0) and ValidHash(ParseStr[1]);
  end
  else
    Result := ValidSocket(ParseStr[0]) <> 0;
end;

function CidrToRange(CidrStr: string): TIPv4Range;
var
  Search: Integer;
  Prefix: Byte;
  Ip, Mask: Cardinal;
  ParseStr: ArrOfStr;
begin
  Search := Pos('/', CidrStr);
  Prefix := StrToInt(Copy(CidrStr, Search + 1));
  ParseStr := Explode('.', Copy(CidrStr, 1, Search - 1));

  Ip := StrToInt(ParseStr[0]) shl 24 or StrToInt(ParseStr[1]) shl 16 or
        StrToInt(ParseStr[2]) shl 8 or StrToInt(ParseStr[3]);
  Mask := $FFFFFFFF shl (32 - Prefix);
  Result.IpStart := Ip and Mask;
  Result.IpEnd := Ip or (Mask xor $FFFFFFFF);
end;

function IpInRanges(const IpStr: string; RangesData: array of string): Boolean;
var
  i: Integer;
  Range: TIPv4Range;
  Ip: Cardinal;
begin
  Ip := IpToInt(IpStr);
  for i := 0 to Length(RangesData) - 1 do
  begin
    Range := CidrToRange(RangesData[i]);
    if InRange(Ip, Range.IpStart, Range.IpEnd) then
    begin
      Result := True;
      Exit;
    end;
  end;
  Result := False;
end;

function IpToInt(IpStr: string): Cardinal;
var
  i, x, Index: Byte;
begin
  Result := 0;
  for i := 0 to 3 do
  begin
    Index := Pos('.', IpStr);
    x := StrToIntDef(copy(IpStr, 0, Index - 1), 0);
    Result := (256 * Result) + x;
    Delete(IpStr, 1, Index);
  end;
  Result := Result + Cardinal(StrToIntDef(IpStr, 0));
end;

function IntToIp(Ip: Cardinal): string;
begin
  Result := Format('%d.%d.%d.%d', [Ip shr 24, (Ip shr 16) and 255, (Ip shr 8) and 255, Ip and 255]);
end;

procedure ComboBoxAutoWidth(const AComboBox: TCombobox);
var
  i: Integer;
  FullWidth: Integer;
  ItemWidth: Integer;
  ScrollSize: Integer;
begin
  ScrollSize := 0;
  FullWidth := 0;
  if AComboBox.DropDownCount < AComboBox.Items.Count then
    ScrollSize := GetSystemMetrics(SM_CXVSCROLL);
  for i := 0 to AComboBox.Items.Count - 1 do
  begin
    ItemWidth := ScrollSize + AComboBox.Canvas.TextWidth(AComboBox.Items[i]) + 8;
    if ItemWidth > FullWidth then
		  FullWidth := ItemWidth;
  end;
  if FullWidth > AComboBox.Width then
    SendMessage(AComboBox.Handle, CB_SETDROPPEDWIDTH, FullWidth, 0);
end;

procedure GridScrollCheck(aSg: TStringGrid; ACol, ColWidth: Integer);
begin
  if (aSg.RowCount - aSg.FixedRows) > aSg.VisibleRowCount then
    aSg.ColWidths[ACol] := Round(ColWidth * Scale) - GetSystemMetrics(SM_CXVSCROLL)
  else
    aSg.ColWidths[ACol] := Round(ColWidth * Scale);
end;

procedure ControlsDisable(Control: TWinControl);
var
  i: Integer;
begin
  for i := 0 to Control.ControlCount - 1 do
  begin
    if Control.Controls[i] is TControl and Control.Controls[i].Enabled then
    begin
      Control.Controls[i].HelpContext := 1;
      Control.Controls[i].Enabled := False;
    end;
  end;
end;

procedure ControlsEnable(Control: TWinControl);
var
  i: Integer;
begin
  for i := 0 to Control.ControlCount - 1 do
  begin
    if Control.Controls[i] is TControl and (Control.Controls[i].HelpContext = 1) then
    begin
      Control.Controls[i].HelpContext := 0;
      Control.Controls[i].Enabled := True;
    end;
  end;
end;

function CtrlKeyPressed(Key: Char): Boolean;
var
  State: Boolean;
begin
  if Key = #0 then
    State := True
  else
    State := GetKeyState(Ord(Key)) < 0;
  Result := (GetKeyState(VK_CONTROL) < 0) and State;
end;

function GetPortProtocol(PortID: Word): string;
begin
  case PortID of
    443: Result := 'https';
    else
      Result := 'http';
  end;
end;

procedure LoadIconsFromResource(ImageList: TImageList; ResourceName: string);
var
  Bmp: TBitmap;
  Png: TPngImage;
begin
  Png := TPngImage.Create;
  Bmp := TBitmap.Create;
  try
    Png.LoadFromResourceName(HInstance, ResourceName);
    Bmp.Assign(Png);
    ImageList.Clear;
    ImageList.Add(Bmp, nil);
  finally
    Png.Free;
    Bmp.Free;
  end;
end;

procedure EditMenuEnableCheck(MenuItem: TMenuItem; MenuType: TEditMenuType);
var
  Control: TCustomEdit;
begin
  if Screen.ActiveControl is TCustomEdit then
  begin
    Control := TCustomEdit(Screen.ActiveControl);
    case MenuType of
      emCopy: MenuItem.Enabled := Control.SelLength > 0;
      emCut: MenuItem.Enabled := (Control.SelLength > 0) and not Control.ReadOnly;
      emPaste: MenuItem.Enabled := (IsClipboardFormatAvailable(CF_TEXT) or IsClipboardFormatAvailable(CF_UNICODETEXT)) and not Control.ReadOnly;
      emSelectAll: MenuItem.Enabled := Length(Control.Text) > 0;
      emClear: MenuItem.Enabled := (Length(Control.Text) > 0) and (not Control.ReadOnly or (Control = Tcp.meLog));
      emDelete: MenuItem.Enabled := (Control.SelLength > 0) and not Control.ReadOnly;
      emFind:
      begin
        MenuItem.Visible := Control is TMemo;
        if MenuItem.Visible then
          MenuItem.Enabled := Length(Control.Text) > 0;
      end;
    end;
  end;
end;

function SearchEdit(EditControl: TCustomEdit; const SearchString: String; Options: TFindOptions; FindFirst: Boolean = False): Boolean;
var
  Size: Integer;
  SearchOptions: TStringSearchOptions;
  Buffer, P: PChar;
begin
  Result := False;
  if (Length(SearchString) = 0) then Exit;
  Size := EditControl.GetTextLen;
  if (Size = 0) then Exit;

  SearchOptions := [];
  if frDown in Options then
    Include(SearchOptions, soDown);
  if frMatchCase in Options then
    Include(SearchOptions, soMatchCase);
  if frWholeWord in Options then
    Include(SearchOptions, soWholeWord);

  Buffer := StrAlloc(Size + 1);
  try
    EditControl.GetTextBuf(Buffer, Size + 1);
    if FindFirst then
      P := SearchBuf(Buffer, Size, 0, EditControl.SelLength, SearchString, SearchOptions)
    else
      P := SearchBuf(Buffer, Size, EditControl.SelStart, EditControl.SelLength, SearchString, SearchOptions);
    if P <> nil then
    begin
      EditControl.SelStart := P - Buffer;
      EditControl.SelLength := Length(SearchString);
      Result := True;
    end;
  finally
    StrDispose(Buffer);
  end;
end;

procedure EditMenuHandle(MenuType: TEditMenuType);
var
  Control: TCustomEdit;
begin
  if Screen.ActiveControl is TCustomEdit then
  begin
    Control := TCustomEdit(Screen.ActiveControl);
    if Control.Enabled then
    begin
      case MenuType of
        emCopy: Control.CopyToClipboard;
        emCut: Control.CutToClipboard;
        emPaste: Control.PasteFromClipboard;
        emSelectAll: Control.SelectAll;
        emClear: Control.Text := '';
        emDelete: Control.ClearSelection;
        emFind:
        begin
          if Control is TMemo then
          begin
            SearchFirst := False;
            FindObject := TMemo(Control);
            if Tcp.cbClearPreviousSearchQuery.Checked then
              Tcp.FindDialog.FindText := FindObject.SelText
            else
            begin
              if FindObject.SelText <> '' then
                Tcp.FindDialog.FindText := FindObject.SelText
            end;
            Tcp.FindDialog.Execute;
          end;
        end;
      end;
    end;
  end;
end;

function GetFileVersionStr(const FileName: string): string;
var
  InfoSize, Wnd: DWORD;
  VerBuf: Pointer;
  FI: PVSFixedFileInfo;
  VerSize: DWORD;
begin
  Result := '0.0.0.0';
  InfoSize := GetFileVersionInfoSize(PChar(FileName), Wnd);
  if InfoSize <> 0 then
  begin
    GetMem(VerBuf, InfoSize);
    try
      if GetFileVersionInfo(PChar(FileName), Wnd, InfoSize, VerBuf) then
        if VerQueryValue(VerBuf, '\', Pointer(FI), VerSize) then
          Result := Format('%d.%d.%d.%d', [
            HiWord(FI.dwFileVersionMS), LoWord(FI.dwFileVersionMS),
            HiWord(FI.dwFileVersionLS), LoWord(FI.dwFileVersionLS)
          ]);
    finally
      FreeMem(VerBuf);
    end;
  end;
end;

function CheckFileVersion(FileVersion, StaticVersion: string): Boolean;
begin
  FileVersion := SeparateLeft(FileVersion, '-');
  StaticVersion := SeparateLeft(StaticVersion, '-');
  Result := CompareNaturalText(PWideChar(FileVersion), PWideChar(StaticVersion)) <> -1;
end;

function TryUpdateMask(var Mask: Byte; Param: Byte; Condition: Boolean): Boolean;
begin
  if Condition then
  begin
    Result := Mask and Param = 0;
    if Result then
      Inc(Mask, Param);
  end
  else
  begin
    Result := Mask and Param <> 0;
    if Result then
      Dec(Mask, Param);
  end;
end;

function GetRoutersParamsCount(Mask: Integer): Integer;
  procedure CheckMask(Param: Integer);
  begin
    if Mask and Param <> 0 then
      Inc(Result);
  end;
begin
  Result := 0;
  CheckMask(ROUTER_BRIDGE);
  CheckMask(ROUTER_AUTHORITY);
  CheckMask(ROUTER_ALIVE);
  CheckMask(ROUTER_REACHABLE_IPV6);
  CheckMask(ROUTER_HS_DIR);
  CheckMask(ROUTER_DIR_MIRROR);
  CheckMask(ROUTER_NOT_RECOMMENDED);
  CheckMask(ROUTER_BAD_EXIT);
end;

function CheckSplitButton(Button: TButton; DirectClick: Boolean): Boolean;
var
  MousePoint, MenuPoint: TPoint;
begin
  Result := False;
  if (Win32MajorVersion = 5) and (Button.Style = bsSplitButton) and DirectClick then
  begin
    MousePoint := Button.ScreenToClient(Mouse.CursorPos);
    if not InRange(MousePoint.X, 0, Button.Width - 16) then
    begin
      if Assigned(Button.DropDownMenu) then
      begin
        MenuPoint := Button.ClientOrigin;
        Button.DropDownMenu.Popup(MenuPoint.X, MenuPoint.Y + Button.Height);
      end;
      Result := True;
    end;
  end;
end;

function FileTimeToDateTime(const FileTime: TFileTime): TDateTime;
var
  LocalFileTime: TFileTime;
  Age : integer;
begin
  FileTimeToLocalFileTime(FileTime, LocalFileTime);
  if FileTimeToDosDateTime(LocalFileTime, LongRec(Age).Hi, LongRec(Age).Lo) then
  begin
    Result := FileDateToDateTime(Age);
    Exit;
  end;
  Result := -1;
end;

function GetFileID(FileName: string; SkipFileExists: Boolean = False; ConstData: string = ''): string;
var
  F: TSearchRec;
begin
  Result := '-1';
  if SkipFileExists or FileExists(FileName) then
  begin
    if FindFirst(FileName, faAnyFile, F) = 0 then
    {$WARN SYMBOL_PLATFORM OFF}
      Result := IntToHex(Crc32(AnsiString(IntToStr(F.Size)) + ':' +
        AnsiString(IntToStr(DateTimeToUnix(F.TimeStamp))) + ':' +
        AnsiString(IntToStr(DateTimeToUnix(FileTimeToDateTime(F.FindData.ftCreationTime)))) + ':' +
        AnsiString(ConstData)));
    {$WARN SYMBOL_PLATFORM ON}
    FindClose(F);
  end;
end;

function SampleDown(Data: ArrOfPoint; Threshold: Integer): ArrOfPoint;
var
  i, DataLength, SampledIndex: Integer;
  a, NextA: Integer;
  AvgRangeStart, AvgRangeEnd, AvgRangeLength: Integer;
  RangeOffs, RangeTo: Integer;
  PointAX, PointAY: Integer;
  MaxAreaPoint: TPoint;
  Every, Area, MaxArea: Real;
  AvgX, AvgY: Real;
begin
  DataLength := Length(Data);
  if (Threshold >= DataLength) or (Threshold < 3) then
  begin
    Result := Data;
    Exit;
  end;

  Result := nil;
  SetLength(Result, Threshold);

  i := 0;
  a := 0;
  NextA := 0;
  MaxAreaPoint.X := 0;
  MaxAreaPoint.Y := 0;
  SampledIndex := 0;
  Result[SampledIndex] := Data[a];
  Inc(SampledIndex);

  Every := (DataLength - 2) / (Threshold - 2);

  while i < Threshold - 2 do
  begin
    AvgX := 0;
    AvgY := 0;
    AvgRangeStart := Floor((i + 1) * Every) + 1;
    AvgRangeEnd := Floor((i + 2) * Every) + 1;
    if AvgRangeEnd < DataLength then
      AvgRangeEnd := AvgRangeEnd
    else
      AvgRangeEnd := DataLength;
    AvgRangeLength := AvgRangeEnd - AvgRangeStart;
    while AvgRangeStart < AvgRangeEnd do
    begin
      AvgX := AvgX + Data[AvgRangeStart].X * 1;
      AvgY := AvgY + Data[AvgRangeStart].Y * 1;
      Inc(AvgRangeStart);
    end;

    AvgX := AvgX / AvgRangeLength;
    AvgY := AvgY / AvgRangeLength;

    RangeOffs := Floor((i + 0) * Every) + 1;
    RangeTo := Floor((i + 1) * Every) + 1;

    PointAX := Data[a].X * 1;
    PointAY := Data[a].Y * 1;

    MaxArea := -1;

    while RangeOffs < RangeTo do
    begin
      Area := Abs((PointAX - AvgX) * (Data[RangeOffs].Y - PointAY) - (PointAX - Data[RangeOffs].X) * (AvgY - PointAY)) * 0.5;
      if Area > MaxArea then
      begin
        MaxArea := Area;
        MaxAreaPoint := Data[RangeOffs];
        NextA := RangeOffs;
      end;
      Inc(RangeOffs);
    end;

    Result[SampledIndex] := MaxAreaPoint;
    Inc(SampledIndex);
    a := NextA;
    Inc(i);
  end;
  Result[SampledIndex] := Data[DataLength - 1];
end;

procedure EnableComposited(WinControl: TWinControl);
begin
  SetWindowLong(WinControl.Handle, GWL_EXSTYLE,
    GetWindowLong(WinControl.Handle, GWL_EXSTYLE) or WS_EX_COMPOSITED);
end;

initialization
  InitCharUpCaseTable(CharUpCaseTable);

end.
