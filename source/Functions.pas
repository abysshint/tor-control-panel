unit Functions;

interface

uses
  Winapi.Windows, Winapi.ActiveX, Winapi.ShlObj, System.Classes, Winapi.TlHelp32,
  Winapi.ShellApi, Winapi.WinSock, System.StrUtils, System.SysUtils, System.IniFiles, System.Hash,
  System.Variants, System.Masks, System.DateUtils, System.Generics.Collections, System.Generics.Defaults,
  System.Math, System.Win.ComObj, System.Win.Registry, Vcl.Graphics, Vcl.Forms, Vcl.Controls, Vcl.Grids,
  Vcl.Menus, Vcl.Imaging.pngimage, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Clipbrd, Vcl.Dialogs,
  Vcl.Buttons, Vcl.Themes, blcksock, synautil, ConstData, Addons, ClassData;

type
  TPeData = record
    Bits: Byte;
    CheckSum: Cardinal;
    MajorOSVersion: Word;
    MinorOSVersion: Word;
    IsDLL: Boolean;
  end;

  TFileID = record
    Data :string;
    ExecSupport: Boolean;
  end;

  TFallbackDir = record
    Hash: string;
    IPv4: string;
    IPv6: string;
    OrPort: Word;
    DirPort: Word;
    Weight: Double;
  end;

  TBridge = record
    Ip: string;
    Port: Word;
    Hash: string;
    SocketType: TSocketType;
    Transport: string;
    Params: string;
  end;

  TBridgeData = record
    Data: TBridge;
    DataStr: string;
  end;

  TTarget = record
    TargetType: TTargetType;
    Hostname: string;
    Port: string;
    Hash: string;
  end;

  TIndexData = record
    Index: Integer;
    IsComment: Boolean;
  end;

  TConfigFile = record
    FileName: string;
    Encoding: TEncoding;
    Data: TStringList;
    Idx: TDictionary<string, TArray<TIndexData>>;
  end;

  TPortInfo = record
    Port: Word;
    Value: ShortInt;
  end;

  TCharUpCaseTable = array [Char] of Char;
  TUserGrid = class(TCustomGrid);

var
  CharUpCaseTable: TCharUpCaseTable;

  function CreateJob(lpJobAttributes: PSecurityAttributes; lpName: LPCSTR): THandle; stdcall;
    external 'kernel32.dll' name 'CreateJobObjectA';

  function BoolToStrDef(Value: Boolean): string;
  function GetCommandLineFileName(const CommandLine: string): string;
  function CheckSplitButton(Button: TButton; DirectClick: Boolean): Boolean;
  function GetAssocUpDown(const AName: string): TUpdown;
  function GetCountryValue(const IpStr: string): Byte;
  function GetIntDef(Value, Default, Min, Max: Integer): Integer;
  function GetPortProtocol(PortID: Word): string;
  function GetFileVersionStr(const FileName: string): string;
  function FindStr(const Mask, Str: string): Boolean;
  function CtrlKeyPressed(Key: Char): Boolean;
  function GetArrayIndex(const Data: array of string; const Value: string): Integer;
  function GetConstantIndex(const Key: string): ShortInt;
  function GetDefaultsValue(const Key: string; const Default: string = ''): string;
  function GetSystemDir(CSIDL: Integer): string;
  function RegistryFileExists(Root: HKEY; const Key, Param: string): Boolean;
  function RegistryGetValue(Root: HKEY; const Key, Param: string): string;
  function CreateShortcut(const CmdLine, Args, WorkDir, LinkFile, IconFile: string): IPersistFile;
  function GetFullFileName(const FileName: string): string;
  function GetHost(const Host: string): string;
  function GetAddressFromSocket(const SocketStr: string; UseFormatHost: Boolean = False): string;
  function GetPortFromSocket(const SocketStr: string): Word;
  function GetRouterBySocket(const SocketStr: string): string;
  function FormatHost(const HostStr: string; Validate: Boolean = True): string;
  function ExtractDomain(const Url: string; HasPort: Boolean = False): string;
  function GetAvailPhysMemory: Cardinal;
  function GetCPUCount: Integer;
  function BytesToHex(const Bytes: TBytes): string;
  function StrToHex(const Value: string): string;
  function HexToStr(const hex: string): string;
  function Crypt(const Str, Key: string): string;
  function Decrypt(const Str, Key: string): string;
  function FileGetString(const Filename: string; Hex: Boolean = False): string;
  function ProcessExists(var ProcessInfo: TProcessInfo; FindChild: Boolean = True; AutoTerminate: Boolean = False): Boolean;
  function ExecuteProcess(CmdLine: string; Flags: TProcessFlags = []; JobHandle: THandle = 0): TProcessInfo;
  function RandomString(StrLen: Integer): string;
  function GetPasswordHash(const password: string): string;
  function CheckFileVersion(const FileVersion, StaticVersion: string): Boolean;
  function GetDirFromArray(const Data: array of string; const FileName: string = ''; ShowFileName: Boolean = False): string;
  function GetLogFileName(SeparateType: Integer): string;
  function GetRoutersParamsCount(Mask: Integer): Integer;
  function GetCircuitsParamsCount(PurposeID: Integer): Integer;
  function GetTorConfig(const Param, Default: string; Flags: TConfigFlags = []; ParamType: TParamType = ptString; MinValue: Integer = 0; MaxValue: Integer = 0; const Prefix: string = ''): string; overload;
  function GetTorConfig(const Param: string; Flags: TConfigFlags = []): TStringList; overload;
  function BytesFormat(Bytes: Double): string;
  function FormatSizeToBytes(const SizeStr: string): Int64;
  function CheckEditSymbols(Key: Char; const UserSymbols: AnsiString = ''; const EditMsg: string = ''): string;
  function CheckEditString(const Str: string; const UserSymbols: AnsiString = ''; AllowNumbersFirst: Boolean = True; const EditMsg: string = ''; edComponent: TEdit = nil): string;
  function IsDirectoryWritable(const Dir: string): Boolean;
  function PortTCPIsOpen(Port: Word; const IpStr: string; Timeout: Integer): Boolean;
  function GetBridgeCert: string;
  function InsensPosEx(const SubStr, S: string; Offset: Integer = 1): Integer;
  function HasBrackets(const Str: string; BracketsType: TBracketsType): Boolean;
  function GetAddressType(const IpStr: string; UseCidr: Boolean = False): TAddressType;
  function IpInReservedRanges(const IpStr: string; RangeType: TIPRangeType): Boolean;
  function IsIPv4(const IpStr: string): Boolean;
  function IsIPv6(const IpStr: string): Boolean;
  function ValidKeyValue(const Str: string): Boolean;
  function ValidData(const Str: string; ListType: TListType; Validate: Boolean = True): Boolean;
  function ValidInt(const IntStr: string; Min, Max: Integer): Boolean; overload;
  function ValidInt(const IntStr: string; Min, Max: Int64): Boolean; overload;
  function ValidInt(const IntStr: string; Min, Max: Integer; out n: Integer): Boolean; overload;
  function ValidFloat(const FloatStr: string; Min, Max: Double): Boolean;
  function ValidHash(const HashStr: string): Boolean; overload;
  function ValidHash(const HashStr: string; HashLength: Integer): Boolean; overload;
  function ValidNode(const NodeStr: string; Validate: Boolean = True): TNodeDataType;
  function ValidAddress(const AddrStr: string; AllowCidr: Boolean = False; ReqBrackets: Boolean = False): TAddressType;
  function ValidHost(const HostStr: string; AllowRootDomain: Boolean = False; AllowIp: Boolean = True; ReqBrackets: Boolean = False; DenySpecialDomains: Boolean = True): THostType;
  function ValidBridge(const BridgeStr: string; StrictTransport: Boolean = False): Boolean;
  function ValidTransport(const TransportStr: string; StrictTransport: Boolean = False): Boolean;
  function ValidSocket(const SocketStr: string; AllowHostNames: Boolean = False): TSocketType;
  function ValidPolicy(const PolicyStr: string): Boolean;
  function ValidFallbackDir(const FallbackStr: string): Boolean;
  function GetMsgCaption(const Caption: string; MsgType: TMsgType): string;
  function TryParseBridge(const BridgeStr: string; out Bridge: TBridge; Validate: Boolean = True; UseFormatHost: Boolean = False): Boolean;
  function TryParseFallbackDir(const FallbackStr: string; out FallbackDir: TFallbackDir; Validate: Boolean = True; UseFormatHost: Boolean = False): Boolean;
  function TryParseTarget(const TargetStr: string; out Target: TTarget): Boolean;
  function CompareNaturalText(const S1, S2: string; CaseSensitive: Boolean = False): Integer;
  function CompAsc(aSl: TStringList; aIndex1, aIndex2: Integer): Integer; overload;
  function CompAsc(const A, B: string) : Integer; overload;
  function CompDesc(aSl: TStringList; aIndex1, aIndex2: Integer): Integer; overload;
  function CompDesc(const A, B: string) : Integer; overload;
  function CompIntObjectAsc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
  function CompIntObjectDesc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
  function CompIntDesc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
  function CompIntAsc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
  function CompTextAsc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer; overload;
  function CompTextAsc(const A, B: string): Integer; overload;
  function CompTextDesc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer; overload;
  function CompSizeAsc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
  function CompTextDesc(const A, B: string): Integer;  overload;
  function CompSizeDesc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
  function CompParamsAsc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
  function CompParamsDesc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
  function CompFlagsAsc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
  function CompFlagsDesc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
  function GetTaskBarPos: TTaskBarPos;
  function RemoveBrackets(const Str: string; BracketsType: TBracketsType; TrimOnly: Boolean = True): string;
  function SearchEdit(EditControl: TCustomEdit; const SearchString: String; Options: TFindOptions; FindFirst: Boolean = False): Boolean;
  function ShowMsg(const Msg: string; Caption: string = ''; MsgType: TMsgType = mtInfo; Question: Boolean = False): Boolean;
  function MenuToInt(Menu: TMenuItem): Integer;
  function TryUpdateMask(var Mask: Word; Param: Word; Condition: Boolean): Boolean;
  function TryGetDataFromStr(const Str: string; DataType: TListType; out DatatStr: string; const Separator: string = ''): Boolean;
  function SampleDown(const Data: ArrOfPoint; Threshold: Integer): ArrOfPoint;
  function FileTimeToDateTime(const FileTime: TFileTime): TDateTime;
  function GetPortsValue(const PortsData: TArray<TPortInfo>; Port: Word): Integer;
  function GetBridgeIp(const Bridge: TBridge): string;
  function GetFileID(const FileName: string; SkipFileExists: Boolean = False; const ConstData: string = ''): TFileID;
  function ListToStr(ls: TStringList; const Delimiter: string): string;
  function MemoToLine(Memo: TMemo; SortType: Byte = SORT_NONE; const Separator: string = ','): string;
  procedure MemoToList(Memo: TMemo; out ls: TStringList; SortType: Byte = SORT_NONE);
  procedure LineToMemo(const Line: string; Memo: TMemo; SortType: Byte = SORT_NONE; const Separator: string = ','; RemoveDuplicates: Boolean = True; Validate: Boolean = True);
  procedure GetPeData(const FileName: string; var Data: TPEData);
  procedure SetPortsValue(const IpStr: string; Port: Word; Value: ShortInt);
  procedure SetPingValue(const IpStr: string; Value: SmallInt);
  procedure SetCountryValue(const IpStr: string; Value: Byte);
  procedure DeleteFiles(const FileMask: string; TimeOffset: Integer = 0);
  procedure DeleteDir(const DirName: string);
  procedure AppendWithDelims(sb: TStringBuilder; const Value: string; const Delimiter: string = ',');
  procedure IntToMenu(Menu: TMenuItem; Mask: Integer; DisableUnchecked: Boolean = False);
  procedure GetNodes(var Nodeslist: string; NodeType: TNodeType; Favorites: Boolean; Validate: Boolean = True; ini: TMemIniFile = nil);
  procedure SetTorConfig(const Param, Value: string; Flags: TConfigFlags = []); overload;
  procedure AddTorConfig(const Param: string; Values: TStringList; Flags: TConfigFlags = []); overload;
  procedure AddTorConfig(const Param, Value: string; Flags: TConfigFlags = []); overload;
  procedure DeleteTorConfig(const Params: TArray<string>; Flags: TConfigFlags = []);
  procedure SetConfigBoolean(const Section, Ident: string; Value: Boolean);
  procedure SetConfigInteger(const Section, Ident: string; Value: Integer); overload;
  procedure SetConfigInteger(const Section, Ident: string; Value: Int64); overload;
  procedure SetConfigString(const Section, Ident: string; Value: string);
  procedure SaveToLog(const str, LogFile: string);
  procedure AddUPnPEntry(Port: Integer; const Desc, LanIp: string; Test: Boolean; var Msg: string);
  procedure RemoveUPnPEntry(const PortList: array of Word);
  procedure SetGridLastCell(aSg: TStringGrid; Show: Boolean = True; ScrollTop: Boolean = False; ManualSort: Boolean = False; ARow: Integer = -1; ACol: Integer = -1; FindCol: Integer = -1);
  procedure FindInGridColumn(aSg: TStringGrid; ACol: Integer; Key: Char);
  procedure InitCharUpCaseTable(var Table: TCharUpCaseTable);
  procedure CheckFileEncoding(const FileName, BackupFile: string);
  procedure Flush(const FileName: string);
  procedure UpdateConfigFile(ini: TMemIniFile);
  procedure CheckLabelEndEllipsis(lbComponent: TLabel; MaxWidth: Integer; EllipsisType: TEllipsisPosition; UseHint: Boolean; IgnoreFormSize: Boolean);
  procedure sgSort(aSg: TStringGrid; aCol: Integer; aCompare: TStringListSortCompare);
  procedure GetLocalInterfaces(ComboBox: TComboBox; const RecentHost: string = '');
  procedure GridDrawIcon(aSg: TStringGrid; Rect: TRect; ls: TImageList; Index: Integer; W: Integer = 16; H: Integer = 16);
  procedure GridDrawSortArrows(aSg: TStringGrid; Rect: TRect);
  procedure GridSetKeyboardLayout(aSg: TStringGrid; ACol: Integer);
  procedure GridSetFocus(aSg: TStringGrid);
  procedure GridShowHints(aSg: TStringGrid);
  procedure GridShowCountryHint(aSg: TStringGrid; IPv4Col, IPv6Col, FlagCol: Integer; UseSocket: Boolean; out HintGeoIpType: TGeoIpType);
  procedure GridScrollCheck(aSg: TStringGrid; ACol, ColWidth: Integer);
  procedure GridSelectCell(aSg: TStringGrid; ACol, ARow: Integer);
  function GetRouterStrFlags(Flags: TRouterFlags): string;
  function GetRouterStrParams(Params: Word; Flags: TRouterFlags): string;
  function GridGetSpecialData(aSg: TStringGrid; ACol, ARow: Integer; const KeyStr: string): string;
  procedure GridKeyDown(aSg: TStringGrid; Shift: TShiftState; var Key: Word);
  procedure GridCheckAutoPopup(aSg: TStringGrid; ARow: Integer; AllowEmptyRows: Boolean = False);
  procedure GoToInvalidOption(PageID: TTabSheet; const Msg: string = ''; edComponent: TCustomEdit = nil);
  procedure DeleteDuplicatesFromList(var ls: TStringList; ListType: TListType = ltNone);
  procedure SortList(var ls: TStringList; ListType: TListType; SortType: Byte);
  procedure SortHostsList(var ls: TStringList; SortType: Byte = SORT_ASC);
  procedure SortNodesList(var ls: TStringList; SortType: Byte = SORT_ASC);
  procedure ControlsDisable(Control: TWinControl);
  procedure ControlsEnable(Control: TWinControl);
  procedure LoadTorConfig;
  procedure SaveTorConfig;
  function LoadIconsFromResource(ImageList: TImageList; const ResourceName: string; UseFile: Boolean = False): Boolean;
  procedure LoadThemesList(ThemesList: TComboBox; const LastStyle: string);
  procedure LoadStyle(ThemesList: TCombobox);
  procedure EditMenuHandle(MenuType: TEditMenuType);
  procedure EditMenuEnableCheck(MenuItem: TMenuItem; MenuType: TEditMenuType);
  procedure MenuSelectPrepare(SelMenu: TMenuItem = nil; UnSelMenu: TMenuItem = nil; HandleDisabled: Boolean = False);
  procedure ShellOpen(const Url: string);
  procedure SetMaskData(var Mask: Integer; CheckBoxControl: TCheckBox);
  procedure GetMaskData(var Mask: Integer; CheckBoxControl: TCheckBox);
  procedure GetSettings(const Section: string; UpDownControl: TUpDown; ini: TMemIniFile); overload;
  procedure GetSettings(const Section: string; CheckBoxControl: TCheckBox; ini: TMemIniFile); overload;
  procedure GetSettings(const Section: string; MenuControl: TMenuItem; ini: TMemIniFile; Default: Boolean = True); overload;
  procedure GetSettings(const Section: string; ComboBoxControl: TComboBox; ini: TMemIniFile; Default: Integer = 0); overload;
  procedure GetSettings(const Section: string; EditControl: TEdit; ini: TMemIniFile); overload;
  procedure GetSettings(const Section: string; SpeedButtonControl: TSpeedButton; ini: TMemIniFile); overload;
  procedure GetSettings(UpDownControl: TUpDown; Flags: TConfigFlags = []); overload;
  procedure GetSettings(CheckBoxControl: TCheckBox; Flags: TConfigFlags = []); overload;
  procedure GetSettings(SpeedButtonControl: TSpeedButton; Flags: TConfigFlags = []); overload;
  procedure GetSettings(MenuControl: TMenuItem; Flags: TConfigFlags = []; Default: Boolean = True); overload;
  procedure SetSettings(const Section: string; UpDownControl: TUpDown; ini: TMemIniFile); overload;
  procedure SetSettings(const Section: string; CheckBoxControl: TCheckBox; ini: TMemIniFile); overload;
  procedure SetSettings(const Section: string; SpeedButtonControl: TSpeedButton; ini: TMemIniFile); overload;
  procedure SetSettings(const Section: string; MenuControl: TMenuItem; ini: TMemIniFile); overload;
  procedure SetSettings(const Section: string; ComboBoxControl: TComboBox; ini: TMemIniFile; SaveIndex: Boolean = True; UseFormatHost: Boolean = False); overload;
  procedure SetSettings(const Section: string; EditControl: TEdit; ini: TMemIniFile); overload;
  procedure SetSettings(const Section, Ident, Value: string; ini: TMemIniFile); overload;
  procedure SetSettings(const Section, Ident: string; Value: Integer; ini: TMemIniFile); overload;
  procedure SetSettings(const Section, Ident: string; Value: Int64; ini: TMemIniFile); overload;
  procedure SetSettings(const Section, Ident: string; Value: Boolean; ini: TMemIniFile); overload;
  procedure DeleteSettings(const Section, Ident: string; ini: TMemIniFile);
  function GetSettings(const Section, Ident, Default: string; ini: TMemIniFile): string; overload;
  function GetSettings(const Section, Ident: string; Default: Integer; ini: TMemIniFile): Integer; overload;
  function GetSettings(const Section, Ident: string; Default: Int64; ini: TMemIniFile): Int64; overload;
  function GetSettings(const Section, Ident: string; Default: Boolean; ini: TMemIniFile): Boolean; overload;
  procedure EnableComposited(WinControl: TWinControl);
  function GetConfig(var Config: TConfigFile; const Param, Default: string; Flags: TConfigFlags = []; ParamType: TParamType = ptString; MinValue: Integer = 0; MaxValue: Integer = 0): string; overload;
  function GetConfig(var Config: TConfigFile; const Param: string; Flags: TConfigFlags = []): TStringList; overload;
  procedure SetConfig(var Config: TConfigFile; const Param, Value: string; Flags: TConfigFlags = []);
  procedure AddConfig(var Config: TConfigFile; const Param: string; Values: TStringList; Flags: TConfigFlags = []); overload;
  procedure AddConfig(var Config: TConfigFile; const Param, Value: string; Flags: TConfigFlags = []); overload;
  procedure DeleteConfig(var Config: TConfigFile; const Params: TArray<string>; Flags: TConfigFlags = []);
  procedure LoadConfig(var Config: TConfigFile; Flags: TConfigFlags = []);
  procedure SaveConfig(var Config: TConfigFile; Flags: TConfigFlags = []);
  procedure AddOptionToIndex(var Config: TConfigFile; const OptionName: string; LineIndex: Integer; IsComment: Boolean);
  function TryGetStrFromIndex(const Data: TArray<string>; out Str: string; Index: Integer): Boolean;
  function TryGetOption(const Line, OptionName: string; out Value: string; FindComments: Boolean = False; FindOnly: Boolean = False): Boolean;
  function GetOptionName(const Line: string; out IsComment: Boolean; FindComments: Boolean = False): string;
  function InsertMenuItem(ParentMenu: TMenuItem; FTag, FImageIndex: Integer;
    const FCaption: string = ''; FOnClick: TNotifyEvent = nil; FChecked: Boolean = False;
    FAutoCheck: Boolean = False; FRadioItem: Boolean = False; FEnabled: Boolean = True;
    FVisible: Boolean = True; FHelpContext: THelpContext = 0; const FHint: string = ''): TMenuItem;

implementation

uses
  Main, Languages;

function TryGetStrFromIndex(const Data: TArray<string>; out Str: string; Index: Integer): Boolean;
begin
  Result := Length(Data) > Index;
  if Result then
    Str := Data[Index]
  else
    Str := '';
end;

function InsertMenuItem(ParentMenu: TMenuItem; FTag, FImageIndex: Integer;
  const FCaption: string = ''; FOnClick: TNotifyEvent = nil; FChecked: Boolean = False;
  FAutoCheck: Boolean = False; FRadioItem: Boolean = False; FEnabled: Boolean = True;
  FVisible: Boolean = True; FHelpContext: THelpContext = 0; const FHint: string = ''): TMenuItem;
begin
  Result := TMenuItem.Create(ParentMenu.Owner);
  Result.ImageIndex := FImageIndex;
  Result.Tag := FTag;
  Result.Caption := FCaption;
  Result.Checked := FChecked;
  Result.AutoCheck := FAutoCheck;
  Result.RadioItem := FRadioItem;
  Result.Enabled := FEnabled;
  Result.Visible := FVisible;
  Result.HelpContext := FHelpContext;
  Result.Hint := FHint;
  if Assigned(FOnClick) then
    Result.OnClick := FOnClick;
  ParentMenu.Add(Result);
end;

procedure SetMaskData(var Mask: Integer; CheckBoxControl: TCheckBox);
begin
  if CheckBoxControl.Checked then
    Inc(Mask, CheckBoxControl.Tag);
end;

procedure GetMaskData(var Mask: Integer; CheckBoxControl: TCheckBox);
begin
  if FirstLoad then
    CheckBoxControl.ResetValue := CheckBoxControl.Checked;
  CheckBoxControl.Checked := Mask and CheckBoxControl.Tag <> 0;
end;

function GetPortsValue(const PortsData: TArray<TPortInfo>; Port: Word): Integer;
var
  i: Integer;
begin
  Result := PORT_NONE;
  if PortsData = nil then
    Exit;
  for i := 0 to High(PortsData) do
  begin
    if PortsData[i].Port = Port then
      Exit(PortsData[i].Value);
  end;
end;

procedure SetPortsValue(const IpStr: string; Port: Word; Value: ShortInt);
var
  GeoIpInfo: TGeoIpInfo;
  PortDataLen, i: Integer;
  Search: Boolean;
  PortInfo: TPortInfo;
begin
  if GeoIpDic.TryGetValue(IpStr, GeoIpInfo) then
  begin
    PortInfo.Port := Port;
    PortInfo.Value := Value;
    PortDataLen := Length(GeoIpInfo.ports);
    if PortDataLen = 0 then
      TArrayHelper.AddToArray<TPortInfo>(GeoIpInfo.ports, PortInfo)
    else
    begin
      Search := False;
      for i := 0 to PortDataLen - 1 do
      begin
        if GeoIpInfo.ports[i].Port = Port then
        begin
          GeoIpInfo.ports[i].Value := Value;
          Search := True;
          Break;
        end;
      end;
      if not Search then
        TArrayHelper.AddToArray<TPortInfo>(GeoIpInfo.ports, PortInfo);
    end;
    GeoIpDic.AddOrSetValue(IpStr, GeoIpInfo);
  end
  else
  begin
    GeoIpInfo.cc := DEFAULT_COUNTRY_ID;
    GeoIpInfo.ping := PING_NONE;
    PortInfo.Port := Port;
    PortInfo.Value := Value;
    TArrayHelper.AddToArray<TPortInfo>(GeoIpInfo.ports, PortInfo);
    GeoIpDic.AddOrSetValue(IpStr, GeoIpInfo);
  end;
  GeoIpModified := True;
end;

procedure SetPingValue(const IpStr: string; Value: SmallInt);
var
  GeoIpInfo: TGeoIpInfo;
begin
  if GeoIpDic.TryGetValue(IpStr, GeoIpInfo) then
  begin
    GeoIpInfo.ping := Value;
    GeoIpDic.AddOrSetValue(IpStr, GeoIpInfo);
  end
  else
  begin
    GeoIpInfo.cc := DEFAULT_COUNTRY_ID;
    GeoIpInfo.ping := Value;
    GeoIpInfo.ports := nil;
    GeoIpDic.AddOrSetValue(IpStr, GeoIpInfo);
  end;
  GeoIpModified := True;
end;

procedure SetCountryValue(const IpStr: string; Value: Byte);
var
  GeoIpInfo: TGeoIpInfo;
begin
  if GeoIpDic.TryGetValue(IpStr, GeoIpInfo) then
  begin
    GeoIpInfo.cc := Value;
    GeoIpDic.AddOrSetValue(IpStr, GeoIpInfo);
  end
  else
  begin
    GeoIpInfo.cc := Value;
    GeoIpInfo.ping := PING_NONE;
    GeoIpInfo.ports := nil;
    GeoIpDic.AddOrSetValue(IpStr, GeoIpInfo);
  end;
  GeoIpModified := True;
end;

function GetBridgeIp(const Bridge: TBridge): string;
var
  BridgeInfo: TBridgeInfo;
  RouterInfo: TRouterInfo;
  GeoIpInfo: TGeoIpInfo;
  BridgeID: string;
begin
  BridgeID := Bridge.Hash;
  if BridgeID = '' then
    CompBridgesDic.TryGetValue(Bridge.Ip, BridgeID);
  if BridgesDic.TryGetValue(BridgeID, BridgeInfo) then
  begin
    if Bridge.Port = BridgeInfo.Router.Port then
    begin
      case Bridge.SocketType of
        soIPv4: Result := BridgeInfo.Router.IPv4;
        soIPv6: Result := BridgeInfo.Router.IPv6;
      end;
      if BridgeInfo.Source <> '' then
        Exit;
    end;
  end
  else
  begin
    if RoutersDic.TryGetValue(BridgeID, RouterInfo) then
    begin
      if (Bridge.Port = RouterInfo.Port) and (rfRelay in RouterInfo.Flags) then
      begin
        case Bridge.SocketType of
          soIPv4: Result := RouterInfo.IPv4;
          soIPv6: Result := RouterInfo.IPv6;
        end;
      end;
    end;
  end;
  if Result = Bridge.Ip then
    Exit;
  Result := Bridge.Ip;
  if GeoIpDic.TryGetValue(Bridge.Ip, GeoIpInfo) then
  begin
    if GetPortsValue(GeoIpInfo.ports, Bridge.Port) < PORT_DEAD then
      Exit;
  end;
  if IpInReservedRanges(Bridge.Ip, rtDoc) then
    Result := '';
end;

function BoolToStrDef(Value: Boolean): string;
begin
  if Value then
    Result := '1'
  else
    Result := '0'
end;

function GetAssocUpDown(const AName: string): TUpdown;
begin
  Result := TUpdown(Tcp.FindComponent('ud' + copy(AName, 3)));
end;

function GetCountryValue(const IpStr: string): Byte;
var
  GeoIpInfo: TGeoIpInfo;
begin
  if GeoIpDic.TryGetValue(IpStr, GeoIpInfo) then
    Result := GeoIpInfo.cc
  else
    Result := DEFAULT_COUNTRY_ID;
end;

function GetArrayIndex(const Data: array of string; const Value: string): Integer;
var
  i: Integer;
begin
  for i := 0 to High(Data) do
  begin
    if Data[i] = Value  then
      Exit(i);
  end;
  Result := -1;
end;

function GetConstantIndex(const Key: string): ShortInt;
begin
  if not ConstDic.TryGetValue(Key, Result) then
    Result := -1;
end;

function GetDefaultsValue(const Key: string; const Default: string = ''): string;
var
  Value: string;
begin
  if DefaultsDic.TryGetValue(Key, Value) then
  begin
    if Trim(Value) <> '' then
      Exit(Value);
  end;
  Result := Default;
end;

function FindStr(const Mask, Str: string): Boolean;
begin
  if not MatchesMask(Mask, '*[*?-!]*') then
    Result := InsensPosEx(Mask, Str) <> 0
  else
    Result := MatchesMask(Str, Mask);
end;

procedure ShellOpen(const Url: string);
var
  Port: Word;
  Address: string;
begin
  if Url = '' then
    Exit;
  if (Pos('://', Url) <> 0) or (Pos(':\', Url) <> 0) or Url.StartsWith('mailto:') then
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
  begin
    if ACol in LOCALE_COLS then
      ActivateKeyboardLayout(CurrentLanguage, 0);
  end;
end;

procedure SetGridLastCell(aSg: TStringGrid; Show: Boolean = True; ScrollTop: Boolean = False; ManualSort: Boolean = False; ARow: Integer = -1; ACol: Integer = -1; FindCol: Integer = -1);
var
  RowIndex, ColIndex: Integer;
  TopState: Boolean;
begin

  TopState := ScrollTop and ManualSort;
  if ARow = -1 then
  begin
    if TopState then
      RowIndex := aSg.FixedRows
    else
    begin
      if aSg.RowID.Data <> '' then
      begin
        if FindCol = -1 then
          FindCol := aSg.Key;
        if (aSg.Cells[FindCol, aSg.RowID.Selection.Top] = aSg.RowID.Data) then
          RowIndex := aSg.RowID.Selection.Top
        else
        begin
          if (aSg.Cells[FindCol, aSg.RowID.Selection.Bottom] = aSg.RowID.Data) then
            RowIndex := aSg.RowID.Selection.Bottom
          else
            RowIndex := aSg.Cols[FindCol].IndexOf(aSg.RowID.Data);
        end;
      end
      else
        RowIndex := aSg.FixedRows;
    end;
  end
  else
    RowIndex := ARow;

  if RowIndex < aSg.FixedRows then
  begin
    if InRange(aSg.RowID.Selection.Top, aSg.FixedRows, aSg.RowCount - 1) then
      RowIndex := aSg.RowID.Selection.Top
    else
    begin
      if InRange(aSg.RowID.Selection.Top - 1, aSg.FixedRows, aSg.RowCount - 1) then
        RowIndex := aSg.RowID.Selection.Top - 1
      else
        RowIndex := aSg.FixedRows;
    end;
  end;
  if RowIndex > aSg.RowCount - 1 then
    RowIndex := aSg.RowCount - 1;

  if ACol > - 1 then
    ColIndex := ACol
  else
    ColIndex := aSg.SelCol;

  if ((aSg.IsMultiRow or (aSg.IsMultiCol and not (goRowSelect in aSg.Options))) and not TopState) and (ARow = -1) then
  begin
    if aSg.SelectState then
      Exit;
    aSg.Selection := aSg.RowID.Selection;
    aSg.MultiSelState := True;
  end
  else
    TUserGrid(aSg).MoveColRow(ColIndex, RowIndex, True, Show);
  Tcp.UpdateSelectedRouter(aSg);
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
  aSg.MultiSelState := False;
end;

function GetRouterStrFlags(Flags: TRouterFlags): string;
begin
  Result := '';
  if rfAuthority in Flags then Result := Result + 'Authority';
  if rfBadExit in Flags then Result := Result + ' BadExit';
  if rfExit in Flags then Result := Result + ' Exit';
  if rfFast in Flags then Result := Result + ' Fast';
  if rfGuard in Flags then Result := Result + ' Guard';
  if rfHSDir in Flags then Result := Result + ' HSDir';
  if rfMiddleOnly in Flags then Result := Result + ' MiddleOnly';
  if rfStable in Flags then Result := Result + ' Stable';
  if rfV2Dir in Flags then Result := Result + ' V2Dir';
  Result := Trim(Result);
end;

function GetRouterStrParams(Params: Word; Flags: TRouterFlags): string;
  procedure InsertData(Key: Word; const Data: string);
  begin
    if Params and Key <> 0 then
      Result := Result + Data;    
  end;
begin
  Result := '';
  if Params and ROUTER_BRIDGE <> 0 then
  begin
    if rfRelay in Flags then
      Result := Result + 'BridgeRelay'
    else
    begin
      if rfNoBridgeRelay in Flags then
        Result := Result + 'NoBridgeRelay'
      else
        Result := Result + 'Bridge';
    end;
  end;
  InsertData(ROUTER_AUTHORITY, ' Authority');
  InsertData(ROUTER_ALIVE, ' Alive');
  InsertData(ROUTER_REACHABLE_IPV6, ' IPv6');
  InsertData(ROUTER_HS_DIR, ' HSDir');
  InsertData(ROUTER_UNSTABLE, ' Unstable');
  InsertData(ROUTER_NOT_RECOMMENDED, ' NotRecommended');
  InsertData(ROUTER_BAD_EXIT, ' BadExit');
  InsertData(ROUTER_MIDDLE_ONLY, ' MiddleOnly');
  InsertData(ROUTER_SUPPORT_CONFLUX, ' Conflux');
  Result := Trim(Result);
end;

function GridGetSpecialData(aSg: TStringGrid; ACol, ARow: Integer; const KeyStr: string): string;
var
  RouterInfo: TRouterInfo;
  StreamInfo: TStreamInfo;
  StrData: string;
begin
  Result := '';
  case aSg.Tag of
    GRID_FILTER:
    begin
      if ACol = FILTER_FLAG then
        Result := LowerCase(aSg.Cells[FILTER_ID, ARow]);
    end;
    GRID_ROUTERS:
    begin
      case ACol of
        ROUTER_COUNTRY_FLAG:
        begin
          Result := CountryCodes[GetCountryValue(aSg.Cells[ROUTER_ADDR_IPV4, ARow])];
          if Tcp.miRoutersShowIPv6CountryFlag.Checked and (aSg.Cells[ROUTER_ADDR_IPV6, ARow] <> '') then
          begin
            StrData := CountryCodes[GetCountryValue(aSg.Cells[ROUTER_ADDR_IPV6, ARow])];
            if Result <> StrData then
              Result := Result + ',' + StrData;
          end;
        end;
        ROUTER_ADDR_IPV6:
        begin
          if aSg.Cells[ROUTER_ADDR_IPV6, ARow] = '' then
            Result := NONE_CHAR
          else
            Result := aSg.Cells[ROUTER_ADDR_IPV6, ARow];
        end;
        ROUTER_FLAGS:
        begin
          if RoutersDic.TryGetValue(KeyStr, RouterInfo) then
            Result := GetRouterStrParams(RouterInfo.Params, RouterInfo.Flags);
        end;
      end;
    end;
    GRID_CIRCUITS:
    begin
      if ACol = CIRC_FLAGS then
        Result := aSg.Cells[CIRC_PURPOSE, ARow];
    end;
    GRID_CIRC_INFO:
    begin
      case ACol of
        CIRC_INFO_COUNTRY_FLAG:
        begin
          Result := CountryCodes[GetCountryValue(aSg.Cells[CIRC_INFO_ADDR_IPV4, ARow])];
          if Tcp.miCircuitsShowIPv6CountryFlag.Checked and (aSg.Cells[CIRC_INFO_ADDR_IPV6, ARow] <> '') then
          begin
            StrData := CountryCodes[GetCountryValue(aSg.Cells[CIRC_INFO_ADDR_IPV6, ARow])];
            if Result <> StrData then
              Result := Result + ',' + StrData;
          end;
        end;
        CIRC_INFO_ADDR_IPV6:
        begin
          if aSg.Cells[CIRC_INFO_ADDR_IPV6, ARow] = '' then
            Result := NONE_CHAR
          else
            Result := aSg.Cells[CIRC_INFO_ADDR_IPV6, ARow];
        end;
      end;
    end;
    GRID_STREAMS_INFO:
    begin
      if ACol = STREAMS_INFO_SOURCE_ADDR then
      begin
        if StreamsDic.TryGetValue(KeyStr, StreamInfo) then
          Result := StreamInfo.Target
        else
          Result := NONE_CHAR;
        Result := Result + TAB + aSg.Cells[STREAMS_INFO_SOURCE_ADDR, ARow];
      end;
    end;
  end;
  if Result = '' then
    Result := aSg.Cells[ACol, ARow];
end;

procedure GridKeyDown(aSg: TStringGrid; Shift: TShiftState; var Key: Word);
var
  i, j: Integer;
  GridRect: TGridRect;
  MultiSel, UseSpecialData, MultiRows, HiddenKey, HandleAction: Boolean;
  Data, KeyStr: string;
begin
  HandleAction := False;
  HiddenKey := aSg.ColWidths[0] = -1;
  MultiRows := (goRowSelect in aSg.Options) and (aSg.IsMultiRow or (ssShift in Shift));
  MultiSel := (ssShift in Shift) and (goRangeSelect in aSg.Options) and not (goRowSelect in aSg.Options);
  if ssCtrl in Shift then
  begin
    case Char(Key) of
      'C':
      begin
        Data := '';
        UseSpecialData := aSg.Tag in [GRID_FILTER, GRID_ROUTERS, GRID_CIRCUITS, GRID_CIRC_INFO, GRID_STREAMS_INFO];
        if MultiRows or ((aSg.IsMultiRow or (aSg.Selection.Left <> aSg.Selection.Right)) and not (goRowSelect in aSg.Options)) then
        begin
          for i := aSg.Selection.Top to aSg.Selection.Bottom do
          begin
            if UseSpecialData then
            begin
              KeyStr := aSg.Cells[0, i];
              if MultiRows and HiddenKey then
                Data := Data + KeyStr + TAB;
            end
            else
              KeyStr := '';
            for j := aSg.Selection.Left to aSg.Selection.Right do
            begin
              if aSg.ColWidths[j] > 0 then
              begin
                if UseSpecialData then
                  Data := Data + GridGetSpecialData(aSg, j, i, KeyStr)
                else
                  Data := Data + aSg.Cells[j, i];
                if j < aSg.Selection.Right then
                  Data := Data + TAB;
              end;
            end;
            Data := Data + BR;
          end;
        end
        else
        begin
          if UseSpecialData then
          begin
            KeyStr := aSg.Cells[0, aSg.SelRow];
            Data := GridGetSpecialData(aSg, aSg.SelCol, aSg.SelRow, KeyStr);
          end
          else
            Data := aSg.Cells[aSg.SelCol, aSg.SelRow];
        end;
        if Trim(Data) <> '' then
          Clipboard.AsText := Data;
      end;
      'A':
      begin
        aSg.SelectAll;
        HandleAction := True;
      end;
    end;
  end;

  if Key in [VK_PRIOR, VK_NEXT, VK_END, VK_HOME, VK_LEFT, VK_UP, VK_RIGHT, VK_DOWN] then
    aSg.ScrollKeyDown := True
  else
    aSg.ScrollKeyDown := False;
  aSg.SelectState := (ssShift in Shift) or (ssCtrl in Shift);

  case Key of
    VK_APPS:
    begin
      case aSg.Tag of
        GRID_HS, GRID_HS_PORTS: GridCheckAutoPopup(aSg, aSg.Row, True);
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
          Dec(aSg.SelCol)
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
      if MultiSel then
      begin
        GridRect := aSg.Selection;
        GridRect.Left := aSg.SelCol;
        aSg.Selection := GridRect;
      end
      else
        aSg.Col := aSg.SelCol;
      GridSetKeyboardLayout(aSg, aSg.SelCol)
    end;
    VK_RIGHT:
    begin
      Key := 0;
      if (aSg.SelCol < aSg.ColCount - 1) then
      begin    
        if aSg.ColWidths[aSg.SelCol + 1] > 0 then
          Inc(aSg.SelCol)
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
      if MultiSel then
      begin
        GridRect := aSg.Selection;     
        GridRect.Right := aSg.SelCol;
        aSg.Selection := GridRect;
      end
      else
        aSg.Col := aSg.SelCol;
      GridSetKeyboardLayout(aSg, aSg.SelCol)
    end;
  end;
  if HandleAction then
  begin
    case aSg.Tag of
      GRID_STREAMS: Tcp.ShowStreamsInfo(Tcp.sgCircuits.Cells[CIRC_ID, Tcp.sgCircuits.SelRow]);
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

procedure GridShowCountryHint(aSg: TStringGrid; IPv4Col, IPv6Col, FlagCol: Integer; UseSocket: Boolean; out HintGeoIpType: TGeoIpType);
var
  PixelData, RowIndex, MaxItems: Integer;
  CountryCodeIPv4, CountryCodeIPv6: Byte;
  IPv4Str, IPv6Str: string;
  CellRect, CellPoint: TRect;
  Fail: Boolean;
begin
  Fail := True;
  RowIndex := aSg.MovRow;
  if not aSg.IsEmptyRow(RowIndex) then
  begin
    IPv4Str := aSg.Cells[IPv4Col, RowIndex];
    if IPv4Str <> '' then
    begin
      MaxItems := 1;
      if UseSocket then
        IPv4Str := GetAddressFromSocket(IPv4Str, True);
      CountryCodeIPv4 := GetCountryValue(IPv4Str);
      IPv6Str := aSg.Cells[IPv6Col, RowIndex];
      if IPv6Str <> '' then
      begin
        if UseSocket then
          IPv6Str := GetAddressFromSocket(IPv6Str);
        CountryCodeIPv6 := GetCountryValue(IPv6Str);
        if CountryCodeIPv6 <> CountryCodeIPv4 then
          MaxItems := 2;
      end
      else
        CountryCodeIPv6 := DEFAULT_COUNTRY_ID;
      CellRect := aSg.CellRect(FlagCol, aSg.MovRow);
      CellPoint := aSg.ClientToScreen(CellRect);
      PixelData := (Mouse.CursorPos.X - CellPoint.Left - (CellRect.Width - MaxItems * 20) div 2);
      if InRange(PixelData, 0, MaxItems * 20 - 1) then
      begin
        case PixelData div 20 of
          0:
          begin
            HintGeoIpType := gitIPv4;
            aSg.Hint := TransStr(CountryCodes[CountryCodeIPv4]);
          end;
          1:
          begin
            HintGeoIpType := gitIPv6;
            aSg.Hint := TransStr(CountryCodes[CountryCodeIPv6]);
          end
          else
          begin
            HintGeoIpType := gitBoth;
            aSg.Hint := TransStr('??');
          end;
        end;
        Application.ActivateHint(Mouse.CursorPos);
        Exit;
      end;
    end;
  end;
  if Fail then
  begin
    Application.CancelHint;
    aSg.Hint := '';
    HintGeoIpType := gitNone;
  end;
end;

procedure GridCheckAutoPopup(aSg: TStringGrid; ARow: Integer; AllowEmptyRows: Boolean = False);
begin
  if not Assigned(aSg.PopupMenu) then
    Exit;
  if (ARow > 0) and (not aSg.IsEmptyRow(ARow) or AllowEmptyRows) then
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
  PSubStr, PS, PEnd: PChar;
  SubStrLen, n: Integer;
begin
  Result := 0;
  if (S = '') or (SubStr = '') or (Offset <= 0) then Exit;

  SubStrLen := Length(SubStr);
  if SubStrLen > Length(S) - Offset + 1 then Exit;

  PSubStr := PChar(SubStr);
  PS := PChar(S) + Offset - 1;
  PEnd := PChar(S) + Length(S) - SubStrLen;

  while PS <= PEnd do
  begin
    if CharUpCaseTable[PS^] = CharUpCaseTable[PSubStr^] then
    begin
      n := 1;
      while (n < SubStrLen) and
            (CharUpCaseTable[(PS + n)^] = CharUpCaseTable[(PSubStr + n)^]) do
        Inc(n);

      if n = SubStrLen then
        Exit(PS - PChar(S) + 1);
    end;
    Inc(PS);
  end;
end;

procedure FindInGridColumn(aSg: TStringGrid; ACol: Integer; Key: Char);
var
  i, StrLength: Integer;
begin
  if GetTickCount > SearchTimer + 1000 then
    SearchStr := '';
  SearchStr := SearchStr + Key;
  StrLength := Length(SearchStr);
  for i := 1 to aSg.RowCount - 1 do
  begin
    if AnsiLowerCase(Copy(aSg.Cells[ACol, i], 1, StrLength)) = SearchStr then
    begin
      aSg.Row := i;
      aSg.Col := ACol;
      SearchTimer := GetTickCount;
      break;
    end;
  end;
end;

procedure GoToInvalidOption(PageID: TTabSheet; const Msg: string = ''; edComponent: TCustomEdit = nil);
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

function CheckEditString(const Str: string; const UserSymbols: AnsiString = ''; AllowNumbersFirst: Boolean = True; const EditMsg: string = ''; edComponent: TEdit = nil): string;
var
  i: Integer;
  Msg: string;
  ParentBox: TGroupBox;
begin
  Result := '';
  ParentBox := nil;
  if Assigned(edComponent) then
  begin
    if edComponent.GetParentComponent is TGroupBox then
    begin
      ParentBox := TGroupBox(edComponent.GetParentComponent);
      Msg := TTabSheet(ParentBox.GetParentComponent).Caption + ' - ' + ParentBox.Caption + ' - ' + EditMsg + BR + BR
    end
    else
      Msg := TTabSheet(edComponent.GetParentComponent).Caption + ' - ' + EditMsg + BR + BR;
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
        Result := CheckEditSymbols(Str[i], UserSymbols, Msg);
        if Result <> '' then
          Break;
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

function CheckEditSymbols(Key: Char; const UserSymbols: AnsiString = ''; const EditMsg: string = ''): string;
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
  4..5: begin Default := TPL_MENU_DEFAULT; Max := TPL_MENU_MAX; end;
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

function HasBrackets(const Str: string; BracketsType: TBracketsType): Boolean;
var
  StrLen: Integer;
  StartChar, EndChar: Char;
begin
  StrLen := Length(Str);
  if StrLen > 1 then
  begin
    case BracketsType of
      btCurly: begin StartChar := '{'; EndChar := '}' end;
      btSquare: begin StartChar := '['; EndChar := ']' end;
      btRound: begin StartChar := '('; EndChar := ')' end;
      else
        Exit(False);
    end;
    Result := (Str[1] = StartChar) and (Str[StrLen] = EndChar)
  end
  else
    Result := False;
end;

function RemoveBrackets(const Str: string; BracketsType: TBracketsType; TrimOnly: Boolean = True): string;
begin
  if TrimOnly then
  begin
    case BracketsType of
      btCurly: Result := Str.Trim(['{','}']);
      btSquare: Result := Str.Trim(['[',']']);
      btRound: Result := Str.Trim(['(',')']);
      else
        Result := Str;
    end;
  end
  else
  begin
    case BracketsType of
      btCurly: Result := StringReplace(StringReplace(Str, '{', '', [rfReplaceAll]), '}', '', [rfReplaceAll]);
      btSquare: Result := StringReplace(StringReplace(Str, '[', '', [rfReplaceAll]), ']', '', [rfReplaceAll]);
      btRound: Result := StringReplace(StringReplace(Str, '(', '', [rfReplaceAll]), ')', '', [rfReplaceAll]);
      else
        Result := Str;
    end;
  end;
end;

function ValidNode(const NodeStr: string; Validate: Boolean = True): TNodeDataType;
begin
  if Validate then
  begin
    case Length(NodeStr) of
    0..1: Exit(dtNone);
       2: if FilterDic.ContainsKey(LowerCase(NodeStr)) then Exit(dtCode);
      40: if ValidHash(NodeStr, 40) then Exit(dtHash);
      else
      begin
        case ValidAddress(NodeStr, True, True) of
          atIPv4: Exit(dtIPv4);
          atIPv4Cidr: Exit(dtIPv4Cidr);
        end;
      end;
    end;
  end
  else
  begin
    case Length(NodeStr) of
    0..1: Exit(dtNone);
       2: Exit(dtCode);
      40: Exit(dtHash);
      else
      begin
        if Pos('/', NodeStr) = 0 then
          Exit(dtIPv4)
        else
          Exit(dtIPv4Cidr);
      end;
    end;
  end;
  Result := dtNone;
end;

procedure AppendWithDelims(sb: TStringBuilder; const Value: string; const Delimiter: string = ',');
begin
  if sb.Length > 0 then
    sb.Append(Delimiter);
  sb.Append(Value);
end;

procedure GetNodes(var Nodeslist: string; NodeType: TNodeType; Favorites: Boolean; Validate: Boolean = True; ini: TMemIniFile = nil);
var
  Count, i: Integer;
  Nodes: TArray<string>;
  FilterInfo: TFilterInfo;
  FNodeType: TNodeTypes;
  NodeStr: string;
  lbComponent: TLabel;
  NodeDataType: TNodeDataType;
  sb: TStringBuilder;
begin
  if Nodeslist = '' then
    Exit;
  Count := 0;
  if Favorites then
  begin
    Nodes := Nodeslist.Split([',']);
    for i := 0 to High(Nodes) do
    begin
      NodeStr := Trim(Nodes[i]);
      if HasBrackets(NodeStr, btCurly) then
        NodeStr := RemoveBrackets(NodeStr, btCurly);
      NodeDataType := ValidNode(NodeStr, Validate);
      case NodeDataType of
        dtNone: NodeStr := '';
        dtCode: NodeStr := LowerCase(NodeStr);
      end;
      if NodeStr <> '' then
      begin
        if NodeDataType <> dtIPv4Cidr then
        begin
          NodesDic.TryGetValue(NodeStr, FNodeType);
          Include(FNodeType, NodeType);
          NodesDic.AddOrSetValue(NodeStr, FNodeType);
        end
        else
        begin
          if IPv4CidrNodes.FindExactCIDR(NodeStr, FNodeType) then
            Include(FNodeType, NodeType)
          else
            FNodeType := [NodeType];
          IPv4CidrNodes.AddOrSetCIDR(NodeStr, FNodeType);
        end;
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
    Nodes := Nodeslist.Split([',']);
    for i := 0 to High(Nodes) do
    begin
      NodeStr := LowerCase(RemoveBrackets(Nodes[i], btCurly));
      if FilterDic.TryGetValue(NodeStr, FilterInfo) then
      begin
        Include(FilterInfo.Data, NodeType);
        FilterDic.AddOrSetValue(NodeStr, FilterInfo);
        Inc(Count);
      end
      else
        Nodes[i] := '';
    end;
  end;

  if (ini <> nil) and (Length(Nodes) <> Count) then
  begin
    NodeStr := '';
    case NodeType of
      ntEntry: NodeStr := 'EntryNodes';
      ntMiddle: NodeStr := 'MiddleNodes';
      ntExit: NodeStr := 'ExitNodes';
      ntExclude: NodeStr := 'ExcludeNodes';
    end;
    if NodeStr <> '' then
    begin
      sb := TStringBuilder.Create;
      try
        for i := 0 to High(Nodes) do
        begin
          if Nodes[i] <> '' then
            AppendWithDelims(sb, Nodes[i]);
        end;
        Nodeslist := sb.ToString;
        if Favorites then
          SetSettings('Routers', NodeStr, Nodeslist, ini)
        else
          SetSettings('Filter', NodeStr, Nodeslist, ini);
      finally
        sb.Free;
      end;
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

function FormatSizeToBytes(const SizeStr: string): Int64;
var
  SpacePos: Integer;
  PrefixSize: Int64;
begin
  SpacePos := Pos(' ', SizeStr);
  if not PrefixesDic.TryGetValue(Copy(SizeStr, SpacePos + 1, Pos('/', SizeStr) - SpacePos - 1), PrefixSize) then
    PrefixSize := 0;
  Result := Round(StrToFloatDef(Copy(SizeStr, 1, SpacePos - 1), 0.0) * PrefixSize);
end;

function GetHost(const Host: string): string;
begin
  if Host = '0.0.0.0' then
    Result := '127.0.0.1'
  else
  begin
    if Host = '::' then
      Result := '::1'
    else
      Result := Host;
  end;
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

function BytesToHex(const Bytes: TBytes): string;
const
  HexChars: array[0..15] of Char = '0123456789ABCDEF';
var
  i: Integer;
begin
  SetLength(Result, Length(Bytes) * 2);
  for I := 0 to High(Bytes) do
  begin
    Result[I * 2 + 1] := HexChars[Bytes[i] shr 4];
    Result[I * 2 + 2] := HexChars[Bytes[i] and $0F];
  end;
end;

function StrToHex(const Value: string): string;
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

function HexToStr(const hex: string): string;
var
  i: Integer;
begin
  for i := 1 to Length(hex) div 2 do
    Result := Result + Char(StrToInt('$' + copy(hex, (i - 1) * 2 + 1, 2)));
end;

function Crypt(const Str, Key: string): string;
var
  i, T: Integer;
  KeyLen, StrLen: Integer;
  Data: string;
begin
  if (Str = '') or (Key = '') then
    Exit('');

  StrLen := Length(Str);
  KeyLen := Length(Key);
  Data := Str;

  for i := 1 to StrLen do
  begin
    T := (Ord(Data[i]) + (Ord(Key[(i-1) mod KeyLen + 1]) - Ord('0')));
    Data[i] := Char(T);
  end;

  Result := StrToHex(Data);
end;

function Decrypt(const Str, Key: string): string;
var
  i, T: Integer;
  KeyLen, StrLen: Integer;
  Data: string;
begin
  if (Str = '') or (Key = '') then
    Exit('');

  Data := HexToStr(Str);
  StrLen := Length(Data);
  KeyLen := Length(Key);

  for i := 1 to StrLen do
  begin
    T := (Ord(Data[i]) - (Ord(Key[(i-1) mod KeyLen + 1]) - Ord('0')));
    Data[i] := Chr(T);
  end;

  Result := Data;
end;

function FileGetString(const Filename: string; Hex: Boolean = False): string;
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

function ProcessExists(var ProcessInfo: TProcessInfo; FindChild: Boolean = True; AutoTerminate: Boolean = False): Boolean;
var
  Find: LongBool;
  SnapshotHandle, ProcessHandle: THandle;
  ProcessEntry: TProcessEntry32;
  ls: TStringList;
  i: Integer;
begin
  Result := False;
  if ProcessInfo.ProcessID = 0 then
    Exit;
  ls := TStringList.Create;
  SnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  try
    ProcessEntry.dwSize := SizeOf(ProcessEntry);
    Find := Process32First(SnapshotHandle, ProcessEntry);
    while Find do
    begin
      if ProcessEntry.th32ProcessID = ProcessInfo.ProcessID then
      begin
        ls.Insert(0, IntToStr(ProcessEntry.th32ProcessID));
        Result := True;
      end
      else
      begin
        if (FindChild and (ProcessEntry.th32ParentProcessID = ProcessInfo.ProcessID)) then
        begin
          ls.Append(IntToStr(ProcessEntry.th32ProcessID));
          Result := True;
        end;
      end;
      Find := Process32Next(SnapshotHandle, ProcessEntry);
    end;
    if AutoTerminate then
    begin
      for i := ls.Count - 1 downto 0 do
      begin
        ProcessHandle := OpenProcess(PROCESS_TERMINATE, False, Cardinal(StrToInt(ls[i])));
        if ProcessHandle <> INVALID_HANDLE_VALUE then
        begin
          TerminateProcess(ProcessHandle, 0);
          CloseHandle(ProcessHandle);
        end;
      end;
      ProcessInfo := cDefaultProcessInfo;
    end;
  finally
    CloseHandle(SnapshotHandle);
    ls.Free;
  end;
end;

function ExecuteProcess(CmdLine: string; Flags: TProcessFlags = []; JobHandle: THandle = 0): TProcessInfo;
var
  hStdOutRead, hStdOutWrite: THandle;
  SA: SECURITY_ATTRIBUTES;
  SI: STARTUPINFO;
  PI: PROCESS_INFORMATION;
  CreationFlags: Cardinal;
  ErrorMode: DWORD;

begin
  Result := cDefaultProcessInfo;
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
  ErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  SetErrorMode(ErrorMode or SEM_FAILCRITICALERRORS);
  if CreateProcess(nil, PWideChar(CmdLine), nil, nil, True, CreationFlags, nil, nil, SI, PI) then
  begin
    if JobHandle <> 0 then
      AssignProcessToJobObject(JobHandle, PI.hProcess);
    if pfReadStdOut in Flags then
      Result.hStdOutput := hStdOutRead;
    Result.hProcess := PI.hProcess;
    Result.ProcessID := PI.dwProcessId;
  end;
  SetErrorMode(0);
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
  Result := '16:' + StrToHex(salt) + (UpperCase(THashSHA1.GetHashString(hash)));
end;

function GetDirFromArray(const Data: array of string; const FileName: string = ''; ShowFileName: Boolean = False): string;
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

procedure SaveToLog(const str, LogFile: string);
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

function GetIntDef(Value, Default, Min, Max: Integer): Integer;
begin
  if InRange(Value, Min, Max) then
    Result := Value
  else
    Result := Default;
end;

procedure GetSettings(const Section: string; EditControl: TEdit; ini: TMemIniFile);
begin
  if FirstLoad then
    EditControl.ResetValue := EditControl.Text;
  EditControl.Text := ini.ReadString(Section, StringReplace(EditControl.Name, 'ed', '', [rfIgnoreCase]), EditControl.ResetValue);
end;

procedure SetSettings(const Section: string; EditControl: TEdit; ini: TMemIniFile); overload;
begin
  ini.WriteString(Section, StringReplace(EditControl.Name, 'ed', '', [rfIgnoreCase]), EditControl.Text);
end;

procedure GetSettings(const Section: string; ComboBoxControl: TComboBox; ini: TMemIniFile; Default: Integer = 0);
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

procedure SetSettings(const Section: string; ComboBoxControl: TComboBox; ini: TMemIniFile; SaveIndex: Boolean = True; UseFormatHost: Boolean = False);
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

procedure GetSettings(const Section: string; UpDownControl: TUpDown; ini: TMemIniFile);
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

procedure SetSettings(const Section: string; UpDownControl: TUpDown; ini: TMemIniFile); overload;
begin
  ini.WriteInteger(Section, StringReplace(UpDownControl.Name, 'ud', '', [rfIgnoreCase]), UpDownControl.Position)
end;

procedure GetSettings(UpDownControl: TUpDown; Flags: TConfigFlags = []);
begin
  if FirstLoad then
    UpDownControl.ResetValue := UpDownControl.Position;
  UpDownControl.Position := StrToInt(GetTorConfig(StringReplace(UpDownControl.Name, 'ud', '', [rfIgnoreCase]), IntToStr(UpDownControl.ResetValue), Flags, ptInteger, UpDownControl.Min, UpDownControl.Max));
end;

procedure GetSettings(const Section: string; CheckBoxControl: TCheckBox; ini: TMemIniFile);
begin
  if FirstLoad then
    CheckBoxControl.ResetValue := CheckBoxControl.Checked;
  CheckBoxControl.Checked := ini.ReadBool(Section, StringReplace(CheckBoxControl.Name, 'cb', '', [rfIgnoreCase]), CheckBoxControl.ResetValue)
end;

procedure SetSettings(const Section: string; CheckBoxControl: TCheckBox; ini: TMemIniFile);
begin
  ini.WriteBool(Section, StringReplace(CheckBoxControl.Name, 'cb', '', [rfIgnoreCase]), CheckBoxControl.Checked);
end;

procedure SetSettings(const Section: string; SpeedButtonControl: TSpeedButton; ini: TMemIniFile);
begin
  ini.WriteBool(Section, StringReplace(SpeedButtonControl.Name, 'sb', '', [rfIgnoreCase]), SpeedButtonControl.Down);
end;

procedure GetSettings(CheckBoxControl: TCheckBox; Flags: TConfigFlags = []);
begin
  if FirstLoad then
    CheckBoxControl.ResetValue := CheckBoxControl.Checked;
  CheckBoxControl.Checked := StrToBool(GetTorConfig(StringReplace(CheckBoxControl.Name, 'cb', '', [rfIgnoreCase]), BoolToStrDef(CheckBoxControl.ResetValue), Flags, ptBoolean));
end;

procedure GetSettings(SpeedButtonControl: TSpeedButton; Flags: TConfigFlags = []); overload;
begin
  if FirstLoad then
    SpeedButtonControl.ResetValue := SpeedButtonControl.Down;
  SpeedButtonControl.Down := StrToBool(GetTorConfig(StringReplace(SpeedButtonControl.Name, 'sb', '', [rfIgnoreCase]), BoolToStrDef(SpeedButtonControl.ResetValue), Flags, ptBoolean));
end;

procedure GetSettings(const Section: string; SpeedButtonControl: TSpeedButton; ini: TMemIniFile);
begin
  if FirstLoad then
    SpeedButtonControl.ResetValue := SpeedButtonControl.Down;
  SpeedButtonControl.Down := ini.ReadBool(Section, StringReplace(SpeedButtonControl.Name, 'sb', '', [rfIgnoreCase]), SpeedButtonControl.ResetValue)
end;

procedure GetSettings(const Section: string; MenuControl: TMenuItem; ini: TMemIniFile; Default: Boolean = True);
begin
  MenuControl.Checked := ini.ReadBool(Section, StringReplace(MenuControl.Name, 'mi', '', [rfIgnoreCase]), Default)
end;

procedure SetSettings(const Section: string; MenuControl: TMenuItem; ini: TMemIniFile);
begin
  ini.WriteBool(Section, StringReplace(MenuControl.Name, 'cb', '', [rfIgnoreCase]), MenuControl.Checked);
end;

procedure GetSettings(MenuControl: TMenuItem; Flags: TConfigFlags = []; Default: Boolean = True);
begin
  MenuControl.Checked := StrToBool(GetTorConfig(StringReplace(MenuControl.Name, 'mi', '', [rfIgnoreCase]), BoolToStrDef(Default), Flags, ptBoolean));
end;

procedure SetSettings(const Section, Ident, Value: string; ini: TMemIniFile);
begin
  ini.WriteString(Section, Ident, Value)
end;

procedure SetSettings(const Section, Ident: string; Value: Integer; ini: TMemIniFile);
begin
  ini.WriteInteger(Section, Ident, Value)
end;

procedure SetSettings(const Section, Ident: string; Value: Int64; ini: TMemIniFile);
begin
  ini.WriteInt64(Section, Ident, Value)
end;

procedure SetSettings(const Section, Ident: string; Value: Boolean; ini: TMemIniFile);
begin
  ini.WriteBool(Section, Ident, Value)
end;

procedure DeleteSettings(const Section, Ident: string; ini: TMemIniFile);
begin
  ini.DeleteKey(Section, Ident)
end;

function GetSettings(const Section, Ident, Default: string; ini: TMemIniFile): string;
begin
  Result := ini.ReadString(Section, Ident, Default)
end;

function GetSettings(const Section, Ident: string; Default: Integer; ini: TMemIniFile): Integer;
begin
  Result := ini.ReadInteger(Section, Ident, Default)
end;

function GetSettings(const Section, Ident: string; Default: Int64; ini: TMemIniFile): Int64;
begin
  Result := ini.ReadInt64(Section, Ident, Default)
end;

function GetSettings(const Section, Ident: string; Default: Boolean; ini: TMemIniFile): Boolean;
begin
  Result := ini.ReadBool(Section, Ident, Default)
end;

procedure AddOptionToIndex(var Config: TConfigFile; const OptionName: string; LineIndex: Integer; IsComment: Boolean);
var
  Data: TArray<TIndexData>;
  Element: TIndexData;
begin
  Element.Index := LineIndex;
  Element.IsComment := IsComment;
  if Config.Idx.TryGetValue(OptionName, Data) then
  begin
    TArrayHelper.AddToArray<TIndexData>(Data, Element);
    Config.Idx.AddOrSetValue(OptionName, Data);
  end
  else
  begin
    TArrayHelper.AddToArray<TIndexData>(Data, Element);
    Config.Idx.Add(OptionName, Data);
  end;
end;

procedure LoadConfig(var Config: TConfigFile; Flags: TConfigFlags = []);
var
  i: Integer;
  OptionName: string;
  IsComment: Boolean;
begin
  if Assigned(Config.Data) then
    Exit
  else
  begin
    Config.Data := TStringList.Create;
    Config.Idx := TDictionary<string, TArray<TIndexData>>.Create;
    if FileExists(Config.FileName) then
    begin
      Config.Data.LoadFromFile(Config.FileName, Config.Encoding);
      for i := 0 to Config.Data.Count - 1 do
      begin
        OptionName := LowerCase(GetOptionName(Config.Data[i], IsComment, True));
        if OptionName <> '' then
          AddOptionToIndex(Config, OptionName, i, IsComment);
      end;
    end;
  end;
end;

procedure LoadTorConfig;
begin
  LoadConfig(tc);
end;

procedure SaveConfig(var Config: TConfigFile; Flags: TConfigFlags = []);
var
  i: Integer;
  DeleteBlankLines: Boolean;
begin
  LoadConfig(Config);
  DeleteBlankLines := cfDeleteBlankLines in Flags;

  for i := Config.Data.Count - 1 downto 0 do
    if (Config.Data[i] = #0) or ((Config.Data[i] = '') and (i <> 1) and DeleteBlankLines) then
      Config.Data.Delete(i);

  Config.Data.SaveToFile(Config.FileName, Config.Encoding);
  FreeAndNil(Config.Data);
  FreeAndNil(Config.Idx);
end;

procedure SaveTorConfig;
begin
  SaveConfig(tc, [cfDeleteBlankLines]);
  TorrcFileID := GetFileID(tc.FileName, True).Data;
end;

function GetOptionName(const Line: string; out IsComment: Boolean; FindComments: Boolean = False): string;
var
  P, PEnd, NameStart, NameEnd: PChar;
  HadCommentMark: Boolean;
begin
  Result := '';
  IsComment := False;
  if Line = '' then Exit;

  P := PChar(Line);
  PEnd := P + Length(Line);
  HadCommentMark := False;

  while (P < PEnd) and (P^ = ' ') do
    Inc(P);

  if P >= PEnd then Exit;

  if P^ = '#' then
  begin
    HadCommentMark := True;
    if not FindComments then
    begin
      IsComment := True;
      Exit;
    end;
  end;

  if FindComments then
    while (P < PEnd) and (P^ = '#') do
      Inc(P);

  while (P < PEnd) and (P^ = ' ') do
    Inc(P);

  NameStart := P;
  while (NameStart < PEnd) and (NameStart^ = ' ') do
    Inc(NameStart);

  NameEnd := NameStart;
  while (NameEnd < PEnd) and (NameEnd^ <> ' ') and (NameEnd^ <> #9) do
    Inc(NameEnd);

  if NameEnd > NameStart then
  begin
    SetString(Result, NameStart, NameEnd - NameStart);
    IsComment := HadCommentMark and FindComments;
  end
  else
  begin
    IsComment := HadCommentMark;
  end;
end;

function TryGetOption(const Line, OptionName: string; out Value: string; FindComments: Boolean = False; FindOnly: Boolean = False): Boolean;
var
  P, PEnd, ValueStart, ValueEnd: PChar;
  OptionLen: Integer;
  InCommentSection: Boolean;
begin
  Result := False;
  Value := '';
  if (Line = '') or (OptionName = '') then Exit;

  OptionLen := Length(OptionName);
  P := PChar(Line);
  PEnd := P + Length(Line);
  InCommentSection := False;

  while (P < PEnd) and (P^ = ' ') do
    Inc(P);

  if not FindComments then
  begin
    while (P < PEnd) and (P^ = '#') do
    begin
      InCommentSection := True;
      Inc(P);
      if (P < PEnd) and (P^ <> ' ') then
        Exit;
    end;
    if InCommentSection then Exit;
  end
  else
  begin
    while (P < PEnd) and (P^ = '#') do
      Inc(P);
  end;

  while (P < PEnd) and (P^ = ' ') do
    Inc(P);

  if (PEnd - P) < OptionLen + 1 then Exit;

  if not (CompareText(OptionName, Copy(Line, P - PChar(Line) + 1, OptionLen)) = 0) then
    Exit;

  if (P + OptionLen)^ <> ' ' then
    Exit;

  if FindOnly then
    Exit(True);

  ValueStart := P + OptionLen + 1;
  while (ValueStart < PEnd) and (ValueStart^ = ' ') do
    Inc(ValueStart);

  ValueEnd := ValueStart;
  while (ValueEnd < PEnd) and (ValueEnd^ <> '#') do
    Inc(ValueEnd);

  while (ValueEnd > ValueStart) and ((ValueEnd - 1)^ = ' ') do
    Dec(ValueEnd);

  if ValueEnd > ValueStart then
  begin
    SetString(Value, ValueStart, ValueEnd - ValueStart);
    Result := True;
  end;
end;

function GetConfig(var Config: TConfigFile; const Param, Default: string; Flags: TConfigFlags = []; ParamType: TParamType = ptString; MinValue: Integer = 0; MaxValue: Integer = 0): string;
var
  LineIndex, i: Integer;
  Search, FindComments, FindOnly: Boolean;
  IdxData: TArray<TIndexData>;
  InsensParam: string;

  procedure Reset;
  begin
    if not IdxData[i].IsComment then
    begin
      if (Default <> '') and (GetDefaultsValue(Param) <> Default) then
        Config.Data[LineIndex] := Param + ' ' + Default
      else
      begin
        Config.Data[LineIndex] := #0;
        if Length(IdxData) = 1 then
          Config.Idx.Remove(InsensParam)
        else
        begin
          IdxData[i].Index := -1;
          Config.Idx.AddOrSetValue(InsensParam, IdxData);
        end;
      end;
    end;
    Result := Default;
  end;

begin
  LoadConfig(Config);
  Search := False;
  FindComments := cfFindComments in Flags;
  FindOnly := cfExistCheck in Flags;
  InsensParam := LowerCase(Param);

  if Config.Idx.TryGetValue(InsensParam, IdxData) then
  begin
    for i := 0 to High(IdxData) do
    begin
      if IdxData[i].IsComment and not FindComments then
        Continue;
      LineIndex := IdxData[i].Index;
      if (LineIndex > -1) and (LineIndex < Config.Data.Count) then
      begin
        Search := TryGetOption(Config.Data[LineIndex], Param, Result, FindComments, FindOnly);
        if Search then
        begin
          if FindOnly then
          begin
            Result := '1';
            Break;
          end;
          case ParamType of
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
          end;
          Break;
        end;
      end;
    end;
  end;

  if not Search then
  begin
    Result := Default;
    if cfAutoAppend in Flags then
      AddOptionToIndex(Config, InsensParam, Config.Data.Add(Param + ' ' + Default), False);
  end;
  if cfAutoSave in Flags then
    SaveConfig(Config);
end;

function GetConfig(var Config: TConfigFile; const Param: string; Flags: TConfigFlags = []): TStringList;
var
  LineIndex, i: Integer;
  DataStr, InsensParam: string;
  FindComments: Boolean;
  IdxData: TArray<TIndexData>;
begin
  Result := nil;
  LoadConfig(Config);
  FindComments := cfFindComments in Flags;
  InsensParam := LowerCase(Param);

  if Config.Idx.TryGetValue(InsensParam, IdxData) then
  begin
    for i := 0 to High(IdxData) do
    begin
      if IdxData[i].IsComment and not FindComments then
        Continue;
      LineIndex := IdxData[i].Index;
      if (LineIndex > -1) and (LineIndex < Config.Data.Count) then
      begin
        if TryGetOption(Config.Data[LineIndex], Param, DataStr, FindComments) then
        begin
          if DataStr <> '' then
          begin
            if Result = nil then
              Result := TStringList.Create;
            Result.Append(DataStr);
          end;
        end;
      end;
    end;
  end;
  if cfAutoSave in Flags then
    SaveConfig(Config);
end;

function GetTorConfig(const Param, Default: string; Flags: TConfigFlags = []; ParamType: TParamType = ptString; MinValue: Integer = 0; MaxValue: Integer = 0; const Prefix: string = ''): string;
begin
  Result := GetConfig(tc, Param, Default, Flags, ParamType, MinValue, MaxValue);
end;

function GetTorConfig(const Param: string; Flags: TConfigFlags = []): TStringList;
begin
  Result := GetConfig(tc, Param, Flags);
end;

procedure AddConfig(var Config: TConfigFile; const Param: string; Values: TStringList; Flags: TConfigFlags = []);
var
  DataCount, i: Integer;
  InsensParam: string;
begin
  LoadConfig(Config);
  DataCount := Values.Count;

  if DataCount > 0 then
  begin
    InsensParam := LowerCase(Param);
    for i := 0 to DataCount - 1 do
    begin
      if Values[i] <> '' then
        AddOptionToIndex(Config, InsensParam, Config.Data.Add(Param + ' ' + Values[i]), False);
    end;
  end
  else
    DeleteConfig(Config, [Param]);
  if cfAutoSave in Flags then
    SaveConfig(Config);
end;

procedure AddConfig(var Config: TConfigFile; const Param, Value: string; Flags: TConfigFlags = []);
begin
  LoadConfig(Config);
  if Value <> '' then
    AddOptionToIndex(Config, LowerCase(Param), Config.Data.Add(Param + ' ' + Value), False);
  if cfAutoSave in Flags then
    SaveConfig(Config);
end;

procedure AddTorConfig(const Param: string; Values: TStringList; Flags: TConfigFlags = []);
begin
  AddConfig(tc, Param, Values, Flags);
end;

procedure AddTorConfig(const Param, Value: string; Flags: TConfigFlags = []);
begin
  AddConfig(tc, Param, Value, Flags);
end;

procedure SetConfig(var Config: TConfigFile; const Param, Value: string; Flags: TConfigFlags = []);
var
  LineIndex, i: Integer;
  Search, FindComments: Boolean;
  InsensParam: string;
  IdxData: TArray<TIndexData>;
begin
  LoadConfig(Config);
  Search := False;
  FindComments := cfFindComments in Flags;
  InsensParam := LowerCase(Param);

  if Config.Idx.TryGetValue(InsensParam, IdxData) then
  begin
    for i := 0 to High(IdxData) do
    begin
      if IdxData[i].IsComment and not FindComments then
        Continue;
      LineIndex := IdxData[i].Index;
      if (LineIndex > -1) and (LineIndex < Config.Data.Count) then
      begin
        Search := True;
        if (Value <> '') and (GetDefaultsValue(Param) <> Value) then
          Config.Data[LineIndex] := Param + ' ' + Value
        else
        begin
          Config.Data[LineIndex] := #0;
          if Length(IdxData) = 1 then
            Config.Idx.Remove(InsensParam)
          else
          begin
            IdxData[i].Index := -1;
            Config.Idx.AddOrSetValue(InsensParam, IdxData);
          end;
        end;
        Break;
      end;
    end;
  end;
  if not Search then
  begin
    if (Value <> '') and (GetDefaultsValue(Param) <> Value) then
      AddOptionToIndex(Config, InsensParam, Config.Data.Add(Param + ' ' + Value), False);
  end;
  if cfAutoSave in Flags then
    SaveConfig(Config);
end;

procedure SetTorConfig(const Param, Value: string; Flags: TConfigFlags = []);
begin
  SetConfig(tc, Param, Value, Flags);
end;

procedure DeleteConfig(var Config: TConfigFile; const Params: TArray<string>; Flags: TConfigFlags = []);
var
  LineIndex, i, j: Integer;
  FindComments, CommentsFound, ParamWithoutSpace: Boolean;
  InsensParam, DataStr: string;
  IdxData: TArray<TIndexData>;
begin
  LoadConfig(Config);
  FindComments := cfFindComments in Flags;
  ParamWithoutSpace := not (cfParamWithSpace in Flags);

  for i := 0 to High(Params) do
  begin
    InsensParam := LowerCase(SeparateLeft(Params[i], ' '));
    if Config.Idx.TryGetValue(InsensParam, IdxData) then
    begin
      CommentsFound := False;
      for j := 0 to High(IdxData) do
      begin
        if IdxData[j].IsComment and not FindComments then
        begin
          CommentsFound := True;
          Continue;
        end;
        LineIndex := IdxData[j].Index;
        if (LineIndex > -1) and (LineIndex < Config.Data.Count) then
        begin
          if ParamWithoutSpace or TryGetOption(Config.Data[LineIndex], Params[i], DataStr, FindComments, True) then
          begin
            Config.Data[LineIndex] := #0;
            IdxData[j].Index := -1;
          end;
        end;
      end;
      if CommentsFound then
        Config.Idx.AddOrSetValue(InsensParam, IdxData)
      else
        Config.Idx.Remove(InsensParam);
    end;
  end;

  if cfAutoSave in Flags then
    SaveConfig(Config);
end;

procedure DeleteTorConfig(const Params: TArray<string>; Flags: TConfigFlags = []);
begin
  DeleteConfig(tc, Params, Flags);
end;

procedure SetConfigBoolean(const Section, Ident: string; Value: Boolean);
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

procedure SetConfigInteger(const Section, Ident: string; Value: Int64); overload;
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

procedure SetConfigInteger(const Section, Ident: string; Value: Integer); overload;
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

procedure SetConfigString(const Section, Ident: string; Value: string);
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

procedure DeleteDuplicatesFromList(var ls: TStringList; ListType: TListType = ltNone);
var
  Duplicates: THashSet<string>;
  List: TStringList;
  SocketStr: string;
  i: Integer;

  procedure UpdateList(const Str: string);
  begin
    if not Duplicates.Contains(Str) then
    begin
      Duplicates.Add(Str);
      List.Append(ls[i]);
    end;
  end;

begin
  if ls.Count < 2 then
    Exit;
  Duplicates := THashSet<string>.Create(ls.Count);
  List := TStringList.Create;
  try
    if ListType = ltBridge then
    begin
      for i := 0 to ls.Count - 1 do
      begin
        if TryGetDataFromStr(ls[i], ltSocket, SocketStr) then
          UpdateList(SocketStr)
        else
          UpdateList(ls[i]);
      end;
    end
    else
    begin
      for i := 0 to ls.Count - 1 do
        UpdateList(ls[i]);
    end;
    ls.SetStrings(List);
  finally
    Duplicates.Free;
    List.Free;
  end;
end;

procedure SortHostsList(var ls: TStringList; SortType: Byte = SORT_ASC);
var
  i: Integer;
  IPv4Addrs, IPv6Addr, Hosts: TArray<string>;
  IPv4AddrsCount, IPv6AddrsCount, HostsCount: Integer;
begin
  if (SortType = SORT_NONE) or (ls.Count < 2)  then
    Exit;
  IPv4AddrsCount := 0;
  IPv6AddrsCount := 0;
  HostsCount := 0;
  for i := 0 to ls.Count - 1 do
  begin
    case ValidAddress(ls[i]) of
      atIPv4: TArrayHelper.AddToArray<string>(IPv4Addrs, IPv4AddrsCount, ls[i]);
      atIPv6: TArrayHelper.AddToArray<string>(IPv6Addr, IPv6AddrsCount, ls[i]);
      else
        TArrayHelper.AddToArray<string>(Hosts, HostsCount, ls[i]);
    end;
  end;
  SetLength(IPv4Addrs, IPv4AddrsCount);
  SetLength(IPv6Addr, IPv6AddrsCount);
  SetLength(Hosts, HostsCount);
  ls.Clear;
  case SortType of
    SORT_ASC:
    begin
      TArray.Sort<string>(IPv4Addrs, TComparer<string>.Construct(CompTextAsc));
      TArray.Sort<string>(IPv6Addr, TComparer<string>.Construct(CompTextAsc));
      TArray.Sort<string>(Hosts, TComparer<string>.Construct(CompTextAsc));
      ls.AddStrings(IPv4Addrs);
      ls.AddStrings(IPv6Addr);
      ls.AddStrings(Hosts);
    end;
    SORT_DESC:
    begin
      TArray.Sort<string>(IPv4Addrs, TComparer<string>.Construct(CompTextDesc));
      TArray.Sort<string>(IPv6Addr, TComparer<string>.Construct(CompTextDesc));
      TArray.Sort<string>(Hosts, TComparer<string>.Construct(CompTextDesc));
      ls.AddStrings(Hosts);
      ls.AddStrings(IPv6Addr);
      ls.AddStrings(IPv4Addrs);
    end;
  end;
end;

procedure SortNodesList(var ls: TStringList; SortType: Byte = SORT_ASC);
var
  i, HashesCount, IPv4AddrsCount, IPv4CidrsCount, CountryCodesCount: Integer;
  Hashes, IPv4Addrs, IPv4Cidrs, CountryCodes: TArray<string>;
begin
  if (SortType = SORT_NONE) or (ls.Count < 2) then
    Exit;
  HashesCount := 0;
  IPv4AddrsCount := 0;
  IPv4CidrsCount := 0;
  CountryCodesCount := 0;
  for i := 0 to ls.Count - 1 do
  begin
    case ValidNode(ls[i], False) of
      dtHash: TArrayHelper.AddToArray<string>(Hashes, HashesCount, ls[i]);
      dtIPv4: TArrayHelper.AddToArray<string>(IPv4Addrs, IPv4AddrsCount, ls[i]);
      dtIPv4Cidr: TArrayHelper.AddToArray<string>(IPv4Cidrs, IPv4CidrsCount, ls[i]);
      dtCode: TArrayHelper.AddToArray<string>(CountryCodes, CountryCodesCount, ls[i]);
    end;
  end;
  SetLength(Hashes, HashesCount);
  SetLength(IPv4Addrs, IPv4AddrsCount);
  SetLength(IPv4Cidrs, IPv4CidrsCount);
  SetLength(CountryCodes, CountryCodesCount);

  ls.Clear;
  case SortType of
    SORT_ASC:
    begin
      TArray.Sort<string>(IPv4Addrs, TComparer<string>.Construct(CompTextAsc));
      TArray.Sort<string>(IPv4Cidrs, TComparer<string>.Construct(CompTextAsc));
      TArray.Sort<string>(CountryCodes, TComparer<string>.Construct(CompAsc));
      TArray.Sort<string>(Hashes, TComparer<string>.Construct(CompAsc));
      ls.AddStrings(CountryCodes);
      ls.AddStrings(IPv4Cidrs);
      ls.AddStrings(IPv4Addrs);
      ls.AddStrings(Hashes);
    end;
    SORT_DESC:
    begin
      TArray.Sort<string>(IPv4Addrs, TComparer<string>.Construct(CompTextDesc));
      TArray.Sort<string>(IPv4Cidrs, TComparer<string>.Construct(CompTextDesc));
      TArray.Sort<string>(CountryCodes,TComparer<string>.Construct(CompDesc));
      TArray.Sort<string>(Hashes,TComparer<string>.Construct(CompDesc));
      ls.AddStrings(Hashes);
      ls.AddStrings(IPv4Addrs);
      ls.AddStrings(IPv4Cidrs);
      ls.AddStrings(CountryCodes);
    end;
  end;
end;

function ValidData(const Str: string; ListType: TListType; Validate: Boolean = True): Boolean;
begin
  case ListType of
    ltHost: Result := ValidHost(Str, True, True) <> htNone;
    ltHash: Result := ValidHash(Str);
    ltPolicy: Result := ValidPolicy(Str);
    ltBridge: Result := ValidBridge(Str);
    ltNode: Result := ValidNode(Str, Validate) <> dtNone;
    ltSocket: Result := ValidSocket(Str) <> soNone;
    ltTransport: Result := ValidTransport(Str);
    ltFallbackDir: Result := ValidFallbackDir(Str);
    else
      Result := True;
  end;
end;

procedure SortList(var ls: TStringList; ListType: TListType; SortType: Byte);
begin
  if (SortType = SORT_NONE) or (ls.Count < 2) then
    Exit;
  case ListType of
    ltHost: SortHostsList(ls, SortType);
    ltNode: SortNodesList(ls, SortType);
    ltHash:
    begin
      case SortType of
        SORT_ASC: ls.CustomSort(CompAsc);
        SORT_DESC: ls.CustomSort(CompDesc);
      end;
    end;
    else
    begin
      case SortType of
        SORT_ASC: ls.CustomSort(CompTextAsc);
        SORT_DESC: ls.CustomSort(CompTextDesc);
      end;
    end;
  end;
end;

procedure LineToMemo(const Line: string; Memo: TMemo; SortType: Byte = SORT_NONE; const Separator: string = ','; RemoveDuplicates: Boolean = True; Validate: Boolean = True);
var
  ParseStr: TArray<string>;
  ListType: TListType;
  i: Integer;
  ls: TStringList;
  Str: string;
begin
  ListType := Memo.ListType;
  if ListType = ltNode then
    ParseStr := UpperCase(Line).Split([Separator])
  else
    ParseStr := Line.Split([Separator]);
  ls := TStringList.Create;
  try
    if ListType = ltNone then
    begin
      for i := 0 to High(ParseStr) do
      begin
        Str := Trim(ParseStr[i]);
        if Str <> '' then
          ls.Append(Str);
      end;
    end
    else
    begin
      for i := 0 to High(ParseStr) do
      begin
        Str := Trim(ParseStr[i]);
        if Str <> '' then
        begin
          if ValidData(Str, ListType, Validate) then
            ls.Append(Str);
        end;
      end;
      if RemoveDuplicates then
        DeleteDuplicatesFromList(ls, ListType);
      SortList(ls, ListType, SortType);
    end;
    Memo.SetTextData(ls.Text);
  finally
    ls.Free;
  end;
end;

function MemoToLine(Memo: TMemo; SortType: Byte = SORT_NONE; const Separator: string = ','): string;
var
  ls: TStringList;
begin
  ls := TStringList.Create;
  try
    MemoToList(Memo, ls, SortType);
    Result := ListToStr(ls, Separator);
  finally
    ls.Free;
  end;
end;

procedure MemoToList(Memo: TMemo; out ls: TStringList; SortType: Byte = SORT_NONE);
var
  i: Integer;
  ListType: TListType;
  Str: string;
begin
  ListType := Memo.ListType;
  if ListType = ltNone then
    ls.Text := Memo.Text
  else
  begin
    if ListType in [ltBridge, ltFallbackDir] then
      ls.Text := Memo.Text
    else
    begin
      if ListType = ltNode then
        ls.Text := UpperCase(RemoveBrackets(StringReplace(Memo.Text, ',', BR, [rfReplaceAll]), btCurly, False))
      else
        ls.Text := StringReplace(Memo.Text, ',', BR, [rfReplaceAll]);
    end;
    for i := ls.Count - 1 downto 0 do
    begin
      Str := Trim(ls[i]);
      if Str = '' then
        ls.Delete(i)
      else
      begin
        case ListType of
          ltHost: Str := ExtractDomain(Str);
          ltHash: Str := UpperCase(Str);
          ltPolicy: Str := LowerCase(Str);
          ltBridge:
            if Str.StartsWith('Bridge ', True) then
              Str := Copy(Str, 8);
        end;
        if ValidData(Str, ListType) then
          ls[i] := Str
        else
          ls.Delete(i);
      end;
    end;
    DeleteDuplicatesFromList(ls, ListType);
    SortList(ls, ListType, SortType);
    Memo.SetTextData(ls.Text);
  end;
end;

function ListToStr(ls: TStringList; const Delimiter: string): string;
var
  i, Len, DelimLen: Integer;
  p: PChar;
begin
  if ls.Count = 0 then
    Exit('');

  DelimLen := Length(Delimiter);
  Len := 0;
  for i := 0 to ls.Count - 1 do
    Len := Len + Length(ls[i]);
  Len := Len + (ls.Count - 1) * DelimLen;

  SetLength(Result, Len);
  p := PChar(Result);

  for i := 0 to ls.Count - 1 do
  begin
    if (i > 0) and (DelimLen > 0) then
    begin
      Move(Delimiter[1], p^, DelimLen * SizeOf(Char));
      Inc(p, DelimLen);
    end;

    Len := Length(ls[i]);
    if Len > 0 then
    begin
      Move(ls[i][1], p^, Len * SizeOf(Char));
      Inc(p, Len);
    end;
  end;
end;

procedure AddUPnPEntry(Port: Integer; const Desc, LanIp: string; Test: Boolean; var Msg: string);
var
  Nat: OleVariant;
  Ports: OleVariant;
  procedure FormatMsg(const Str: string);
  begin
    Msg := Msg + LanIp + ' : ' + inttostr(Port) + ' - ' + Str + BR;
  end;
begin
  try
    Nat := CreateOleObject('HNetCfg.NATUPnP');
    Ports := Nat.StaticPortMappingCollection;
    if not VarIsClear(Ports) then
    begin
      Ports.Add(Port, 'TCP', Port, LanIp, True, Desc);
      if Test then
      begin
        FormatMsg(TransStr('245'));
        if ConnectState = 0 then
          Ports.Remove(Port, 'TCP');
      end;
    end;
  except
    on E:Exception do
    begin
      if Test then
        FormatMsg(TransStr('247'));
      Exit;
    end;
  end;
end;

procedure RemoveUPnPEntry(const PortList: array of Word);
var
  Nat: Variant;
  Ports: Variant;
  i, PortsCount, Sum: Integer;
begin
  PortsCount := Length(PortList);
  if PortsCount = 0 then
    Exit;
  Sum := 0;
  for i := 0 to PortsCount - 1 do
    Inc(Sum, PortList[i]);
  if Sum = 0 then
    Exit;
  try
    Nat := CreateOleObject('HNetCfg.NATUPnP');
    Ports := Nat.StaticPortMappingCollection;
    if not VarIsClear(Ports) then
    begin
      for i := 0 to PortsCount - 1 do
      begin
        if PortList[i] <> 0 then
          Ports.Remove(PortList[i], 'TCP');
      end;
    end;
  except
    on E:Exception do
      Exit;
    end;
end;

function IsDirectoryWritable(const Dir: string): Boolean;
var
  FileName: array[0..MAX_PATH] of Char;
begin
  if GetTempFileName(PChar(Dir), 'Tmp', 0, FileName) <> 0 then
    Result := DeleteFile(FileName)
  else
    Result := False;
end;

function GetFullFileName(const FileName: string): string;
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

function RegistryFileExists(Root: HKEY; const Key, Param: string): Boolean;
begin
  Result := FileExists(GetCommandLineFileName(RegistryGetValue(Root, Key, Param)));
end;

function RegistryGetValue(Root: HKEY; const Key, Param: string): string;
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

function TryGetDataFromStr(const Str: string; DataType: TListType; out DatatStr: string; const Separator: string = ''): Boolean;
var
  i: Integer;
  ParseStr: TArray<string>;
  Data: string;
begin
  if Str <> '' then
  begin
    ParseStr := Str.Split([' ']);
    for i := 0 to High(ParseStr) do
    begin
      if Separator = '' then
        Data := ParseStr[i]
      else
        Data := SeparateRight(ParseStr[i], Separator);
      if ValidData(Data, DataType) then
      begin
        Result := True;
        DatatStr := Data;
        Exit;
      end;
    end;
  end;
  Result := False;
  DatatStr := '';
end;

function PortTCPIsOpen(Port: Word; const IpStr: string; Timeout: Integer): Boolean;
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
      ls.LoadFromFile(Bridgeline);
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

function GetMsgCaption(const Caption: string; MsgType: TMsgType): string;
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

function ShowMsg(const Msg: string; Caption: string = ''; MsgType: TMsgType = mtInfo; Question: Boolean = False): Boolean;
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

procedure CheckFileEncoding(const FileName, BackupFile: string);
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

procedure Flush(const FileName: string);
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

function CompareNaturalText(const S1, S2: string; CaseSensitive: Boolean = False): Integer;
var
  P1, P2: PChar;
  Num1, Num2: Integer;
  IsDigit1, IsDigit2: Boolean;
begin
  P1 := PChar(S1);
  P2 := PChar(S2);

  while True do
  begin
    if P1^ = #0 then
      Exit(IfThen(P2^ = #0, 0, -1));
    if P2^ = #0 then
      Exit(1);

    IsDigit1 := (P1^ >= '0') and (P1^ <= '9');
    IsDigit2 := (P2^ >= '0') and (P2^ <= '9');

    if IsDigit1 and IsDigit2 then
    begin
      Num1 := 0;
      Num2 := 0;

      while (P1^ >= '0') and (P1^ <= '9') do
      begin
        if Num1 > (MaxInt - 10) div 10 then Break;
        Num1 := Num1 * 10 + (Ord(P1^) - Ord('0'));
        Inc(P1);
      end;

      while (P2^ >= '0') and (P2^ <= '9') do
      begin
        if Num2 > (MaxInt - 10) div 10 then Break;
        Num2 := Num2 * 10 + (Ord(P2^) - Ord('0'));
        Inc(P2);
      end;

      if Num1 < Num2 then Exit(-1);
      if Num1 > Num2 then Exit(1);
    end
    else
    begin
      if CaseSensitive then
      begin
        if P1^ < P2^ then Exit(-1);
        if P1^ > P2^ then Exit(1);
      end
      else
      begin
        if (P1^ <> P2^) and ((Ord(P1^) or $20) <> (Ord(P2^) or $20)) then
        begin
          if (Ord(P1^) or $20) < (Ord(P2^) or $20) then Exit(-1) else Exit(1);
        end;
      end;
      Inc(P1);
      Inc(P2);
    end;
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

function CompAsc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
begin
  Result := CompareStr(aSl[aIndex1], aSl[aIndex2]);
end;

function CompDesc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
begin
  Result := CompareStr(aSl[aIndex2], aSl[aIndex1]);
end;

function CompAsc(const A, B: string) : Integer;
begin
  Result := CompareStr(A, B);
end;

function CompDesc(const A, B: string) : Integer;
begin
  Result := CompareStr(B, A);
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
  Result := CompareNaturalText(aSl[aIndex1], aSl[aIndex2]);
end;

function CompTextDesc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
begin
  Result := CompareNaturalText(aSl[aIndex2], aSl[aIndex1]);
end;

function CompTextAsc(const A, B: string) : Integer;
begin
  Result := CompareNaturalText(A, B);
end;

function CompTextDesc(const A, B: string) : Integer;
begin
  Result := CompareNaturalText(B, A);
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

function CompFlagsAsc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
begin
  Result := CompareValue(StrToIntDef(SeparateLeft(aSl[aIndex1], '|'), 0), StrToIntDef(SeparateLeft(aSl[aIndex2], '|'), 0));
end;

function CompFlagsDesc(aSl: TStringList; aIndex1, aIndex2: Integer) : Integer;
begin
  Result := CompareValue(StrToIntDef(SeparateLeft(aSl[aIndex2], '|'), 0), StrToIntDef(SeparateLeft(aSl[aIndex1],'|'), 0));
end;

procedure SgSort(aSg: TStringGrid; aCol: Integer; aCompare: TStringListSortCompare);
var
  SlSort: TStringList;
  RowData: array of TStringList;
  SortKeys: array of string;
  i, j, RowStart, RowEnd, RowCount: Integer;
begin
  RowStart := aSg.FixedRows;
  RowEnd := aSg.RowCount - 1;
  RowCount := RowEnd - RowStart + 1;

  SetLength(RowData, RowCount);
  SetLength(SortKeys, RowCount);

  for i := 0 to RowCount - 1 do
  begin
    RowData[i] := TStringList.Create;
    RowData[i].Assign(aSg.Rows[i + RowStart]);
    SortKeys[i] := aSg.Cells[aCol, i + RowStart];
  end;

  SlSort := TStringList.Create;
  try
    SlSort.Capacity := RowCount;
    SlSort.Duplicates := dupAccept;

    for i := 0 to RowCount - 1 do
      SlSort.AddObject(SortKeys[i], TObject(i));

    SlSort.CustomSort(aCompare);
    for i := 0 to RowCount - 1 do
    begin
      j := Integer(SlSort.Objects[i]);
      aSg.Rows[i + RowStart].Assign(RowData[j]);
    end;
  finally
    SlSort.Free;
    for i := 0 to RowCount - 1 do
      RowData[i].Free;
  end;
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

procedure LoadThemesList(ThemesList: TComboBox; const LastStyle: string);
var
  Search: TSearchRec;
  ls: TStringList;
  Index: Integer;
  Style: string;
begin
  if LastStyle = 'Windows' then
    Style := TransStr('104')
  else
    if LastStyle = '' then
      Style := ThemesList.Text
    else
      Style := LastStyle;
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
    Index := ThemesList.Items.IndexOf(Style);
    if Index = -1 then
      ThemesList.ItemIndex := 0
    else
      ThemesList.ItemIndex := Index;
  finally
    ls.Free;
  end;
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
  for i := High(TStyleManager.StyleNames) downto 0 do
  begin
    StyleName := TStyleManager.StyleNames[i];
    if (StyleName <> 'Windows') and (StyleName <> TStyleManager.ActiveStyle.Name) then
      TStyleManager.RemoveStyle(StyleName);
  end;
end;

procedure GetLocalInterfaces(ComboBox: TComboBox; const RecentHost: string = '');
var
  i, Index: Integer;
  ls: TStringList;
  TcpSock: TTCPBlockSocket;
  FindIPv6, ShowIPv6, ShowMask: Boolean;
  Host: string;

  procedure AddToList(const Str: string);
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
    Host := Combobox.Text
  else
    Host := RemoveBrackets(RecentHost, btSquare);
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
    ComboBox.ItemIndex := ComboBox.Items.IndexOf(Host);
    if ComboBox.ItemIndex = -1 then
      ComboBox.ItemIndex := 0;
  finally
    ls.Free;
  end;
end;

function ExtractDomain(const Url: string; HasPort: Boolean = False): string;
var
  Search: Integer;
begin
  Result := LowerCase(Url);
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
    Result := RemoveBrackets(Result, btSquare);
  end;
  Search := Pos('.$', Result);
  if Search > 0 then
    SetLength(Result, Pred(Search));
end;

function GetAddressFromSocket(const SocketStr: string; UseFormatHost: Boolean = False): string;
var
  Search: Integer;
begin
  Search := RPos(':', SocketStr);
  if Search > 0 then
  begin
    if UseFormatHost then
      Result := Copy(SocketStr, 1, Search - 1)
    else
      Result := RemoveBrackets(Copy(SocketStr, 1, Search - 1), btSquare)
  end
  else
    Result := SocketStr;
end;

function GetPortFromSocket(const SocketStr: string): Word;
begin
  Result := StrToIntDef(Copy(SocketStr, RPos(':', SocketStr) + 1), 0);
end;

function FormatHost(const HostStr: string; Validate: Boolean = True): string;
begin
  if HostStr = '' then
    Exit('');
  if Validate then
  begin
    if IsIPv6(HostStr) then
      Result := '[' + HostStr + ']'
    else
      Result := HostStr;
  end
  else
  begin
    if HasBrackets(HostStr, btSquare) then
      Result := HostStr
    else
      Result := '[' + HostStr + ']'
  end;
end;

function GetRouterBySocket(const SocketStr: string): string;
var
  RoutersItem: TPair<string, TRouterInfo>;
  BridgesItem: TPair<string, TBridgeInfo>;
  SocketType: TSocketType;
  IpStr: string;
  Port: Word;

  function FindData(const RouterInfo: TRouterInfo): Boolean;
  begin
    case SocketType of
      soIPv4: Result := (RouterInfo.IPv4 = IpStr) and (RouterInfo.Port = Port);
      soIPv6: Result := (RouterInfo.IPv6 = IpStr) and (RouterInfo.Port = Port);
      else
        Result := False;
    end;
  end;

begin
  Result := '';
  SocketType := ValidSocket(SocketStr);
  if SocketType <> soNone then
  begin
    Port := GetPortFromSocket(SocketStr);
    IpStr := GetAddressFromSocket(SocketStr);
    for BridgesItem in BridgesDic do
    begin
      if FindData(BridgesItem.Value.Router) then
      begin
        Result := BridgesItem.Key;
        Exit;
      end;
    end;
    for RoutersItem in RoutersDic do
    begin
      if FindData(RoutersItem.Value) then
      begin
        Result := RoutersItem.Key;
        Exit;
      end;
    end;
  end;
end;

function ValidInt(const IntStr: string; Min, Max: Integer; out n: Integer): Boolean; overload;
begin
  if TryStrToInt(IntStr, n) then
  begin
    if (n >= Min) and (n <= Max) then
      Exit(True);
  end;
  Result := False;
end;

function ValidInt(const IntStr: string; Min, Max: Integer): Boolean; overload;
var
  n: Integer;
begin
  if TryStrToInt(IntStr, n) then
  begin
    if (n >= Min) and (n <= Max) then
      Exit(True);
  end;
  Result := False;
end;

function ValidInt(const IntStr: string; Min, Max: Int64): Boolean; overload;
var
  n: Int64;
begin
  if TryStrToInt64(IntStr, n) then
  begin
    if (n >= Min) and (n <= Max) then
      Exit(True);
  end;
  Result := False;
end;

function ValidFloat(const FloatStr: string; Min, Max: Double): Boolean;
var
  n: Double;
begin
  if Pos(',', FloatStr) = 0 then
  begin
    if TryStrToFloat(StringReplace(FloatStr, '.', FormatSettings.DecimalSeparator, []), n) then
    begin
      if (n >= Min) and (n <= Max) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;
  Result := False;
end;

function ValidHash(const HashStr: string; HashLength: Integer): Boolean;
var
  i: Integer;
begin
  for i := 1 to HashLength do
  begin
    case HashStr[i] of
      '0'..'9', 'A'..'F': ;
    else
      Exit(False);
    end;
  end;
  Result := True;
end;

function ValidHash(const HashStr: string): Boolean;
var
  i, HashLength: Integer;
begin
  HashLength := Length(HashStr);
  if HashLength <> 40 then
    Exit(False);
  for i := 1 to HashLength do
  begin
    case HashStr[i] of
      '0'..'9', 'A'..'F': ;
    else
      Exit(False);
    end;
  end;
  Result := True;
end;

function GetAddressType(const IpStr: string; UseCidr: Boolean = False): TAddressType;
begin
  if Pos(':', IpStr) = 0 then
  begin
    if UseCidr then
      Result := atIPv4Cidr
    else
      Result := atIPv4;
  end
  else
  begin
    if UseCidr then
      Result := atIPv6Cidr
    else
      Result := atIPv6;
  end;
end;

function IpInReservedRanges(const IpStr: string; RangeType: TIPRangeType): Boolean;
var
  Value: TValueSet;
begin
  Result := False;
  case GetAddressType(IpStr, True) of
    atIPv4Cidr: Result := IPv4ReservedRanges.FindBestMatchIP(IpStr, Value);
    atIPv6Cidr: Result := IPv6ReservedRanges.FindBestMatchIP(IpStr, Value);
  end;
  if Result then
  begin
    if RangeType = rtNone then
      Exit(True);
    Exit(RangeType in TIPRangeTypes(Value));
  end;
end;

function IsIPv4(const IpStr: string): Boolean;
var
  P: PChar;
  i, Octet, DigitCount: Integer;
begin
  P := PChar(IpStr);
  i := 0;

  while i < 4 do
  begin
    DigitCount := 0;
    Octet := 0;

    while (P^ >= '0') and (P^ <= '9') do
    begin
      Octet := Octet * 10 + (Ord(P^) - Ord('0'));
      Inc(P);
      Inc(DigitCount);
      if DigitCount > 3 then Exit(False);
    end;

    if (DigitCount = 0) or (DigitCount > 1) and (P[-DigitCount] = '0') or (Octet > 255) then
      Exit(False);

    if i < 3 then
    begin
      if P^ <> '.' then Exit(False);
      Inc(P);
    end;

    Inc(i);
  end;

  Result := P^ = #0;
end;

function IsIPv6(const IpStr: string): Boolean;
var
  P: PChar;
  WordCount, ColonCount, WordValue, i: Integer;
  HasDoubleColon: Boolean;
  Ch: Char;
  ConsecutiveColons: Integer;
begin
  P := PChar(IpStr);
  WordCount := 0;
  ColonCount := 0;
  HasDoubleColon := False;
  ConsecutiveColons := 0;

  if (IpStr = '::') then Exit(True);

  while P^ <> #0 do
  begin
    if P^ = ':' then
    begin
      Inc(ConsecutiveColons);
      if ConsecutiveColons > 2 then Exit(False);
    end
    else
      ConsecutiveColons := 0;

    WordValue := 0;
    i := 0;
    while True do
    begin
      Ch := P^;
      case Ch of
        '0'..'9': WordValue := (WordValue shl 4) or (Ord(Ch) - Ord('0'));
        'A'..'F': WordValue := (WordValue shl 4) or (Ord(Ch) - Ord('A') + 10);
        'a'..'f': WordValue := (WordValue shl 4) or (Ord(Ch) - Ord('a') + 10);
        ':': Break;
        #0: Break;
      else
        Exit(False);
      end;

      Inc(i);
      Inc(P);
      if i > 4 then Exit(False);
    end;

    if i > 0 then
    begin
      if WordValue > $FFFF then Exit(False);
      Inc(WordCount);
    end;

    if P^ = ':' then
    begin
      Inc(P);
      Inc(ColonCount);
      if P^ = ':' then
      begin
        if HasDoubleColon then Exit(False);
        HasDoubleColon := True;
        Inc(P);
        Inc(ColonCount);
        ConsecutiveColons := 2;
      end;
    end;
  end;

  if HasDoubleColon then
  begin
    if (WordCount > 7) then Exit(False);
  end
  else
  begin
    if (WordCount <> 8) or (ColonCount <> 7) then Exit(False);
  end;

  if (ColonCount > 8) or
     (not HasDoubleColon and (ColonCount <> 7)) then
    Exit(False);

  Result := True;
end;

function ValidAddress(const AddrStr: string; AllowCidr: Boolean = False; ReqBrackets: Boolean = False): TAddressType;
var
  Search: Integer;
  Mask: Byte;
  IpStr: string;
begin
  Result := atNone;
  Search := Pos('/', AddrStr);
  if Search = 0 then
  begin
    if IsIPv4(AddrStr) then
      Result := atIPv4
    else
    begin
      if ReqBrackets then
      begin
        if not HasBrackets(AddrStr, btSquare) then
          Exit;
        if IsIPv6(Copy(AddrStr, 2, Length(AddrStr) - 2)) then
          Result := atIPv6;
      end
      else
        if IsIPv6(AddrStr) then
          Result := atIPv6;
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
          if not HasBrackets(IpStr, btSquare) then
            Exit;
          IpStr := Copy(IpStr, 2, Length(IpStr) - 2);
        end;
        if IsIPv6(IpStr) then
          Mask := 128
        else
          Exit;
      end;
      if ValidInt(Copy(AddrStr, Search + 1), 0, Mask) then
      begin
        case Mask of
          32: Result := atIPv4Cidr;
         128: Result := atIPv6Cidr;
        end;
      end;
    end;
  end;
end;

function ValidHost(const HostStr: string; AllowRootDomain: Boolean = False; AllowIp: Boolean = True; ReqBrackets: Boolean = False; DenySpecialDomains: Boolean = True): THostType;
var
  i, j, SubLen, Count: Integer;
  AddressType: TAddressType;
  SubDomains: TArray<string>;
begin
  Result := htNone;
  if AllowRootDomain and (HostStr = '.') then
    Exit(htRoot);
  AddressType := ValidAddress(HostStr, False, ReqBrackets);
  if AddressType <> atNone then
  begin
    if AllowIp then
    begin
      case AddressType of
        atIPv4: Result := htIPv4;
        atIPv6: Result := htIPv6;
      end;
      Exit;
    end
    else
      Exit;
  end;
  if Length(HostStr) > 255 then
    Exit;
  SubDomains := HostStr.Split(['.']);
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
  if DenySpecialDomains then
  begin
    if SubDomains[Count - 1] = 'exit' then
      Exit;
    if SubDomains[Count - 1] = 'onion' then
      Exit;
  end;
  if HostStr[1] = '.' then
    Result := htRoot
  else
    Result := htDomain;
end;

function ValidSocket(const SocketStr: string; AllowHostNames: Boolean = False): TSocketType;
var
  Search: Integer;
begin
  Result := soNone;
  Search := RPos(':', SocketStr);
  if Search = 0 then
    Exit;
  if AllowHostNames then
  begin
    if ValidHost(Copy(SocketStr, 1, Search - 1), False, True, True) <> htNone then
      Result := soHost;
  end
  else
  begin
    case ValidAddress(Copy(SocketStr, 1, Search - 1), False, True) of
      atIPv4: Result := soIPv4;
      atIPv6: Result := soIPv6;
    end;
  end;
  if Result <> soNone then
  begin
    if not ValidInt(Copy(SocketStr, Search + 1), 1, 65535) then
      Result := soNone;
  end;
end;

function TryParseFallbackDir(const FallbackStr: string; out FallbackDir: TFallbackDir; Validate: Boolean = True; UseFormatHost: Boolean = False): Boolean;
var
  ParseStr: TArray<string>;
  Search, i: Integer;
  Key, Data: string;
  FindOrPort, FindHash, FindIPv4, FindIPv6, FindWeight: Boolean;
begin
  FallbackDir.Hash := '';
  FallbackDir.IPv4 := '';
  FallbackDir.IPv6 := '';
  FallbackDir.OrPort := 0;
  FallbackDir.DirPort := 0;
  FallbackDir.Weight := 1.0;
  if Validate then
    Result := ValidFallbackDir(FallbackStr)
  else
    Result := FallbackStr <> '';
  if Result then
  begin
    FindHash := True;
    FindOrPort := True;
    FindIPv4 := True;
    FindIPv6 := True;
    FindWeight := True;
    ParseStr := FallbackStr.Split([' ']);
    for i := 0 to High(ParseStr) do
    begin
      Search := Pos('=', ParseStr[i]);
      if Search > 0 then
      begin
        Key := Copy(ParseStr[i], 1, Search - 1);
        Data := Copy(ParseStr[i], Search + 1);
        if FindOrPort and (Key = 'orport') then
        begin
          FallbackDir.OrPort := StrToIntDef(Data, 0);
          FindOrPort := False;
        end
        else
        begin
          if FindHash and (Key = 'id') then
          begin
            FallbackDir.Hash := Data;
            FindHash := False;
          end
          else
          begin
            if FindIPv6 and (Key = 'ipv6') then
            begin
              FallbackDir.IPv6 := GetAddressFromSocket(Data, UseFormatHost);
              FindIPv6 := False;
            end
            else
            begin
              if FindWeight and (Key = 'weight') then
              begin
                FallbackDir.Weight := StrToFloatDef(StringReplace(Data, '.', FormatSettings.DecimalSeparator, []), 1.0);
                FindWeight := False;
              end
            end;
          end;
        end;
      end
      else
      begin
        if FindIPv4 then
        begin
          Data := ParseStr[i];
          FallbackDir.IPv4 := GetAddressFromSocket(Data);
          FallbackDir.DirPort := GetPortFromSocket(Data);
          FindIPv4 := False;
        end;
      end;
    end;
  end;
end;

function ValidFallbackDir(const FallbackStr: string): Boolean;
var
  i, DataLength, Search: Integer;
  ParseStr: TArray<string>;
  Key, Data: string;
  FindIPv4, FindIPv6, FindPort, FindHash, FindWeight: Boolean;
begin
  Result := False;
  ParseStr := FallbackStr.Split([' ']);
  DataLength := Length(ParseStr);
  if DataLength < 3 then
    Exit;
  FindIPv4 := True;
  FindPort := True;
  FindHash := True;
  FindIPv6 := True;
  FindWeight := True;
  for i := 0 to DataLength - 1 do
  begin
    Search := Pos('=', ParseStr[i]);
    if Search > 0 then
    begin
      Key := Copy(ParseStr[i], 1, Search - 1);
      Data := Copy(ParseStr[i], Search + 1);
      if FindPort and (Key = 'orport') then
      begin
        if not ValidInt(Data, 1, 65535) then
          Exit;
        FindPort := False;
      end
      else
      begin
        if FindHash and (Key = 'id') then
        begin
          if not ValidHash(Data) then
            Exit;
          FindHash := False;
        end
        else
        begin
          if FindIPv6 and (Key = 'ipv6') then
          begin
            if ValidSocket(Data) <> soIPv6 then
              Exit;
            FindIPv6 := False;
          end
          else
          begin
            if FindWeight and (Key = 'weight') then
            begin
              if not ValidFloat(Data, 0, Double.MaxValue) then
                Exit;
              FindWeight := False;
            end
            else
              Exit;
          end;
        end;
      end;
    end
    else
    begin
      if FindIPv4 then
      begin
        Data := ParseStr[i];
        if not IsIPv4(Data) then
        begin
          if ValidSocket(Data) <> soIPv4 then
            Exit;
        end;
        FindIPv4 := False;
      end
      else
        Exit;
    end;
  end;
  Result := not (FindIPv4 or FindPort or FindHash)
end;

function ValidPolicy(const PolicyStr: string): Boolean;
var
  ParseStr, Ports: TArray<string>;
  Search, i: Integer;
  Address, Port: string;
  PolicyType, MaskType: Integer;
begin
  Result := False;
  ParseStr := PolicyStr.Split([' ']);
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
      Ports := Port.Split(['-']);
      if Length(Ports) > 2 then
        Exit;
      for i := 0 to High(Ports) do
        if not ValidInt(Ports[i], 1, 65535) then
          Exit;
    end;
    Address := Copy(ParseStr[1], 1, Search - 1);
    MaskType := GetArrayIndex(MaskTypes, Address);
    case MaskType of
      -1:
      begin
        case ValidAddress(Address, True, True) of
          atNone: Exit;
          atIPv4: if PolicyType > 1 then Exit;
        end;
      end;
      1, 3: if PolicyType > 1 then Exit;
    end;
  end;
  Result := True;
end;

function ValidKeyValue(const Str: string): Boolean;
var
  Search, DL: Integer;
begin
  Result := False;
  DL := Length(Str); 
  if DL < 3 then
    Exit;
  Search := Pos('=', Str);
  if Search = 0 then
    Exit;
  if (Str[1] = '=') or (Str[DL] = '=') then
    Exit;
  Result := True;  
end;

function TryParseTarget(const TargetStr: string; out Target: TTarget): Boolean;
var
  PortIndex, ExitIndex, TargetLength: Integer;
begin
  Target.TargetType := ttNone;
  Target.Hash := '';
  Target.Hostname := '';
  Target.Port := '0';

  PortIndex := RPos(':', TargetStr);
  Result := PortIndex <> 0;
  if Result then
  begin
    Target.Port := Copy(TargetStr, PortIndex + 1);
    ExitIndex := RPos('.exit:', TargetStr);
    if ExitIndex <> 0 then
    begin
      Target.TargetType := ttExit;
      Target.Hash := Copy(TargetStr, ExitIndex - 40, 40);
      if Pos('.$', TargetStr) = 0 then
        Target.Hostname := Copy(TargetStr, 1, ExitIndex - 42)
      else
        Target.Hostname := Copy(TargetStr, 1, ExitIndex - 43);
    end
    else
    begin
      TargetLength := Length(TargetStr);
      Target.Hostname := Copy(TargetStr, 1, TargetLength - (TargetLength - PortIndex + 1));
      if RPos('.onion:', TargetStr) <> 0 then
        Target.TargetType := ttOnion
      else
        Target.TargetType := ttNormal;
    end;
  end;
end;

function TryParseBridge(const BridgeStr: string; out Bridge: TBridge; Validate: Boolean = True; UseFormatHost: Boolean = False): Boolean;
var
  ParseStr: TArray<string>;
  ParamsState: Byte;
  SocketType: TSocketType;
  ParamsStr: string;
  i: Integer;
begin
  Bridge.Ip := '';
  Bridge.Port := 0;
  Bridge.Hash := '';
  Bridge.Transport := '';
  Bridge.Params := '';
  Bridge.SocketType := soNone;
  if Validate then
    Result := ValidBridge(BridgeStr)
  else
    Result := BridgeStr <> '';
  if Result then
  begin
    ParamsState := 0;
    ParamsStr := '';
    ParseStr := BridgeStr.Split([' ']);
    for i := 0 to High(ParseStr) do
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
      SocketType := ValidSocket(ParseStr[i]);
      if SocketType <> soNone then
      begin
        if i = 1 then
          Bridge.Transport := ParseStr[0];
        Bridge.Ip := GetAddressFromSocket(ParseStr[i], UseFormatHost);
        Bridge.Port := GetPortFromSocket(ParseStr[i]);
        Bridge.SocketType := SocketType;
        ParamsState := 1;
        Continue;
      end;
    end;
    Bridge.Params := Trim(ParamsStr);
  end;
end;

function ValidTransport(const TransportStr: string; StrictTransport: Boolean = False): Boolean;
begin
  if TransportStr = '' then
    Result := False
  else
  begin
    if StrictTransport then
      Result := TransportsDic.ContainsKey(TransportStr)
    else
      Result := CheckEditString(TransportStr, '_', False) = '';
  end;
end;

function ValidBridge(const BridgeStr: string; StrictTransport: Boolean = False): Boolean;
var
  ParseStr: TArray<string>;
  ParamCount: Integer;
begin
  Result := False;
  if (BridgeStr = '') or (Pos('|', BridgeStr) <> 0)  then
    Exit;
  ParseStr := BridgeStr.Split([' ']);
  ParamCount := Length(ParseStr);
  if ParamCount > 1 then
  begin
    if ValidTransport(ParseStr[0], StrictTransport) then
    begin
      if ValidSocket(ParseStr[1]) <> soNone then
      begin
        if ParamCount > 2 then
          Result := ValidHash(ParseStr[2]) or ValidKeyValue(ParseStr[2])
        else
          Result := True;
      end;
    end
    else
    begin
      if ValidSocket(ParseStr[0]) <> soNone then
        Result := ValidHash(ParseStr[1])
    end;
  end
  else
    Result := ValidSocket(ParseStr[0]) <> soNone;
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

function LoadIconsFromResource(ImageList: TImageList; const ResourceName: string; UseFile: Boolean = False): Boolean;
var
  Bmp: TBitmap;
  Png: TPngImage;
begin
  Result := False;
  Png := TPngImage.Create;
  Bmp := TBitmap.Create;
  try
    if UseFile then
    begin
      if FileExists(ResourceName) then
      begin
        try
          Png.LoadFromFile(ResourceName)
        except
          on E:Exception do Exit;
        end;
      end
      else
        Exit;
    end
    else
      Png.LoadFromResourceName(HInstance, ResourceName);
    Bmp.Assign(Png);
    ImageList.Clear;
    ImageList.Add(Bmp, nil);
    Result := True;
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
        emClear:
        begin
          if Control is TMemo then
            TMemo(Control).ClearText
          else
            Control.Text := '';
        end;
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

function CheckFileVersion(const FileVersion, StaticVersion: string): Boolean;
begin
  Result := CompareNaturalText(
    PWideChar(SeparateLeft(FileVersion, '-')),
    PWideChar(SeparateLeft(StaticVersion, '-'))) <> -1;
end;

function TryUpdateMask(var Mask: Word; Param: Word; Condition: Boolean): Boolean;
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

function GetCircuitsParamsCount(PurposeID: Integer): Integer;
begin
  case PurposeID of
    HS_CLIENT_HSDIR..HS_SERVICE_REND: Result := 3;
    HS_VANGUARDS, CONFLUX_LINKED, CONFLUX_UNLINKED: Result := 2;
    else
      Result := 1;
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
  CheckMask(ROUTER_UNSTABLE);
  CheckMask(ROUTER_NOT_RECOMMENDED);
  CheckMask(ROUTER_BAD_EXIT);
  CheckMask(ROUTER_MIDDLE_ONLY);
  CheckMask(ROUTER_SUPPORT_CONFLUX);
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

procedure GetPeData(const FileName: string; var Data: TPEData);
var
  fs: TFilestream;
  NtSignature: DWORD;
  DosHeader: IMAGE_DOS_HEADER;
  PeHeader: IMAGE_FILE_HEADER;
  OptHeader: IMAGE_OPTIONAL_HEADER;
begin
  Data.Bits := 0;
  Data.CheckSum := 0;
  Data.MajorOSVersion := MAXWORD;
  Data.MinorOSVersion := MAXWORD;
  Data.IsDLL := False;
  fs := TFilestream.Create(FileName, fmOpenread or fmShareDenyNone);
  try
    fs.Read(DosHeader, SizeOf(DosHeader));
    if DosHeader.e_magic <> IMAGE_DOS_SIGNATURE then
      Exit;
    fs.Seek(DosHeader._lfanew, soFromBeginning);
    fs.Read(NtSignature, SizeOf(NtSignature));
    if NtSignature <> IMAGE_NT_SIGNATURE then
      Exit;
    fs.Read(PeHeader, SizeOf(PeHeader));
    Data.IsDLL := PeHeader.Characteristics and IMAGE_FILE_DLL <> 0;
    if PeHeader.SizeOfOptionalHeader > 0 then
    begin
      fs.Read(OptHeader, SizeOf(OptHeader));
      Data.CheckSum := OptHeader.CheckSum;
      Data.MajorOSVersion := OptHeader.MajorOperatingSystemVersion;
      Data.MinorOSVersion := OptHeader.MinorOperatingSystemVersion;
      case OptHeader.Magic of
        $10b: Data.Bits := 32;
        $20b: Data.Bits := 64;
      end;
    end;
  finally
    fs.Free;
  end;
end;

function GetFileID(const FileName: string; SkipFileExists: Boolean = False; const ConstData: string = ''): TFileID;
var
  F: TSearchRec;
  PeData: TPeData;
  OSBits: Integer;
begin
  Result.Data := '-1';
  Result.ExecSupport := False;
  if SkipFileExists or FileExists(FileName) then
  begin
    try
      if FindFirst(FileName, faAnyFile, F) = 0 then
      begin
        GetPeData(FileName, PeData);
        case TOSVersion.Architecture of
          arIntelX86: OSBits := 32;
          arIntelX64: OSBits := 64;
          else
            OSBits := -1;
        end;
        Result.ExecSupport := (OSBits >= PeData.Bits) and not PeData.IsDLL and CheckFileVersion(
          IntToStr(Win32MajorVersion) + '.' + IntToStr(Win32MinorVersion),
          IntToStr(PeData.MajorOSVersion) + '.' + IntToStr(PeData.MinorOSVersion)
        );
        {$WARN SYMBOL_PLATFORM OFF}
        Result.Data := IntToHex(THashBobJenkins.GetHashValue(IntToStr(F.Size) +
          IntToStr(DateTimeToUnix(F.TimeStamp)) +
          IntToStr(DateTimeToUnix(FileTimeToDateTime(F.FindData.ftCreationTime))) +
          IntToStr(DateTimeToUnix(FileTimeToDateTime(F.FindData.ftLastAccessTime))) +
          IntToStr(PeData.CheckSum) + ConstData
        ));
        {$WARN SYMBOL_PLATFORM ON}
      end;
    finally
      FindClose(F);
    end;
  end;
end;

function SampleDown(const Data: ArrOfPoint; Threshold: Integer): ArrOfPoint;
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
