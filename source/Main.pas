unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.CommCtrl, Winapi.Winsock, Winapi.ShellApi,
  Winapi.ShlObj, Winapi.GDIPAPI, Winapi.GDIPOBJ, System.SysUtils, System.IniFiles,
  System.Generics.Collections, System.ImageList, System.DateUtils, System.Math, System.IOUtils,
  Vcl.Forms, System.Classes, System.Masks, Vcl.ImgList, Vcl.Controls, Vcl.ExtCtrls,
  Vcl.Menus, Vcl.StdCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.Clipbrd, Vcl.Dialogs, Vcl.Graphics,
  Vcl.Themes, Vcl.Buttons, Vcl.ExtDlgs, blcksock, dnssend, httpsend, pingsend, synacode,
  synautil, ConstData, Functions, Addons, Languages;

type
  TUserGrid = class(TCustomGrid);

  TRouterFlag = (rfAuthority, rfBadExit, rfExit, rfFast, rfGuard, rfHSDir, rfStable, rfV2Dir, rfBridge, rfRelay, rfMiddleOnly, rfNoBridgeRelay);
  TRouterFlags = set of TRouterFlag;
  TRouterInfo = record
    Name: string;
    IPv4: string;
    IPv6: string;
    Port: Word;
    DirPort: Word;
    Flags: TRouterFlags;
    Version: string;
    Bandwidth: Integer;
    Params: Word;
  end;

  TSpeedData = record
    DL: Integer;
    UL: Integer;
  end;

  TTransportInfo = record
    TransportID: Byte;
    InList: Boolean;
  end;

  TBridgeInfo = record
    Router: TRouterInfo;
    Kind: Byte;
    Source: string;
    Transport: string;
    Params: string;
  end;

  TFetchInfo = record
    IpStr: string;
    PortStr: string;
    FailsCount: Integer;
  end;

  TFilterInfo = record
    cc: Byte;
    Data: TNodeTypes;
  end;

  TGeoIpInfo = record
    cc: Byte;
    ping: Integer;
    ports: string;
  end;

  TBuildFlag = (bfOneHop, bfInternal, bfNeedCapacity, bfNeedUptime);
  TBuildFlags = set of TBuildFlag;
  TCircuitInfo = record
    BuildFlags: TBuildFlags;
    PurposeID: Integer;
    Streams: Integer;
    Nodes: string;
    Date: TDateTime;
    BytesRead: int64;
    BytesWritten: int64;
    Flags: Word;
  end;

  TStreamInfo = record
    CircuitID: string;
    Target: string;
    SourceAddr: string;
    DestAddr: string;
    PurposeID: Integer;
    Protocol: Integer;
    BytesRead: int64;
    BytesWritten: int64;
  end;

  TPing = class(TPINGSend)
  public
    constructor Create(Timeout: Integer);
  end;

  TReadPipeThread = class(TThread)
  public
    hStdOut: THandle;
    VersionCheck: Boolean;
  private
    Data: string;
    DataSize, dwRead: DWORD;
    Buffer: PAnsiChar;
    FirstStart: Boolean;
    procedure UpdateLog;
    procedure UpdateVersionInfo;
  protected
    procedure Execute; override;
  end;

  TSendHttpThread = class(TThread)
  protected
    procedure Execute; override;
  end;

  TDNSSendThread = class(TThread)
  private
    Temp: string;
    procedure UpdateIpStage;
  protected
    procedure Execute; override;
  end;

  TScanThread = class(TThread)
  private
    procedure UpdateControls;
  public
    sScanPortionSize, sMaxThreads, sAttemptsDelay: Integer;
    sMaxPortAttempts, sMaxPingAttempts: Byte;
    sScanType: TScanType;
    sScanPurpose: TScanPurpose;
    sPingTimeout, sPortTimeout, sScanPortionTimeout: Integer;
  protected
    procedure Execute; override;
  end;

  TScanItemThread = class(TThread)
  public
    IpStr: string;
    Port: Word;
    MaxPortAttempts, MaxPingAttempts: Byte;
    ScanType: TScanType;
    PingTimeout, PortTimeout, AttemptsDelay: Integer;
    Result: Integer;
  protected
    procedure Execute; override;
  end;

  TConsensusThread = class(TThread)
  protected
    procedure Execute; override;
  end;

  TDescriptorsThread = class(TThread)
  protected
    procedure Execute; override;
  end;

  TControlThread = class(TThread)
  private
    Socket: TTCPBlockSocket;
    StreamStatusID, CircuitStatusID: Integer;
    CircuitInfo: TCircuitInfo;
    StreamInfo: TStreamInfo;
    SendBuffer: string;
    Data, AuthParam: string;
    Ip, Temp, CircuitID, StreamID: string;
    ParseStr: ArrOfStr;
    SearchPos, InfoCount: Integer;
    CountryCode: Byte;
    AddressType: TAddressType;
    UpdateCountry: Boolean;
    function AuthStageReady(AuthMethod: Integer): Boolean;
    function GetCircuitFlags(Circuit: TCircuitInfo): Word;
    procedure GetData;
    procedure SendData(cmd: string);
    procedure CheckDirFetches(StreamInfo: TStreamInfo; Counter: Integer);
  protected
    procedure Execute; override;
  end;

  TUTF8EncodingNoBOM = class(TUTF8Encoding)
  public
    function GetPreamble: TBytes; override;
  end;

  TPageControl = class(Vcl.ComCtrls.TPageControl)
  private
    procedure TCMAdjustRect(var Msg: TMessage); message TCM_ADJUSTRECT;
  end;

  TTcp = class(TForm)
    tiTray: TTrayIcon;
    mnTray: TPopupMenu;
    miExit: TMenuItem;
    tmUpdateIp: TTimer;
    miSwitchTor: TMenuItem;
    mnLog: TPopupMenu;
    miLogClear: TMenuItem;
    miShowOptions: TMenuItem;
    miShowLog: TMenuItem;
    miDelimiter1: TMenuItem;
    miDelimiter2: TMenuItem;
    miWriteLogFile: TMenuItem;
    miLogOptions: TMenuItem;
    miLogSelectAll: TMenuItem;
    miLogCopy: TMenuItem;
    miDelimiter3: TMenuItem;
    miDelimiter4: TMenuItem;
    miScrollBars: TMenuItem;
    miSbVertical: TMenuItem;
    miSbHorizontal: TMenuItem;
    miSbBoth: TMenuItem;
    miSbNone: TMenuItem;
    lsFlags: TImageList;
    lsButtons: TImageList;
    lsMenus: TImageList;
    btnCancelOptions: TButton;
    miAutoClear: TMenuItem;
    miOpenFileLog: TMenuItem;
    miDelimiter6: TMenuItem;
    miChangeCircuit: TMenuItem;
    mnChangeCircuit: TPopupMenu;
    miDelimiter5: TMenuItem;
    mnFilter: TPopupMenu;
    miLoadTemplate: TMenuItem;
    miSaveTemplate: TMenuItem;
    miDeleteTemplate: TMenuItem;
    miDelimiter7: TMenuItem;
    miClearFilter: TMenuItem;
    miClearFilterAll: TMenuItem;
    miClearFilterEntry: TMenuItem;
    miClearFilterMiddle: TMenuItem;
    miClearDNSCache: TMenuItem;
    EditMenu: TPopupMenu;
    miCut: TMenuItem;
    miCopy: TMenuItem;
    miPaste: TMenuItem;
    miSelectAll: TMenuItem;
    miDelimiter11: TMenuItem;
    miClear: TMenuItem;
    miDelimiter10: TMenuItem;
    miGetBridges: TMenuItem;
    btnApplyOptions: TButton;
    mnDetails: TPopupMenu;
    miDetailsUpdateIp: TMenuItem;
    miDetailsSelectTemplate: TMenuItem;
    miDelimiter8: TMenuItem;
    paStatus: TPanel;
    gbSpeedGraph: TGroupBox;
    miDetailsRelayInfo: TMenuItem;
    miDelimiter16: TMenuItem;
    gbSession: TGroupBox;
    lbSessionDLCaption: TLabel;
    lbSessionULCaption: TLabel;
    lbSessionDL: TLabel;
    lbSessionUL: TLabel;
    gbServerInfo: TGroupBox;
    lbServerExternalIpCaption: TLabel;
    lbFingerprintCaption: TLabel;
    miShowStatus: TMenuItem;
    mnServerInfo: TPopupMenu;
    miServerCopy: TMenuItem;
    miServerCopyIPv4: TMenuItem;
    miServerCopyFingerprint: TMenuItem;
    miDetailsAddToNodesList: TMenuItem;
    miServerInfo: TMenuItem;
    gbTraffic: TGroupBox;
    lbDownloadSpeedCaption: TLabel;
    lbUploadSpeedCaption: TLabel;
    lbDLSpeed: TLabel;
    lbULSpeed: TLabel;
    gbMaxTraffic: TGroupBox;
    lbMaxDLSpeedCaption: TLabel;
    lbMaxULSpeedCaption: TLabel;
    lbMaxDLSpeed: TLabel;
    lbMaxULSpeed: TLabel;
    gbInfo: TGroupBox;
    lbClientVersionCaption: TLabel;
    lbClientVersion: TLabel;
    mnHs: TPopupMenu;
    miHsInsert: TMenuItem;
    miHsDelete: TMenuItem;
    lbUserDirCaption: TLabel;
    lbUserDir: TLabel;
    lbServerExternalIp: TLabel;
    lbFingerprint: TLabel;
    miServerCopyBridgeIPv4: TMenuItem;
    lbBridgeCaption: TLabel;
    lbBridge: TLabel;
    miDelimiter9: TMenuItem;
    miHsClear: TMenuItem;
    miDelimiter12: TMenuItem;
    miHsCopy: TMenuItem;
    miHsCopyOnion: TMenuItem;
    miHsOpenDir: TMenuItem;
    miDelimiter13: TMenuItem;
    miStat: TMenuItem;
    miStatRelays: TMenuItem;
    miStatGuards: TMenuItem;
    miStatExit: TMenuItem;
    miDelimiter14: TMenuItem;
    miStatAggregate: TMenuItem;
    paRouters: TPanel;
    sgRouters: TStringGrid;
    miShowRouters: TMenuItem;
    miDelimiter15: TMenuItem;
    btnShowNodes: TButton;
    mnShowNodes: TPopupMenu;
    lbRoutersCount: TLabel;
    miShowExit: TMenuItem;
    miShowGuard: TMenuItem;
    miShowStable: TMenuItem;
    miShowFast: TMenuItem;
    miDelimiter17: TMenuItem;
    miDelimiter18: TMenuItem;
    miShowV2Dir: TMenuItem;
    miShowHSDir: TMenuItem;
    miShowOther: TMenuItem;
    cbxRoutersCountry: TComboBox;
    edRoutersWeight: TEdit;
    udRoutersWeight: TUpDown;
    lbSpeed3: TLabel;
    pcOptions: TPageControl;
    tsMain: TTabSheet;
    gbProfile: TGroupBox;
    lbCreateProfile: TLabel;
    btnCreateProfile: TButton;
    tsNetwork: TTabSheet;
    lbReachableAddresses: TLabel;
    lbProxyAddress: TLabel;
    lbProxyUser: TLabel;
    lbProxyPort: TLabel;
    lbProxyPassword: TLabel;
    lbProxyType: TLabel;
    cbUseReachableAddresses: TCheckBox;
    edReachableAddresses: TEdit;
    cbUseProxy: TCheckBox;
    edProxyAddress: TEdit;
    edProxyUser: TEdit;
    edProxyPassword: TEdit;
    cbxProxyType: TComboBox;
    cbUseBridges: TCheckBox;
    meBridges: TMemo;
    cbxSOCKSHost: TComboBox;
    edProxyPort: TEdit;
    udProxyPort: TUpDown;
    edSOCKSPort: TEdit;
    udSOCKSPort: TUpDown;
    cbEnableSocks: TCheckBox;
    tsFilter: TTabSheet;
    lbFilterMode: TLabel;
    cbxFilterMode: TComboBox;
    sgFilter: TStringGrid;
    tsServer: TTabSheet;
    lbORPort: TLabel;
    lbNickname: TLabel;
    lbServerMode: TLabel;
    lbRelayBandwidthRate: TLabel;
    lbRelayBandwidthBurst: TLabel;
    lbSpeed1: TLabel;
    lbSpeed2: TLabel;
    lbContactInfo: TLabel;
    lbDirPort: TLabel;
    lbExitPolicy: TLabel;
    lbMaxMemInQueues: TLabel;
    lbSizeMb: TLabel;
    lbBridgeType: TLabel;
    lbNumCPUs: TLabel;
    lbTransportPort: TLabel;
    imUPnPTest: TImage;
    edNickname: TEdit;
    cbxServerMode: TComboBox;
    cbUseRelayBandwidth: TCheckBox;
    edContactInfo: TEdit;
    cbxExitPolicyType: TComboBox;
    cbUseUPnP: TCheckBox;
    cbUseMaxMemInQueues: TCheckBox;
    cbxBridgeType: TComboBox;
    meExitPolicy: TMemo;
    cbUseNumCPUs: TCheckBox;
    cbPublishServerDescriptor: TCheckBox;
    cbUseDirPort: TCheckBox;
    cbDirReqStatistics: TCheckBox;
    cbIPv6Exit: TCheckBox;
    cbHiddenServiceStatistics: TCheckBox;
    edORPort: TEdit;
    udORPort: TUpDown;
    edDirPort: TEdit;
    udDirPort: TUpDown;
    edTransportPort: TEdit;
    udTransportPort: TUpDown;
    edMaxMemInQueues: TEdit;
    udMaxMemInQueues: TUpDown;
    edNumCPUs: TEdit;
    udNumCPUs: TUpDown;
    edRelayBandwidthRate: TEdit;
    udRelayBandwidthRate: TUpDown;
    edRelayBandwidthBurst: TEdit;
    udRelayBandwidthBurst: TUpDown;
    meMyFamily: TMemo;
    tsHs: TTabSheet;
    sgHsPorts: TStringGrid;
    sgHs: TStringGrid;
    gbHsEdit: TGroupBox;
    lbHsSocket: TLabel;
    lbHsVirtualPort: TLabel;
    lbHsVersion: TLabel;
    lbHsNumIntroductionPoints: TLabel;
    lbRendPostPeriod: TLabel;
    lbMinutes: TLabel;
    lbHsMaxStreams: TLabel;
    lbHsName: TLabel;
    cbxHsAddress: TComboBox;
    cbxHsVersion: TComboBox;
    cbHsMaxStreams: TCheckBox;
    edHsName: TEdit;
    edHsNumIntroductionPoints: TEdit;
    udHsNumIntroductionPoints: TUpDown;
    edHsMaxStreams: TEdit;
    udHsMaxStreams: TUpDown;
    udRendPostPeriod: TUpDown;
    edRendPostPeriod: TEdit;
    edHsRealPort: TEdit;
    udHsRealPort: TUpDown;
    edHsVirtualPort: TEdit;
    udHsVirtualPort: TUpDown;
    tsLists: TTabSheet;
    lbTotalNodesList: TLabel;
    cbEnableNodesList: TCheckBox;
    meNodesList: TMemo;
    lbTotalMyFamily: TLabel;
    tmConsensus: TTimer;
    miFilterOptions: TMenuItem;
    miDelimiter19: TMenuItem;
    miFilterHideUnused: TMenuItem;
    miFilterScrollTop: TMenuItem;
    mnRouters: TPopupMenu;
    miRtRelayInfo: TMenuItem;
    lbFilterCount: TLabel;
    lbFilterEntry: TLabel;
    lbFilterMiddle: TLabel;
    lbFilterExit: TLabel;
    miClearFilterExit: TMenuItem;
    miDelimiter20: TMenuItem;
    lbFavoritesEntry: TLabel;
    lbFavoritesMiddle: TLabel;
    lbFavoritesExit: TLabel;
    lbExcludeNodes: TLabel;
    miDelimiter21: TMenuItem;
    miClearRouters: TMenuItem;
    miClearRoutersEntry: TMenuItem;
    miClearRoutersMiddle: TMenuItem;
    miClearRoutersExit: TMenuItem;
    miDelimiter22: TMenuItem;
    miClearRoutersFavorites: TMenuItem;
    miClearRoutersExclude: TMenuItem;
    lbNodesListType: TLabel;
    cbxNodesListType: TComboBox;
    paCircuits: TPanel;
    tmCircuits: TTimer;
    mnCircuits: TPopupMenu;
    miDestroyCircuit: TMenuItem;
    miFilterSelectRow: TMenuItem;
    miRoutersOptions: TMenuItem;
    miDelimiter23: TMenuItem;
    miRoutersSelectRow: TMenuItem;
    miRoutersScrollTop: TMenuItem;
    sgStreams: TStringGrid;
    sgCircuitInfo: TStringGrid;
    lbDetailsTime: TLabel;
    lbNodesListTypeCaption: TLabel;
    sgCircuits: TStringGrid;
    miCircuitsDestroy: TMenuItem;
    miDestroyStreams: TMenuItem;
    miCircuitsSort: TMenuItem;
    miCircuitsSortID: TMenuItem;
    miCircuitsSortPurpose: TMenuItem;
    miCircuitsSortStreams: TMenuItem;
    miResetGuards: TMenuItem;
    miShowCircuits: TMenuItem;
    miCircuitOptions: TMenuItem;
    miDelimiter24: TMenuItem;
    miShowBridge: TMenuItem;
    lbTotalBridges: TLabel;
    miRtSaveDefault: TMenuItem;
    miRtResetFilter: TMenuItem;
    miDelimiter25: TMenuItem;
    miDelimiter26: TMenuItem;
    lbFavoritesTotal: TLabel;
    miRtFilters: TMenuItem;
    miRtFiltersType: TMenuItem;
    miRtFiltersCountry: TMenuItem;
    miRtFiltersWeight: TMenuItem;
    miShowAuthority: TMenuItem;
    lbPorts: TLabel;
    cbDirCache: TCheckBox;
    cbListenIPv6: TCheckBox;
    cbAssumeReachable: TCheckBox;
    lbAddress: TLabel;
    cbUseAddress: TCheckBox;
    edAddress: TEdit;
    lbStatusSocksAddrCaption: TLabel;
    lbStatusSocksAddr: TLabel;
    miCircuitFilter: TMenuItem;
    miCircOneHop: TMenuItem;
    miCircInternal: TMenuItem;
    miCircExit: TMenuItem;
    miCircHsClientDir: TMenuItem;
    miCircHsClientIntro: TMenuItem;
    miCircHsClientRend: TMenuItem;
    miCircHsServiceDir: TMenuItem;
    miCircHsServiceIntro: TMenuItem;
    miCircHsServiceRend: TMenuItem;
    miCircHsVanguards: TMenuItem;
    miCircPathBiasTesting: TMenuItem;
    miCircTesting: TMenuItem;
    miCircCircuitPadding: TMenuItem;
    miCircMeasureTimeout: TMenuItem;
    miCircOther: TMenuItem;
    miHideCircuitsWithoutStreams: TMenuItem;
    miAlwaysShowExitCircuit: TMenuItem;
    lbCircuitsCount: TLabel;
    lbStreamsCount: TLabel;
    mnStreams: TPopupMenu;
    miStreamsSort: TMenuItem;
    miStreamsSortStreams: TMenuItem;
    miStreamsSortID: TMenuItem;
    miStreamsSortTarget: TMenuItem;
    miStreamsDestroyStream: TMenuItem;
    miStreamsOpenInBrowser: TMenuItem;
    miDelimiter28: TMenuItem;
    miDelimiter27: TMenuItem;
    miStreamsBindToExitNode: TMenuItem;
    cbUseHiddenServiceVanguards: TCheckBox;
    lbVanguardLayerType: TLabel;
    cbxVanguardLayerType: TComboBox;
    miLoadCachedRoutersOnStartup: TMenuItem;
    miUpdateIpToCountryCache: TMenuItem;
    gbControlAuth: TGroupBox;
    lbControlPort: TLabel;
    lbAuthMetod: TLabel;
    lbControlPassword: TLabel;
    imGeneratePassword: TImage;
    edControlPort: TEdit;
    udControlPort: TUpDown;
    cbxAuthMetod: TComboBox;
    edControlPassword: TEdit;
    gbInterface: TGroupBox;
    cbStayOnTop: TCheckBox;
    cbShowBalloonOnlyWhenHide: TCheckBox;
    cbShowBalloonHint: TCheckBox;
    cbConnectOnStartup: TCheckBox;
    cbRestartOnControlFail: TCheckBox;
    cbNoDesktopBorders: TCheckBox;
    cbRememberEnlargedPosition: TCheckBox;
    gbOptions: TGroupBox;
    lbMaxCircuitDirtiness: TLabel;
    lbSeconds1: TLabel;
    cbAvoidDiskWrites: TCheckBox;
    cbLearnCircuitBuildTimeout: TCheckBox;
    cbEnforceDistinctSubnets: TCheckBox;
    edMaxCircuitDirtiness: TEdit;
    udMaxCircuitDirtiness: TUpDown;
    cbUseOpenDNS: TCheckBox;
    cbUseOpenDNSOnlyWhenUnknown: TCheckBox;
    miStreamsSortTrack: TMenuItem;
    miSelectExitCircuitWhenItChanges: TMenuItem;
    lsTray: TImageList;
    paButtons: TPanel;
    sbShowLog: TSpeedButton;
    sbShowOptions: TSpeedButton;
    paLog: TPanel;
    sbShowStatus: TSpeedButton;
    sbShowCircuits: TSpeedButton;
    sbShowRouters: TSpeedButton;
    sbDecreaseForm: TSpeedButton;
    btnChangeCircuit: TButton;
    imExitFlag: TImage;
    lbExitCountryCaption: TLabel;
    lbExitIpCaption: TLabel;
    lbExitIp: TLabel;
    lbExitCountry: TLabel;
    cbUseNetworkCache: TCheckBox;
    btnSwitchTor: TButton;
    lsMain: TImageList;
    cbUseMyFamily: TCheckBox;
    cbxRoutersQuery: TComboBox;
    edRoutersQuery: TEdit;
    cbxBridgeDistribution: TComboBox;
    lbBridgeDistribution: TLabel;
    miShowRecommend: TMenuItem;
    miAbout: TMenuItem;
    miShowDirMirror: TMenuItem;
    miRtFiltersQuery: TMenuItem;
    miDisableFiltersOnUserQuery: TMenuItem;
    miClearRoutersAbsent: TMenuItem;
    cbHideIPv6Addreses: TCheckBox;
    miClearRoutersIncorrect: TMenuItem;
    sgStreamsInfo: TStringGrid;
    miDelimiter29: TMenuItem;
    miRtAddToNodesList: TMenuItem;
    miDelimiter30: TMenuItem;
    miTplLoadExcludes: TMenuItem;
    miTplLoadCountries: TMenuItem;
    miTplLoadRouters: TMenuItem;
    miTplSaveCountries: TMenuItem;
    miTplSaveRouters: TMenuItem;
    miTplSaveExcludes: TMenuItem;
    miTplSave: TMenuItem;
    miTplLoad: TMenuItem;
    miTplSaveSA: TMenuItem;
    miDelimiter31: TMenuItem;
    miDelimiter32: TMenuItem;
    miTplLoadSA: TMenuItem;
    miDelimiter33: TMenuItem;
    miCircSA: TMenuItem;
    miDelimiter34: TMenuItem;
    miRtFilterSA: TMenuItem;
    miCircUA: TMenuItem;
    miTplSaveUA: TMenuItem;
    miTplLoadUA: TMenuItem;
    miRtFilterUA: TMenuItem;
    miIgnoreTplLoadParamsOutsideTheFilter: TMenuItem;
    miNotLoadEmptyTplData: TMenuItem;
    miDelimiter35: TMenuItem;
    miGetBridgesSite: TMenuItem;
    miGetBridgesEmail: TMenuItem;
    miDelimiter36: TMenuItem;
    miDestroyExitCircuits: TMenuItem;
    miCircuitsUpdateSpeed: TMenuItem;
    miCircuitsUpdateHigh: TMenuItem;
    miCircuitsUpdateNormal: TMenuItem;
    miCircuitsUpdateLow: TMenuItem;
    miDelimiter37: TMenuItem;
    miCircuitsUpdateManual: TMenuItem;
    miDelimiter38: TMenuItem;
    miCircuitsUpdateNow: TMenuItem;
    miDelimiter39: TMenuItem;
    cbStrictNodes: TCheckBox;
    tsOther: TTabSheet;
    miReplaceDisabledFavoritesWithCountries: TMenuItem;
    miDelimiter40: TMenuItem;
    miCircuitsSortDL: TMenuItem;
    miCircuitsSortUL: TMenuItem;
    miDelimiter41: TMenuItem;
    miShowCircuitsTraffic: TMenuItem;
    miShowStreamsTraffic: TMenuItem;
    mnStreamsInfo: TPopupMenu;
    miStreamsInfoDestroyStream: TMenuItem;
    miDelimiter42: TMenuItem;
    miStreamsInfoSort: TMenuItem;
    miStreamsInfoSortID: TMenuItem;
    miStreamsInfoSortSource: TMenuItem;
    miStreamsInfoSortPurpose: TMenuItem;
    miStreamsInfoSortDL: TMenuItem;
    miStreamsInfoSortUL: TMenuItem;
    miStreamsSortDL: TMenuItem;
    miStreamsSortUL: TMenuItem;
    miStreamsInfoSortDest: TMenuItem;
    miShowStreamsInfo: TMenuItem;
    cbNoDesktopBordersOnlyEnlarged: TCheckBox;
    lbMaxClientCircuitsPending: TLabel;
    edMaxClientCircuitsPending: TEdit;
    udMaxClientCircuitsPending: TUpDown;
    miDelimiter43: TMenuItem;
    miDelete: TMenuItem;
    miFind: TMenuItem;
    miLogFind: TMenuItem;
    FindDialog: TFindDialog;
    gbNetworkScanner: TGroupBox;
    tmScanner: TTimer;
    miClearServerCache: TMenuItem;
    miDelimiter47: TMenuItem;
    miCacheOperations: TMenuItem;
    miDelimiter46: TMenuItem;
    miShowAlive: TMenuItem;
    miDelimiter49: TMenuItem;
    miDelimiter50: TMenuItem;
    miShowNodesUA: TMenuItem;
    miDelimiter51: TMenuItem;
    miClearPingCache: TMenuItem;
    miClearAliveCache: TMenuItem;
    lbFilterExclude: TLabel;
    lbStatusScannerCaption: TLabel;
    lbStatusScanner: TLabel;
    miRoutersShowFlagsHint: TMenuItem;
    lbHsState: TLabel;
    cbxHsState: TComboBox;
    gbTransports: TGroupBox;
    sgTransports: TStringGrid;
    lbTransports: TLabel;
    edTransports: TEdit;
    lbTransportsHandler: TLabel;
    edTransportsHandler: TEdit;
    lbHandlerParams: TLabel;
    meHandlerParams: TMemo;
    mnTransports: TPopupMenu;
    miTransportsInsert: TMenuItem;
    miTransportsDelete: TMenuItem;
    miDelimiter53: TMenuItem;
    miTransportsClear: TMenuItem;
    miDelimiter52: TMenuItem;
    miTransportsOpenDir: TMenuItem;
    miTransportsReset: TMenuItem;
    lbTransportType: TLabel;
    cbxTransportType: TComboBox;
    lbBridgesType: TLabel;
    cbxBridgesType: TComboBox;
    cbxBridgesList: TComboBox;
    lbBridgesSubType: TLabel;
    miDelimiter54: TMenuItem;
    miRequestIPv6Bridges: TMenuItem;
    miRequestObfuscatedBridges: TMenuItem;
    miGetBridgesTelegram: TMenuItem;
    miPreferWebTelegram: TMenuItem;
    miDelimiter55: TMenuItem;
    miClearMenuNotAlive: TMenuItem;
    miClearMenu: TMenuItem;
    miClearMenuAll: TMenuItem;
    miDelimiter56: TMenuItem;
    miClearMenuNonCached: TMenuItem;
    miResetGuardsDefault: TMenuItem;
    miResetGuardsAll: TMenuItem;
    miDelimiter57: TMenuItem;
    miResetGuardsRestricted: TMenuItem;
    miResetGuardsBridges: TMenuItem;
    cbUsePreferredBridge: TCheckBox;
    edPreferredBridge: TEdit;
    lbPreferredBridge: TLabel;
    cbClearPreviousSearchQuery: TCheckBox;
    miRtSelectAsBridge: TMenuItem;
    miServerCopyIPv6: TMenuItem;
    miServerCopyBridgeIPv6: TMenuItem;
    miDisableSelectionUnSuitableAsBridge: TMenuItem;
    miRtSelectAsBridgeIPv4: TMenuItem;
    miRtSelectAsBridgeIPv6: TMenuItem;
    miRtDisableBridges: TMenuItem;
    btnFindPreferredBridge: TButton;
    miClearBridgesCacheAll: TMenuItem;
    lbFullScanInterval: TLabel;
    lbHours1: TLabel;
    lbPartialScanInterval: TLabel;
    lbHours2: TLabel;
    cbAutoScanNewNodes: TCheckBox;
    cbEnableDetectAliveNodes: TCheckBox;
    cbEnablePingMeasure: TCheckBox;
    edFullScanInterval: TEdit;
    udFullScanInterval: TUpDown;
    edPartialScanInterval: TEdit;
    udPartialScanInterval: TUpDown;
    lbPartialScansCounts: TLabel;
    edPartialScansCounts: TEdit;
    udPartialScansCounts: TUpDown;
    lbScanMaxThread: TLabel;
    lbScanPortAttempts: TLabel;
    lbScanPortionSize: TLabel;
    edScanMaxThread: TEdit;
    udScanMaxThread: TUpDown;
    edScanPortAttempts: TEdit;
    udScanPortAttempts: TUpDown;
    edScanPortionSize: TEdit;
    udScanPortionSize: TUpDown;
    lbScanPingAttempts: TLabel;
    edScanPingAttempts: TEdit;
    udScanPingAttempts: TUpDown;
    lbScanPortTimeout: TLabel;
    edScanPortTimeout: TEdit;
    udScanPortTimeout: TUpDown;
    lbMiliseconds2: TLabel;
    lbScanPingTimeout: TLabel;
    lbMiliseconds1: TLabel;
    edScanPingTimeout: TEdit;
    udScanPingTimeout: TUpDown;
    lbDelayBetweenAttempts: TLabel;
    lbMiliseconds3: TLabel;
    edDelayBetweenAttempts: TEdit;
    udDelayBetweenAttempts: TUpDown;
    lbScanPortionTimeout: TLabel;
    edScanPortionTimeout: TEdit;
    udScanPortionTimeout: TUpDown;
    lbMiliseconds4: TLabel;
    miDelimiter48: TMenuItem;
    gbTotal: TGroupBox;
    lbTotalDLCaption: TLabel;
    lbTotalULCaption: TLabel;
    lbTotalDL: TLabel;
    lbTotalUL: TLabel;
    miDelimiter60: TMenuItem;
    miResetScannerSchedule: TMenuItem;
    miLogSeparate: TMenuItem;
    miDelimiter59: TMenuItem;
    miLogSeparateNone: TMenuItem;
    miLogSeparateMonth: TMenuItem;
    miLogSeparateDay: TMenuItem;
    miDelimiter58: TMenuItem;
    miReverseConditions: TMenuItem;
    miStopScan: TMenuItem;
    miStartScan: TMenuItem;
    miScanNewNodes: TMenuItem;
    miScanCachedBridges: TMenuItem;
    miScanNonResponsed: TMenuItem;
    miScanAll: TMenuItem;
    miManualDetectAliveNodes: TMenuItem;
    miManualPingMeasure: TMenuItem;
    gbAutoSelectRouters: TGroupBox;
    miDelimiter61: TMenuItem;
    miClearMenuCached: TMenuItem;
    miClearBridgeCacheUnnecessary: TMenuItem;
    miDelimiter62: TMenuItem;
    miDisableFiltersOn: TMenuItem;
    miDisableFiltersOnAuthorityOrBridge: TMenuItem;
    miClearUnusedNetworkCache: TMenuItem;
    miClearFilterExclude: TMenuItem;
    miConvertNodes: TMenuItem;
    miEnableConvertNodesOnIncorrectClear: TMenuItem;
    miEnableConvertNodesOnAddToNodesList: TMenuItem;
    miDelimiter63: TMenuItem;
    miIgnoreConvertExcludeNodes: TMenuItem;
    miConvertIpNodes: TMenuItem;
    miConvertCidrNodes: TMenuItem;
    miConvertCountryNodes: TMenuItem;
    miDelimiter64: TMenuItem;
    miAvoidAddingIncorrectNodes: TMenuItem;
    lbMaxAdvertisedBandwidth: TLabel;
    edMaxAdvertisedBandwidth: TEdit;
    udMaxAdvertisedBandwidth: TUpDown;
    lbSpeed4: TLabel;
    edAutoSelExitCount: TEdit;
    udAutoSelExitCount: TUpDown;
    edAutoSelMiddleCount: TEdit;
    udAutoSelMiddleCount: TUpDown;
    edAutoSelEntryCount: TEdit;
    udAutoSelEntryCount: TUpDown;
    miEnableConvertNodesOnRemoveFromNodesList: TMenuItem;
    cbAutoSelNodesWithPingOnly: TCheckBox;
    cbAutoSelUniqueNodes: TCheckBox;
    cbAutoSelStableOnly: TCheckBox;
    lbCount1: TLabel;
    lbCount2: TLabel;
    lbCount3: TLabel;
    cbAutoSelFilterCountriesOnly: TCheckBox;
    lbAutoSelPriority: TLabel;
    cbxAutoSelPriority: TComboBox;
    pbTraffic: TPaintBox;
    mnTraffic: TPopupMenu;
    miTrafficPeriod: TMenuItem;
    miSelectGraph: TMenuItem;
    miPeriod1m: TMenuItem;
    miPeriod5m: TMenuItem;
    miPeriod15m: TMenuItem;
    miPeriod30m: TMenuItem;
    miPeriod1h: TMenuItem;
    miPeriod3h: TMenuItem;
    miPeriod6h: TMenuItem;
    miPeriod12h: TMenuItem;
    miPeriod24h: TMenuItem;
    miSelectGraphDL: TMenuItem;
    miSelectGraphUL: TMenuItem;
    tmTraffic: TTimer;
    cbAutoSelMiddleNodesWithoutDir: TCheckBox;
    lbUseBuiltInProxy: TLabel;
    cbEnableHttp: TCheckBox;
    cbxHTTPTunnelHost: TComboBox;
    edHTTPTunnelPort: TEdit;
    udHTTPTunnelPort: TUpDown;
    lbStatusHttpAddrCaption: TLabel;
    lbStatusHttpAddr: TLabel;
    miCheckIpProxyType: TMenuItem;
    miDelimiter66: TMenuItem;
    miCheckIpProxyAuto: TMenuItem;
    miCheckIpProxySocks: TMenuItem;
    miCheckIpProxyHttp: TMenuItem;
    lbStatusFilterModeCaption: TLabel;
    lbStatusFilterMode: TLabel;
    miOpenLogsFolder: TMenuItem;
    miScanGuards: TMenuItem;
    lbAutoScanType: TLabel;
    cbxAutoScanType: TComboBox;
    miScanAliveNodes: TMenuItem;
    miShowConsensus: TMenuItem;
    miExcludeBridgesWhenCounting: TMenuItem;
    miDelimiter67: TMenuItem;
    miShowPortAlongWithIp: TMenuItem;
    miResetTotalsCounter: TMenuItem;
    miEnableTotalsCounter: TMenuItem;
    miTotalsCounter: TMenuItem;
    miDelimiter68: TMenuItem;
    miDelimiter69: TMenuItem;
    lbTheme: TLabel;
    lbLanguage: TLabel;
    cbxThemes: TComboBox;
    cbxLanguage: TComboBox;
    cbxCircuitPadding: TComboBox;
    cbxConnectionPadding: TComboBox;
    lbConnectionPadding: TLabel;
    lbCircuitPadding: TLabel;
    miLogAutoDelType: TMenuItem;
    miLogDelNever: TMenuItem;
    miLogDelEvery: TMenuItem;
    miLogDel1d: TMenuItem;
    miLogDel3d: TMenuItem;
    miLogDel1w: TMenuItem;
    miLogDel1m: TMenuItem;
    miLogDel3m: TMenuItem;
    miLogDel6m: TMenuItem;
    miLogDel1y: TMenuItem;
    miLogDelOlderThan: TMenuItem;
    miLogDel2w: TMenuItem;
    miDelimiter71: TMenuItem;
    miLogSeparateWeek: TMenuItem;
    pbScanProgress: TProgressBar;
    lbScanType: TLabel;
    lbScanProgress: TLabel;
    cbExcludeUnsuitableBridges: TCheckBox;
    miDelimiter72: TMenuItem;
    miClearMenuUnsuitable: TMenuItem;
    cbUseBridgesLimit: TCheckBox;
    lbBridgesLimit: TLabel;
    edBridgesLimit: TEdit;
    udBridgesLimit: TUpDown;
    lbBridgesPriority: TLabel;
    cbxBridgesPriority: TComboBox;
    cbCacheNewBridges: TCheckBox;
    lbMaxDirFails: TLabel;
    edMaxDirFails: TEdit;
    udMaxDirFails: TUpDown;
    lbBridgesCheckDelay: TLabel;
    edBridgesCheckDelay: TEdit;
    udBridgesCheckDelay: TUpDown;
    lbSeconds5: TLabel;
    lbCount4: TLabel;
    lbBridgesQueueSize: TLabel;
    edBridgesQueueSize: TEdit;
    udBridgesQueueSize: TUpDown;
    lbCount5: TLabel;
    cbScanNewBridges: TCheckBox;
    imFilterEntry: TImage;
    imFilterMiddle: TImage;
    imFilterExit: TImage;
    imFilterExclude: TImage;
    lbFilterTotalSelected: TLabel;
    lbFavoritesTotalSelected: TLabel;
    imFavoritesEntry: TImage;
    imFavoritesMiddle: TImage;
    imFavoritesExit: TImage;
    imFavoritesTotal: TImage;
    imExcludeNodes: TImage;
    miDelimiter73: TMenuItem;
    miStatCountry: TMenuItem;
    imFavoritesBridges: TImage;
    lbFavoritesBridges: TLabel;
    lbSocksTimeout: TLabel;
    lbSeconds6: TLabel;
    edSocksTimeout: TEdit;
    udSocksTimeout: TUpDown;
    lbCircuitBuildTimeout: TLabel;
    lbSeconds2: TLabel;
    edCircuitBuildTimeout: TEdit;
    udCircuitBuildTimeout: TUpDown;
    lbSeconds3: TLabel;
    lbNewCircuitPeriod: TLabel;
    edNewCircuitPeriod: TEdit;
    udNewCircuitPeriod: TUpDown;
    OpenDialog: TOpenDialog;
    edBridgesFile: TEdit;
    imBridgesFile: TImage;
    cbUseFallbackDirs: TCheckBox;
    lbTotalFallbackDirs: TLabel;
    meFallbackDirs: TMemo;
    lbFallbackDirsType: TLabel;
    cbxFallbackDirsType: TComboBox;
    lbCount6: TLabel;
    edAutoSelFallbackDirCount: TEdit;
    udAutoSelFallbackDirCount: TUpDown;
    imFavoritesFallbackDirs: TImage;
    lbFavoritesFallbackDirs: TLabel;
    lbSeconds4: TLabel;
    lbTotalHosts: TLabel;
    lbTrackHostExitsExpire: TLabel;
    meTrackHostExits: TMemo;
    cbUseTrackHostExits: TCheckBox;
    edTrackHostExitsExpire: TEdit;
    udTrackHostExitsExpire: TUpDown;
    cbAutoSelFallbackDirNoLimit: TCheckBox;
    cbExcludeUnsuitableFallbackDirs: TCheckBox;
    lbCircPurpose: TLabel;
    imCircuitPurpose: TImage;
    miCircuitsSortFlags: TMenuItem;
    miCircController: TMenuItem;
    miCircuitsSortParams: TMenuItem;
    miCircuitsShowFlagsHint: TMenuItem;
    miExtractData: TMenuItem;
    lbAutoSelRoutersAfterScanType: TLabel;
    cbxAutoSelRoutersAfterScanType: TComboBox;
    cbAutoSelEntryEnabled: TCheckBox;
    cbAutoSelMiddleEnabled: TCheckBox;
    cbAutoSelExitEnabled: TCheckBox;
    cbAutoSelFallbackDirEnabled: TCheckBox;
    lbAutoSelEntry: TLabel;
    lbAutoSelMiddle: TLabel;
    lbAutoSelExit: TLabel;
    lbAutoSelFallbackDir: TLabel;
    lbAutoSelMaxPing: TLabel;
    lbAutoSelMinWeight: TLabel;
    lbSpeed5: TLabel;
    lbMiliseconds5: TLabel;
    edAutoSelMaxPing: TEdit;
    udAutoSelMaxPing: TUpDown;
    edAutoSelMinWeight: TEdit;
    udAutoSelMinWeight: TUpDown;
    meLog: TMemo;
    sbAutoScroll: TSpeedButton;
    sbWordWrap: TSpeedButton;
    edLinesLimit: TEdit;
    udLinesLimit: TUpDown;
    sbUseLinesLimit: TSpeedButton;
    lbLogLevel: TLabel;
    cbxLogLevel: TComboBox;
    sbSafeLogging: TSpeedButton;
    bvLog: TBevel;
    miSortData: TMenuItem;
    miSortDataAsc: TMenuItem;
    miSortDataDesc: TMenuItem;
    miDelimiter65: TMenuItem;
    miSortDataNone: TMenuItem;
    cbMinimizeToTray: TCheckBox;
    lbMinimizeOnEvent: TLabel;
    cbxMinimizeOnEvent: TComboBox;
    lbTrayIconType: TLabel;
    cbxTrayIconType: TComboBox;
    miRtExtractData: TMenuItem;
    miDetailsExtractData: TMenuItem;
    imSelectedRouters: TImage;
    lbSelectedRouters: TLabel;
    function CheckCacheOpConfirmation(OpStr: string): Boolean;
    function CheckVanguards(Silent: Boolean = False): Boolean;
    function CheckNetworkOptions: Boolean;
    function CheckHsPorts: Boolean;
    function CheckHsTable: Boolean;
    function CheckTransports: Boolean;
    function CheckSimilarPorts: Boolean;
    function NodesToFavorites(NodesID: Integer): Integer;
    function FavoritesToNodes(FavoritesID: Integer): Integer;
    function GetFavoritesLabel(FavoritesID: Integer): TLabel;
    function GetFilterLabel(FilterID: Integer): TLabel;
    function GetFormPositionStr: string;
    function FindTrackHost(Host: string): Boolean;
    function FindInRanges(IpStr: string; AddressType: TAddressType): string;
    function RouterInNodesList(RouterID: string; IpStr: string; NodeType: TNodeType; SkipCodes: Boolean = False; CodeStr: string = ''; AddressType: TAddressType = atNone): Boolean;
    function GetTrackHostDomains(Host: string; OnlyExists: Boolean): string;
    function GetControlEvents: string;
    function GetTorHs: Integer;
    function LoadHiddenServices(ini: TMemIniFile): Integer;
    function PreferredBridgeFound: Boolean;
    function GetRouterStrFlags(Flags: TRouterFlags): string;
    function GetRouterCsvData(RouterID: string; RouterInfo: TRouterInfo; Preview: Boolean = False): string;
    function GetBridgeStr(RouterID: string; RouterInfo: TRouterInfo; UseIPv6: Boolean; Preview: Boolean = False): string;
    function GetFallbackStr(RouterID: string; RouterInfo: TRouterInfo; Preview: Boolean = False): string;
    function CheckRouterFlags(NodeTypeID: Integer; RouterInfo: TRouterInfo): Boolean;
    procedure SaveScanData;
    procedure UpdateBridgesControls(UpdateList: Boolean; UpdateUserBridges: Boolean);
    procedure UpdateFallbackDirControls;
    procedure ShowRoutersParamsHint;
    procedure ShowCircuitsFlagsHint;
    procedure CalculateFilterNodes(AlwaysUpdate: Boolean = True);
    procedure CalculateTotalNodes(AlwaysUpdate: Boolean = True);
    procedure CloseCircuit(CircuitID: string; AutoUpdate: Boolean = True);
    procedure CloseStream(StreamID: string);
    procedure CloseStreams(CircuitID: string; FindTarget: Boolean = False; TargetID: string = '');
    procedure CheckOptionsChanged;
    procedure LoadNetworkCache;
    procedure SaveNetworkCache(AutoSave: Boolean = True);
    procedure LoadBridgesCache;
    procedure SaveBridgesCache;
    procedure SetServerPort(PortControl: TUpDown);
    procedure SetNodes(FilterEntry, FilterMiddle, FilterExit, FavoritesEntry, FavoritesMiddle, FavoritesExit, ExcludeNodes: string);
    procedure ShowFilter;
    procedure ApplyOptions(AutoResolveErrors: Boolean = False);
    function InsertExtractMenu(ParentMenu: TMenuItem; ControlType, ControlID, ExtractType: Integer): Boolean;
    procedure InsertNodesMenu(ParentMenu: TMenuItem; NodeID: string; AutoSave: Boolean = True);
    procedure InsertNodesListMenu(ParentMenu: TmenuItem; NodeID: string; NodeTypeID: Integer; AutoSave: Boolean = True);
    procedure InsertNodesToDeleteMenu(ParentMenu: TmenuItem; NodeID: string; AutoSave: Boolean = True);
    procedure ChangeFilter;
    procedure ChangeRouters;
    procedure UpdateRoutersAfterFilterUpdate;
    procedure UpdateOptionsAfterRoutersUpdate;
    procedure UpdateRoutersAfterBridgesUpdate;
    procedure UpdateRoutersAfterFallbackDirsUpdate;
    procedure SaveRoutersFilterdata(Default: Boolean = False; SaveFilters: Boolean = True);
    procedure LoadRoutersFilterData(Data: string; AutoUpdate: Boolean = True; ResetCustomFilter: Boolean = False);
    procedure ChangeHsTable(Param: Integer);
    procedure ChangeTransportTable(Param: Integer);
    procedure SetDesktopPosition(ALeft, ATop: Integer; AutoUpdate: Boolean = True);
    procedure LoadOptions(FirstStart: Boolean);
    function GetTorVersion(FirstStart: Boolean): Boolean;
    procedure CheckLinesLimitControls;
    procedure CheckAuthMetodContols;
    procedure CheckAutoSelControls;
    procedure CheckFilterMode;
    procedure CheckHsVersion;
    procedure CheckStatusControls;
    procedure CheckOpenPorts(PortSpin: TUpDown; IP: string; var PortStr: string);
    procedure CheckServerControls;
    procedure CheckScannerControls;
    procedure CheckShowRouters;
    procedure CheckCachedFiles;
    procedure ClearFilter(NodeType: TNodeType; Silent: Boolean = True);
    procedure ClearRouters(NodeTypes: TNodeTypes = []; Silent: Boolean = True);
    procedure ControlPortConnect;
    procedure LogListenerStart(hStdOut: THandle);
    procedure CheckVersionStart(hStdOut: THandle; FirstStart: Boolean);
    procedure DecreaseFormSize(AutoRestore: Boolean = True);
    procedure ChangeButtonsCaption;
    procedure UpdateFormSize;
    procedure HsMaxStreamsEnable(State: Boolean);
    procedure HsPortsEnable(State: Boolean);
    procedure TransportsEnable(State: Boolean);
    procedure BridgesCheckControls;
    procedure FallbackDirsCheckControls;
    procedure EnableOptionButtons(State: Boolean = True);
    procedure FindInFilter(IpAddr: string);
    procedure FindInRouters(RouterID: string; SocketStr: string = '');
    procedure FindInCircuits(CircID, NodeID: string; AutoSelect: Boolean = False);
    procedure SendDataThroughProxy;
    procedure GetDNSExternalAddress(UpdateExternalIp: Boolean = True);
    procedure GetServerInfo(UpdateExternalIp: Boolean = True);
    procedure UpdateServerInfo;
    procedure IncreaseFormSize;
    procedure SetDownState;
    procedure InitPortForwarding(Test: Boolean);
    procedure ResetFocus;
    procedure ScanStart(ScanType: TScanType; ScanPurpose: TScanPurpose);
    procedure ScanNetwork(ScanType: TScanType; ScanPurpose: TScanPurpose);
    procedure UpdateScannerControls;
    procedure CheckBridgeFileSave;
    function GetScanTypeStr: string;
    procedure LoadConsensus;
    procedure LoadDescriptors;
    procedure SaveLinesLimitData;
    procedure CheckCountryIndexInList;
    procedure CheckNodesListControls;
    procedure CheckFavoritesState(FavoritesID: Integer = -1);
    procedure LoadNodesList(UseDic: Boolean = True; NodesStr: string = '');
    procedure SaveNodesList(NodesID: Integer);
    procedure LoadFilterTotals;
    procedure LoadRoutersCountries;
    procedure OpenMetricsUrl(Page, Query: string);
    procedure ProxyParamCheck;
    function CheckRequiredFiles(AutoSave: Boolean = False): Boolean;
    function ReachablePortsExists: Boolean;
    procedure SetIconsColor;
    procedure SaveHiddenServices(ini: TMemIniFile);
    procedure SavePaddingOptions(ini: TMemIniFile);
    procedure CheckPaddingControls;
    procedure UpdateConfigVersion;
    procedure LoadUserBridges(ini: TMemIniFile);
    procedure LoadBridgesFromFile;
    procedure LoadFallbackDirs(ini: TMemIniFile; Default: Boolean);
    procedure LoadBuiltinBridges(ini: TMemIniFile; UpdateBridges, UpdateList: Boolean; ListName: string = '');
    procedure ResetTransports(ini: TMemIniFile);
    procedure LoadTransportsData(Data: TStringList);
    procedure LoadProxyPorts(PortControl: TUpdown; HostControl: TCombobox; EnabledControl: TCheckBox; ini: TMemIniFile);
    procedure SaveReachableAddresses(ini: TMemIniFile);
    procedure SaveProxyData(ini: TMemIniFile);
    procedure SaveTransportsData(ini: TMemIniFile; ReloadServerTransport: Boolean);
    procedure SaveBridgesData(ini: TMemIniFile = nil);
    procedure SaveFallbackDirsData(ini: TMemIniFile = nil; UseDic: Boolean = False; FastUpdate: Boolean = False);
    procedure SaveFallbackDirs;
    procedure SetTransportsList(var ls: TStringList);
    procedure LimitBridgesList(var Data: TStringList; AutoSave: Boolean);
    procedure ExcludeUnsuitableBridges(var Data: TStringList; DeleteUnsuitable: Boolean = False);
    procedure ExcludeUnsuitableFallbackDirs(var Data: TStringList);
    procedure SetButtonGlyph(ls: TImageList; Index: Integer; Button: TSpeedButton);
    procedure LoadStaticArray(Data: array of TStaticPair);
    procedure ResetOptions;
    procedure LoadUserOverrides(ini: TMemIniFile);
    procedure RestartTor(RestartCode: Byte = 0);
    procedure UpdateSystemInfo;
    procedure RestoreForm;
    procedure SelectHs;
    procedure SelectHsPorts;
    procedure SelectTransports;
    procedure CheckCircuitsControls(UpdateAll: Boolean = True);
    procedure CheckStreamsControls;
    procedure ChangeCircuit(DirectClick: Boolean = True);
    procedure SendCommand(const cmd: string);
    procedure CheckSelectRowOptions(aSg: TStringGrid; Checked: Boolean; Save: Boolean = False);
    procedure SetButtonsProp(Btn: TSpeedButton; LeftSmall, LeftBig: Integer);
    procedure ShowBalloon(Msg: string; Title: string = ''; Notice: Boolean = False; MsgType: TMsgType = mtInfo);
    procedure ShowCircuits(AlwaysUpdate: Boolean = True);
    procedure ShowStreams(CircID: string);
    procedure ShowStreamsInfo(CircID, TargetStr: string);
    procedure ShowCircuitInfo(CircID: string);
    procedure ShowRouters;
    function FindSelectedBridge(RouterID: string; Router: TRouterInfo): Boolean;
    procedure CheckNodesListState(NodeTypeID: Integer);
    procedure CheckCircuitExists(CircID: string; UpdateStreamsCount: Boolean = False);
    procedure CheckCircuitStreams(CircID: string; TargetStreams: Integer);
    procedure SelectRowPopup(aSg: TStringGrid; aPopup: TPopupMenu);
    procedure SaveTrackHostExits(ini: TMemIniFile; UseDic: Boolean = False);
    procedure SaveServerOptions(ini: TMemIniFile);
    procedure SetOptionsEnable(State: Boolean);
    procedure PrepareOpenDialog(FileName, Filter: string);    
    procedure StartTor(AutoResolveErrors: Boolean = False);
    procedure StopTor;
    procedure UpdateTrayIcon;
    procedure UpdateConnectProgress(Value: Integer);
    procedure UpdateConnectControls;
    procedure SetSortMenuData(aSg: TStringGrid);
    procedure SetCustomFilterStyle(CustomFilterID: Integer);
    procedure ResetGuards(GuardType: TGuardType);
    procedure MyFamilyEnable(State: Boolean);
    procedure FastAndStableEnable(State: Boolean; AutoCheck: Boolean = True);
    procedure HsControlsEnable(State: Boolean);
    procedure CheckLogAutoScroll(AlwaysUpdate: Boolean = False);
    procedure UpdateHs;
    procedure UpdateHsPorts;
    procedure UpdateUsedProxyTypes(ini: TMemIniFile);
    procedure UpdateTransports;
    procedure UseDirPortEnable(State: Boolean);
    procedure SaveSortData;
    procedure UpdateScaleFactor;
    function RoutersAutoSelect: Boolean;
    procedure CheckTorAutoStart;
    procedure UpdateSelectedRouter;
    procedure UpdateTrayHint;
    function ShowRelayInfo(aSg: TStringGrid; Handle: Boolean = False): Boolean;
    procedure CountTotalBridges(ShowSuitableCount: Boolean = True);
    procedure CountTotalFallbackDirs(ShowSuitableCount: Boolean = True);
    function PrepareNodesToRemove(Data: string; NodeType: TNodeType; out Nodes: ArrOfNodes): Boolean;
    procedure RemoveFromNodesListWithConvert(Nodes: ArrOfNodes; NodeType: TNodeType);
    procedure SortPrepare(aSg: TStringGrid; ACol: Integer; ManualSort: Boolean = False);
    procedure GridSort(aSg: TStringGrid);
    procedure SetExtractOptions(Sender: TObject);
    procedure SetExtractDelimiter(Sender: TObject);
    procedure ServerControlsChange(Sender: TObject);
    procedure ExtractDataClick(Sender: TObject);
    procedure SortDataList(Sender: TObject);
    procedure SelectLogAutoDelInterval(Sender: TObject);
    procedure SelectLogSeparater(Sender: TObject);
    procedure SelectLogScrollbar(Sender: TObject);
    procedure StartScannerManual(Sender: TObject);
    procedure SelectCircuitsSort(Sender: TObject);
    procedure ShowTrafficSelect(Sender: TObject);
    procedure SelectStreamsSort(Sender: TObject);
    procedure SelectStreamsInfoSort(Sender: TObject);
    procedure ClearScannerCacheClick(Sender: TObject);
    procedure lbStatusProxyAddrClick(Sender: TObject);
    procedure EditMenuClick(Sender: TObject);
    procedure ConnectOnStartupTimer(Sender: TObject);
    procedure CursorStopTimer(Sender: TObject);
    procedure RestartTimer(Sender: TObject);
    procedure SetCircuitsFilter(Sender: TObject);
    procedure RoutersAutoSelectClick(Sender: TObject);
    procedure ClearFilterClick(Sender: TObject);
    procedure ClearRoutersClick(Sender: TObject);
    procedure SetRoutersFilter(Sender: TObject);
    procedure SetRoutersFilterState(Sender: TObject);
    procedure SetLogScrollBar(ScrollType: Byte; Menu: TMenuItem = nil);
    procedure EditMenuPopup(Sender: TObject);
    procedure FilterDeleteClick(Sender: TObject);
    procedure FilterLoadClick(Sender: TObject);
    procedure SelectNodeAsBridge(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormMinimize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbExitCountryDblClick(Sender: TObject);
    procedure lbExitMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure lbServerInfoMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure EditChange(Sender: TObject);
    procedure SpinChanging(Sender: TObject; var AllowChange: Boolean);
    procedure SetCircuitsUpdateInterval(Sender: TObject);
    procedure MainButtonssMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure AddToNodesListClick(Sender: TObject);
    procedure RemoveFromNodeListClick(Sender: TObject);
    procedure ScanThreadTerminate(Sender: TObject);
    procedure LogThreadTerminate(Sender: TObject);
    procedure VersionCheckerThreadTerminate(Sender: TObject);
    procedure ControlThreadTerminate(Sender: TObject);
    procedure TConsensusThreadTerminate(Sender: TObject);
    procedure TDescriptorsThreadTerminate(Sender: TObject);
    procedure btnApplyOptionsClick(Sender: TObject);
    procedure btnCancelOptionsClick(Sender: TObject);
    procedure btnCreateProfileClick(Sender: TObject);
    procedure cbEnableNodesListClick(Sender: TObject);
    procedure cbHsMaxStreamsClick(Sender: TObject);
    procedure cbLearnCircuitBuildTimeoutClick(Sender: TObject);
    procedure cbShowBalloonHintClick(Sender: TObject);
    procedure cbStayOnTopClick(Sender: TObject);
    procedure cbUseTrackHostExitsClick(Sender: TObject);
    procedure cbUseBridgesClick(Sender: TObject);
    procedure cbUseProxyClick(Sender: TObject);
    procedure cbxHsAddressChange(Sender: TObject);
    procedure cbxHsVersionChange(Sender: TObject);
    procedure cbxProxyTypeChange(Sender: TObject);
    procedure cbxProxyHostDropDown(Sender: TObject);
    procedure edHsChange(Sender: TObject);
    procedure edTransportsChange(Sender: TObject);
    procedure edReachableAddressesKeyPress(Sender: TObject; var Key: Char);
    procedure imGeneratePasswordClick(Sender: TObject);
    procedure imUPnPTestClick(Sender: TObject);
    procedure lbUserDirClick(Sender: TObject);
    procedure meNodesListChange(Sender: TObject);
    procedure meTrackHostExitsChange(Sender: TObject);
    procedure MetricsInfo(Sender: TObject);
    procedure miAutoClearClick(Sender: TObject);
    procedure miChangeCircuitClick(Sender: TObject);
    procedure miClearDNSCacheClick(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure miHsDeleteClick(Sender: TObject);
    procedure miHsInsertClick(Sender: TObject);
    procedure miOpenFileLogClick(Sender: TObject);
    procedure miDetailsRelayInfoClick(Sender: TObject);
    procedure miSaveTemplateClick(Sender: TObject);
    procedure miServerInfoClick(Sender: TObject);
    procedure miShowLogClick(Sender: TObject);
    procedure miShowOptionsClick(Sender: TObject);
    procedure miShowStatusClick(Sender: TObject);
    procedure miSwitchTorClick(Sender: TObject);
    procedure miWriteLogFileClick(Sender: TObject);
    procedure mnDetailsPopup(Sender: TObject);
    procedure mnFilterPopup(Sender: TObject);
    procedure mnHsPopup(Sender: TObject);
    procedure mnLogPopup(Sender: TObject);
    procedure SelectorMenuClick(Sender: TObject);
    procedure sgFilterDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgFilterKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sgFilterKeyPress(Sender: TObject; var Key: Char);
    procedure sgFilterMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure sgHsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgHsMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure sgHsPortsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgHsPortsMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure sgHsPortsSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure sgHsSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure tiTrayClick(Sender: TObject);
    procedure tmUpdateIpTimer(Sender: TObject);
    procedure udHsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure miHsClearClick(Sender: TObject);
    procedure edControlPasswordDblClick(Sender: TObject);
    procedure miHsCopyOnionClick(Sender: TObject);
    procedure miHsOpenDirClick(Sender: TObject);
    procedure miStatAggregateClick(Sender: TObject);
    procedure sgFilterMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure sgFilterSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure cbEnableSocksClick(Sender: TObject);
    procedure sgRoutersDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure miShowRoutersClick(Sender: TObject);
    procedure sgRoutersFixedCellClick(Sender: TObject; ACol, ARow: Integer);
    procedure btnShowNodesClick(Sender: TObject);
    procedure cbeRoutersCountrySelect(Sender: TObject);
    procedure cbxRoutersCountryEnter(Sender: TObject);
    procedure udRoutersWeightClick(Sender: TObject; Button: TUDBtnType);
    procedure edRoutersWeightKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sgFilterFixedCellClick(Sender: TObject; ACol, ARow: Integer);
    procedure tmConsensusTimer(Sender: TObject);
    procedure miFilterHideUnusedClick(Sender: TObject);
    procedure miFilterScrollTopClick(Sender: TObject);
    procedure sgRoutersKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sgRoutersSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure sgRoutersMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure sgRoutersDblClick(Sender: TObject);
    procedure CopyCaptionToClipboard(Sender: TObject);
    procedure mnRoutersPopup(Sender: TObject);
    procedure miRtRelayInfoClick(Sender: TObject);
    procedure sgRoutersMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure sgRoutersKeyPress(Sender: TObject; var Key: Char);
    procedure paRoutersClick(Sender: TObject);
    procedure lbClientVersionClick(Sender: TObject);
    procedure meMyFamilyChange(Sender: TObject);
    procedure tmCircuitsTimer(Sender: TObject);
    procedure sgCircuitsSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure miFilterSelectRowClick(Sender: TObject);
    procedure miRoutersSelectRowClick(Sender: TObject);
    procedure miRoutersScrollTopClick(Sender: TObject);
    procedure sgCircuitsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgCircuitsMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure mnCircuitsPopup(Sender: TObject);
    procedure sgStreamsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgCircuitInfoDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgCircuitInfoDblClick(Sender: TObject);
    procedure sgCircuitInfoMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure sgCircuitInfoSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure sgCircuitsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sgStreamsSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure sgStreamsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sgCircuitInfoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure miDestroyCircuitClick(Sender: TObject);
    procedure miDestroyStreamsClick(Sender: TObject);
    procedure sgCircuitInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure sgCircuitsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure mnChangeCircuitPopup(Sender: TObject);
    procedure sgStreamsMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure miShowCircuitsClick(Sender: TObject);
    procedure sgHsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sgHsPortsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sgHsPortsEnter(Sender: TObject);
    procedure sgHsEnter(Sender: TObject);
    procedure meBridgesChange(Sender: TObject);
    procedure OptionsChange(Sender: TObject);
    procedure SetResetGuards(Sender: TObject);
    procedure cbxHsAddressDropDown(Sender: TObject);
    procedure miRtSaveDefaultClick(Sender: TObject);
    procedure miRtResetFilterClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure miDetailsUpdateIpClick(Sender: TObject);
    procedure ShowFavoritesRouters(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure cbDirCacheMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure cbUseOpenDNSClick(Sender: TObject);
    procedure cbUseOpenDNSOnlyWhenUnknownClick(Sender: TObject);
    procedure miHideCircuitsWithoutStreamsClick(Sender: TObject);
    procedure miAlwaysShowExitCircuitClick(Sender: TObject);
    procedure sgStreamsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure mnStreamsPopup(Sender: TObject);
    procedure miStreamsDestroyStreamClick(Sender: TObject);
    procedure miStreamsOpenInBrowserClick(Sender: TObject);
    procedure BindToExitNodeClick(Sender: TObject);
    procedure cbUseHiddenServiceVanguardsClick(Sender: TObject);
    procedure miLoadCachedRoutersOnStartupClick(Sender: TObject);
    procedure miUpdateIpToCountryCacheClick(Sender: TObject);
    procedure cbUseReachableAddressesClick(Sender: TObject);
    procedure miSelectExitCircuitWhenItChangesClick(Sender: TObject);
    procedure sgStreamsFixedCellClick(Sender: TObject; ACol, ARow: Integer);
    procedure sgCircuitsFixedCellClick(Sender: TObject; ACol, ARow: Integer);
    procedure sbShowOptionsClick(Sender: TObject);
    procedure sbShowLogClick(Sender: TObject);
    procedure sbShowStatusClick(Sender: TObject);
    procedure sbShowCircuitsClick(Sender: TObject);
    procedure sbShowRoutersClick(Sender: TObject);
    procedure sbShowCircuitsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure paButtonsDblClick(Sender: TObject);
    procedure cbxThemesDropDown(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnSwitchTorClick(Sender: TObject);
    procedure sbDecreaseFormClick(Sender: TObject);
    procedure lbExitIpMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure edRoutersQueryKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure miAboutClick(Sender: TObject);
    procedure meNodesListExit(Sender: TObject);
    procedure cbxAuthMetodChange(Sender: TObject);
    procedure cbxThemesChange(Sender: TObject);
    procedure cbxRoutersCountryChange(Sender: TObject);
    procedure cbxRoutersQueryChange(Sender: TObject);
    procedure cbxNodesListTypeChange(Sender: TObject);
    procedure miClearRoutersAbsentClick(Sender: TObject);
    procedure sgFilterExit(Sender: TObject);
    procedure miClearRoutersIncorrectClick(Sender: TObject);
    procedure sbShowRoutersMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure sgStreamsInfoSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure sgStreamsInfoMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure sgStreamsInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure sgStreamsInfoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure miTplSaveClick(Sender: TObject);
    procedure miTplLoadClick(Sender: TObject);
    procedure mnShowNodesChange(Sender: TObject; Source: TMenuItem; Rebuild: Boolean);
    procedure miIgnoreTplLoadParamsOutsideTheFilterClick(Sender: TObject);
    procedure miNotLoadEmptyTplDataClick(Sender: TObject);
    procedure sbShowOptionsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure miGetBridgesSiteClick(Sender: TObject);
    procedure miGetBridgesEmailClick(Sender: TObject);
    procedure miDestroyExitCircuitsClick(Sender: TObject);
    procedure miCircuitsUpdateNowClick(Sender: TObject);
    procedure sgStreamsInfoDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgStreamsInfoFixedCellClick(Sender: TObject; ACol, ARow: Integer);
    procedure miStreamsInfoDestroyStreamClick(Sender: TObject);
    procedure mnStreamsInfoPopup(Sender: TObject);
    procedure miShowStreamsInfoClick(Sender: TObject);
    procedure cbNoDesktopBordersClick(Sender: TObject);
    procedure FindDialogFind(Sender: TObject);
    procedure sgStreamsDblClick(Sender: TObject);
    procedure tmScannerTimer(Sender: TObject);
    procedure cbEnablePingMeasureClick(Sender: TObject);
    procedure cbEnableDetectAliveNodesClick(Sender: TObject);
    procedure miClearServerCacheClick(Sender: TObject);
    procedure mnShowNodesPopup(Sender: TObject);
    procedure cbAutoScanNewNodesClick(Sender: TObject);
    procedure edRoutersQueryChange(Sender: TObject);
    procedure miRoutersShowFlagsHintClick(Sender: TObject);
    procedure cbxHsStateChange(Sender: TObject);
    procedure sgTransportsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure sgTransportsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sgTransportsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure miTransportsOpenDirClick(Sender: TObject);
    procedure mnTransportsPopup(Sender: TObject);
    procedure miTransportsResetClick(Sender: TObject);
    procedure sgTransportsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure miTransportsInsertClick(Sender: TObject);
    procedure miTransportsDeleteClick(Sender: TObject);
    procedure miTransportsClearClick(Sender: TObject);
    procedure btnChangeCircuitClick(Sender: TObject);
    procedure cbxTransportTypeChange(Sender: TObject);
    procedure cbxBridgesListChange(Sender: TObject);
    procedure cbxBridgesTypeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbxBridgesListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbxNodesListTypeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbxBridgesListCloseUp(Sender: TObject);
    procedure miRequestIPv6BridgesClick(Sender: TObject);
    procedure miRequestObfuscatedBridgesClick(Sender: TObject);
    procedure miGetBridgesTelegramClick(Sender: TObject);
    procedure miPreferWebTelegramClick(Sender: TObject);
    procedure miClearMenuNotAliveClick(Sender: TObject);
    procedure ClearAvailableCache(Sender: TObject);
    procedure cbUsePreferredBridgeClick(Sender: TObject);
    procedure miDisableSelectionUnSuitableAsBridgeClick(Sender: TObject);
    procedure miRtDisableBridgesClick(Sender: TObject);
    procedure edPreferredBridgeChange(Sender: TObject);
    procedure btnFindPreferredBridgeClick(Sender: TObject);
    procedure ClearBridgesCache(Sender: TObject);
    procedure miResetTotalsCounterClick(Sender: TObject);
    procedure miResetScannerScheduleClick(Sender: TObject);
    procedure miDisableFiltersOnUserQueryClick(Sender: TObject);
    procedure miStopScanClick(Sender: TObject);
    procedure miDisableFiltersOnAuthorityOrBridgeClick(Sender: TObject);
    procedure miClearUnusedNetworkCacheClick(Sender: TObject);
    procedure miEnableConvertNodesOnIncorrectClearClick(Sender: TObject);
    procedure miEnableConvertNodesOnAddToNodesListClick(Sender: TObject);
    procedure miIgnoreConvertExcludeNodesClick(Sender: TObject);
    procedure miConvertIpNodesClick(Sender: TObject);
    procedure miConvertCidrNodesClick(Sender: TObject);
    procedure miConvertCountryNodesClick(Sender: TObject);
    procedure miAvoidAddingIncorrectNodesClick(Sender: TObject);
    procedure edRoutersWeightMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure miEnableConvertNodesOnRemoveFromNodesListClick(Sender: TObject);
    procedure miManualPingMeasureClick(Sender: TObject);
    procedure miManualDetectAliveNodesClick(Sender: TObject);
    procedure AutoSelOptionsUpdate(Sender: TObject);
    procedure pbTrafficPaint(Sender: TObject);
    procedure SelectTrafficPeriod(Sender: TObject);
    procedure tmTrafficTimer(Sender: TObject);
    procedure miSelectGraphDLClick(Sender: TObject);
    procedure miSelectGraphULClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure cbEnableHttpClick(Sender: TObject);
    procedure lbStatusProxyAddrMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure SelectCheckIpProxy(Sender: TObject);
    procedure miOpenLogsFolderClick(Sender: TObject);
    procedure lbStatusFilterModeClick(Sender: TObject);
    procedure miExcludeBridgesWhenCountingClick(Sender: TObject);
    procedure miShowPortAlongWithIpClick(Sender: TObject);
    procedure mnTrafficPopup(Sender: TObject);
    procedure miEnableTotalsCounterClick(Sender: TObject);
    procedure ShowTimerEvent(Sender: TObject);
    procedure pbScanProgressMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cbExcludeUnsuitableBridgesClick(Sender: TObject);
    procedure edReachableAddressesChange(Sender: TObject);
    procedure miClearMenuUnsuitableClick(Sender: TObject);
    procedure cbUseBridgesLimitClick(Sender: TObject);
    procedure cbCacheNewBridgesClick(Sender: TObject);
    procedure meLogMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cbxBridgesPriorityChange(Sender: TObject);
    procedure edReachableAddressesExit(Sender: TObject);
    procedure meBridgesExit(Sender: TObject);
    procedure edReachableAddressesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edPreferredBridgeExit(Sender: TObject);
    procedure edPreferredBridgeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure meBridgesKeyPress(Sender: TObject; var Key: Char);
    procedure edBridgesLimitChange(Sender: TObject);
    procedure imBridgesFileClick(Sender: TObject);
    procedure cbxBridgesTypeChange(Sender: TObject);
    procedure edBridgesFileKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edBridgesFileExit(Sender: TObject);
    procedure edBridgesFileChange(Sender: TObject);
    procedure miClearMenuAllClick(Sender: TObject);
    procedure udBridgesLimitClick(Sender: TObject; Button: TUDBtnType);
    procedure meFallbackDirsChange(Sender: TObject);
    procedure cbUseFallbackDirsClick(Sender: TObject);
    procedure meFallbackDirsExit(Sender: TObject);
    procedure meFallbackDirsKeyPress(Sender: TObject; var Key: Char);
    procedure cbxFallbackDirsTypeChange(Sender: TObject);
    procedure meNodesListKeyPress(Sender: TObject; var Key: Char);
    procedure cbExcludeUnsuitableFallbackDirsClick(Sender: TObject);
    procedure miCircuitsShowFlagsHintClick(Sender: TObject);
    procedure sbAutoScrollClick(Sender: TObject);
    procedure sbWordWrapClick(Sender: TObject);
    procedure sbSafeLoggingClick(Sender: TObject);
    procedure cbxLogLevelChange(Sender: TObject);
    procedure sbUseLinesLimitClick(Sender: TObject);
    procedure udLinesLimitClick(Sender: TObject; Button: TUDBtnType);
    procedure edLinesLimitKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edLinesLimitMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cbxFallbackDirsTypeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbxTrayIconTypeChange(Sender: TObject);
    procedure lbSelectedRoutersMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbShowLogMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    procedure WMExitSizeMove(var msg: TMessage); message WM_EXITSIZEMOVE;
    procedure WMDpiChanged(var msg: TWMDpi); message WM_DPICHANGED;
    procedure WMQueryEndSession(var Message: TWMQueryEndSession); message WM_QUERYENDSESSION;
    procedure WMEndSession(var Message: TWMEndSession); message WM_ENDSESSION;
  end;

var
  Tcp: TTcp;
  TorConfig, RandomBridges: TStringList;
  CountryTotals: array [0..MAX_TOTALS - 1, 0..MAX_COUNTRIES - 1] of Integer;
  SpeedData: array [0..MAX_SPEED_DATA_LENGTH - 1] of TSpeedData;
  DirFetches: TDictionary<string, TFetchInfo>;
  RoutersDic: TDictionary<string, TRouterInfo>;
  FilterDic: TDictionary<string, TFilterInfo>;
  GeoIpDic: TDictionary<string, TGeoIpInfo>;
  NodesDic: TDictionary<string, TNodeTypes>;
  CircuitsDic: TDictionary<string, TCircuitInfo>;
  StreamsDic: TDictionary<string, TStreamInfo>;
  TrackHostDic: TDictionary<string, Byte>;
  VersionsDic: TDictionary<string, Byte>;
  TransportsDic: TDictionary<string, TTransportInfo>;
  TransportsList: TDictionary<string, Byte>;
  BridgesDic: TDictionary<string, TBridgeInfo>;
  CidrsDic: TDictionary<string, TCidrInfo>;
  PortsDic: TDictionary<Word, Byte>;
  ConstDic: TDictionary<string, Integer>;
  DefaultsDic: TDictionary<string, string>;
  NewBridgesList: TDictionary<string, string>;
  UsedBridgesList: TDictionary<string, Byte>;
  CompBridgesDic: TDictionary<string, string>;
  UsedFallbackDirs: TDictionary<string, string>;

  ProgramDir, UserDir, HsDir, ThemesDir, TransportsDir, OnionAuthDir, LogsDir: string;
  DefaultsFile, UserConfigFile, UserBackupFile, TorConfigFile, TorStateFile, TorLogFile,
  TorExeFile, GeoIpFile, GeoIpv6File, NetworkCacheFile, BridgesCacheFile, BridgesFileName,
  UserProfile, LangFile, ConsensusFile, DescriptorsFile, NewDescriptorsFile, TrayIconFile: string;
  ControlPassword, SelectedNode, SearchStr, UPnPMsg, GeoFileID, TorFileID, BridgeFileID, TorrcFileID, DefaultsFileID: string;
  Circuit, LastRoutersFilter, LastPreferBridgeID, ExitNodeID, ServerIPv4, ServerIPv6, TorVersion: string;
  jLimit: TJobObjectExtendedLimitInformation;
  TorVersionProcess, TorMainProcess: TProcessInfo;
  hJob: THandle;
  DLSpeed, ULSpeed, MaxDLSpeed, MaxULSpeed, CurrentTrafficPeriod, LogAutoDelHours: Integer;
  SessionDL, SessionUL, TotalDL, TotalUL: Int64;
  ConnectState, StopCode, FormSize, LastPlace, InfoStage, GetIpStage, NodesListStage, NewBridgesStage: Byte;
  EncodingNoBom: TUTF8EncodingNoBOM;
  SearchTimer, LastCountriesHash, LastFallbackDirsHash: Cardinal;
  DecFormPos, IncFormPos, IncFormSize: TPoint;
  RoutersCustomFilter, LastRoutersCustomFilter, RoutersFilters, LastFilters: Integer;
  GeoIpExists, FirstLoad, Restarting, Closing, WindowsShutdown, CursorShow, GeoIpUpdating, GeoIpModified, ServerIsObfs4: Boolean;
  CursorStop, StartTimer, RestartTimeout, ShowTimer: TTimer;
  Controller: TControlThread;
  Consensus: TConsensusThread;
  Descriptors: TDescriptorsThread;
  Logger, VersionChecker: TReadPipeThread;
  OptionsLocked, OptionsChanged, ShowNodesChanged, Connected, AlreadyStarted, SearchFirst, StopScan, LogHasSel: Boolean;
  ConsensusUpdated, FilterUpdated, RoutersUpdated, ExcludeUpdated, OpenDNSUpdated, LanguageUpdated,
  BridgesUpdated, BridgesRecalculate, BridgesFileUpdated, BridgesFileNeedSave: Boolean;
  SelectExitCircuit, TotalsNeedSave: Boolean;
  SupportVanguardsLite, SupportRendPostPeriod: Boolean;
  FallbackDirsRecalculate, FallbackDirsUpdated: Boolean;
  Scale: Real;
  HsToDelete: ArrOfStr;
  SystemLanguage: Word;
  LastAuthCookieDate, LastConsensusDate, LastNewDescriptorsDate: TDateTime;
  LastFullScanDate, LastPartialScanDate, TotalStartDate, LastSaveStats: Int64;
  LastPartialScansCounts: Integer;
  LockCircuits, LockCircuitInfo, LockStreams, LockStreamsInfo, UpdateTraffic: Boolean;
  CircuitsUpdated, SortUpdated, SelNodeState: Boolean;
  FindObject: TMemo;
  ScanStage, AutoScanStage: Byte;
  CurrentScanType, InitScanType: TScanType;
  CurrentScanPurpose, CurrentAutoScanPurpose: TScanPurpose;
  ScanThreads, CurrentScans, TotalScans, AliveNodesCount, PingNodesCount, ConnectProgress: Integer;
  SuitableBridgesCount, UnknownBridgesCountriesCount, FailedBridgesCount, FailedBridgesInterval, NewBridgesCount, UsedBridgesCount: Integer;
  SuitableFallbackDirsCount, UsedFallbackDirsCount, UnknownFallbackDirCountriesCount, MissingFallbackDirCount: Integer;
  Scanner: TScanThread;
  UsedProxyType: TProxyType;
  LastUserStreamProtocol, LastTrayIconType, ExtractDelimiterType: Integer;
  FindBridgesCountries, FindFallbackDirCountries, ScanNewBridges, UpdateFallbackDirs: Boolean;
  FormatIPv6OnExtract, RemoveDuplicateOnExtract, SortOnExtract, FormatCodesOnExtract: Boolean;

implementation

{$R *.dfm}
{$R TorControlPanel.icons.res}

procedure TTcp.WMQueryEndSession(var Message: TWMQueryEndSession);
begin
  WindowsShutdown := True;
  inherited;
end;

procedure TTcp.WMEndSession(var Message: TWMEndSession);
begin
  WindowsShutdown := Message.EndSession;
  inherited;
end;

procedure TTcp.WMExitSizeMove(var msg: TMessage);
begin
  SetDesktopPosition(Tcp.Left, Tcp.Top)
end;

procedure TTcp.WMDpiChanged(var msg: TWMDpi);
begin
  inherited;
  UpdateScaleFactor;
  UpdateFormSize;
end;

procedure TTcp.SendCommand(const cmd: string);
begin
  if Assigned(Controller) then
    Controller.SendData(cmd);
end;

procedure TTcp.LogThreadTerminate(Sender: TObject);
begin
  Logger := nil;
end;

procedure TTcp.VersionCheckerThreadTerminate(Sender: TObject);
begin
  VersionChecker := nil;
end;

constructor TPing.Create(Timeout: Integer);
begin
  inherited Create;
  FTimeout := Timeout;
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

procedure TReadPipeThread.UpdateVersionInfo;
var
  ParseStr: ArrOfStr;
  ini: TMemIniFile;
begin
  ParseStr := Explode(BR, Data);
  TorVersion := SeparateLeft(SeparateRight(ParseStr[0], 'Tor version ').Trim(['.']), ' ');
  if ValidAddress(SeparateLeft(TorVersion, '-')) = atIPv4 then
  begin
    ini := TMemIniFile.Create(UserConfigFile, TEncoding.UTF8);
    try
      TorFileID := GetFileID(TorExeFile, True, TorVersion);
      SetSettings('Main', 'TorFileID', TorFileID, ini);
    finally
      UpdateConfigFile(ini);
    end;
  end
  else
    TorVersion := '0.0.0.0';
  Tcp.LoadOptions(FirstStart);
  Terminate;
end;

procedure TReadPipeThread.UpdateLog;
var
  SelStart, SelLength, DelLength, CharFromPos: Integer;
  LinesCount, DeleteLines, MaxLines, i: Integer;
  ls: TStringList;
  Caret: TPoint;
begin
  if Tcp.sbUseLinesLimit.Down then
    MaxLines := Tcp.udLinesLimit.Position
  else
    MaxLines := $40000000;
  LinesCount := Tcp.meLog.Lines.Count;
  if LinesCount > MaxLines then
    ls := TStringList.Create
  else
    ls := nil;
  try
    if Assigned(ls) then
    begin
      DelLength := 0;
      SelStart := Tcp.meLog.SelStart;
      SelLength := Tcp.meLog.SelLength;
      DeleteLines := Round(LinesCount * 0.10);
      ls.Text := Tcp.meLog.Text;
      for i := DeleteLines - 1 downto 0 do
      begin
        Inc(DelLength, Length(ls[i]));
        ls.Delete(i);
      end;
      Inc(DelLength, DeleteLines * 2);
      Tcp.meLog.Text := ls.Text;
      if (SelStart - DelLength) > 0 then
      begin
        Tcp.meLog.SelStart := SelStart - DelLength;
        Tcp.meLog.SelLength := SelLength;
      end
      else
        LogHasSel := False;
    end;

    if Tcp.sbAutoScroll.Down and not LogHasSel then
      Tcp.meLog.Lines.Add(Data)
    else
    begin
      GetCaretPos(Caret);
      CharFromPos := SendMessage(Tcp.meLog.Handle, EM_CHARFROMPOS, 0, Caret.Y * $FFFF + Caret.X) AND $FFFF;
      SelStart := Tcp.meLog.SelStart;
      SelLength := Tcp.meLog.SelLength;
      Tcp.meLog.Lines.BeginUpdate;
      Tcp.meLog.Lines.Add(Data);
      Tcp.meLog.Lines.EndUpdate;

      if SelStart <> CharFromPos then
      begin
        Tcp.meLog.SelStart := SelStart;
        if SelLength > 0 then
          Tcp.meLog.SelLength := SelLength;
      end
      else
      begin
        Tcp.meLog.SelStart := SelStart + SelLength;
        Tcp.meLog.SelLength := - SelLength;
      end;
    end;

  finally
    ls.Free;
  end;

  if Tcp.miWriteLogFile.Checked then
    SaveToLog(Data, TorLogFile);

  if ConnectState = 1 then
  begin
    if Pos('Reading config failed', Data) <> 0 then
      StopCode := STOP_CONFIG_ERROR;
  end;
end;

procedure TReadPipeThread.Execute;
begin
  while not Terminated do
  begin
    if PeekNamedPipe(hStdOut, nil, 0, nil, @DataSize, nil) then
    begin
      if DataSize > 0 then
      begin
        Buffer := AllocMem(DataSize + 1);
        if ReadFile(hStdOut, Buffer^, DataSize, dwRead, nil) then
        begin
          Data := Trim(string(Buffer));
          Data := StringReplace(Data, CR + BR, BR, [rfReplaceAll]);
          Data := StringReplace(Data, BR + BR, BR, [rfReplaceAll]);
          if Data <> '' then
          begin
            if VersionCheck then
              Synchronize(UpdateVersionInfo)
            else
              Synchronize(UpdateLog);
          end;
        end;
        FreeMem(Buffer);
      end;
    end
    else
    begin
      if GetLastError = ERROR_BROKEN_PIPE then
      begin
        if VersionCheck and (TorVersion = '') then
        begin
          Data := '';
          Synchronize(UpdateVersionInfo)
        end
        else
          Terminate;
      end;
    end;
    Sleep(1);
  end;
end;

procedure TDNSSendThread.UpdateIpStage;
begin
  ServerIPv4 := Temp;
  if ConnectState = 2 then
    GetIpStage := 2
  else
  begin
    GetIpStage := 0;
    Tcp.UpdateServerInfo;
  end;
end;

procedure TDNSSendThread.Execute;
var
  DNS: TDNSSend;
  ls: TStringList;
begin
  DNS := TDNSSend.Create;
  ls := TStringList.Create;
  try
    DNS.TargetHost := 'resolver1.opendns.com';
    DNS.DNSQuery('myip.opendns.com', QTYPE_A, ls);
    Temp := Trim(ls.Text);
    Synchronize(UpdateIpStage);
  finally
    DNS.Free;
    ls.Free;
  end;
end;

procedure TSendHttpThread.Execute;
var
  Http: THTTPSend;
  UseSocks, SocksEnabled: Boolean;
begin
  SocksEnabled := UsedProxyType in [ptSocks, ptBoth];
  if Tcp.miCheckIpProxyAuto.Checked then
  begin
    if Circuit = '' then
      UseSocks := SocksEnabled
    else
      UseSocks := (LastUserStreamProtocol in [SOCKS4, SOCKS5]);
  end
  else
    UseSocks := SocksEnabled and Tcp.miCheckIpProxySocks.Checked;
  Http := THTTPSend.Create;
  try
    if UseSocks then
    begin
      Http.Sock.SocksType := ST_Socks5;
      Http.Sock.SocksIP := GetHost(Tcp.cbxSOCKSHost.Text);
      Http.Sock.SocksPort := IntToStr(Tcp.udSOCKSPort.Position);
    end
    else
    begin
      Http.ProxyHost := GetHost(Tcp.cbxHTTPTunnelHost.Text);
      Http.ProxyPort := IntToStr(Tcp.udHTTPTunnelPort.Position);
    end;
    Http.HTTPMethod('HEAD', GetDefaultsValue('CheckUrl', CHECK_URL));
  finally
    Http.Free;
  end;
end;

procedure TScanItemThread.Execute;
var
  GeoIpInfo: TGeoIpInfo;
  i: Integer;
begin
  try
    if ScanType = stPing then
    begin
      for i := 1 to MaxPingAttempts do
      begin
        if StopScan then
          Exit;
        Result := SendPing(IpStr, PingTimeOut);
        if Result <> -1 then
          Break;
        if i <> MaxPingAttempts then
          Sleep(AttemptsDelay);
      end;
      if GeoIpDic.TryGetValue(IpStr, GeoIpInfo) then
      begin
        GeoIpInfo.ping := Result;
        GeoIpDic.AddOrSetValue(IpStr, GeoIpInfo);
      end
      else
      begin
        GeoIpInfo.ping := Result;
        GeoIpInfo.ports := '';
        GeoIpInfo.cc := DEFAULT_COUNTRY_ID;
        GeoIpDic.AddOrSetValue(IpStr, GeoIpInfo);
      end;
      GeoIpModified := True;
    end;

    if ScanType = stAlive then
    begin
      for i := 1 to MaxPortAttempts do
      begin
        if StopScan then
          Exit;
        if PortTCPIsOpen(Port, IpStr, PortTimeout) then
        begin
          Result := 1;
          Break;
        end
        else
          Result := -1;
        if i <> MaxPortAttempts then
          Sleep(AttemptsDelay);
      end;
      SetPortsValue(IpStr, IntToStr(Port), Result);
    end;
  finally
    InterlockedDecrement(ScanThreads);
  end;
end;

procedure TTcp.ScanThreadTerminate(Sender: TObject);
begin
  Scanner := nil;
end;

procedure TScanThread.UpdateControls;
begin
  Tcp.pbScanProgress.Position := 0;
  Tcp.pbScanProgress.ProgressText := '0 %';
  Tcp.UpdateScannerControls;
end;

procedure TScanThread.Execute;
var
  MemoryStatus: TMemoryStatusEx;
  Data, ls: TStringList;
  Item: TPair<string,TRouterInfo>;
  GeoIpInfo: TGeoIpInfo;
  AvailMemoryBefore: Int64;
  NeedScan: Boolean;
  i, PortsData: Integer;
  IpToScan, IpStr: string;
  PortToScan: Word;
  Bridge: TBridge;
  FallbackDir: TFallbackDir;

  procedure AddToScanList(IpStr, PortStr: string; Flags: TRouterFlags);
  begin
    if GeoIpDic.TryGetValue(IpStr, GeoIpInfo) then
    begin
      NeedScan := False;
      PortsData := 0;
      if sScanType = stAlive then
        PortsData := GetPortsValue(GeoIpInfo.ports, PortStr);

      case sScanPurpose of
        spAll: NeedScan := True;
        spNew:
        begin
          case sScanType of
            stPing: NeedScan := GeoIpInfo.ping = 0;
            stAlive: NeedScan := PortsData = 0;
          end;
        end;
        spFailed:
        begin
          case sScanType of
            stPing: NeedScan := GeoIpInfo.ping = -1;
            stAlive: NeedScan := PortsData = -1;
          end;
        end;
        spNewAndFailed:
        begin
          case sScanType of
            stPing: NeedScan := GeoIpInfo.ping < 1;
            stAlive: NeedScan := PortsData < 1;
          end;
        end;
        spNewAndAlive:
        begin
          case sScanType of
            stPing: NeedScan := GeoIpInfo.ping = 0;
            stAlive: NeedScan := PortsData <> -1;
          end;
        end;
        spNewAndBridges:
        begin
          case sScanType of
            stPing: NeedScan := GeoIpInfo.ping = 0;
            stAlive: NeedScan := (PortsData = 0) or (rfBridge in Flags);
          end;
        end;
        spBridges: NeedScan := rfBridge in Flags;
        spGuards: NeedScan := rfGuard in Flags;
        spAlive: NeedScan := PortsData = 1;
      end;
    end
    else
      NeedScan := True;
    if NeedScan then
      ls.Append(IpStr + ':' + PortStr);
  end;

begin
  ls := TStringList.Create;
  try
    if CurrentAutoScanPurpose <> spNone then
      sScanPurpose := CurrentAutoScanPurpose;

    if sScanPurpose in [spUserBridges, spNewBridges] then
    begin
      Data := TStringList.Create;
      try
        MemoToList(Tcp.meBridges, SORT_NONE, Data);
        for i := 0 to Data.Count - 1 do
        begin
          if TryParseBridge(Data[i], Bridge, False) then
          begin
            IpStr := GetBridgeIp(Bridge);
            if sScanPurpose = spUserBridges then
              NeedScan := True
            else
            begin
              if IpStr <> '' then
              begin
                if GeoIpDic.TryGetValue(IpStr, GeoIpInfo) then
                  NeedScan := GetPortsValue(GeoIpInfo.ports, IntToStr(Bridge.Port)) = 0
                else
                  NeedScan := True;
              end
              else
                NeedScan := False;
            end;
            if NeedScan then
              ls.Append(FormatHost(IpStr) + ':' + IntToStr(Bridge.Port));
          end;
        end;
      finally
        Data.Free;
      end;
    end
    else
    begin
      if sScanPurpose = spUserFallbackDirs then
      begin
        Data := TStringList.Create;
        try
          MemoToList(Tcp.meFallbackDirs, SORT_NONE, Data);
          for i := 0 to Data.Count - 1 do
          begin
            if TryParseFallbackDir(Data[i], FallbackDir, False) then
              ls.Append(FallbackDir.IPv4 + ':' + IntToStr(FallbackDir.OrPort));
          end;
        finally
          Data.Free;
        end;
      end
      else
      begin
        for Item in RoutersDic do
          AddToScanList(Item.Value.IPv4, IntToStr(Item.Value.Port), Item.Value.Flags);
      end;
    end;

    if ls.Count > 0 then
    begin
      Synchronize(UpdateControls);
      TotalScans := ls.Count;
      i := 0;
      MemoryStatus.dwLength := SizeOf(MemoryStatus);
      GlobalMemoryStatusEx(MemoryStatus);
      AvailMemoryBefore := MemoryStatus.ullAvailVirtual;
      while not Terminated do
      begin
        if ScanThreads < sMaxThreads then
        begin
          IpToScan := GetAddressFromSocket(ls[i]);
          PortToScan := GetPortFromSocket(ls[i]);
          with TScanItemThread.Create(True) do
          begin
            IpStr := IpToScan;
            Port := PortToScan;
            ScanType := sScanType;
            MaxPortAttempts := sMaxPortAttempts;
            MaxPingAttempts := sMaxPingAttempts;
            AttemptsDelay := sAttemptsDelay;
            PingTimeout := sPingTimeout;
            PortTimeout := sPortTimeout;
            FreeOnTerminate := True;
            Priority := tpNormal;
            Start;
          end;
          CurrentScans := i + 1;
          InterlockedIncrement(ScanThreads);

          if (i = ls.Count - 1) or StopScan then
            Exit;
          Inc(i);

          GlobalMemoryStatusEx(MemoryStatus);
          if MemoryStatus.ullAvailVirtual < Round(AvailMemoryBefore * 0.2) then
            sMaxThreads := ScanThreads;
          if i mod sScanPortionSize = 0 then
            Sleep(sScanPortionTimeout);
        end
        else
          Sleep(1);
      end;
    end;
  finally
    ls.Free;
  end;
end;

procedure TTcp.CheckTorAutoStart;
begin
  if FirstLoad then
  begin
    if cbConnectOnStartup.Checked then
    begin
      StartTimer := TTimer.Create(Tcp);
      StartTimer.OnTimer := ConnectOnStartupTimer;
      StartTimer.Interval := 25;
    end;
    FirstLoad := False;
  end;
end;

procedure TTcp.ConnectOnStartupTimer(Sender: TObject);
begin
  if TorVersion <> '' then
  begin
    StartTor(True);
    FreeAndNil(StartTimer);
  end;
end;

procedure TTcp.TConsensusThreadTerminate(Sender: TObject);
begin
  Consensus := nil;
  ConsensusUpdated := False;
  if cbUseBridges.Checked then
    LoadDescriptors
  else
  begin
    if FirstLoad or (MissingFallbackDirCount > 0) or UpdateFallbackDirs then
      SaveFallbackDirs;
    if ConnectState = 0 then
    begin 
      LoadFilterTotals;
      LoadRoutersCountries;
      BridgesCheckControls;     
      ShowFilter;
      ShowRouters;
      ShowCircuits;
      CheckTorAutoStart;
    end
    else
      InfoStage := 1;
    SaveBridgesCache;
  end;
end;

procedure TTcp.TDescriptorsThreadTerminate(Sender: TObject);
begin
  Descriptors := nil;
  if UsedBridgesCount <> UsedBridgesList.Count then
    SaveBridgesData;
  if FirstLoad or (MissingFallbackDirCount > 0) or UpdateFallbackDirs then
    SaveFallbackDirs;
  if ConnectState = 0 then
  begin
    LoadFilterTotals;
    LoadRoutersCountries;
    BridgesCheckControls;
    ShowFilter;
    ShowRouters;
    ShowCircuits;
    CheckTorAutoStart;
  end
  else
    InfoStage := 1;
  SaveBridgesCache;
end;

procedure TConsensusThread.Execute;
var
  ls: TStringList;
  NeedUpdate: Boolean;
  i, j, FlagsCount: Integer;
  RouterID, FallbackStr: string;
  ParseStr, ParseFlag: ArrOfStr;
  Router: TRouterInfo;
  GeoIpInfo: TGeoIpInfo; 
  BridgeItem: TPair<string, TBridgeInfo>;
  RouterItem: TPair<string, TRouterInfo>;
  FallbackDir: TFallbackDir;
  HashItem: TPair<string, Byte>;
  BridgeInfo: TBridgeInfo;
  HashList: TDictionary<string, Byte>;
  LastRoutersCount: Integer;

  procedure RemoveMissingRouter;
  begin
    if RoutersDic.TryGetValue(HashItem.Key, Router) then
    begin
      if not UsedFallbackDirs.ContainsKey(Router.IPv4 + '|' + IntToStr(Router.Port)) then
        SetPortsValue(Router.IPv4, IntToStr(Router.Port), -1);
      RoutersDic.Remove(HashItem.Key);
    end;
  end;

  procedure RemoveMissingFallbackDir;
  begin
    if GeoIpDic.TryGetValue(FallbackDir.IPv4, GeoIpInfo) then
    begin
      if GetPortsValue(GeoIpInfo.ports, IntToStr(FallbackDir.OrPort)) <> -1 then
      begin
        SetPortsValue(FallbackDir.IPv4, IntToStr(FallbackDir.OrPort), -1);
        Inc(MissingFallbackDirCount);
      end;
    end
    else
      Inc(MissingFallbackDirCount);
  end;

begin
  if not FileExists(ConsensusFile) then
    Exit;
  VersionsDic.Clear;
  HashList := TDictionary<string, Byte>.Create;
  ls := TStringList.Create;
  try
    LastRoutersCount := RoutersDic.Count;
    for RouterItem in RoutersDic do
    begin
      if rfRelay in RouterItem.Value.Flags then
        HashList.AddOrSetValue(RouterItem.Key, 1)
      else
        HashList.AddOrSetValue(RouterItem.Key, 0);
    end;
    ls.LoadFromFile(ConsensusFile);
    for i := 0 to ls.Count - 1 do
    begin
      if Pos('r ', ls[i]) = 1 then
      begin
        ParseStr := Explode(' ', ls[i]);
        RouterID := AnsiStrToHex(decodebase64(AnsiString(ParseStr[2])));
        Router.Name := ParseStr[1];
        Router.IPv4 := ParseStr[5];
        Router.IPv6 := '';
        Router.Port := StrToInt(ParseStr[6]);
        Router.DirPort := StrToInt(ParseStr[7]);
        Router.Flags := [rfRelay];
        Router.Version := '';
        Router.Params := 0;
        if Router.DirPort <> 0 then
          Inc(Router.Params, ROUTER_DIR_MIRROR);
        Continue;
      end;
      if Pos('a ', ls[i]) = 1 then
      begin
        Router.IPv6 := Copy(ls[i], 3, RPos(':', ls[i]) - 3);
        Inc(Router.Params, ROUTER_REACHABLE_IPV6);
        Continue;
      end;
      if Pos('s ', ls[i]) = 1 then
      begin
        ParseFlag := Explode(' ', ls[i]);
        FlagsCount := Length(ParseFlag);
        for j := 0 to FlagsCount - 1 do
        begin
          if Pos('Authority', ParseFlag[j]) = 1 then
          begin
            Include(Router.Flags, rfAuthority);
            Inc(Router.Params, ROUTER_AUTHORITY);
          end;
          if Pos('BadExit', ParseFlag[j]) = 1 then
          begin
            Include(Router.Flags, rfBadExit);
            Inc(Router.Params, ROUTER_BAD_EXIT);
          end;
          if Pos('Exit', ParseFlag[j]) = 1 then
            Include(Router.Flags, rfExit);
          if Pos('MiddleOnly', ParseFlag[j]) = 1 then
          begin
            Include(Router.Flags, rfMiddleOnly);
            Inc(Router.Params, ROUTER_MIDDLE_ONLY);
          end;
          if Pos('Fast', ParseFlag[j]) = 1 then
            Include(Router.Flags, rfFast);
          if Pos('Guard', ParseFlag[j]) = 1 then
            Include(Router.Flags, rfGuard);
          if Pos('HSDir', ParseFlag[j]) = 1 then
          begin
            Include(Router.Flags, rfHSDir);
            Inc(Router.Params, ROUTER_HS_DIR);
          end;
          if Pos('Stable', ParseFlag[j]) = 1 then
            Include(Router.Flags, rfStable);
          if Pos('V2Dir', ParseFlag[j]) = 1 then
            Include(Router.Flags, rfV2Dir);
        end;
        Continue;
      end;
      if Pos('v ', ls[i]) = 1 then
      begin
        Router.Version := Copy(ls[i], 7);
        if not VersionsDic.ContainsKey(Router.Version) then
          Inc(Router.Params, ROUTER_NOT_RECOMMENDED);
        Continue;
      end;

      if Pos('w ', ls[i]) = 1 then
      begin
        ParseStr := Explode(' ', ls[i]);
        Router.Bandwidth := StrToInt(SeparateRight(ParseStr[1], '='));
        if BridgesDic.TryGetValue(RouterID, BridgeInfo) then
        begin
          Include(Router.Flags, rfBridge);
          TryUpdateMask(Router.Params, ROUTER_BRIDGE, True);
          BridgeInfo.Router := Router;
          BridgeInfo.Kind := BRIDGE_RELAY;
          BridgesDic.AddOrSetValue(RouterID, BridgeInfo);
        end;
        RoutersDic.AddOrSetValue(RouterID, Router);

        if HashList.ContainsKey(RouterID) then
          HashList.Remove(RouterID)
        else
        begin
          if LastRoutersCount > 0 then
            SetPortsValue(Router.IPv4, IntToStr(Router.Port), 0);
        end;
        Continue;
      end;

      if Pos('server-versions', ls[i]) = 1 then
      begin
        ParseStr := Explode(',', ls[i]);
        for j := 0 to Length(ParseStr) - 1 do
          VersionsDic.AddOrSetValue(ParseStr[j], 0);
        Continue;
      end;

      if Pos('directory-footer', ls[i]) = 1 then
        Break;
    end;
    FileAge(ConsensusFile, LastConsensusDate);

    for HashItem in HashList do
    begin
      if HashItem.Value = 1 then
        RemoveMissingRouter
      else
      begin
        if not BridgesDic.ContainsKey(HashItem.Key) then
          RemoveMissingRouter;
      end;
    end;

    if BridgesDic.Count > 0 then
    begin
      for BridgeItem in BridgesDic do
      begin
        NeedUpdate := False;
        BridgeInfo := BridgeItem.Value;
        if BridgeItem.Value.Kind = BRIDGE_RELAY then
        begin
          if not (rfRelay in BridgeInfo.Router.Flags) then
          begin
            Include(BridgeInfo.Router.Flags, rfNoBridgeRelay);
            NeedUpdate := True;
          end;
        end;
        if TryUpdateMask(BridgeInfo.Router.Params, ROUTER_NOT_RECOMMENDED, not VersionsDic.ContainsKey(BridgeInfo.Router.Version))
          or NeedUpdate then
            BridgesDic.AddOrSetValue(BridgeItem.Key, BridgeInfo);
        RoutersDic.AddOrSetValue(BridgeItem.Key, BridgeInfo.Router);
      end;
    end;

    if (UsedFallbackDirs.Count > 0) and (RoutersDic.Count > 0) then
    begin
      for FallbackStr in UsedFallbackDirs.Values do
      begin
        if TryParseFallbackDir(FallbackStr, FallbackDir, False) then
        begin
          if RoutersDic.TryGetValue(FallbackDir.Hash, Router) then
          begin
            if (FallbackDir.IPv4 <> Router.IPv4) or (FallbackDir.OrPort <> Router.Port) then
              RemoveMissingFallbackDir;
          end
          else
            RemoveMissingFallbackDir; 
        end;
      end;
    end;

  finally
    ls.Free;
    HashList.Free;
  end;
end;

procedure TDescriptorsThread.Execute;
var
  ls, lb: TStringList;
  i, PrevData, CurrData: Integer;
  ParseStr: ArrOfStr;
  DescRouter, Router: TRouterInfo;
  UserBridges: TDictionary<string, TBridge>;
  Bridge, PrevBridge: TBridge;
  RouterID, Temp, BridgeKey, SourceAddr: string;
  BridgeRelay, UpdateFromDesc, DifferSource: Boolean;
  GeoIpInfo: TGeoIpInfo;

  procedure LoadDesc(FileName: string);
  var
    Desc: TStringList;
  begin
    if not FileExists(FileName) then
      Exit;
    Desc := TStringList.Create;
    try
      Desc.LoadFromFile(FileName);
      if Desc.Count > 0 then
        ls.AddStrings(Desc);
    finally
      Desc.Free;
    end;
  end;

  procedure UpdateBridges(var RouterInfo: TRouterInfo);
  var
    BridgeInfo, BridgeInfoDic: TBridgeInfo;

    procedure Update(CheckSource: Boolean = False);
    begin
      RouterInfo.Port := Bridge.Port;
      BridgeInfo.Transport := Bridge.Transport;
      BridgeInfo.Params := Bridge.Params;
    end;
    
  begin
    if rfRelay in RouterInfo.Flags then
      BridgeInfo.Kind := BRIDGE_RELAY
    else
      BridgeInfo.Kind := BRIDGE_NATIVE;
        
    if UserBridges.TryGetValue(RouterID, Bridge) then
      Update
    else
    begin
      if UserBridges.TryGetValue(RouterInfo.IPv4, Bridge) then
        Update
      else
      begin
        if UserBridges.TryGetValue(RouterInfo.IPv6, Bridge) then
          Update
        else
        begin
          if UserBridges.TryGetValue(SourceAddr, Bridge) then
          begin
            Update
          end
          else
          begin
            if BridgesDic.TryGetValue(RouterID, BridgeInfoDic) then
            begin
              RouterInfo.Port := BridgeInfoDic.Router.Port;
              BridgeInfo.Source := BridgeInfoDic.Source;
              BridgeInfo.Transport := BridgeInfoDic.Transport;
              BridgeInfo.Params := BridgeInfoDic.Params;
            end
            else
            begin
              BridgeInfo.Source := '';
              BridgeInfo.Transport := '';
              BridgeInfo.Params := '';
            end;
          end;
        end;
      end;
    end;
    DifferSource := False;
    case ValidAddress(SourceAddr) of
      atIPv4: DifferSource := SourceAddr <> RouterInfo.IPv4;
      atIPv6: DifferSource := SourceAddr <> RemoveBrackets(RouterInfo.IPv6, True);
    end;
    if DifferSource then
    begin
      BridgeInfo.Source := SourceAddr;
      CompBridgesDic.AddOrSetValue(SourceAddr, RouterID);
    end
    else
      BridgeInfo.Source := '';
    BridgeInfo.Router := RouterInfo;

    if ConnectState <> 0 then
    begin
      SetPortsValue(BridgeInfo.Router.IPv4, IntToStr(BridgeInfo.Router.Port), 1);
      BridgeKey := BridgeInfo.Router.IPv4 + '|' + IntToStr(BridgeInfo.Router.Port);
      DirFetches.Remove(BridgeKey);
      if (NewBridgesStage = 1) and (NewBridgesCount > 0) then
      begin
        if NewBridgesList.ContainsKey(BridgeKey) then
        begin
          NewBridgesList.Remove(BridgeKey);
          Dec(NewBridgesCount);
        end;
      end;
      if GeoIpDic.ContainsKey(BridgeInfo.Router.IPv6) then
      begin
        SetPortsValue(BridgeInfo.Router.IPv6, IntToStr(BridgeInfo.Router.Port), 1);
        BridgeKey := BridgeInfo.Router.IPv6 + '|' + IntToStr(BridgeInfo.Router.Port);
        DirFetches.Remove(BridgeKey);
        if (NewBridgesStage = 1) and (NewBridgesCount > 0) then
        begin
          if NewBridgesList.ContainsKey(BridgeKey) then
          begin
            NewBridgesList.Remove(BridgeKey);
            Dec(NewBridgesCount);
          end;
        end;
      end;
    end;
    BridgesDic.AddOrSetValue(RouterID, BridgeInfo);
  end;

begin
  if RoutersDic.Count = 0 then
    Exit;
  ls := TStringList.Create;
  lb := TStringList.Create;
  UserBridges := TDictionary<string, TBridge>.Create;
  try
    lb.Text := Tcp.meBridges.Text;
    lb.Append(Tcp.edPreferredBridge.Text);

    for i := 0 to lb.Count - 1 do
    begin
      if TryParseBridge(lb[i], Bridge, False) then
      begin
        if Bridge.Hash <> '' then
          BridgeKey := Bridge.Hash
        else
          BridgeKey := Bridge.Ip;
        if UserBridges.TryGetValue(BridgeKey, PrevBridge) then
        begin
          if GeoIpDic.TryGetValue(PrevBridge.Ip, GeoIpInfo) then
            PrevData := GetPortsValue(GeoIpInfo.ports, IntToStr(PrevBridge.Port))
          else
            PrevData := 0;

          if GeoIpDic.TryGetValue(Bridge.Ip, GeoIpInfo) then
            CurrData := GetPortsValue(GeoIpInfo.ports, IntToStr(Bridge.Port))
          else
            CurrData := 0;

          if CurrData > PrevData then
            UserBridges.AddOrSetValue(BridgeKey, Bridge)
        end
        else
          UserBridges.AddOrSetValue(BridgeKey, Bridge)
      end;
    end;

    BridgeRelay := False;
    UpdateFromDesc := False;
    LoadDesc(DescriptorsFile);
    LoadDesc(NewDescriptorsFile);
    for i := 0 to ls.Count - 1 do
    begin
      if Pos('@source ', ls[i]) = 1 then
      begin
        SourceAddr := StringReplace(Copy(ls[i], 9), '"', '', [rfReplaceAll]);
        Continue;
      end;
      if Pos('@purpose bridge', ls[i]) = 1 then
      begin
        BridgeRelay := True;
        UpdateFromDesc := True;
        Continue;
      end;
      if BridgeRelay then
      begin
        if Pos('router ', ls[i]) = 1 then
        begin
          ParseStr := Explode(' ', ls[i]);
          DescRouter.Name := ParseStr[1];
          DescRouter.IPv4 := ParseStr[2];
          DescRouter.IPv6 := '';
          DescRouter.Port := StrToInt(ParseStr[3]);
          DescRouter.DirPort := 0;
          DescRouter.Flags := [rfBridge];
          DescRouter.Params := ROUTER_BRIDGE;
          DescRouter.Version := '';
          Continue;
        end;

        if Pos('or-address ', ls[i]) = 1 then
        begin
          Temp := Copy(ls[i], 12, RPos(':', ls[i]) - 12);
          if ValidAddress(Temp, False, True) = atIPv6 then
          begin
            DescRouter.IPv6 := Temp;
            Inc(DescRouter.Params, ROUTER_REACHABLE_IPV6);
          end;
          Continue;
        end;

        if Pos('platform ', ls[i]) = 1 then
        begin
          ParseStr := Explode(' ', ls[i]);
          DescRouter.Version := ParseStr[2];
          if not VersionsDic.ContainsKey(ParseStr[2]) then
            Inc(DescRouter.Params, ROUTER_NOT_RECOMMENDED);
          Continue;
        end;

        if Pos('fingerprint ', ls[i]) = 1 then
        begin
          RouterID := StringReplace(Copy(ls[i], 13), ' ', '', [rfReplaceAll]);
          Continue;
        end;

        if Pos('bandwidth ', ls[i]) = 1 then
        begin
          ParseStr := Explode(' ', ls[i]);
          DescRouter.Bandwidth := Round(StrToInt(ParseStr[3]) / 1024);
          Continue;
        end;

        if Pos('tunnelled-dir-server', ls[i]) = 1 then
        begin
          Include(DescRouter.Flags, rfV2Dir);
          Continue;
        end;

        if Pos('router-signature', ls[i]) = 1 then
        begin
          if RoutersDic.TryGetValue(RouterID, Router) then
          begin
            if rfRelay in Router.Flags then
            begin
              Include(Router.Flags, rfBridge);
              TryUpdateMask(Router.Params, ROUTER_BRIDGE, True);
              if Router.Bandwidth < DescRouter.Bandwidth then
                Router.Bandwidth := DescRouter.Bandwidth;
              UpdateBridges(Router);
              RoutersDic.AddOrSetValue(RouterID, Router);
              UpdateFromDesc := False;
            end;
          end;

          if UpdateFromDesc then
          begin
            UpdateBridges(DescRouter);
            RoutersDic.AddOrSetValue(RouterID, DescRouter);
            UpdateFromDesc := False;
          end;
          BridgeRelay := False;
          Continue;
        end;
      end;
    end;
    FileAge(NewDescriptorsFile, LastNewDescriptorsDate);
  finally
    ls.Free;
    lb.Free;
    UserBridges.Free;
  end;
end;

procedure TTcp.ControlThreadTerminate(Sender: TObject);
begin
  Connected := False;
  Controller := nil;
  if (ConnectState > 0) then
  begin
    case StopCode of
      STOP_NORMAL: RestartTor;
      STOP_CONFIG_ERROR:
      begin
        StopTor;
        Tcp.Show;
        sbShowLog.Click;
        ShowMsg(TransStr('236'), '', mtError);
      end;
      STOP_AUTH_ERROR:
      begin
        StopTor;
        ShowMsg(TransStr('237'), '', mtWarning);
      end;
    end;
  end;
end;

function TTcp.GetControlEvents: string;
begin
  Result := 'BW CIRC STREAM STATUS_CLIENT';
  if cbxServerMode.ItemIndex <> SERVER_MODE_NONE then
    Result := Result + ' STATUS_SERVER';
  if miShowCircuitsTraffic.Checked then
    Result := Result + ' CIRC_BW';
  if miShowStreamsTraffic.Checked then
    Result := Result + ' STREAM_BW';
end;

procedure TControlThread.Execute;
begin
  Socket := TTCPBlockSocket.Create;
  try
    repeat
      Socket.Connect(LOOPBACK_ADDRESS, IntToStr(Tcp.udControlPort.Position));
      if StopCode <> STOP_NORMAL then
        Terminate;
    until (Terminated = True) or (Socket.LastError = 0);

    repeat
      Sleep(1);
    until (Terminated = True) or (AuthStageReady(Tcp.cbxAuthMetod.ItemIndex) = True);

    case Tcp.cbxAuthMetod.ItemIndex of
      0: AuthParam := FileGetString(UserDir + 'control_auth_cookie', True);
      1: AuthParam := '"' + Decrypt(ControlPassword, 'True') + '"';
    end;
    Socket.SendString('AUTHENTICATE ' + AnsiString(AuthParam) + BR);
    Socket.SendString('SETEVENTS ' + AnsiString(Tcp.GetControlEvents) + BR);
    Connected := True;
    while not Terminated do
    begin
      Data := string(socket.RecvString(1));
      if Socket.LastError = 0 then
        Synchronize(GetData);
        
      if SendBuffer <> '' then
      begin
        Socket.SendString(AnsiString(SendBuffer));
        SendBuffer := '';
      end;
              
      if Socket.LastError = WSAECONNRESET then
        Terminate;
    end;
  finally
    Socket.CloseSocket;
    Socket.Free;
  end;
end;

function TControlThread.AuthStageReady(AuthMethod: Integer): Boolean;
var
  Time: TDateTime;
begin
  Result := False;
  if AuthMethod = CONTROL_AUTH_PASSWORD then
    Result := True
  else
  begin
    if FileAge(UserDir + 'control_auth_cookie', Time) then
    begin
      if LastAuthCookieDate <> Time then
        Result := True;
    end;
  end;
end;

procedure TControlThread.SendData(cmd: string);
begin
  if Connected then
    SendBuffer := SendBuffer + cmd + BR;
end;

procedure TControlThread.CheckDirFetches(StreamInfo: TStreamInfo; Counter: Integer);
var
  Target: TTarget;
  FetchInfo: TFetchInfo;
  RouterInfo: TRouterInfo;
  BridgeKey, BridgeStr: string;
  Bridge: TBridge;
begin
  if StreamInfo.PurposeID = DIR_FETCH then
  begin
    if TryParseTarget(StreamInfo.Target, Target) then
    begin
      if Target.TargetType = ttExit then
      begin
        BridgeKey := Target.Hostname + '|' + Target.Port;
        if DirFetches.TryGetValue(BridgeKey, FetchInfo) then
        begin
          if RoutersDic.TryGetValue(Target.Hash, RouterInfo) then
          begin
            if rfRelay in RouterInfo.Flags then
            begin
              if NewBridgesList.TryGetValue(BridgeKey, BridgeStr) then
              begin
                if TryParseBridge(BridgeStr, Bridge, False) then
                begin
                  if Bridge.Transport <> '' then
                  begin
                    SetPortsValue(Target.Hostname, Target.Port, -1);
                    Inc(FailedBridgesCount);
                    ConsensusUpdated := True;
                    Exit;
                  end;
                end;
              end;
            end;
          end;
          Inc(FetchInfo.FailsCount);
          DirFetches.AddOrSetValue(BridgeKey, FetchInfo);
          if FetchInfo.FailsCount > Tcp.udMaxDirFails.Position then
          begin
            SetPortsValue(FetchInfo.IpStr, FetchInfo.PortStr, -1);
            DirFetches.Remove(BridgeKey);
            Inc(FailedBridgesCount);
            ConsensusUpdated := True;
          end;
        end
        else
        begin
          FetchInfo.IpStr := Target.Hostname;
          FetchInfo.PortStr := Target.Port;
          FetchInfo.FailsCount := Counter;
          DirFetches.AddOrSetValue(BridgeKey, FetchInfo);
        end;
      end;
    end;
  end;
end;

function TControlThread.GetCircuitFlags(Circuit: TCircuitInfo): Word;
begin
  if bfOneHop in (Circuit.BuildFlags) then
    Result := CF_DIR_REQUEST
  else
  begin
    case Circuit.PurposeID of
      GENERAL:
      begin
        if bfInternal in (Circuit.BuildFlags) then
          Result := CF_INTERNAL
        else
          Result := CF_EXIT;
      end;
      HS_CLIENT_HSDIR: Result := CF_HIDDEN_SERVICE + CF_CLIENT + CF_DIR_REQUEST;
      HS_CLIENT_INTRO: Result := CF_HIDDEN_SERVICE + CF_CLIENT + CF_INTRO;
      HS_CLIENT_REND: Result := CF_HIDDEN_SERVICE + CF_CLIENT + CF_REND;
      HS_SERVICE_HSDIR: Result := CF_HIDDEN_SERVICE + CF_SERVICE + CF_DIR_REQUEST;
      HS_SERVICE_INTRO: Result := CF_HIDDEN_SERVICE + CF_SERVICE + CF_INTRO;
      HS_SERVICE_REND: Result := CF_HIDDEN_SERVICE + CF_SERVICE + CF_REND;
      HS_VANGUARDS: Result := CF_HIDDEN_SERVICE + CF_VANGUARDS;
      PATH_BIAS_TESTING: Result := CF_PATH_BIAS_TESTING;
      TESTING: Result := CF_TESTING;
      CIRCUIT_PADDING: Result := CF_CIRCUIT_PADDING;
      MEASURE_TIMEOUT: Result := CF_MEASURE_TIMEOUT;
      CONTROLLER_CIRCUIT: Result := CF_CONTROLLER;
      else
        Result := CF_OTHER;
    end;
  end;
end;

procedure TControlThread.GetData;
var
  i: Integer;
  Item: TPair<string, TRouterInfo>;
  GeoIpItem: TPair<string, TGeoIpInfo>;
  ls: TStringList;
  GeoIpInfo: TGeoIpInfo;
  FilterInfo: TFilterInfo;
  RouterInfo: TRouterInfo;
  Bridge: TBridge;
  FallbackDir: TFallbackDir;
  Str: string;

  procedure CheckCountryUpdate(IpStr: string; FindData: Boolean = True);
  begin
    UpdateCountry := True;
    if FindData then
    begin
      if GeoIpDic.TryGetValue(IpStr, GeoIpInfo) then
      begin
        if GeoIpInfo.cc <> DEFAULT_COUNTRY_ID then
          UpdateCountry := False;
      end;
    end;
    if UpdateCountry then
    begin
      Inc(InfoCount);
      Temp := Temp + ' ip-to-country/' + IpStr;
    end;
  end;

begin
  if InfoStage > 0 then
  begin
    if InfoStage = 1 then
    begin
      Temp := '';
      InfoCount := 0;

      if GeoIpExists then
      begin
        if FindBridgesCountries or FindFallbackDirCountries then
        begin
          ls := TStringList.Create;
          try
            if FindBridgesCountries then
            begin
              ls.Text := Tcp.meBridges.Text;
              ls.Append(Tcp.edPreferredBridge.Text);
              for i := 0 to ls.Count - 1 do
              begin
                if TryParseBridge(ls[i], Bridge, False) then
                begin
                  Str := GetBridgeIp(Bridge);
                  if Str = '' then
                    Continue;
                  CheckCountryUpdate(Str);
                end;
              end;
            end;
            if FindFallbackDirCountries then
            begin
              ls.Text := Tcp.meFallbackDirs.Text;
              for i := 0 to ls.Count - 1 do
              begin
                if TryParseFallbackDir(ls[i], FallbackDir, False) then
                  CheckCountryUpdate(FallbackDir.IPv4);
              end;
            end;
          finally
            ls.Free;
          end;
        end
        else
        begin
          if GeoIpUpdating then
          begin
            for GeoIpItem in GeoIpDic do
              CheckCountryUpdate(GeoIpItem.Key, False);
          end
          else
          begin
            for Item in RoutersDic do
              CheckCountryUpdate(Item.Value.IPv4);
          end;
        end;
      end;

      if InfoCount > 0 then
      begin
        SendData('GETINFO' + Temp);
        InfoStage := 2;
      end
      else
        InfoStage := 3;
    end;

    if InfoStage = 2 then
    begin
      if Pos('250-ip-to-country/', Data) = 1 then
      begin
        ParseStr := Explode('=', copy(Data, 19));
        if FilterDic.TryGetValue(ParseStr[1], FilterInfo) then
          CountryCode := FilterInfo.cc
        else
          CountryCode := DEFAULT_COUNTRY_ID;

        if GeoIpDic.TryGetValue(ParseStr[0], GeoIpInfo) then
          GeoIpInfo.cc := CountryCode
        else
        begin
          GeoIpInfo.cc := CountryCode;
          GeoIpInfo.ping := 0;
          GeoIpInfo.ports := '';
        end;
        GeoIpDic.AddOrSetValue(ParseStr[0], GeoIpInfo);
        GeoIpModified := True;

        Dec(InfoCount);

        if InfoCount = 0 then
        begin
          if GeoIpUpdating then
          begin
            GeoFileID := GetFileID(GeoIpFile);
            SetConfigString('Main', 'GeoFileID', GeoFileID);
            GeoIpUpdating := False;
          end;
          InfoStage := 3;
        end
        else
          Exit;
      end;
    end;

    if InfoStage = 3 then
    begin
      InfoStage := 0;
      if FindBridgesCountries or FindFallbackDirCountries then
      begin
        FindBridgesCountries := False;
        FindFallbackDirCountries := False;
        if not ScanNewBridges then
        begin
          OptionsLocked := True;
          Tcp.ApplyOptions(True);
        end;
        Exit;
      end
      else
      begin
        Tcp.LoadFilterTotals;
        Tcp.LoadRoutersCountries;
        Tcp.ShowFilter;
        Tcp.ShowRouters;
        if (ConnectState = 2) and (Circuit = '') then
          Tcp.SendDataThroughProxy;

        if AutoScanStage = 0 then
        begin
          if Tcp.cbAutoScanNewNodes.Checked and
            (Tcp.cbEnablePingMeasure.Checked or Tcp.cbEnableDetectAliveNodes.Checked) then
              AutoScanStage := 1;
        end
        else
        begin
          if AutoScanStage = 3 then
            AutoScanStage := 0;
        end;
        Tcp.SaveNetworkCache(False);
      end;
    end;
  end;

  if GetIpStage > 0 then
  begin
    if GetIpStage = 1 then
    begin
      if (Pos('250-address', Data) = 1) then
      begin
        ServerIPv4 := SeparateRight(Data, '=');
        GetIpStage := 2;
      end;

      if Pos('551 Address unknown', Data) = 1 then
      begin
        if Tcp.cbUseOpenDNS.Checked and Tcp.cbUseOpenDNSOnlyWhenUnknown.Checked then
        begin
          Tcp.GetDNSExternalAddress;
          Exit;
        end
        else
        begin
          ServerIPv4 := '';
          GetIpStage := 2;
        end;
      end;
    end;

    if GetIpStage = 2 then
    begin
      Tcp.UpdateServerInfo;
      GetIpStage := 0;
      Exit;
    end;
  end;

  if ConnectState = 1 then
  begin

    if Pos('515 Authentication failed', Data) = 1 then
    begin
      StopCode := STOP_AUTH_ERROR;
      Exit;
    end;

    SearchPos := Pos('BOOTSTRAP PROGRESS', Data);
    if SearchPos <> 0 then
    begin
      ConnectProgress := StrToIntDef(copy(Data, SearchPos + 19, Pos('TAG', Data) - (SearchPos + 20)), 0);
      Tcp.UpdateConnectProgress(ConnectProgress);
      if ConnectProgress = 100 then
      begin
        ConnectState := 2;
        AlreadyStarted := True;
        Tcp.UpdateConnectControls;
        Tcp.SetOptionsEnable(True);
        Tcp.GetServerInfo;
        Tcp.SendDataThroughProxy;
      end;
      Exit;
    end;
  end;

  if Pos('650 CIRC ', Data) = 1  then
  begin
    ParseStr := Explode(' ', Data);
    CircuitID := ParseStr[2];
    CircuitStatusID := GetConstantIndex(ParseStr[3]);
    case CircuitStatusID of
      BUILT:
      begin
        CircuitInfo.BuildFlags := [];
        CircuitInfo.Streams := 0;
        CircuitInfo.BytesRead := 0;
        CircuitInfo.BytesWritten := 0;
        if Pos('ONEHOP_TUNNEL', ParseStr[5]) <> 0 then
          Include(CircuitInfo.BuildFlags, bfOneHop);
        if Pos('IS_INTERNAL', ParseStr[5]) <> 0 then
          Include(CircuitInfo.BuildFlags, bfInternal);
        if Pos('NEED_CAPACITY', ParseStr[5]) <> 0 then
          Include(CircuitInfo.BuildFlags, bfNeedCapacity);
        if Pos('NEED_UPTIME', ParseStr[5]) <> 0 then
          Include(CircuitInfo.BuildFlags, bfNeedUptime);
        CircuitInfo.PurposeID := GetConstantIndex(SeparateRight(ParseStr[6], '='));
        CircuitInfo.Flags := GetCircuitFlags(CircuitInfo);
        for i := 7 to Length(ParseStr) - 1 do
        begin
          if Pos('TIME_CREATED', ParseStr[i]) <> 0 then
          begin
            CircuitInfo.Date := ISO8601ToDate(SeparateRight(ParseStr[i], '='), False);
            Break;
          end;
        end;
        ParseStr := Explode(',', ParseStr[4]);
        Temp := '';
        for i := 0 to Length(ParseStr) - 1 do
          Temp := Temp + ',' + Copy(SeparateLeft(ParseStr[i], '~'), 2);
        Delete(Temp, 1, 1);
        CircuitInfo.Nodes := Temp;
        CircuitsDic.AddOrSetValue(CircuitID, CircuitInfo);
        CircuitsUpdated := True;
      end;
      CLOSED:
      begin
        CircuitsDic.Remove(CircuitID);
        CircuitsUpdated := True;
        if CircuitID = Circuit then
          Tcp.SendDataThroughProxy;
      end;
    end;
    Exit;
  end;

  if Pos('650 STREAM ', Data) = 1  then
  begin
    ParseStr := Explode(' ', Data);
    StreamID := ParseStr[2];
    StreamStatusID := GetConstantIndex(ParseStr[3]);
    CircuitID := ParseStr[4];
    case StreamStatusID of
      NEW:
      begin
        StreamInfo.CircuitID := CircuitID;
        StreamInfo.Target := ParseStr[5];
        StreamInfo.SourceAddr := '';
        StreamInfo.DestAddr := '';
        StreamInfo.Protocol := -1;
        StreamInfo.BytesRead := 0;
        StreamInfo.BytesWritten := 0;
        for i := 6 to Length(ParseStr) - 1 do
        begin
          if Pos('SOURCE_ADDR', ParseStr[i]) = 1 then
            StreamInfo.SourceAddr := SeparateRight(ParseStr[i], '=');
          if Pos('PURPOSE', ParseStr[i]) = 1 then
            StreamInfo.PurposeID := GetConstantIndex(SeparateRight(ParseStr[i], '='));
          if Pos('CLIENT_PROTOCOL', ParseStr[i]) = 1 then
          begin
            StreamInfo.Protocol := GetConstantIndex(SeparateRight(ParseStr[i], '='));
            Break;
          end;
        end;
        StreamsDic.AddOrSetValue(StreamID, StreamInfo);
        if Tcp.cbUseBridges.Checked and Tcp.cbExcludeUnsuitableBridges.Checked and (CircuitID = '0') then
          CheckDirFetches(StreamInfo, 0);
        Exit;
      end;
      SENTCONNECT:
      begin
        if StreamsDic.TryGetValue(StreamID, StreamInfo) then
        begin
          StreamInfo.CircuitID := CircuitID;
          StreamsDic.AddOrSetValue(StreamID, StreamInfo);
          if (Circuit <> CircuitID) and (StreamInfo.PurposeID = USER) then
          begin
            if CircuitsDic.TryGetValue(CircuitID, CircuitInfo) then
            begin
              if not (bfInternal in CircuitInfo.BuildFlags) then
              begin
                ParseStr := Explode(',', CircuitInfo.Nodes);
                Temp := ParseStr[Length(ParseStr) - 1];
                if RoutersDic.TryGetValue(Temp, RouterInfo) then
                begin
                  LastUserStreamProtocol := StreamInfo.Protocol;
                  Circuit := CircuitID;
                  Ip := RouterInfo.IPv4;
                  CountryCode := GetCountryValue(Ip);
                  if ExitNodeID = '' then
                  begin
                    Tcp.lbExitIp.Cursor := crHandPoint;
                    Tcp.lbExitCountry.Cursor := crHandPoint;
                  end;
                  ExitNodeID := Temp;
                  Tcp.lbExitIp.Caption := Ip;
                  Tcp.lbExitCountry.Caption := TransStr(CountryCodes[CountryCode]);
                  Tcp.lbExitCountry.Left := Round(208 * Scale);
                  Tcp.imExitFlag.Picture := nil;
                  Tcp.lsFlags.GetBitmap(CountryCode, Tcp.imExitFlag.Picture.Bitmap);
                  Tcp.imExitFlag.Visible := True;
                  CheckLabelEndEllipsis(Tcp.lbExitCountry, 150, epEndEllipsis, True, False);
                  if CountryCode = DEFAULT_COUNTRY_ID then
                    Tcp.ShowBalloon(TransStr('113') + ': ' + Ip, TransStr('258'))
                  else
                    Tcp.ShowBalloon(TransStr('113') + ': ' + Ip + BR + '  ' + TransStr('114') + ': ' + TransStr(CountryCodes[CountryCode]), TransStr('258'));
                  Tcp.btnChangeCircuit.Enabled := True;
                  Tcp.miChangeCircuit.Enabled := True;
                  Tcp.tmUpdateIp.Interval := Tcp.udMaxCircuitDirtiness.Position * 1000;
                  Tcp.tmUpdateIp.Enabled := True;
                  if Tcp.miSelectExitCircuitWhenItChanges.Checked then
                    SelectExitCircuit := True;
                  Tcp.UpdateTrayHint;
                end;
              end;
            end;
          end;
        end;
      end;
      REMAP:
      begin
        if StreamsDic.TryGetValue(StreamID, StreamInfo) then
        begin
          StreamInfo.DestAddr := ParseStr[5];
          StreamsDic.AddOrSetValue(StreamID, StreamInfo);
        end;
        Exit;
      end;
    end;
    if CircuitsDic.TryGetValue(CircuitID, CircuitInfo) then
    begin
      if StreamsDic.ContainsKey(StreamID) then
      begin
        case StreamStatusID of
          SENTCONNECT: Inc(CircuitInfo.Streams);
          DETACHED: Dec(CircuitInfo.Streams);
          CLOSED:
          begin
            Dec(CircuitInfo.Streams);
            StreamsDic.Remove(StreamID);
          end;
        end;
        CircuitsDic.AddOrSetValue(CircuitID, CircuitInfo);
        CircuitsUpdated := True;
      end;
    end
    else
    begin
      if StreamStatusID = CLOSED then
      begin
        if (UsedProxyType <> ptNone) and (ConnectState = 2) and (ExitNodeID = '') then
        begin
          if ExtractDomain(ParseStr[5], True) = ExtractDomain(GetDefaultsValue('CheckUrl', CHECK_URL)) then
            Tcp.SendDataThroughProxy;
        end;
        StreamsDic.Remove(StreamID);
      end;
    end;
    Exit;
  end;

  if Pos('650 BW ', Data) = 1 then
  begin
    ParseStr := Explode(' ', Data);
    DLSpeed := StrToIntDef(ParseStr[2], 0);
    ULSpeed := StrToIntDef(ParseStr[3], 0);
    if DLSpeed > MaxDLSpeed then
    begin
      MaxDLSpeed := DLSpeed;
      Tcp.lbMaxDLSpeed.Caption := BytesFormat(MaxDLSpeed) + '/' + TransStr('180');
    end;
    if ULSpeed > MaxULSpeed then
    begin
      MaxULSpeed := ULSpeed;
      Tcp.lbMaxULSpeed.Caption := BytesFormat(MaxULSpeed) + '/' + TransStr('180');
    end;
    if DLSpeed > 0 then
    begin
      Inc(SessionDL, DLSpeed);
      Tcp.lbSessionDL.Caption := BytesFormat(SessionDL);
      if Tcp.miEnableTotalsCounter.Checked then
      begin
        inc(TotalDL, DLSpeed);
        Tcp.lbTotalDL.Caption := BytesFormat(TotalDL);
        TotalsNeedSave := True;
      end;
    end;
    if ULSpeed > 0 then
    begin
      Inc(SessionUL, ULSpeed);
      Tcp.lbSessionUL.Caption := BytesFormat(SessionUL);
      if Tcp.miEnableTotalsCounter.Checked then
      begin
        inc(TotalUL, ULSpeed);
        Tcp.lbTotalUL.Caption := BytesFormat(TotalUL);
        TotalsNeedSave := True;
      end;
    end;

    Exit;
  end;
  if Tcp.miShowCircuitsTraffic.Checked then
  begin
    if Pos('650 CIRC_BW ', Data) = 1 then
    begin
      ParseStr := Explode(' ', Data);
      CircuitID := SeparateRight(ParseStr[2], '=');
      if CircuitsDic.TryGetValue(CircuitID, CircuitInfo) then
      begin
        Inc(CircuitInfo.BytesRead, StrToInt64Def(SeparateRight(ParseStr[3], '='), 0));
        Inc(CircuitInfo.BytesWritten, StrToInt64Def(SeparateRight(ParseStr[4], '='), 0));
        CircuitsDic.AddOrSetValue(CircuitID, CircuitInfo);
        CircuitsUpdated := True;
      end;
      Exit;
    end;
  end;

  if Tcp.miShowStreamsTraffic.Checked then
  begin
    if Pos('650 STREAM_BW ', Data) = 1 then
    begin
      ParseStr := Explode(' ', Data);
      StreamID := SeparateRight(ParseStr[2], '=');
      if StreamsDic.TryGetValue(StreamID, StreamInfo) then
      begin
        Inc(StreamInfo.BytesWritten, StrToInt64Def(SeparateRight(ParseStr[3], '='), 0));
        Inc(StreamInfo.BytesRead, StrToInt64Def(SeparateRight(ParseStr[4], '='), 0));
        StreamsDic.AddOrSetValue(StreamID, StreamInfo);
      end;
      Exit;
    end;
  end;

  if Tcp.cbxServerMode.ItemIndex <> SERVER_MODE_NONE then
  begin
    if Pos('650 STATUS_SERVER ', Data) = 1 then
    begin
      ParseStr := Explode(' ', Data);
      for i := 2 to Length(ParseStr) - 1 do
      begin
        if Pos('ADDRESS=', ParseStr[i]) = 1 then
        begin
          Temp := SeparateRight(ParseStr[i], '=');
          AddressType := ValidAddress(Temp);
          case AddressType of
            atIPv4: if Temp <> ServerIPv4 then ServerIPv4 := Temp;
            atIPv6: if Temp <> ServerIPv6 then ServerIPv6 := Temp;
          end;
          if AddressType <> atNone then
            Tcp.UpdateServerInfo;
        end;
      end;
      Exit;
    end;
  end;

end;

function TUTF8EncodingNoBOM.GetPreamble: TBytes;
begin
  SetLength(Result, 0);
end;

procedure TPageControl.TCMAdjustRect(var Msg: TMessage);
begin
  inherited;
  if Msg.WParam = 0 then
    InflateRect(PRect(Msg.LParam)^, 3, 3)
  else
    InflateRect(PRect(Msg.LParam)^, -3, -3);
end;

procedure TTcp.sgCircuitInfoDblClick(Sender: TObject);
begin
  if sgCircuitInfo.MovRow > 0 then
  begin
    case sgCircuitInfo.MovCol of
      CIRC_INFO_IP: FindInRouters(sgCircuitInfo.Cells[CIRC_INFO_ID, sgCircuitInfo.MovRow]);
      CIRC_INFO_FLAG, CIRC_INFO_COUNTRY:
        FindInFilter(sgCircuitInfo.Cells[CIRC_INFO_IP, sgCircuitInfo.MovRow]);
    end;
  end;
end;

procedure TTcp.sgCircuitInfoDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  IpStr: string;
begin
  if (ARow = 0) and (ACol > 0) then
  begin
    case ACol of
      CIRC_INFO_FLAG: GridDrawIcon(sgCircuitInfo, Rect, lsMain, 6);
      else
        DrawText(sgCircuitInfo.Canvas.Handle, PChar(DetailsHeader[ACol - 1]), Length(DetailsHeader[ACol - 1]), Rect, DT_CENTER);
    end;
  end;
  if ARow > 0 then
  begin
    if ACol = CIRC_INFO_FLAG then
    begin
      IpStr := sgCircuitInfo.Cells[CIRC_INFO_IP, ARow];
      if IpStr <> '' then
      begin
        if miShowPortAlongWithIp.Checked then
          IpStr := GetAddressFromSocket(IpStr);
        GridDrawIcon(sgCircuitInfo, Rect, lsFlags,  GetCountryValue(IpStr), 20, 13);
      end;
    end;
  end;
end;

procedure TTcp.sgCircuitInfoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GridKeyDown(sgCircuitInfo, Shift, Key);
  case Key of
    VK_F5: ShowCircuits;
  end;
end;

procedure TTcp.sgCircuitInfoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    sgCircuitInfo.MouseToCell(X, Y, sgCircuitInfo.MovCol, sgCircuitInfo.MovRow);
end;

procedure TTcp.sgCircuitInfoMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  SelNodeState := False;
  sgCircuitInfo.MouseToCell(X, Y, sgCircuitInfo.MovCol, sgCircuitInfo.MovRow);
  GridSetFocus(sgCircuitInfo);
  GridShowHints(sgCircuitInfo);
  GridCheckAutoPopup(sgCircuitInfo, sgCircuitInfo.MovRow);
  if (sgCircuitInfo.MovCol in [CIRC_INFO_IP..CIRC_INFO_COUNTRY]) and (sgCircuitInfo.MovRow > 0) and not IsEmptyRow(sgCircuitInfo, sgCircuitInfo.MovRow) then
    sgCircuitInfo.Cursor := crHandPoint
  else
    sgCircuitInfo.Cursor := crDefault;
end;

procedure TTcp.sgCircuitInfoSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  GridSelectCell(sgCircuitInfo, ACol, ARow);
end;

procedure TTcp.sgCircuitsDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  PurposeID, Indent, Mask, Interval: Integer;
  Params: string;

  procedure DrawFlagIcon(Flag: Word; Index: Integer);
  begin
    if Indent > Interval then
    begin
      if Mask and Flag <> 0 then
      begin
        lsMenus.Draw(sgCircuits.Canvas, Rect.Left + (Rect.Width - Indent) div 2 + Interval, Rect.Top + (Rect.Height - 16) div 2, Index, True);
        Inc(Interval, 16);
      end;
    end
    else
      Exit;
  end;

begin
  if ARow = 0 then
  begin
    case ACol of
      CIRC_BYTES_READ: GridDrawIcon(sgCircuits, Rect, lsMain, 15);
      CIRC_BYTES_WRITTEN: GridDrawIcon(sgCircuits, Rect, lsMain, 16);
      CIRC_STREAMS: GridDrawIcon(sgCircuits, Rect, lsMain, 8);
      else
        DrawText(sgCircuits.Canvas.Handle, PChar(CircuitsHeader[ACol - 1]), Length(CircuitsHeader[ACol - 1]), Rect, DT_CENTER)
    end;
    if (ACol = sgCircuits.SortCol) and (ACol <> CIRC_STREAMS) then
      GridDrawSortArrows(sgCircuits, Rect);
  end;
  if ARow > 0 then
  begin
    if (ACol = CIRC_FLAGS) and miShowCircuitsTraffic.Checked then
    begin
      Params := sgCircuits.Cells[CIRC_PARAMS, ARow];
      if Params <> '' then
      begin
        PurposeID := StrToIntDef(SeparateRight(Params, '|'), -1);
        Mask := StrToIntDef(SeparateLeft(Params, '|'), CF_OTHER);
        Interval := 0;
        Indent := GetCircuitsParamsCount(PurposeID) * 16;

        DrawFlagIcon(CF_EXIT, 42);
        DrawFlagIcon(CF_INTERNAL, 61);
        DrawFlagIcon(CF_HIDDEN_SERVICE, 53);
        DrawFlagIcon(CF_VANGUARDS, 40);
        DrawFlagIcon(CF_CLIENT, 32);
        DrawFlagIcon(CF_SERVICE, 65);
        DrawFlagIcon(CF_DIR_REQUEST, 54);
        DrawFlagIcon(CF_INTRO, 64);
        DrawFlagIcon(CF_REND, 66);
        DrawFlagIcon(CF_MEASURE_TIMEOUT, 69);
        DrawFlagIcon(CF_CIRCUIT_PADDING, 22);
        DrawFlagIcon(CF_TESTING, 56);
        DrawFlagIcon(CF_PATH_BIAS_TESTING, 67);
        DrawFlagIcon(CF_CONTROLLER, 70);
        DrawFlagIcon(CF_OTHER, 68);
      end;
    end;
  end;
end;

procedure TTcp.sgCircuitsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GridKeyDown(sgCircuits, Shift, Key);
end;

procedure TTcp.sgCircuitsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    sgCircuits.MouseToCell(X, Y, sgCircuits.MovCol, sgCircuits.MovRow);
end;

procedure TTcp.sgCircuitsMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  sgCircuits.MouseToCell(X, Y, sgCircuits.MovCol, sgCircuits.MovRow);
  GridSetFocus(sgCircuits);
  if miCircuitsShowFlagsHint.Checked and (sgCircuits.MovCol = CIRC_FLAGS) then
    ShowCircuitsFlagsHint
  else
    GridShowHints(sgCircuits);
  GridCheckAutoPopup(sgCircuits, sgCircuits.MovRow, True);
end;

procedure TTcp.sgCircuitsSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  GridSelectCell(sgCircuits, ACol, ARow);
  ShowCircuitInfo(sgCircuits.Cells[CIRC_ID, ARow]);
end;

procedure TTcp.sgFilterDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  if ARow = 0 then
  begin
    case ACol of
      FILTER_FLAG: GridDrawIcon(sgFilter, Rect, lsMain, 6);
      FILTER_ENTRY_NODES: GridDrawIcon(sgFilter, Rect, lsMain, 7);
      FILTER_MIDDLE_NODES: GridDrawIcon(sgFilter, Rect, lsMain, 8);
      FILTER_EXIT_NODES: GridDrawIcon(sgFilter, Rect, lsMain, 9);
      FILTER_EXCLUDE_NODES: GridDrawIcon(sgFilter, Rect, lsMain, 10);
      else
        DrawText(sgFilter.Canvas.Handle, PChar(FilterHeader[ACol]), Length(FilterHeader[ACol]), Rect, DT_CENTER);
    end;
    if (ACol = sgFilter.SortCol) and (ACol < FILTER_ENTRY_NODES) then
      GridDrawSortArrows(sgFilter, Rect);
  end;
  if ARow > 0 then
  begin
    if (ACol = FILTER_FLAG) and (sgFilter.Cells[FILTER_ID, ARow] <> '') then
      GridDrawIcon(sgFilter, Rect, lsFlags, FilterDic.Items[LowerCase(sgFilter.Cells[FILTER_ID, ARow])].cc, 20, 13);
  end;
end;

procedure TTcp.UpdateRoutersAfterBridgesUpdate;
begin
  if BridgesFileUpdated then
    LoadBridgesFromFile;
  if BridgesRecalculate then
    SaveBridgesData;
  if BridgesUpdated then
  begin
    ShowRouters;
    BridgesUpdated := False;
  end;
end;

procedure TTcp.UpdateRoutersAfterFallbackDirsUpdate;
begin
  if FallbackDirsRecalculate then
    SaveFallbackDirsData;
  if FallbackDirsUpdated then
  begin
    if not BridgesUpdated then
      ShowRouters;
    FallbackDirsUpdated := False;
  end;
end;

procedure TTcp.UpdateRoutersAfterFilterUpdate;
begin
  if FilterUpdated then
  begin
    if FallbackDirsRecalculate then
      SaveFallbackDirsData;
    if BridgesRecalculate then
      SaveBridgesData;
    if (cbxRoutersCountry.Tag = -2) or ExcludeUpdated then
      ShowRouters;
    if ExcludeUpdated then
    begin
      CalculateTotalNodes;
      LoadNodesList;
      ExcludeUpdated := False;
    end;
    FilterUpdated := False;
  end;
end;

procedure TTcp.UpdateOptionsAfterRoutersUpdate;
begin
  if BridgesRecalculate then
    SaveBridgesData;
  if FallbackDirsRecalculate then
    SaveFallbackDirsData;
  if FilterUpdated then
  begin
    CalculateFilterNodes;
    ShowFilter;
    FilterUpdated := False;
  end;
  if RoutersUpdated then
  begin
    LoadNodesList;
    RoutersUpdated := False;
  end;
end;

procedure TTcp.sgFilterExit(Sender: TObject);
begin
  UpdateRoutersAfterFilterUpdate;
end;

procedure TTcp.sgFilterFixedCellClick(Sender: TObject; ACol, ARow: Integer);
begin
  if ACol = FILTER_FLAG then
    Exit;
  SortPrepare(sgFilter, ACol, True);
end;

procedure TTcp.ChangeFilter;
var
  i: Integer;
  Key: string;
  FNodeType: TNodeType;
  FilterInfo: TFilterInfo;

  procedure DeleteExclude;
  begin
    if sgFilter.Cells[FILTER_EXCLUDE_NODES, sgFilter.SelRow] = EXCLUDE_CHAR then
    begin
      sgFilter.Cells[FILTER_EXCLUDE_NODES, sgFilter.SelRow] := '';
      NodesDic.Remove(Key);
      FilterInfo.Data := [];
      ExcludeUpdated := True;
    end;
  end;

begin
  Key := LowerCase(sgFilter.Cells[FILTER_ID, sgFilter.SelRow]);
  if not FilterDic.ContainsKey(Key) then
    Exit;
  case sgFilter.SelCol of
    FILTER_ENTRY_NODES: FNodeType := ntEntry;
    FILTER_MIDDLE_NODES: FNodeType := ntMiddle;
    FILTER_EXIT_NODES: FNodeType := ntExit;
    FILTER_EXCLUDE_NODES: FNodeType := ntExclude;
    else
      Exit;
  end;
  FilterDic.TryGetValue(Key,  FilterInfo);

  if FNodeType = ntExclude then
  begin
    if sgFilter.Cells[FILTER_EXCLUDE_NODES, sgFilter.SelRow] = '' then
    begin
      sgFilter.Cells[FILTER_EXCLUDE_NODES, sgFilter.SelRow] := EXCLUDE_CHAR;
      for i := FILTER_ENTRY_NODES to FILTER_EXIT_NODES do
        sgFilter.Cells[i, sgFilter.SelRow] := '';
      NodesDic.AddOrSetValue(Key, [ntExclude]);
      FilterInfo.Data := [];
      ExcludeUpdated := True;
    end
    else
      DeleteExclude;
  end
  else
  begin
    if sgFilter.Cells[sgFilter.SelCol, sgFilter.SelRow] = '' then
    begin
      DeleteExclude;
      sgFilter.Cells[sgFilter.SelCol, sgFilter.SelRow] := SELECT_CHAR;
      Include(FilterInfo.Data, FNodeType);
    end
    else
    begin
      sgFilter.Cells[sgFilter.SelCol, sgFilter.SelRow] := '';
      Exclude(FilterInfo.Data, FNodeType);
    end;
  end;

  FilterDic.AddOrSetValue(Key, FilterInfo);
  CheckNodesListState(EXCLUDE_ID);
  CalculateFilterNodes(False);
  FilterUpdated := True;
  EnableOptionButtons;
  if FNodeType = ntExclude then
  begin
    BridgesUpdated := True;
    BridgesRecalculate := True;
    FallbackDirsUpdated := True;
    FallbackDirsRecalculate := True;
  end;
end;

procedure TTcp.sgFilterKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) and (sgFilter.SelCol > FILTER_PING) then
    ChangeFilter;
  GridKeyDown(sgFilter, Shift, Key);
end;

procedure TTcp.sgFilterKeyPress(Sender: TObject; var Key: Char);
begin
  if sgFilter.SelCol < FILTER_ENTRY_NODES then
    FindInGridColumn(sgFilter, sgFilter.SelCol, Key);
end;

procedure TTcp.sgFilterMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  CountryIndex: Integer;
begin
  if Button = mbRight then
    sgFilter.MouseToCell(X, Y, sgFilter.MovCol, sgFilter.MovRow);

  if (Button = mbLeft) and (ssDouble in Shift) then
  begin
    if (sgFilter.MovCol in [FILTER_TOTAL..FILTER_ALIVE]) and (sgFilter.MovRow > 0) and (sgFilter.Cells[sgFilter.MovCol, sgFilter.MovRow] <> NONE_CHAR) then
    begin
      LoadRoutersFilterData(LastRoutersFilter, False, True);
      case sgFilter.MovCol of
        FILTER_TOTAL:
        begin
          RoutersCustomFilter := FILTER_BY_TOTAL;
          if miExcludeBridgesWhenCounting.Checked then
            IntToMenu(mnShowNodes.Items, 8192)
          else
            IntToMenu(mnShowNodes.Items, 0);
        end;
        FILTER_GUARD:
        begin
          RoutersCustomFilter := FILTER_BY_GUARD;
          IntToMenu(mnShowNodes.Items, 2);
        end;
        FILTER_EXIT:
        begin
          RoutersCustomFilter := FILTER_BY_EXIT;
          IntToMenu(mnShowNodes.Items, 1);
        end;
        FILTER_BRIDGE:
        begin
          RoutersCustomFilter := FILTER_BY_BRIDGE;
          IntToMenu(mnShowNodes.Items, 16);
        end;
        FILTER_ALIVE:
        begin
          RoutersCustomFilter := FILTER_BY_ALIVE;
          if miExcludeBridgesWhenCounting.Checked then
            IntToMenu(mnShowNodes.Items, 10240)
          else
            IntToMenu(mnShowNodes.Items, 2048);
        end;
      end;
      CountryIndex := FilterDic.Items[LowerCase(sgFilter.Cells[FILTER_ID, sgFilter.MovRow])].cc;
      cbxRoutersCountry.ItemIndex := cbxRoutersCountry.Items.IndexOf(TransStr(CountryCodes[CountryIndex]));
      cbxRoutersCountry.Tag := CountryIndex;
      CheckShowRouters;
      ShowRouters;
      sbShowRouters.Click;
      SaveRoutersFilterdata(False, False);
    end;
  end;
  if (sgFilter.SelCol > FILTER_PING) and (sgFilter.MovRow > 0) and (Button = mbLeft) then
    ChangeFilter;
end;

procedure TTcp.sgFilterMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  sgFilter.MouseToCell(X, Y, sgFilter.MovCol, sgFilter.MovRow);
  GridSetFocus(sgFilter);
  GridShowHints(sgFilter);
  GridCheckAutoPopup(sgFilter, sgFilter.MovRow);
  if (sgFilter.MovCol in [FILTER_TOTAL..FILTER_ALIVE]) and (sgFilter.MovRow > 0) and (sgFilter.Cells[sgFilter.MovCol, sgFilter.MovRow] <> NONE_CHAR) then
    sgFilter.Cursor := crHandPoint
  else
    sgFilter.Cursor := crDefault;
end;

procedure TTcp.sgFilterSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  GridSelectCell(sgFilter, ACol, ARow);
end;

procedure TTcp.sgHsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if ARow = 0 then
  begin
    case ACol of
      HS_STATE: GridDrawIcon(sgHs, Rect, lsMain, 17);
      else
        if ACol < HS_STATE then
          DrawText(sgHs.Canvas.Handle, PChar(HsHeader[ACol]), Length(HsHeader[ACol]), Rect, DT_CENTER);
    end;
  end;
  GridScrollCheck(sgHs, HS_NAME, 184);
end;

procedure TTcp.sgHsEnter(Sender: TObject);
begin
  tsHs.Tag := 1;
end;

procedure TTcp.sgHsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  GridKeyDown(sgHs, Shift, Key);
end;

procedure TTcp.sgHsPortsDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  if ARow = 0 then
    DrawText(sgHsPorts.Canvas.Handle, PChar(HsPortsHeader[ACol]), Length(HsPortsHeader[ACol]), Rect, DT_CENTER);
  GridScrollCheck(sgHsPorts, HSP_INTERFACE, 163);
end;

procedure TTcp.sgHsPortsEnter(Sender: TObject);
begin
  tsHs.Tag := 2;
end;

procedure TTcp.sgHsPortsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GridKeyDown(sgHsPorts, Shift, Key);
end;

procedure TTcp.sgHsMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  sgHs.MouseToCell(X, Y, sgHs.MovCol, sgHs.MovRow);
  GridSetFocus(sgHs);
  GridShowHints(sgHs);
  GridCheckAutoPopup(sgHs, sgHs.MovRow, True);
end;

procedure TTcp.sgHsPortsMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  sgHsPorts.MouseToCell(X, Y, sgHsPorts.MovCol, sgHsPorts.MovRow);
  GridSetFocus(sgHsPorts);
  GridShowHints(sgHsPorts);
  GridCheckAutoPopup(sgHsPorts, sgHsPorts.MovRow, True);
end;

procedure TTcp.UpdateTransports;
begin
  if IsEmptyGrid(sgTransports) then
  begin
    edTransports.Text := '';
    edTransportsHandler.Text := '';
    cbxTransportType.ItemIndex := 0;
    meHandlerParams.Clear;
    TransportsEnable(False);
  end;
end;

procedure TTcp.UpdateHs;
begin
  if IsEmptyGrid(sgHs) then
  begin
    ClearGrid(sgHsPorts);
    edHsName.Text := '';
    cbxHsVersion.ItemIndex := HS_VERSION_3;
    cbxHsState.ItemIndex := HS_STATE_DISABLED;
    udHsNumIntroductionPoints.Position := 3;
    cbHsMaxStreams.Checked := False;
    cbxHsAddress.ItemIndex := 0;
    udHsRealPort.Position := StrToInt(DEFAULT_PORT);
    udHsVirtualPort.Position := StrToInt(DEFAULT_PORT);
    HsControlsEnable(False);
  end;
end;

procedure TTcp.UpdateHsPorts;
var
  i: Integer;
  Ports: string;
begin
  Ports := '';
  if IsEmptyGrid(sgHsPorts) then
  begin
    sgHs.Cells[HS_PORTS_DATA, sgHs.SelRow] := '';
    cbxHsAddress.ItemIndex := 0;
    udHsRealPort.Position := StrToInt(DEFAULT_PORT);
    udHsVirtualPort.Position := StrToInt(DEFAULT_PORT);
    HsPortsEnable(False);
  end
  else
  begin
    for i := 1 to sgHsPorts.RowCount - 1 do
      Ports := Ports + '|' +
        sgHsPorts.Cells[HSP_INTERFACE, i] + ',' +
        sgHsPorts.Cells[HSP_REAL_PORT, i] + ',' +
        sgHsPorts.Cells[HSP_VIRTUAL_PORT, i];
    Delete(Ports, 1, 1);
    sgHs.Cells[HS_PORTS_DATA, sgHs.SelRow] := Ports;
  end;
end;

procedure TTcp.sgHsSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  GridSelectCell(sgHs, ACol, ARow);
  SelectHs;
end;

procedure TTcp.sgRoutersDblClick(Sender: TObject);
begin
  if (sgRouters.MovCol in [ROUTER_FLAG, ROUTER_COUNTRY]) and (sgRouters.MovRow > 0) then
    FindInFilter(sgRouters.Cells[ROUTER_IP, sgRouters.MovRow]);
end;

procedure TTcp.sgRoutersDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  RouterID: string;
  RouterInfo: TRouterInfo;
  Indent, Mask, Interval, ImageIndex: Integer;

  procedure DrawFlagIcon(Flag: Word; Index: Integer);
  begin
    if Indent > Interval then
    begin
      if Mask and Flag <> 0 then
      begin
        lsMenus.Draw(sgRouters.Canvas, Rect.Left + (Rect.Width - Indent) div 2 + Interval, Rect.Top + (Rect.Height - 16) div 2, Index, True);
        Inc(Interval, 16);
      end;
    end
    else
      Exit;
  end;

begin
  if ARow = 0 then
  begin
    if ACol = ROUTER_WEIGHT then
      Rect.Right := Rect.Right + 2;
    case ACol of
      ROUTER_FLAG: GridDrawIcon(sgRouters, Rect, lsMain, 6);
      ROUTER_ENTRY_NODES: GridDrawIcon(sgRouters, Rect, lsMain, 7);
      ROUTER_MIDDLE_NODES: GridDrawIcon(sgRouters, Rect, lsMain, 8);
      ROUTER_EXIT_NODES: GridDrawIcon(sgRouters, Rect, lsMain, 9);
      ROUTER_EXCLUDE_NODES: GridDrawIcon(sgRouters, Rect, lsMain, 10);
      else
        DrawText(sgRouters.Canvas.Handle, PChar(RoutersHeader[ACol - 1]), Length(RoutersHeader[ACol - 1]), Rect, DT_CENTER);
    end;
    if (ACol = sgRouters.SortCol) and (ACol < ROUTER_ENTRY_NODES) then
      GridDrawSortArrows(sgRouters, Rect);
  end;
  if ARow > 0 then
  begin
    if ACol = ROUTER_FLAG then
    begin
      if sgRouters.Cells[ROUTER_IP, ARow] <> '' then
        GridDrawIcon(sgRouters, Rect, lsFlags, GetCountryValue(sgRouters.Cells[ROUTER_IP, ARow]), 20, 13);
    end;
    if ACol = ROUTER_FLAGS then
    begin
      RouterID := sgRouters.Cells[ROUTER_ID, ARow];

      if RoutersDic.TryGetValue(RouterID, RouterInfo) then
      begin
        Mask := RouterInfo.Params;
        if Mask <> 0 then
        begin
          Interval := 0;
          Indent := GetRoutersParamsCount(Mask) * 16;
          if Mask and ROUTER_BRIDGE <> 0 then
          begin
            if rfRelay in RouterInfo.Flags then
              ImageIndex := 62
            else
            begin
              if rfNoBridgeRelay in RouterInfo.Flags then
                ImageIndex := 63
              else
                ImageIndex := 28;
            end;
            lsMenus.Draw(sgRouters.Canvas, Rect.Left + (Rect.Width - Indent) div 2 + Interval, Rect.Top + (Rect.Height - 16) div 2, ImageIndex, True);
            Inc(Interval, 16);
          end;
          DrawFlagIcon(ROUTER_AUTHORITY, 54);
          DrawFlagIcon(ROUTER_ALIVE, 56);
          DrawFlagIcon(ROUTER_REACHABLE_IPV6, 34);
          DrawFlagIcon(ROUTER_HS_DIR, 53);
          DrawFlagIcon(ROUTER_DIR_MIRROR, 38);
          DrawFlagIcon(ROUTER_NOT_RECOMMENDED, 44);
          DrawFlagIcon(ROUTER_BAD_EXIT, 43);
          DrawFlagIcon(ROUTER_MIDDLE_ONLY, 61);
        end;
      end;
    end;
  end;
  if ACol = sgRouters.SelCol then
    UpdateSelectedRouter;
end;

procedure TTcp.UpdateSelectedRouter;
begin
  if sgRouters.SelectAllState then
    Exit;
  lbSelectedRouters.Caption := IntToStr(sgRouters.Selection.Bottom - sgRouters.Selection.Top + 1);
end;

procedure TTcp.sgRoutersFixedCellClick(Sender: TObject; ACol, ARow: Integer);
begin
  if ACol = ROUTER_FLAG then
    Exit;
  SortPrepare(sgRouters, ACol, True);
end;

procedure TTcp.sgRoutersKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) and (sgRouters.SelCol > ROUTER_FLAGS) and not (ssShift in Shift) then
    ChangeRouters;
  GridKeyDown(sgRouters, Shift, Key);
end;

procedure TTcp.sgRoutersKeyPress(Sender: TObject; var Key: Char);
begin
  if sgRouters.SelCol < ROUTER_FLAGS then
    FindInGridColumn(sgRouters, sgRouters.SelCol, Key);
end;

procedure TTcp.sgRoutersMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    sgRouters.MouseToCell(X, Y, sgRouters.MovCol, sgRouters.MovRow);
  if (sgRouters.SelCol > ROUTER_FLAGS) and (sgRouters.MovRow > 0) and (Button = mbLeft) and not (ssShift in Shift) then
    ChangeRouters;
end;

function TTcp.GetFilterLabel(FilterID: Integer): TLabel;
begin
  case FilterID of
    FILTER_ENTRY_NODES: Result := lbFilterEntry;
    FILTER_MIDDLE_NODES: Result := lbFilterMiddle;
    FILTER_EXIT_NODES: Result := lbFilterExit;
    FILTER_EXCLUDE_NODES: Result := lbFilterExclude;
    else
      Result := nil;
  end;
end;

function TTcp.GetFavoritesLabel(FavoritesID: Integer): TLabel;
begin
  case FavoritesID of
    ENTRY_ID: Result := lbFavoritesEntry;
    MIDDLE_ID: Result := lbFavoritesMiddle;
    EXIT_ID: Result := lbFavoritesExit;
    EXCLUDE_ID: Result := lbExcludeNodes;
    FAVORITES_ID: Result := lbFavoritesTotal;
    BRIDGES_ID: Result := lbFavoritesBridges;
    FALLBACK_DIR_ID: Result := lbFavoritesFallbackDirs;
    else
      Result := nil;
  end;
end;

procedure TTcp.ChangeRouters;
var
  i: Integer;
  Key, CountryCode, FindCidr, NodeStr, SelData, ConvertMsg: string;
  FNodeTypes: TNodeTypes;
  NodeTypeID: TNodeType;
  RouterInfo: TRouterInfo;
  NodesList: TStringList;
  HashMode, FindCountry, ConvertNodes: Boolean;
  NodeDataType: TNodeDataType;
  Nodes: ArrOfNodes;

  function IsHashMode: Boolean;
  begin
    case NodesList.Count of
      0: Result := True;
      1: Result := ValidHash(NodesList[0]);
      else
        Result := False;
    end;
  end;

  procedure FindNode(NodeStr: string; NodeType: TNodeType; IsCountry: Boolean = False);
  begin
    if NodesDic.ContainsKey(NodeStr) then
    begin
      if NodeType in NodesDic.Items[NodeStr] then
      begin
        if IsCountry then
        begin
          NodesList.Append(UpperCase(NodeStr) + ' (' + TransStr(NodeStr) + ')');
          FindCountry := True;
        end
        else
          NodesList.Append(NodeStr);
      end;
    end;
  end;

  procedure CreateNodesList(NodeType: TNodeType);
  var
    i: Integer;
    ParseStr: ArrOfStr;
  begin
    NodesList.Clear;
    FindNode(Key, NodeType);
    FindNode(RouterInfo.IPv4, NodeType);
    FindCidr := FindInRanges(RouterInfo.IPv4, atIPv4Cidr);
    if FindCidr <> '' then
    begin
      ParseStr := Explode(',', FindCidr);
      for i := 0 to Length(ParseStr) - 1 do
        FindNode(ParseStr[i], NodeType);
      SortNodesList(NodesList, SORT_DESC);
    end;
    FindNode(CountryCode, NodeType, True);
  end;

begin
  if ConnectState = 1 then
    Exit;
  Key := sgRouters.Cells[ROUTER_ID, sgRouters.SelRow];
  SelData := sgRouters.Cells[sgRouters.SelCol, sgRouters.SelRow];
  if (SelData = NONE_CHAR) or (SelData = BOTH_CHAR) then
    Exit;
  if RoutersDic.TryGetValue(Key, RouterInfo) then
  begin

    FindCountry := False;
    NodeTypeID := TNodeType(sgRouters.SelCol);
    CountryCode := CountryCodes[GetCountryValue(RouterInfo.IPv4)];

    NodesList := TStringList.Create;
    try
      NodesList.QuoteChar := #0;
      CreateNodesList(NodeTypeID);
      HashMode := IsHashMode;
      if HashMode then
      begin
        NodesDic.TryGetValue(Key,  FNodeTypes);
        if SelData = '' then
        begin
          if sgRouters.SelCol = ROUTER_EXCLUDE_NODES then
          begin
            sgRouters.Cells[ROUTER_EXCLUDE_NODES, sgRouters.SelRow] := EXCLUDE_CHAR;
            for i := ROUTER_ENTRY_NODES to ROUTER_EXIT_NODES do
            begin
              CreateNodesList(TNodeType(i));
              if IsHashMode then
              begin
                if CheckRouterFlags(i, RouterInfo) then
                  sgRouters.Cells[i, sgRouters.SelRow] := ''
                else
                  sgRouters.Cells[i, sgRouters.SelRow] := NONE_CHAR;
              end
              else
                sgRouters.Cells[i, sgRouters.SelRow] := FAVERR_CHAR;
            end;
            FNodeTypes := [];
          end
          else
          begin
            if sgRouters.Cells[ROUTER_EXCLUDE_NODES, sgRouters.SelRow] = EXCLUDE_CHAR then
              sgRouters.Cells[sgRouters.SelCol, sgRouters.SelRow] := FAVERR_CHAR
            else
              sgRouters.Cells[sgRouters.SelCol, sgRouters.SelRow] := SELECT_CHAR;
          end;
          Include(FNodeTypes, NodeTypeID);
        end
        else
        begin
          if sgRouters.SelCol = ROUTER_EXCLUDE_NODES then
          begin
            sgRouters.Cells[ROUTER_EXCLUDE_NODES, sgRouters.SelRow] := '';
            for i := ROUTER_ENTRY_NODES to ROUTER_EXIT_NODES do
            begin
              if sgRouters.Cells[i, sgRouters.SelRow] <> NONE_CHAR then
              begin
                if (sgRouters.Cells[i, sgRouters.SelRow] = FAVERR_CHAR) and CheckRouterFlags(i, RouterInfo) then
                  sgRouters.Cells[i, sgRouters.SelRow] := SELECT_CHAR;
              end;
            end;
          end
          else
          begin
            if (SelData = FAVERR_CHAR) and ((not CheckRouterFlags(Integer(NodeTypeID), RouterInfo)) or FindSelectedBridge(Key, RouterInfo)) then
              sgRouters.Cells[sgRouters.SelCol, sgRouters.SelRow] := NONE_CHAR
            else
              sgRouters.Cells[sgRouters.SelCol, sgRouters.SelRow] := '';
          end;
          Exclude(FNodeTypes, NodeTypeID);
        end;
        NodesDic.AddOrSetValue(Key, FNodeTypes);
        SaveBridgesData;
      end
      else
      begin
        if SelData <> '' then
        begin
          ConvertNodes := PrepareNodesToRemove(NodesList.DelimitedText, NodeTypeID, Nodes);;
          if ConvertNodes then
            ConvertMsg := BR + BR + TransStr('146')
          else
            ConvertMsg := '';
          if ShowMsg(Format(TransStr('362'), [StringReplace(NodesList.DelimitedText, ',', BR, [rfReplaceAll]), TransStr(GetFavoritesLabel(Integer(NodeTypeID)).Hint), ConvertMsg]), '', mtQuestion, True) then
          begin
            for i := 0 to NodesList.Count - 1 do
            begin
              NodeStr := SeparateLeft(NodesList[i], ' ');
              NodeDataType := ValidNode(NodeStr);
              if NodeDataType = dtCode then
                NodeStr := LowerCase(NodeStr);
              if NodesDic.TryGetValue(NodeStr, FNodeTypes) then
              begin
                Exclude(FNodeTypes, NodeTypeID);
                NodesDic.AddOrSetValue(NodeStr, FNodeTypes);
              end;
            end;
            if ConvertNodes then
              RemoveFromNodesListWithConvert(Nodes, NodeTypeID);
          end
          else
            Exit;
        end;
      end;
    finally
      NodesList.Free;
    end;

    CheckNodesListState(Integer(NodeTypeID));
    CalculateTotalNodes(False);
    if HashMode then
    begin
      if NodeTypeID = ntExclude then
      begin
        if FindSelectedBridge(Key, RouterInfo) then
        begin
          SaveBridgesData;
          if SelData <> ''  then
            sgRouters.Cells[ROUTER_ENTRY_NODES, sgRouters.SelRow] := BOTH_CHAR;
        end;
        if UsedFallbackDirs.ContainsKey(RouterInfo.IPv4 + '|' + IntToStr(RouterInfo.Port)) then
          SaveFallbackDirsData;
      end;
    end
    else
    begin
      if NodeTypeID = ntExclude then
      begin
        SaveBridgesData;
        SaveFallbackDirsData;
      end;
      ShowRouters;
      FilterUpdated := FindCountry;
    end;

    RoutersUpdated := True;
    EnableOptionButtons;
  end;
end;

procedure TTcp.ShowCircuitsFlagsHint;
var
  Fail: Boolean;
  Mask, MaxItems: Integer;
  Params: string;
  CellRect, CellPoint: TRect;
  Data: array of Word;
  ArrayIndex: Integer;

  procedure CheckMask(Param: Integer);
  begin
    if Mask and Param <> 0 then
    begin
      SetLength(Data, MaxItems + 1);
      Data[MaxItems] := Param;
      Inc(MaxItems);
    end;
  end;
begin
  Fail := True;
  if not IsEmptyRow(sgCircuits, sgCircuits.MovRow) then
  begin
    Params := sgCircuits.Cells[CIRC_PARAMS, sgCircuits.MovRow];
    if Params <> '' then
    begin
      Mask := StrToIntDef(SeparateLeft(Params, '|'), CF_OTHER);
      MaxItems := 0;

      CheckMask(CF_EXIT);
      CheckMask(CF_INTERNAL);
      CheckMask(CF_HIDDEN_SERVICE);
      CheckMask(CF_VANGUARDS);
      CheckMask(CF_CLIENT);
      CheckMask(CF_SERVICE);
      CheckMask(CF_DIR_REQUEST);
      CheckMask(CF_INTRO);
      CheckMask(CF_REND);
      CheckMask(CF_MEASURE_TIMEOUT);
      CheckMask(CF_CIRCUIT_PADDING);
      CheckMask(CF_TESTING);
      CheckMask(CF_PATH_BIAS_TESTING);
      CheckMask(CF_CONTROLLER);
      CheckMask(CF_OTHER);

      CellRect := sgCircuits.CellRect(CIRC_FLAGS, sgCircuits.MovRow);
      CellPoint := sgCircuits.ClientToScreen(CellRect);

      ArrayIndex := (Mouse.CursorPos.X - CellPoint.Left - (CellRect.Width - MaxItems * 16) div 2);
      if InRange(ArrayIndex, 0, MaxItems * 16 - 1) then
      begin
        case Data[ArrayIndex div 16] of
          CF_EXIT: sgCircuits.Hint := TransStr('333');
          CF_INTERNAL: sgCircuits.Hint := TransStr('332');
          CF_HIDDEN_SERVICE: sgCircuits.Hint := TransStr('122');
          CF_VANGUARDS: sgCircuits.Hint := TransStr('665');
          CF_CLIENT: sgCircuits.Hint := TransStr('663');
          CF_SERVICE: sgCircuits.Hint := TransStr('664');
          CF_DIR_REQUEST: sgCircuits.Hint := TransStr('331');
          CF_INTRO: sgCircuits.Hint := TransStr('666');
          CF_REND: sgCircuits.Hint := TransStr('667');
          CF_MEASURE_TIMEOUT: sgCircuits.Hint := TransStr('344');
          CF_CIRCUIT_PADDING: sgCircuits.Hint := TransStr('343');
          CF_TESTING: sgCircuits.Hint := TransStr('342');
          CF_PATH_BIAS_TESTING: sgCircuits.Hint := TransStr('341');
          CF_CONTROLLER: sgCircuits.Hint := TransStr('661');
          CF_OTHER: sgCircuits.Hint := TransStr('345');
          else
            sgCircuits.Hint := TransStr('392');
        end;
        Application.ActivateHint(Mouse.CursorPos);
        Exit;
      end;
    end;
  end;

  if Fail then
  begin
    Application.CancelHint;
    sgCircuits.Hint := '';
  end;
end;

procedure TTcp.ShowRoutersParamsHint;
var
  RouterInfo: TRouterInfo;
  Mask, MaxItems: Integer;
  Fail: Boolean;
  CellRect, CellPoint: TRect;
  Data: array of Word;
  ArrayIndex: Integer;

  procedure CheckMask(Param: Integer);
  begin
    if Mask and Param <> 0 then
    begin
      SetLength(Data, MaxItems + 1);
      Data[MaxItems] := Param;
      Inc(MaxItems);
    end;
  end;

begin
  Fail := True;
  if not IsEmptyRow(sgRouters, sgRouters.MovRow) then
  begin
    if RoutersDic.TryGetValue(sgRouters.Cells[ROUTER_ID, sgRouters.MovRow], RouterInfo) then
    begin
      Mask := RouterInfo.Params;
      if Mask > 0 then
      begin
        MaxItems := 0;
        CheckMask(ROUTER_BRIDGE);
        CheckMask(ROUTER_AUTHORITY);
        CheckMask(ROUTER_ALIVE);
        CheckMask(ROUTER_REACHABLE_IPV6);
        CheckMask(ROUTER_HS_DIR);
        CheckMask(ROUTER_DIR_MIRROR);
        CheckMask(ROUTER_NOT_RECOMMENDED);
        CheckMask(ROUTER_BAD_EXIT);
        CheckMask(ROUTER_MIDDLE_ONLY);

        CellRect := sgRouters.CellRect(ROUTER_FLAGS, sgRouters.MovRow);
        CellPoint := sgRouters.ClientToScreen(CellRect);

        ArrayIndex := (Mouse.CursorPos.X - CellPoint.Left - (CellRect.Width - MaxItems * 16) div 2);
        if InRange(ArrayIndex, 0, MaxItems * 16 - 1) then
        begin
          case Data[ArrayIndex div 16] of
            ROUTER_BRIDGE:
            begin
              if rfRelay in RouterInfo.Flags then
                sgRouters.Hint := TransStr('645')
              else
              begin
                if rfNoBridgeRelay in RouterInfo.Flags then
                  sgRouters.Hint := TransStr('655')
                else
                  sgRouters.Hint := TransStr('384');
              end
            end;
            ROUTER_AUTHORITY: sgRouters.Hint := TransStr('385');
            ROUTER_ALIVE: sgRouters.Hint := TransStr('386');
            ROUTER_REACHABLE_IPV6: sgRouters.Hint := TransStr('387');
            ROUTER_HS_DIR: sgRouters.Hint := TransStr('388');
            ROUTER_DIR_MIRROR: sgRouters.Hint := Format(TransStr('389'), [RouterInfo.DirPort]);
            ROUTER_NOT_RECOMMENDED: sgRouters.Hint := TransStr('390');
            ROUTER_BAD_EXIT: sgRouters.Hint := TransStr('391');
            ROUTER_MIDDLE_ONLY: sgRouters.Hint := TransStr('640');
            else
              sgRouters.Hint := TransStr('392');
          end;
          Application.ActivateHint(Mouse.CursorPos);
          Exit;
        end;
      end;
    end;
  end;

  if Fail then
  begin
    Application.CancelHint;
    sgRouters.Hint := '';
  end;
end;

procedure TTcp.sgRoutersMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  sgRouters.MouseToCell(X, Y, sgRouters.MovCol, sgRouters.MovRow);
  if not (edRoutersQuery.Focused or edRoutersWeight.Focused) then
    GridSetFocus(sgRouters);
  if miRoutersShowFlagsHint.Checked and (sgRouters.MovCol = ROUTER_FLAGS) then
    ShowRoutersParamsHint
  else
    GridShowHints(sgRouters);
  GridCheckAutoPopup(sgRouters, sgRouters.MovRow, True);
  if (sgRouters.MovCol in [ROUTER_FLAG, ROUTER_COUNTRY]) and (sgRouters.MovRow > 0) and not IsEmptyRow(sgRouters, sgRouters.MovRow) then
    sgRouters.Cursor := crHandPoint
  else
    sgRouters.Cursor := crDefault;
end;

procedure TTcp.sgRoutersSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  GridSelectCell(sgRouters, ACol, ARow);
end;

procedure TTcp.sgStreamsInfoDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  if ARow = 0 then
  begin
    if ACol > 0 then
    begin
      case ACol of
        STREAMS_INFO_BYTES_READ: GridDrawIcon(sgStreamsInfo, Rect, lsMain, 15);
        STREAMS_INFO_BYTES_WRITTEN: GridDrawIcon(sgStreamsInfo, Rect, lsMain, 16);
        else
          DrawText(sgStreamsInfo.Canvas.Handle, PChar(StreamsInfoHeader[ACol - 1]), Length(StreamsInfoHeader[ACol - 1]), Rect, DT_CENTER);
      end;
      if ACol = sgStreamsInfo.SortCol then
        GridDrawSortArrows(sgStreamsInfo, Rect);
    end;
  end;
end;

procedure TTcp.sgStreamsInfoFixedCellClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  miStreamsInfoSort.Items[ACol].Checked := True;
  SortPrepare(sgStreamsInfo, ACol, True);
end;

procedure TTcp.sgStreamsInfoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GridKeyDown(sgStreamsInfo, Shift, Key);
  case Key of
    VK_F5: ShowCircuits;
  end;
end;

procedure TTcp.sgStreamsInfoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    sgStreamsInfo.MouseToCell(X, Y, sgStreamsInfo.MovCol, sgStreamsInfo.MovRow);
end;

procedure TTcp.sgStreamsInfoMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  sgStreamsInfo.MouseToCell(X, Y, sgStreamsInfo.MovCol, sgStreamsInfo.MovRow);
  GridSetFocus(sgStreamsInfo);
  GridShowHints(sgStreamsInfo);
  GridCheckAutoPopup(sgStreamsInfo, sgStreamsInfo.MovRow, True);
end;

procedure TTcp.sgStreamsInfoSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  GridSelectCell(sgStreamsInfo, ACol, ARow);
end;

procedure TTcp.sgStreamsDblClick(Sender: TObject);
begin
  if (sgStreams.MovRow > 0) and (sgStreams.MovCol = STREAMS_TARGET) then
    ShellOpen(sgStreams.Cells[STREAMS_TARGET, sgStreams.SelRow]);
end;

procedure TTcp.sgStreamsDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  if ARow = 0 then
  begin
    if ACol > 0 then
    begin
      case ACol of
        STREAMS_TRACK: GridDrawIcon(sgStreams, Rect, lsMain, 11);
        STREAMS_COUNT: GridDrawIcon(sgStreams, Rect, lsMain, 8);
        STREAMS_BYTES_READ: GridDrawIcon(sgStreams, Rect, lsMain, 15);
        STREAMS_BYTES_WRITTEN: GridDrawIcon(sgStreams, Rect, lsMain, 16);
        else
          DrawText(sgStreams.Canvas.Handle, PChar(StreamsHeader[ACol - 1]), Length(StreamsHeader[ACol - 1]), Rect, DT_CENTER);
      end;
      if (ACol = sgStreams.SortCol) and (ACol in [STREAMS_TARGET, STREAMS_BYTES_READ, STREAMS_BYTES_WRITTEN]) then
        GridDrawSortArrows(sgStreams, Rect);
    end;
  end;
end;

procedure TTcp.sgStreamsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GridKeyDown(sgStreams, Shift, Key);
  case Key of
    VK_F5: ShowCircuits;
  end;
end;

procedure TTcp.sgStreamsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    sgStreams.MouseToCell(X, Y, sgStreams.MovCol, sgStreams.MovRow);
end;

procedure TTcp.sgStreamsMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  sgStreams.MouseToCell(X, Y, sgStreams.MovCol, sgStreams.MovRow);
  GridSetFocus(sgStreams);
  GridShowHints(sgStreams);
  GridCheckAutoPopup(sgStreams, sgStreams.MovRow, True);
  if (sgStreams.MovCol = STREAMS_TARGET) and (sgStreams.MovRow > 0) and not IsEmptyRow(sgStreams, sgStreams.MovRow) then
    sgStreams.Cursor := crHandPoint
  else
    sgStreams.Cursor := crDefault;
end;

procedure TTcp.sgStreamsSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  GridSelectCell(sgStreams, ACol, ARow);
  ShowStreamsInfo(sgCircuits.Cells[CIRC_ID, sgCircuits.SelRow], sgStreams.Cells[STREAMS_TARGET, sgStreams.SelRow]);
end;

procedure TTcp.sgTransportsDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  if ARow = 0 then
    DrawText(sgTransports.Canvas.Handle, PChar(TransportsHeader[ACol]), Length(TransportsHeader[ACol]), Rect, DT_CENTER);
  GridScrollCheck(sgTransports, PT_TRANSPORTS, 204);
end;

procedure TTcp.sgTransportsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GridKeyDown(sgTransports, Shift, Key);
end;

procedure TTcp.sgTransportsMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  sgTransports.MouseToCell(X, Y, sgTransports.MovCol, sgTransports.MovRow);
  GridSetFocus(sgTransports);
  GridShowHints(sgTransports);
  GridCheckAutoPopup(sgTransports, sgTransports.MovRow, True);
end;

procedure TTcp.sgTransportsSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  GridSelectCell(sgTransports, ACol, ARow);
  SelectTransports;
end;

procedure TTcp.sgHsPortsSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  GridSelectCell(sgHsPorts, ACol, ARow);
  SelectHsPorts;
end;

procedure TTcp.SelectHs;
var
  i: Integer;
  ParseStr, Items: ArrOfStr;
begin
  if sgHs.SelRow = 0 then
    sgHs.SelRow := 1;
  if IsEmptyRow(sgHs, sgHs.SelRow) then
    Exit;
  edHsName.Text := sgHs.Cells[HS_NAME, sgHs.SelRow];
  case StrToIntDef(sgHs.Cells[HS_VERSION, sgHs.SelRow], HS_VERSION_3) of
    2: cbxHsVersion.ItemIndex := HS_VERSION_2;
    3: cbxHsVersion.ItemIndex := HS_VERSION_3;
  end;
  if sgHs.Cells[HS_STATE, sgHs.SelRow] = SELECT_CHAR then
    cbxHsState.ItemIndex := HS_STATE_ENABLED
  else
    cbxHsState.ItemIndex := HS_STATE_DISABLED;
  udHsNumIntroductionPoints.Position := StrToInt(sgHs.Cells[HS_INTRO_POINTS, sgHs.SelRow]);
  CheckHsVersion;
  if sgHs.Cells[HS_MAX_STREAMS, sgHs.SelRow] = NONE_CHAR then
  begin
    cbHsMaxStreams.Checked := False;
    HsMaxStreamsEnable(False);
  end
  else
  begin
    cbHsMaxStreams.Checked := True;
    HsMaxStreamsEnable(True);
    udHsMaxStreams.Position := StrToInt(sgHs.Cells[HS_MAX_STREAMS, sgHs.SelRow]);
  end;
  if sgHs.Cells[HS_PORTS_DATA, sgHs.SelRow] <> '' then
  begin
    Items := Explode('|', sgHs.Cells[HS_PORTS_DATA, sgHs.SelRow]);
    sgHsPorts.RowCount := Length(Items) + 1;
    for i := 0 to Length(Items) - 1 do
    begin
      ParseStr := Explode(',', Items[i]);
      sgHsPorts.Cells[HSP_INTERFACE, i + 1] := ParseStr[0];
      sgHsPorts.Cells[HSP_REAL_PORT, i + 1] := ParseStr[1];
      sgHsPorts.Cells[HSP_VIRTUAL_PORT, i + 1] := ParseStr[2];
    end;
    SelectHsPorts;
    HsPortsEnable(True);
  end
  else
  begin
    ClearGrid(sgHsPorts);
    HsPortsEnable(False);
  end;
end;

procedure TTcp.SelectHsPorts;
begin
  if sgHsPorts.SelRow = 0 then
    sgHsPorts.SelRow := 1;
  if IsEmptyRow(sgHsPorts, sgHsPorts.SelRow) then
    Exit;
  cbxHsAddress.ItemIndex := cbxHsAddress.Items.IndexOf(sgHsPorts.Cells[HSP_INTERFACE, sgHsPorts.SelRow]);
  udHsRealPort.Position := StrToInt(sgHsPorts.Cells[HSP_REAL_PORT, sgHsPorts.SelRow]);
  udHsVirtualPort.Position := StrToInt(sgHsPorts.Cells[HSP_VIRTUAL_PORT, sgHsPorts.SelRow]);
end;

procedure TTcp.SelectTransports;
begin
  if sgTransports.SelRow = 0 then
    sgTransports.SelRow := 1;
  edTransports.Text := sgTransports.Cells[PT_TRANSPORTS, sgTransports.SelRow];
  edTransportsHandler.Text := sgTransports.Cells[PT_HANDLER, sgTransports.SelRow];
  meHandlerParams.Text := sgTransports.Cells[PT_PARAMS, sgTransports.SelRow];
  cbxTransportType.ItemIndex := GetTransportID(sgTransports.Cells[PT_TYPE, sgTransports.SelRow]);
end;

procedure TTcp.SelectorMenuClick(Sender: TObject);
var
  i: Integer;
  Parent: TMenuItem;
  State, HandleDisabled: Boolean;
begin
  State := Boolean(TMenuItem(Sender).Tag);
  Parent := TMenuItem(Sender).Parent;
  HandleDisabled := Boolean(TMenuItem(Sender).HelpContext);

  for i := 0 to Parent.Count - 1 do
  begin
    if Parent.Items[i].AutoCheck and (Parent.Items[i].Enabled or HandleDisabled) then
      Parent.Items[i].Checked := State;
  end;
  case Parent.Tag of
    1: SetRoutersFilter(Sender);
    2: SetRoutersFilterState(Sender);
    3: SetCircuitsFilter(Sender);
    4: miTplSaveClick(Sender);
    5: miTplLoadClick(Sender);
  end;
end;

procedure TTcp.EnableOptionButtons(State: Boolean = True);
begin
  if State and OptionsLocked then
    Exit;
  btnApplyOptions.Enabled := State;
  btnCancelOptions.Enabled := State;
  OptionsChanged := State;
end;

procedure TTcp.ShowBalloon(Msg: string; Title: string = ''; Notice: Boolean = False; MsgType: TMsgType = mtInfo);
var
  MsgIcon: TBalloonFlags;
begin
  MsgIcon := bfNone;
  case MsgType of
    mtInfo: MsgIcon := bfInfo;
    mtWarning: MsgIcon := bfWarning;
    mtError: MsgIcon := bfError;
  end;
  if (Notice or ((cbShowBalloonHint.Checked) and (not cbShowBalloonOnlyWhenHide.Checked or
    (cbShowBalloonOnlyWhenHide.Checked and Visible = False)))) and not Closing then
  begin
    tiTray.BalloonFlags := MsgIcon;
    tiTray.BalloonTitle := GetMsgCaption(Title, MsgType);
    tiTray.BalloonHint := Msg;
    tiTray.ShowBalloonHint;
  end;
end;

procedure TTcp.SendDataThroughProxy;
var
  Http: TSendHttpThread;
begin
  if (UsedProxyType <> ptNone) and (ConnectState = 2) then
  begin
    Http := TSendHttpThread.Create(True);
    Http.FreeOnTerminate := True;
    Http.Priority := tpNormal;
    Http.Start;
  end;
end;

procedure TTcp.GetDNSExternalAddress(UpdateExternalIp: Boolean = True);
var
  Dns: TDNSSendThread;
begin
  if not UpdateExternalIp then
  begin
    if ValidAddress(ServerIPv4) = atIPv4 then
    begin
      GetIpStage := 0;
      UpdateServerInfo;
      Exit;
    end;
  end;
  Dns := TDNSSendThread.Create(True);
  Dns.FreeOnTerminate := True;
  Dns.Priority := tpNormal;
  Dns.Start;
end;

procedure TTcp.GetServerInfo(UpdateExternalIp: Boolean = True);
begin
  if cbxServerMode.ItemIndex > SERVER_MODE_NONE then
  begin
    GetIpStage := 1;
    if cbUseOpenDNS.Checked and not cbUseOpenDNSOnlyWhenUnknown.Checked then
      GetDNSExternalAddress(UpdateExternalIp)
    else
    begin
      if ConnectState = 2 then
      begin
        if UpdateExternalIp then
          SendCommand('GETINFO address')
      end
      else
        UpdateServerInfo;
    end;
  end;
end;

procedure TTcp.UpdateServerInfo;
var
  Fingerprint, ServerIp, BridgeStr: string;
  IsIPv4, IsIPv6, IsFingerprint, ServerIsBridge: Boolean;

  function ReplaceIp(Str: string): string;
  begin
    Result := StringReplace(Str, ServerIPv4, FormatHost(ServerIPv6), [rfReplaceAll]);
  end;

begin
  miServerCopyBridgeIPv4.Visible := False;
  miServerCopyBridgeIPv6.Visible := False;
  miServerCopyBridgeIPv4.Hint := '';
  miServerCopyBridgeIPv6.Hint := '';

  Fingerprint := SeparateRight(Trim(FileGetString(UserDir + 'fingerprint')), ' ');
  IsFingerprint := ValidHash(Fingerprint);
  if IsFingerprint then
    lbFingerprint.Caption := Fingerprint
  else
    lbFingerprint.Caption := TransStr('260');
  miServerCopyFingerprint.Caption := Fingerprint;
  miServerCopyFingerprint.Visible := IsFingerprint;

  IsIPv4 := ValidAddress(ServerIPv4) = atIPv4;
  IsIPv6 := (ValidAddress(ServerIPv6) = atIPv6) and cbListenIPv6.Checked;
  ServerIsBridge := cbxServerMode.ItemIndex = SERVER_MODE_BRIDGE;

  miServerCopyIPv4.Caption := ServerIPv4;
  miServerCopyIPv6.Caption := FormatHost(ServerIPv6);
  miServerCopyIPv4.Visible := IsIPv4;
  miServerCopyIPv6.Visible := IsIPv6;

  if IsIPv4 then
  begin
    if IsIPv6 then
      ServerIp := ServerIPv4 + ', ' + FormatHost(ServerIPv6)
    else
      ServerIp := ServerIPv4;
    lbServerExternalIp.Caption := ServerIp;

    if ServerIsBridge and IsFingerprint then
    begin
      if cbxBridgeType.ItemIndex = 0 then
        BridgeStr := ServerIPv4 + ':' + edORPort.Text + ' ' + lbFingerprint.Caption
      else
      begin
        BridgeStr := cbxBridgeType.Text + ' ' + ServerIPv4 + ':' + edTransportPort.Text + ' ' + lbFingerprint.Caption;
        if ServerIsObfs4 then
        begin
          miServerCopyBridgeIPv4.Hint := BridgeStr + ' ' + GetBridgeCert;
          BridgeStr := BridgeStr + '...';
        end;
      end;
      miServerCopyBridgeIPv4.Caption := BridgeStr;

      if IsIPv6 then
      begin
        lbBridge.Caption := BridgeStr + BR + ReplaceIp(BridgeStr);
        miServerCopyBridgeIPv6.Hint := ReplaceIp(miServerCopyBridgeIPv4.Hint);
        miServerCopyBridgeIPv6.Caption := ReplaceIp(BridgeStr);
      end
      else
        lbBridge.Caption := BridgeStr;

      miServerCopyBridgeIPv4.Visible := True;
      miServerCopyBridgeIPv6.Visible := IsIPv6;
    end
  end
  else
  begin
    lbServerExternalIp.Caption := TransStr('260');
    lbBridge.Caption := TransStr('260');
  end;
end;

procedure TTcp.InitPortForwarding(Test: Boolean);
var
  i: Integer;
begin
  UPnPMsg := '';
  GetLocalInterfaces(cbxSOCKSHost);
  if (cbxServerMode.ItemIndex > SERVER_MODE_NONE) and (cbUseUPnP.Checked) then
  begin
    for i := 0 to cbxSOCKSHost.items.Count - 1 do
    begin
      if not IpInRanges(cbxSOCKSHost.Items[i], PrivateRanges) then
        Continue;
      AddUPnPEntry(udORPort.Position, 'ORPort', cbxSOCKSHost.Items[i], Test, UPnPMsg);
      udORPort.Tag := udORPort.Position;
      if cbUseDirPort.Checked then
      begin
        AddUPnPEntry(udDirPort.Position, 'DirPort', cbxSOCKSHost.Items[i], Test, UPnPMsg);
        udDirPort.Tag := udDirPort.Position;
      end;
      if (cbxServerMode.ItemIndex = SERVER_MODE_BRIDGE) and (cbxBridgeType.ItemIndex > 0) then
      begin
        AddUPnPEntry(udTransportPort.Position, 'PTPort', cbxSOCKSHost.Items[i], Test, UPnPMsg);
        udTransportPort.Tag := udTransportPort.Position;
      end;
    end;
  end;
end;

procedure TTcp.LogListenerStart(hStdOut: THandle);
begin
  if not Assigned(Logger) then
  begin
    Logger := TReadPipeThread.Create(True);
    Logger.hStdOut := hStdOut;
    Logger.FreeOnTerminate := True;
    Logger.Priority := tpNormal;
    Logger.OnTerminate := LogThreadTerminate;
    Logger.Start;
  end;
end;

procedure TTcp.CheckVersionStart(hStdOut: THandle; FirstStart: Boolean);
begin
  if not Assigned(VersionChecker) then
  begin
    VersionChecker := TReadPipeThread.Create(True);
    VersionChecker.FirstStart := FirstStart;
    VersionChecker.hStdOut := hStdOut;
    VersionChecker.VersionCheck := True;
    VersionChecker.FreeOnTerminate := True;
    VersionChecker.Priority := tpNormal;
    VersionChecker.OnTerminate := VersionCheckerThreadTerminate;
    VersionChecker.Start;
  end;
end;

procedure TTcp.ControlPortConnect;
begin
  if not Assigned(Controller) then
  begin
    Controller := TControlThread.Create(True);
    Controller.FreeOnTerminate := True;
    Controller.Priority := tpNormal;
    Controller.OnTerminate := ControlThreadTerminate;
    Controller.Start;
  end;
end;

procedure TTcp.CheckOpenPorts(PortSpin: TUpDown; IP: string; var PortStr: string);
var
  Port: Integer;
begin
  if PortTCPIsOpen(PortSpin.Position, IP, 1) then
  begin
    PortStr := PortStr + ', ' + IntToStr(PortSpin.Position);
    Randomize;
    repeat
      Port := RandomRange(9000, 10000)
    until not PortTCPIsOpen(Port, IP, 1);
    PortSpin.Position := Port;
  end;
end;

procedure TTcp.CheckStatusControls;
var
  ServerIsBridge, ServerEnabled: Boolean;
begin
  if UsedProxyType in [ptSocks, ptBoth] then
    lbStatusSocksAddr.Caption := FormatHost(GetHost(cbxSOCKSHost.Text)) + ':' + IntToStr(udSOCKSPort.Position)
  else
    lbStatusSocksAddr.Caption := TransStr('226');

  if UsedProxyType in [ptHttp, ptBoth] then
    lbStatusHttpAddr.Caption := FormatHost(GetHost(cbxHttpTunnelHost.Text)) + ':' + IntToStr(udHttpTunnelPort.Position)
  else
    lbStatusHttpAddr.Caption := TransStr('226');

  CheckLabelEndEllipsis(lbStatusSocksAddr, 300, epPathEllipsis, False, True);
  CheckLabelEndEllipsis(lbStatusHttpAddr, 300, epPathEllipsis, False, True);

  ServerEnabled := cbxServerMode.ItemIndex > SERVER_MODE_NONE;
  ServerIsBridge := cbxServerMode.ItemIndex = SERVER_MODE_BRIDGE;

  lbBridge.Visible := ServerIsBridge;
  lbBridgeCaption.Visible := ServerIsBridge;
  gbServerInfo.Visible := ServerEnabled;
  if ServerEnabled then
    GetServerInfo(False);

  if cbEnablePingMeasure.Checked or cbEnableDetectAliveNodes.Checked then
  begin
    if cbAutoScanNewNodes.Checked then
      lbStatusScanner.Caption := TransStr('380')
    else
      lbStatusScanner.Caption := TransStr('381')
  end
  else
    lbStatusScanner.Caption := TransStr('226');

  if TorVersion = '0.0.0.0' then
    lbClientVersion.Caption := TransStr('110')
  else
    lbClientVersion.Caption := TorVersion;

  lbStatusFilterMode.Caption := cbxFilterMode.Text;

  if miEnableTotalsCounter.Checked then
  begin
    lbTotalDL.Caption := BytesFormat(TotalDL);
    lbTotalUL.Caption := BytesFormat(TotalUL);
    gbTotal.Hint := Format(TransStr('402'), [DateTimeToStr(UnixToDateTime(TotalStartDate))]);
    gbTotal.ShowHint := True;
  end
  else
  begin
    lbTotalDL.Caption := INFINITY_CHAR;
    lbTotalUL.Caption := INFINITY_CHAR;
    gbTotal.ShowHint := False;
    gbTotal.Hint := '';
  end;

  UpdateTrayHint;
end;

procedure TTcp.SetOptionsEnable(State: Boolean);
var
  i: Integer;
begin
  for i := 0 to pcOptions.PageCount - 1 do
    pcOptions.Pages[i].Enabled := State;
end;

procedure TTcp.CheckOptionsChanged;
var
  TorrcChanged, PathChanged, BridgesChanged, DefaultsChanged, FallbackDirsChanged, NeedReset: Boolean;
begin
  DefaultsChanged := DefaultsFileID <> GetFileID(DefaultsFile);
  TorrcChanged := TorrcFileID <> GetFileID(TorConfigFile);
  PathChanged := not CheckRequiredFiles;
  FallbackDirsChanged := (MissingFallbackDirCount > 0) or UpdateFallbackDirs;
  BridgesChanged := (FailedBridgesCount > 0) or (AlreadyStarted and (NewBridgesCount > 0)) or
    ((cbxBridgesType.ItemIndex = BRIDGES_TYPE_FILE) and (BridgeFileID <> GetFileID(BridgesFileName)));

  NeedReset := TorrcChanged or PathChanged or BridgesChanged or DefaultsChanged or FallbackDirsChanged;
  if OptionsChanged or NeedReset then
  begin
    if Restarting or NeedReset then
      ResetOptions
    else
    begin
      if ShowMsg(TransStr('354'), '', mtWarning, True) then
      begin
        if NodesListStage = 1 then
          SaveNodesList(cbxNodesListType.ItemIndex);
        ApplyOptions(True);
      end
      else
        ResetOptions;
    end;
  end;
end;

procedure TTcp.StartTor(AutoResolveErrors: Boolean = False);
var
  PortStr, Msg: string;
  FindVersion: Boolean;
begin
  if FileExists(TorExeFile) then
  begin
    FindVersion := True;
    if TorFileID <> GetFileID(TorExeFile, True, TorVersion) then
    begin
      if not AutoResolveErrors then
      begin
        FindVersion := GetTorVersion(False);
        if FindVersion then
          Exit;
      end;
    end;
    CheckOptionsChanged;
    PortStr := '';
    OptionsLocked := True;
    ForceDirectories(LogsDir);
    ForceDirectories(OnionAuthDir);
    CheckOpenPorts(udSOCKSPort, GetHost(cbxSOCKSHost.Text), PortStr);
    CheckOpenPorts(udHTTPTunnelPort, GetHost(cbxHTTPTunnelHost.Text), PortStr);
    CheckOpenPorts(udControlPort, LOOPBACK_ADDRESS, PortStr);
    if cbxServerMode.ItemIndex > SERVER_MODE_NONE then
    begin
      CheckOpenPorts(udORPort, LOOPBACK_ADDRESS, PortStr);
      if cbUseDirPort.Checked then
        CheckOpenPorts(udDirPort, LOOPBACK_ADDRESS, PortStr);
      if cbxBridgeType.ItemIndex > 0 then
        CheckOpenPorts(udTransportPort, LOOPBACK_ADDRESS, PortStr);
    end;
    Delete(PortStr, 1, 1);
    if PortStr <> '' then
    begin
      if ShowMsg(Format(TransStr('259'), [PortStr]), TransStr('246'), mtWarning, True) then
        ApplyOptions
      else
      begin
        ResetOptions;
        Exit;
      end;
    end;
    OptionsLocked := False;
    FileAge(UserDir + 'control_auth_cookie', LastAuthCookieDate);
    if LogAutoDelHours >= 0 then
      DeleteFiles(LogsDir + '*.log', LogAutoDelHours * 3600);
    TorMainProcess := ExecuteProcess(TorExeFile + ' -f "' + TorConfigFile + '"', [pfHideWindow, pfReadStdOut], hJob);
    if TorMainProcess.hProcess <> 0 then
    begin
      if CheckFileVersion(TorVersion, '0.4.0.5') then
      begin
        if GeoIpExists then
        begin
          if GeoFileID <> GetFileID(GeoIpFile, True) then
            GeoIpUpdating := True;
          if UnknownBridgesCountriesCount > 0 then
            FindBridgesCountries := True;
          if UnknownFallbackDirCountriesCount > 0 then
            FindFallbackDirCountries := True;
          if FindBridgesCountries or FindFallbackDirCountries then
            InfoStage := 1;
        end;
        StopCode := STOP_NORMAL;
        if miAutoClear.Checked then
        begin
          meLog.Clear;
          LogHasSel := False;
        end;
        StreamsDic.Clear;
        CircuitsDic.Clear;
        LockCircuits := False;
        LockCircuitInfo := False;
        LockStreams := False;
        LockStreamsInfo := False;
        ShowCircuits;
        Circuit := '';
        ExitNodeID := '';
        DLSpeed := 0;
        ULSpeed := 0;
        SessionDL := 0;
        SessionUL := 0;
        MaxDLSpeed := 0;
        MaxULSpeed := 0;
        ConnectProgress := 0;
        LastUserStreamProtocol := -1;
        LastSaveStats := DateTimeToUnix(Now);
        ConnectState := 1;
        TotalsNeedSave := False;
        SelectExitCircuit := False;
        tmTraffic.Enabled := True;
        tmCircuits.Enabled := True;
        tmConsensus.Enabled := True;
        UpdateConnectControls;
        if UsedProxyType <> ptNone then
        begin
          lbExitIp.Caption := TransStr('111');
          lbExitCountry.Caption := TransStr('112');
        end;
        SetOptionsEnable(False);
        ControlsDisable(tsNetwork);
        ControlsDisable(tsServer);
        edControlPort.Enabled := False;
        lbControlPort.Enabled := False;
        cbxAuthMetod.Enabled := False;
        lbAuthMetod.Enabled := False;
        if cbxAuthMetod.ItemIndex = 1 then
        begin
          edControlPassword.Enabled := False;
          lbControlPassword.Enabled := False;
          imGeneratePassword.Enabled := False;
        end;
        CheckStatusControls;
        if(cbShowBalloonHint.Checked and not cbShowBalloonOnlyWhenHide.Checked)
          or (not cbConnectOnStartup.Checked or (cbConnectOnStartup.Checked and (cbxMinimizeOnEvent.ItemIndex in [MINIMIZE_ON_ALL, MINIMIZE_ON_STARTUP]))) then
            if not Restarting then
              ShowBalloon(TransStr('240'));
        ControlPortConnect;
        if TorMainProcess.hStdOutput <> 0 then
          LogListenerStart(TorMainProcess.hStdOutput);
        InitPortForwarding(False);
      end
      else
      begin
        TerminateProcess(TorMainProcess.hProcess, 0);
        if not AutoResolveErrors then
        begin
          if Win32MajorVersion = 5 then
            Msg := TransStr('377') + BR + BR + TransStr('397')
          else
            Msg := TransStr('377');
          ShowMsg(Msg, '', mtWarning);
        end;
      end;
    end
    else
    begin
      if not AutoResolveErrors and FindVersion then
        ShowMsg(TransStr('238'), '', mtWarning);
    end;
  end
  else
  begin
    if not AutoResolveErrors then
    begin
      if (ShowMsg(TransStr('239'),'', mtWarning, True)) then
        ShellOpen(GetDefaultsValue('DownloadUrl', DOWNLOAD_URL));
    end;
  end;
end;

procedure TTcp.UpdateConnectProgress(Value: Integer);
var
  Str: string;
begin
  case Value of
    -1, 100: Str := TransStr('103');
    else
      Str := IntToStr(Value) + ' %';  
  end;
  if (Value = 100) and (ConnectState = 1) then
    Exit
  else
    btnChangeCircuit.Caption := Str;
end;

procedure TTcp.UpdateConnectControls;
var
  Value: Integer;
begin
  case ConnectState of
    1: Value := 0;
    2: Value := 100;
    else
      Value := -1;       
  end;
  UpdateConnectProgress(Value);
  btnSwitchTor.Caption := TransStr('10' + IntToStr(ConnectState));
  btnSwitchTor.ImageIndex := ConnectState;
  miSwitchTor.Caption := btnSwitchTor.Caption;
  miSwitchTor.ImageIndex := ConnectState;
  UpdateTrayIcon;
end;

procedure TTcp.StopTor;
var
  BridgesFullUpdate: Boolean;
begin
  TerminateProcess(TorMainProcess.hProcess, 0);
  if Assigned(Controller) then
    Controller.Terminate;
  if Assigned(Consensus) then
    Consensus.Terminate;
  if Assigned(Descriptors) then
    Descriptors.Terminate;
  if Assigned(Logger) then
    Logger.Terminate;
  ConnectState := 0;
  InfoStage := 0;
  GetIpStage := 0;
  AutoScanStage := 0;
  BridgesFullUpdate := NewBridgesStage <> 0;
  NewBridgesStage := 0;
  FailedBridgesInterval := 0;
  LockCircuits := False;
  LockCircuitInfo := False;
  LockStreams := False;
  LockStreamsInfo := False;
  tmUpdateIp.Enabled := False;
  tmConsensus.Enabled := False;
  tmCircuits.Enabled := False;
  btnChangeCircuit.Enabled := True;
  miChangeCircuit.Enabled := False;
  imExitFlag.Visible := False;
  lbExitCountry.Left := Round(182 * Scale);
  lbExitCountry.Caption := TransStr('110');
  lbExitCountry.Cursor := crDefault;
  lbExitCountry.Hint := '';
  lbExitIp.Caption := TransStr('109');
  lbExitIp.Cursor := crDefault;
  DirFetches.Clear;
  UpdateConnectControls;
  UpdateTrayHint;
  if not Restarting then
  begin
    if CurrentScanPurpose <> spNewBridges then
      SetOptionsEnable(True);
    edControlPort.Enabled := True;
    lbControlPort.Enabled := True;
    cbxAuthMetod.Enabled := True;
    lbAuthMetod.Enabled := True;
    if cbxAuthMetod.ItemIndex = 1 then
    begin
      edControlPassword.Enabled := True;
      lbControlPassword.Enabled := True;
      imGeneratePassword.Enabled := True;
    end;
    ControlsEnable(tsNetwork);
    ControlsEnable(tsServer);
    if BridgesFullUpdate then
    begin
      SaveBridgesData;
      ShowRouters;
    end
    else
      BridgesCheckControls;
    ShowBalloon(TransStr('241'));
  end;
  RemoveUPnPEntry(udORPort.Tag, udDirPort.Tag, udTransportPort.Tag);
  udORPort.Tag := 0;
  udDirPort.Tag := 0;
  udTransportPort.Tag := 0;
end;

procedure TTcp.RestartTor(RestartCode: Byte = 0);
begin
  if not Assigned(RestartTimeout) then
  begin
    if (RestartCode > 0) or cbRestartOnControlFail.Checked then
      Restarting := True;
    StopTor;
    RestartTimeout := TTimer.Create(Tcp);
    RestartTimeout.Tag := RestartCode;
    RestartTimeout.OnTimer := RestartTimer;
    RestartTimeout.Interval := 200;
  end;
end;

procedure TTcp.RestartTimer(Sender: TObject);
begin
  if not Assigned(Controller) and not Assigned(Logger) and not Assigned(Consensus) and not Assigned(Descriptors) then
  begin
    case TTimer(Sender).Tag of
      1:
      begin
        ResetGuards(TGuardType(miResetGuards.Tag));
        StartTor;
      end;
      else
        if cbRestartOnControlFail.Checked then
          StartTor;
    end;
    Restarting := False;
    FreeAndNil(RestartTimeout);
  end
end;

procedure TTcp.imBridgesFileClick(Sender: TObject);
begin
  PrepareOpenDialog(BridgesFileName, TransStr('615'));
  if OpenDialog.Execute then
  begin
    BridgesFileName := StringReplace(OpenDialog.FileName, GetFullFileName(ProgramDir) + '\', '', [rfIgnoreCase]);;
    BridgesUpdated := True;      
    LoadBridgesFromFile;
    SaveBridgesData;  
    EnableOptionButtons;
  end;
end;

procedure TTcp.imGeneratePasswordClick(Sender: TObject);
begin
  edControlPassword.Text := RandomString(15);
  EnableOptionButtons;
end;

procedure TTcp.imUPnPTestClick(Sender: TObject);
begin
  InitPortForwarding(True);
  if UPnPMsg <> '' then
    ShowMsg(UPnPMsg, TransStr('181'))
  else
    ShowMsg(TransStr('242'), TransStr('181'), mtWarning);
end;

function TTcp.CheckRequiredFiles(AutoSave: Boolean = False): Boolean;
  procedure CheckPathChanges(var PathVar: string; PathStr: string);
  begin
    if (PathVar <> '') and (PathVar <> PathStr) then
      Result := False;
    PathVar := PathStr;
  end;
begin
  Result := True;
  CheckPathChanges(GeoIpFile, GetDirFromArray(GeoIpDirs, 'geoip', True));
  CheckPathChanges(GeoIpv6File, GetDirFromArray(GeoIpDirs, 'geoip6', True));
  CheckPathChanges(TransportsDir, GetDirFromArray(TransportDirs));
  GeoIpExists := FileExists(GeoIpFile);
  if AutoSave then
  begin
    SetTorConfig('DataDirectory', ExcludeTrailingPathDelimiter(UserDir));
    SetTorConfig('ClientOnionAuthDir', ExcludeTrailingPathDelimiter(OnionAuthDir));
    if GeoIpExists then
      SetTorConfig('GeoIPFile', GeoIpFile)
    else
      DeleteTorConfig('GeoIPFile');
    if FileExists(GeoIpv6File) then
      SetTorConfig('GeoIPv6File', GeoIpv6File)
    else
      DeleteTorConfig('GeoIPv6File');
  end;
end;

procedure TTcp.SetIconsColor;
  function GetRGBSum(AColor: TColor): Integer;
  begin
    Result := GetRValue(AColor) + GetGValue(AColor) + GetBValue(AColor);
  end;
begin
  if GetRGBSum(ColorToRGB(StyleServices.GetStyleColor(scButtonNormal))) >= 384 then
    LoadIconsFromResource(lsButtons, 'ICON_BUTTONS_DARK')
  else
    LoadIconsFromResource(lsButtons, 'ICON_BUTTONS_LIGHT');
  if GetRGBSum(ColorToRGB(StyleServices.GetStyleColor(scWindow))) >= 384 then
    LoadIconsFromResource(lsMain, 'ICON_MAIN_DARK')
  else
    LoadIconsFromResource(lsMain, 'ICON_MAIN_LIGHT');
  if GetRGBSum(ColorToRGB(StyleServices.GetStyleColor(scEdit))) >= 384 then
  begin
    lsMenus.GrayscaleFactor := 0;
    LoadIconsFromResource(lsMenus, 'ICON_MENUS_DARK')
  end
  else
  begin
    lsMenus.GrayscaleFactor := 128;
    LoadIconsFromResource(lsMenus, 'ICON_MENUS_LIGHT');
  end;

  if StyleServices.Enabled and StyleServices.IsSystemStyle then
    pbTraffic.Color := clWindow
  else
    pbTraffic.Color := ColorToRGB(StyleServices.GetStyleColor(scWindow));

  lsMain.GetIcon(19, imCircuitPurpose.Picture.Icon);
  lsMain.GetIcon(21, imGeneratePassword.Picture.Icon);
  lsMain.GetIcon(20, imUPnPTest.Picture.Icon);

  lsMain.GetIcon(7, imFilterEntry.Picture.Icon);
  lsMain.GetIcon(8, imFilterMiddle.Picture.Icon);
  lsMain.GetIcon(9, imFilterExit.Picture.Icon);
  lsMain.GetIcon(10, imFilterExclude.Picture.Icon);

  lsMain.GetIcon(7, imFavoritesEntry.Picture.Icon);
  lsMain.GetIcon(8, imFavoritesMiddle.Picture.Icon);
  lsMain.GetIcon(9, imFavoritesExit.Picture.Icon);
  lsMain.GetIcon(10, imExcludeNodes.Picture.Icon);
  lsMenus.GetIcon(46, imFavoritesTotal.Picture.Icon);
  lsMenus.GetIcon(28, imFavoritesBridges.Picture.Icon);
  lsMenus.GetIcon(54, imFavoritesFallbackDirs.Picture.Icon);
  lsMenus.GetIcon(16, imSelectedRouters.Picture.Icon);

  lsMenus.GetIcon(15, imBridgesFile.Picture.Icon);

  SetButtonGlyph(lsButtons, 4, sbShowOptions);
  SetButtonGlyph(lsButtons, 5, sbShowLog);
  SetButtonGlyph(lsButtons, 7, sbShowStatus);
  SetButtonGlyph(lsButtons, 8, sbShowCircuits);
  SetButtonGlyph(lsButtons, 6, sbShowRouters);
  SetButtonGlyph(lsButtons, 9, sbDecreaseForm);

  SetButtonGlyph(lsMain, 22, sbWordWrap);
  SetButtonGlyph(lsMain, 23, sbAutoScroll);
  SetButtonGlyph(lsMain, 24, sbSafeLogging);
  SetButtonGlyph(lsMain, 25, sbUseLinesLimit);

  btnSwitchTor.ImageIndex := ConnectState;
  btnSwitchTor.Refresh;
  btnChangeCircuit.Refresh;
  if FormSize = 1 then
  begin
    case LastPlace of
      LP_OPTIONS: sgFilter.Refresh;
      LP_CIRCUITS: sgCircuits.Refresh;
      LP_ROUTERS: sgRouters.Refresh;
    end;
  end;
end;

procedure TTcp.SetButtonGlyph(ls: TImageList; Index: Integer; Button: TSpeedButton);
begin
  Button.Glyph := nil;
  ls.GetBitmap(Index, Button.Glyph);
end;

procedure TTcp.UpdateConfigVersion;
var
  ini: TMemIniFile;
  TemplateList: TStringlist;
  TemplateName, Temp: string;
  ParseStr: ArrOfStr;
  FirstRun: Boolean;
  i, ConfigVersion: Integer;

  function ConvertCodes(Str: string): string;
  var
    Mas: ArrOfStr;
    i: Integer;
  begin
    Result := '';
    Mas := Explode(',', Str);
    for i := 0 to Length(Mas) - 1 do
      if ValidInt(Mas[i], 0, MAX_COUNTRIES - 1) then
        Result := Result + ',' + CountryCodes[StrToInt(Mas[i])]
      else
        Result := Result + ',' + Mas[i];
    Delete(Result, 1, 1);
  end;

  function ConvertNodes(FilterData: string; TorFormat: Boolean): string;
  var
    ParsedData: ArrOfStr;
    NodesList: TStringlist;
    EntryNodes, MiddleNodes, ExitNodes, ExcludeList, IncludeList: string;
    FMode, FNodes: Byte;
    i: Integer;
  begin
    ParsedData := Explode(';', FilterData);
    if (Length(ParsedData) in [4,5]) then
    begin
      if ValidInt(ParsedData[1], 0, 2) then
        FMode := StrToInt(ParsedData[1])
      else
        FMode := 0;

      if (Length(ParsedData) = 5) and ValidInt(ParsedData[4], 1, 7) then
        FNodes := StrToInt(ParsedData[4])
      else
        FNodes := 4;

      ExcludeList := ConvertCodes(ParsedData[2]);
      IncludeList := ConvertCodes(ParsedData[3]);

      if FMode in [0, 2] then
      begin
        NodesList := TStringList.Create;
        try
          ParseParametersEx(RemoveBrackets(DEFAULT_EXIT_NODES), ',', NodesList);
          for i := NodesList.Count - 1 downto 0 do
          begin
            if Pos(NodesList[i], ExcludeList) <> 0 then
              NodesList.Delete(i);
          end;
          for i := 0 to NodesList.Count - 1 do
          begin
            if TorFormat then
              ExitNodes := ExitNodes + ',{' + NodesList[i] + '}'
            else
              ExitNodes := ExitNodes + ',' + NodesList[i];
          end;
          Delete(ExitNodes, 1, 1);
        finally
          NodesList.Free;
        end;
      end;
      case FMode of
        0: Fmode := 1;
        1: ExitNodes := IncludeList;
        2: FMode := 0;
      end;
      case FNodes of
        1: begin EntryNodes := ExitNodes; ExitNodes := ''; end;
        2: begin MiddleNodes := ExitNodes; ExitNodes := ''; end;
        3: begin EntryNodes := ExitNodes; MiddleNodes := ExitNodes; ExitNodes := ''; end;
        5: begin EntryNodes := ExitNodes; end;
        6: begin MiddleNodes := ExitNodes; end;
        7: begin EntryNodes := ExitNodes; MiddleNodes := ExitNodes; end;
      end;
      Result := ParsedData[0] + ';' + IntToStr(FMode) + ';' + EntryNodes + ';' + MiddleNodes + ';' + ExitNodes;
    end;
  end;

begin
  if FileExists(UserConfigFile) and FileExists(TorConfigFile) then
    FirstRun := False
  else
    FirstRun := True;
  ini := TMemIniFile.Create(UserConfigFile, TEncoding.UTF8);
  try
    ConfigVersion := GetSettings('Main', 'ConfigVersion', 1, ini);
    if ConfigVersion = CURRENT_CONFIG_VERSION then
      Exit;
    if not FirstRun then
    begin
      if ConfigVersion = 1 then
      begin
        case GetSettings('Main', 'Language', 0, ini) of
          1: SetSettings('Main', 'Language', 1033, ini);
          2: SetSettings('Main', 'Language', 1031, ini);
          else
            SetSettings('Main', 'Language', 1049, ini);
        end;

        if GetSettings('Server', 'BridgeType', 0, ini) = 1 then
          SetSettings('Server', 'BridgeType', 'obfs4', ini);

        ParseStr := Explode(';', ConvertNodes(
          ';' + IntToStr(GetSettings('Main', 'FilterMode', 0, ini)) +
          ';' + GetTorConfig('ExcludeExitNodes', '', [cfFindComments]) +
          ';' + GetTorConfig('ExitNodes', '', [cfFindComments]) +
          ';' + IntToStr(GetSettings('Main', 'FilterNodes', 4, ini)), True
        ));
        SetSettings('Filter', 'FilterMode', StrToInt(ParseStr[1]), ini);
        SetSettings('Filter', 'EntryNodes', ParseStr[2], ini);
        SetSettings('Filter', 'MiddleNodes', ParseStr[3], ini);
        SetSettings('Filter', 'ExitNodes', ParseStr[4], ini);

        SetTorConfig('EntryNodes', ParseStr[2], [cfFindComments]);
        SetTorConfig('MiddleNodes', ParseStr[3], [cfFindComments]);
        SetTorConfig('ExitNodes', ParseStr[4], [cfFindComments]);
        DeleteTorConfig('ExcludeExitNodes', [cfFindComments]);

        Temp := GetTorConfig('ExcludeNodes', '', [cfFindComments]);
        SetSettings('Routers', 'ExcludeNodes', Temp, ini);
        if GetTorConfig('ExcludeNodes', '0', [cfExistCheck]) = '1' then
          SetSettings('Lists', 'UseExcludeNodes', True, ini)
        else
          DeleteTorConfig('ExcludeNodes', [cfFindComments]);

        Temp := GetTorConfig('TrackHostExits', '', [cfFindComments]);
        SetSettings('Lists', 'TrackHostExits', Temp, ini);
        if GetTorConfig('TrackHostExits', '0', [cfExistCheck]) = '1' then
          SetSettings('Lists', 'UseTrackHostExits', True, ini)
        else
          DeleteTorConfig('TrackHostExits', [cfFindComments]);

        Temp := GetTorConfig('TrackHostExitsExpire', '1800', [cfFindComments], ptInteger, Tcp.udTrackHostExitsExpire.Min, Tcp.udTrackHostExitsExpire.Max);
        SetSettings('Lists', 'TrackHostExitsExpire', StrToInt(Temp), ini);
        if GetTorConfig('TrackHostExitsExpire', '0', [cfExistCheck]) = '0' then
          DeleteTorConfig('TrackHostExitsExpire', [cfFindComments]);

        Temp := GetTorConfig('HashedControlPassword', '', [cfFindComments]);
        SetSettings('Main', 'HashedControlPassword', Temp, ini);
        if GetTorConfig('HashedControlPassword', '0', [cfExistCheck]) = '0' then
          DeleteTorConfig('HashedControlPassword', [cfFindComments]);

        Temp := GetTorConfig('Bridge', '', [cfMultiLine, cfFindComments]);
        if Temp <> '' then
        begin
          ParseStr := Explode('|', Temp);
          for i := 0 to Length(ParseStr) - 1 do
            SetSettings('Bridges', IntToStr(i), ParseStr[i], ini);
          SetSettings('Network', 'UseBridges', StrToBool(GetTorConfig('UseBridges', '0', [], ptBoolean)), ini);
          SetSettings('Network', 'BridgesType', 1, ini);
          DeleteTorConfig('Bridge', [cfMultiLine, cfFindComments]);
        end;

        SetSettings('Server', 'UseNumCPUs', StrToBool(GetTorConfig('NumCPUs', '0', [cfExistCheck])), ini);
        SetSettings('Server', 'UseRelayBandwidth', StrToBool(GetTorConfig('RelayBandwidthRate', '0', [cfExistCheck])) or StrToBool(GetTorConfig('RelayBandwidthBurst', '0', [cfExistCheck])) or StrToBool(GetTorConfig('MaxAdvertisedBandwidth', '0', [cfExistCheck])), ini);
        SetSettings('Server', 'UseMaxMemInQueues', StrToBool(GetTorConfig('MaxMemInQueues', '0', [cfExistCheck])), ini);
        SetSettings('Server', 'UseDirPort', StrToBool(GetTorConfig('DirPort', '0', [cfExistCheck])), ini);
        SetSettings('Server', 'PublishServerDescriptor', StrToBool(GetTorConfig('PublishServerDescriptor', '1', [], ptBoolean)), ini);
        SetSettings('Server', 'DirReqStatistics', StrToBool(GetTorConfig('DirReqStatistics', '1', [], ptBoolean)), ini);
        SetSettings('Server', 'HiddenServiceStatistics', StrToBool(GetTorConfig('HiddenServiceStatistics', '1', [], ptBoolean)), ini);
        SetSettings('Server', 'IPv6Exit', StrToBool(GetTorConfig('IPv6Exit', '0', [], ptBoolean)), ini);

        GetLocalInterfaces(cbxHsAddress);
        GetTorHs;
        SaveHiddenServices(ini);

        SetSettings('Main', 'FormPosition',
          IntToStr(GetSettings('Main', 'PositionLeft', -1, ini)) + ',' +
          IntToStr(GetSettings('Main', 'PositionTop', -1, ini)) + ',-1,-1', ini);

        DeleteSettings('Main', 'ConfirmBanRelay', ini);
        DeleteSettings('Main', 'PositionLeft', ini);
        DeleteSettings('Main', 'PositionTop', ini);
        DeleteSettings('Main', 'FilterMode', ini);
        DeleteSettings('Main', 'FilterNodes', ini);
        DeleteSettings('Main', 'UseExcludeNodes', ini);
        DeleteSettings('Main', 'UseTrackHostExits', ini);

        TemplateList := TStringlist.Create;
        try
          ini.ReadSectionValues('Templates', TemplateList);
          if TemplateList.Count > 0 then
          begin
            for i := 0 to TemplateList.Count - 1 do
            begin
              TemplateName := SeparateLeft(TemplateList[i], '=');
              SetSettings('Templates', TemplateName, ConvertNodes(GetSettings('Templates', TemplateName, '', ini), False), ini);
            end;
          end;
        finally
          TemplateList.Free;
        end;
        ForceDirectories(LogsDir);
        RenameFile(UserDir + 'console.log', LogsDir + 'console.log');
        ConfigVersion := 2;
      end;
      if ConfigVersion = 2 then
      begin
        SetSettings('AutoSelNodes', 'AutoSelStableOnly', GetSettings('AutoSelNodes', 'AutoSelFastAndStableOnly', False, ini), ini);
        DeleteSettings('AutoSelNodes', 'AutoSelFastAndStableOnly', ini);
        ConfigVersion := 3;
      end;
      if ConfigVersion = 3 then
      begin
        if GetSettings('Log', 'SeparateType', 1, ini) = 2 then
          SetSettings('Log', 'SeparateType', 3, ini);
        SetSettings('Scanner', 'LastPartialScanDate', GetSettings('Scanner', 'LastNonResponsedScanDate', Int64(0), ini), ini);
        SetSettings('Scanner', 'PartialScanInterval', GetSettings('Scanner', 'NonResponsedScanInterval', udPartialScanInterval.Position, ini), ini);
        DeleteSettings('Scanner', 'LastNonResponsedScanDate', ini);
        DeleteSettings('Scanner', 'NonResponsedScanInterval', ini);
        ConfigVersion := 4;
      end;
      if ConfigVersion = 4 then
      begin
        SetSettings('AutoSelNodes', 'AutoSelNodesType',
          GetIntDef(GetSettings('AutoSelNodes', 'AutoSelNodesType', 15, ini) + 8,
            15, 0, 15), ini);
        DeleteSettings('Main', 'LastGeoIpUpdateDate', ini);
        DeleteSettings('Routers', 'AddRelaysToBridgesCache, ', ini);
        ConfigVersion := 5;
      end;
      if ConfigVersion = 5 then
      begin
        SetSettings('Routers', 'RoutersShowFlagsHint', GetSettings('Routers', 'ShowFlagsHint', True, ini), ini);
        SetSettings('Circuits', 'SelectExitCircuitWhenItChanges', GetSettings('Circuits', 'SelectExitCircuitWhetItChanges', True, ini), ini);
        SetSettings('Circuits', 'PurposeFilter',
          GetIntDef(GetSettings('Circuits', 'PurposeFilter', CIRCUIT_FILTER_DEFAULT, ini) + miCircController.Tag,
            CIRCUIT_FILTER_DEFAULT, 0, CIRCUIT_FILTER_MAX), ini);
        DeleteSettings('Routers', 'ShowFlagsHint', ini);
        DeleteSettings('Circuits', 'SelectExitCircuitWhetItChanges', ini);
        ConfigVersion := 6;
      end;
      if ConfigVersion = 6 then
      begin
        i := GetIntDef(GetSettings('Log', 'DisplayedLinesType', 2, ini), 2, 0, 7);
        SetSettings('Log', 'UseLinesLimit', i <> 0, ini);
        if i = 0 then
          i := 2;
        SetSettings('Log', 'LinesLimit', Round(Power(2, (17 - i))), ini);
        DeleteSettings('Log', 'DisplayedLinesType', ini);
        ConfigVersion := 7;
      end;
      if ConfigVersion = 7 then
      begin
        i := 0;
        if GetSettings('Main', 'MinimizeOnClose', True, ini) then
          Inc(i, 1);
        if GetSettings('Main', 'MinimizeOnStartup', False, ini) then
          Inc(i, 2);
        case i of
          0: i := MINIMIZE_ON_NONE;
          1: i := MINIMIZE_ON_CLOSE;
          2: i := MINIMIZE_ON_STARTUP;
          3: i := MINIMIZE_ON_ALL;
        end;
        SetSettings('Main', 'MinimizeOnEvent', i, ini);
        DeleteSettings('Main', 'MinimizeOnClose', ini);
        DeleteSettings('Main', 'MinimizeOnStartup', ini);
        ConfigVersion := 8;
      end;
    end
    else
      ConfigVersion := CURRENT_CONFIG_VERSION;
    SetSettings('Main', 'ConfigVersion', ConfigVersion, ini);
  finally
    UpdateConfigFile(ini);
  end;
end;

function TTcp.GetTorHs: Integer;
var
  Name, Version, MaxStreams, IntroPoints, Port, Temp, Data, Delimiter: string;
  VirtualPort, RealPort, Address: string;
  ParseStr: ArrOfStr;
  Reset: Boolean;
  i, Min, Max: Integer;

  function GetParam(Param, Str: string): string;
  var
    p, CommentPos, ParamSize: Integer;
  begin
    p := InsensPosEx(Param + ' ', Str);
    if p = 1 then
    begin
      ParamSize := Length(Param);
      CommentPos := Pos('#', Str);
      if CommentPos > p + ParamSize then
        Result := Trim(copy(Str, p + ParamSize + 1, CommentPos - ParamSize - 2))
      else
        Result := Trim(copy(Str, p + ParamSize + 1, Length(Str) - ParamSize - 1));
    end
    else
      Result := '';
  end;

begin
  Result := 0;
  Min := 0;
  Max := 0;

  for i := 0 to TorConfig.Count - 1 do
  begin
    Name := GetParam('HiddenServiceDir', TorConfig[i]);
    if Name <> '' then
    begin
      Inc(Result);
      sgHs.Cells[HS_VERSION, Result] := '3';
      sgHs.Cells[HS_INTRO_POINTS, Result] := '3';
      sgHs.Cells[HS_MAX_STREAMS, Result] := NONE_CHAR;
      sgHs.cells[HS_STATE, Result] := SELECT_CHAR;
      sgHs.Cells[HS_PORTS_DATA, Result] := '';
      if Result > 1 then
        sgHs.RowCount := sgHs.RowCount + 1;
      Name := ExcludeTrailingPathDelimiter(Name);
      Name := copy(Name, RPos('\', Name) + 1);
      TorConfig[i] := 'HiddenServiceDir ' + HsDir + Name;

      sgHs.Cells[HS_NAME, Result] := Name;
      sgHs.Cells[HS_PREVIOUS_NAME, Result] := sgHs.Cells[HS_NAME, Result];

      continue;
    end;

    Version := GetParam('HiddenServiceVersion', TorConfig[i]);
    if Version <> '' then
    begin
      if ValidInt(Version, 2, 3) then
        sgHs.Cells[HS_VERSION, Result] := Version
      else
        TorConfig[i] := 'HiddenServiceVersion 3';
      continue;
    end;

    Port := GetParam('HiddenServicePort', TorConfig[i]);
    if Port <> '' then
    begin
      Reset := False;
      Delimiter := '';
      Address := '';
      RealPort := '';
      VirtualPort := '';
      Temp := sgHs.Cells[HS_PORTS_DATA, Result];
      if Temp <> '' then
        Delimiter := '|';
      ParseStr := Explode(' ', Port);
      VirtualPort := ParseStr[0];
      if not ValidInt(VirtualPort, 1, 65535) then
      begin
        VirtualPort := DEFAULT_PORT;
        Reset := True;
      end;
      if Length(ParseStr) > 1 then
      begin
        if ValidSocket(ParseStr[1]) <> soNone then
        begin
          Address := GetAddressFromSocket(ParseStr[1]);
          RealPort := IntToStr(GetPortFromSocket(ParseStr[1]));
          if Reset then
            VirtualPort := RealPort;
          if Tcp.cbxHsAddress.Items.IndexOf(Address) = -1 then
          begin
            Address := LOOPBACK_ADDRESS;
            Reset := True;
          end;
        end
        else
        begin
          Address := RemoveBrackets(ParseStr[1], True);
          if ValidAddress(Address) <> atNone then
          begin
            RealPort := VirtualPort;
            if Tcp.cbxHsAddress.Items.IndexOf(Address) = -1 then
            begin
              Address := LOOPBACK_ADDRESS;
              Reset := True;
            end;
          end
          else
          begin
            Address := LOOPBACK_ADDRESS;
            if ValidInt(ParseStr[1], 1, 65535) then
            begin
              RealPort := ParseStr[1];
              if Reset then
                VirtualPort := RealPort;
            end
            else
            begin
              RealPort := VirtualPort;
              Reset := True;
            end;
          end;
        end
      end
      else
      begin
        Address := LOOPBACK_ADDRESS;
        RealPort := VirtualPort;
      end;
      Data := Address + ',' + RealPort + ',' + VirtualPort;
      sgHs.Cells[HS_PORTS_DATA, Result] := Temp + Delimiter + Data;
      if Reset then
        TorConfig[i] := 'HiddenServicePort ' + VirtualPort + ' ' + FormatHost(Address) + ':' + RealPort;
      continue;
    end;

    IntroPoints := GetParam('HiddenServiceNumIntroductionPoints', TorConfig[i]);
    if IntroPoints <> '' then
    begin
      case StrToInt(sgHs.Cells[HS_VERSION, Result]) of
        2: begin Min := 1; Max := 10 end;
        3: begin Min := 3; Max := 20 end;
      end;
      if ValidInt(IntroPoints, Min, Max) then
        sgHs.Cells[HS_INTRO_POINTS, Result] := IntroPoints
      else
        TorConfig[i] := 'HiddenServiceNumIntroductionPoints 3';
      continue;
    end;

    MaxStreams := GetParam('HiddenServiceMaxStreams', TorConfig[i]);
    if MaxStreams <> '' then
    begin
      if ValidInt(MaxStreams, 1, 65535) then
        sgHs.Cells[HS_MAX_STREAMS, Result] := MaxStreams
      else
        TorConfig[i] := '';
      continue;
    end;
  end;
  udRendPostPeriod.Position := Round(StrToInt(GetTorConfig('RendPostPeriod', '3600', [], ptInteger, Tcp.udRendPostPeriod.Min * 60, Tcp.udRendPostPeriod.Max * 60)) / 60);
end;

function TTcp.LoadHiddenServices(ini: TMemIniFile): Integer;
var
  HsList, PortList: TStringList;
  i, j, Min, Max: Integer;
  ParseStr, PortsStr: ArrOfStr;
  Address, RealPort, VirtualPort: string;
  Name, Version, MaxStreams, IntroPoints, PortsData, State: string;
begin
  Result := 0;
  Min := 0;
  Max := 0;

  BeginUpdateTable(sgHs);
  HsList := TStringList.Create;
  PortList := TStringList.Create;
  try
    GetSettings('HiddenServices', udRendPostPeriod, ini);
    ini.ReadSectionValues('HiddenServices', HsList);
    for i := 0 to HsList.Count - 1 do
    begin
      if ValidInt(SeparateLeft(HsList[i], '='), 0, MAXINT) then
      begin
        ParseStr := Explode(';', SeparateRight(HsList[i], '='));
        if Length(ParseStr) = 6 then
        begin
          Name := ParseStr[0];
          Version := ParseStr[1];
          IntroPoints := ParseStr[2];
          MaxStreams := ParseStr[3];
          State := ParseStr[4];
          PortsData := ParseStr[5];
          if not ValidInt(Version, 2, 3) then
            Version := '3';
          case StrToInt(Version) of
            2: begin Min := 1; Max := 10 end;
            3: begin Min := 3; Max := 20 end;
          end;
          if not ValidInt(IntroPoints, Min, Max) then
            IntroPoints := '3';
          if not ValidInt(MaxStreams, 1, 65535) then
            MaxStreams := NONE_CHAR;
          if State = '1' then
            State := SELECT_CHAR
          else
            State := FAVERR_CHAR;
          PortList.Clear;
          ParseStr := Explode('|', PortsData);
          for j := 0 to Length(ParseStr) - 1 do
          begin
            PortsStr := Explode(',', ParseStr[j]);
            if Length(PortsStr) = 3 then
            begin
              Address := PortsStr[0];
              RealPort := PortsStr[1];
              VirtualPort := PortsStr[2];
              if (ValidAddress(Address) = atNone) or (cbxHsAddress.Items.IndexOf(Address) = -1) then
                Address := LOOPBACK_ADDRESS;
              if not ValidInt(RealPort, 1, 65535) then
                RealPort := DEFAULT_PORT;
              if not ValidInt(VirtualPort, 1, 65535) then
                VirtualPort := DEFAULT_PORT;
            end
            else
            begin
              Address := LOOPBACK_ADDRESS;
              RealPort := DEFAULT_PORT;
              VirtualPort := DEFAULT_PORT;
            end;
            PortList.Append(Address + ',' + RealPort + ',' + VirtualPort);
          end;
          DeleteDuplicatesFromList(PortList);
          PortsData := '';
          for j := 0 to PortList.Count - 1 do
            PortsData := PortsData + '|' + PortList[j];
          Delete(PortsData, 1, 1);

          Inc(Result);
          sgHs.Cells[HS_NAME, Result] := Name;
          sgHs.Cells[HS_VERSION, Result] := Version;
          sgHs.Cells[HS_INTRO_POINTS, Result] := IntroPoints;
          sgHs.Cells[HS_MAX_STREAMS, Result] := MaxStreams;
          sgHs.Cells[HS_STATE, Result] := State;
          sgHs.Cells[HS_PORTS_DATA, Result] := PortsData;
          sgHs.Cells[HS_PREVIOUS_NAME, Result] := Name;
        end;
      end;
    end;
    if Result > 0 then
      sgHs.RowCount := Result + 1
    else
      sgHs.RowCount := 2;

    EndUpdateTable(sgHs);
  finally
    HsList.Free;
    PortList.Free;
  end;
end;

procedure TTcp.SaveHiddenServices(ini: TMemIniFile);
var
  i, j, Count: Integer;
  UpdateControls: Boolean;
  ParseStr, ParsePort: ArrOfStr;
  Name, PrevName, Version, MaxStreams, IntroPoints, PortsData, State: string;
begin
  UpdateControls := False;
  DeleteTorConfig('HiddenServiceDir', [cfMultiLine]);
  DeleteTorConfig('HiddenServiceVersion', [cfMultiLine]);
  DeleteTorConfig('HiddenServicePort', [cfMultiLine]);
  DeleteTorConfig('HiddenServiceNumIntroductionPoints', [cfMultiLine]);
  DeleteTorConfig('HiddenServiceMaxStreams', [cfMultiLine]);
  DeleteTorConfig('RendPostPeriod');
  ini.EraseSection('HiddenServices');

  if Length(HsToDelete) > 0 then
  begin
    for i := 0 to Length(HsToDelete) - 1 do
      DeleteDir(HsDir + HsToDelete[i]);
    HsToDelete := nil;
  end;
  SetSettings('HiddenServices', udRendPostPeriod, ini);

  if not IsEmptyGrid(sgHs) then
  begin
    if not DirectoryExists(UserDir + 'services') then
      ForceDirectories(UserDir + 'services');
    Count := 0;
    for i := 1 to sgHs.RowCount - 1 do
    begin
      Name := sgHs.Cells[HS_NAME, i];
      PrevName := sgHs.Cells[HS_PREVIOUS_NAME, i];
      Version := sgHs.Cells[HS_VERSION, i];
      IntroPoints := sgHs.Cells[HS_INTRO_POINTS, i];
      MaxStreams := sgHs.Cells[HS_MAX_STREAMS, i];
      State := sgHs.Cells[HS_STATE, i];
      PortsData := sgHs.Cells[HS_PORTS_DATA, i];

      if not ValidInt(MaxStreams, 1, 65535) then MaxStreams := '0';
      if State = SELECT_CHAR then
      begin
        if CheckFileVersion(TorVersion, '0.4.6.1') and (Version = '2') then
        begin
          State := '0';
          UpdateControls := True;
        end
        else
          State := '1'
      end
      else
        State := '0';

      if State = '1' then
      begin
        Inc(Count);
        if DirectoryExists(HsDir + PrevName) then
        begin
          if Name <> PrevName then
          begin
            RenameFile(HsDir + PrevName, HsDir + Name);
            sgHs.Cells[HS_PREVIOUS_NAME, i] := Name;
          end;
        end;
        TorConfig.Append('HiddenServiceDir ' + HsDir + Name);
        TorConfig.Append('HiddenServiceVersion ' + Version);
        ParseStr := Explode('|', PortsData);
        for j := 0 to Length(ParseStr) - 1 do
        begin
          ParsePort := Explode(',', ParseStr[j]);
          if (cbxHsAddress.Items.IndexOf(ParsePort[0]) = -1) then
          begin
            ParsePort[0] := LOOPBACK_ADDRESS;
            UpdateControls := True;
          end;
          TorConfig.Append('HiddenServicePort ' + ParsePort[2] + ' ' + FormatHost(ParsePort[0]) + ':' + ParsePort[1]);
        end;
        if IntroPoints <> '3' then
          TorConfig.Append('HiddenServiceNumIntroductionPoints ' + IntroPoints);
        if MaxStreams <> '0' then
          TorConfig.Append('HiddenServiceMaxStreams ' + MaxStreams);
      end;

      SetSettings('HiddenServices', IntToStr(i - 1),
        Name + ';' +
        Version + ';' +
        IntroPoints + ';' +
        MaxStreams + ';' +
        State + ';' +
        PortsData,
      ini);
    end;
    if SupportRendPostPeriod and (Count > 0) then
      SetTorConfig('RendPostPeriod', IntToStr(Tcp.udRendPostPeriod.Position * 60));
    if UpdateControls then
    begin
      LoadHiddenServices(ini);
      SelectHs;
    end;
  end;
end;

procedure TTcp.ResetTransports(ini: TMemIniFile);
var
  ls: TStringList;
begin
  if FileExists(DefaultsFile) then
  begin
    ls := TStringList.Create;
    try
      ini.ReadSectionValues('Transports', ls);
      if ls.Count > 0 then
        LoadTransportsData(ls);
    finally
      ls.Free;
    end;
  end;
end;

procedure TTcp.LoadTransportsData(Data: TStringList);
var
  i, j, TotalTransports: Integer;
  TransportID: Byte;
  ParseStr, TransList: ArrOfStr;
  Transports, Handler, Params, StrType, Item: string;
  T: TTransportInfo;
  IsValid: Boolean;
begin
  TotalTransports := 0;
  sgTransports.RowID := sgTransports.Cells[PT_HANDLER, sgTransports.SelRow];
  BeginUpdateTable(sgTransports);
  ClearGrid(sgTransports);
  TransportsDic.Clear;

  for i := 0 to Data.Count - 1 do
  begin
    ParseStr := Explode('|', SeparateRight(Data[i], '='));
    if Length(ParseStr) in [3, 4] then
    begin
      Transports := ParseStr[0];
      Handler := ParseStr[1];
      StrType := GetTransportChar(StrToIntDef(ParseStr[2], 0));
      TransportID := GetTransportID(StrType);

      if Length(ParseStr) = 4 then
        Params := ParseStr[3]
      else
        Params := '';

      if FileExists(TransportsDir + Handler) then
      begin
        TransList := Explode(',', Transports);
        Transports := '';
        for j := 0 to Length(TransList) - 1 do
        begin
          IsValid := False;
          Item := Trim(TransList[j]);
          if (Item <> '') and (CheckEditString(Item, '_', False) = '') then
          begin
            if TransportsDic.TryGetValue(Item, T) then
            begin
              if T.TransportID = TRANSPORT_BOTH then
                Continue
              else
              begin
                if (TransportID <> TRANSPORT_BOTH) and (TransportID <> T.TransportID) then
                begin
                  T.TransportID := TRANSPORT_BOTH;
                  IsValid := True;
                end;
              end;
            end
            else
            begin
              T.TransportID := TransportID;
              IsValid := True;
            end;
            if IsValid then
            begin
              T.InList := False;
              TransportsDic.AddOrSetValue(Item, T);
              Transports := Transports + ',' + Item;
            end;
          end;
        end;
        Delete(Transports, 1, 1);
      end;

      if Transports <> '' then
      begin
        Inc(TotalTransports);
        sgTransports.Cells[PT_TRANSPORTS, TotalTransports] := Transports;
        sgTransports.Cells[PT_HANDLER, TotalTransports] := Handler;
        sgTransports.Cells[PT_TYPE, TotalTransports] := StrType;
        sgTransports.Cells[PT_PARAMS, TotalTransports] := Params;
      end;
    end;
  end;

  if TotalTransports > 0 then
  begin
    sgTransports.RowCount := TotalTransports + 1;
    TransportsEnable(True);
    SelectTransports;
  end
  else
    UpdateTransports;
  SetGridLastCell(sgTransports, True, False, False, -1, -1, PT_HANDLER);
  EndUpdateTable(sgTransports);
end;

procedure TTcp.SaveTransportsData(ini: TMemIniFile; ReloadServerTransport: Boolean);
var
  i, j, TransportID: Integer;
  Transports, UsedTransports, Handler, Params, StrType, ServerTransport: string;
  ParseStr: ArrOfStr;
  Find, InBridges: Boolean;
  T: TTransportInfo;
begin
  DeleteTorConfig('ClientTransportPlugin', [cfMultiLine]);
  DeleteTorConfig('ServerTransportPlugin', [cfMultiLine]);
  DeleteTorConfig('ServerTransportListenAddr', [cfMultiLine]);
  DeleteTorConfig('ExtORPort', [cfMultiLine]);
  ini.EraseSection('Transports');

  if ReloadServerTransport then
    ServerTransport := GetSettings('Server', 'BridgeType', '', ini)
  else
    ServerTransport := cbxBridgeType.Text;

  cbxBridgeType.Clear;
  cbxBridgeType.Items.Insert(0, TransStr('206'));
  if not IsEmptyGrid(sgTransports) then
  begin
    for i := 1 to sgTransports.RowCount - 1 do
    begin
      Transports := sgTransports.Cells[PT_TRANSPORTS, i];
      Handler := sgTransports.Cells[PT_HANDLER, i];
      StrType := sgTransports.Cells[PT_TYPE, i];
      Params := sgTransports.Cells[PT_PARAMS, i];

      TransportID := GetTransportID(StrType);
      ParseStr := Explode(',', Transports);
      Transports := '';
      UsedTransports := '';
      Find := False;
      for j := 0 to Length(ParseStr) - 1 do
      begin
        ParseStr[j] := Trim(ParseStr[j]);
        if TransportsDic.TryGetValue(ParseStr[j], T) then
        begin
          InBridges := T.InList = True;
          if (T.TransportID <> TRANSPORT_SERVER) and InBridges then
          begin
            UsedTransports := UsedTransports + ',' + ParseStr[j];
            Find := True;
          end;
        end;
        if TransportID <> TRANSPORT_CLIENT then
        begin
          cbxBridgeType.Items.Append(ParseStr[j]);
          if (cbxServerMode.ItemIndex = SERVER_MODE_BRIDGE) and (ServerTransport = ParseStr[j]) then
          begin
            SetTorConfig('ServerTransportPlugin', Trim(ServerTransport + ' exec ' + TransportsDir + Handler + ' ' + Params));
            SetTorConfig('ServerTransportListenAddr', ServerTransport + ' 0.0.0.0:' + IntToStr(udTransportPort.Position));
            SetTorConfig('ExtORPort', 'auto');
          end;
        end;
        Transports := Transports + ',' + ParseStr[j];
      end;
      Delete(Transports, 1, 1);
      Delete(UsedTransports, 1, 1);

      if cbUseBridges.Checked and Find then
        TorConfig.Append('ClientTransportPlugin ' + UsedTransports + ' exec ' + TransportsDir + Handler + ' ' + Params);

      if Params <> '' then
        Params := '|' + Params;

      SetSettings('Transports', IntToStr(i - 1),
        Transports + '|' + Handler + '|' + IntToStr(TransportID) + Params, ini);
    end;
  end;
  cbxBridgeType.ItemIndex := GetIntDef(cbxBridgeType.Items.IndexOf(ServerTransport), 0, 0, MAXINT);
  SetSettings('Server', cbxBridgeType, ini, False);
  ServerIsObfs4 := cbxBridgeType.Text = 'obfs4';
end;

procedure TTcp.LoadBridgesFromFile;
var
  Bridges: TStringList;
  i: Integer;
  NeedUpdate: Boolean;
begin
  NeedUpdate := True;
  if FileExists(BridgesFileName) then
  begin
    Bridges := TStringList.Create;
    try
      Bridges.LoadFromFile(BridgesFileName);
      if Bridges.Count > 0 then
      begin
        for i := Bridges.Count - 1 downto 0 do
        begin
          Bridges[i] := Trim(Bridges[i]);
          if not ValidBridge(Bridges[i]) then
            Bridges.Delete(i);
        end;
        SortList(Bridges, ltBridge, meBridges.SortType);
        meBridges.Text := Bridges.Text;
        NeedUpdate := False;
      end;
    finally
      Bridges.Free;
    end;
  end;
  if NeedUpdate then
    meBridges.Clear;
  BridgesFileUpdated := False;
end;

procedure TTcp.LoadUserBridges(ini: TMemIniFile);
var
  Bridges: TStringList;
  NeedUpdate: Boolean;
  i: Integer;
begin
  NeedUpdate := True;
  if FileExists(UserConfigFile) then
  begin
    Bridges := TStringList.Create;
    try
      ini.ReadSectionValues('Bridges', Bridges);
      if Bridges.Count > 0 then
      begin
        for i := Bridges.Count - 1 downto 0 do
        begin
          Bridges[i] := Trim(SeparateRight(Bridges[i], '='));
          if not ValidBridge(Bridges[i]) then
            Bridges.Delete(i);
        end;
        SortList(Bridges, ltBridge, meBridges.SortType);
        meBridges.Text := Bridges.Text;
        NeedUpdate := False;
      end;
    finally
      Bridges.Free;
    end;
  end;
  if NeedUpdate then
    meBridges.Clear; 
end;

procedure TTcp.LoadFallbackDirs(ini: TMemIniFile; Default: Boolean);
var
  ls: TStringList;
  NeedUpdate: Boolean;
  FileName: string;
  i: Integer;
begin
  NeedUpdate := True;
  if Default then
    FileName := DefaultsFile
  else
    FileName := UserConfigFile;
  if FileExists(FileName) then
  begin
    ls := TStringList.Create;
    try
      ini.ReadSectionValues('FallbackDirs', ls);
      if ls.Count > 0 then
      begin
        for i := ls.Count - 1 downto 0 do
        begin
          ls[i] := Trim(SeparateRight(ls[i], '='));
          if not ValidFallbackDir(ls[i]) then
            ls.Delete(i);
        end;
        SortList(ls, ltFallbackDir, meFallbackDirs.SortType);
        meFallbackDirs.Text := ls.Text;
        NeedUpdate := False;
      end;
    finally
      ls.Free;
    end;
  end;
  if NeedUpdate then
    meFallbackDirs.Text := '';
end;

procedure TTcp.LoadBuiltinBridges(ini: TMemIniFile; UpdateBridges, UpdateList: Boolean; ListName: string = '');
const
  Delimiter = '|';
var
  ls, list: TStringList;
  i, Index: Integer;
  Key, Value, Str: string;
  Bridges: TDictionary<string, string>;
begin
  if UpdateBridges then
    meBridges.Clear;
  if FileExists(DefaultsFile) then
  begin
    ls := TStringList.Create;
    list := TStringList.Create;
    Bridges := TDictionary<string, string>.Create;
    try
      ini.ReadSectionValues('Bridges', ls);
      if ls.Count > 0 then
      begin
        for i := 0 to ls.Count - 1 do
        begin
          Key := SeparateLeft(SeparateLeft(ls[i], '='), '.');
          Value := SeparateRight(ls[i], '=');
          if Pos(Delimiter, Value) = 0 then
          begin
            if ValidBridge(Value) then
            begin
              if Bridges.TryGetValue(Key, Str) then
                Str := Str + Delimiter + Value
              else
              begin
                Str := Value;
                if UpdateList then
                  list.Append(Key);
              end;
              Bridges.AddOrSetValue(Key, Str)
            end;
          end;
        end;

        if UpdateList then
          cbxBridgesList.Items.SetStrings(list);

        if Bridges.Count > 0 then
        begin
          if UpdateList then
          begin
            Index := list.IndexOf(ListName);
            if Index < 0 then
              Index := 0;
            cbxBridgesList.ItemIndex := Index
          end;
          if UpdateBridges then
          begin
            if Bridges.TryGetValue(cbxBridgesList.Text, Str) then
              LineToMemo(Str, meBridges, meBridges.SortType, Delimiter);
          end;
        end;
      end
      else
        cbxBridgesList.Clear;
    finally
      ls.Free;
      list.Free;
      Bridges.Free;
    end;
  end;
end;

function TTcp.ReachablePortsExists: Boolean;
var
  ParseStr: ArrOfStr;
  i: Integer;
begin
  if cbUseReachableAddresses.Checked then
  begin
    PortsDic.Clear;
    ParseStr := Explode(',', StringReplace(edReachableAddresses.Text, ' ', '', [rfReplaceAll]));
    for i := 0 to Length(ParseStr) - 1 do
    begin
      if ValidInt(ParseStr[i], 1, 65535) then
        PortsDic.AddOrSetValue(StrToInt(ParseStr[i]), 0);
    end;
  end;
  Result := PortsDic.Count > 0;
end;

procedure TTcp.ExcludeUnsuitableBridges(var Data: TStringList; DeleteUnsuitable: Boolean = False);
var
  cdPorts, cdAlive, cdRelay: Boolean;
  CheckEntryPorts, NeedCountry, NeedAlive, Cached, SpecialAddr, FindCountry: Boolean;
  BridgesCount, RoutersCount: Integer;
  Bridge: TBridge;
  RouterInfo: TRouterInfo;
  GeoIpInfo: TGeoIpInfo;
  CountryStr, IpStr: string;
  i, CountryID, PortData: Integer;
begin
  SuitableBridgesCount := 0;
  RoutersCount := RoutersDic.Count;
  BridgesCount := Data.Count;
  if BridgesCount = 0 then
    Exit;
  CheckEntryPorts := ReachablePortsExists;
  for i := Data.Count - 1 downto 0 do
  begin
    if TryParseBridge(Data[i], Bridge, False) then
    begin
      if CheckEntryPorts then
        cdPorts := PortsDic.ContainsKey(Bridge.Port)
      else
        cdPorts := True;
      IpStr := GetBridgeIp(Bridge);
      if IpStr <> '' then
      begin
        if GeoIpDic.TryGetValue(IpStr, GeoIpInfo) then
        begin
          CountryID := GeoIpInfo.cc;
          PortData := GetPortsValue(GeoIpInfo.ports, IntToStr(Bridge.Port));
          NeedCountry := CountryID = DEFAULT_COUNTRY_ID;
          NeedAlive := PortData = 0;
          cdAlive := PortData <> -1;
          FindCountry := NeedCountry and cdAlive;
        end
        else
        begin
          CountryID := DEFAULT_COUNTRY_ID;
          NeedCountry := True;
          NeedAlive := True;
          FindCountry := True;
          cdAlive := False;
        end;
        if FindCountry and GeoIpExists then
          Inc(UnknownBridgesCountriesCount);
        SpecialAddr := False;
      end
      else
      begin
        CountryID := DEFAULT_COUNTRY_ID;
        NeedCountry := True;
        NeedAlive := True;
        cdAlive := False;
        SpecialAddr := True;
      end;

      Cached := BridgesDic.ContainsKey(Bridge.Hash);
      CountryStr := CountryCodes[CountryID];

      cdRelay := True;
      if RoutersCount > 0 then
      begin
        if RoutersDic.TryGetValue(Bridge.Hash, RouterInfo) then
        begin
          if rfRelay in RouterInfo.Flags then
          begin
            case GetAddressType(Bridge.Ip) of
              atIPv4: cdRelay := ((RouterInfo.IPv4 = Bridge.Ip) and (RouterInfo.Port = Bridge.Port));
              atIPv6: cdRelay := ((RouterInfo.IPv6 = Bridge.Ip) and (RouterInfo.Port = Bridge.Port));
            end;
            if not cdRelay then
              SetPortsValue(IpStr, IntToStr(Bridge.Port), -1);
          end;
        end;
      end;

      if cdPorts and (cdAlive or NeedAlive) and cdRelay and not RouterInNodesList(Bridge.Hash, IpStr, ntExclude, NeedCountry and NeedAlive, CountryStr) then
      begin
        if cbUseBridges.Checked and not DeleteUnsuitable then
        begin
          if cbCacheNewBridges.Checked and (cbUseBridgesLimit.Checked or cbUsePreferredBridge.Checked) and (NeedAlive or not Cached) and not SpecialAddr then
          begin
            if NewBridgesStage = 1 then
              NewBridgesList.AddOrSetValue(Bridge.Ip + '|' + IntToStr(Bridge.Port) , Data[i]);
            Inc(NewBridgesCount);
          end;
        end;
        Inc(SuitableBridgesCount);
      end
      else
        Data.Delete(i);
    end
    else
      Data.Delete(i);
  end;
  if CheckEntryPorts then
    PortsDic.Clear;
end;

procedure TTcp.LimitBridgesList(var Data: TStringList; AutoSave: Boolean);
var
  i, PriorityType, Ping, Bandwidth, Max, Count: Integer;
  SortCompare: TStringListSortCompare;
  UniqueList: TDictionary<string, Byte>;
  Item: TPair<string, string>;
  GeoIpInfo: TGeoIpInfo;
  Bridge: TBridge;
  BridgeInfo: TBridgeInfo;
  IpStr: string;
  ls: TStringList;
  RandomState: Boolean;
  WeightCount, PingCount: Integer;
begin
  if Data.Text = '' then
    Exit;
  PriorityType := cbxBridgesPriority.ItemIndex;
  UniqueList := TDictionary<string, Byte>.Create;
  ls := TStringList.Create;
  try
    WeightCount := 0;
    PingCount := 0;
    for i := 0 to Data.Count - 1 do
    begin
      if TryParseBridge(Data[i], Bridge, False) then
      begin
        case PriorityType of
          PRIORITY_BANDWIDTH:
          begin
            if BridgesDic.TryGetValue(Bridge.Hash, BridgeInfo) then
            begin
              Bandwidth := BridgeInfo.Router.Bandwidth;
              Inc(WeightCount);
            end
            else
              Bandwidth := 0;
            ls.AddObject(Data[i], TObject(Bandwidth));
          end;
          PRIORITY_PING:
          begin
            Ping := MAXWORD;
            IpStr := GetBridgeIp(Bridge);
            if IpStr <> '' then
            begin
              if GeoIpDic.TryGetValue(IpStr, GeoIpInfo) then
              begin
                case GeoIpInfo.ping of
                  -1: Ping := MAXINT;
                  0: Ping := MAXWORD;
                  else
                  begin
                    Ping := GeoIpInfo.ping;
                    Inc(PingCount);
                  end;
                end;
              end;
            end;
            ls.AddObject(Data[i], TObject(Ping));
          end;
          else
            ls.AddObject(Data[i], TObject(Random(MAXWORD)));
        end;
      end;
    end;

    if ((PriorityType = PRIORITY_BANDWIDTH) and (WeightCount = 0)) or
       ((PriorityType = PRIORITY_PING) and (PingCount = 0)) then
      PriorityType := PRIORITY_BY_ORDER;

    case PriorityType of
      PRIORITY_PING: SortCompare := CompIntObjectAsc
      else
        SortCompare := CompIntObjectDesc;
    end;
    if PriorityType <> PRIORITY_BY_ORDER then
      ls.CustomSort(SortCompare);

    Count := 0;
    Max := udBridgesLimit.Position;
    Data.Text := '';

    RandomState := (cbxBridgesPriority.ItemIndex = PRIORITY_RANDOM) and (ConnectState = 0);

    if RandomState and BridgesRecalculate then
      RandomBridges.Clear
    else
    begin
      if (cbxBridgesPriority.ItemIndex = PRIORITY_RANDOM) and not cbUsePreferredBridge.Checked then
      begin
        for i := 0 to RandomBridges.Count - 1 do
        begin
          if TryParseBridge(RandomBridges[i], Bridge, False) then
          begin
            UniqueList.AddOrSetValue(Bridge.Ip + '|' + IntToStr(Bridge.Port), 0);
            Data.Append(RandomBridges[i]);
          end;
        end;
        RandomState := RandomBridges.Count = 0;
      end;
    end;
    if cbUsePreferredBridge.Checked then
      RandomState := False;

    if (cbxBridgesPriority.ItemIndex <> PRIORITY_RANDOM) or RandomState or cbUsePreferredBridge.Checked then
    begin
      for i := 0 to ls.Count - 1 do
      begin
        if Count < Max then
        begin
          if TryParseBridge(ls[i], Bridge, False) then
          begin
            UniqueList.AddOrSetValue(Bridge.Ip + '|' + IntToStr(Bridge.Port), 0);
            Data.Append(ls[i]);
            if RandomState then
              RandomBridges.Append(ls[i]);
            Inc(Count);
          end;
        end
        else
          Break;
      end;
    end;

    if AutoSave and (NewBridgesStage = 1) then
    begin
      Count := 0;
      Max := udBridgesQueueSize.Position;
      for Item in NewBridgesList do
      begin
        if Count < Max then
        begin
          if not UniqueList.ContainsKey(Item.Key) then
          begin
            Data.Append(Item.Value);
            Inc(Count);
          end;
        end
        else
          Break;
      end;
    end;

  finally
    ls.Free;
    UniqueList.Free;
  end;
end;

procedure TTcp.SetTransportsList(var ls: TStringList);
var
  i: Integer;
  Bridge: TBridge;
  T: TTransportInfo;
  IpStr: string;
begin
  if ls.Count = 0 then
    Exit;
  for i := 0 to ls.Count - 1 do
  begin
    if TryParseBridge(ls[i], Bridge, False) then
    begin
      if TransportsDic.TryGetValue(Bridge.Transport, T) then
      begin
        if T.TransportID <> TRANSPORT_SERVER then
        begin
          T.InList := True;
          TransportsDic.AddOrSetValue(Bridge.Transport, T);
        end;
      end;
      if cbUseBridges.Checked then
      begin
        IpStr := GetBridgeIp(Bridge);
        if IpStr <> '' then
          UsedBridgesList.AddOrSetValue(IpStr + '|' + IntToStr(Bridge.Port), 0);
        Inc(UsedBridgesCount);
      end;
    end;
  end;
end;

procedure TTcp.SaveBridgesData(ini: TMemIniFile = nil);
var
  PreferredBridge: string;
  ls: TStringList;
  i: Integer;
  AutoSave: Boolean;
begin
  AutoSave := ini <> nil;
  UsedBridgesCount := 0;
  UsedBridgesList.Clear;
  if AutoSave then
  begin
    ScanNewBridges := False;
    NewBridgesList.Clear;
    NewBridgesCount := 0;
    FailedBridgesCount := 0;
    FailedBridgesInterval := 0;
    UnknownBridgesCountriesCount := 0;
    DeleteTorConfig('Bridge', [cfMultiLine]);
  end;

  ls := TStringList.Create;
  try
    PreferredBridge := Trim(edPreferredBridge.Text);
    if not ValidBridge(PreferredBridge) then
    begin
      PreferredBridge := '';
      cbUsePreferredBridge.Checked := False;
    end
    else
    begin
      if cbUsePreferredBridge.Checked and cbExcludeUnsuitableBridges.Checked then
      begin
        ls.Text := PreferredBridge;
        ExcludeUnSuitableBridges(ls, not AutoSave);
        NewBridgesCount := 0;
        if SuitableBridgesCount = 0 then
          cbUsePreferredBridge.Checked := False;
      end;
    end;
    edPreferredBridge.Text := PreferredBridge;

    MemoToList(meBridges, SORT_NONE, ls);
    if cbExcludeUnsuitableBridges.Checked then
      ExcludeUnSuitableBridges(ls, not AutoSave);

    if cbUsePreferredBridge.Checked then
      ls.Text := PreferredBridge;

    if cbUseBridgesLimit.Checked or cbUsePreferredBridge.Checked then
      LimitBridgesList(ls, AutoSave);

    if (ls.Text = '') and AutoSave then
      cbUseBridges.Checked := False;

    SetTransportsList(ls);

    if AutoSave then
    begin
      if ConnectState = 0 then
      begin
        ScanNewBridges := cbEnableDetectAliveNodes.Checked and cbUseBridges.Checked and cbScanNewBridges.Checked and (NewBridgesCount > 0);
        if (UnknownBridgesCountriesCount > 0) or ScanNewBridges then
          SetTorConfig('DisableNetwork', '1');
      end;

      SetTorConfig('UseBridges', IntToStr(Integer(cbUseBridges.Checked)));
      if cbUseBridges.Checked then
        SetTorConfig('Bridge', ls);

      if (cbxBridgesPriority.ItemIndex <> PRIORITY_RANDOM) or not cbUseBridges.Checked then
        RandomBridges.Clear;

      if cbxBridgesType.ItemIndex = BRIDGES_TYPE_USER then
      begin
        ini.EraseSection('Bridges');
        for i := 0 to meBridges.Lines.Count - 1 do
          SetSettings('Bridges', IntToStr(i), meBridges.Lines[i], ini);
      end;
      SetSettings('Network', cbUseBridges, ini);
      SetSettings('Network', cbUsePreferredBridge, ini);
      SetSettings('Network', cbxBridgesList, ini, False);
      SetSettings('Network', cbxBridgesType, ini);
      SetSettings('Network', cbUseBridgesLimit, ini);
      SetSettings('Network', cbExcludeUnsuitableBridges, ini);
      SetSettings('Network', cbCacheNewBridges, ini);
      SetSettings('Network', cbScanNewBridges, ini);
      SetSettings('Network', cbxBridgesPriority, ini);
      SetSettings('Network', udBridgesLimit, ini);
      SetSettings('Network', udMaxDirFails, ini);
      SetSettings('Network', udBridgesCheckDelay, ini);
      SetSettings('Network', udBridgesQueueSize, ini);
      SetSettings('Network', edPreferredBridge, ini);
      SetSettings('Network', 'BridgesFileName', BridgesFileName, ini);
      
      if cbxBridgesType.ItemIndex = BRIDGES_TYPE_FILE then
      begin
        if BridgesFileNeedSave then
        begin
          try
            if ForceDirectories(ExtractFileDir(ExpandFileName(BridgesFileName))) then
              meBridges.Lines.SaveToFile(BridgesFileName);
          except
          end;
          BridgesFileNeedSave := False;
        end;
        BridgeFileID := GetFileID(BridgesFileName);
      end;
    end;
    BridgesCheckControls;
    CountTotalBridges;
    BridgesRecalculate := False;
  finally
    ls.Free;
  end;
end;

procedure TTcp.SaveProxyData(ini: TMemIniFile);
begin
  DeleteTorConfig('Socks4Proxy');
  DeleteTorConfig('Socks5Proxy');
  DeleteTorConfig('Socks5ProxyUsername');
  DeleteTorConfig('Socks5ProxyPassword');
  DeleteTorConfig('HTTPProxy');
  DeleteTorConfig('HTTPProxyAuthenticator');
  DeleteTorConfig('HTTPSProxy');
  DeleteTorConfig('HTTPSProxyAuthenticator');
  edProxyAddress.Text := ExtractDomain(Trim(edProxyAddress.Text));
  edProxyUser.Text := Trim(edProxyUser.Text);
  edProxyPassword.Text := Trim(edProxyPassword.Text);
  if (cbUseProxy.Checked) and ValidHost(edProxyAddress.Text) then
  begin
    case cbxProxyType.ItemIndex of
      PROXY_TYPE_SOCKS4:
        SetTorConfig('Socks4Proxy', FormatHost(edProxyAddress.Text) + ':' + IntToStr(udProxyPort.Position));
      PROXY_TYPE_SOCKS5:
      begin
        SetTorConfig('Socks5Proxy', FormatHost(edProxyAddress.Text) + ':' + IntToStr(udProxyPort.Position));
        if (edProxyUser.Text <> '') and (edProxyPassword.Text <> '') then
        begin
          SetTorConfig('Socks5ProxyUsername', edProxyUser.Text);
          SetTorConfig('Socks5ProxyPassword', edProxyPassword.Text);
        end;
      end;
      PROXY_TYPE_HTTPS:
      begin
        SetTorConfig('HTTPSProxy', FormatHost(edProxyAddress.Text) + ':' + IntToStr(udProxyPort.Position));
        if (edProxyUser.Text <> '') and (edProxyPassword.Text <> '') then
          SetTorConfig('HTTPSProxyAuthenticator', edProxyUser.Text + ':' + edProxyPassword.Text);
      end;
    end;
  end
  else
    cbUseProxy.Checked := False;
  SetSettings('Network', cbUseProxy, ini);
  SetSettings('Network', cbxProxyType, ini);
  SetSettings('Network', edProxyAddress, ini, True);
  SetSettings('Network', udProxyPort, ini);
  SetSettings('Network', edProxyUser, ini);
  SetSettings('Network', edProxyPassword, ini);
end;

procedure TTcp.SaveReachableAddresses(ini: TMemIniFile);
var
  AllowedPorts: TStringList;
  Data: string;
  i: Integer;
begin
  DeleteTorConfig('ReachableAddresses');
  AllowedPorts := TStringList.Create;
  try
    AllowedPorts.CommaText := edReachableAddresses.Text;
    for i := AllowedPorts.Count - 1 downto 0 do
    begin
      AllowedPorts[i] := Trim(AllowedPorts[i]);
      if not ValidInt(AllowedPorts[i], 1, 65535) or (AllowedPorts.IndexOf(AllowedPorts[i]) <> i) then
        AllowedPorts.Delete(i);
    end;

    if AllowedPorts.Count > 0 then
    begin
      AllowedPorts.CustomSort(CompTextAsc);
      edReachableAddresses.Text := AllowedPorts.CommaText;
      Data := '';
      for i := 0 to AllowedPorts.Count - 1 do
        Data := Data + ',*:' + AllowedPorts[i];
      Delete(Data, 1, 1);
      if cbUseReachableAddresses.Checked then
        SetTorConfig('ReachableAddresses', Data);
    end
    else
    begin
      cbUseReachableAddresses.Checked := False;
      edReachableAddresses.Text := DEFAULT_ALLOWED_PORTS;
    end;
    SetSettings('Network', cbUseReachableAddresses, ini);
    SetSettings('Network', edReachableAddresses, ini);
  finally
    AllowedPorts.Free;
  end;
end;

procedure TTCP.LoadProxyPorts(PortControl: TUpdown; HostControl: TCombobox; EnabledControl: TCheckBox; ini: TMemIniFile);
var
  Host, TempHost, Params, ParamStr: string;
  Port, i: Integer;
  Update: Boolean;
  ParseStr: ArrOfStr;
begin
  if FirstLoad then
  begin
    EnabledControl.ResetValue := EnabledControl.Checked;
    PortControl.ResetValue := PortControl.Position;
  end;
  GetLocalInterfaces(HostControl);
  Update := False;

  ParamStr := StringReplace(PortControl.Name, 'ud', '', [rfIgnoreCase]);
  Port := GetIntDef(GetSettings('Network', ParamStr, PortControl.ResetValue, ini), PortControl.ResetValue, PortControl.Min, PortControl.Max);
  Host := RemoveBrackets(GetSettings('Network', StringReplace(HostControl.Name, 'cbx', '', [rfIgnoreCase]), LOOPBACK_ADDRESS, ini), True);
  if (ValidAddress(Host) = atNone) or (HostControl.Items.IndexOf(Host) = -1) then
    Host := LOOPBACK_ADDRESS;

  Params := '';
  ParseStr := Explode(' ', GetTorConfig(ParamStr, ''));
  if Length(ParseStr) > 1 then
  begin
    for i := 1 to Length(ParseStr) - 1 do
    begin
      ParseStr[i] := Trim(ParseStr[i]);
      if ParseStr[i] <> '' then
        Params := Params + ' ' + ParseStr[i];
    end;
  end;
  HostControl.Hint := Params;

  if ValidSocket(ParseStr[0]) <> soNone then
  begin
    EnabledControl.Checked := True;
    Port := GetPortFromSocket(ParseStr[0]);
    TempHost := GetAddressFromSocket(ParseStr[0]);
    if HostControl.Items.IndexOf(TempHost) <> -1 then
      Host := TempHost
    else
      Update := True;
  end
  else
  begin
    if ValidInt(ParseStr[0], 0, PortControl.Max) then
    begin
      EnabledControl.Checked := StrToBool(ParseStr[0]);
      if StrToInt(ParseStr[0]) > 0 then
      begin
        Port := StrToInt(ParseStr[0]);
        Host := LOOPBACK_ADDRESS;
      end;
    end
    else
      Update := True;
  end;
  HostControl.ItemIndex := HostControl.Items.IndexOf(Host);
  PortControl.Position := Port;

  if (Update or CheckSimilarPorts) and ((ParseStr[0] <> '') or EnabledControl.Checked) then
    SetTorConfig(ParamStr, FormatHost(Host) + ':' + IntToStr(Port) + Params);
end;

procedure TTcp.UpdateUsedProxyTypes(ini: TMemIniFile);
var
  UpdateControls: Boolean;
begin
  if cbEnableSocks.Checked and cbEnableHttp.Checked then
    UsedProxyType := ptBoth
  else
  begin
    if cbEnableSocks.Checked then
      UsedProxyType := ptSocks
    else
    begin
      if cbEnableHttp.Checked then
        UsedProxyType := ptHttp
      else
        UsedProxyType := ptNone;
    end;
  end;
  UpdateControls := False;
  if not miCheckIpProxyAuto.Checked then
  begin
    case UsedProxyType of
      ptSocks: if miCheckIpProxyHttp.Checked then UpdateControls := True;
      ptHttp: if miCheckIpProxySocks.Checked then UpdateControls := True;
    end;
    if UpdateControls then
    begin
      miCheckIpProxyAuto.Checked := True;
      SetSettings('Network', 'CheckIpProxyType', 0, ini);
    end;
  end;
end;

procedure TTcp.UpdateSystemInfo;
var
  MaxCPU, SystemCPU, SystemMemory: Integer;
begin
  if FirstLoad then
  begin
    if CheckFileVersion(TorVersion, '0.4.7.11') then
      MaxCPU := 128
    else
      MaxCPU := 16;
    SystemCPU := GetCPUCount;
    if SystemCPU > MaxCPU then
      SystemCPU := MaxCPU;
    udNumCPUs.Max := SystemCPU;
    edNumCPUs.MaxLength := Length(IntToStr(udNumCPUs.Max));
  end;
  SystemMemory := GetAvailPhysMemory;
  udMaxMemInQueues.Max := SystemMemory - (SystemMemory mod udMaxMemInQueues.Min);
  if udMaxMemInQueues.Position > udMaxMemInQueues.Max then
    udMaxMemInQueues.Position := udMaxMemInQueues.Max;
end;

procedure TTcp.LoadUserOverrides(ini: TMemIniFile);
begin
  DefaultsDic.AddOrSetValue('BridgesBot', GetSettings('UserOverrides', 'BridgesBot', BRIDGES_BOT, ini));
  DefaultsDic.AddOrSetValue('BridgesEmail', GetSettings('UserOverrides', 'BridgesEmail', BRIDGES_EMAIL, ini));
  DefaultsDic.AddOrSetValue('BridgesSite', GetSettings('UserOverrides', 'BridgesSite', BRIDGES_SITE, ini));
  DefaultsDic.AddOrSetValue('CheckUrl', GetSettings('UserOverrides', 'CheckUrl', CHECK_URL, ini));
  DefaultsDic.AddOrSetValue('DownloadUrl', GetSettings('UserOverrides', 'DownloadUrl', DOWNLOAD_URL, ini));
  DefaultsDic.AddOrSetValue('MetricsUrl', GetSettings('UserOverrides', 'MetricsUrl', METRICS_URL, ini));
end;

procedure TTcp.ResetOptions;
var
  i, LogID, AutoSelNodesType: Integer;
  ini, inidef: TMemIniFile;
  ScrollBars, SeparateType, LogAutoDelType: Byte;
  ParseStr: ArrOfStr;
  Transports: TStringList;
  FilterEntry, FilterMiddle, FilterExit, Temp: string;
  FavoritesEntry, FavoritesMiddle, FavoritesExit, ExcludeNodes: string;
begin
  LoadTorConfig;
  ini := TMemIniFile.Create(UserConfigFile, TEncoding.UTF8);
  inidef := TMemIniFile.Create(DefaultsFile, TEncoding.UTF8);
  try
    GetSettings('Main', cbxTrayIconType, ini);
    TrayIconFile := GetSettings('Main', 'TrayIconFile', '', ini);
    if (TrayIconFile <> '') and not FileExists(TrayIconFile) then
      SetSettings('Main', 'TrayIconFile', '', ini);
    UpdateTrayIcon;
    cbxLanguage.ItemIndex := cbxLanguage.Items.IndexOfObject(TObject(Integer(GetSettings('Main', 'Language', GetLangList, ini))));
    cbxLanguage.ResetValue := cbxLanguage.Items.IndexOf('Русский');
    if cbxLanguage.ItemIndex = -1 then
    begin
      cbxLanguage.ItemIndex := cbxLanguage.ResetValue;
      SetSettings('Main', 'Language', 1049, ini);
    end;
    cbxLanguage.Tag := cbxLanguage.ItemIndex;
    if FirstLoad then
      Translate(cbxLanguage.Text);
    LoadThemesList(cbxThemes, GetSettings('Main', 'Theme', 'Windows', ini));
    LoadStyle(cbxThemes);
    SetIconsColor;
    if TorConfig.Count = 0 then
    begin
      TorConfig.Append('# ' + TransStr('271'));
      TorConfig.Append('');
    end;
    CheckRequiredFiles(True);
    LoadUserOverrides(inidef);
    GetSettings('Main', cbConnectOnStartup, ini);
    GetSettings('Main', cbRestartOnControlFail, ini);
    GetSettings('Main', cbMinimizeToTray, ini);
    GetSettings('Main', cbxMinimizeOnEvent, ini, MINIMIZE_ON_CLOSE);
    GetSettings('Main', cbShowBalloonHint, ini);
    GetSettings('Main', cbShowBalloonOnlyWhenHide, ini);
    GetSettings('Main', cbStayOnTop, ini);
    GetSettings('Main', cbNoDesktopBorders, ini);
    GetSettings('Main', cbNoDesktopBordersOnlyEnlarged, ini);
    GetSettings('Main', cbHideIPv6Addreses, ini);
    GetSettings('Main', cbUseNetworkCache, ini);
    GetSettings('Main', cbUseOpenDNS, ini);
    GetSettings('Main', cbUseOpenDNSOnlyWhenUnknown, ini);
    GetSettings('Main', cbRememberEnlargedPosition, ini);
    GetSettings('Main', cbClearPreviousSearchQuery, ini);

    FormatCodesOnExtract := GetSettings('Extractor', 'FormatCodesOnExtract', True, ini);
    FormatIPv6OnExtract := GetSettings('Extractor', 'FormatIPv6OnExtract', True, ini);
    RemoveDuplicateOnExtract := GetSettings('Extractor', 'RemoveDuplicateOnExtract', True, ini);
    SortOnExtract := GetSettings('Extractor', 'SortOnExtract', True, ini);
    ExtractDelimiterType := GetIntDef(GetSettings('Extractor', 'ExtractDelimiterType', 0, ini), 0, 0, 2);

    if FirstLoad then
    begin
      LoadNetworkCache;
      LastPlace := GetIntDef(GetSettings('Main', 'LastPlace', LP_OPTIONS, ini), LP_OPTIONS, LP_OPTIONS, LP_ROUTERS);
      pcOptions.TabIndex := GetIntDef(GetSettings('Main', 'OptionsPage', 0, ini), 0, 0, pcOptions.PageCount - 1);
      ParseStr := Explode(',', GetSettings('Main', 'FormPosition', '-1,-1,-1,-1', ini));
      for i := 0 to Length(ParseStr) - 1 do
      begin
        case i of
          0: DecFormPos.X := StrToIntDef(ParseStr[i], -1);
          1: DecFormPos.Y := StrToIntDef(ParseStr[i], -1);
          2: IncFormPos.X := StrToIntDef(ParseStr[i], -1);
          3: IncFormPos.Y := StrToIntDef(ParseStr[i], -1);
        end;
      end;
      SetDesktopPosition(IncFormPos.X, IncFormPos.Y, False);
      DecreaseFormSize;
    end;

    GetSettings('Log', miWriteLogFile, ini);
    GetSettings('Log', miAutoClear, ini);
    GetSettings('Log', sbAutoScroll, ini);
    GetSettings('Log', sbWordWrap, ini);

    GetSettings('Network', miPreferWebTelegram, ini);
    GetSettings('Network', miRequestIPv6Bridges, ini, False);
    GetSettings('Network', miRequestObfuscatedBridges, ini);

    GetSettings('Lists', cbUseHiddenServiceVanguards, ini);
    GetSettings('Lists', cbxVanguardLayerType, ini);

    GetSettings('Filter', miFilterHideUnused, ini);
    GetSettings('Filter', miFilterScrollTop, ini);
    GetSettings('Filter', miFilterSelectRow, ini);
    GetSettings('Filter', miIgnoreTplLoadParamsOutsideTheFilter, ini);
    GetSettings('Filter', miNotLoadEmptyTplData, ini);
    GetSettings('Filter', miReplaceDisabledFavoritesWithCountries, ini);
    GetSettings('Filter', miExcludeBridgesWhenCounting, ini, False);

    GetSettings('Routers', miRoutersScrollTop, ini);
    GetSettings('Routers', miRoutersSelectRow, ini);
    GetSettings('Routers', miRoutersShowFlagsHint, ini);
    GetSettings('Routers', miDisableSelectionUnSuitableAsBridge, ini);
    GetSettings('Routers', miDisableFiltersOnAuthorityOrBridge, ini);
    GetSettings('Routers', miLoadCachedRoutersOnStartup, ini);
    GetSettings('Routers', miDisableFiltersOnUserQuery, ini);
    GetSettings('Routers', miEnableConvertNodesOnIncorrectClear, ini);
    GetSettings('Routers', miEnableConvertNodesOnAddToNodesList, ini);
    GetSettings('Routers', miEnableConvertNodesOnRemoveFromNodesList, ini);
    GetSettings('Routers', miConvertIpNodes, ini);
    GetSettings('Routers', miConvertCidrNodes, ini);
    GetSettings('Routers', miConvertCountryNodes, ini);
    GetSettings('Routers', miIgnoreConvertExcludeNodes, ini);
    GetSettings('Routers', miAvoidAddingIncorrectNodes, ini);

    GetSettings('Circuits', miHideCircuitsWithoutStreams, ini, False);
    GetSettings('Circuits', miAlwaysShowExitCircuit, ini);
    GetSettings('Circuits', miSelectExitCircuitWhenItChanges, ini);
    GetSettings('Circuits', miShowCircuitsTraffic, ini);
    GetSettings('Circuits', miShowStreamsTraffic, ini);
    GetSettings('Circuits', miShowStreamsInfo, ini);
    GetSettings('Circuits', miShowPortAlongWithIp, ini);
    GetSettings('Circuits', miCircuitsShowFlagsHint, ini);

    GetSettings('Scanner', cbEnablePingMeasure, ini);
    GetSettings('Scanner', cbEnableDetectAliveNodes, ini);
    GetSettings('Scanner', cbAutoScanNewNodes, ini);
    GetSettings('Scanner', miManualPingMeasure, ini);
    GetSettings('Scanner', miManualDetectAliveNodes, ini);
    GetSettings('Scanner', udScanPortTimeout, ini);
    GetSettings('Scanner', udScanPingTimeout, ini);
    GetSettings('Scanner', udScanPortionTimeout, ini);
    GetSettings('Scanner', udDelayBetweenAttempts, ini);
    GetSettings('Scanner', udScanPingAttempts, ini);
    GetSettings('Scanner', udScanPortAttempts, ini);
    GetSettings('Scanner', udScanMaxThread, ini);
    GetSettings('Scanner', udScanPortionSize, ini);
    GetSettings('Scanner', udFullScanInterval, ini);
    GetSettings('Scanner', udPartialScanInterval, ini);
    GetSettings('Scanner', udPartialScansCounts, ini);
    GetSettings('Scanner', cbxAutoScanType, ini);
    GetSettings('Scanner', cbxAutoSelRoutersAfterScanType, ini);

    GetSettings('AutoSelNodes', cbxAutoSelPriority, ini);
    GetSettings('AutoSelNodes', udAutoSelEntryCount, ini);
    GetSettings('AutoSelNodes', udAutoSelMiddleCount, ini);
    GetSettings('AutoSelNodes', udAutoSelExitCount, ini);
    GetSettings('AutoSelNodes', udAutoSelFallbackDirCount, ini);
    GetSettings('AutoSelNodes', udAutoSelMinWeight, ini);
    GetSettings('AutoSelNodes', udAutoSelMaxPing, ini);
    GetSettings('AutoSelNodes', cbAutoSelFallbackDirNoLimit, ini);
    GetSettings('AutoSelNodes', cbAutoSelStableOnly, ini);
    GetSettings('AutoSelNodes', cbAutoSelFilterCountriesOnly, ini);
    GetSettings('AutoSelNodes', cbAutoSelUniqueNodes, ini);
    GetSettings('AutoSelNodes', cbAutoSelNodesWithPingOnly, ini);
    GetSettings('AutoSelNodes', cbAutoSelMiddleNodesWithoutDir, ini);
    AutoSelNodesType := GetIntDef(GetSettings('AutoSelNodes', 'AutoSelNodesType', 15, ini), 15, 0, 15);
    GetMaskData(AutoSelNodesType, cbAutoSelEntryEnabled);
    GetMaskData(AutoSelNodesType, cbAutoSelMiddleEnabled);
    GetMaskData(AutoSelNodesType, cbAutoSelExitEnabled);
    GetMaskData(AutoSelNodesType, cbAutoSelFallbackDirEnabled);
    CheckAutoSelControls;

    GetSettings('Status', miSelectGraphDL, ini);
    GetSettings('Status', miSelectGraphUL, ini);
    GetSettings('Status', miEnableTotalsCounter, ini);

    CurrentTrafficPeriod := GetIntDef(GetSettings('Status', 'CurrentTrafficPeriod', 1, ini), 1, 0, 8);
    miTrafficPeriod.items[CurrentTrafficPeriod].Checked := True;

    LastFullScanDate := GetSettings('Scanner', 'LastFullScanDate', 0, ini);
    LastPartialScanDate := GetSettings('Scanner', 'LastPartialScanDate', 0, ini);
    LastPartialScansCounts := GetSettings('Scanner', 'LastPartialScansCounts', 0, ini);

    GeoFileID := GetSettings('Main', 'GeoFileID', '', ini);
    if (GeoFileID = '') and GeoIpExists and not FileExists(NetworkCacheFile) then
    begin
      GeoFileID := GetFileID(GeoIpFile, True);
      SetSettings('Main', 'GeoFileID', GeoFileID, ini);
    end;

    tmCircuits.Interval := GetIntDef(GetSettings('Circuits', 'UpdateInterval', 1000, ini), 1000, 0, 4000);
    case tmCircuits.Interval of
      0: miCircuitsUpdateManual.Checked := True;
      500: miCircuitsUpdateHigh.Checked := True;
      1000: miCircuitsUpdateNormal.Checked := True;
      4000: miCircuitsUpdateLow.Checked := True;
      else
      begin
        miCircuitsUpdateNormal.Checked := True;
        tmCircuits.Interval := 1000;
      end;
    end;

    IntToMenu(miCircuitFilter, GetSettings('Circuits', 'PurposeFilter', CIRCUIT_FILTER_DEFAULT, ini));
    IntToMenu(miTplSave, GetSettings('Filter', 'TplSave', TPL_MENU_DEFAULT, ini));
    IntToMenu(miTplLoad, GetSettings('Filter', 'TplLoad', TPL_MENU_DEFAULT, ini));

    CheckSelectRowOptions(sgFilter, miFilterSelectRow.Checked);
    CheckSelectRowOptions(sgRouters, miRoutersSelectRow.Checked);

    ParseStr := Explode(',', GetSettings('Main', 'SortData',
      Format('%d,%d,%d,%d,%d,%d,%d,%d,%d,%d', [
        SORT_DESC, FILTER_TOTAL,
        SORT_DESC, ROUTER_WEIGHT,
        SORT_DESC, CIRC_ID,
        SORT_DESC, STREAMS_ID,
        SORT_DESC, STREAMS_INFO_ID
      ]),
    ini));
    for i := 0 to Length(ParseStr) - 1 do
    begin
      case i of
        0: sgFilter.SortType := StrToIntDef(ParseStr[i], SORT_DESC);
        1: sgFilter.SortCol := StrToIntDef(ParseStr[i], FILTER_TOTAL);
        2: sgRouters.SortType := StrToIntDef(ParseStr[i], SORT_DESC);
        3: sgRouters.SortCol := StrToIntDef(ParseStr[i], ROUTER_WEIGHT);
        4: sgCircuits.SortType := StrToIntDef(ParseStr[i], SORT_DESC);
        5: sgCircuits.SortCol := StrToIntDef(ParseStr[i], CIRC_ID);
        6: sgStreams.SortType := StrToIntDef(ParseStr[i], SORT_DESC);
        7: sgStreams.SortCol := StrToIntDef(ParseStr[i], STREAMS_ID);
        8: sgStreamsInfo.SortType := StrToIntDef(ParseStr[i], SORT_DESC);
        9: sgStreamsInfo.SortCol := StrToIntDef(ParseStr[i], STREAMS_INFO_ID);
      end;
    end;

    ParseStr := Explode(',', GetSettings('Main', 'SortListData',
      Format('%d,%d,%d,%d,%d', [
        SORT_NONE, SORT_ASC, SORT_ASC, SORT_ASC, SORT_ASC
      ]),
    ini));
    for i := 0 to Length(ParseStr) - 1 do
    begin
      case i of
        0: meBridges.SortType := StrToIntDef(ParseStr[i], SORT_NONE);
        1: meMyFamily.SortType := StrToIntDef(ParseStr[i], SORT_ASC);
        2: meTrackHostExits.SortType := StrToIntDef(ParseStr[i], SORT_ASC);
        3: meNodesList.SortType := StrToIntDef(ParseStr[i], SORT_ASC);
        4: meFallbackDirs.SortType := StrToIntDef(ParseStr[i], SORT_ASC);
      end;
    end;

    GetSettings('Network', cbUseProxy, ini);
    GetSettings('Network', cbxProxyType, ini, PROXY_TYPE_SOCKS5);
    GetSettings('Network', edProxyAddress, ini);
    GetSettings('Network', udProxyPort, ini);
    GetSettings('Network', edProxyUser, ini);
    GetSettings('Network', edProxyPassword, ini);
    SaveProxyData(ini);

    GetSettings('Network', edReachableAddresses, ini);
    GetSettings('Network', cbUseReachableAddresses, ini);
    SaveReachableAddresses(ini);

    meLog.WordWrap := sbWordWrap.Down;
    SeparateType := GetIntDef(GetSettings('Log', 'SeparateType', 1, ini), 1, 0, 3);
    miLogSeparate.items[SeparateType].Checked := True;
    TorLogFile := GetLogFileName(SeparateType);

    ScrollBars := GetIntDef(GetSettings('Log', 'ScrollBars', 0, ini), 0, 0, 3);
    miScrollBars.items[ScrollBars].Checked := True;
    SetLogScrollBar(ScrollBars);

    GetSettings('Log', sbUseLinesLimit, ini);
    GetSettings('Log', udLinesLimit, ini);
    CheckLinesLimitControls;

    LogAutoDelType := GetIntDef(GetSettings('Log', 'LogAutoDelType', 0, ini), 0, 0, 10);
    if LogAutoDelType in [2, 3] then
      LogAutoDelType := 0;
    miLogAutoDelType.Items[LogAutoDelType].Checked := True;
    LogAutoDelHours := miLogAutoDelType.Items[LogAutoDelType].Tag;

    if FirstLoad then
      cbxLogLevel.ResetValue := 2;
    LogID := GetArrayIndex(LogLevels, LowerCase(SeparateLeft(GetTorConfig('Log', 'notice stdout', [cfAutoAppend]), ' ')));
    if LogID <> -1 then
      cbxLogLevel.ItemIndex := LogID
    else
    begin
      cbxLogLevel.ItemIndex := 2;
      SetTorConfig('Log', 'notice stdout');
    end;

    ControlPassword := GetSettings('Main', 'ControlPassword', '', ini);
    Temp := GetSettings('Main', 'HashedControlPassword', '', ini);
    if Temp = '' then
    begin
      ControlPassword := '';
      SetSettings('Main', 'ControlPassword', '', ini);
    end;
    if (ControlPassword = '')then
    begin
      SetTorConfig('CookieAuthentication', '1');
      edControlPassword.Text := '';
    end
    else
      edControlPassword.Text := Decrypt(ControlPassword, 'True');
    if GetTorConfig('CookieAuthentication', '0') = '1' then
    begin
      cbxAuthMetod.ItemIndex := 0;
      DeleteTorConfig('HashedControlPassword');
    end
    else
    begin
      cbxAuthMetod.ItemIndex := 1;
      SetTorConfig('HashedControlPassword', Temp);
    end;
    CheckAuthMetodContols;

    GetSettings(sbSafeLogging);
    GetSettings(cbLearnCircuitBuildTimeout);
    GetSettings(cbAvoidDiskWrites);
    GetSettings(cbStrictNodes, [cfBoolInvert]);
    GetSettings(cbEnforceDistinctSubnets);
    GetSettings(udMaxCircuitDirtiness);
    GetSettings(udSocksTimeout);
    GetSettings(udCircuitBuildTimeout);
    GetSettings(udNewCircuitPeriod);
    GetSettings(udMaxClientCircuitsPending);
    GetSettings(udControlPort, [cfAutoAppend]);

    miCheckIpProxyType.Items[GetIntDef(GetSettings('Network', 'CheckIpProxyType', 0, ini), 0, 0, 2)].Checked := True;
    LoadProxyPorts(udSOCKSPort, cbxSOCKSHost, cbEnableSocks, ini);
    LoadProxyPorts(udHttpTunnelPort, cbxHttpTunnelHost, cbEnableHttp, ini);
    UpdateUsedProxyTypes(ini);

    if ini.SectionExists('Transports') then
    begin
      Transports := TStringList.Create;
      try
        ini.ReadSectionValues('Transports', Transports);
        if Transports.Count > 0 then
          LoadTransportsData(Transports);
      finally
        Transports.Free;
      end;
    end
    else
      ResetTransports(inidef);

    GetSettings('Network', cbUseBridges, ini);
    GetSettings('Network', cbUsePreferredBridge, ini);
    GetSettings('Network', cbxBridgesType, ini);
    GetSettings('Network', cbUseBridgesLimit, ini);
    GetSettings('Network', cbExcludeUnsuitableBridges, ini);
    GetSettings('Network', cbCacheNewBridges, ini);
    GetSettings('Network', cbScanNewBridges, ini);
    GetSettings('Network', udBridgesLimit, ini);
    GetSettings('Network', udMaxDirFails, ini);
    GetSettings('Network', udBridgesCheckDelay, ini);
    GetSettings('Network', udBridgesQueueSize, ini);
    GetSettings('Network', cbxBridgesPriority, ini);
    GetSettings('Network', edPreferredBridge, ini);

    BridgesFileName := GetSettings('Network', 'BridgesFileName', '', ini);
    LoadBuiltinBridges(inidef, cbxBridgesType.ItemIndex = BRIDGES_TYPE_BUILTIN, True, GetSettings('Network', 'BridgesList', '', ini));
    case cbxBridgesType.ItemIndex of
      BRIDGES_TYPE_USER: LoadUserBridges(ini);
      BRIDGES_TYPE_FILE: LoadBridgesFromFile;
    end;
    if FirstLoad then
      LoadBridgesCache;

    GetSettings('Filter', cbxFilterMode, ini, FILTER_TYPE_COUNTRIES);
    FilterEntry := GetSettings('Filter', 'EntryNodes', DEFAULT_ENTRY_NODES, ini);
    FilterMiddle := GetSettings('Filter', 'MiddleNodes', DEFAULT_MIDDLE_NODES, ini);
    FilterExit := GetSettings('Filter', 'ExitNodes', DEFAULT_EXIT_NODES, ini);
    if not FirstLoad then
      ClearFilter(ntNone);
    GetNodes(FilterEntry, ntEntry, False, ini);
    GetNodes(FilterMiddle, ntMiddle, False, ini);
    GetNodes(FilterExit, ntExit, False, ini);

    FavoritesEntry := GetSettings('Routers', 'EntryNodes', '', ini);
    FavoritesMiddle := GetSettings('Routers', 'MiddleNodes', '', ini);
    FavoritesExit := GetSettings('Routers', 'ExitNodes', '', ini);
    ExcludeNodes := GetSettings('Routers', 'ExcludeNodes', '', ini);

    if not FirstLoad then
      ClearRouters;
    GetNodes(FavoritesEntry, ntEntry, True, ini);
    GetNodes(FavoritesMiddle, ntMiddle, True, ini);
    GetNodes(FavoritesExit, ntExit, True, ini);
    GetNodes(ExcludeNodes, ntExclude, True, ini);

    CalculateTotalNodes;
    CalculateFilterNodes;

    lbFavoritesEntry.HelpContext := GetIntDef(GetSettings('Lists', 'UseFavoritesEntry', 0, ini), 0, 0, 1);
    lbFavoritesMiddle.HelpContext := GetIntDef(GetSettings('Lists', 'UseFavoritesMiddle', 0, ini), 0, 0, 1);
    lbFavoritesExit.HelpContext := GetIntDef(GetSettings('Lists', 'UseFavoritesExit', 0, ini), 0, 0, 1);
    lbExcludeNodes.HelpContext := GetIntDef(GetSettings('Lists', 'UseExcludeNodes', 0, ini), 0, 0, 1);

    GetSettings('Lists', cbxNodesListType, ini, NL_TYPE_EXLUDE);
    case cbxNodesListType.ItemIndex of
      NL_TYPE_ENTRY: LoadNodesList(False, FavoritesEntry);
      NL_TYPE_MIDDLE: LoadNodesList(False, FavoritesMiddle);
      NL_TYPE_EXIT: LoadNodesList(False, FavoritesExit);
      NL_TYPE_EXLUDE: LoadNodesList(False, ExcludeNodes);
    end;
    CheckFilterMode;
    CheckFavoritesState;
    CheckVanguards(True);

    DeleteTorConfig('DisableNetwork');
    GetSettings('Lists', cbUseFallbackDirs, ini);
    GetSettings('Lists', cbExcludeUnsuitableFallbackDirs, ini);
    GetSettings('Lists', cbxFallbackDirsType, ini);
    case cbxFallbackDirsType.ItemIndex of
      FALLBACK_TYPE_BUILTIN: LoadFallbackDirs(inidef, True);
      FALLBACK_TYPE_USER: LoadFallbackDirs(ini, False);
    end;
    if not FirstLoad then
      SaveFallbackDirsData(ini);
    BridgesFileNeedSave := False;
    SaveBridgesData(ini);

    SetNodes(FilterEntry, FilterMiddle, FilterExit, FavoritesEntry, FavoritesMiddle, FavoritesExit, ExcludeNodes);
    SetSettings('Filter', cbxFilterMode, ini);

    UpdateSystemInfo;
    GetSettings('Server', edNickname, ini);
    GetSettings('Server', edContactInfo, ini);
    GetSettings('Server', edAddress, ini);
    GetSettings('Server', cbxServerMode, ini);
    GetSettings('Server', udORPort, ini);
    GetSettings('Server', udDirPort, ini);
    GetSettings('Server', cbUseDirPort, ini);
    GetSettings('Server', cbDirCache, ini);
    GetSettings('Server', cbListenIPv6, ini);
    GetSettings('Server', cbUseAddress, ini);
    GetSettings('Server', udNumCPUs, ini);
    GetSettings('Server', udTransportPort, ini);
    GetSettings('Server', cbUseNumCPUs, ini);
    GetSettings('Server', cbUseMaxMemInQueues, ini);
    GetSettings('Server', udMaxMemInQueues, ini);
    GetSettings('Server', cbUseRelayBandwidth, ini);
    GetSettings('Server', udRelayBandwidthRate, ini);
    GetSettings('Server', udRelayBandwidthBurst, ini);
    GetSettings('Server', udMaxAdvertisedBandwidth,ini);
    GetSettings('Server', cbUseUPnP, ini);
    GetSettings('Server', cbIPv6Exit, ini);
    GetSettings('Server', cbPublishServerDescriptor, ini);
    GetSettings('Server', cbDirReqStatistics, ini);
    GetSettings('Server', cbHiddenServiceStatistics, ini);
    GetSettings('Server', cbAssumeReachable, ini);
    GetSettings('Server', cbUseMyFamily, ini);
    GetSettings('Server', cbxBridgeDistribution, ini);
    GetSettings('Server', cbxExitPolicyType, ini);
    LineToMemo(GetSettings('Server', 'CustomExitPolicy', DEFAULT_CUSTOM_EXIT_POLICY, ini), meExitPolicy);
    LineToMemo(GetSettings('Server', 'MyFamily', '', ini), meMyFamily, meMyFamily.SortType);
    SaveServerOptions(ini);
    SaveTransportsData(ini, True);

    GetSettings('Main', cbxConnectionPadding, ini);
    GetSettings('Main', cbxCircuitPadding, ini);
    SavePaddingOptions(ini);
    CheckPaddingControls;

    GetSettings('Lists', cbUseTrackHostExits, ini);
    GetSettings('Lists', udTrackHostExitsExpire, ini);
    LineToMemo(GetSettings('Lists', 'TrackHostExits', '', ini), meTrackHostExits, meTrackHostExits.SortType);
    SaveTrackHostExits(ini);

    CheckScannerControls;
    if not FirstLoad then
      CheckStatusControls;
    CheckCircuitsControls;
    CheckStreamsControls;
    CheckCachedFiles;

    HsToDelete := nil;
    ClearGrid(sgHs);
    ClearGrid(sgHsPorts);
    GetLocalInterfaces(cbxHsAddress);
    if LoadHiddenServices(ini) = 0 then
      UpdateHs
    else
    begin
      HsControlsEnable(True);
      SelectHs;
    end;
    SaveHiddenServices(ini);
    if FirstLoad then
      LoadRoutersFilterData(GetSettings('Routers', 'CurrentFilter', DEFAULT_ROUTERS_FILTER_DATA, ini), False);
    ParseStr := Explode(';', GetSettings('Routers', 'DefaultFilter', DEFAULT_ROUTERS_FILTER_DATA, ini));
    if Length(ParseStr) > 4 then
      udRoutersWeight.ResetValue := StrToIntDef(ParseStr[4], 10);
    CheckShowRouters;

    if FirstLoad then
    begin
      if GetSettings('Main', 'Terminated', False, ini) = True then
      begin
        if (cbUseUPnP.Checked) and (cbxServerMode.ItemIndex > SERVER_MODE_NONE) then
          RemoveUPnPEntry(udORPort.Position, udDirPort.Position, udTransportPort.Position);
      end;
      TotalDL := GetSettings('Status', 'TotalDL', 0, ini);
      TotalUL := GetSettings('Status', 'TotalUL', 0, ini);
      TotalStartDate := GetSettings('Status', 'TotalStartDate', 0, ini);
      if (TotalStartDate = 0) or ((TotalDL = 0) and (TotalUL = 0)) then
      begin
        TotalStartDate := DateTimeToUnix(Now);
        SetSettings('Status', 'TotalStartDate', TotalStartDate, ini);
      end;
      CheckStatusControls;
      SetSettings('Main', 'Terminated', True, ini);

      if miLoadCachedRoutersOnStartup.Checked then
        LoadConsensus
      else
      begin
        SaveFallbackDirsData(ini);
        LoadRoutersCountries;
        ShowFilter;
        ShowRouters;
        ShowCircuits;
        CheckTorAutoStart;
      end;
    end
    else
    begin
      SetDesktopPosition(Tcp.Left, Tcp.Top);
      if ConsensusUpdated then
        LoadConsensus
      else
      begin
        CheckCountryIndexInList;
        ShowFilter;
        ShowRouters;
        if ConnectState = 0 then
          ShowCircuits;
      end;
      BridgesUpdated := False;
      RoutersUpdated := False;
      FilterUpdated := False;
    end;
    FallbackDirsUpdated := False;
    DefaultsFileID := GetFileID(DefaultsFile);
    SaveTorConfig;
    OptionsLocked := False;
    EnableOptionButtons(False);
  finally
    UpdateConfigFile(ini);
    inidef.Free;
  end;
end;

procedure TTcp.LoadNetworkCache;
var
  DataLength, i: Integer;
  ParseStr: ArrOfStr;
  GeoIpCache: TStringList;
  GeoIpInfo: TGeoIpInfo;
  FilterInfo: TFilterInfo;
begin
  if FileExists(NetworkCacheFile) then
  begin
    GeoIpCache := TStringList.Create;
    try
      GeoIpCache.LoadFromFile(NetworkCacheFile);
      for i := 0 to GeoIpCache.Count - 1 do
      begin
        ParseStr := Explode(',', GeoIpCache[i]);
        DataLength := Length(ParseStr);
        if DataLength in [2..4] then
        begin
          if FilterDic.TryGetValue(ParseStr[1], FilterInfo) then
          begin
            if ValidAddress(ParseStr[0]) <> atNone then
            begin
              GeoIpInfo.cc := FilterInfo.cc;
              if DataLength > 2 then
                GeoIpInfo.ping := StrToIntDef(ParseStr[2], 0)
              else
                GeoIpInfo.ping := 0;
              if DataLength > 3 then
                GeoIpInfo.ports := ParseStr[3]
              else
                GeoIpInfo.ports := '';
              GeoIpDic.AddOrSetValue(ParseStr[0], GeoIpInfo);
            end;
          end;
        end;
      end;
    finally
      GeoIpCache.Free;
    end;
  end;
end;

procedure TTcp.SaveNetworkCache(AutoSave: Boolean = True);
var
  GeoIpCache: TStringList;
  Item: TPair<string, TGeoIpInfo>;
  PingData, PortsData: string;
begin
  if cbUseNetworkCache.Checked then
  begin
    if not (AutoSave or GeoIpModified) and not (Closing or ScanNewBridges) then
      Exit;
    GeoIpCache := TStringList.Create;
    try
      for Item in GeoIpDic do
      begin
        if Item.Value.ports = '' then
          PortsData := ''
        else
          PortsData := ',' + Item.Value.ports;

        if Item.Value.ping = 0 then
        begin
          if PortsData = '' then
            PingData := ''
          else
            PingData := ',0'
        end
        else
          PingData := ',' + IntToStr(Item.Value.ping);

        GeoIpCache.Append(Item.Key + ',' + CountryCodes[Item.Value.cc] + PingData + PortsData);
      end;
      if GeoIpCache.Count > 0 then
      begin
        GeoIpCache.SaveToFile(NetworkCacheFile);
        Flush(NetworkCacheFile);
        GeoIpModified := False;
      end;
    finally
      GeoIpCache.Free;
    end;
  end;
end;

procedure TTCP.LoadBridgesCache;
var
  DataLength, i, j: Integer;
  BridgesCache: TStringList;
  BridgeInfo: TBridgeInfo;
  ParseStr, IpStr: ArrOfStr;
  BridgeStr: string;
begin
  if FileExists(BridgesCacheFile) then
  begin
    BridgesCache := TStringList.Create;
    try
      BridgesCache.LoadFromFile(BridgesCacheFile);
      if BridgesCache.Count = 0 then
        Exit;
      for i := 0 to BridgesCache.Count - 1 do
      begin
        ParseStr := Explode('|', BridgesCache[i]);
        DataLength := Length(ParseStr);
        if DataLength in [8..11] then
        begin
          BridgeInfo.Router.Flags := [rfBridge];
          BridgeInfo.Router.Params := ROUTER_BRIDGE;
          BridgeInfo.Router.Name := ParseStr[1];
          BridgeInfo.Router.IPv4 := '';
          BridgeInfo.Router.IPv6 := '';
          IpStr := Explode(',', ParseStr[2]);
          for j := 0 to Length(IpStr) - 1 do
          begin
            case ValidAddress(IpStr[j], False, True) of
              atIPv4: BridgeInfo.Router.IPv4 := IpStr[j];
              atIPv6: BridgeInfo.Router.IPv6 := IpStr[j];
            end;  
          end;
          if BridgeInfo.Router.IPv6 <> '' then
            Inc(BridgeInfo.Router.Params, ROUTER_REACHABLE_IPV6);
          BridgeInfo.Router.Port := StrToIntDef(ParseStr[3], 0);
          BridgeInfo.Router.DirPort := 0;
          BridgeInfo.Router.Bandwidth := StrToIntDef(ParseStr[4], 0);  
          BridgeInfo.Router.Version := ParseStr[5];
          BridgeInfo.Kind := GetIntDef(StrToIntDef(ParseStr[6], BRIDGE_RELAY), BRIDGE_RELAY, BRIDGE_RELAY, BRIDGE_NATIVE);
          if ParseStr[7] = '1' then
            Include(BridgeInfo.Router.Flags, rfV2Dir);
          if DataLength > 8 then
            BridgeInfo.Transport := ParseStr[8]
          else
            BridgeInfo.Transport := '';
          if DataLength > 9 then
            BridgeInfo.Params := ParseStr[9]
          else
            BridgeInfo.Params := '';
          if DataLength > 10 then
            BridgeInfo.Source := ParseStr[10]
          else
            BridgeInfo.Source := '';

          BridgeStr := Trim(
            BridgeInfo.Transport + ' ' +
            BridgeInfo.Router.IPv4 + ':' +
            IntToStr(BridgeInfo.Router.Port) + ' ' +
            ParseStr[0] + ' ' +
            BridgeInfo.Params
          );
          if ValidBridge(BridgeStr) then
          begin
            BridgesDic.AddOrSetValue(ParseStr[0], BridgeInfo);
            if BridgeInfo.Source <> '' then
              CompBridgesDic.AddOrSetValue(BridgeInfo.Source, ParseStr[0]);
          end;
        end;
      end;
    finally
      BridgesCache.Free;
    end;
  end;
end;

procedure TTcp.SaveBridgesCache;
var
  BridgesCache: TStringList;
  Item: TPair<string, TBridgeInfo>;
  Address, Transport, Params, Source: string;
begin
  BridgesCache := TStringList.Create;
  try
    for Item in BridgesDic do
    begin
      if Item.Value.Router.IPv6 = '' then
        Address := Item.Value.Router.IPv4
      else
        Address := Item.Value.Router.IPv4 + ',' + Item.Value.Router.IPv6;

      if Item.Value.Transport = '' then
        Transport := ''
      else
        Transport := '|' + Item.Value.Transport;

      if Item.Value.Params <> '' then
      begin
        Params := '|' + Item.Value.Params;
        if Transport = '' then
          Params := '|' + Params;
      end
      else
        Params := '';

      if Item.Value.Source <> '' then
        Source := '|' + Item.Value.Source
      else
        Source := '';

      BridgesCache.Append(
        Item.Key + '|' +
        Item.Value.Router.Name + '|' +
        Address + '|' +
        IntToStr(Item.Value.Router.Port) + '|' +
        IntToStr(Item.Value.Router.Bandwidth) + '|' +
        Item.Value.Router.Version + '|' +
        IntToStr(Item.Value.Kind) + '|' +
        IntToStr(Integer(rfV2Dir in Item.Value.Router.Flags)) +
        Transport +
        Params +
        Source
      );
    end;
    if BridgesDic.Count > 0 then
    begin
      BridgesCache.SaveToFile(BridgesCacheFile);
      Flush(BridgesCacheFile);
    end
    else
      DeleteFile(BridgesCacheFile);
  finally
    BridgesCache.Free;
  end;
end;

procedure TTcp.SetServerPort(PortControl: TUpDown);
var
  PortName, FlagsStr: string;
begin
  PortName := Copy(PortControl.Name, 3);
  if cbListenIPv6.Checked then
    FlagsStr := ''
  else
    FlagsStr := ' IPv4Only';
  SetTorConfig(PortName, IntToStr(PortControl.Position) + FlagsStr);
end;

procedure TTcp.CheckFilterMode;
var
  FMode: Integer;
begin
  FMode := cbxFilterMode.ItemIndex;
  if (FMode = FILTER_MODE_FAVORITES) and (lbFavoritesTotal.Tag = 0) then
    FMode := FILTER_MODE_COUNTRIES;
  if (FMode = FILTER_MODE_FAVORITES) and (lbFavoritesEntry.HelpContext = 0) and (lbFavoritesMiddle.HelpContext = 0) and (lbFavoritesExit.HelpContext = 0) then
    FMode := FILTER_MODE_COUNTRIES;
  if (FMode = FILTER_MODE_COUNTRIES) and (lbFilterEntry.Tag = 0) and (lbFilterMiddle.Tag = 0) and (lbFilterExit.Tag = 0) then
    FMode := FILTER_MODE_NONE;
  if (FMode = FILTER_MODE_COUNTRIES) and not GeoIpExists then
    FMode := FILTER_MODE_NONE;
  cbxFilterMode.ItemIndex := FMode;
end;

function TTcp.CheckTransports: Boolean;
var
  i, j, ResultCode: Integer;
  TransportID: Byte;
  T: TTransportInfo;
  Transports, Item, Handler, Params, Msg, ResultMsg: string;
  ParseStr: ArrOfStr;
begin
  Result := True;
  ResultCode := 0;
  TransportsDic.Clear;
  if not edTransports.Enabled then
    Exit;
  edTransports.Text := StringReplace(edTransports.Text, ' ', '', [rfReplaceAll]);
  edTransportsHandler.Text := StringReplace(edTransportsHandler.Text, ' ', '', [rfReplaceAll]);
  meHandlerParams.Text := Trim(meHandlerParams.Text);
  Msg := TTabSheet(gbTransports.GetParentComponent).Caption + ' - ' + gbTransports.Caption + BR + BR;
  for i := 1 to sgTransports.RowCount - 1 do
  begin
    TransportID := GetTransportID(sgTransports.Cells[PT_TYPE, i]);
    Transports := sgTransports.Cells[PT_TRANSPORTS, i];
    Handler := sgTransports.Cells[PT_HANDLER, i];
    Params := sgTransports.Cells[PT_PARAMS, i];

    if not FileExists(TransportsDir + Handler) then
    begin
      ResultCode := 2;
      Break;
    end;

    if Pos('|', Params) <> 0 then
    begin
      ResultCode := 5;
      Break;
    end;

    ParseStr := Explode(',', Transports);
    for j := 0 to Length(ParseStr) - 1 do
    begin
      Item := Trim(ParseStr[j]);
      if Item = '' then
      begin
        ResultCode := 1;
        Break;
      end;

      ResultMsg := CheckEditString(Item, '_', False);
      if ResultMsg <> '' then
      begin
        ResultCode := 3;
        Break;
      end;

      if TransportsDic.TryGetValue(Item, T) then
      begin
        if (T.TransportID = TransportID) or
           (T.TransportID = TRANSPORT_BOTH) or
           (TransportID = TRANSPORT_BOTH) then
        begin
          ResultCode := 4;
          Break;
        end;
      end;
      T.TransportID := TransportID;
      T.InList := False;
      TransportsDic.AddOrSetValue(Item, T);
    end;

    if ResultCode > 0 then
      Break;

  end;
  if ResultCode > 0 then
  begin
    Result := False;
    sgTransports.Row := i;
    SelectTransports;
    case ResultCode of
      1: GoToInvalidOption(tsOther, Msg + TransStr('394'), edTransports);
      2: GoToInvalidOption(tsOther, Msg + TransStr('395'), edTransportsHandler);
      3: GoToInvalidOption(tsOther, Msg + ResultMsg, edTransports);
      4: GoToInvalidOption(tsOther, Msg + TransStr('399'), edTransports);
      5: GoToInvalidOption(tsOther, Msg + Format(TransStr('255'), ['|']), meHandlerParams);
    end;
  end;
end;

function TTcp.CheckHsTable: Boolean;
var
  Duplicate: Boolean;
  DirName, Msg, ResultMsg: string;
  i, j, ResultCode: Integer;
begin
  Result := True;
  ResultCode := 0;
  j := 0;
  Duplicate := False;
  if not edHsName.Enabled then
    Exit;
  Msg := TTabSheet(sgHs.GetParentComponent).Caption + ' - ' + lbHsName.Caption + BR + BR;
  for i := 1 to sgHs.RowCount - 1 do
  begin
    DirName := sgHs.Cells[HS_NAME, i];
    if DirName = '' then
    begin
      ResultCode := 1;
      Break;
    end;
    ResultMsg := CheckEditString(DirName, '_');
    if ResultMsg <> ''  then
    begin
      ResultCode := 3;
      Break;
    end;
    for j := 1 to sgHs.RowCount - 1 do
      if (i <> j) and (DirName = sgHs.Cells[HS_NAME, j]) then
      begin
        Duplicate := True;
        Break;
      end;
    if Duplicate then
    begin
      ResultCode := 2;
      Break;
    end;
  end;
  if ResultCode > 0 then
  begin
    Result := False;
    if Duplicate then
      sgHs.Row := j
    else
      sgHs.Row := i;
    SelectHs;
    case ResultCode of
      1: GoToInvalidOption(tsHs, Msg + TransStr('248'), edHsName);
      2: GoToInvalidOption(tsHs, Msg + TransStr('249'), edHsName);
      3: GoToInvalidOption(tsHs, Msg + ResultMsg, edHsName);
    end;
  end;
end;

function TTcp.CheckHsPorts: Boolean;
var
  Duplicate: Boolean;
  i, j, k, ResultCode: Integer;
  Msg: string;
  ParseStr: ArrOfStr;
begin
  ResultCode := 0;
  Result := True;
  Duplicate := False;
  if not sgHsPorts.Enabled then
    Exit;
  Msg := TTabSheet(sgHs.GetParentComponent).Caption + ' - ' + TransStr('250') + BR + BR;
  k := 0;
  for i := 1 to sgHs.RowCount - 1 do
  begin
    if (sgHs.Cells[HS_PORTS_DATA, i]) = '' then
    begin
      ResultCode := 1;
      Break;
    end;
    ParseStr := Explode('|', sgHs.Cells[HS_PORTS_DATA, i]);
    if Length(ParseStr) > 1 then
    begin
      for j := 0 to Length(ParseStr) - 1 do
      begin
        for k := j + 1 to Length(ParseStr) - 1 do
        begin
          if ParseStr[j] = ParseStr[k] then
          begin
            Duplicate := True;
            Break;
          end;
        end;
        if Duplicate then
          Break;
      end;
      if Duplicate then
      begin
        ResultCode := 2;
        Break;
      end;
    end;
  end;

  if ResultCode > 0 then
  begin
    Result := False;
    sgHs.Row := i;
    SelectHs;
    if Duplicate then
    begin
      sgHsPorts.Row := k + 1;
      SelectHsPorts;
    end;
    case ResultCode of
      1: GoToInvalidOption(tsHs, Msg + TransStr('251'));
      2: GoToInvalidOption(tsHs, Msg + TransStr('252'));
    end;
  end;
end;

function TTcp.CheckNetworkOptions: Boolean;
begin
  if (cbxServerMode.ItemIndex > SERVER_MODE_NONE) and (cbUseReachableAddresses.Checked or cbUseProxy.Checked or cbUseBridges.Checked) then
  begin
    Result := False;
    if ShowMsg(TransStr('261'), TransStr('324'), mtWarning, True) then
    begin
      cbUseReachableAddresses.Checked := False;
      cbUseProxy.Checked := False;
      cbUseBridges.Checked := False;
      ApplyOptions;
    end
    else
      GoToInvalidOption(tsNetwork);
  end
  else
    Result := True;
end;

function TTcp.RouterInNodesList(RouterID: string; IpStr: string; NodeType: TNodeType; SkipCodes: Boolean = False; CodeStr: string = ''; AddressType: TAddressType = atNone): Boolean;
var
  ParseStr: ArrOfStr;
  KeyStr: string;
  i,j: Integer;
begin
  Result := False;
  for i := 0 to 3 do
  begin
    if i < 3 then
    begin
      if SkipCodes and (i = 1) then
        Continue;
      case i of
        0: KeyStr := RouterID;
        1:
        begin
          if CodeStr = '' then
            KeyStr := CountryCodes[GetCountryValue(IpStr)]
          else
            KeyStr := CodeStr;
        end;
        2: KeyStr := IpStr;
      end;
      if NodesDic.ContainsKey(KeyStr) then
        Result := NodeType in NodesDic.Items[KeyStr];
    end
    else
    begin
      KeyStr := FindInRanges(IpStr, AddressType);
      if KeyStr <> '' then
      begin
        ParseStr := Explode(',', KeyStr);
        for j := 0 to Length(ParseStr) - 1 do
        begin
          if NodesDic.ContainsKey(ParseStr[j]) then
          begin
            Result := NodeType in NodesDic.Items[ParseStr[j]];
            if Result then
              Exit;
          end;
        end;
      end;
    end;
    if Result then
      Exit;
  end;
end;

function TTcp.CheckVanguards(Silent: Boolean = False): Boolean;
var
  Router: TPair<string, TRouterInfo>;
  NodesCount: Integer;

  function GetMinGuards: Integer;
  begin
    case cbxVanguardLayerType.ItemIndex of
      VG_L2: Result := L1_NUM_GUARDS + L2_NUM_GUARDS;
      VG_L3: Result := L1_NUM_GUARDS + L3_NUM_GUARDS;
      VG_L2_L3: Result := L1_NUM_GUARDS + L2_NUM_GUARDS + L3_NUM_GUARDS;
      else
        Result := L1_NUM_GUARDS;
    end;
  end;

  procedure ResetVanguards;
  begin
    if SupportVanguardsLite then
      cbxVanguardLayerType.ItemIndex := VG_AUTO
    else
      cbUseHiddenServiceVanguards.Checked := False;
  end;

begin
  Result := True;
  if cbUseHiddenServiceVanguards.Checked then
  begin
    NodesCount := 0;
    if RoutersDic.Count > 0 then
    begin
      for Router in RoutersDic do
      begin
        if (rfGuard in Router.Value.Flags) then
        begin
          if RouterInNodesList(Router.Key, Router.Value.IPv4, ntEntry, True) then
          begin
            if not RouterInNodesList(Router.Key, Router.Value.IPv4, ntExclude) then
              Inc(NodesCount);
          end;
        end;
      end;
    end;

    if ((NodesCount < GetMinGuards) and (RoutersDic.Count > 0)) and (cbxVanguardLayerType.ItemIndex <> VG_AUTO) then
    begin
      if Silent then
        ResetVanguards
      else
      begin
        Result := False;
        if ShowMsg(Format(TransStr('161'), [GetMinGuards, NodesCount]), TransStr('324'), mtWarning, True) then
        begin
          ResetVanguards;
          ApplyOptions;
        end
        else
          GoToInvalidOption(tsLists);
      end;
    end
    else
    begin
      if cbxVanguardLayerType.ItemIndex = VG_AUTO then
        ResetVanguards;
    end;
  end;
end;

procedure TTcp.SetNodes(FilterEntry, FilterMiddle, FilterExit, FavoritesEntry, FavoritesMiddle, FavoritesExit, ExcludeNodes: string);
var
  Vanguards: string;
  ParseStr: ArrOfStr;
  i: Integer;
begin
  DeleteTorConfig('HSLayer2Nodes');
  DeleteTorConfig('HSLayer3Nodes');
  DeleteTorConfig('VanguardsLiteEnabled');
  if cbUseHiddenServiceVanguards.Checked then
  begin
    ParseStr := Explode(',', RemoveBrackets(FavoritesEntry));
    Vanguards := '';
    for i := 0 to Length(ParseStr) - 1 do
    begin
      if Length(ParseStr[i]) > 2 then
        Vanguards := Vanguards + ',' + ParseStr[i];
    end;
    Delete(Vanguards, 1, 1);

    case cbxVanguardLayerType.ItemIndex of
      VG_L2: SetTorConfig('HSLayer2Nodes', Vanguards);
      VG_L3: SetTorConfig('HSLayer3Nodes', Vanguards);
      VG_L2_L3:
      begin
        SetTorConfig('HSLayer2Nodes', Vanguards);
        SetTorConfig('HSLayer3Nodes', Vanguards);
      end;
    end;
  end
  else
  begin
    if SupportVanguardsLite then
      SetTorConfig('VanguardsLiteEnabled', '0');
  end;

  case cbxFilterMode.ItemIndex of
    FILTER_MODE_NONE:
    begin
      DeleteTorConfig('EntryNodes');
      DeleteTorConfig('MiddleNodes');
      DeleteTorConfig('ExitNodes');
    end;
    FILTER_MODE_COUNTRIES:
    begin
      if cbUseBridges.Checked then
        DeleteTorConfig('EntryNodes')
      else
        SetTorConfig('EntryNodes', FilterEntry);
      SetTorConfig('MiddleNodes', FilterMiddle);
      SetTorConfig('ExitNodes', FilterExit);
    end;
    FILTER_MODE_FAVORITES:
    begin
      if miReplaceDisabledFavoritesWithCountries.Checked and
        ((FavoritesEntry = '') or (lbFavoritesEntry.HelpContext = 0)) then
        FavoritesEntry := FilterEntry;
      if miReplaceDisabledFavoritesWithCountries.Checked and
        ((FavoritesMiddle = '') or (lbFavoritesMiddle.HelpContext = 0)) then
        FavoritesMiddle := FilterMiddle;
      if miReplaceDisabledFavoritesWithCountries.Checked and
        ((FavoritesExit = '') or (lbFavoritesExit.HelpContext = 0)) then
        FavoritesExit := FilterExit;

      if cbUseBridges.Checked then
        DeleteTorConfig('EntryNodes')
      else
        SetTorConfig('EntryNodes', FavoritesEntry);
      SetTorConfig('MiddleNodes', FavoritesMiddle);
      SetTorConfig('ExitNodes', FavoritesExit);
    end;
  end;
  if lbExcludeNodes.HelpContext = 1 then
    SetTorConfig('ExcludeNodes', ExcludeNodes)
  else
    DeleteTorConfig('ExcludeNodes');
  DeleteTorConfig('ExcludeExitNodes');
end;

procedure TTcp.ApplyOptions(AutoResolveErrors: Boolean = False);
var
  ini, inidef: TMemIniFile;
  AutoSelNodesType: Integer;
  Item: TPair<string, TFilterInfo>;
  NodeItem: TPair<string, TNodeTypes>;
  Temp: string;
  FilterEntry, FilterMiddle, FilterExit, ExcludeNodes, NodeStr: string;
  FavoritesEntry, FavoritesMiddle, FavoritesExit: string;
  StyleName: string;
begin
  if (cbxAuthMetod.ItemIndex = 1) and (CheckEditString(edControlPassword.Text, '', True, lbControlPassword.Caption, edControlPassword) <> '') then
    Exit;
  if (cbxServerMode.ItemIndex > SERVER_MODE_NONE) and (CheckEditString(edNickname.Text, '', True, lbNickname.Caption, edNickname) <> '') then
    Exit;
  if not CheckVanguards(AutoResolveErrors) then
    Exit;
  if not CheckNetworkOptions then
    Exit;
  if not CheckHsTable then
    Exit;
  if not CheckHsPorts then
    Exit;
  if not CheckTransports then
    Exit;
  LoadTorConfig;
  CheckRequiredFiles(True);
  ini := TMemIniFile.Create(UserConfigFile, TEncoding.UTF8);
  try
    if cbxLanguage.ItemIndex <> cbxLanguage.Tag then
      Translate(cbxLanguage.Text);

    if cbxThemes.ItemIndex = 0 then
      StyleName := 'Windows'
    else
      StyleName := cbxThemes.Text;

    if (ConnectState = 2) and (AutoScanStage = 0) and not ConsensusUpdated and
      (GetSettings('Scanner', 'AutoScanNewNodes', True, ini) = False) then
    begin
      if Tcp.cbAutoScanNewNodes.Checked and
        (Tcp.cbEnablePingMeasure.Checked or Tcp.cbEnableDetectAliveNodes.Checked) then
          AutoScanStage := 1;
    end;

    if cbUseNetworkCache.Checked and not GetSettings('Main', 'UseNetworkCache', True, ini) then
      SaveNetworkCache;

    SetSettings('Main', 'Language', Integer(cbxLanguage.Items.Objects[cbxLanguage.ItemIndex]), ini);
    SetSettings('Main', 'Theme', StyleName, ini);
    SetSettings('Main', 'LastPlace', LastPlace, ini);
    SetSettings('Main', 'OptionsPage', pcOptions.TabIndex, ini);

    SetSettings('Main', cbConnectOnStartup, ini);
    SetSettings('Main', cbRestartOnControlFail, ini);
    SetSettings('Main', cbMinimizeToTray, ini);
    SetSettings('Main', cbxMinimizeOnEvent, ini);
    SetSettings('Main', cbShowBalloonHint, ini);
    SetSettings('Main', cbShowBalloonOnlyWhenHide, ini);
    SetSettings('Main', cbStayOnTop, ini);
    SetSettings('Main', cbNoDesktopBorders, ini);
    SetSettings('Main', cbNoDesktopBordersOnlyEnlarged, ini);
    SetSettings('Main', cbHideIPv6Addreses, ini);
    SetSettings('Main', cbUseOpenDNS, ini);
    SetSettings('Main', cbUseOpenDNSOnlyWhenUnknown, ini);
    SetSettings('Main', cbRememberEnlargedPosition, ini);
    SetSettings('Main', cbClearPreviousSearchQuery, ini);
    SetSettings('Main', cbUseNetworkCache, ini);
    SetSettings('Main', cbxTrayIconType, ini);
    SetSettings('Main', 'TrayIconFile', TrayIconFile, ini);

    SetSettings('Scanner', cbEnablePingMeasure, ini);
    SetSettings('Scanner', cbEnableDetectAliveNodes, ini);
    SetSettings('Scanner', cbAutoScanNewNodes, ini);
    SetSettings('Scanner', udScanPortTimeout, ini);
    SetSettings('Scanner', udScanPingTimeout, ini);
    SetSettings('Scanner', udScanPortionTimeout, ini);
    SetSettings('Scanner', udDelayBetweenAttempts, ini);
    SetSettings('Scanner', udScanPingAttempts, ini);
    SetSettings('Scanner', udScanPortAttempts, ini);
    SetSettings('Scanner', udScanMaxThread, ini);
    SetSettings('Scanner', udScanPortionSize, ini);
    SetSettings('Scanner', udFullScanInterval, ini);
    SetSettings('Scanner', udPartialScanInterval, ini);
    SetSettings('Scanner', udPartialScansCounts, ini);
    SetSettings('Scanner', cbxAutoScanType, ini);
    SetSettings('Scanner', cbxAutoSelRoutersAfterScanType, ini);

    SetSettings('AutoSelNodes', udAutoSelEntryCount, ini);
    SetSettings('AutoSelNodes', udAutoSelMiddleCount, ini);
    SetSettings('AutoSelNodes', udAutoSelExitCount, ini);
    SetSettings('AutoSelNodes', udAutoSelFallbackDirCount, ini);
    SetSettings('AutoSelNodes', udAutoSelMinWeight, ini);
    SetSettings('AutoSelNodes', udAutoSelMaxPing, ini);
    SetSettings('AutoSelNodes', cbxAutoSelPriority, ini);
    SetSettings('AutoSelNodes', cbAutoSelFallbackDirNoLimit, ini);
    SetSettings('AutoSelNodes', cbAutoSelStableOnly, ini);
    SetSettings('AutoSelNodes', cbAutoSelFilterCountriesOnly, ini);
    SetSettings('AutoSelNodes', cbAutoSelUniqueNodes, ini);
    SetSettings('AutoSelNodes', cbAutoSelNodesWithPingOnly, ini);
    SetSettings('AutoSelNodes', cbAutoSelMiddleNodesWithoutDir, ini);

    AutoSelNodesType := 0;
    SetMaskData(AutoSelNodesType, cbAutoSelEntryEnabled);
    SetMaskData(AutoSelNodesType, cbAutoSelMiddleEnabled);
    SetMaskData(AutoSelNodesType, cbAutoSelExitEnabled);
    SetMaskData(AutoSelNodesType, cbAutoSelFallbackDirEnabled);
    SetSettings('AutoSelNodes', 'AutoSelNodesType', AutoSelNodesType, ini);

    SetDesktopPosition(Tcp.Left, Tcp.Top);
    SetSettings('Main', 'FormPosition', GetFormPositionStr, ini);
    SetSettings('Main', 'SortListData',
      IntToStr(meBridges.SortType) + ',' +
      IntToStr(meMyFamily.SortType) + ',' +
      IntToStr(meTrackHostExits.SortType) + ',' +
      IntToStr(meNodesList.SortType) + ',' +
      IntToStr(meFallbackDirs.SortType), ini
    );
    edControlPassword.Hint := GetSettings('Main', 'HashedControlPassword', '', ini);
    if cbxAuthMetod.ItemIndex = 1 then
    begin
      if edControlPassword.Text <> '' then
      begin
        if (edControlPassword.Text <> Decrypt(ControlPassword, 'True')) or (edControlPassword.Hint = '') then
        begin
          ControlPassword := Crypt(edControlPassword.Text, 'True');
          Temp := GetPasswordHash(edControlPassword.Text);
          SetTorConfig('HashedControlPassword', Temp);
          SetSettings('Main', 'HashedControlPassword', Temp, ini);
          ShowBalloon(TransStr('253'));
        end
        else
          SetTorConfig('HashedControlPassword', edControlPassword.Hint);
      end
      else
        cbxAuthMetod.ItemIndex := 0;
    end;
    if cbxAuthMetod.ItemIndex = 0 then
    begin
      SetTorConfig('CookieAuthentication', '1');
      if edControlPassword.Text <> '' then
        SetSettings('Main', 'HashedControlPassword', edControlPassword.Hint, ini)
      else
      begin
        ControlPassword := '';
        SetSettings('Main', 'HashedControlPassword', '', ini);
      end;
      DeleteTorConfig('HashedControlPassword');
    end
    else
      DeleteTorConfig('CookieAuthentication');
    SetSettings('Main', 'ControlPassword', ControlPassword, ini);
    CheckAuthMetodContols;

    SetTorConfig('Log', LogLevels[cbxLogLevel.ItemIndex] + ' stdout');

    SetTorConfig('SafeLogging', IntToStr(Integer(sbSafeLogging.Down)));
    SetTorConfig('MaxCircuitDirtiness', IntToStr(udMaxCircuitDirtiness.Position));
    SetTorConfig('SocksTimeout', IntToStr(udSocksTimeout.Position));
    SetTorConfig('CircuitBuildTimeout', IntToStr(udCircuitBuildTimeout.Position));
    SetTorConfig('MaxClientCircuitsPending', IntToStr(udMaxClientCircuitsPending.Position));
    SetTorConfig('LearnCircuitBuildTimeout', IntToStr(Integer(cbLearnCircuitBuildTimeout.Checked)));
    SetTorConfig('EnforceDistinctSubnets', IntToStr(Integer(cbEnforceDistinctSubnets.Checked)));
    SetTorConfig('StrictNodes', IntToStr(Integer(not cbStrictNodes.Checked)));
    SetTorConfig('NewCircuitPeriod', IntToStr(udNewCircuitPeriod.Position));
    SetTorConfig('AvoidDiskWrites', IntToStr(Integer(cbAvoidDiskWrites.Checked)));

    UpdateUsedProxyTypes(ini);
    GetLocalInterfaces(cbxSOCKSHost);
    GetLocalInterfaces(cbxHTTPTunnelHost);
    CheckSimilarPorts;
    if UsedProxyType in [ptSocks, ptBoth] then
      SetTorConfig('SOCKSPort', FormatHost(cbxSOCKSHost.Text) + ':' + IntToStr(udSOCKSPort.Position) + cbxSOCKSHost.Hint)
    else
      SetTorConfig('SOCKSPort', '0' + cbxSOCKSHost.Hint);
    if UsedProxyType in [ptHttp, ptBoth] then
      SetTorConfig('HTTPTunnelPort', FormatHost(cbxHTTPTunnelHost.Text) + ':' + IntToStr(udHTTPTunnelPort.Position) + cbxHTTPTunnelHost.Hint)
    else
      SetTorConfig('HTTPTunnelPort', '0' + cbxHTTPTunnelHost.Hint);
    SetSettings('Network', cbxSOCKSHost, ini, False, True);
    SetSettings('Network', udSOCKSPort, ini);
    SetSettings('Network', cbxHTTPTunnelHost, ini, False, True);
    SetSettings('Network', udHTTPTunnelPort, ini);
    SetTorConfig('ControlPort', IntToStr(udControlPort.Position));

    SaveReachableAddresses(ini);
    SaveProxyData(ini);

    Temp := GetFileID(DefaultsFile);
    if DefaultsFileID <> Temp then
    begin
      inidef := TMemIniFile.Create(DefaultsFile, TEncoding.UTF8);
      try
        if cbxBridgesType.ItemIndex <> BRIDGES_TYPE_FILE then
          LoadBuiltinBridges(inidef, True, True, cbxBridgesList.Text);
        if cbxFallbackDirsType.ItemIndex = FALLBACK_TYPE_BUILTIN then
          LoadFallbackDirs(inidef, True);
        LoadUserOverrides(inidef);
      finally
        inidef.Free;
      end;
      DefaultsFileID := Temp;
    end;
    DeleteTorConfig('DisableNetwork');
    SaveFallbackDirsData(ini);
    SaveBridgesData(ini);

    for Item in FilterDic do
    begin
      if ntEntry in Item.Value.Data then
        FilterEntry := FilterEntry + ',{' + Item.Key + '}';
      if ntMiddle in Item.Value.Data then
        FilterMiddle := FilterMiddle + ',{' + Item.Key + '}';
      if ntExit in Item.Value.Data then
        FilterExit := FilterExit + ',{' + Item.Key + '}';
    end;
    Delete(FilterEntry, 1, 1);
    Delete(FilterMiddle, 1, 1);
    Delete(FilterExit, 1, 1);
    SetSettings('Filter', 'EntryNodes', FilterEntry, ini);
    SetSettings('Filter', 'MiddleNodes', FilterMiddle, ini);
    SetSettings('Filter', 'ExitNodes', FilterExit, ini);

    for NodeItem in NodesDic do
    begin
      NodeStr := NodeItem.Key;
      if FilterDic.ContainsKey(NodeStr) then
        NodeStr := '{' + NodeStr + '}';
      if ntEntry in NodeItem.Value then
        FavoritesEntry := FavoritesEntry + ',' + NodeStr;
      if ntMiddle in NodeItem.Value then
        FavoritesMiddle := FavoritesMiddle + ',' + NodeStr;
      if ntExit in NodeItem.Value then
        FavoritesExit := FavoritesExit + ',' + NodeStr;
      if ntExclude in NodeItem.Value then
        ExcludeNodes := ExcludeNodes + ',' + NodeStr;
    end;
    Delete(FavoritesEntry, 1, 1);
    Delete(FavoritesMiddle, 1, 1);
    Delete(FavoritesExit, 1, 1);
    Delete(ExcludeNodes, 1, 1);

    CheckFilterMode;
    CheckFavoritesState;
    SetNodes(FilterEntry, FilterMiddle, FilterExit, FavoritesEntry, FavoritesMiddle, FavoritesExit, ExcludeNodes);

    SetSettings('Routers', 'EntryNodes', FavoritesEntry, ini);
    SetSettings('Routers', 'MiddleNodes', FavoritesMiddle, ini);
    SetSettings('Routers', 'ExitNodes', FavoritesExit, ini);
    SetSettings('Routers', 'ExcludeNodes', ExcludeNodes, ini);
    SetSettings('Routers', 'CurrentFilter', LastRoutersFilter, ini);

    SetSettings('Lists', 'UseFavoritesEntry', lbFavoritesEntry.HelpContext, ini);
    SetSettings('Lists', 'UseFavoritesMiddle', lbFavoritesMiddle.HelpContext, ini);
    SetSettings('Lists', 'UseFavoritesExit', lbFavoritesExit.HelpContext, ini);
    SetSettings('Lists', 'UseExcludeNodes', lbExcludeNodes.HelpContext, ini);
    SetSettings('Lists', cbxNodesListType, ini);

    if SupportVanguardsLite or
      (not SupportVanguardsLite and (cbxVanguardLayerType.ItemIndex <> VG_AUTO)) then
        SetSettings('Lists', cbUseHiddenServiceVanguards, ini);
    SetSettings('Lists', cbxVanguardLayerType, ini);

    SetSettings('Filter', cbxFilterMode, ini);
    SetSettings('Filter', miReplaceDisabledFavoritesWithCountries, ini);

    SetSettings('Status', 'TotalDL', TotalDL, ini);
    SetSettings('Status', 'TotalUL', TotalUL, ini);
    LastSaveStats := DateTimeToUnix(Now);
    TotalsNeedSave := False;

    UpdateSystemInfo;
    SaveServerOptions(ini);
    SaveTransportsData(ini, False);
    SavePaddingOptions(ini);

    GetLocalInterfaces(cbxHsAddress);
    SaveHiddenServices(ini);
    SaveTrackHostExits(ini);

    CheckCachedFiles;
    CheckStatusControls;

    OptionsLocked := False;
    EnableOptionButtons(False);
    if ConsensusUpdated then
      LoadConsensus
    else
    begin
      if cbxLanguage.ItemIndex <> cbxLanguage.Tag then
      begin
        LoadRoutersCountries;
        ShowFilter;
        ShowRouters;
        if ConnectState = 0 then
          ShowCircuits;
      end
      else
      begin
        if RoutersUpdated or BridgesUpdated or FallbackDirsUpdated then
          ShowRouters;
      end;
    end;
    BridgesUpdated := False;
    FallbackDirsUpdated := False;

    if cbxLanguage.ItemIndex <> cbxLanguage.Tag then
      cbxLanguage.Tag := cbxLanguage.ItemIndex;

    UpdateOptionsAfterRoutersUpdate;

    SaveTorConfig;
    if ConnectState <> 0 then
    begin
      SendCommand('SIGNAL RELOAD');
      SendDataThroughProxy;
    end;
    if OpenDNSUpdated then
    begin
      OpenDNSUpdated := False;
      GetServerInfo;
    end;
  finally
    UpdateConfigFile(ini);
  end;
end;

procedure TTcp.CheckCachedFiles;
begin
  if ConnectState = 0 then
  begin
    if ((cbxServerMode.ItemIndex = SERVER_MODE_NONE) and not cbUseBridges.checked) or
       ((cbxServerMode.ItemIndex > SERVER_MODE_NONE) and not cbDirCache.Checked)  then
    begin
      RenameFile(UserDir + 'cached-consensus', UserDir + 'cached-consensus.tmp');
      RenameFile(UserDir + 'cached-descriptors', UserDir + 'cached-descriptors.tmp');
      RenameFile(UserDir + 'cached-descriptors.new', UserDir + 'cached-descriptors.new.tmp');
    end
    else
    begin
      RenameFile(UserDir + 'cached-consensus.tmp', UserDir + 'cached-consensus');
      RenameFile(UserDir + 'cached-descriptors.tmp', UserDir + 'cached-descriptors');
      RenameFile(UserDir + 'cached-descriptors.new.tmp', UserDir + 'cached-descriptors.new');
      if RoutersDic.Count > 0 then
        ConsensusUpdated := True;
    end;
  end;
end;

procedure TTcp.ClearFilter(NodeType: TNodeType; Silent: Boolean = True);
var
  Item: TPair<string, TFilterInfo>;
  Filter: TFilterInfo;
begin
  for Item in FilterDic do
  begin
    Filter := Item.Value;
    case NodeType of
      ntNone: Filter.Data := [];
      ntExclude: NodesDic.Remove(CountryCodes[Filter.cc]);
      else
        Exclude(Filter.Data, NodeType);
    end;
    if NodeType <> ntExclude then
      FilterDic.AddOrSetValue(Item.Key, Filter);
  end;

  if not Silent then
  begin
    CalculateFilterNodes;
    FilterUpdated := True;
    if NodeType = ntExclude then
      ExcludeUpdated := True;
    ShowFilter;
    EnableOptionButtons;
  end;
end;

procedure TTcp.ClearRouters(NodeTypes: TNodeTypes = []; Silent: Boolean = True);
var
  Item: TPair<string, TNodeTypes>;
  Data, ExcludeData: TNodeTypes;
begin
  if NodeTypes = [] then
  begin
    NodesDic.Clear;
    CidrsDic.Clear;
  end
  else
  begin
    if NodeTypes = [ntFavorites] then
      ExcludeData := [ntEntry, ntMiddle, ntExit]
    else
      ExcludeData := NodeTypes;
    for Item in NodesDic do
    begin
      Data := Item.Value;
      Data := Data - ExcludeData;
      NodesDic.AddOrSetValue(Item.Key, Data);
    end;
  end;
  if not Silent then
  begin
    CalculateTotalNodes(False);
    ShowRouters;
    RoutersUpdated := True;
    if NodeTypes = [ntExclude] then
      FilterUpdated := True;
    EnableOptionButtons;
  end;
end;

procedure TTcp.miClearRoutersAbsentClick(Sender: TObject);
var
  IpList: TDictionary<string, TAddressType>;
  NodeItem: TPair<string, TNodeTypes>;
  RouterItem: TPair<string, TRouterInfo>;
  ListItem: TPair<string, TAddressType>;
  DeleteExcludeNodes, Search: Boolean;
  CidrInfo: TCidrInfo;
  AddressType: TAddressType;

  procedure SetNodesData;
  begin
    if DeleteExcludeNodes or not (ntExclude in NodeItem.Value) then
      NodesDic.AddOrSetValue(NodeItem.Key, [])
    else
      NodesDic.AddOrSetValue(NodeItem.Key, [ntExclude]);
  end;

begin
  if (InfoStage > 0) or Assigned(Consensus) or Assigned(Descriptors) or (RoutersDic.Count = 0) then
    Exit;
  DeleteExcludeNodes := not ShowMsg(TransStr('358'), '', mtQuestion, True);
  IpList := TDictionary<string, TAddressType>.Create;
  try
    for RouterItem in RoutersDic do
      IpList.AddOrSetValue(RouterItem.Value.IPv4, atIPv4Cidr);
    for NodeItem in NodesDic do
    begin
      if ValidHash(NodeItem.Key) then
      begin
        if not RoutersDic.ContainsKey(NodeItem.Key) then
          SetNodesData;
      end
      else
      begin
        AddressType := ValidAddress(NodeItem.Key, True, True);
        if AddressType <> atNone then
        begin
          if AddressType = atIPv4 then
          begin
            if not IpList.ContainsKey(NodeItem.Key) then
              SetNodesData;
          end
          else
          begin
            Search := False;
            CidrInfo := CidrStrToInfo(NodeItem.Key, AddressType);
            for ListItem in IpList do
            begin
              if IpInCidr(ListItem.Key, CidrInfo, ListItem.Value) then
              begin
                Search := True;
                Break;
              end;
            end;
            if not Search then
            begin
              CidrsDic.Remove(NodeItem.Key);
              SetNodesData;
            end;
          end;
        end
        else
        begin
          if GeoIpDic.Count > 0 then
          begin
            if FilterDic.ContainsKey(NodeItem.Key) then
            begin
              if CountryTotals[TOTAL_RELAYS][FilterDic.Items[NodeItem.Key].cc] = 0 then
                SetNodesData;
            end;
          end;
        end;
      end;
    end;
    CalculateTotalNodes(False);
    ShowRouters;
    FilterUpdated := True;
    RoutersUpdated := True;
    EnableOptionButtons;
  finally
    IpList.Free;
  end;
end;

procedure TTcp.miClearRoutersIncorrectClick(Sender: TObject);
var
  IpList: TDictionary<string, string>;
  UpdateList: TDictionary<string, Byte>;
  NodeItem: TPair<string, TNodeTypes>;
  RouterItem: TPair<string, TRouterInfo>;
  UpdateItem: TPair<string, Byte>;
  ConvertToHash: Boolean;
  RouterInfo: TRouterInfo;
  Ip, CountryCode: string;

  procedure CheckNode(NodeID: string; NodeTypes: TNodeTypes; HashID: string = '');
  var
    NodeIsChanged, NodeIsExcluded, NodeIsBridge: Boolean;
    Flags: TRouterFlags;
    Node, CountryCode: string;
  begin
    NodeIsChanged := False;
    NodeIsExcluded := False;

    if HashID = '' then
      Node := NodeID
    else
      Node := HashID;

    if RoutersDic.TryGetValue(Node, RouterInfo) then
    begin
      if NodesDic.ContainsKey(NodeID) then
      begin
        Flags := RouterInfo.Flags;
        NodeIsBridge := (NodeTypes <> [ntExclude]) and (rfBridge in Flags) and not (rfRelay in Flags);

        if GeoIpDic.Count > 0 then
        begin
          CountryCode := CountryCodes[GetCountryValue(RouterInfo.IPv4)];
          if NodesDic.ContainsKey(CountryCode) then
            NodeIsExcluded := ntExclude in NodesDic.Items[CountryCode];
        end;

        if NodeIsExcluded or NodeIsBridge then
          NodesDic.AddOrSetValue(NodeID, [])
        else
        begin
          if (ntEntry in NodeTypes) and not (rfGuard in Flags) then
          begin
            Exclude(NodeTypes, ntEntry);
            NodeIsChanged := True;
          end;
          if (ntExit in NodeTypes) and (not (rfExit in Flags) or (rfBadExit in Flags)) then
          begin
            Exclude(NodeTypes, ntExit);
            NodeIsChanged := True;
          end;
          if NodeIsChanged then
            NodesDic.AddOrSetValue(NodeID, NodeTypes);
        end;
      end;
    end;
  end;

  procedure CheckRanges(NodeIp: string; NodeTypes: TNodeTypes; HashID: string = '');
  var
    CidrItem: TPair<string, TCidrInfo>;
    NodeInfo: TNodeTypes;
    NodeID: string;
  begin
    if CidrsDic.Count > 0 then
    begin
      if HashID = '' then
        NodeID := NodeIp
      else
        NodeID := HashID;
      for CidrItem in CidrsDic do
      begin
        if IpInCidr(NodeIp, CidrItem.Value, atIPv4Cidr) then
        begin
          if NodesDic.TryGetValue(CidrItem.Key, NodeInfo) then
          begin
            if NodeTypes = [ntNone] then
              CheckNode(CidrItem.Key, NodeInfo, HashID)
            else
            begin
              if NodesDic.ContainsKey(NodeID) then
              begin
                if (ntExclude in NodeInfo) then
                begin
                  if NodeTypes <> [ntExclude] then
                    NodesDic.AddOrSetValue(NodeID, [])
                end
                else
                begin
                  if ntExclude in NodesDic.Items[NodeID] then
                    NodesDic.AddOrSetValue(CidrItem.Key, [])
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;

  procedure CheckIp(NodeIp: string; NodeTypes: TNodeTypes; HashID: string = '');
  var
    ParseStr: ArrOfStr;
    NodesList, CountryCode: string;
    i: Integer;
  begin

    if HashID <> '' then
    begin
      CheckRanges(NodeIp, NodeTypes, HashID);
      CheckNode(HashID, NodeTypes);
      Exit;
    end
    else
      CheckRanges(NodeIp, NodeTypes);

    if IpList.TryGetValue(NodeIp, NodesList) then
    begin
      ParseStr := Explode(',', NodesList);
      for i := 0 to Length(ParseStr) - 1 do
      begin
        if NodesDic.ContainsKey(ParseStr[i]) then
        begin
          CheckRanges(NodeIp, NodeTypes, ParseStr[i]);

          if (ntExclude in NodeTypes) and (NodesDic.Items[ParseStr[i]] <> [ntExclude]) then
            NodesDic.AddOrSetValue(ParseStr[i], [])
          else
            CheckNode(ParseStr[i], NodesDic.Items[ParseStr[i]]);

          if NodesDic.ContainsKey(NodeIp) then
          begin
            if NodesDic.Items[NodeIp] <> [ntExclude] then
            begin
              if (NodesDic.Items[ParseStr[i]] = [ntExclude]) then
                NodesDic.AddOrSetValue(NodeIp, [])
              else
                CheckNode(NodeIp, NodeTypes, ParseStr[i]);
            end;
          end;
        end
        else
          CheckNode(NodeIp, NodeTypes, ParseStr[i]);
      end;
    end
    else
    begin
      if NodesDic.ContainsKey(NodeIp) then
      begin
        if GeoIpDic.Count > 0 then
        begin
          CountryCode := CountryCodes[GetCountryValue(NodeIp)];
          if NodesDic.ContainsKey(CountryCode) then
          begin
            if ntExclude in NodesDic.Items[CountryCode] then
              NodesDic.AddOrSetValue(NodeIp, []);
          end;
        end;
      end;
    end;
  end;

  procedure CheckCountry(NodeIp, HashID: string);
  begin
    if GeoIpDic.Count > 0 then
    begin
      CountryCode := CountryCodes[GetCountryValue(NodeIp)];
      if NodesDic.ContainsKey(CountryCode) then
      begin
        if not (ntExclude in NodesDic.Items[CountryCode]) then
          CheckNode(CountryCode, NodesDic.Items[CountryCode], HashID);
      end;
    end;
  end;

  procedure CheckRangesNesting(RangeID: string; NodeTypes: TNodeTypes);
  var
    CidrItem: TPair<string, TCidrInfo>;
    CidrInfo: TCidrInfo;
    MinBits: Byte;
  begin
    if CidrsDic.Count > 1 then
    begin
      if CidrsDic.ContainsKey(RangeID) then
        CidrInfo := CidrsDic.Items[RangeID]
      else
        CidrInfo := CidrStrToInfo(RangeID, atIPv4Cidr);
      for CidrItem in CidrsDic do
      begin
        if RangeID <> CidrItem.Key then
        begin
          MinBits := Min(CidrInfo.Prefix, CidrItem.Value.Prefix);
          if (Copy(CidrInfo.Bits, 1, MinBits) = Copy(CidrItem.Value.Bits, 1, MinBits)) and
            (CidrInfo.Prefix > CidrItem.Value.Prefix) then
          begin
            if NodesDic.ContainsKey(CidrItem.Key) then
            begin
              if (ntExclude in NodesDic.Items[CidrItem.Key]) then
              begin
                if NodesDic.ContainsKey(RangeID) then
                  NodesDic.AddOrSetValue(RangeID, []);
              end
              else
              begin
                if (ntExclude in NodeTypes) then
                  NodesDic.AddOrSetValue(CidrItem.Key, [])
                else
                begin
                  if NodesDic.Items[CidrItem.Key] = NodeTypes then
                  begin
                    if NodesDic.ContainsKey(RangeID) then
                      NodesDic.AddOrSetValue(RangeID, []);
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;


  procedure ConvertNodesToHash(NodeIp, HashID: string);
  var
    CidrItem: TPair<string, TCidrInfo>;
    CountryCode: string;
    IgnoreExclude: Boolean;

    procedure UpdateNodes(NodeID: string);
    begin
      if NodesDic.ContainsKey(NodeID) then
      begin
        if NodesDic.ContainsKey(HashID) then
        begin
          if (ntExclude in NodesDic.Items[NodeID]) then
          begin
            if IgnoreExclude then
              Exit;
            NodesDic.AddOrSetValue(HashID, [ntExclude]);
          end
          else
          begin
            if NodesDic.Items[HashID] <> [ntExclude] then
              NodesDic.AddOrSetValue(HashID, NodesDic.Items[HashID] + NodesDic.Items[NodeID]);
          end;
        end
        else
        begin
          if IgnoreExclude and (ntExclude in NodesDic.Items[NodeID]) then
            Exit;
          NodesDic.AddOrSetValue(HashID, NodesDic.Items[NodeID]);
        end;
        UpdateList.AddOrSetValue(NodeID, 0);
      end;
    end;

  begin
    IgnoreExclude := miIgnoreConvertExcludeNodes.Checked;

    if miConvertIpNodes.Checked then
      UpdateNodes(NodeIp);
    if miConvertCidrNodes.Checked then
    begin
      if CidrsDic.Count > 0 then
      begin
        for CidrItem in CidrsDic do
        begin
          if IpInCidr(NodeIp, CidrItem.Value, atIPv4Cidr) then
            UpdateNodes(CidrItem.Key);
        end;
      end;
    end
    else
      CheckRanges(NodeIp, [ntNone], HashID);

    if miConvertCountryNodes.Checked then
    begin
      if GeoIpDic.Count > 0 then
      begin
        CountryCode := CountryCodes[GetCountryValue(NodeIp)];
        UpdateNodes(CountryCode);
      end;
    end
    else
      CheckCountry(NodeIp, HashID);
  end;

begin

  if (RoutersDic.Count = 0) or (InfoStage > 0) or Assigned(Consensus) or Assigned(Descriptors) then
    Exit;

  ConvertToHash := miEnableConvertNodesOnIncorrectClear.Checked;

  IpList := TDictionary<string, string>.Create;
  UpdateList := TDictionary<string, Byte>.Create;
  try
    for NodeItem in NodesDic do
    begin
      if (ntExclude in NodeItem.Value) and (NodeItem.Value <> [ntExclude]) then
        NodesDic.AddOrSetValue(NodeItem.Key, [ntExclude]);
      if Pos('/', NodeItem.Key) <> 0 then
        CheckRangesNesting(NodeItem.Key, NodeItem.Value)
    end;

    for RouterItem in RoutersDic do
    begin
      if IpList.ContainsKey(RouterItem.Value.IPv4) then
        IpList.AddOrSetValue(RouterItem.Value.IPv4, IpList.Items[RouterItem.Value.IPv4] + ',' + RouterItem.Key)
      else
        IpList.AddOrSetValue(RouterItem.Value.IPv4, RouterItem.Key);
      if ConvertToHash then
        ConvertNodesToHash(RouterItem.Value.IPv4, RouterItem.Key)
      else
      begin
        CheckCountry(RouterItem.Value.IPv4, RouterItem.Key);
        CheckRanges(RouterItem.Value.IPv4, [ntNone], RouterItem.Key);
      end;
    end;

    if ConvertToHash then
    begin
      for UpdateItem in UpdateList do
      begin
        if NodesDic.ContainsKey(UpdateItem.Key) then
        begin
          NodesDic.AddOrSetValue(UpdateItem.Key, []);
          if Pos('/', UpdateItem.Key) <> 0 then
            CidrsDic.Remove(UpdateItem.Key);
        end;
      end;
    end;

    for NodeItem in NodesDic do
    begin
      if NodeItem.Value <> [] then
      begin
        if RoutersDic.ContainsKey(NodeItem.Key) then
        begin
          Ip := RoutersDic.Items[NodeItem.Key].IPv4;
          if NodesDic.ContainsKey(Ip) then
            CheckIp(Ip, NodesDic.Items[Ip])
          else
            CheckIp(Ip, NodeItem.Value, NodeItem.Key);
        end
        else
        begin
          if ValidAddress(NodeItem.Key) = atIPv4 then
            CheckIp(NodeItem.Key, NodeItem.Value)
        end;
      end;
    end;
  finally
    IpList.Free;
    UpdateList.Free;
  end;

  CalculateTotalNodes(False);
  ShowRouters;
  FilterUpdated := True;
  RoutersUpdated := True;
  EnableOptionButtons;
end;

procedure TTcp.miClearServerCacheClick(Sender: TObject);
begin
  if not CheckCacheOpConfirmation(TMenuItem(Sender).Caption) then
    Exit;
  if TMenuItem(Sender).Enabled then
  begin
    DeleteFile(UserDir + 'cached-consensus');
    DeleteFile(UserDir + 'cached-descriptors');
    DeleteFile(UserDir + 'cached-descriptors.new');
    DeleteFile(UserDir + 'cached-descriptors.tmp');
    DeleteFile(UserDir + 'cached-consensus.tmp');
    DeleteFile(UserDir + 'cached-descriptors.new.tmp');
    DeleteDir(UserDir + 'diff-cache');
  end;
end;

procedure TTcp.miClearUnusedNetworkCacheClick(Sender: TObject);
var
  IpList: TDictionary<string, string>;
  DeleteList, BridgesList: TStringList;
  Router: TPair<string, TRouterInfo>;
  Item: TPair<string, TGeoIpInfo>;
  ListItem: TPair<string, string>;
  GeoIpInfo: TGeoIpInfo;
  Bridge: TBridge;
  Data: string;
  RouterPorts, IpPorts, ParseStr: ArrOfStr;
  i, j, Max, Index, Count, Find: Integer;

  procedure AddToIpList(IpStr, PortStr: string);
  var
    PortsList: string;
    i: Integer;
  begin
    if IpList.TryGetValue(IpStr, PortsList) then
    begin
      ParseStr := Explode(',', PortsList);
      for i := 0 to Length(ParseStr) - 1 do
      begin
        if ParseStr[i] = PortStr then
          Exit;
      end;
      IpList.AddOrSetValue(IpStr, PortsList + ',' + PortStr)
    end
    else
      IpList.AddOrSetValue(IpStr, PortStr);
  end;
begin
  if not CheckCacheOpConfirmation(TMenuItem(Sender).Caption) then
    Exit;
  DeleteList := TStringList.Create;
  BridgesList := TStringList.Create;
  IpList := TDictionary<string, string>.Create;
  try
    for Router in RoutersDic do
    begin
      AddToIpList(Router.Value.IPv4, IntToStr(Router.Value.Port));
      if Router.Value.IPv6 <> '' then
        AddToIpList(RemoveBrackets(Router.Value.IPv6, True), IntToStr(Router.Value.Port));
    end;

    BridgesList.Text := meBridges.Text;
    for i := 0 to BridgesList.Count - 1 do
    begin
      if TryParseBridge(BridgesList[i], Bridge) then
        AddToIpList(Bridge.Ip, IntToStr(Bridge.Port));
    end;

    for Item in GeoIpDic do
    begin
      if not IpList.ContainsKey(Item.Key) then
        DeleteList.Append(Item.Key);
    end;
    for i := 0 to DeleteList.Count - 1 do
      GeoIpDic.Remove(DeleteList[i]);

    for ListItem in IpList do
    begin
      if GeoIpDic.TryGetValue(ListItem.Key, GeoIpInfo) then
      begin
        if GeoIpInfo.ports <> '' then
        begin
          IpPorts := Explode('|', GeoIpInfo.ports);
          RouterPorts := Explode(',', ListItem.Value);
          Max := Length(RouterPorts);
          Find := 0;
          Index := -1;
          for i := 0 to Length(IpPorts) - 1 do
          begin
            Count := 0;
            for j := 0 to Length(RouterPorts) - 1 do
            begin
              if Pos(RouterPorts[j] + ':', IpPorts[i]) = 1 then
              begin
                RouterPorts[j] := '';
                Index := i;
                Inc(Count);
                Inc(Find);
              end;
              if (j = Max - 1) and (Count = 0) then
                IpPorts[i] := '';
            end;
            if Find = Max then
              Break;
          end;
          Data := '';
          if Index > -1 then
          begin
            for j := 0 to Index do
            begin
              if IpPorts[j] <> '' then
                Data := Data + '|' + IpPorts[j];
            end;
            Delete(Data, 1, 1);
          end;
          GeoIpInfo.ports := Data;
          GeoIpDic.AddOrSetValue(ListItem.Key, GeoIpInfo);
        end;
      end;
    end;
  finally
    IpList.Free;
    BridgesList.Free;
    DeleteList.Free;
  end;
  SaveNetworkCache;
end;

procedure TTcp.miConvertCidrNodesClick(Sender: TObject);
begin
  SetConfigBoolean('Routers', 'ConvertCidrNodes', miConvertCidrNodes.Checked);
end;

procedure TTcp.miConvertCountryNodesClick(Sender: TObject);
begin
  SetConfigBoolean('Routers', 'ConvertCountryNodes', miConvertCountryNodes.Checked);
end;

procedure TTcp.miConvertIpNodesClick(Sender: TObject);
begin
  SetConfigBoolean('Routers', 'ConvertIpNodes', miConvertIpNodes.Checked);
end;

procedure TTcp.miExcludeBridgesWhenCountingClick(Sender: TObject);
begin
  LoadFilterTotals;
  LoadRoutersCountries;
  ShowFilter;
  SetConfigBoolean('Filter', 'ExcludeBridgesWhenCounting', miExcludeBridgesWhenCounting.Checked);
end;

procedure TTcp.miIgnoreConvertExcludeNodesClick(Sender: TObject);
begin
  SetConfigBoolean('Routers', 'IgnoreConvertExcludeNodes', miIgnoreConvertExcludeNodes.Checked);
end;

procedure TTcp.ClearFilterClick(Sender: TObject);
begin
  ClearFilter(TNodeType(TMenuItem(Sender).Tag), False);
end;

procedure TTcp.ClearRoutersClick(Sender: TObject);
var
  NodeTypes: TNodeTypes;
begin
  NodeTypes := [];
  Include(NodeTypes, TNodeType(TMenuItem(Sender).Tag));
  ClearRouters(NodeTypes, False);
end;

procedure TTcp.cbxFallbackDirsTypeChange(Sender: TObject);
begin
  UpdateFallbackDirControls;
end;

procedure TTcp.cbxFallbackDirsTypeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) and (meFallbackDirs.Lines.Count > 0) and meFallbackDirs.CanFocus then
    meFallbackDirs.SetFocus;
end;

procedure TTcp.miWriteLogFileClick(Sender: TObject);
begin
  SetConfigBoolean('Log', 'WriteLogFile', miWriteLogFile.Checked);
end;

procedure TTcp.FilterDeleteClick(Sender: TObject);
var
  ini: TMemIniFile;
  TemplateName, Temp: string;
begin
  TemplateName := TMenuItem(Sender).Caption;
  if TemplateName = TransStr('264') then
    Temp := ''
  else
    Temp := TransStr('366') + ' ';

  if ShowMsg(Format(TransStr('263'), [Temp, TemplateName]), '', mtQuestion, True) then
  begin
    ini := TMemIniFile.Create(UserConfigFile, TEncoding.UTF8);
    try
      if TMenuItem(Sender).Tag = 0 then
        ini.EraseSection('Templates')
      else
        ini.DeleteKey('Templates', IntToStr(TMenuItem(Sender).Tag));
    finally
      UpdateConfigFile(ini);
    end;
    ShowBalloon(Format(TransStr('365'), [TemplateName]));
  end;
end;

procedure TTcp.FilterLoadClick(Sender: TObject);
var
  ParseStr: ArrOfStr;
  FUpdated, RUpdated, ImmediateApplyOptions, IgnoreSettings: Boolean;
  EmptyCountries, EmptyFavorites, EmptyExcludes: Boolean;
  LoadCountries, LoadFavorites, LoadExcludes: Boolean;
  ini: TMemIniFile;
  n: Integer;
begin
  ImmediateApplyOptions := TMenuItem(Sender).Hint = 'ApplyOptions';
  if ImmediateApplyOptions then
  begin
    if not CheckCacheOpConfirmation(TransStr('286') + ': ' + TMenuItem(Sender).Caption) then
      Exit;
  end;
  ini := TMemIniFile.Create(UserConfigFile, TEncoding.UTF8);
  try
    ParseStr := Explode(';', GetSettings('Templates', IntToStr(TMenuItem(Sender).Tag), '', ini));
    n := Length(ParseStr);
    if n in [5,9] then
    begin
      if ValidInt(ParseStr[1], FILTER_MODE_NONE, FILTER_MODE_FAVORITES) then
        cbxFilterMode.ItemIndex := StrToInt(ParseStr[1])
      else
      begin
        ShowMsg(TransStr('254'), '', mtError);
        Exit;
      end;

      FUpdated := False;
      RUpdated := False;
      IgnoreSettings := miIgnoreTplLoadParamsOutsideTheFilter.Checked and ImmediateApplyOptions;
      EmptyCountries := ((ParseStr[2] = '') and (ParseStr[3] = '') and (ParseStr[4] = '')) and miNotLoadEmptyTplData.Checked;
      LoadCountries := (miTplLoadCountries.Checked or IgnoreSettings) and not EmptyCountries;

      if LoadCountries then
      begin
        ClearFilter(ntNone);
        GetNodes(ParseStr[2], ntEntry, False);
        GetNodes(ParseStr[3], ntMiddle, False);
        GetNodes(ParseStr[4], ntExit, False);
        FUpdated := True;
      end;

      if n = 9 then
      begin
        EmptyFavorites := ((ParseStr[5] = '') and (ParseStr[6] = '') and (ParseStr[7] = '')) and miNotLoadEmptyTplData.Checked;
        EmptyExcludes := (ParseStr[8] = '') and miNotLoadEmptyTplData.Checked;
        LoadFavorites := (miTplLoadRouters.Checked or IgnoreSettings) and not EmptyFavorites;
        LoadExcludes := (miTplLoadExcludes.Checked or IgnoreSettings) and not EmptyExcludes;

        if LoadFavorites then
        begin
          if LoadExcludes then
            ClearRouters
          else
            ClearRouters([ntFavorites]);
          GetNodes(ParseStr[5], ntEntry, True);
          GetNodes(ParseStr[6], ntMiddle, True);
          GetNodes(ParseStr[7], ntExit, True);
          RUpdated := True;
        end;

        if LoadExcludes then
        begin
          if not LoadFavorites then
            ClearRouters([ntExclude]);
          GetNodes(ParseStr[8], ntExclude, True);
          FUpdated := True;
          RUpdated := True;
        end;
      end;

      CalculateTotalNodes;
      CalculateFilterNodes;

      if FUpdated then
      begin
        FilterUpdated := True;
        ShowFilter;
        if not RUpdated then
        begin
          CheckFilterMode;
          UpdateRoutersAfterFilterUpdate;
        end;
      end;

      if RUpdated then
      begin
        RoutersUpdated := True;
        BridgesRecalculate := True;
        FallbackDirsRecalculate := True;
        UpdateOptionsAfterRoutersUpdate;
        ShowRouters;
        FilterUpdated := False;
      end;

      if FUpdated or RUpdated then
      begin
        if ImmediateApplyOptions and not OptionsChanged then
          ApplyOptions(True)
        else
          EnableOptionButtons;
        ShowBalloon(Format(TransStr('364'), [ParseStr[0]]));
      end;
    end
    else
      ShowMsg(TransStr('254'), '', mtError);
  finally
    ini.Free;
  end;
end;

procedure TTcp.CopyCaptionToClipboard(Sender: TObject);
begin
  if TMenuItem(Sender).Hint = '' then
    Clipboard.AsText := TMenuItem(Sender).Caption
  else
    Clipboard.AsText := TMenuItem(Sender).Hint;
end;

procedure TTcp.mnDetailsPopup(Sender: TObject);
var
  ini: TMemIniFile;
  SelectMenu: TMenuItem;
  i, TimeStampIndex, TemplateNameIndex: Integer;
  TimeStamp: Int64;
  TemplateList: TStringList;
  TemplateName, TimeStampStr, RouterID: string;
  Search, SingleRow: Boolean;
begin
  if SelNodeState then
  begin
    RouterID := ExitNodeID;
    SelectedNode := ExitNodeID;
    SingleRow := True;
  end
  else
  begin
    SelectRowPopup(sgCircuitInfo, mnDetails);
    SelectedNode := sgCircuitInfo.Cells[CIRC_INFO_ID, sgCircuitInfo.SelRow];
    SingleRow := sgCircuitInfo.Selection.Top = sgCircuitInfo.Selection.Bottom;
    if RoutersDic.ContainsKey(SelectedNode) then
      RouterID := ''
    else
      RouterID := SelectedNode;
  end;
  miDetailsExtractData.Hint := RouterID;

  Search := InsertExtractMenu(miDetailsExtractData, CONTROL_TYPE_GRID, GRID_CIRC_INFO, EXTRACT_PREVIEW);
  miDetailsUpdateIp.Enabled := ConnectState = 2;
  miDetailsExtractData.Enabled := Search;
  miDetailsAddToNodesList.Visible := Search and SingleRow and (ConnectState <> 1);
  miDetailsRelayInfo.Visible := Search and ShowRelayInfo(sgCircuitInfo);

  InsertNodesMenu(miDetailsAddToNodesList, SelectedNode);

  miDetailsSelectTemplate.Enabled := False;
  if ConnectState = 1 then
    Exit;
  miDetailsSelectTemplate.Clear;
  ini := TMemIniFile.Create(UserConfigFile, TEncoding.UTF8);
  try
    TemplateList := TStringList.Create;
    try
      ini.ReadSectionValues('Templates', TemplateList);
      if TemplateList.Count > 0 then
      begin
        miDetailsSelectTemplate.Enabled := True;
        for i := 0 to TemplateList.Count - 1 do
        begin
          TimeStampIndex := Pos('=', TemplateList[i]);
          TemplateNameIndex := Pos(';', TemplateList[i]);
          TimeStampStr := copy(TemplateList[i], 0,  TimeStampIndex - 1);
          if ValidInt(TimeStampStr, 0, MaxInt) then
            TimeStamp := StrToInt(TimeStampStr)
          else
          begin
            TimeStamp := DateTimeToUnix(Now);
            SetSettings('Templates', IntToStr(TimeStamp), SeparateRight(TemplateList[i], '='), ini);
            DeleteSettings('Templates', TimeStampStr, ini);
            UpdateConfigFile(ini);
          end;
          TemplateName := copy(TemplateList[i], TimeStampIndex + 1, (TemplateNameIndex - TimeStampIndex) - 1);
          SelectMenu := TMenuItem.Create(self);
          SelectMenu.Caption := TemplateName;
          SelectMenu.Tag := TimeStamp;
          SelectMenu.Hint := 'ApplyOptions';
          SelectMenu.OnClick := FilterLoadClick;
          miDetailsSelectTemplate.Add(SelectMenu);
        end;
      end;
    finally
      TemplateList.Free;
    end;
  finally
    ini.Free;
  end;
end;


procedure TTcp.SetSortMenuData(aSg: TStringGrid);
var
  SortMenu: TMenuItem;
  Fail: Boolean;
begin
  Fail := False;
  if not (aSg.SortCol in [0..aSg.ColCount - 1]) then
  begin
    aSg.SortCol := 0;
    Fail := True;
  end;
  if not (aSg.SortType in [SORT_ASC..SORT_DESC]) then
  begin
    aSg.SortType := SORT_DESC;
    Fail := True;
  end;
  case aSg.Tag of
    GRID_CIRCUITS: SortMenu := miCircuitsSort;
    GRID_STREAMS: SortMenu := miStreamsSort;
    GRID_STREAM_INFO: SortMenu := miStreamsInfoSort;
    else
      SortMenu := nil;
  end;
  if Assigned(SortMenu) then
  begin
    SortMenu.Items[aSg.SortCol].Checked := True;
    case aSg.SortType of
      SORT_ASC: SortMenu.ImageIndex := 9;
      SORT_DESC: SortMenu.ImageIndex := 10;
    end;
  end;
  if Fail then
    SaveSortData;
end;

procedure TTcp.mnCircuitsPopup(Sender: TObject);
begin
  SetSortMenuData(sgCircuits);
  SelectRowPopup(sgCircuits, mnCircuits);
  MenuSelectPrepare(miCircSA, miCircUA);

  miCircuitsDestroy.Enabled := ConnectState = 2;
  miCircuitsUpdateNow.Enabled := ConnectState = 2;
  if IsEmptyRow(sgCircuits, sgCircuits.SelRow) or (ConnectState <> 2) then
  begin
    miDestroyCircuit.Enabled := False;
    miDestroyStreams.Enabled := False;    
  end
  else
  begin
    miDestroyCircuit.Enabled := sgCircuits.Cells[CIRC_STREAMS, sgCircuits.SelRow] <> EXCLUDE_CHAR;
    miDestroyStreams.Enabled := ValidInt(sgCircuits.Cells[CIRC_STREAMS, sgCircuits.SelRow], 1, MaxInt);
  end;
  miDestroyExitCircuits.Enabled := ConnectState = 2;
  miShowCircuitsTraffic.Enabled := ConnectState <> 1;
  miShowStreamsTraffic.Enabled := ConnectState <> 1;
  miCircuitsSortDL.Enabled := miShowCircuitsTraffic.Checked;
  miCircuitsSortUL.Enabled := miShowCircuitsTraffic.Checked;
end;

procedure TTcp.SelectRowPopup(aSg: TStringGrid; aPopup: TPopupMenu);
var
  Origin: TPoint;
begin
  aSg.SelRow := aSg.Row;
  aSg.SelCol := aSg.Col;
  Origin := aSg.ClientOrigin;
  if ((Origin.X <> TPoint(aPopup.PopupPoint).X) and (Origin.Y <> TPoint(aPopup.PopupPoint).Y)) then
  begin
    if aSg.MovRow > 0 then
      aSg.SelRow := aSg.MovRow;
    if aSg.MovCol > -1 then
      aSg.SelCol := aSg.MovCol;
  end;
  if aSg.SelRow < 1 then
    aSg.SelRow := 0;
  if aSg.SelRow >= aSg.RowCount then
    aSg.SelRow := aSg.RowCount - 1;
  if aSg.SelCol < 0 then
    aSg.SelCol := 0;
  if aSg.SelCol >= aSg.ColCount then
    aSg.SelCol := aSg.ColCount - 1;
  if aSg.Selection.Top = aSg.Selection.Bottom then
    TUserGrid(aSg).MoveColRow(aSg.SelCol, aSg.SelRow, True, True);
end;

procedure TTcp.mnFilterPopup(Sender: TObject);
var
  ini: TMemIniFile;
  DeleteMenu, LoadMenu: TMenuItem;
  i, TimeStampIndex, TemplateNameIndex: Integer;
  TimeStamp: Int64;
  TemplateList: TStringList;
  TemplateName, TimeStampStr: string;
  State: Boolean;
begin
  SelectRowPopup(sgFilter, mnFilter);
  State := not IsEmptyGrid(sgFilter);
  miStatCountry.Visible := State;
  if State then
  begin
    miStatCountry.Caption := sgFilter.Cells[FILTER_NAME, sgFilter.SelRow];
    miStatCountry.ImageIndex := FilterDic.Items[LowerCase(sgFilter.Cells[FILTER_ID, sgFilter.SelRow])].cc;
  end
  else
  begin
    miStatCountry.Caption := '';
    miStatCountry.ImageIndex := -1;
  end;
  miStatRelays.Enabled := State;
  miStatGuards.Enabled := State;
  miStatExit.Enabled := State;
  miClearFilterEntry.Enabled := lbFilterEntry.Tag > 0;
  miClearFilterMiddle.Enabled := lbFilterMiddle.Tag > 0;
  miClearFilterExit.Enabled := lbFilterExit.Tag > 0;
  miClearFilterExclude.Enabled := lbFilterExclude.Tag > 0;
  miClearFilterAll.Enabled := miClearFilterEntry.Enabled or miClearFilterMiddle.Enabled or miClearFilterExit.Enabled;

  MenuSelectPrepare(miTplSaveSA, miTplSaveUA);
  MenuSelectPrepare(miTplLoadSA, miTplLoadUA);

  miLoadTemplate.Clear;
  miDeleteTemplate.Clear;
  ini := TMemIniFile.Create(UserConfigFile, TEncoding.UTF8);
  try
    TemplateList := TStringList.Create;
    try
      ini.ReadSectionValues('Templates', TemplateList);
      if TemplateList.Count > 0 then
      begin
        miDeleteTemplate.Enabled := True;
        miLoadTemplate.Enabled := True;
        for i := 0 to TemplateList.Count - 1 do
        begin
          TimeStampIndex := Pos('=', TemplateList[i]);
          TemplateNameIndex := Pos(';', TemplateList[i]);
          TimeStampStr := copy(TemplateList[i], 0,  TimeStampIndex - 1);
          if ValidInt(TimeStampStr, 0, MaxInt) then
            TimeStamp := StrToInt(TimeStampStr)
          else
          begin
            TimeStamp := DateTimeToUnix(Now);
            SetSettings('Templates', IntToStr(TimeStamp), SeparateRight(TemplateList[i], '='), ini);
            DeleteSettings('Templates', TimeStampStr, ini);
            UpdateConfigFile(ini);
          end;
          TemplateName := copy(TemplateList[i], TimeStampIndex + 1, (TemplateNameIndex - TimeStampIndex) - 1);
          LoadMenu := TMenuItem.Create(self);
          LoadMenu.Caption := TemplateName;
          LoadMenu.Tag := TimeStamp;
          LoadMenu.OnClick := FilterLoadClick;
          miLoadTemplate.Add(LoadMenu);

          DeleteMenu := TMenuItem.Create(self);
          DeleteMenu.Caption := TemplateName;
          if TemplateList.Count > 1 then
            DeleteMenu.Tag := TimeStamp
          else
            DeleteMenu.Tag := 0;
          DeleteMenu.OnClick := FilterDeleteClick;
          miDeleteTemplate.Add(DeleteMenu);
        end;
        DeleteMenu := TMenuItem.Create(self);
        DeleteMenu.Caption := '-';
        miDeleteTemplate.Add(DeleteMenu);

        DeleteMenu := TMenuItem.Create(self);
        DeleteMenu.Caption := TransStr('264');
        DeleteMenu.Tag := 0;
        DeleteMenu.OnClick := FilterDeleteClick;
        miDeleteTemplate.Add(DeleteMenu);
      end
      else
      begin
        miDeleteTemplate.Enabled := False;
        miLoadTemplate.Enabled := False;
      end;
    finally
      TemplateList.Free;
    end;
  finally
    ini.Free;
  end;
end;

procedure TTcp.mnHsPopup(Sender: TObject);
begin
  if tsHs.Tag = 1 then
  begin
    SelectRowPopup(sgHs, mnHs);
    if DirectoryExists(HsDir + sgHs.Cells[HS_NAME, sgHs.SelRow]) and (sgHs.Cells[HS_NAME, sgHs.SelRow] <> '') then
      miHsOpenDir.Visible := True
    else
      miHsOpenDir.Visible := False;

    if FileExists(HsDir + sgHs.Cells[HS_NAME, sgHs.SelRow] + '\hostname') then
    begin
      miHsCopyOnion.Caption := Trim(FileGetString(HsDir + sgHs.Cells[HS_NAME, sgHs.SelRow] + '\hostname'));
      miHsCopy.Visible := True;
    end
    else
      miHsCopy.Visible := False;

    if IsEmptyGrid(sgHs) then
    begin
      miHsDelete.Enabled := False;
      miHsClear.Enabled := False;
    end
    else
    begin
      miHsDelete.Enabled := True;
      miHsClear.Enabled := True;
    end;
    SelectHs;
  end;

  if tsHs.Tag = 2 then
  begin
    SelectRowPopup(sgHsPorts, mnHs);
    miHsOpenDir.Visible := False;
    miHsCopy.Visible := False;
    if IsEmptyGrid(sgHsPorts) then
    begin
      miHsDelete.Enabled := False;
      miHsClear.Enabled := False;
    end
    else
    begin
      miHsDelete.Enabled := True;
      miHsClear.Enabled := True;
    end;
    SelectHsPorts;
  end;
end;

procedure TTcp.mnLogPopup(Sender: TObject);
begin
  miOpenFileLog.Enabled := FileExists(TorLogFile);
  miOpenLogsFolder.Enabled := DirectoryExists(LogsDir);
  miLogSeparate.Enabled := miWriteLogFile.Checked;

  EditMenuEnableCheck(miLogCopy, emCopy);
  EditMenuEnableCheck(miLogSelectAll, emSelectAll);
  EditMenuEnableCheck(miLogClear, emClear);
  EditMenuEnableCheck(miLogFind, emFind);
end;

function TTcp.GetBridgeStr(RouterID: string; RouterInfo: TRouterInfo; UseIPv6: Boolean; Preview: Boolean = False): string;
var
  IpStr, HashStr: string;
  BridgeInfo: TBridgeInfo;
begin
  Result := '';
  if UseIPv6 then
    IpStr := RouterInfo.IPv6
  else
    IpStr := RouterInfo.IPv4;
  if IpStr = '' then
    Exit;
  if Preview then
    HashStr := Copy(RouterID, 1, 30) + '..'
  else
    HashStr := RouterID;
  if BridgesDic.TryGetValue(RouterID, BridgeInfo) then
  begin
    if BridgeInfo.Source <> '' then
    begin
      IpStr := BridgeInfo.Source;
      if UseIPv6 then
      begin
        if IpInRanges(IpStr, DocRanges) then
          Exit;
        IpStr := FormatHost(IpStr, False);
      end;
    end;
    Result := Trim(BridgeInfo.Transport + ' ' + IpStr + ':' + IntToStr(BridgeInfo.Router.Port) + ' ' + HashStr + ' ' + BridgeInfo.Params);
    if Preview and (BridgeInfo.Params <> '') then
      Result := Copy(Result, 1, Pos(HashStr, Result) + 29) + '...';
  end
  else
    Result := IpStr + ':' + IntToStr(RouterInfo.Port) + ' ' + HashStr;
end;

function TTcp.GetRouterStrFlags(Flags: TRouterFlags): string;
begin
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

function TTcp.GetRouterCsvData(RouterID: string; RouterInfo: TRouterInfo; Preview: Boolean = False): string;
var
  HashStr, IPv6Str, CountryStr, PingStr, FlagsStr, TypeStr, AliveStr: string;
  GeoIpInfo: TGeoIpInfo;
  PingData: Integer;
begin
  if GeoIpDic.TryGetValue(RouterInfo.IPv4, GeoIpInfo) then
  begin
    PingData := GeoIpInfo.ping;
    CountryStr := CountryCodes[GeoIpInfo.cc]
  end
  else
  begin
    PingData := 0;
    CountryStr := CountryCodes[DEFAULT_COUNTRY_ID];
  end;
  if PingData > 0 then
    PingStr := IntToStr(PingData)
  else
    PingStr := NONE_CHAR;
  if Preview then
  begin
    HashStr := Copy(RouterID, 1, 10) + '..';
    IPv6Str := '';
    PingStr := PingStr + '..';
    TypeStr := '';
    AliveStr := '';
    FlagsStr := '';
  end
  else
  begin
    HashStr := RouterID;
    if FormatIPv6OnExtract then
      IPv6Str := RouterInfo.IPv6 + ','
    else
      IPv6Str := RemoveBrackets(RouterInfo.IPv6, True) + ',';
    PingStr := PingStr + ',';
    if rfRelay in RouterInfo.Flags then
      TypeStr := 'Relay,'
    else
      TypeStr := 'Bridge,';
    if RouterInfo.Params and ROUTER_ALIVE <> 0 then
      AliveStr := 'Alive,'
    else
      AliveStr := NONE_CHAR + ',';
    FlagsStr := GetRouterStrFlags(RouterInfo.Flags);
  end;
  Result := HashStr + ',' +
    RouterInfo.Name + ',' +
    RouterInfo.IPv4 + ',' + IPv6Str +
    CountryStr + ',' + TransStr(CountryStr) + ',' +
    IntToStr(RouterInfo.Bandwidth) + ',' +
    IntToStr(RouterInfo.Port) + ',' +
    RouterInfo.Version + ',' +
    PingStr + TypeStr + AliveStr + FlagsStr;
end;

function TTcp.GetFallbackStr(RouterID: string; RouterInfo: TRouterInfo; Preview: Boolean = False): string;
begin
  if Preview then
    RouterID := Copy(RouterID, 1, 30) + '..';
  Result := RouterInfo.IPv4;
  if RouterInfo.DirPort <> 0 then
    Result := Result + ':' + IntToStr(RouterInfo.DirPort);
  Result := Result + ' orport=' + IntToStr(RouterInfo.Port) + ' id=' + RouterID;
  if RouterInfo.IPv6 <> '' then
  begin
    if Preview then
      Result := Result + ' ipv6=..'
    else
      Result := Result + ' ipv6=' + RouterInfo.IPv6 + ':' + IntToStr(RouterInfo.Port);
  end;
end;

function TTcp.ShowRelayInfo(aSg: TStringGrid; Handle: Boolean = False): Boolean;
var
  SelCount, i: Integer;
begin
  Result := False;
  if (aSg.Tag = GRID_CIRC_INFO) and SelNodeState then
  begin
    if Handle then
      OpenMetricsUrl('#details', SelectedNode);
  end
  else
  begin
    SelCount := aSg.Selection.Bottom - aSg.Selection.Top + 1;
    if SelCount > 5 then
      Exit;
    if Handle then
    begin
      for i := aSg.Selection.Top to aSg.Selection.Bottom do
        OpenMetricsUrl('#details', aSg.Cells[0, i]);
    end;
  end;
  Result := True;
end;

procedure TTcp.mnRoutersPopup(Sender: TObject);
var
  State, ClearState, ActionState, TypeState, NotStarting, FindPorts, SingleRow: Boolean;
  Router: TRouterInfo;
  RouterID: string;
begin
  SelectRowPopup(sgRouters, mnRouters);
  SingleRow := sgRouters.Selection.Top = sgRouters.Selection.Bottom;
  NotStarting := ConnectState <> 1;
  State := not IsEmptyRow(sgRouters, sgRouters.SelRow);

  miRtExtractData.Visible := State;
  miRtRelayInfo.Visible := State and ShowRelayInfo(sgRouters);
  miRtAddToNodesList.Visible := State and SingleRow;
  miRtAddToNodesList.Enabled := NotStarting;
  miRtSelectAsBridge.Visible := State and SingleRow;
  miRtSelectAsBridge.Enabled := NotStarting;

  miClearRouters.Enabled := NotStarting;
  miClearRoutersEntry.Enabled := lbFavoritesEntry.Tag > 0;
  miClearRoutersMiddle.Enabled := lbFavoritesMiddle.Tag > 0;
  miClearRoutersExit.Enabled := lbFavoritesExit.Tag > 0;
  miClearRoutersExclude.Enabled := lbExcludeNodes.Tag > 0;
  miClearRoutersFavorites.Enabled := lbFavoritesTotal.Tag > 0;

  ClearState := ((lbFavoritesTotal.Tag > 0) or (lbExcludeNodes.Tag > 0)) and (RoutersDic.Count > 0) and (InfoStage = 0) and not (Assigned(Consensus) or Assigned(Descriptors));
  miClearRoutersIncorrect.Enabled := ClearState;
  miClearRoutersAbsent.Enabled := ClearState;

  ActionState := miEnableConvertNodesOnIncorrectClear.Checked or miEnableConvertNodesOnAddToNodesList.Checked or miEnableConvertNodesOnRemoveFromNodesList.Checked;
  TypeState := miConvertIpNodes.Checked or miConvertCidrNodes.Checked or miConvertCountryNodes.Checked;

  miEnableConvertNodesOnIncorrectClear.Enabled := TypeState;
  miEnableConvertNodesOnAddToNodesList.Enabled := TypeState;
  miEnableConvertNodesOnRemoveFromNodesList.Enabled := TypeState;
  miConvertIpNodes.Enabled := ActionState;
  miConvertCidrNodes.Enabled := ActionState;
  miConvertCountryNodes.Enabled := ActionState;
  miIgnoreConvertExcludeNodes.Enabled := ActionState and TypeState;
  miAvoidAddingIncorrectNodes.Enabled := ActionState and TypeState;
  MenuSelectPrepare(miRtFilterSA, miRtFilterUA);

  if State then
  begin
    RouterID := sgRouters.Cells[ROUTER_ID, sgRouters.SelRow];
    if SingleRow then
    begin
      if RoutersDic.TryGetValue(RouterID, Router) then
      begin
        if ReachablePortsExists then
        begin
          FindPorts := PortsDic.ContainsKey(Router.Port);
          PortsDic.Clear;
        end
        else
          FindPorts := True;
        miRtSelectAsBridge.Visible := (cbxServerMode.ItemIndex = SERVER_MODE_NONE) and
          (((sgRouters.Cells[ROUTER_EXCLUDE_NODES, sgRouters.SelRow] <> EXCLUDE_CHAR) and
          (Router.Params and ROUTER_ALIVE <> 0) and FindPorts) or not miDisableSelectionUnSuitableAsBridge.Checked);
        if miRtSelectAsBridge.Visible then
        begin
          miRtSelectAsBridgeIPv4.Caption := GetBridgeStr(RouterID, Router, False, True);
          miRtSelectAsBridgeIPv4.Hint := RouterID;
          miRtSelectAsBridgeIPv4.Visible := miRtSelectAsBridgeIPv4.Caption <> '';
          miRtSelectAsBridgeIPv6.Caption := GetBridgeStr(RouterID, Router, True, True);
          miRtSelectAsBridgeIPv6.Hint := RouterID;
          miRtSelectAsBridgeIPv6.Visible := miRtSelectAsBridgeIPv6.Caption <> '';
          miRtDisableBridges.Visible := cbUseBridges.Checked;
        end;
      end;
      InsertNodesMenu(miRtAddToNodesList, RouterID, False);
    end;
    InsertExtractMenu(miRtExtractData, CONTROL_TYPE_GRID, GRID_ROUTERS, EXTRACT_PREVIEW);
  end;
end;

function TTcp.GetTrackHostDomains(Host: string; OnlyExists: Boolean): string;
var
  DotIndex: Integer;
begin
  Result := '';
  Host := ExtractDomain(Host, True);
  if ValidHost(Host, True, True) then
  begin
    DotIndex := 1;
    while DotIndex > 0 do
    begin
      if (OnlyExists and TrackHostDic.ContainsKey(Host)) or not OnlyExists then
        Result := Result + ';' + Host;
      DotIndex := Pos('.', Host, 2);
      if DotIndex <> -1 then
        Host := Copy(Host, DotIndex);
    end;
    if OnlyExists and TrackHostDic.ContainsKey('.') then
      Result := Result + ';' + TransStr('353');
    Delete(Result, 1, 1);
  end;
end;

procedure TTcp.mnShowNodesChange(Sender: TObject; Source: TMenuItem;
  Rebuild: Boolean);
begin
  mnShowNodes.Items.Tag := mnShowNodes.Tag;
  ShowNodesChanged := True;
end;

procedure TTcp.mnShowNodesPopup(Sender: TObject);
begin
  MenuSelectPrepare(nil, miShowNodesUA, True);
end;

procedure TTcp.mnStreamsInfoPopup(Sender: TObject);
var
  Flag: Boolean;
begin
  SelectRowPopup(sgStreamsInfo, mnStreamsInfo);
  SetSortMenuData(sgStreamsInfo);
  Flag := (ConnectState = 2) and not IsEmptyRow(sgStreamsInfo, sgStreamsInfo.SelRow);
  miStreamsInfoDestroyStream.Enabled := Flag and (sgStreams.Cells[STREAMS_COUNT, sgStreams.SelRow] <> EXCLUDE_CHAR);
  miStreamsInfoSortDL.Enabled := miShowStreamsTraffic.Checked;
  miStreamsInfoSortUL.Enabled := miShowStreamsTraffic.Checked;
end;

procedure TTcp.mnStreamsPopup(Sender: TObject);
var
  i: Integer;
  Flag, Search: Boolean;
  ParseStr: ArrOfStr;
  HostMenu: TMenuItem;
  Domains: string;
begin
  SetSortMenuData(sgStreams);
  SelectRowPopup(sgStreams, mnStreams);
  Flag := IsEmptyRow(sgStreams, sgStreams.SelRow);
  if Flag or (ConnectState <> 2) or (sgStreams.Cells[STREAMS_COUNT, sgStreams.SelRow] = EXCLUDE_CHAR) then
    miStreamsDestroyStream.Enabled := False
  else
    miStreamsDestroyStream.Enabled := True;
  miStreamsOpenInBrowser.Enabled := not Flag;
  miStreamsBindToExitNode.Enabled := False;
  miStreamsBindToExitNode.Clear;
  miStreamsSortDL.Enabled := miShowStreamsTraffic.Checked;
  miStreamsSortUL.Enabled := miShowStreamsTraffic.Checked;

  miStreamsBindToExitNode.Caption := TransStr('351');
  miStreamsBindToExitNode.ImageIndex := 21;

  if not Flag then
  begin
    Search := sgStreams.Cells[STREAMS_TRACK, sgStreams.SelRow] <> NONE_CHAR;
    if Search then
    begin
      miStreamsBindToExitNode.Caption := TransStr('352');
      miStreamsBindToExitNode.ImageIndex := 22;
    end;

    Domains := GetTrackHostDomains(sgStreams.Cells[STREAMS_TARGET, sgStreams.SelRow], Search);
    if Domains <> '' then
    begin
      ParseStr := Explode(';', Domains);
      for i := 0 to Length(ParseStr) - 1 do
      begin
        HostMenu := TMenuItem.Create(self);
        HostMenu.Caption := ParseStr[i];
        HostMenu.Tag := Integer(Search);
        HostMenu.OnClick := BindToExitNodeClick;
        miStreamsBindToExitNode.Add(HostMenu);
      end;
      miStreamsBindToExitNode.Enabled := True;
    end;
  end;
end;

procedure TTcp.mnTrafficPopup(Sender: TObject);
begin
  miResetTotalsCounter.Enabled := (ConnectState <> 1) and ((TotalDL <> 0) or (TotalUL <> 0));
end;

procedure TTcp.mnTransportsPopup(Sender: TObject);
begin
  SelectRowPopup(sgTransports, mnTransports);
  miTransportsOpenDir.Enabled := DirectoryExists(TransportsDir);
  miTransportsReset.Enabled := FileExists(DefaultsFile);
  if IsEmptyGrid(sgTransports) then
  begin
    miTransportsDelete.Enabled := False;
    miTransportsClear.Enabled := False;
  end
  else
  begin
    miTransportsDelete.Enabled := True;
    miTransportsClear.Enabled := True;
  end;
end;

procedure TTcp.mnChangeCircuitPopup(Sender: TObject);
var
  State, StartScanState, ClearNetworkState, ClearBridgesState, ScanState: Boolean;
  NotStarting: Boolean;
begin
  NotStarting := ConnectState <> 1;
  State := (InfoStage = 0) and not (Assigned(Consensus) or Assigned(Descriptors));
  ScanState := State and NotStarting and not tmScanner.Enabled;
  StartScanState := ScanState and
    ((cbEnablePingMeasure.Checked and miManualPingMeasure.Checked) or
    (miManualDetectAliveNodes.Checked and cbEnableDetectAliveNodes.Checked));
  ClearNetworkState := ScanState and FileExists(NetworkCacheFile);
  ClearBridgesState := ScanState and (ConnectState = 0) and FileExists(BridgesCacheFile);

  miCacheOperations.Enabled := NotStarting;
  miUpdateIpToCountryCache.Enabled := ClearNetworkState and GeoIpExists and (ConnectState = 2);
  miClearDNSCache.Enabled := ConnectState = 2;
  miClearServerCache.Enabled := (ConnectState = 0) and
    (DirectoryExists(UserDir + 'diff-cache') or FileExists(UserDir + 'cached-consensus') or FileExists(UserDir + 'cached-consensus.tmp'));
  miClearPingCache.Enabled := ClearNetworkState;
  miClearAliveCache.Enabled := ClearNetworkState;
  miClearUnusedNetworkCache.Enabled := ClearNetworkState;
  miClearBridgesCacheAll.Enabled := ClearBridgesState;
  miClearBridgeCacheUnnecessary.Enabled := ClearBridgesState;

  miStartScan.Enabled := NotStarting;
  miScanNewNodes.Enabled := StartScanState;
  miScanNonResponsed.Enabled := StartScanState;
  miScanCachedBridges.Enabled := StartScanState;
  miScanAll.Enabled := StartScanState;
  miScanGuards.Enabled := StartScanState;
  miScanAliveNodes.Enabled := StartScanState;
  miManualPingMeasure.Enabled := cbEnablePingMeasure.Checked and ScanState;
  miManualDetectAliveNodes.Enabled := cbEnableDetectAliveNodes.Checked and ScanState;
  miStopScan.Enabled := NotStarting and tmScanner.Enabled;

  miResetGuards.Enabled := NotStarting;
  miResetScannerSchedule.Enabled := ScanState;

  miCheckIpProxyType.Enabled := NotStarting;
  miCheckIpProxyAuto.Enabled := UsedProxyType <> ptNone;
  miCheckIpProxySocks.Enabled := UsedProxyType in [ptSocks, ptBoth];
  miCheckIpProxyHttp.Enabled := UsedProxyType in [ptHttp, ptBoth];
end;

procedure TTcp.EditMenuPopup(Sender: TObject);
var
  Control: TMemo;
  IsBridgeEdit, IsUserBridges, IsFallbackDirEdit, IsUserFallbackDirs, BridgesState, FallbackState: Boolean;
  BridgesCount, FallbackDirCount, MemoID, i: Integer;
begin
  if Screen.ActiveControl is TMemo then
    Control := TMemo(Screen.ActiveControl)
  else
    Control := nil;

  BridgesCount := meBridges.Lines.Count;
  IsBridgeEdit := Control = meBridges;
  IsUserBridges := IsBridgeEdit and (cbxBridgesType.ItemIndex <> BRIDGES_TYPE_BUILTIN) and (BridgesCount > 0);

  FallbackDirCount := meFallbackDirs.Lines.Count;
  IsFallbackDirEdit := Control = meFallbackDirs;
  IsUserFallbackDirs := IsFallbackDirEdit and (cbxFallbackDirsType.ItemIndex <> FALLBACK_TYPE_BUILTIN) and (FallbackDirCount > 0);

  BridgesState := IsUserBridges and not tmScanner.Enabled;
  FallbackState := IsUserFallbackDirs and not tmScanner.Enabled;

  miGetBridges.Visible := IsBridgeEdit;
  miClear.Visible := not (IsUserBridges or IsUserFallbackDirs);
  miClearMenu.Visible := IsUserBridges or IsUserFallbackDirs;

  miGetBridgesEmail.Enabled := IsBridgeEdit and RegistryFileExists(HKEY_CLASSES_ROOT, 'mailto\shell\open\command', '');
  miGetBridgesTelegram.Enabled := IsBridgeEdit and (RegistryFileExists(HKEY_CLASSES_ROOT, 'tg\shell\open\command', '') or miPreferWebTelegram.Checked);

  miClearMenuAll.Enabled := BridgesState or FallbackState;
  miClearMenuNotAlive.Enabled := (BridgesState or FallbackState) and cbEnableDetectAliveNodes.Checked;
  miClearMenuCached.Enabled := BridgesState or FallbackState;
  miClearMenuNonCached.Enabled := BridgesState or FallbackState;
  miClearMenuUnsuitable.Enabled :=
    (FallbackState and cbExcludeUnsuitableFallbackDirs.Checked and (SuitableFallbackDirsCount < FallbackDirCount)) or
    (BridgesState and cbExcludeUnsuitableBridges.Checked and (SuitableBridgesCount < BridgesCount));

  MemoID := MEMO_NONE;
  if IsBridgeEdit then
    MemoID := MEMO_BRIDGES;
  if IsFallbackDirEdit then
    MemoID := MEMO_FALLBACK_DIRS;

  miClearMenu.Tag := MemoID;

  if IsUserBridges then
  begin
    miClearMenuAll.Caption := TransStr('510');
    miClearMenuUnsuitable.Caption := TransStr('634');
  end;
  if IsUserFallbackDirs then
  begin
    miClearMenuAll.Caption := TransStr('656');
    miClearMenuUnsuitable.Caption := TransStr('657');
  end;

  EditMenuEnableCheck(miClear, emClear);
  EditMenuEnableCheck(miCopy, emCopy);
  EditMenuEnableCheck(miCut, emCut);
  EditMenuEnableCheck(miPaste, emPaste);
  EditMenuEnableCheck(miSelectAll, emSelectAll);
  EditMenuEnableCheck(miDelete, emDelete);
  EditMenuEnableCheck(miFind, emFind);

  if IsBridgeEdit or IsFallbackDirEdit then
    miExtractData.Visible := InsertExtractMenu(miExtractData, CONTROL_TYPE_MEMO, MemoID, EXTRACT_PREVIEW)
  else
    miExtractData.Visible := False;

  if Control <> nil then
  begin
    miSortData.Visible := Control.Tag in [MEMO_BRIDGES..MEMO_NODES_LIST];
    if miSortData.Visible then
    begin
      if not (Control.SortType in [SORT_NONE..SORT_DESC]) then
        Control.SortType := SORT_NONE;
      for i := 0 to miSortData.Count - 1 do
      begin
        if miSortData[i].Tag = Control.SortType then
        begin
          miSortData[i].Checked := True;
          Break;
        end;
      end;
    end;
  end
  else
    miSortData.Visible := False;
end;

procedure TTcp.SortDataList(Sender: TObject);
var
  Control: TMemo;
  ls: TStringList;
  State: Byte;
begin
  if Screen.ActiveControl is TMemo then
  begin
    SortUpdated := True;
    Control := TMemo(Screen.ActiveControl);
    State := TMenuItem(Sender).Tag;
    case State of
      SORT_NONE: Control.SortType := SORT_NONE;
      SORT_DESC: Control.SortType := SORT_DESC;
      else
        Control.SortType := SORT_ASC;
    end;
    if (State = SORT_NONE) and (Control.Tag in [MEMO_BRIDGES, MEMO_FALLBACK_DIRS, MEMO_NODES_LIST]) then
    begin
      case Control.Tag of
        MEMO_BRIDGES: UpdateBridgesControls(True, True);
        MEMO_FALLBACK_DIRS: UpdateFallbackDirControls;
        MEMO_NODES_LIST: LoadNodesList;
      end;
    end
    else
    begin
      ls := TStringList.Create;
      try
        MemoToList(Control, Control.SortType, ls);
      finally
        ls.Free;
      end;
    end;
    SortUpdated := False;
    EnableOptionButtons;
  end;
end;

procedure TTcp.SetExtractOptions(Sender: TObject);
begin
  case TMenuItem(Sender).Tag of
    OPTION_FORMAT_IPV6:
    begin
      FormatIPv6OnExtract := TMenuItem(Sender).Checked;
      SetConfigBoolean('Extractor', 'FormatIPv6OnExtract', FormatIPv6OnExtract);
    end;
    OPTION_SORT:
    begin
      SortOnExtract := TMenuItem(Sender).Checked;
      SetConfigBoolean('Extractor', 'SortOnExtract', SortOnExtract);
    end;
    OPTION_REMOVE_DUPLICATES:
    begin
      RemoveDuplicateOnExtract := TMenuItem(Sender).Checked;
      SetConfigBoolean('Extractor', 'RemoveDuplicateOnExtract', RemoveDuplicateOnExtract);
    end;
    OPTION_FORMAT_CODES:
    begin
      FormatCodesOnExtract := TMenuItem(Sender).Checked;
      SetConfigBoolean('Extractor', 'FormatCodesOnExtract', FormatCodesOnExtract);
    end;
 end;
end;

procedure TTcp.SetExtractDelimiter(Sender: TObject);
begin
  ExtractDelimiterType := TMenuItem(Sender).Tag;
  SetConfigInteger('Extractor', 'ExtractDelimiterType', ExtractDelimiterType);
end;

procedure TTcp.ExtractDataClick(Sender: TObject);
var
  ExtractMenu: TMenuItem;
begin
  ExtractMenu := TMenuItem(Sender).Parent;
  InsertExtractMenu(ExtractMenu, ExtractMenu.HelpContext, ExtractMenu.Tag, TMenuItem(Sender).Tag);
end;

function TTcp.InsertExtractMenu(ParentMenu: TMenuItem; ControlType, ControlID, ExtractType: Integer): Boolean;
var
  ControlMemo: TMemo;
  ControlGrid: TStringGrid;
  DelimiterMenu, OptionsMenu: TMenuItem;
  lr, ls: TStringList;
  i: Integer;
  PreviewState, ValidateData: Boolean;
  FallbackDir: TFallbackDir;
  Router: TRouterInfo;
  Bridge: TBridge;
  BridgeInfo: TBridgeInfo;
  DataStr, Delimiter: string;
  UniqueList: TDictionary<string, Byte>;
  PortStr, IPv4Str, IPv6Str, HashStr, IPv4BridgesStr, IPv6BridgesStr,
  FallbackDirsStr, NicknameStr, CountryCodeStr, CsvStr: string;
  PortCount, IPv4Count, IPv6Count, HashCount, IPv4BridgesCount, IPv6BridgesCount,
  FallbackDirsCount, NicknameCount, CountryCodeCount, CsvCount: Integer;

  procedure UpdateMenu(Menu: TMenuItem; DataStr: string; Count: Integer);
  var
    Str: string;
  begin
    case Count of
      0: Str := '';
      1: Str := DataStr;
      else
      begin
        Str := (DataStr).Trim(['.']) + '.. (' + IntToStr(Count) + ')';
      end;
    end;
    Menu.Visible := Count > 0;
    Menu.Caption := Str;
    Result := Result or Menu.Visible;
  end;

  procedure FormatData(var Str: string; var Count: Integer; Data: string; CurrentType: Integer);
  begin
    case CurrentType of
      EXTRACT_COUNTRY_CODE: if FormatCodesOnExtract then Data := '{' + Data + '}';
      EXTRACT_IPV6: if not FormatIPv6OnExtract then Data := RemoveBrackets(Data, True);
    end;
    if PreviewState then
    begin
      if Count = 0 then
        Str := Data;
      if RemoveDuplicateOnExtract then
      begin
        if UniqueList.ContainsKey(Data) then
          Exit
        else
        begin
          UniqueList.AddOrSetValue(Data, 0);
          Inc(Count);
        end;
      end
      else
        Inc(Count);
    end
    else
    begin
      if ExtractType = CurrentType then
      begin
        if RemoveDuplicateOnExtract then
        begin
          if UniqueList.ContainsKey(Data) then
            Exit
          else
          begin
            UniqueList.AddOrSetValue(Data, 0);
            lr.Append(Data);
            Inc(Count);
          end;
        end
        else
        begin
          lr.Append(Data);
          Inc(Count);
        end;
      end;
    end;
  end;

begin
  Result := False;
  PortCount := 0;
  IPv4Count := 0;
  IPv6Count := 0;
  HashCount := 0;
  IPv4BridgesCount := 0;
  IPv6BridgesCount := 0;
  FallbackDirsCount := 0;
  NicknameCount := 0;
  CountryCodeCount := 0;
  CsvCount := 0;
  PortStr := '';
  IPv4Str := '';
  IPv6Str := '';
  HashStr := '';
  IPv4BridgesStr := '';
  IPv6BridgesStr := '';
  FallbackDirsStr := '';
  NicknameStr := '';
  CountryCodeStr := '';
  CsvStr := '';
  ParentMenu.Clear;
  ParentMenu.Tag := ControlID;
  ParentMenu.HelpContext := ControlType;
  InsertMenuItem(ParentMenu, EXTRACT_COUNTRY_CODE, 57, '', ExtractDataClick);
  InsertMenuItem(ParentMenu, EXTRACT_PORT, 72, '', ExtractDataClick);
  InsertMenuItem(ParentMenu, EXTRACT_NICKNAME, 32, '', ExtractDataClick);
  InsertMenuItem(ParentMenu, EXTRACT_IPV4, 33, '', ExtractDataClick);
  InsertMenuItem(ParentMenu, EXTRACT_IPV6, 34, '', ExtractDataClick);
  InsertMenuItem(ParentMenu, EXTRACT_HASH, 23, '', ExtractDataClick);
  InsertMenuItem(ParentMenu, 0, -1, '-');
  InsertMenuItem(ParentMenu, EXTRACT_IPV4_BRIDGE, 59, '', ExtractDataClick);
  InsertMenuItem(ParentMenu, EXTRACT_IPV6_BRIDGE, 60, '', ExtractDataClick);
  InsertMenuItem(ParentMenu, 0, -1, '-');
  InsertMenuItem(ParentMenu, EXTRACT_FALLBACK_DIR, 54, '', ExtractDataClick);
  InsertMenuItem(ParentMenu, 0, -1, '-');
  InsertMenuItem(ParentMenu, EXTRACT_CSV, 73, '', ExtractDataClick);
  InsertMenuItem(ParentMenu, 0, -1, '-');
  OptionsMenu := InsertMenuItem(ParentMenu, 0, 11, TransStr('107'));
  InsertMenuItem(OptionsMenu, OPTION_FORMAT_IPV6, -1, TransStr('670'), SetExtractOptions, FormatIPv6OnExtract, True);
  InsertMenuItem(OptionsMenu, OPTION_FORMAT_CODES, -1, TransStr('679'), SetExtractOptions, FormatCodesOnExtract, True);
  InsertMenuItem(OptionsMenu, OPTION_SORT, -1, TransStr('672'), SetExtractOptions, SortOnExtract, True);
  InsertMenuItem(OptionsMenu, OPTION_REMOVE_DUPLICATES, -1, TransStr('671'), SetExtractOptions, RemoveDuplicateOnExtract, True);
  DelimiterMenu := InsertMenuItem(OptionsMenu, 0, -1, TransStr('673'));
  InsertMenuItem(DelimiterMenu, DELIM_AUTO, -1, TransStr('674'), SetExtractDelimiter, ExtractDelimiterType = DELIM_AUTO, False, True);
  InsertMenuItem(DelimiterMenu, DELIM_NEW_LINE, -1, TransStr('675'), SetExtractDelimiter, ExtractDelimiterType = DELIM_NEW_LINE , False, True);
  InsertMenuItem(DelimiterMenu, DELIM_COMMA, -1, TransStr('676'), SetExtractDelimiter, ExtractDelimiterType = DELIM_COMMA, False, True);

  if ((ExtractDelimiterType = DELIM_AUTO) and not (ExtractType in [EXTRACT_PORT, EXTRACT_COUNTRY_CODE]))
    or (ExtractDelimiterType = DELIM_NEW_LINE) or (ExtractType = EXTRACT_CSV) then
      Delimiter := BR
  else
    Delimiter := ',';

  PreviewState := ExtractType = EXTRACT_PREVIEW;
  ControlMemo := nil;
  ControlGrid := nil;

  case ControlType of
    CONTROL_TYPE_MEMO:
    begin
      case ControlID of
        MEMO_BRIDGES: ControlMemo := meBridges;
        MEMO_FALLBACK_DIRS: ControlMemo := meFallbackDirs;
      end;
    end;
    CONTROL_TYPE_GRID:
    begin
      case ControlID of
        GRID_ROUTERS: ControlGrid := sgRouters;
        GRID_CIRC_INFO: ControlGrid := sgCircuitInfo;
      end;
    end;
  end;
  if Assigned(ControlMemo) or Assigned(ControlGrid) then
  begin
    UniqueList := TDictionary<string, Byte>.Create;
    ls := TStringList.Create;
    lr := TStringList.Create;
    try
      case ControlType of
        CONTROL_TYPE_MEMO:
        begin
          if ControlMemo.SelLength > 0 then
            ls.Text := Trim(ControlMemo.SelText)
          else
            ls.Text := Trim(ControlMemo.Text);
          if ls.Text <> '' then
          begin
            ValidateData := OptionsChanged or (ControlMemo.SelLength > 0);
            case ControlID of
              MEMO_BRIDGES:
              begin
                for i := 0 to ls.Count - 1 do
                begin
                  if TryParseBridge(Trim(ls[i]), Bridge, ValidateData, FormatIPv6OnExtract) then
                  begin
                    FormatData(PortStr, PortCount, IntToStr(Bridge.Port), EXTRACT_PORT);
                    if Bridge.Hash <> '' then
                      FormatData(HashStr, HashCount, Bridge.Hash, EXTRACT_HASH);
                    if GetAddressType(Bridge.Ip) = atIPv4 then
                    begin
                      FormatData(CountryCodeStr, CountryCodeCount, CountryCodes[GetCountryValue(Bridge.Ip)], EXTRACT_COUNTRY_CODE);
                      FormatData(IPv4Str, IPv4Count, Bridge.Ip, EXTRACT_IPV4);
                      if (Bridge.Transport = '') and (Bridge.Hash <> '') then
                        FormatData(FallbackDirsStr, FallbackDirsCount, Bridge.Ip + ' orport=' + IntToStr(Bridge.Port) + ' id=' + Bridge.Hash, EXTRACT_FALLBACK_DIR);
                    end
                    else
                    begin
                      if RoutersDic.TryGetValue(Bridge.Hash, Router) then
                        FormatData(CountryCodeStr, CountryCodeCount, CountryCodes[GetCountryValue(Router.IPv4)], EXTRACT_COUNTRY_CODE);
                      FormatData(IPv6Str, IPv6Count, Bridge.Ip, EXTRACT_IPV6);
                    end;
                  end;
                end;
              end;
              MEMO_FALLBACK_DIRS:
              begin
                for i := 0 to ls.Count - 1 do
                begin
                  if TryParseFallbackDir(Trim(ls[i]), FallbackDir, ValidateData, FormatIPv6OnExtract) then
                  begin
                    FormatData(CountryCodeStr, CountryCodeCount, CountryCodes[GetCountryValue(FallbackDir.IPv4)], EXTRACT_COUNTRY_CODE);
                    FormatData(PortStr, PortCount, IntToStr(FallbackDir.OrPort), EXTRACT_PORT);
                    FormatData(HashStr, HashCount, FallbackDir.Hash, EXTRACT_HASH);
                    FormatData(IPv4Str, IPv4Count, FallbackDir.IPv4, EXTRACT_IPV4);
                    FormatData(IPv4BridgesStr, IPv4BridgesCount, FallbackDir.IPv4 + ':' + IntToStr(FallbackDir.OrPort) + ' ' + FallbackDir.Hash, EXTRACT_IPV4_BRIDGE);
                    if FallbackDir.IPv6 <> '' then
                    begin
                      FormatData(IPv6Str, IPv6Count, FallbackDir.IPv6, EXTRACT_IPV6);
                      FormatData(IPv6BridgesStr, IPv6BridgesCount, FormatHost(FallbackDir.IPv6, False) + ':' + IntToStr(FallbackDir.OrPort) + ' ' + FallbackDir.Hash, EXTRACT_IPV6_BRIDGE);
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
        CONTROL_TYPE_GRID:
        begin
          if ParentMenu.Hint = '' then
          begin
            for i := ControlGrid.Selection.Top to ControlGrid.Selection.Bottom do
              ls.Append(ControlGrid.Cells[0, i]);
          end
          else
            ls.Text := ParentMenu.Hint;
          if ls.Text <> '' then
          begin
            case ControlID of
              GRID_ROUTERS, GRID_CIRC_INFO:
              begin
                for i := 0 to ls.Count - 1 do
                begin
                  if RoutersDic.TryGetValue(ls[i], Router) then
                  begin
                    FormatData(CountryCodeStr, CountryCodeCount, CountryCodes[GetCountryValue(Router.IPv4)], EXTRACT_COUNTRY_CODE);
                    FormatData(PortStr, PortCount, IntToStr(Router.Port), EXTRACT_PORT);
                    FormatData(NicknameStr, NicknameCount, Router.Name, EXTRACT_NICKNAME);
                    FormatData(HashStr, HashCount, ls[i], EXTRACT_HASH);
                    FormatData(IPv4Str, IPv4Count, Router.IPv4, EXTRACT_IPV4);
                    FormatData(IPv4BridgesStr, IPv4BridgesCount, GetBridgeStr(ls[i], Router, False, PreviewState), EXTRACT_IPV4_BRIDGE);
                    if Router.IPv6 <> '' then
                    begin
                      FormatData(IPv6Str, IPv6Count, Router.IPv6, EXTRACT_IPV6);
                      DataStr := GetBridgeStr(ls[i], Router, True, PreviewState);
                      if DataStr <> ''then
                        FormatData(IPv6BridgesStr, IPv6BridgesCount, DataStr, EXTRACT_IPV6_BRIDGE);
                    end;
                    if rfRelay in Router.Flags then
                      FormatData(FallbackDirsStr, FallbackDirsCount, GetFallbackStr(ls[i], Router, PreviewState), EXTRACT_FALLBACK_DIR)
                    else
                    begin
                      if BridgesDic.TryGetValue(ls[i], BridgeInfo) then
                      begin
                        if BridgeInfo.Transport = '' then
                          FormatData(FallbackDirsStr, FallbackDirsCount, GetFallbackStr(ls[i], Router, PreviewState), EXTRACT_FALLBACK_DIR)
                      end;
                    end;
                    FormatData(CsvStr, CsvCount, GetRouterCsvData(ls[i], Router, PreviewState), EXTRACT_CSV);
                  end
                  else
                  begin
                    if ParentMenu.Hint <> '' then
                      FormatData(HashStr, HashCount, ls[i], EXTRACT_HASH);
                  end;
                end;
              end;
            end;
          end;
        end;
      end;

      if ExtractType = EXTRACT_PREVIEW then
      begin
        for i := 0 to ParentMenu.Count - 1 do
        begin
          if ParentMenu.Items[i].ImageIndex <> -1 then
          begin
            case ParentMenu.Items[i].Tag of
              EXTRACT_PORT: UpdateMenu(ParentMenu.Items[i], PortStr, PortCount);
              EXTRACT_IPV4: UpdateMenu(ParentMenu.Items[i], IPv4Str, IPv4Count);
              EXTRACT_IPV6: UpdateMenu(ParentMenu.Items[i], IPv6Str, IPv6Count);
              EXTRACT_HASH: UpdateMenu(ParentMenu.Items[i], HashStr, HashCount);
              EXTRACT_IPV4_BRIDGE: UpdateMenu(ParentMenu.Items[i], IPv4BridgesStr, IPv4BridgesCount);
              EXTRACT_IPV6_BRIDGE: UpdateMenu(ParentMenu.Items[i], IPv6BridgesStr, IPv6BridgesCount);
              EXTRACT_FALLBACK_DIR: UpdateMenu(ParentMenu.Items[i], FallbackDirsStr, FallbackDirsCount);
              EXTRACT_NICKNAME: UpdateMenu(ParentMenu.Items[i], NicknameStr, NicknameCount);
              EXTRACT_COUNTRY_CODE: UpdateMenu(ParentMenu.Items[i], CountryCodeStr, CountryCodeCount);
              EXTRACT_CSV: UpdateMenu(ParentMenu.Items[i], CsvStr, CsvCount);
            end;
          end;
        end;
        if not Result then
          ParentMenu.Clear;
      end
      else
      begin
        if SortOnExtract then
        begin
          if ExtractType = EXTRACT_HASH then
            lr.Sort
          else
            lr.CustomSort(CompTextAsc);
        end;
        DataStr := '';
        for i := 0 to lr.Count - 1 do
          DataStr := DataStr + Delimiter + lr[i];
        Delete(DataStr, 1, Length(Delimiter));
        if DataStr <> '' then
          Clipboard.AsText := DataStr;
      end;
    finally
      ls.Free;
      lr.Free;
      UniqueList.Free;
    end;
  end;
end;

procedure TTcp.ResetFocus;
begin
  if Closing or not Tcp.Visible then
    Exit;

  if FormSize = 1 then
  begin
    case LastPlace of
      LP_OPTIONS: if pcOptions.CanFocus then pcOptions.SetFocus;
      LP_LOG: if meLog.CanFocus then meLog.SetFocus;
      LP_STATUS: if paStatus.CanFocus then paStatus.SetFocus;
      LP_CIRCUITS: if paCircuits.CanFocus then paCircuits.SetFocus;
      LP_ROUTERS: if paRouters.CanFocus then paRouters.SetFocus;
    end;
  end
  else
    if paButtons.CanFocus then paButtons.SetFocus;
end;

procedure TTcp.lbSelectedRoutersMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and (ssDouble in Shift) then
    GridSelectAll(sgRouters);
end;

procedure TTcp.lbServerInfoMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if TLabel(Sender).Caption <> TransStr('260') then
    TLabel(Sender).Cursor := crHandPoint
  else
    TLabel(Sender).Cursor := crDefault;
  if (cbxServerMode.ItemIndex > SERVER_MODE_NONE) and (TLabel(Sender).Cursor = crHandPoint) then
    mnServerInfo.AutoPopup := True
  else
    mnServerInfo.AutoPopup := False;
end;

procedure TTcp.lbStatusFilterModeClick(Sender: TObject);
begin
  pcOptions.ActivePage := tsFilter;
  sbShowOptions.Click;
end;

procedure TTcp.lbStatusProxyAddrClick(Sender: TObject);
begin
  Clipboard.AsText := TLabel(Sender).Caption;
end;

procedure TTcp.lbStatusProxyAddrMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if ValidSocket(TLabel(Sender).Caption, False) <> soNone then
    TLabel(Sender).Cursor := crHandPoint
  else
    TLabel(Sender).Cursor := crDefault;
end;

procedure TTcp.lbUserDirClick(Sender: TObject);
begin
  ShellOpen(GetFullFileName(UserDir));
end;

procedure TTcp.paButtonsDblClick(Sender: TObject);
begin
  if FormSize = 1 then
  begin
    CheckOptionsChanged;
    DecreaseFormSize;
  end
  else
  begin
    case LastPlace of
      LP_OPTIONS: sbShowOptions.Click;
      LP_LOG: sbShowLog.Click;
      LP_STATUS: sbShowStatus.Click;
      LP_CIRCUITS: sbShowCircuits.Click;
      LP_ROUTERS: sbShowRouters.Click;
    end;
  end;
end;

procedure TTcp.paRoutersClick(Sender: TObject);
begin
  ResetFocus;
end;

procedure TTcp.pbScanProgressMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    if tmScanner.Enabled then
    begin
      if not ShowMsg(Format(TransStr('608'),[TransStr('495')]), '', mtQuestion, True) then
        Exit;
      if tmScanner.Enabled then
        StopScan := True;
    end;
  end;
end;

procedure TTcp.pbTrafficPaint(Sender: TObject);
const
  GRID_XN = 6;
  GRID_YN = 4;
var
  i, IntervalSize, Threshold, StepSpeed: Integer;
  MinIndex, MaxIndex, MinValue, MaxValue: Integer;
  ZeroX, ZeroY, CurrX, CurrY, LastX, LastY: Integer;
  AText: string;
  ARect: TRect;
  AHeight, AWidth, Filler, Modifier: Integer;
  APen: TGPPen;
  Plot : TGPGraphics;
  Data, ScaledData: ArrOfPoint;
  StepX, StepY: Real;

  procedure DrawData(AColor: TColor; IsDL: Boolean);
  var
    i, j, DataLength: Integer;
  begin
    j := 0;
    for i := MinIndex to MaxIndex do
    begin
      Data[j].X := j;
      if IsDL then
        Data[j].Y := SpeedData[i].DL
      else
        Data[j].Y := SpeedData[i].UL;
      Inc(j);
    end;
    ScaledData := SampleDown(Data, Threshold);
    DataLength := Length(ScaledData) - 1;

    APen.SetColor(ColorRefToARGB(AColor));
    LastX := ZeroX + AWidth;
    LastY := AHeight - Round((ScaledData[DataLength].Y - MinValue) / StepY);

    Filler := AWidth - (Threshold * Round(StepX));
    if Filler > 0 then
      Modifier := Threshold div Filler
    else
      Modifier := -1;

    for i := DataLength downto 0 do
    begin
      CurrX := Round(LastX - StepX);
      if Modifier > 0 then
      begin
        if (i mod Modifier = 0) and (i <> 0) then
          Dec(CurrX);
      end;
      CurrY := AHeight - Round((ScaledData[i].Y - MinValue) / StepY);
      if (ScaledData[i].Y <> -1) and (CurrX >= ZeroX) then
        Plot.DrawLine(APen, LastX, LastY, CurrX, CurrY);
      LastX := CurrX;
      LastY := CurrY;
    end;
  end;

begin
  IntervalSize := PlotIntervals[CurrentTrafficPeriod];
  MaxIndex := MAX_SPEED_DATA_LENGTH - 1;
  MinIndex := MaxIndex - IntervalSize + 1;

  MinValue := 0;
  MaxValue := 0;

  for i := MinIndex to MaxIndex do
  begin
    if miSelectGraphDL.Checked then
    begin
      if SpeedData[i].DL > -1 then
      begin
        if SpeedData[i].DL > MaxValue then
          MaxValue := SpeedData[i].DL;
        if SpeedData[i].DL < MinValue then
          MinValue := SpeedData[i].DL;
      end;
    end;
    if miSelectGraphUL.Checked then
    begin
      if SpeedData[i].UL > -1 then
      begin
        if SpeedData[i].UL > MaxValue then
          MaxValue := SpeedData[i].UL;
        if SpeedData[i].UL < MinValue then
          MinValue := SpeedData[i].UL;
      end;
    end;
  end;

  ZeroX := Round(55 * Scale);
  ZeroY := 0;

  AWidth := pbTraffic.Width - ZeroX - Round(8 * Scale);
  AHeight := pbTraffic.Height - ZeroY - Round(8 * Scale);

  StepY := Round(AHeight / GRID_YN);
  StepX := Round(AWidth / GRID_XN);
  StepSpeed := Round(MaxValue / GRID_YN);

  with pbTraffic.Canvas do
  begin
    Pen.Color := clSilver;
    Pen.Style := psDot;
    Pen.Width := 1;
    Font.Color := StyleServices.GetStyleFontColor(sfWindowTextNormal);

    CurrX := ZeroX;
    for i := 1 to GRID_XN + 1 do
    begin
      MoveTo(CurrX, ZeroY);
      LineTo(CurrX, AHeight);
      CurrX := Floor(CurrX + StepX);
    end;

    CurrY := ZeroY;
    for i := GRID_YN + 1 downto 1 do
    begin
      MoveTo(ZeroX, CurrY);
      LineTo(AWidth + ZeroX, CurrY);
      if i <> 1 then
      begin
        ARect := ClipRect;
        ARect.Right := ZeroX - Round(3 * Scale);
        ARect.Top := CurrY;
        AText := BytesFormat(StepSpeed * (i - 1));
        TextRect(ARect, AText, [tfRight, tfSingleLine]);
      end;
      CurrY := Floor(CurrY + StepY);
    end;
  end;

  case CurrentTrafficPeriod of
    0, 1: Threshold := IntervalSize;
    else
      Threshold := AWidth;
  end;

  Dec(AHeight, 2);
  StepX := AWidth / Threshold;
  StepY := (MaxValue - MinValue) / AHeight;

  if StepY = 0 then
    Exit;

  Plot := TGPGraphics.Create(pbTraffic.Canvas.Handle);
  APen := TGPPen.Create(ColorRefToARGB(clDefault), 1);
  try
    Plot.SetSmoothingMode(SmoothingModeAntiAlias);
    SetLength(Data, IntervalSize);

    if miSelectGraphUL.Checked then
      DrawData($00FF9932, False);

    if miSelectGraphDL.Checked then
      DrawData($003FC486, True);
  finally
    Plot.Free;
    APen.Free;
  end;
end;

function TTcp.CheckSimilarPorts: Boolean;
  function NoSimilar: Boolean;
  begin
    Result := (udSOCKSPort.Position <> udControlPort.Position) and
      (udHTTPTunnelPort.Position <> udControlPort.Position) and
        (udHTTPTunnelPort.Position <> udSOCKSPort.Position);
  end;
begin
  if NoSimilar then
    Result := False
  else
  begin
    Result := True;
    Randomize;
    repeat
      if (udControlPort.Position = udSOCKSPort.Position) then
        udControlPort.Position := RandomRange(9000, 10000);
      if (udControlPort.Position = udHTTPTunnelPort.Position) then
        udControlPort.Position := RandomRange(9000, 10000);
      if (udSOCKSPort.Position = udHTTPTunnelPort.Position) then
        udHTTPTunnelPort.Position := RandomRange(9000, 10000);
    until NoSimilar;
  end;
end;

procedure TTcp.SetButtonsProp(Btn: TSpeedButton; LeftSmall, LeftBig: Integer);
begin
  if FormSize = 0 then
  begin
    Btn.Hint := Btn.Caption;
    Btn.Caption := '';
    Btn.ShowHint := True;
    Btn.Margin := -1;
    Btn.Width := Round(40 * Scale);
    Btn.Left := Round(LeftSmall * Scale);
  end
  else
  begin
    Btn.Caption := Btn.Hint;
    Btn.ShowHint := False;
    Btn.Hint := '';
    Btn.Margin := 8;
    Btn.Width := Round(119 * Scale);
    Btn.Left := Round(LeftBig * Scale);
  end;
end;

procedure TTcp.ChangeButtonsCaption;
begin
  if FormSize = 0 then
  begin
    btnChangeCircuit.Width := Round(119 * Scale);
    btnSwitchTor.Width := Round(119 * Scale);
  end
  else
  begin
    btnChangeCircuit.Width := Round(119 * Scale);
    btnSwitchTor.Width := Round(119 * Scale);
  end;
  SetButtonsProp(sbShowOptions, 124, 124);
  SetButtonsProp(sbShowLog, 166, 245);
  SetButtonsProp(sbShowStatus, 208, 366);
  SetButtonsProp(sbShowCircuits, 250, 487);
  SetButtonsProp(sbShowRouters, 292, 608);
  CheckLabelEndEllipsis(lbExitCountry, 150, epEndEllipsis, True, False);
end;

procedure TTcp.UpdateFormSize;
var
  H, W: Integer;
begin
  if FormSize = 0 then
  begin
    H := Round(91 * Scale);
    W := Round(335 * Scale);
  end
  else
  begin
    H := Round(556 * Scale);
    W := Round(772 * Scale);
  end;
  if ClientHeight <> H then
    ClientHeight := H;
  if ClientWidth <> W then
    ClientWidth := W;
end;

procedure TTcp.SetDesktopPosition(ALeft, ATop: Integer; AutoUpdate: Boolean = True);
var
  TP: TTaskBarPos;
  CheckBorders: Boolean;
begin
  if FormSize = 0 then
    CheckBorders := not cbNoDesktopBorders.Checked
      or not (cbNoDesktopBorders.Checked and not cbNoDesktopBordersOnlyEnlarged.Checked)
  else
    CheckBorders := not cbNoDesktopBorders.Checked;

  if (ALeft = -1) and (ATop = -1) then
  begin
    ALeft := Round((Screen.Width - Width) / 2);
    ATop := Round((Screen.Height - Height) / 2);
  end
  else
  begin
    if CheckBorders or FirstLoad then
    begin
      TP := GetTaskBarPos;
      if ALeft < Screen.WorkAreaLeft then
        ALeft := Screen.WorkAreaLeft + 5
      else
      begin
        if ALeft > Screen.WorkAreaWidth - Width then
        begin
          if TP = tbLeft then
            ALeft := Screen.Width - Width - 5
          else
            ALeft := Screen.WorkAreaWidth - Width - 5;
        end;
      end;

      if ATop < Screen.WorkAreaTop then
        ATop := Screen.WorkAreaTop + 5
      else
      begin
        if ATop > Screen.WorkAreaHeight - Height then
        begin
          if TP = tbTop then
            ATop := Screen.Height - Height - 5
          else
            ATop := Screen.WorkAreaHeight - Height - 5;
        end;
      end;
    end;
  end;
  if FormSize = 0 then
  begin
    DecFormPos.X := ALeft;
    DecFormPos.Y := ATop;
  end
  else
  begin
    IncFormPos.X := ALeft;
    IncFormPos.Y := ATop;
  end;
  if AutoUpdate then
  begin
    if Left <> ALeft then
      Left := ALeft;
    if Top <> ATop then
      Top := ATop;
  end;
end;

procedure TTcp.DecreaseFormSize(AutoRestore: Boolean = True);
begin
  FindDialog.CloseDialog;
  if FormSize = 1 then
  begin
    FormSize := 0;
    paButtons.Visible := False;
    sbShowOptions.AllowAllUp := True;
    sbShowOptions.Down := False;
    sbShowLog.Down := False;
    sbShowStatus.Down := False;
    sbShowCircuits.Down := False;
    sbShowRouters.Down := False;
    sbShowOptions.AllowAllUp := False;
    ChangeButtonsCaption;
    AlphaBlendValue := 0;
    AlphaBlend := True;
    UpdateFormSize;
    SetDesktopPosition(DecFormPos.X, DecFormPos.Y);
    AlphaBlend := False;
    AlphaBlendValue := 255;
    paButtons.Visible := True;
  end;
end;

procedure TTcp.IncreaseFormSize;
  procedure SetVisible(vOptions, vLog, vStatus, vCircuits, vRouters, vButtons: Boolean);
  begin
    paRouters.Visible := vRouters;
    paCircuits.Visible := vCircuits;
    paStatus.Visible := vStatus;
    paLog.Visible := vLog;
    pcOptions.Visible := vOptions;
    btnApplyOptions.Visible := vButtons;
    btnCancelOptions.Visible := vButtons;
  end;
begin
  SetDownState;
  if FormSize = 0 then
  begin
    FormSize := 1;
    paButtons.Visible := False;
    SetVisible(False, False, False, False, False, False);
    ChangeButtonsCaption;
    AlphaBlendValue := 0;
    AlphaBlend := True;
    UpdateFormSize;
    if cbRememberEnlargedPosition.Checked then
    begin
      Tcp.Left := IncFormPos.X;
      Tcp.Top := IncFormPos.Y;
    end
    else
    begin
      Tcp.Left := Round((Screen.Width - Width) / 2);
      Tcp.Top := Round((Screen.Height - Height) / 2);
    end;
    AlphaBlend := False;
    AlphaBlendValue := 255;
    paButtons.Visible := True;
  end;
  case LastPlace of
    LP_OPTIONS: SetVisible(True, False, False, False, False, True);
    LP_LOG: SetVisible(False, True, False, False, False, False);
    LP_STATUS: SetVisible(False, False, True, False, False, False);
    LP_CIRCUITS: SetVisible(False, False, False, True, False, False);
    LP_ROUTERS: SetVisible(False, False, False, False, True, True);
  end;
end;

procedure TTcp.MainButtonssMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if ssLeft in Shift then
    TButton(Sender).Perform(BM_SETSTATE, 1, 0);
end;

procedure TTcp.MetricsInfo(Sender: TObject);
var
  cc: string;
begin
  if sgFilter.Cells[FILTER_ID, sgFilter.SelRow] <> '??' then
    cc := LowerCase(sgFilter.Cells[FILTER_ID, sgFilter.SelRow])
  else
    cc := 'xz';
  OpenMetricsUrl('#search', 'country:' + cc + TMenuItem(Sender).Hint);
end;

procedure TTcp.miStatAggregateClick(Sender: TObject);
begin
  OpenMetricsUrl('#aggregate', 'cc');
end;

procedure TTcp.miStopScanClick(Sender: TObject);
begin
  if not ShowMsg(Format(TransStr('608'),[TransStr('495')]), '', mtQuestion, True) then
    Exit;
  if tmScanner.Enabled then
    StopScan := True;
end;

procedure TTcp.SaveTrackHostExits(ini: TMemIniFile; UseDic: Boolean = False);
var
  TrackHostExits: string;
  ls: TStringList;
  Item: TPair<string, Byte>;
  i: Integer;
begin
  if UseDic then
  begin
    ls := TStringList.Create;
    try
      for Item in TrackHostDic do
        ls.Append(Item.Key);
      SortList(ls, ltHost, meTrackHostExits.SortType);
      TrackHostExits := '';
      for i := 0 to ls.Count - 1 do
        TrackHostExits := TrackHostExits + ',' + ls[i];
      Delete(TrackHostExits, 1, 1);
      meTrackHostExits.Text := ls.Text;
    finally
      ls.Free;
    end;
  end
  else
  begin
    TrackHostExits := MemoToLine(meTrackHostExits, meTrackHostExits.SortType);
    TrackHostDic.Clear;
    if TrackHostExits <> '' then
      for i := 0 to meTrackHostExits.Lines.Count - 1 do
        TrackHostDic.AddOrSetValue(meTrackHostExits.Lines[i], 0);
  end;
  if cbUseTrackHostExits.Checked and (TrackHostExits <> '') then
  begin
    SetTorConfig('TrackHostExits', TrackHostExits);
    SetTorConfig('TrackHostExitsExpire', IntToStr(udTrackHostExitsExpire.Position));
  end
  else
  begin
    cbUseTrackHostExits.Checked := False;
    DeleteTorConfig('TrackHostExits');
    DeleteTorConfig('TrackHostExitsExpire');
  end;
  SetSettings('Lists', cbUseTrackHostExits, ini);
  SetSettings('Lists', udTrackHostExitsExpire, ini);
  SetSettings('Lists', 'TrackHostExits', TrackHostExits, ini);
  if UseDic and (ConnectState = 2) then
  begin
    if cbUseTrackHostExits.Checked then
      SendCommand('SETCONF TrackHostExits=' + TrackHostExits)
    else
      SendCommand('SETCONF TrackHostExits');
  end;
end;

procedure TTcp.SaveServerOptions(ini: TMemIniFile);
var
  ExitPolicy, MyFamily, Address: string;
  ParseStr: ArrOfStr;
  i: Integer;
begin
  DeleteTorConfig('Nickname');
  DeleteTorConfig('ContactInfo');
  DeleteTorConfig('Address', [cfMultiLine]);
  DeleteTorConfig('RelayBandwidthRate');
  DeleteTorConfig('RelayBandwidthBurst');
  DeleteTorConfig('MaxAdvertisedBandwidth');
  DeleteTorConfig('MaxMemInQueues');
  DeleteTorConfig('NumCPUs');
  DeleteTorConfig('PublishServerDescriptor');
  DeleteTorConfig('DirReqStatistics');
  DeleteTorConfig('HiddenServiceStatistics');
  DeleteTorConfig('AssumeReachable');
  DeleteTorConfig('DirCache');
  DeleteTorConfig('ORPort');
  DeleteTorConfig('DirPort');
  DeleteTorConfig('BridgeRelay');
  DeleteTorConfig('BridgeDistribution');
  DeleteTorConfig('ExitRelay');
  DeleteTorConfig('ExitPolicy', [cfMultiLine]);
  DeleteTorConfig('IPv6Exit');
  DeleteTorConfig('ReducedExitPolicy');
  DeleteTorConfig('MyFamily');

  MyFamily := MemoToLine(meMyFamily, meMyFamily.SortType);
  ExitPolicy := MemoToLine(meExitPolicy);
  if ExitPolicy = '' then
  begin
    if cbxExitPolicyType.ItemIndex <> 1 then
      cbxExitPolicyType.ItemIndex := 0;
    meExitPolicy.Text := StringReplace(DEFAULT_CUSTOM_EXIT_POLICY, ',', BR, [rfReplaceAll]);
    meExitPolicy.Enabled := False;
  end;
  if cbxServerMode.ItemIndex > SERVER_MODE_NONE then
  begin
    SetTorConfig('Nickname', edNickname.Text);
    edContactInfo.Text := Trim(edContactInfo.Text);
    SetTorConfig('ContactInfo', edContactInfo.Text);

    SetServerPort(udORPort);
    if cbUseDirPort.Checked then
      SetServerPort(udDirPort);

    ParseStr := Explode(',', RemoveBrackets(edAddress.Text, True));
    Address := '';
    for i := 0 to Length(ParseStr) - 1 do
    begin
      ParseStr[i] := ExtractDomain(Trim(ParseStr[i]));
      if ValidHost(ParseStr[i]) then
      begin
        if cbUseAddress.Checked then
          TorConfig.Append('Address ' + FormatHost(ParseStr[i]));
        Address := Address + ',' + ParseStr[i];
      end;
    end;
    Delete(Address, 1, 1);
    edAddress.Text := Address;
    if Address = '' then
      cbUseAddress.Checked := False;

    if cbUseRelayBandwidth.Checked then
    begin
      SetTorConfig('RelayBandwidthRate', IntToStr(udRelayBandwidthRate.Position) + ' kb');
      SetTorConfig('RelayBandwidthBurst', IntToStr(udRelayBandwidthBurst.Position) + ' kb');
      SetTorConfig('MaxAdvertisedBandwidth', IntToStr(udMaxAdvertisedBandwidth.Position) + ' kb');
    end;
    if cbUseMaxMemInQueues.Checked then
      SetTorConfig('MaxMemInQueues', IntToStr(udMaxMemInQueues.Position) + ' mb');
    if cbUseNumCPUs.Checked then
      SetTorConfig('NumCPUs', IntToStr(udNumCPUs.Position));
    if cbxServerMode.ItemIndex = SERVER_MODE_EXIT then
    begin
      if cbListenIPv6.Checked and cbIPv6Exit.Checked then
        SetTorConfig('IPv6Exit', '1')
      else
        SetTorConfig('ExitRelay', '1');
      case cbxExitPolicyType.ItemIndex of
        1: SetTorConfig('ReducedExitPolicy', '1');
        2: SetTorConfig('ExitPolicy', ExitPolicy);
      end;
    end;
    if cbxServerMode.ItemIndex = SERVER_MODE_BRIDGE then
    begin
      SetTorConfig('BridgeRelay', '1');
      SetTorConfig('BridgeDistribution', BridgeDistributions[cbxBridgeDistribution.ItemIndex]);

    end;
    if cbxServerMode.ItemIndex in [SERVER_MODE_RELAY, SERVER_MODE_BRIDGE] then
      SetTorConfig('ExitPolicy', 'reject *:*');

    if MyFamily <> '' then
    begin
      if cbUseMyFamily.Checked and (cbxServerMode.ItemIndex <> SERVER_MODE_BRIDGE) then
        SetTorConfig('MyFamily', MyFamily)
    end
    else
    begin
      cbUseMyFamily.Checked := False;
      MyFamilyEnable(False);
    end;

    SetTorConfig('PublishServerDescriptor', IntToStr(Integer(cbPublishServerDescriptor.Checked)));
    SetTorConfig('DirReqStatistics', IntToStr(Integer(cbDirReqStatistics.Checked)));
    SetTorConfig('HiddenServiceStatistics', IntToStr(Integer(cbHiddenServiceStatistics.Checked)));
    SetTorConfig('DirCache', IntToStr(Integer(cbDirCache.Checked)));
    SetTorConfig('AssumeReachable', IntToStr(Integer(cbAssumeReachable.Checked)));
  end;

  SetSettings('Server', cbxServerMode, ini);
  SetSettings('Server', edNickname, ini);
  SetSettings('Server', edContactInfo, ini);
  SetSettings('Server', edAddress, ini, True);
  SetSettings('Server', udORPort, ini);
  SetSettings('Server', udDirPort, ini);
  SetSettings('Server', udTransportPort, ini);
  SetSettings('Server', udRelayBandwidthRate, ini);
  SetSettings('Server', udRelayBandwidthBurst, ini);
  SetSettings('Server', udMaxAdvertisedBandwidth, ini);
  SetSettings('Server', udMaxMemInQueues, ini);
  SetSettings('Server', udNumCPUs, ini);
  SetSettings('Server', cbxExitPolicyType, ini);
  SetSettings('Server', cbxBridgeDistribution, ini);
  SetSettings('Server', 'CustomExitPolicy', ExitPolicy, ini);
  SetSettings('Server', cbUseRelayBandwidth, ini);
  SetSettings('Server', cbUseNumCPUs, ini);
  SetSettings('Server', cbUseMaxMemInQueues, ini);
  SetSettings('Server', cbUseAddress, ini);
  SetSettings('Server', cbUseDirPort, ini);
  SetSettings('Server', cbUseUPnP, ini);
  SetSettings('Server', cbAssumeReachable, ini);
  SetSettings('Server', cbDirCache, ini);
  SetSettings('Server', cbDirReqStatistics, ini);
  SetSettings('Server', cbIPv6Exit, ini);
  SetSettings('Server', cbListenIPv6, ini);
  SetSettings('Server', cbHiddenServiceStatistics, ini);
  SetSettings('Server', cbPublishServerDescriptor, ini);
  SetSettings('Server', cbUseMyFamily, ini);
  SetSettings('Server', 'MyFamily', MyFamily, ini);
  CheckServerControls;
end;

procedure TTcp.CheckPaddingControls;
var
  State: Boolean;
begin
  State := CheckFileVersion(TorVersion, '0.4.1.1');
  cbxCircuitPadding.Enabled := State;
  lbCircuitPadding.Enabled := State;
end;

procedure TTcp.SavePaddingOptions(ini: TMemIniFile);
begin
  DeleteTorConfig('ConnectionPadding');
  DeleteTorConfig('ReducedConnectionPadding');
  DeleteTorConfig('CircuitPadding');
  DeleteTorConfig('ReducedCircuitPadding');

  if cbxServerMode.ItemIndex = SERVER_MODE_NONE then
  begin
    case cbxConnectionPadding.ItemIndex of
      0: SetTorConfig('ConnectionPadding', 'auto');
      1: SetTorConfig('ConnectionPadding', '1');
      2: SetTorConfig('ReducedConnectionPadding', '1');
      3: SetTorConfig('ConnectionPadding', '0');
    end;
    if CheckFileVersion(TorVersion, '0.4.1.1') then
    begin
      case cbxCircuitPadding.ItemIndex of
        0: SetTorConfig('CircuitPadding', '1');
        1: SetTorConfig('ReducedCircuitPadding', '1');
        2: SetTorConfig('CircuitPadding', '0');
      end;
    end;
  end;

  SetSettings('Main', cbxConnectionPadding, ini);
  SetSettings('Main', cbxCircuitPadding, ini);
end;

procedure TTcp.BindToExitNodeClick(Sender: TObject);
var
  ini: TMemIniFile;
  Host: string;
begin
  Host := TMenuItem(Sender).Caption;
  if Host = TransStr('353') then
    Host := '.';
  OptionsLocked := True;
  if TMenuItem(Sender).Tag = 0 then
  begin
    if TrackHostDic.Count = 0 then
      cbUseTrackHostExits.Checked := True;
    TrackHostDic.AddOrSetValue(Host, 0)
  end
  else
    TrackHostDic.Remove(Host);
  ini := TMemIniFile.Create(UserConfigFile, TEncoding.UTF8);
  try
    SaveTrackHostExits(ini, True);
  finally
    UpdateConfigFile(ini);
  end;
  OptionsLocked := False;
  SaveTorConfig;
  ShowStreams(sgCircuits.Cells[CIRC_ID, sgCircuits.Row]);
end;

procedure TTcp.miStreamsDestroyStreamClick(Sender: TObject);
begin
  CloseStreams(sgCircuits.Cells[CIRC_ID, sgCircuits.SelRow], True, sgStreams.Cells[STREAMS_TARGET, sgStreams.SelRow]);
end;

procedure TTcp.miStreamsInfoDestroyStreamClick(Sender: TObject);
begin
  CloseStream(sgStreamsInfo.Cells[STREAMS_INFO_ID, sgStreamsInfo.SelRow]);
end;

procedure TTcp.miStreamsOpenInBrowserClick(Sender: TObject);
begin
  ShellOpen(sgStreams.Cells[STREAMS_TARGET, sgStreams.SelRow]);
end;

procedure TTcp.ScanStart(ScanType: TScanType; ScanPurpose: TScanPurpose);
begin
  TotalScans := 0;
  CurrentScans := 0;
  CurrentScanType := ScanType;
  Scanner := TScanThread.Create(True);
  Scanner.sScanType := ScanType;
  Scanner.sScanPurpose := ScanPurpose;
  Scanner.sMaxPortAttempts := udScanPortAttempts.Position;
  Scanner.sMaxPingAttempts := udScanPingAttempts.Position;
  Scanner.sAttemptsDelay := udDelayBetweenAttempts.Position;
  Scanner.sMaxThreads := udScanMaxThread.Position;
  Scanner.sPingTimeout := udScanPingTimeout.Position;
  Scanner.sPortTimeout := udScanPortTimeout.Position;
  Scanner.sScanPortionTimeout := udScanPortionTimeout.Position;
  Scanner.sScanPortionSize := udScanPortionSize.Position;
  Scanner.FreeOnTerminate := True;
  Scanner.Priority := tpNormal;
  Scanner.OnTerminate := ScanThreadTerminate;
  Scanner.Start;
end;

function TTcp.GetScanTypeStr: string;
begin
  case CurrentScanType of
    stPing: Result := TransStr('382');
    stAlive:
    begin
      if CurrentScanPurpose in [spUserBridges, spNewBridges] then
        Result := TransStr('396')
      else
      begin
        if CurrentScanPurpose = spUserFallbackDirs then
          Result := TransStr('658')
        else
          Result := TransStr('383');
      end;
    end;
    else
      Result := '';
  end;
  if Result <> '' then
    Result := Result + '..';
end;

procedure TTcp.UpdateScannerControls;
var
  State: Boolean;
begin
  State := ScanStage > 0;
  lbScanProgress.Caption := TransStr('631');
  lbScanType.Caption := GetScanTypeStr;
  lbScanType.Left := lbScanProgress.Left;
  lbScanType.Visible := State;
  lbScanProgress.Visible := State;
  pbScanProgress.Visible := State;
  UpdateTrayIcon;
end;

procedure TTcp.ScanNetwork(ScanType: TScanType; ScanPurpose: TScanPurpose);
var
  CurrentDate: Int64;
begin
  if (ScanType = stNone) or (ScanPurpose = spNone) then
    Exit;
  if cbEnablePingMeasure.Checked or cbEnableDetectAliveNodes.Checked then
  begin
    if not tmScanner.Enabled then
    begin
      CurrentDate := DateTimeToUnix(Now);
      CurrentScanPurpose := ScanPurpose;
      ScanStage := 1;
      if ScanType = stBoth then
      begin
        if cbEnablePingMeasure.Checked and cbEnableDetectAliveNodes.Checked then
          ScanStage := 2
        else
        begin
          if cbEnablePingMeasure.Checked then
            ScanType := stPing
          else
            ScanType := stAlive;
        end;
      end;

      if CurrentScanPurpose = spAuto then
      begin
        if CurrentDate >= (LastFullScanDate + (udFullScanInterval.Position * 3600)) then
          CurrentAutoScanPurpose := spAll
        else
        begin
          CurrentAutoScanPurpose := spNew;
          if cbxAutoScanType.ItemIndex <> AUTOSCAN_NEW then
          begin
            if (LastPartialScansCounts > 0) and (CurrentDate >= (LastPartialScanDate + (udPartialScanInterval.Position * 3600))) then
            begin
              case cbxAutoScanType.ItemIndex of
                AUTOSCAN_AUTO:
                begin
                  if LastPartialScansCounts mod 3 = 0 then
                    CurrentAutoScanPurpose := spNewAndFailed
                  else
                    CurrentAutoScanPurpose := spNewAndAlive
                end;
                AUTOSCAN_NEW_AND_FAILED: CurrentAutoScanPurpose := spNewAndFailed;
                AUTOSCAN_NEW_AND_ALIVE: CurrentAutoScanPurpose := spNewAndAlive;
                AUTOSCAN_NEW_AND_BRIDGES: CurrentAutoScanPurpose := spNewAndBridges;
              end;
            end;
          end;
        end;
        AutoScanStage := 2;
      end
      else
        CurrentAutoScanPurpose := spNone;

      InitScanType := ScanType;

      case ScanStage of
        1: ScanStart(ScanType, CurrentScanPurpose);
        2: ScanStart(stPing, CurrentScanPurpose);
      end;

      if CurrentScanPurpose in [spUserBridges, spUserFallbackDirs] then
        SetOptionsEnable(False);

      tmScanner.Enabled := True;
    end;
  end;
end;

procedure TTcp.tmScannerTimer(Sender: TObject);
var
  ls: TStringList;
  i, DeleteCount, AutoSelType: Integer;
  CurrentDate: Int64;
  Str: string;
  GeoIpInfo: TGeoIpInfo;
  Bridge: TBridge;
  FallbackDir: TFallbackDir;
  CurrentMemo: TMemo;
  NeedUpdate: Boolean;

  procedure DeleteListData(IpStr, PortStr: string);
  begin
    if GeoIpDic.TryGetValue(IpStr, GeoIpInfo) then
    begin
      if GetPortsValue(GeoIpInfo.ports, PortStr) = -1 then
      begin
        ls.Delete(i);
        Inc(DeleteCount);
      end;
      if (GeoIpInfo.cc = DEFAULT_COUNTRY_ID) and (GeoIpInfo.ping = 0) then
        GeoIpDic.Remove(IpStr);
    end;
  end;

  procedure ResetScanData;
  begin
    LastFullScanDate := CurrentDate;
    LastPartialScanDate := CurrentDate;
    LastPartialScansCounts := udPartialScansCounts.Position;
    SaveScanData;
  end;

begin
  if not Assigned(Scanner) and (ScanThreads = 0) then
  begin
    if (ScanStage = 2) and not StopScan then
    begin
      ScanStart(stAlive, CurrentScanPurpose);
      ScanStage := 1;
    end
    else
    begin
      if CurrentScanType = stAlive then
      begin
        if CurrentScanPurpose in [spUserBridges, spUserFallbackDirs] then
        begin
          case CurrentScanPurpose of
            spUserBridges: CurrentMemo := meBridges;
            spUserFallbackDirs: CurrentMemo := meFallbackDirs;
            else
              Exit;
          end;
          if CurrentMemo.Text <> '' then
          begin
            DeleteCount := 0;
            ls := TStringList.Create;
            try
              ls.Text := CurrentMemo.Text;
              if CurrentScanPurpose = spUserBridges then
              begin
                for i := ls.Count - 1 downto 0 do
                begin
                  if TryParseBridge(ls[i], Bridge) then
                  begin
                    Str := GetBridgeIp(Bridge);
                    if Str = '' then
                      Continue;
                    DeleteListData(Str, IntToStr(Bridge.Port));
                  end;
                end;
              end;
              if CurrentScanPurpose = spUserFallbackDirs then
              begin
                for i := ls.Count - 1 downto 0 do
                begin
                  if TryParseFallbackDir(ls[i], FallbackDir) then
                    DeleteListData(FallbackDir.IPv4, IntToStr(FallbackDir.OrPort));
                end;
              end;
              if DeleteCount > 0 then
              begin
                CurrentMemo.Text := ls.Text;
                case CurrentScanPurpose of
                  spUserBridges: SaveBridgesData;
                  spUserFallbackDirs: SaveFallbackDirsData;
                end;
              end;
            finally
              ls.Free;
            end;
          end;
        end
        else
        begin
          if cbExcludeUnsuitableFallbackDirs.Checked then
          begin
            ls := TStringList.Create;
            try
              ls.Text := meFallbackDirs.Text;
              ExcludeUnsuitableFallbackDirs(ls);
              if LastFallbackDirsHash <> Crc32(AnsiString(ls.Text)) then
                UpdateFallbackDirs := True;
            finally
              ls.Free;
            end;
          end;
        end;
      end;

      CurrentDate := DateTimeToUnix(Now);
      case CurrentScanPurpose of
        spUserBridges, spUserFallbackDirs: SetOptionsEnable(True);
        spAll:
        begin
          if (InitScanType = stBoth) and not StopScan then
            ResetScanData;
        end;
        spAuto:
        begin
          if not StopScan then
          begin
            if CurrentAutoScanPurpose = spAll then
              ResetScanData
            else
            begin
              if CurrentAutoScanPurpose <> spNew then
              begin
                LastPartialScanDate := CurrentDate;
                Dec(LastPartialScansCounts);
                SaveScanData;
              end;
            end;
          end;
        end;
      end;
      NeedUpdate := (TotalScans > 0) or (CurrentScanPurpose = spNewBridges);
      if AutoScanStage = 2 then
      begin
        if (ConnectState <> 0) and NeedUpdate then
          AutoScanStage := 3
        else
          AutoScanStage := 0;
      end;
      if NeedUpdate then
      begin
        LoadConsensus;
        case CurrentScanPurpose of
          spNewBridges:
          begin
            if ConnectState = 0 then
              SetOptionsEnable(True);
            OptionsLocked := True;
            ApplyOptions(True);
          end;
          spAuto:
          begin
            AutoSelType := cbxAutoSelRoutersAfterScanType.ItemIndex;
            if (AutoSelType <> AUTOSEL_SCAN_DISABLED) and (NewBridgesStage = 0) then
            begin
              if (AutoSelType = AUTOSEL_SCAN_ANY) or
                ((AutoSelType = AUTOSEL_SCAN_FULL) and (CurrentAutoScanPurpose = spAll)) or
                ((AutoSelType = AUTOSEL_SCAN_PARTIAL) and (CurrentAutoScanPurpose <> spNew)) or
                ((AutoSelType = AUTOSEL_SCAN_NEW) and (CurrentAutoScanPurpose = spNew)) then
              begin
                OptionsLocked := True;
                if RoutersAutoSelect then
                  ApplyOptions(True)
                else
                  OptionsLocked := False;
              end;
            end;
          end;
        end;
        if ConnectState = 0 then
          SaveNetworkCache;
      end;
      ScanStage := 0;
      UpdateScannerControls;
      CurrentScanPurpose := spNone;
      CurrentAutoScanPurpose := spNone;
      CurrentScanType := stNone;
      InitScanType := stNone;
      StopScan := False;
      tmScanner.Enabled := False;
    end;
  end
  else
  begin
    if TotalScans > 0 then
    begin
      if StopScan then
        lbScanType.Caption := TransStr('404')
      else
      begin
        lbScanType.Caption := GetScanTypeStr;
        pbScanProgress.Max := TotalScans;
        pbScanProgress.Position := CurrentScans - ScanThreads;
        pbScanProgress.ProgressText := IntToStr(Round((CurrentScans - ScanThreads) / TotalScans * 100)) + ' %';
      end;
    end;
  end;
end;

procedure TTcp.tmTrafficTimer(Sender: TObject);
var
  CurrentDate: TDateTime;
  ini: TMemIniFile;
begin
  if ConnectState = 0 then
  begin
    DLSpeed := 0;
    ULSpeed := 0;
  end;
  Move(SpeedData[1], SpeedData[0], (MAX_SPEED_DATA_LENGTH - 1) * Sizeof(TSpeedData));
  SpeedData[MAX_SPEED_DATA_LENGTH - 1].DL := DLSpeed;
  SpeedData[MAX_SPEED_DATA_LENGTH - 1].UL := ULSpeed;

  lbDLSpeed.Caption := BytesFormat(DLSpeed) + '/' + TransStr('180');
  lbULSpeed.Caption := BytesFormat(ULSpeed) + '/' + TransStr('180');

  if UpdateTraffic then
  begin
    UpdateTraffic := False;
    pbTraffic.Repaint;
  end
  else
    UpdateTraffic := True;

  if miEnableTotalsCounter.Checked then
  begin
    CurrentDate := Now;
    if (CurrentDate >= (LastSaveStats + 600)) and TotalsNeedSave then
    begin
      ini := TMemIniFile.Create(UserConfigFile, TEncoding.UTF8);
      try
        SetSettings('Status', 'TotalDL', TotalDL, ini);
        SetSettings('Status', 'TotalUL', TotalUL, ini);
        LastSaveStats := DateTimeToUnix(CurrentDate);
        TotalsNeedSave := False;
      finally
        UpdateConfigFile(ini);
      end;
    end;
  end;
end;

procedure TTCp.LoadConsensus;
begin
  if not Assigned(Consensus) then
  begin
    Consensus := TConsensusThread.Create(True);
    Consensus.FreeOnTerminate := True;
    Consensus.Priority := tpNormal;
    Consensus.OnTerminate := TConsensusThreadTerminate;
    Consensus.Start;
  end;
end;

procedure TTcp.LoadDescriptors;
begin
  if not Assigned(Descriptors) then
  begin
    Descriptors := TDescriptorsThread.Create(True);
    Descriptors.FreeOnTerminate := True;
    Descriptors.Priority := tpNormal;
    Descriptors.OnTerminate := TDescriptorsThreadTerminate;
    Descriptors.Start;
  end;
end;

procedure TTcp.ShowFilter;
var
  FilterCount: Integer;
  Item: TPair<string, TFilterInfo>;
  cdTotal, cdUser, HideRow, IsExclude: Boolean;
  NodeTypes: TNodeTypes;
  CountryID: Byte;
begin
  FilterCount := 0;
  if sgFilter.SelRow = 0 then
    sgFilter.SelRow := 1;
  sgFilter.RowID := sgFilter.Cells[FILTER_ID, sgFilter.SelRow];
  BeginUpdateTable(sgFilter);
  ClearGrid(sgFilter, False);
  if (lbFilterEntry.Tag = 0) and (lbFilterMiddle.Tag = 0) and (lbFilterExit.Tag = 0) and (lbFilterExclude.Tag = 0) and not AlreadyStarted then
    HideRow := False
  else
    HideRow := miFilterHideUnused.Checked;
  for Item in FilterDic do
  begin
    CountryID := Item.Value.cc;
    if HideRow then
    begin
      if CountryTotals[TOTAL_RELAYS][CountryID] > 0 then
        cdTotal := True
      else
        cdTotal := False;

      if (Item.Value.Data = []) then
      begin
        if NodesDic.TryGetValue(Item.Key, NodeTypes) then
          cdUser := ntExclude in NodeTypes
        else
          cdUser := False;
      end
      else
        cdUser := True;
    end
    else
    begin
      cdTotal := True;
      cdUser := True;
    end;
    if cdTotal or cdUser then
    begin
      Inc(FilterCount);
      sgFilter.Cells[FILTER_ID, FilterCount] := UpperCase(Item.Key);
      sgFilter.Cells[FILTER_NAME, FilterCount] := TransStr(Item.Key);

      if CountryTotals[TOTAL_RELAYS][CountryID] > 0 then
        sgFilter.Cells[FILTER_TOTAL, FilterCount] := IntToStr(CountryTotals[TOTAL_RELAYS][CountryID])
      else
        sgFilter.Cells[FILTER_TOTAL, FilterCount] := NONE_CHAR;

      if CountryTotals[TOTAL_GUARDS][CountryID] > 0 then
        sgFilter.Cells[FILTER_GUARD, FilterCount] := IntToStr(CountryTotals[TOTAL_GUARDS][CountryID])
      else
        sgFilter.Cells[FILTER_GUARD, FilterCount] := NONE_CHAR;

      if CountryTotals[TOTAL_EXITS][CountryID] > 0 then
        sgFilter.Cells[FILTER_EXIT, FilterCount] := IntToStr(CountryTotals[TOTAL_EXITS][CountryID])
      else
        sgFilter.Cells[FILTER_EXIT, FilterCount] := NONE_CHAR;

      if CountryTotals[TOTAL_BRIDGES][CountryID] > 0 then
        sgFilter.Cells[FILTER_BRIDGE, FilterCount] := IntToStr(CountryTotals[TOTAL_BRIDGES][CountryID])
      else
        sgFilter.Cells[FILTER_BRIDGE, FilterCount] := NONE_CHAR;

      if CountryTotals[TOTAL_ALIVES][CountryID] > 0 then
        sgFilter.Cells[FILTER_ALIVE, FilterCount] := IntToStr(CountryTotals[TOTAL_ALIVES][CountryID])
      else
        sgFilter.Cells[FILTER_ALIVE, FilterCount] := NONE_CHAR;

      if CountryTotals[TOTAL_PING_COUNTS][CountryID] > 0 then
        sgFilter.Cells[FILTER_PING, FilterCount] := IntToStr(Round(CountryTotals[TOTAL_PING_SUM][CountryID] / CountryTotals[TOTAL_PING_COUNTS][CountryID])) + ' ' + TransStr('379')
      else
        sgFilter.Cells[FILTER_PING, FilterCount] := NONE_CHAR;

      IsExclude := False;
      if NodesDic.ContainsKey(Item.Key) then
        IsExclude := ntExclude in NodesDic.Items[Item.Key];

      if IsExclude then
        sgFilter.Cells[FILTER_EXCLUDE_NODES, FilterCount] := EXCLUDE_CHAR
      else
      begin
        if ntEntry in Item.Value.Data then
          sgFilter.Cells[FILTER_ENTRY_NODES, FilterCount] := SELECT_CHAR;
        if ntMiddle in Item.Value.Data then
          sgFilter.Cells[FILTER_MIDDLE_NODES, FilterCount] := SELECT_CHAR;
        if ntExit in Item.Value.Data then
          sgFilter.Cells[FILTER_EXIT_NODES, FilterCount] := SELECT_CHAR;
      end;
    end;
  end;
  if FilterCount > 0 then
    sgFilter.RowCount := FilterCount + 1
  else
    sgFilter.RowCount := 2;
  GridSort(sgFilter);
  SetGridLastCell(sgFilter, True, miFilterScrollTop.Checked);
  if cbEnablePingMeasure.Checked and cbEnableDetectAliveNodes.Checked then
    GridScrollCheck(sgFilter, FILTER_NAME, 268)
  else
  begin
    if cbEnablePingMeasure.Checked or cbEnableDetectAliveNodes.Checked then
      GridScrollCheck(sgFilter, FILTER_NAME, 324)
    else
      GridScrollCheck(sgFilter, FILTER_NAME, 380);
  end;
  EndUpdateTable(sgFilter);
  lbFilterCount.Caption := Format(TransStr('321'), [FilterCount, FilterDic.Count]);
end;

function TTcp.FindInRanges(IpStr: string; AddressType: TAddressType): string;
var
  CidrItem: TPair<string, TCidrInfo>;
begin
  Result := '';
  if IpStr = '' then
    Exit;
  if CidrsDic.Count > 0 then
  begin
    for CidrItem in CidrsDic do
    begin
      if IpInCidr(IpStr, CidrItem.Value, AddressType) then
        Result := Result + ',' + CidrItem.Key;
    end;
    Delete(Result, 1, 1);
  end;
end;

function TTcp.FindSelectedBridge(RouterID: string; Router: TRouterInfo): Boolean;
var
  BridgeInfo: TBridgeInfo;
begin
  Result := False;
  if UsedBridgesList.ContainsKey(Router.IPv4 + '|' + IntToStr(Router.Port)) then
    Result := True
  else
  begin
    if Router.IPv6 <> '' then
      Result := UsedBridgesList.ContainsKey(RemoveBrackets(Router.IPv6, True) + '|' + IntToStr(Router.Port))
    else
    begin
      if BridgesDic.TryGetValue(RouterID, BridgeInfo) then
      begin
        if BridgeInfo.Source <> '' then
          Result := UsedBridgesList.ContainsKey(RemoveBrackets(BridgeInfo.Source) + '|' + IntToStr(Router.Port)); 
      end;
    end;
  end;
end;

procedure TTcp.ShowRouters;
var
  RoutersCount, i, j: Integer;
  cdExit, cdGuard, cdAuthority, cdOther, cdBridge, cdFast, cdStable, cdV2Dir, cdHSDir, cdRecommended, cdDirMirror, cdAlive, cdConsensus: Boolean;
  cdRouterType, cdCountry, cdWeight, cdQuery, cdFavorites: Boolean;
  Item: TPair<string, TRouterInfo>;
  Transport: TPair<string, TTransportInfo>;
  CountryCode: string;
  CountryID: Byte;
  FindCountry, FindHash, FindIPv4, IsExclude, IsNativeBridge, IsSelectedBridge, WrongQuery, SelectedBridgeFound: Boolean;
  FindIPv4Cidr, Query, Temp: string;
  ParseStr, RangeStr: ArrOfStr;
  GeoIpInfo: TGeoIpInfo;
  BridgeInfo: TBridgeInfo;

  procedure SelectNodes(KeyStr: string; Exclude: Boolean);
  var
    i: Integer; 
  begin
    for i := ROUTER_ENTRY_NODES to ROUTER_EXIT_NODES do
    begin
      if TNodeType(i) in NodesDic.Items[KeyStr] then
      begin
        if sgRouters.Cells[i, RoutersCount] <> FAVERR_CHAR then
        begin
          if (sgRouters.Cells[i, RoutersCount] = NONE_CHAR) or Exclude then
            sgRouters.Cells[i, RoutersCount] := FAVERR_CHAR
          else
          begin
            if IsSelectedBridge then
            begin
              if i <> ROUTER_ENTRY_NODES then
                sgRouters.Cells[i, RoutersCount] := FAVERR_CHAR
            end
            else
              sgRouters.Cells[i, RoutersCount] := SELECT_CHAR
          end;
        end;
      end;
    end;
  end;

  function CheckRouterType(Menu: TMenuItem; Condition: Boolean): Boolean;
  begin
    if Menu.Enabled and Menu.Checked then
    begin
      Result := Condition;
      if miReverseConditions.Checked then
        Result := not Result;
    end
    else
      Result := True;
  end;

  function CheckNodesDic(KeyStr: string): Boolean;
  var
    NodeTypes: TNodeTypes;
  begin
    if NodesDic.TryGetValue(KeyStr, NodeTypes) then
    begin
      if NodeTypes <> [] then
      begin
        case RoutersCustomFilter of
          ENTRY_ID: Result := ntEntry in NodeTypes;
          MIDDLE_ID: Result := ntMiddle in NodeTypes;
          EXIT_ID: Result := ntExit in NodeTypes;
          EXCLUDE_ID: Result := ntExclude in NodeTypes;
          FAVORITES_ID: Result := (ntEntry in NodeTypes) or
            (ntMiddle in NodeTypes) or (ntExit in NodeTypes);
          else
            Result := False;
        end;
        Exit;
      end;
    end;
    Result := False;
  end;

begin
  if Assigned(Consensus) or Assigned(Descriptors) then
    Exit;
  WrongQuery := False;
  Query := StringReplace(Trim(edRoutersQuery.Text), ';', '', [rfReplaceAll]);
  if miRtFiltersQuery.Checked and (Query <> '') then
  begin
    case cbxRoutersQuery.ItemIndex of
      4,5:
      begin
        PortsDic.Clear;
        ParseStr := Explode(',', Query);
        Temp := '';
        for i := 0 to Length(ParseStr) - 1 do
        begin
          ParseStr[i] := Trim(ParseStr[i]);
          if ValidInt(ParseStr[i], 0, 65535) then
            PortsDic.AddOrSetValue(StrToInt(ParseStr[i]), 0)
          else
          begin
            RangeStr := Explode('-', ParseStr[i]);
            if Length(RangeStr) <> 2 then
              ParseStr[i] := ''
            else
            begin
              if ValidInt(RangeStr[0], 0, 65535) and ValidInt(RangeStr[1], 1, 65535) then
              begin
                if StrToInt(RangeStr[0]) <= StrToInt(RangeStr[1]) then
                begin
                  for j := StrToInt(RangeStr[0]) to StrToInt(RangeStr[1]) do
                    PortsDic.AddOrSetValue(j, 0);
                end
                else
                  ParseStr[i] := '';
              end
              else
                ParseStr[i] := '';
            end;
          end;
          if ParseStr[i] <> '' then
            Temp := Temp + ',' + ParseStr[i];
        end;
        Delete(Temp, 1, 1);
        Query := Temp;
      end;
      7:if not (ValidInt(Query, -1, 65535) or (CharInSet(AnsiChar(Query[1]), [NONE_CHAR, INFINITY_CHAR]) and (Length(Query) = 1))) then
          WrongQuery := True;
      8:
      begin
        if Query <> '-' then
        begin
          WrongQuery := True;
          TransportsList.Clear;
          for Transport in TransportsDic do
          begin
            if FindStr(Query, Transport.Key) then
            begin
              TransportsList.AddOrSetValue(Transport.Key, 0);
              WrongQuery := False;
            end;
          end;
        end;
      end;
      else
      begin
        try
          MatchesMask('', Query);
        except
          on E:Exception do
            WrongQuery := True;
        end;
      end;
    end;

    edRoutersQuery.Text := Query;
    edRoutersQuery.SelStart := Length(Query);
    if Query = '' then
      WrongQuery := True;
  end;
  
  RoutersCount := 0;
  if sgRouters.SelRow = 0 then
    sgRouters.SelRow := 1;

  sgRouters.RowID := sgRouters.Cells[ROUTER_ID, sgRouters.SelRow];
  BeginUpdateTable(sgRouters);
  ClearGrid(sgRouters, False);

  if not WrongQuery then
  begin
    for Item in RoutersDic do
    begin
      SelectedBridgeFound := False;
      FindIPv4Cidr := '';
      CountryID := GetCountryValue(Item.Value.IPv4);
      CountryCode := CountryCodes[CountryID];
      if miRtFiltersCountry.Checked then
      begin
        case cbxRoutersCountry.Tag of
          -1: cdCountry := True;
          -2: cdCountry := FilterDic.Items[CountryCode].Data <> [];
          else
            cdCountry := CountryID = cbxRoutersCountry.Tag;
        end;
      end
      else
        cdCountry := True;

      if miRtFiltersWeight.Checked then
        cdWeight := Item.Value.Bandwidth >= udRoutersWeight.Position * 1024
      else
        cdWeight := True;

      if miRtFiltersQuery.Checked and (Query <> '') then
      begin
        case cbxRoutersQuery.ItemIndex of
          0: cdQuery := FindStr(Query, Item.Key);
          1: cdQuery := FindStr(Query, Item.Value.Name);
          2: cdQuery := FindStr(Query, Item.Value.IPv4);
          3: cdQuery := FindStr(RemoveBrackets(Query, True), RemoveBrackets(Item.Value.IPv6, True));
          4: cdQuery := PortsDic.ContainsKey(Item.Value.Port);
          5: cdQuery := PortsDic.ContainsKey(Item.Value.DirPort);
          6: cdQuery := FindStr(Query, Item.Value.Version);
          7:
          begin
            if GeoIpDic.TryGetValue(Item.Value.IPv4, GeoIpInfo) then
            begin
              case AnsiChar(Query[1]) of
                NONE_CHAR: cdQuery := GeoIpInfo.ping = 0;
                INFINITY_CHAR: cdQuery := GeoIpInfo.ping = -1;
                else
                  cdQuery := (GeoIpInfo.ping <= StrToInt(Query)) and (GeoIpInfo.ping > 0);
              end;
            end
            else
              cdQuery := False;
          end;
          8:
          begin
            if BridgesDic.TryGetValue(Item.Key, BridgeInfo) then
            begin
              if Query <> '-' then
                cdQuery := TransportsList.ContainsKey(BridgeInfo.Transport)
              else
                cdQuery := BridgeInfo.Transport = '';
            end
            else
              cdQuery := False;
          end;
          else
            cdQuery := True;
        end;
      end
      else
        cdQuery := True;

      if miRtFiltersType.Checked then
      begin
        cdBridge := CheckRouterType(miShowBridge, rfBridge in Item.Value.Flags);
        cdAuthority := CheckRouterType(miShowAuthority, rfAuthority in Item.Value.Flags);
        cdExit := CheckRouterType(miShowExit, rfExit in Item.Value.Flags);
        cdGuard := CheckRouterType(miShowGuard, rfGuard in Item.Value.Flags);
        cdOther := CheckRouterType(miShowOther, not (rfExit in Item.Value.Flags) and not (rfGuard in Item.Value.Flags) and not (rfBridge in Item.Value.Flags) and not (rfAuthority in Item.Value.Flags));
        cdConsensus := CheckRouterType(miShowConsensus, rfRelay in Item.Value.Flags);
        cdFast := CheckRouterType(miShowFast, rfFast in Item.Value.Flags);
        cdStable := CheckRouterType(miShowStable, rfStable in Item.Value.Flags);
        cdHSDir := CheckRouterType(miShowHSDir, rfHSDir in Item.Value.Flags);
        cdDirMirror := CheckRouterType(miShowDirMirror, Item.Value.DirPort > 0);
        cdV2Dir := CheckRouterType(miShowV2Dir, rfV2Dir in Item.Value.Flags);
        cdAlive := CheckRouterType(miShowAlive, Item.Value.Params and ROUTER_ALIVE <> 0);
        cdRecommended := CheckRouterType(miShowRecommend, VersionsDic.ContainsKey(Item.Value.Version));

        cdRouterType := cdExit and cdGuard and cdBridge and cdAuthority and cdOther and cdConsensus and cdFast and cdStable and cdV2Dir and cdHSDir and cdDirMirror and cdRecommended and cdAlive;
      end
      else
        cdRouterType := True;

      case RoutersCustomFilter of
        ENTRY_ID..FAVORITES_ID:
        begin
          if CheckNodesDic(Item.Key) then
            cdFavorites := True
          else
          begin
            if CheckNodesDic(Item.Value.IPv4) then
              cdFavorites := True
            else
            begin
              if CheckNodesDic(CountryCode) then
                cdFavorites := True
              else
              begin
                FindIPv4Cidr := FindInRanges(Item.Value.IPv4, atIPv4Cidr);
                if FindIPv4Cidr <> '' then
                begin
                  cdFavorites := False;
                  ParseStr := Explode(',', FindIPv4Cidr);
                  for i := 0 to Length(ParseStr) - 1 do
                  begin
                    if not cdFavorites then
                      cdFavorites := CheckNodesDic(ParseStr[i])
                    else
                      Break;
                  end;
                end
                else
                  cdFavorites := False;
              end;
            end;
          end;
        end;
        BRIDGES_ID: cdFavorites := cbUseBridges.Checked and FindSelectedBridge(Item.Key, Item.Value);
        FALLBACK_DIR_ID: cdFavorites := cbUseFallbackDirs.Checked and (UsedFallbackDirs.ContainsKey(Item.Value.IPv4 + '|' + IntToStr(Item.Value.Port)));
        else
          cdFavorites := True;
      end;

      if cdRouterType and cdWeight and cdCountry and cdFavorites and cdQuery then
      begin
        Inc(RoutersCount);
        sgRouters.Cells[ROUTER_ID, RoutersCount] := Item.Key;
        sgRouters.Cells[ROUTER_NAME, RoutersCount] := Item.Value.Name;
        sgRouters.Cells[ROUTER_IP, RoutersCount] := Item.Value.IPv4;
        sgRouters.Cells[ROUTER_COUNTRY, RoutersCount] := TransStr(CountryCode);
        sgRouters.Cells[ROUTER_WEIGHT, RoutersCount] := BytesFormat(Item.Value.Bandwidth * 1024) + '/' + TransStr('180');
        sgRouters.Cells[ROUTER_PORT, RoutersCount] := IntToStr(Item.Value.Port);
        if Item.Value.Version <> '' then
          sgRouters.Cells[ROUTER_VERSION, RoutersCount] := Item.Value.Version
        else
          sgRouters.Cells[ROUTER_VERSION, RoutersCount] := NONE_CHAR;
        if GeoIpDic.TryGetValue(Item.Value.IPv4, GeoIpInfo) then
        begin
          if GeoIpInfo.ping > 0 then
            sgRouters.Cells[ROUTER_PING, RoutersCount] := IntToStr(GeoIpInfo.ping) + ' ' + TransStr('379')
          else
          begin
            if GeoIpInfo.ping < 0 then
              sgRouters.Cells[ROUTER_PING, RoutersCount] := INFINITY_CHAR
            else
              sgRouters.Cells[ROUTER_PING, RoutersCount] := NONE_CHAR;
          end;
        end
        else
          sgRouters.Cells[ROUTER_PING, RoutersCount] := NONE_CHAR;

        if Item.Value.Params = 0 then
          sgRouters.Cells[ROUTER_FLAGS, RoutersCount] := NONE_CHAR;

        IsNativeBridge := (rfBridge in Item.Value.Flags) and not (rfRelay in Item.Value.Flags);
        IsSelectedBridge := cbUseBridges.Checked and FindSelectedBridge(Item.Key, Item.Value);

        if not (rfGuard in Item.Value.Flags) or IsNativeBridge then
          sgRouters.Cells[ROUTER_ENTRY_NODES, RoutersCount] := NONE_CHAR;
        if not (rfExit in Item.Value.Flags) or (rfBadExit in Item.Value.Flags) or IsNativeBridge then
          sgRouters.Cells[ROUTER_EXIT_NODES, RoutersCount] := NONE_CHAR;
        if IsNativeBridge then
          sgRouters.Cells[ROUTER_MIDDLE_NODES, RoutersCount] := NONE_CHAR;

        FindHash := NodesDic.ContainsKey(Item.Key);
        FindCountry := NodesDic.ContainsKey(CountryCode);
        FindIPv4 := NodesDic.ContainsKey(Item.Value.IPv4);
        FindIPv4Cidr := FindInRanges(Item.Value.IPv4, atIPv4Cidr);
        IsExclude := False;

        if FindHash then
          if ntExclude in NodesDic.Items[Item.Key] then
            IsExclude := True;
        if FindCountry then
          if ntExclude in NodesDic.Items[CountryCode] then
            IsExclude := True;
        if FindIPv4 then
          if ntExclude in NodesDic.Items[Item.Value.IPv4] then
            IsExclude := True;
        if FindIPv4Cidr <> '' then
        begin
          ParseStr := Explode(',', FindIPv4Cidr);
          for i := 0 to Length(ParseStr) - 1 do
          begin
            if NodesDic.ContainsKey(ParseStr[i]) then
            begin
              if ntExclude in NodesDic.Items[ParseStr[i]] then
              begin
                IsExclude := True;
                Break;
              end;
            end;
          end;
        end;

        if IsExclude then
          sgRouters.Cells[ROUTER_EXCLUDE_NODES, RoutersCount] := EXCLUDE_CHAR;

        if IsSelectedBridge and not IsExclude then
        begin
          sgRouters.Cells[ROUTER_ENTRY_NODES, RoutersCount] := BOTH_CHAR;
          sgRouters.Cells[ROUTER_MIDDLE_NODES, RoutersCount] := NONE_CHAR;
          sgRouters.Cells[ROUTER_EXIT_NODES, RoutersCount] := NONE_CHAR;
        end;

        if FindHash then
          SelectNodes(Item.Key, IsExclude);
        if FindCountry then
          SelectNodes(CountryCode, IsExclude);
        if FindIPv4 then
          SelectNodes(Item.Value.IPv4, IsExclude);
        if FindIPv4Cidr <> '' then
        begin
          for i := 0 to Length(ParseStr) - 1 do
          begin
            if NodesDic.ContainsKey(ParseStr[i]) then
              SelectNodes(ParseStr[i], IsExclude);
          end;
        end;
      end;
    end;
  end;

  if RoutersCount > 0 then
    sgRouters.RowCount := RoutersCount + 1
  else
    sgRouters.RowCount := 2;

  GridSort(sgRouters);
  SetGridLastCell(sgRouters, True, miRoutersScrollTop.Checked);
  if cbEnablePingMeasure.Checked then
    GridScrollCheck(sgRouters, ROUTER_COUNTRY, 133)
  else
    GridScrollCheck(sgRouters, ROUTER_COUNTRY, 153);
  EndUpdateTable(sgRouters);
  lbRoutersCount.Caption := Format(TransStr('321'), [RoutersCount, RoutersDic.Count]);

  if PortsDic.Count > 0 then
    PortsDic.Clear;
  if TransportsList.Count > 0 then
    TransportsList.Clear;
end;


procedure TTcp.CheckCountryIndexInList;
var
  Index: Integer;
begin
  Index := cbxRoutersCountry.Items.IndexOfObject(TObject(cbxRoutersCountry.Tag));
  if Index = -1 then
  begin
    Index := 0;
    cbxRoutersCountry.Tag := -1;
  end;
  if cbxRoutersCountry.ItemIndex <> Index then
    cbxRoutersCountry.ItemIndex := Index;
end;

procedure TTcp.LoadFilterTotals;
var
  Item: TPair<string, TRouterInfo>;
  RouterInfo: TRouterInfo;
  Flags: TRouterFlags;
  GeoIpInfo: TGeoIpInfo;
  CountryID: Byte;
  ParseStr: ArrOfStr;
  i, j: Integer;
  NeedCount: Boolean;
begin
  AliveNodesCount := 0;
  PingNodesCount := 0;
  for j := 0 to MAX_TOTALS - 1 do
    for i := 0 to MAX_COUNTRIES - 1 do
      CountryTotals[j][i] := 0;

  for Item in RoutersDic do
  begin
    NeedCount := not miExcludeBridgesWhenCounting.Checked or (rfRelay in Item.Value.Flags);
    if GeoIpDic.TryGetValue(Item.Value.IPv4, GeoIpInfo) then
    begin
      CountryID := GeoIpInfo.cc;
      if (GeoIpInfo.ping > 0) and NeedCount then
      begin
        Inc(CountryTotals[TOTAL_PING_SUM][CountryID], GeoIpInfo.ping);
        Inc(CountryTotals[TOTAL_PING_COUNTS][CountryID]);
        Inc(PingNodesCount);
      end;
      if GeoIpInfo.ports <> '' then
      begin
        ParseStr := Explode('|', GeoIpInfo.ports);
        for i := 0 to Length(ParseStr) - 1 do
        begin
          if Pos(IntToStr(Item.Value.Port) + ':1', ParseStr[i]) = 1 then
          begin
            if NeedCount then
              Inc(CountryTotals[TOTAL_ALIVES][CountryID]);
            if Item.Value.Params and ROUTER_ALIVE = 0 then
            begin
              RouterInfo := Item.Value;
              Inc(RouterInfo.Params, ROUTER_ALIVE);
              RoutersDic.AddOrSetValue(Item.Key, RouterInfo);
              Inc(AliveNodesCount);
            end;
            Break;
          end;
        end;
      end;
    end
    else
      CountryID := DEFAULT_COUNTRY_ID;
    Flags := Item.Value.Flags;
    if NeedCount then
    begin
      Inc(CountryTotals[TOTAL_RELAYS][CountryID]);
      if rfGuard in Flags then
        Inc(CountryTotals[TOTAL_GUARDS][CountryID]);
      if rfExit in Flags then
        Inc(CountryTotals[TOTAL_EXITS][CountryID]);
    end;
    if rfBridge in Flags then
      Inc(CountryTotals[TOTAL_BRIDGES][CountryID]);
  end;
end;

procedure TTcp.LoadRoutersCountries;
var
  i: Integer;
  ls: TStringList;
  CountriesHash: Cardinal;
begin
  ls := TStringList.Create;
  try
    ls.AddObject(TransStr('347'), TObject(-1));
    ls.AddObject(TransStr('348'), TObject(-2));
    for i := 0 to MAX_COUNTRIES - 1 do
    begin
      if CountryTotals[TOTAL_RELAYS][i] > 0 then
        ls.AddObject(TransStr(CountryCodes[i]), TObject(i));
    end;
    CountriesHash := Crc32(AnsiString(ls.Text));
    if CountriesHash <> LastCountriesHash then
    begin
      LastCountriesHash := CountriesHash;
      cbxRoutersCountry.Items := ls;
    end;
  finally
    ls.Free;
  end;
  CheckCountryIndexInList;
end;

procedure TTcp.ShowCircuits(AlwaysUpdate: Boolean = True);
var
  CircuitsCount: Integer;
  Item: TPair<string, TCircuitInfo>;
  PurposeStr: string;
  TotalConnections: Integer;
begin
  if LockCircuits then
    Exit;
  if AlwaysUpdate or CircuitsUpdated then
  begin
    LockCircuits := True;
    CircuitsCount := 0;
    TotalConnections := 0;
    PurposeStr := '';
    if sgCircuits.SelRow = 0 then
      sgCircuits.SelRow := 1;
    sgCircuits.RowID := sgCircuits.Cells[CIRC_ID, sgCircuits.SelRow];
    BeginUpdateTable(sgCircuits);
    ClearGrid(sgCircuits, False);

    for Item in CircuitsDic do
    begin
      Inc(TotalConnections, Item.Value.Streams);
      if miHideCircuitsWithoutStreams.Checked then
      begin
        if Item.Value.Streams = 0 then
        begin
          if Item.Key = Circuit then
          begin
            if not miAlwaysShowExitCircuit.Checked then
              Continue;
          end
          else
            Continue;
        end;
      end;
      PurposeStr := '';
      if bfOneHop in Item.Value.BuildFlags then
      begin
        if miCircOneHop.Checked then
          PurposeStr := TransStr('331');
      end
      else
      begin
        case Item.Value.PurposeID of
          GENERAL:
          begin
            if bfInternal in Item.Value.BuildFlags then
            begin
              if miCircInternal.Checked then
                PurposeStr := TransStr('332');
            end
            else
            begin
              if miCircExit.Checked or (miAlwaysShowExitCircuit.Checked and (Item.Key = Circuit)) then
                PurposeStr := TransStr('333');
            end;
          end;
          HS_CLIENT_HSDIR: if miCircHsClientDir.Checked then PurposeStr := TransStr('334');
          HS_CLIENT_INTRO: if miCircHsClientIntro.Checked then PurposeStr := TransStr('335');
          HS_CLIENT_REND: if miCircHsClientRend.Checked then PurposeStr := TransStr('336');
          HS_SERVICE_HSDIR: if miCircHsServiceDir.Checked then PurposeStr := TransStr('337');
          HS_SERVICE_INTRO: if miCircHsServiceIntro.Checked then PurposeStr := TransStr('338');
          HS_SERVICE_REND: if miCircHsServiceRend.Checked then PurposeStr := TransStr('339');
          HS_VANGUARDS: if miCircHsVanguards.Checked then PurposeStr := TransStr('340');
          PATH_BIAS_TESTING: if miCircPathBiasTesting.Checked then PurposeStr := TransStr('341');
          TESTING: if miCircTesting.Checked then PurposeStr := TransStr('342');
          CIRCUIT_PADDING: if miCircCircuitPadding.Checked then PurposeStr := TransStr('343');
          MEASURE_TIMEOUT: if miCircMeasureTimeout.Checked then PurposeStr := TransStr('344');
          CONTROLLER_CIRCUIT: if miCircController.Checked then PurposeStr := TransStr('661');
          else
            if miCircOther.Checked then PurposeStr := TransStr('345');
        end;
      end;
      if PurposeStr <> '' then
      begin
        Inc(CircuitsCount);
        sgCircuits.Cells[CIRC_ID, CircuitsCount] := Item.Key;
        sgCircuits.Cells[CIRC_PURPOSE, CircuitsCount] := PurposeStr;
        sgCircuits.Cells[CIRC_PARAMS, CircuitsCount] := IntToStr(Item.Value.Flags) + '|' + IntToStr(Item.Value.PurposeID);
        sgCircuits.Cells[CIRC_BYTES_READ, CircuitsCount] := BytesFormat(Item.Value.BytesRead);
        sgCircuits.Cells[CIRC_BYTES_WRITTEN, CircuitsCount] := BytesFormat(Item.Value.BytesWritten);
        if Item.Value.Streams > 0 then
          sgCircuits.Cells[CIRC_STREAMS, CircuitsCount] := IntToStr(Item.Value.Streams)
        else
          sgCircuits.Cells[CIRC_STREAMS, CircuitsCount] := NONE_CHAR;
      end;
    end;
    if CircuitsCount > 0 then
      sgCircuits.RowCount := CircuitsCount + 1
    else
      sgCircuits.RowCount := 2;
    GridSort(sgCircuits);
    if SelectExitCircuit then
      FindInCircuits(Circuit, ExitNodeID)
    else
      SetGridLastCell(sgCircuits, False);
    CheckCircuitsControls(False);
    EndUpdateTable(sgCircuits);
    lbCircuitsCount.Caption := Format(TransStr('349'), [CircuitsCount, CircuitsDic.Count]);
    lbStreamsCount.Caption := TransStr('350') + ': ' + IntToStr(TotalConnections);

    LockCircuits := False;
    CircuitsUpdated := False;
  end;
  ShowCircuitInfo(sgCircuits.Cells[CIRC_ID, sgCircuits.SelRow]);
end;

procedure TTcp.ShowCircuitInfo(CircID: string);
var
  NodesCount, i: Integer;
  Router: TRouterInfo;
  NodesData: ArrOfStr;
  CountryCode: Byte;
  CircuitInfo: TCircuitInfo;
  GeoIpInfo: TGeoIpInfo;
  PingData: string;
begin
  if LockCircuitInfo then
    Exit;
  LockCircuitInfo := True;
  NodesCount := 0;
  BeginUpdateTable(sgCircuitInfo);
  ClearGrid(sgCircuitInfo, False);

  if CircuitsDic.TryGetValue(CircID, CircuitInfo) then
  begin
    NodesData := Explode(',', CircuitInfo.Nodes);
    for i := 0 to Length(NodesData) - 1 do
    begin
      PingData := NONE_CHAR;
      inc(NodesCount);
      if RoutersDic.TryGetValue(NodesData[i], Router) then
      begin
        CountryCode := GetCountryValue(Router.IPv4);
        sgCircuitInfo.Cells[CIRC_INFO_ID, NodesCount] := NodesData[i];
        sgCircuitInfo.Cells[CIRC_INFO_NAME, NodesCount] := Router.Name;
        if miShowPortAlongWithIp.Checked then
          sgCircuitInfo.Cells[CIRC_INFO_IP, NodesCount] := Router.IPv4 + ':' + IntToStr(Router.Port)
        else
          sgCircuitInfo.Cells[CIRC_INFO_IP, NodesCount] := Router.IPv4;
        sgCircuitInfo.Cells[CIRC_INFO_COUNTRY, NodesCount] := TransStr(CountryCodes[CountryCode]);
        sgCircuitInfo.Cells[CIRC_INFO_WEIGHT, NodesCount] := BytesFormat(Router.Bandwidth * 1024) + '/' + TransStr('180');
        if GeoIpDic.TryGetValue(Router.IPv4, GeoIpInfo) then
        begin
          if GeoIpInfo.ping > 0 then
            PingData := IntToStr(GeoIpInfo.ping) + ' ' + TransStr('379')
          else
          begin
            if GeoIpInfo.ping < 0 then
              PingData := INFINITY_CHAR;
          end;
        end;
      end
      else
      begin
        sgCircuitInfo.Cells[CIRC_INFO_ID, NodesCount] := NodesData[i];
        sgCircuitInfo.Cells[CIRC_INFO_NAME, NodesCount] := TransStr('260');
        sgCircuitInfo.Cells[CIRC_INFO_IP, NodesCount] := TransStr('260');
        sgCircuitInfo.Cells[CIRC_INFO_COUNTRY, NodesCount] := TransStr(CountryCodes[DEFAULT_COUNTRY_ID]);
        sgCircuitInfo.Cells[CIRC_INFO_WEIGHT, NodesCount] := BytesFormat(0) + '/' + TransStr('180');
      end;
      sgCircuitInfo.Cells[CIRC_INFO_PING, NodesCount] := PingData;
    end;
    lbCircPurpose.Caption := sgCircuits.Cells[CIRC_PURPOSE, sgCircuits.SelRow];
    lbDetailsTime.Caption := TransStr('221') + ': ' + DateTimeToStr(CircuitInfo.Date);
  end
  else
  begin
    lbCircPurpose.Caption := TransStr('662');
    lbDetailsTime.Caption := TransStr('221') + ': ' + TransStr('110');
    CheckCircuitExists(CircID);
  end;

  if NodesCount > 0 then
    sgCircuitInfo.RowCount := NodesCount + 1
  else
    sgCircuitInfo.RowCount := 2;
  EndUpdateTable(sgCircuitInfo);
  ShowStreams(CircID);
  LockCircuitInfo := False;
end;

procedure TTcp.CheckCircuitExists(CircID: string; UpdateStreamsCount: Boolean = False);
var
  Search, i: Integer;
begin
  if miCircuitsUpdateLow.Checked or miCircuitsUpdateManual.Checked or (ConnectState = 0) then
  begin
    Search := sgCircuits.Cols[CIRC_ID].IndexOf(CircID);
    if Search > 0 then
    begin
      sgCircuits.Cells[CIRC_STREAMS, Search] := EXCLUDE_CHAR;
      if (Search = sgCircuits.Row) and not IsEmptyGrid(sgStreams) then
      begin
        for i := 1 to sgStreams.RowCount - 1 do
          sgStreams.Cells[STREAMS_COUNT, i] := EXCLUDE_CHAR;
      end;
    end;
    if UpdateStreamsCount and not IsEmptyGrid(sgCircuits) then
      lbStreamsCount.Caption := TransStr('350') + ': ' + IntToStr(StreamsDic.Count);
  end;
end;

procedure TTcp.CheckCircuitStreams(CircID: string; TargetStreams: Integer);
var
  CircuitInfo: TCircuitInfo;
  i: Integer;
begin
  if miCircuitsUpdateLow.Checked or miCircuitsUpdateManual.Checked then
  begin
    if CircuitsDic.TryGetValue(CircID, CircuitInfo) then
    begin
      if CircuitInfo.Streams > 0 then
        sgCircuits.Cells[CIRC_STREAMS, sgCircuits.SelRow] := IntToStr(CircuitInfo.Streams)
      else
      begin
        sgCircuits.Cells[CIRC_STREAMS, sgCircuits.SelRow] := NONE_CHAR;
        if not IsEmptyGrid(sgStreams) then
          for i := 1 to sgStreams.RowCount - 1 do
            sgStreams.Cells[STREAMS_COUNT, i] := EXCLUDE_CHAR;
      end;
    end;

    if StrToIntDef(sgStreams.Cells[STREAMS_COUNT, sgStreams.SelRow], 0) > 0 then
    begin
      if TargetStreams = 0 then
        sgStreams.Cells[STREAMS_COUNT, sgStreams.SelRow] := EXCLUDE_CHAR
      else
        sgStreams.Cells[STREAMS_COUNT, sgStreams.SelRow] := IntToStr(TargetStreams);
    end;

    if not IsEmptyGrid(sgCircuits) then
      lbStreamsCount.Caption := TransStr('350') + ': ' + IntToStr(StreamsDic.Count);
  end;
end;

procedure TTcp.ShowStreams(CircID: string);
var
  StreamsCount, Search, i: Integer;
  Item: TPair<string, TStreamInfo>;
  Target, FoundStr: String;
  CircuitInfo: TCircuitInfo;
  ReadSum, WrittenSum: Int64;
begin
  if LockStreams then
    Exit;
  LockStreams := True;
  StreamsCount := 0;
  if sgStreams.SelRow = 0 then
    sgStreams.SelRow := 1;
  sgStreams.RowID := sgStreams.Cells[STREAMS_TARGET, sgStreams.SelRow];
  BeginUpdateTable(sgStreams);
  ClearGrid(sgStreams, False);
  if CircuitsDic.TryGetValue(CircID, CircuitInfo) then
  begin
    for Item in StreamsDic do
    begin
      if Item.Value.CircuitID = CircID then
      begin
        Target := Item.Value.Target;
        Search := -1;
        for i := 1 to StreamsCount do
          if sgStreams.Cells[STREAMS_TARGET, i] = Target then
          begin
            Search := i;
            Break;
          end;
        if Search > 0 then
        begin
          sgStreams.Cells[STREAMS_ID, Search] := Item.Key;
          sgStreams.Cells[STREAMS_COUNT, Search] := IntToStr(StrToIntDef(sgStreams.Cells[STREAMS_COUNT, Search], 0) + 1);
          ReadSum := FormatSizeToBytes(sgStreams.Cells[STREAMS_BYTES_READ, Search]) + Item.Value.BytesRead;
          WrittenSum := FormatSizeToBytes(sgStreams.Cells[STREAMS_BYTES_WRITTEN, Search]) + Item.Value.BytesWritten;
          sgStreams.Cells[STREAMS_BYTES_READ, Search] := BytesFormat(ReadSum);
          sgStreams.Cells[STREAMS_BYTES_WRITTEN, Search] := BytesFormat(WrittenSum);
        end
        else
        begin
          if FindTrackHost(Target) then
          begin
            if cbUseTrackHostExits.Checked then
              FoundStr := SELECT_CHAR
            else
              FoundStr := FAVERR_CHAR;
          end
          else
            FoundStr := NONE_CHAR;
          Inc(StreamsCount);
          sgStreams.Cells[STREAMS_ID, StreamsCount] := Item.Key;
          sgStreams.Cells[STREAMS_TARGET, StreamsCount] := Target;
          sgStreams.Cells[STREAMS_TRACK, StreamsCount] := FoundStr;
          sgStreams.Cells[STREAMS_COUNT, StreamsCount] := '1';
          sgStreams.Cells[STREAMS_BYTES_READ, StreamsCount] := BytesFormat(Item.Value.BytesRead);
          sgStreams.Cells[STREAMS_BYTES_WRITTEN, StreamsCount] := BytesFormat(Item.Value.BytesWritten);
        end;
      end;
    end;
  end;

  if StreamsCount > 0 then
    sgStreams.RowCount := StreamsCount + 1
  else
    sgStreams.RowCount := 2;

  GridSort(sgStreams);
  SetGridLastCell(sgStreams, False, False, False, -1, -1, 1);
  if miShowStreamsTraffic.Checked then
    GridScrollCheck(sgStreams, STREAMS_TARGET, 338)
  else
    GridScrollCheck(sgStreams, STREAMS_TARGET, 451);

  EndUpdateTable(sgStreams);
  ShowStreamsInfo(CircID, sgStreams.Cells[STREAMS_TARGET, sgStreams.SelRow]);
  LockStreams := False;
end;

procedure TTcp.ShowStreamsInfo(CircID, TargetStr: string);
var
  StreamsCount, i: Integer;
  Item: TPair<string, TStreamInfo>;
  PurposeStr, DestAddr: string;
  Target: TTarget;
  CircuitInfo: TCircuitInfo;
begin
  if LockStreamsInfo then
    Exit;
  LockStreamsInfo := True;
  StreamsCount := 0;
  DestAddr := '';
  if sgStreamsInfo.SelRow = 0 then
    sgStreamsInfo.SelRow := 1;
  sgStreamsInfo.RowID := sgStreamsInfo.Cells[STREAMS_INFO_ID, sgStreamsInfo.SelRow];
  BeginUpdateTable(sgStreamsInfo);
  ClearGrid(sgStreamsInfo, False);

  if CircuitsDic.TryGetValue(CircID, CircuitInfo) then
  begin
    if CircuitInfo.Streams > 0 then
    begin
      for Item in StreamsDic do
      begin
        if (Item.Value.CircuitID = CircID) and (Item.Value.Target = TargetStr) then
        begin
          Inc(StreamsCount);
          sgStreamsInfo.Cells[STREAMS_INFO_ID, StreamsCount] := Item.Key;
          if Item.Value.SourceAddr <> '' then
            sgStreamsInfo.Cells[STREAMS_INFO_SOURCE_ADDR, StreamsCount] := Item.Value.SourceAddr
          else
            sgStreamsInfo.Cells[STREAMS_INFO_SOURCE_ADDR, StreamsCount] := TransStr('376');

          if Item.Value.DestAddr <> '' then
          begin
            DestAddr := Item.Value.DestAddr;
            sgStreamsInfo.Cells[STREAMS_INFO_DEST_ADDR, StreamsCount] := DestAddr;
          end
          else
          begin
            if TryParseTarget(TargetStr, Target) then
            begin
              case Target.TargetType of
                ttExit: sgStreamsInfo.Cells[STREAMS_INFO_DEST_ADDR, StreamsCount] := Target.Hostname + ':' + Target.Port;
                ttOnion: sgStreamsInfo.Cells[STREAMS_INFO_DEST_ADDR, StreamsCount] := TransStr('122');
                else
                  sgStreamsInfo.Cells[STREAMS_INFO_DEST_ADDR, StreamsCount] := TransStr('401');
              end;
            end
            else
              sgStreamsInfo.Cells[STREAMS_INFO_DEST_ADDR, StreamsCount] := TransStr('401');
          end;

          case Item.Value.PurposeID of
            DIR_FETCH: PurposeStr := TransStr('370');
            DIR_UPLOAD: PurposeStr := TransStr('371');
            DIRPORT_TEST: PurposeStr := TransStr('372');
            DNS_REQUEST: PurposeStr := TransStr('373');
            USER:
            begin
              case Item.Value.Protocol of
                SOCKS4: PurposeStr := TransStr('594');
                SOCKS5: PurposeStr := TransStr('595');
                HTTPCONNECT: PurposeStr := TransStr('596');
                else
                  PurposeStr := TransStr('374');
              end;
            end;
            else
              PurposeStr := TransStr('375');
          end;
          sgStreamsInfo.Cells[STREAMS_INFO_PURPOSE, StreamsCount] := PurposeStr;
          sgStreamsInfo.Cells[STREAMS_INFO_BYTES_READ, StreamsCount] := BytesFormat(Item.Value.BytesRead);
          sgStreamsInfo.Cells[STREAMS_INFO_BYTES_WRITTEN, StreamsCount] := BytesFormat(Item.Value.BytesWritten);
        end;
      end;
    end;
  end;

  if StreamsCount > 0 then
  begin
    sgStreamsInfo.RowCount := StreamsCount + 1;
    if DestAddr <> '' then
    begin
      for i := 1 to sgStreamsInfo.RowCount - 1 do
        if sgStreamsInfo.Cells[STREAMS_INFO_DEST_ADDR, i] = TransStr('401') then
          sgStreamsInfo.Cells[STREAMS_INFO_DEST_ADDR, i] := DestAddr;
    end;
  end
  else
    sgStreamsInfo.RowCount := 2;

  GridSort(sgStreamsInfo);
  SetGridLastCell(sgStreamsInfo, False);
  if miShowStreamsTraffic.Checked then
    GridScrollCheck(sgStreamsInfo, STREAMS_INFO_PURPOSE, 134)
  else
    GridScrollCheck(sgStreamsInfo, STREAMS_INFO_PURPOSE, 177);
  EndUpdateTable(sgStreamsInfo);
  CheckCircuitStreams(CircID, StreamsCount);
  LockStreamsInfo := False;
end;

function TTcp.FindTrackHost(Host: string): Boolean;
var
  DotIndex: Integer;
begin
  if TrackHostDic.ContainsKey('.') then
  begin
    Result := True;
    Exit;
  end
  else
  begin
    Host := ExtractDomain(Host, True);
    if ValidHost(Host, True, True) then
    begin
      DotIndex := 1;
      while DotIndex > 0 do
      begin
        if TrackHostDic.ContainsKey(Host) then
        begin
          Result := True;
          Exit;
        end;
        DotIndex := Pos('.', Host, 2);
        if DotIndex <> -1 then
          Host := Copy(Host, DotIndex);
      end;
    end;
  end;
  Result := False;
end;

procedure TTcp.btnCreateProfileClick(Sender: TObject);
var
  Input: string;
begin
  Input := InputBox(TransStr('265'), TransStr('266') + ':', '');
  if Trim(Input) <> '' then
  begin
    CreateShortcut(ParamStr(0), '-profile="' + Input + '"', ExtractFileDir(ParamStr(0)),
      GetSystemDir(CSIDL_DESKTOPDIRECTORY) + '\TCP (' + Input + ').lnk', ParamStr(0));
  end;
end;

procedure TTcp.btnFindPreferredBridgeClick(Sender: TObject);
var
  Bridge: TBridge;
begin
  if TryParseBridge(Trim(edPreferredBridge.Text), Bridge) then
    FindInRouters(LastPreferBridgeID, FormatHost(Bridge.Ip) + ':' + IntToStr(Bridge.Port))
  else
    FindInRouters(LastPreferBridgeID);
end;

procedure TTcp.cbEnableSocksClick(Sender: TObject);
var
  State: Boolean;
begin
  State := cbEnableSocks.Checked;
  edSOCKSPort.Enabled := State;
  udSOCKSPort.Enabled := State;
  cbxSOCKSHost.Enabled := State;
  EnableOptionButtons;
end;

procedure TTcp.cbeRoutersCountrySelect(Sender: TObject);
begin
  ResetFocus;
end;

procedure TTcp.cbExcludeUnsuitableBridgesClick(Sender: TObject);
begin
  if not TCheckBox(Sender).Focused then
    Exit;
  BridgesUpdated := True;
  BridgesRecalculate := True;
  SaveBridgesData;
  EnableOptionButtons;
end;

procedure TTcp.cbAutoScanNewNodesClick(Sender: TObject);
begin
  if cbAutoScanNewNodes.Focused then
  begin
    CheckScannerControls;
    CheckStatusControls;
    EnableOptionButtons;
  end;
end;

procedure TTcp.cbCacheNewBridgesClick(Sender: TObject);
begin
  if not TCheckBox(Sender).Focused then
    Exit;
  BridgesCheckControls;
  EnableOptionButtons;
end;

procedure TTcp.cbDirCacheMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and (cbxServerMode.ItemIndex in [SERVER_MODE_RELAY, SERVER_MODE_EXIT]) and cbDirCache.Checked then
  begin
    if ShowMsg(TransStr('204'), '', mtWarning, True) then
    begin
      cbDirCache.Checked := False;
      EnableOptionButtons;
    end
    else
      cbDirCache.Checked := True;
  end
  else
    EnableOptionButtons;
end;

procedure TTcp.cbEnableNodesListClick(Sender: TObject);
begin
  if not cbEnableNodesList.Focused then
    Exit;
  GetFavoritesLabel(NodesToFavorites(cbxNodesListType.ItemIndex)).HelpContext := Integer(cbEnableNodesList.Checked);
  CheckNodesListControls;
  EnableOptionButtons;
end;

procedure TTcp.CheckScannerControls;
var
  PingState, AliveState, State, AutoState, TypeState: Boolean;
begin
  PingState := cbEnablePingMeasure.Checked;
  AliveState := cbEnableDetectAliveNodes.Checked;
  State := PingState or AliveState;
  AutoState := State and cbAutoScanNewNodes.Checked;
  TypeState := cbxAutoScanType.ItemIndex <> AUTOSCAN_NEW;

  edFullScanInterval.Enabled := AutoState;
  edPartialScanInterval.Enabled := AutoState and TypeState;
  edPartialScansCounts.Enabled := AutoState and TypeState;
  edScanPingTimeout.Enabled := PingState;
  edScanPortTimeout.Enabled := AliveState;
  edDelayBetweenAttempts.Enabled := State;
  edScanPortAttempts.Enabled := AliveState;
  edScanPingAttempts.Enabled := PingState;
  edScanMaxThread.Enabled := State;
  edScanPortionTimeout.Enabled := State;
  edScanPortionSize.Enabled := State;
  udFullScanInterval.Enabled := AutoState;
  udPartialScanInterval.Enabled := AutoState and TypeState;
  udPartialScansCounts.Enabled := AutoState and TypeState;
  udScanPingTimeout.Enabled := PingState;
  udScanPortTimeout.Enabled := AliveState;
  udDelayBetweenAttempts.Enabled := State;
  udScanPortAttempts.Enabled := AliveState;
  udScanPingAttempts.Enabled := PingState;
  udScanMaxThread.Enabled := State;
  udScanPortionTimeout.Enabled := State;
  udScanPortionSize.Enabled := State;
  lbFullScanInterval.Enabled := AutoState;
  lbHours1.Enabled := AutoState;
  lbPartialScanInterval.Enabled := AutoState and TypeState;
  lbHours2.Enabled := AutoState and TypeState;
  lbPartialScansCounts.Enabled := AutoState and TypeState;
  lbScanPingTimeout.Enabled := PingState;
  lbMiliseconds1.Enabled := PingState;
  lbScanPortTimeout.Enabled := AliveState;
  lbMiliseconds2.Enabled := AliveState;
  lbDelayBetweenAttempts.Enabled := State;
  lbMiliseconds3.Enabled := State;
  lbScanPortAttempts.Enabled := AliveState;
  lbScanPingAttempts.Enabled := PingState;
  lbScanMaxThread.Enabled := State;
  lbScanPortionTimeout.Enabled := State;
  lbMiliseconds4.Enabled := State;
  lbScanPortionSize.Enabled := State;
  lbAutoSelRoutersAfterScanType.Enabled := AutoState;
  lbAutoScanType.Enabled := AutoState;
  cbxAutoSelRoutersAfterScanType.Enabled := AutoState;
  cbxAutoScanType.Enabled := AutoState;
  cbAutoScanNewNodes.Enabled := State;

  if PingState and AliveState then
  begin
    sgFilter.ColWidths[FILTER_ALIVE] := Round(55 * Scale);
    sgFilter.ColWidths[FILTER_PING] := Round(55 * Scale);
    GridScrollCheck(sgFilter, FILTER_NAME, 268);
  end
  else
  begin
    if PingState and not AliveState then
    begin
      sgFilter.ColWidths[FILTER_ALIVE] := -1;
      sgFilter.ColWidths[FILTER_PING] := Round(55 * Scale);
      GridScrollCheck(sgFilter, FILTER_NAME, 324);
    end
    else
    begin
      if AliveState and not PingState then
      begin
        sgFilter.ColWidths[FILTER_ALIVE] := Round(55 * Scale);
        sgFilter.ColWidths[FILTER_PING] := -1;
        GridScrollCheck(sgFilter, FILTER_NAME, 324);
      end
      else
      begin
        sgFilter.ColWidths[FILTER_ALIVE] := -1;
        sgFilter.ColWidths[FILTER_PING] := -1;
        GridScrollCheck(sgFilter, FILTER_NAME, 380);
      end;
    end;
  end;

  if PingState then
  begin
    sgCircuitInfo.ColWidths[CIRC_INFO_NAME] := Round(120 * Scale);
    sgCircuitInfo.ColWidths[CIRC_INFO_IP] := Round(130 * Scale);
    sgCircuitInfo.ColWidths[CIRC_INFO_COUNTRY] := Round(114 * Scale);
    sgCircuitInfo.ColWidths[CIRC_INFO_PING] := Round(48 * Scale);
    sgRouters.ColWidths[ROUTER_NAME] := Round(106 * Scale);
    sgRouters.ColWidths[ROUTER_IP] := Round(88 * Scale);
    sgRouters.ColWidths[ROUTER_PING] := Round(44 * Scale);
    GridScrollCheck(sgRouters, ROUTER_COUNTRY, 133);
  end
  else
  begin
    sgCircuitInfo.ColWidths[CIRC_INFO_NAME] := Round(135 * Scale);
    sgCircuitInfo.ColWidths[CIRC_INFO_IP] := Round(145 * Scale);
    sgCircuitInfo.ColWidths[CIRC_INFO_COUNTRY] := Round(134 * Scale);
    sgCircuitInfo.ColWidths[CIRC_INFO_PING] := -1;
    sgRouters.ColWidths[ROUTER_NAME] := Round(121 * Scale);
    sgRouters.ColWidths[ROUTER_IP] := Round(98 * Scale);
    sgRouters.ColWidths[ROUTER_PING] := Round(-1 * Scale);
    GridScrollCheck(sgRouters, ROUTER_COUNTRY, 153);
  end;
end;

procedure TTcp.cbEnablePingMeasureClick(Sender: TObject);
begin
  if cbEnablePingMeasure.Focused then
  begin
    CheckScannerControls;
    CheckStatusControls;
    if cbEnablePingMeasure.Checked and (RoutersDic.Count > 0) then
      ConsensusUpdated := True;
    EnableOptionButtons;
  end;
end;

procedure TTcp.cbEnableDetectAliveNodesClick(Sender: TObject);
begin
  if cbEnableDetectAliveNodes.Focused then
  begin
    if cbUseBridges.Checked and cbExcludeUnsuitableBridges.Checked and cbUseBridgesLimit.Checked and cbCacheNewBridges.Checked then
      BridgesCheckControls;
    CheckScannerControls;
    CheckStatusControls;
    if cbEnableDetectAliveNodes.Checked and (RoutersDic.Count > 0) then
      ConsensusUpdated := True;     
    EnableOptionButtons;
  end;
end;

procedure TTcp.cbEnableHttpClick(Sender: TObject);
var
  State: Boolean;
begin
  State := cbEnableHttp.Checked;
  edHTTPTunnelPort.Enabled := State;
  udHTTPTunnelPort.Enabled := State;
  cbxHTTPTunnelHost.Enabled := State;
  EnableOptionButtons;
end;

procedure TTcp.cbHsMaxStreamsClick(Sender: TObject);
begin
  if not TCheckBox(Sender).Focused then
    Exit;
  HsMaxStreamsEnable(cbHsMaxStreams.Checked);
  ChangeHsTable(2);
end;

procedure TTcp.CountTotalFallbackDirs(ShowSuitableCount: Boolean = True);
var
  NumStr: string;
  FallbackCount: Integer;
begin
  FallbackCount := meFallbackDirs.Lines.Count;
  if cbExcludeUnsuitableFallbackDirs.Checked then
  begin
    if ShowSuitableCount then
      NumStr := IntToStr(SuitableFallbackDirsCount)
    else
      NumStr := INFINITY_CHAR;
    lbTotalFallbackDirs.Caption := Format(TransStr('632'), [NumStr, FallbackCount]);
  end
  else
    lbTotalFallbackDirs.Caption := TransStr('203') + ': ' + IntToStr(FallbackCount);
  lbFavoritesFallbackDirs.Caption := IntToStr(UsedFallbackDirsCount)
end;

procedure TTcp.CountTotalBridges(ShowSuitableCount: Boolean = True);
var
  NumStr: string;
  BridgesCount: Integer;
begin
  BridgesCount := meBridges.Lines.Count;
  if cbExcludeUnsuitableBridges.Checked then
  begin
    if ShowSuitableCount then
      NumStr := IntToStr(SuitableBridgesCount)
    else
      NumStr := INFINITY_CHAR;
    lbTotalBridges.Caption := Format(TransStr('632'), [NumStr, BridgesCount])
  end
  else
    lbTotalBridges.Caption := TransStr('203') + ': ' + IntToStr(BridgesCount);
  lbFavoritesBridges.Caption := IntToStr(UsedBridgesCount);
end;

procedure TTcp.meBridgesChange(Sender: TObject);
begin
  if not meBridges.Focused and (CurrentScanPurpose <> spUserBridges) and (ConnectState <> 1) then
    Exit;
  BridgesUpdated := True;
  BridgesRecalculate := True;
  if cbxBridgesType.ItemIndex = BRIDGES_TYPE_FILE then
    BridgesFileNeedSave := True;
  if not CtrlKeyPressed(AnsiChar(VK_RETURN)) then
    CountTotalBridges(SortUpdated);
  EnableOptionButtons;
end;

procedure TTcp.meBridgesExit(Sender: TObject);
begin
  if BridgesRecalculate then
    SaveBridgesData;
end;

procedure TTcp.meBridgesKeyPress(Sender: TObject; var Key: Char);
begin
  if CtrlKeyPressed(AnsiChar(VK_RETURN)) then
  begin
    Key := #0;
    if BridgesRecalculate then
      SaveBridgesData;
  end;
end;

procedure TTcp.meFallbackDirsChange(Sender: TObject);
begin
  if not meFallbackDirs.Focused and (CurrentScanPurpose <> spUserFallbackDirs) then
    Exit;
  FallbackDirsUpdated := True;
  FallbackDirsRecalculate := True;
  if not CtrlKeyPressed(AnsiChar(VK_RETURN)) then
    CountTotalFallbackDirs(SortUpdated);
  EnableOptionButtons;
end;

procedure TTcp.meFallbackDirsExit(Sender: TObject);
begin
  if FallbackDirsRecalculate then
    SaveFallbackDirsData;
end;

procedure TTcp.meFallbackDirsKeyPress(Sender: TObject; var Key: Char);
begin
  if CtrlKeyPressed(AnsiChar(VK_RETURN)) then
  begin
    Key := #0;
    if FallbackDirsRecalculate then
      SaveFallbackDirsData;
  end;
end;

procedure TTcp.meLogMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    LogHasSel := meLog.SelLength <> 0;
end;

procedure TTcp.SaveSortData;
begin
  SetConfigString('Main', 'SortData',
    IntToStr(sgFilter.SortType) + ',' + IntToStr(sgFilter.SortCol) + ',' +
    IntToStr(sgRouters.SortType) + ',' + IntToStr(sgRouters.SortCol) + ',' +
    IntToStr(sgCircuits.SortType) + ',' + IntToStr(sgCircuits.SortCol) + ',' +
    IntToStr(sgStreams.SortType) + ',' + IntToStr(sgStreams.SortCol) + ',' +
    IntToStr(sgStreamsInfo.SortType) + ',' + IntToStr(sgStreamsInfo.SortCol)
  );
end;

procedure TTcp.GridSort(aSg: TStringGrid);
var
  aCompare: TStringListSortCompare;
  aCol: Integer;
begin
  case aSg.ColsDataType[aSg.SortCol] of
    dtInteger:
      if aSg.SortType = SORT_ASC then aCompare := CompIntAsc else aCompare := CompIntDesc;
    dtSize:
      if aSg.SortType = SORT_ASC then aCompare := CompSizeAsc else aCompare := CompSizeDesc;
    dtParams:
      if aSg.SortType = SORT_ASC then aCompare := CompParamsAsc else aCompare := CompParamsDesc;
    dtFlags:
      if aSg.SortType = SORT_ASC then aCompare := CompFlagsAsc else aCompare := CompFlagsDesc;
    else
      if aSg.SortType = SORT_ASC then aCompare := CompTextAsc else aCompare := CompTextDesc;
  end;
  case aSg.ColsDataType[aSg.SortCol] of
    dtParams: aCol := 0;
     dtFlags: aCol := CIRC_PARAMS;
    else
      aCol := aSg.SortCol;
  end;
  sgSort(aSg, aCol, aCompare);
end;

procedure TTcp.SortPrepare(aSg: TStringGrid; ACol: Integer; ManualSort: Boolean = False);
var
  ScrollTop: Boolean;
begin
  if aSg.SortCol = ACol then
  begin
    case aSg.SortType of
      SORT_ASC: aSg.SortType := SORT_DESC;
      SORT_DESC: aSg.SortType := SORT_ASC;
    end;
  end
  else
    aSg.SortType := SORT_ASC;
  aSg.SortCol := ACol;
  aSg.RowID := aSg.Cells[0, aSg.SelRow];

  GridSort(aSg);
  case aSg.Tag of
    GRID_FILTER: ScrollTop := miFilterScrollTop.Checked;
    GRID_ROUTERS: ScrollTop := miRoutersScrollTop.Checked;
    else
      ScrollTop := False;
  end;
  SetGridLastCell(aSg, True, ScrollTop, ManualSort);
  SaveSortData;
end;

procedure TTcp.SelectCircuitsSort(Sender: TObject);
begin
  TMenuItem(Sender).Checked := True;
  SortPrepare(sgCircuits, TMenuItem(Sender).Tag);
end;

procedure TTcp.sgCircuitsFixedCellClick(Sender: TObject; ACol, ARow: Integer);
begin
  miCircuitsSort.Items[ACol].Checked := True;
  SortPrepare(sgCircuits, ACol, True);
end;

procedure TTcp.SelectStreamsSort(Sender: TObject);
begin
  TMenuItem(Sender).Checked := True;
  SortPrepare(sgStreams, TMenuItem(Sender).Tag);
end;

procedure TTcp.SelectStreamsInfoSort(Sender: TObject);
begin
  TMenuItem(Sender).Checked := True;
  SortPrepare(sgStreamsInfo, TMenuItem(Sender).Tag);
end;

procedure TTcp.sgStreamsFixedCellClick(Sender: TObject; ACol, ARow: Integer);
begin
  miStreamsSort.Items[ACol].Checked := True;
  SortPrepare(sgStreams, ACol, True);
end;

procedure TTcp.meNodesListChange(Sender: TObject);
begin
  lbTotalNodesList.Caption := TransStr('203') + ': ' + IntToStr(meNodesList.Lines.Count);
  if not meNodesList.Focused then
    Exit;
  NodesListStage := 1;
  EnableOptionButtons;
end;

procedure TTcp.meNodesListExit(Sender: TObject);
begin
  if NodesListStage = 1 then
    SaveNodesList(cbxNodesListType.ItemIndex);
end;

procedure TTcp.meNodesListKeyPress(Sender: TObject; var Key: Char);
begin
  if CtrlKeyPressed(AnsiChar(VK_RETURN)) then
  begin
    Key := #0;
    if NodesListStage = 1 then
      SaveNodesList(cbxNodesListType.ItemIndex);
  end;
end;

procedure TTcp.meMyFamilyChange(Sender: TObject);
begin
  lbTotalMyFamily.Caption := TransStr('203') + ': ' + IntToStr(meMyFamily.Lines.Count);
  EnableOptionButtons;
end;

procedure TTcp.ServerControlsChange(Sender: TObject);
begin
  if TWinControl(Sender).Focused then
  begin
    CheckServerControls;
    EnableOptionButtons;
  end;
end;

procedure TTcp.cbNoDesktopBordersClick(Sender: TObject);
begin
  cbNoDesktopBordersOnlyEnlarged.Enabled := cbNoDesktopBorders.Checked;
  EnableOptionButtons;
end;

procedure TTcp.cbUseReachableAddressesClick(Sender: TObject);
var
  State: Boolean;
begin
  State := cbUseReachableAddresses.Checked;
  edReachableAddresses.Enabled := State;
  lbReachableAddresses.Enabled := State;
  if cbUseReachableAddresses.Focused then
  begin
    BridgesUpdated := True;
    SaveBridgesData;
    FallbackDirsUpdated := True;
    SaveFallbackDirsData;
  end;
  EnableOptionButtons;
end;

procedure TTcp.cbxRoutersCountryChange(Sender: TObject);
begin
  if cbxRoutersCountry.ItemIndex <> -1 then
  begin
    cbxRoutersCountry.Tag := Integer(cbxRoutersCountry.Items.Objects[cbxRoutersCountry.ItemIndex]);
    ShowRouters;
    SaveRoutersFilterdata;
  end;
end;

procedure TTcp.cbxRoutersCountryEnter(Sender: TObject);
begin
  ActivateKeyboardLayout(CurrentLanguage, 0);
end;

procedure TTcp.cbxRoutersQueryChange(Sender: TObject);
begin
  SaveRoutersFilterdata(False, False);
end;

procedure TTcp.cbShowBalloonHintClick(Sender: TObject);
begin
  cbShowBalloonOnlyWhenHide.Enabled := cbShowBalloonHint.Checked;
  EnableOptionButtons;
end;

procedure TTcp.cbStayOnTopClick(Sender: TObject);
begin
  if cbStayOnTop.Checked then
    FormStyle := fsStayOnTop
  else
    FormStyle := fsNormal;
  EnableOptionButtons;
end;

procedure TTcp.cbUseTrackHostExitsClick(Sender: TObject);
var
  State: Boolean;
begin
  State := cbUseTrackHostExits.Checked;
  edTrackHostExitsExpire.Enabled := State;
  udTrackHostExitsExpire.Enabled := State;
  meTrackHostExits.Enabled := State;
  lbTrackHostExitsExpire.Enabled := State;
  lbSeconds4.Enabled := State;
  lbTotalHosts.Enabled := State;
  EnableOptionButtons;
end;

function TTcp.PreferredBridgeFound: Boolean;
var
  Bridge: TBridge;
  Str: string;
begin
  LastPreferBridgeID := '';
  if TryParseBridge(Trim(edPreferredBridge.Text), Bridge) then
  begin
    if Bridge.Hash = '' then
    begin
      if CompBridgesDic.TryGetValue(Bridge.Ip, Str) then
        LastPreferBridgeID := Str
      else
        LastPreferBridgeID := GetRouterBySocket(FormatHost(Bridge.Ip) + ':' + IntToStr(Bridge.Port));
    end
    else
    begin
      if RoutersDic.ContainsKey(Bridge.Hash) then
        LastPreferBridgeID := Bridge.Hash;
    end;
  end;
  Result := LastPreferBridgeID <> '';
end;

procedure TTcp.FallbackDirsCheckControls;
var
  State, BuiltinState, FallbackDirsIsBuiltin: Boolean;
begin
  State := cbUseFallbackDirs.Checked;
  FallbackDirsIsBuiltin := cbxFallbackDirsType.ItemIndex = FALLBACK_TYPE_BUILTIN;
  BuiltinState := State and FallbackDirsIsBuiltin and (meFallbackDirs.Lines.Count > 0);

  cbxFallbackDirsType.Enabled := State;
  cbExcludeUnsuitableFallbackDirs.Enabled := State;
  meFallbackDirs.Enabled := BuiltinState or (State and not FallbackDirsIsBuiltin);
  meFallbackDirs.ReadOnly := FallbackDirsIsBuiltin;
  lbFallbackDirsType.Enabled := State;
  lbTotalFallbackDirs.Enabled := State;
end;

procedure TTcp.BridgesCheckControls;
var
  State, BuiltinState, LimitState, PreferredState, UnsuitableState, QueueState, NewState,
  FileState, BridgeIsFile, BridgeIsBuiltin: Boolean;
begin
  if cbUseBridges.HelpContext = 1 then
    Exit;
  BridgeIsFile := cbxBridgesType.ItemIndex = BRIDGES_TYPE_FILE;
  BridgeIsBuiltin := cbxBridgesType.ItemIndex = BRIDGES_TYPE_BUILTIN;
  State := cbUseBridges.Checked;
  PreferredState := State and cbUsePreferredBridge.Checked;
  UnsuitableState := State and cbExcludeUnsuitableBridges.Checked;
  NewState := cbUsePreferredBridge.Checked or cbUseBridgesLimit.Checked;
  LimitState := State and cbUseBridgesLimit.Checked and not cbUsePreferredBridge.Checked;
  QueueState := UnsuitableState and NewState and cbCacheNewBridges.Checked;
  BuiltinState := State and BridgeIsBuiltin and (cbxBridgesList.Items.Count > 0);
  FileState := State and BridgeIsFile;
  
  edBridgesLimit.Enabled := LimitState;
  edBridgesQueueSize.Enabled := QueueState;
  edMaxDirFails.Enabled := UnsuitableState;
  edBridgesCheckDelay.Enabled := UnsuitableState;
  edBridgesFile.Text := BridgesFileName;
  edBridgesFile.Visible := BridgeIsFile;
  edBridgesFile.Enabled := FileState;
  edPreferredBridge.Enabled := PreferredState;
  cbxBridgesType.Enabled := State;
  cbxBridgesList.Visible := not BridgeIsFile;
  cbxBridgesList.Enabled := BuiltinState;
  cbxBridgesPriority.Enabled := LimitState;
  cbExcludeUnsuitableBridges.Enabled := State;
  cbUseBridgesLimit.Enabled := State and not cbUsePreferredBridge.Checked;
  cbCacheNewBridges.Enabled := UnsuitableState and NewState;
  cbScanNewBridges.Enabled := UnsuitableState and cbCacheNewBridges.Checked and NewState and cbEnableDetectAliveNodes.Checked;
  cbUsePreferredBridge.Enabled := State;
  udBridgesLimit.Enabled := LimitState;
  udBridgesQueueSize.Enabled := QueueState;
  udMaxDirFails.Enabled := UnsuitableState;
  udBridgesCheckDelay.Enabled := UnsuitableState;
  meBridges.Enabled := BuiltinState or (State and not BridgeIsBuiltin);
  meBridges.ReadOnly := BridgeIsBuiltin;
  btnFindPreferredBridge.Enabled := PreferredState and PreferredBridgeFound;
  lbBridgesType.Enabled := State;
  lbBridgesSubType.Enabled := BuiltinState or FileState;
  if BridgeIsFile then
    lbBridgesSubType.Caption := TransStr('647')
  else
    lbBridgesSubType.Caption := TransStr('419');
  lbTotalBridges.Enabled := State;
  lbBridgesLimit.Enabled := LimitState;
  lbBridgesPriority.Enabled := LimitState;
  lbBridgesQueueSize.Enabled := QueueState;
  lbCount5.Enabled := QueueState;
  lbMaxDirFails.Enabled := UnsuitableState;
  lbBridgesCheckDelay.Enabled := UnsuitableState;
  lbCount4.Enabled := UnsuitableState;
  lbSeconds5.Enabled := UnsuitableState;
  lbPreferredBridge.Enabled := PreferredState;
  imBridgesFile.Visible := BridgeIsFile;
  imBridgesFile.Enabled := FileState;
  imBridgesFile.ShowHint := BridgeIsFile and cbUseBridges.Checked;
  if not PreferredState then
    LastPreferBridgeID := '';
end;

procedure TTcp.cbUseBridgesClick(Sender: TObject);
begin
  if not cbUseBridges.Focused then
    Exit;
  BridgesUpdated := True;
  BridgesRecalculate := True;
  BridgesCheckControls;
  EnableOptionButtons;
end;

procedure TTcp.cbUseBridgesLimitClick(Sender: TObject);
begin
  if not TCheckBox(Sender).Focused then
    Exit;
  BridgesUpdated := True;
  BridgesRecalculate := True;
  BridgesCheckControls;
  EnableOptionButtons;
end;

procedure TTcp.UseDirPortEnable(State: Boolean);
begin
  edDirPort.Enabled := State;
  udDirPort.Enabled := State;
  if State then
  begin
    cbDirCache.Checked := True;
    cbDirCache.Enabled := False;
  end
  else
  begin
    if cbxServerMode.ItemIndex > SERVER_MODE_NONE then
      cbDirCache.Enabled := True
    else
      cbDirCache.Enabled := False;
  end;
  lbDirPort.Enabled := State;
end;

procedure TTcp.cbUseFallbackDirsClick(Sender: TObject);
begin
  FallbackDirsUpdated := True;
  FallbackDirsRecalculate := True;
  FallbackDirsCheckControls;
  EnableOptionButtons;
end;

procedure TTcp.cbUseHiddenServiceVanguardsClick(Sender: TObject);
var
  State: Boolean;
begin
  State := cbUseHiddenServiceVanguards.Checked;
  cbxVanguardLayerType.Enabled := State;
  lbVanguardLayerType.Enabled := State;
  if cbUseHiddenServiceVanguards.Focused then
    EnableOptionButtons;
end;

procedure TTcp.cbUseOpenDNSClick(Sender: TObject);
begin
  cbUseOpenDNSOnlyWhenUnknown.Enabled := cbUseOpenDNS.Checked;
  OpenDNSUpdated := True;
  EnableOptionButtons;    
end;

procedure TTcp.cbUseOpenDNSOnlyWhenUnknownClick(Sender: TObject);
begin
  OpenDNSUpdated := True;
  EnableOptionButtons;  
end;

procedure TTcp.ProxyParamCheck;
var
  State: Boolean;
begin
  State := cbxProxyType.ItemIndex <> PROXY_TYPE_SOCKS4;
  edProxyUser.Enabled := State;
  edProxyPassword.Enabled := State;
  if not State then
  begin
    edProxyUser.Text := '';
    edProxyPassword.Text := '';
  end;
  lbProxyUser.Enabled := State;
  lbProxyPassword.Enabled := State;
end;

procedure TTcp.cbxProxyTypeChange(Sender: TObject);
begin
  ProxyParamCheck;
  EnableOptionButtons;
end;

procedure TTcp.cbUsePreferredBridgeClick(Sender: TObject);
begin
  if not TCheckBox(Sender).Focused then
    Exit;
  BridgesUpdated := True;
  BridgesRecalculate := True;
  BridgesCheckControls;
  EnableOptionButtons;
end;

procedure TTcp.cbUseProxyClick(Sender: TObject);
var
  State: Boolean;
begin
  State := cbUseProxy.Checked;
  edProxyAddress.Enabled := State;
  edProxyPort.Enabled := State;
  udProxyPort.Enabled := State;
  cbxProxyType.Enabled := State;
  if State then
    ProxyParamCheck
  else
  begin
    edProxyUser.Enabled := False;
    edProxyPassword.Enabled := False;
    lbProxyUser.Enabled := False;
    lbProxyPassword.Enabled := False;
  end;
  lbProxyType.Enabled := State;
  lbProxyAddress.Enabled := State;
  lbProxyPort.Enabled := State;
  EnableOptionButtons;
end;

procedure TTcp.CheckAuthMetodContols;
var
  State: Boolean;
begin
  State := cbxAuthMetod.ItemIndex = 1;
  edControlPassword.PasswordChar := '*';
  edControlPassword.Enabled := State;
  lbControlPassword.Enabled := State;
  imGeneratePassword.Enabled := State;
  imGeneratePassword.ShowHint := State;
end;

procedure TTcp.cbLearnCircuitBuildTimeoutClick(Sender: TObject);
var
  State: Boolean;
begin
  State := not cbLearnCircuitBuildTimeout.Checked;
  edCircuitBuildTimeout.Enabled := State;
  udCircuitBuildTimeout.Enabled := State;
  lbCircuitBuildTimeout.Enabled := State;
  lbSeconds2.Enabled := State;
  EnableOptionButtons;
end;

procedure TTcp.cbxAuthMetodChange(Sender: TObject);
begin
  CheckAuthMetodContols;
  EnableOptionButtons;
end;

procedure TTcp.AutoSelOptionsUpdate(Sender: TObject);
begin
  CheckAutoSelControls;
  EnableOptionButtons;
end;

procedure TTCP.CheckAutoSelControls;
var
  State, EntryState, MiddleState, ExitState, FallbackDirState: Boolean;
begin
  State := cbAutoSelEntryEnabled.Checked or cbAutoSelMiddleEnabled.Checked or cbAutoSelExitEnabled.Checked or cbAutoSelFallbackDirEnabled.Checked;
  EntryState := State and cbAutoSelEntryEnabled.Checked;
  MiddleState := State and cbAutoSelMiddleEnabled.Checked;
  ExitState := State and cbAutoSelExitEnabled.Checked;
  FallbackDirState := State and cbAutoSelFallbackDirEnabled.Checked;

  edAutoSelEntryCount.Enabled := EntryState;
  edAutoSelMiddleCount.Enabled := MiddleState;
  edAutoSelExitCount.Enabled := ExitState;
  edAutoSelFallbackDirCount.Enabled := FallbackDirState;
  edAutoSelMinWeight.Enabled := State;
  edAutoSelMaxPing.Enabled := State;
  udAutoSelEntryCount.Enabled := EntryState;
  udAutoSelMiddleCount.Enabled := MiddleState;
  udAutoSelExitCount.Enabled := ExitState;
  udAutoSelFallbackDirCount.Enabled := FallbackDirState;
  udAutoSelMinWeight.Enabled := State;
  udAutoSelMaxPing.Enabled := State;
  cbxAutoSelPriority.Enabled := State;
  cbxAutoSelRoutersAfterScanType.Enabled := State and cbAutoScanNewNodes.Checked;
  cbAutoSelFallbackDirNoLimit.Enabled := FallbackDirState;
  cbAutoSelMiddleNodesWithoutDir.Enabled := MiddleState;
  cbAutoSelFilterCountriesOnly.Enabled := State;
  cbAutoSelUniqueNodes.Enabled := State;
  cbAutoSelStableOnly.Enabled := State;
  cbAutoSelNodesWithPingOnly.Enabled := State and (cbxAutoSelPriority.ItemIndex in [PRIORITY_WEIGHT, PRIORITY_RANDOM]);
  lbAutoSelPriority.Enabled := State;
  lbCount1.Enabled := EntryState;
  lbCount2.Enabled := MiddleState;
  lbCount3.Enabled := ExitState;
  lbCount6.Enabled := FallbackDirState;
  lbSpeed5.Enabled := State;
  lbMiliseconds5.Enabled := State;
  lbAutoSelMinWeight.Enabled := State;
  lbAutoSelMaxPing.Enabled := State;
  lbAutoSelRoutersAfterScanType.Enabled := State and cbAutoScanNewNodes.Checked;
end;

procedure TTcp.cbxBridgesListChange(Sender: TObject);
begin
  UpdateBridgesControls(False, True);
end;

procedure TTcp.cbxBridgesListCloseUp(Sender: TObject);
begin
  if meBridges.CanFocus then
    meBridges.SetFocus;
end;

procedure TTcp.cbxBridgesListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) and (meBridges.Lines.Count > 0) and meBridges.CanFocus then
    meBridges.SetFocus;
end;

procedure TTcp.cbxBridgesPriorityChange(Sender: TObject);
begin
  BridgesUpdated := True;
  BridgesRecalculate := True;
  EnableOptionButtons;
end;

procedure TTcp.UpdateFallbackDirControls;
var
  ini: TMemIniFile;
  FileName: string;
  Default: Boolean;
begin
  Default := cbxFallbackDirsType.ItemIndex = FALLBACK_TYPE_BUILTIN;
  if Default then
    FileName := DefaultsFile
  else
    FileName := UserConfigFile;
  ini := TMemIniFile.Create(FileName, TEncoding.UTF8);
  try
    LoadFallbackDirs(ini, Default);
  finally
    ini.Free;
  end;
  FallbackDirsUpdated := True;
  SaveFallbackDirsData;
  EnableOptionButtons;
end;

procedure TTcp.UpdateBridgesControls(UpdateList: Boolean; UpdateUserBridges: Boolean);
var
  ini: TMemIniFile;
begin
  case cbxBridgesType.ItemIndex of
    BRIDGES_TYPE_BUILTIN:
    begin
      ini := TMemIniFile.Create(DefaultsFile, TEncoding.UTF8);
      try
        LoadBuiltinBridges(ini, True, UpdateList, cbxBridgesList.Text);
      finally
        ini.Free;
      end;
    end;
    BRIDGES_TYPE_USER:
    begin
      if UpdateUserBridges then
      begin
        ini := TMemIniFile.Create(UserConfigFile, TEncoding.UTF8);
        try
          LoadUserBridges(ini);
        finally
          ini.Free;
        end;
      end;
    end;
    BRIDGES_TYPE_FILE:
    begin
      if UpdateUserBridges then
        LoadBridgesFromFile;
    end;
  end;
  BridgesUpdated := True;
  SaveBridgesData;
  EnableOptionButtons;
end;

procedure TTcp.cbxBridgesTypeChange(Sender: TObject);
begin
  BridgesFileNeedSave := False;
  UpdateBridgesControls(True, True);
end;

procedure TTcp.cbxBridgesTypeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) and (meBridges.Lines.Count > 0) and meBridges.CanFocus then
    meBridges.SetFocus;
end;

procedure TTcp.cbxHsAddressChange(Sender: TObject);
begin
  sgHsPorts.Cells[HSP_INTERFACE, sgHsPorts.SelRow] := cbxHsAddress.Text;
  UpdateHsPorts;
  EnableOptionButtons;
end;

procedure TTcp.cbxHsAddressDropDown(Sender: TObject);
begin
  GetLocalInterfaces(cbxHsAddress);
end;

procedure TTcp.CheckHsVersion;
begin
  case cbxHsVersion.ItemIndex of
    HS_VERSION_2:
    begin
      udHsNumIntroductionPoints.Min := 1;
      udHsNumIntroductionPoints.Max := 10;
    end;
    HS_VERSION_3:
    begin
      udHsNumIntroductionPoints.Min := 3;
      udHsNumIntroductionPoints.Max := 20;
    end;
  end;
  if udHsNumIntroductionPoints.Position < udHsNumIntroductionPoints.Min then
  begin
    udHsNumIntroductionPoints.Position := udHsNumIntroductionPoints.Min;
    sgHs.Cells[HS_INTRO_POINTS, sgHs.SelRow] := IntToStr(udHsNumIntroductionPoints.Position);
  end;

  if udHsNumIntroductionPoints.Position > udHsNumIntroductionPoints.Max then
  begin
    udHsNumIntroductionPoints.Position := udHsNumIntroductionPoints.Max;
    sgHs.Cells[HS_INTRO_POINTS, sgHs.SelRow] := IntToStr(udHsNumIntroductionPoints.Position);
  end;
end;

procedure TTcp.cbxHsVersionChange(Sender: TObject);
begin
  if cbxHsVersion.ItemIndex = HS_VERSION_2 then
  begin
    if not ShowMsg(TransStr('326'), '', mtWarning, True) then
    begin
      cbxHsVersion.ItemIndex := HS_VERSION_3;
      Exit;
    end;
  end;
  CheckHsVersion;
  case cbxHsVersion.ItemIndex of
    HS_VERSION_2: sgHs.Cells[HS_VERSION, sgHs.SelRow] := '2';
    HS_VERSION_3: sgHs.Cells[HS_VERSION, sgHs.SelRow] := '3';
  end;
  EnableOptionButtons;
end;

procedure TTcp.cbxLogLevelChange(Sender: TObject);
var
  DataStr: string;
begin
  if not cbxLogLevel.Focused then
    Exit;
  if cbxLogLevel.ItemIndex in [0..Length(LogLevels) - 1] then
  begin
    DataStr := LogLevels[cbxLogLevel.ItemIndex];
    ResetFocus;
    SendCommand('SETCONF Log=' + DataStr);
    SetTorConfig('Log', DataStr + ' stdout', [cfAutoSave]);
  end;
end;

procedure TTcp.MyFamilyEnable(State: Boolean);
begin
  meMyFamily.Enabled := State;
  lbTotalMyFamily.Enabled := State;
end;

function TTcp.NodesToFavorites(NodesID: Integer): Integer;
begin
  case NodesID of
    NL_TYPE_ENTRY: Result := ENTRY_ID;
    NL_TYPE_MIDDLE: Result := MIDDLE_ID;
    NL_TYPE_EXIT: Result := EXIT_ID;
    NL_TYPE_EXLUDE: Result := EXCLUDE_ID;
    else
      Result := -1;
  end;
end;

function TTcp.FavoritesToNodes(FavoritesID: Integer): Integer;
begin
  case FavoritesID of
    ENTRY_ID: Result := NL_TYPE_ENTRY;
    MIDDLE_ID: Result := NL_TYPE_MIDDLE;
    EXIT_ID: Result := NL_TYPE_EXIT;
    EXCLUDE_ID: Result := NL_TYPE_EXLUDE;
    else
      Result := -1;
  end;
end;

procedure TTcp.CalculateFilterNodes(AlwaysUpdate: Boolean = True);
const
  differ = FILTER_ENTRY_NODES;
var
  FilterItem: TPair<string, TFilterInfo>;
  NodeType: TNodeTypes;
  Counters: array[0..3] of integer;
  lbComponent: TLabel;
  IsExclude: Boolean;
  i, j: Integer;
begin
  for i := 0 to Length(Counters) - 1 do
    Counters[i] := 0;
  for FilterItem in FilterDic do
  begin
    if NodesDic.TryGetValue(FilterItem.Key, NodeType) then
      IsExclude := ntExclude in NodeType
    else
      IsExclude := False;

    if IsExclude then
      Inc(Counters[3])
    else
    begin
      NodeType := FilterItem.Value.Data;
      if ntEntry in NodeType then Inc(Counters[0]);
      if ntMiddle in NodeType then Inc(Counters[1]);
      if ntExit in NodeType then Inc(Counters[2]);
    end;
  end;

  for i := FILTER_ENTRY_NODES to FILTER_EXCLUDE_NODES do
  begin
    lbComponent := GetFilterLabel(i);
    j := i - differ;
    if AlwaysUpdate or (lbComponent.Tag <> Counters[j]) then
    begin
      lbComponent.Tag := Counters[j];
      lbComponent.Caption := IntToStr(Counters[j])
    end;
  end;
end;

procedure TTCP.CalculateTotalNodes(AlwaysUpdate: Boolean = True);
const
  differ = ENTRY_ID;
var
  NodeItem: TPair<string, TNodeTypes>;
  Counters: array[0..4] of integer;
  lbComponent: TLabel;
  ls: TStringList;
  i, j: Integer;
begin
  for i := 0 to Length(Counters) - 1 do
    Counters[i] := 0;

  ls := TStringList.Create;
  try
    for NodeItem in NodesDic do
    begin
      if NodeItem.Value = [] then
      begin
        CidrsDic.Remove(NodeItem.Key);
        ls.Add(NodeItem.Key);
      end;
    end;
    for i := 0 to ls.Count - 1 do
      NodesDic.Remove(ls[i]);
  finally
    ls.Free;
  end;

  for NodeItem in NodesDic do
  begin
    if ntEntry in NodeItem.Value then Inc(Counters[0]);
    if ntMiddle in NodeItem.Value then Inc(Counters[1]);
    if ntExit in NodeItem.Value then Inc(Counters[2]);
    if ntExclude in NodeItem.Value then Inc(Counters[3]);
    if NodeItem.Value <> [ntExclude] then
      Inc(Counters[4]);
  end;

  for i := ENTRY_ID to FAVORITES_ID do
  begin
    lbComponent := GetFavoritesLabel(i);
    j := i - differ;
    if AlwaysUpdate or (lbComponent.Tag <> Counters[j]) then
    begin
      lbComponent.Tag := Counters[j];
      lbComponent.Caption := IntToStr(Counters[j])
    end;
  end;
end;

procedure TTcp.cbxNodesListTypeChange(Sender: TObject);
begin
  LoadNodesList;
  SetConfigInteger('Lists', 'NodesListType', cbxNodesListType.ItemIndex);
end;

procedure TTcp.cbxNodesListTypeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) and meNodesList.CanFocus then
    meNodesList.SetFocus;
end;

procedure TTcp.SaveNodesList(NodesID: Integer);
var
  FavoritesID: Integer;
  NodeTypes: TNodeTypes;
  NodesList: string;
begin
  FavoritesID := NodesToFavorites(NodesID);
  NodeTypes := [];
  Include(NodeTypes, TNodeType(FavoritesID));
  ClearRouters(NodeTypes);
  NodesList := MemoToLine(meNodesList, meNodesList.SortType);
  GetNodes(NodesList, TNodeType(FavoritesID), True);
  CalculateTotalNodes;
  if NodesListStage > 0 then
    NodesListStage := 0;
  FilterUpdated := True;
  if FavoritesID = EXCLUDE_ID then
  begin
    BridgesRecalculate := True;
    FallbackDirsRecalculate := True;
  end;
  UpdateOptionsAfterRoutersUpdate;
  ShowRouters;
end;

procedure TTcp.LoadNodesList(UseDic: Boolean = True; NodesStr: string = '');
var
  NodeItem: TPair<string, TNodeTypes>;
  NodeType: TNodeType;
  FavoritesID: Integer;
begin
  FavoritesID := NodesToFavorites(cbxNodesListType.ItemIndex);
  if UseDic then
  begin
    NodesStr := '';
    NodeType := TNodeType(FavoritesID);
    for NodeItem in NodesDic do
      if NodeType in NodeItem.Value then
        NodesStr := NodesStr + ',' + NodeItem.Key;
    Delete(NodesStr, 1, 1);
  end;

  LineToMemo(RemoveBrackets(NodesStr), meNodesList, meNodesList.SortType);
  if UseDic then
    CheckFavoritesState(FavoritesID);
end;

procedure TTcp.CheckFavoritesState(FavoritesID: Integer = -1);
var
  StartPos, EndPos, i: Integer;
  lbComponent: TLabel;
begin
  if FavoritesID in [ENTRY_ID..EXCLUDE_ID] then
  begin
    StartPos := FavoritesID;
    EndPos := FavoritesID;
  end
  else
  begin
    StartPos := ENTRY_ID;
    EndPos := EXCLUDE_ID;
  end;
  for i := StartPos to EndPos do
  begin
    lbComponent := GetFavoritesLabel(i);
    if lbComponent.Tag = 0 then
      lbComponent.HelpContext := 0;
    if NodesToFavorites(cbxNodesListType.ItemIndex) = i then
      cbEnableNodesList.Checked := Boolean(lbComponent.HelpContext);
  end;
  CheckNodesListControls;
end;

procedure TTcp.CheckNodesListControls;
var
  State: Boolean;
begin
  State := cbEnableNodesList.Checked;
  meNodesList.Enabled := State;
  lbTotalNodesList.Enabled := State; 
end;

procedure TTcp.CheckServerControls;
var
  State, MemState, CpuState, BandState, AddrState, DirState: Boolean;
  BridgeState, FamilyState, ExitState, TransportState: Boolean;
begin
  if cbxServerMode.HelpContext = 1 then
    Exit;
  State := cbxServerMode.ItemIndex <> SERVER_MODE_NONE;
  BridgeState := cbxServerMode.ItemIndex = SERVER_MODE_BRIDGE;
  if BridgeState then
  begin
    cbUseDirPort.Checked := False;
    cbUseMyFamily.Checked := False;
  end;
  if BridgeState or cbUseDirPort.Checked then
    cbDirCache.Checked := True;
  AddrState := State and cbUseAddress.Checked;
  BandState := State and cbUseRelayBandwidth.Checked;
  CpuState := State and cbUseNumCPUs.Checked;
  DirState := State and cbUseDirPort.Checked;
  ExitState := State and (cbxServerMode.ItemIndex = SERVER_MODE_EXIT);
  FamilyState := State and cbUseMyFamily.Checked and not BridgeState;
  MemState := State and cbUseMaxMemInQueues.Checked;
  TransportState := State and BridgeState and (cbxBridgeType.ItemIndex > 0);

  edNickname.Enabled := State;
  edContactInfo.Enabled := State;
  edMaxMemInQueues.Enabled := MemState;
  edNumCPUs.Enabled := CpuState;
  edRelayBandwidthRate.Enabled := BandState;
  edRelayBandwidthBurst.Enabled := BandState;
  edMaxAdvertisedBandwidth.Enabled := BandState;
  edORPort.Enabled := State;
  edDirPort.Enabled := DirState;
  edTransportPort.Enabled := TransportState;
  edAddress.Enabled := AddrState;

  udMaxMemInQueues.Enabled := MemState;
  udNumCPUs.Enabled := CpuState;
  udRelayBandwidthRate.Enabled := BandState;
  udRelayBandwidthBurst.Enabled := BandState;
  udMaxAdvertisedBandwidth.Enabled := BandState;
  udOrPort.Enabled := State;
  udDirPort.Enabled := DirState;
  udTransportPort.Enabled := TransportState;

  cbxBridgeType.Enabled := BridgeState;
  cbxBridgeDistribution.Enabled := BridgeState;
  cbxExitPolicyType.Enabled := ExitState;
  cbUseNumCPUs.Enabled := State;
  cbUseMaxMemInQueues.Enabled := State;
  cbUseRelayBandwidth.Enabled := State;
  cbDirCache.Enabled := State and not (BridgeState or cbUseDirPort.Checked);
  cbUseUPnP.Enabled := State;
  cbPublishServerDescriptor.Enabled := State;
  cbUseDirPort.Enabled := State and not BridgeState;
  cbHiddenServiceStatistics.Enabled := State;
  cbDirReqStatistics.Enabled := State;
  cbAssumeReachable.Enabled := State;
  cbListenIPv6.Enabled := State;
  cbIPv6Exit.Enabled := ExitState and cbListenIPv6.Checked;
  cbUseAddress.Enabled := State;
  cbUseMyFamily.Enabled := State and not BridgeState;

  meExitPolicy.enabled := ExitState and (cbxExitPolicyType.ItemIndex = 2);
  meMyFamily.Enabled := FamilyState;

  imUPnPTest.Visible := State;
  imUPnPTest.ShowHint := State and (ConnectState = 0);

  lbNickname.Enabled := State;
  lbContactInfo.Enabled := State;
  lbBridgeType.Enabled := BridgeState;
  lbBridgeDistribution.Enabled := BridgeState;
  lbExitPolicy.Enabled := ExitState;
  lbTotalMyFamily.Enabled := FamilyState;
  lbAddress.Enabled := AddrState;
  lbMaxMemInQueues.Enabled := MemState;
  lbSizeMb.Enabled := MemState;
  lbNumCPUs.Enabled := CpuState;
  lbRelayBandwidthRate.Enabled := BandState;
  lbRelayBandwidthBurst.Enabled := BandState;
  lbMaxAdvertisedBandwidth.Enabled := BandState;
  lbSpeed1.Enabled := BandState;
  lbSpeed2.Enabled := BandState;
  lbSpeed4.Enabled := BandState;
  lbPorts.Enabled := State;
  lbORPort.Enabled := State;
  lbDirPort.Enabled := DirState;
  lbTransportPort.Enabled := TransportState;
end;

procedure TTcp.cbxHsStateChange(Sender: TObject);
begin
  case cbxHsState.ItemIndex of
    HS_STATE_ENABLED: sgHs.Cells[HS_STATE, sgHs.SelRow] := SELECT_CHAR;
    HS_STATE_DISABLED: sgHs.Cells[HS_STATE, sgHs.SelRow] := FAVERR_CHAR;
  end;
  EnableOptionButtons;
end;

procedure TTcp.cbxProxyHostDropDown(Sender: TObject);
begin
  GetLocalInterfaces(TComboBox(Sender));
end;

procedure TTcp.cbxThemesChange(Sender: TObject);
begin
  LoadStyle(cbxThemes);
  SetIconsColor;
  EnableOptionButtons;
end;

procedure TTcp.cbxThemesDropDown(Sender: TObject);
begin
  LoadThemesList(cbxThemes, '');
end;

procedure TTcp.cbxTransportTypeChange(Sender: TObject);
begin
  sgTransports.Cells[PT_TYPE, sgTransports.SelRow] := GetTransportChar(cbxTransportType.ItemIndex);
  EnableOptionButtons;
end;

procedure TTcp.UpdateTrayIcon;
var
  DefaultState: Boolean;
  Index: Integer;
begin
  DefaultState := True;
  if LastTrayIconType <> cbxTrayIconType.ItemIndex then
  begin
    if cbxTrayIconType.ItemIndex > 0 then
    begin
      if LoadIconsFromResource(lsTray, TrayIconFile, True) then
      begin
        if lsTray.Count > 3 then
          DefaultState := False
      end
      else
        TrayIconFile := '';
    end;
    if DefaultState then
    begin
      cbxTrayIconType.ItemIndex := 0;
      LoadIconsFromResource(lsTray, 'ICON_TRAY_NORMAL');
    end;
    LastTrayIconType := cbxTrayIconType.ItemIndex;
  end;
  if ScanStage > 0 then
    Index := 3
  else
    Index := ConnectState;
  if tiTray.IconIndex = Index then
    tiTray.IconIndex := -1;
  tiTray.IconIndex := Index;
  tiTray.Visible := True;
end;

procedure TTcp.PrepareOpenDialog(FileName, Filter: string);
var
  Str: string;
begin
  OpenDialog.Filter := Filter;
  if FileExists(FileName) then
  begin
    Str := ExpandFileName(FileName); 
    OpenDialog.InitialDir := ExtractFilePath(Str); 
    OpenDialog.FileName := ExtractFileName(Str); 
  end
  else
  begin
    OpenDialog.InitialDir := '';
    OpenDialog.FileName := '';  
  end;
end;

procedure TTcp.cbxTrayIconTypeChange(Sender: TObject);
var
  UpdateState: Boolean;
begin
  UpdateState := True;
  if cbxTrayIconType.ItemIndex > 0 then
  begin
    PrepareOpenDialog(TrayIconFile, TransStr('678'));
    if OpenDialog.Execute then
    begin
      TrayIconFile := StringReplace(OpenDialog.FileName, GetFullFileName(ProgramDir) + '\', '', [rfIgnoreCase]);;
      LastTrayIconType := MAXWORD;
    end
    else
      UpdateState := False;
  end;
  if UpdateState then
  begin
    UpdateTrayIcon;
    EnableOptionButtons;
  end
  else
    cbxTrayIconType.ItemIndex := LastTrayIconType;
end;

procedure TTcp.ChangeTransportTable(Param: Integer);
begin
  case Param of
    1: sgTransports.Cells[PT_TRANSPORTS, sgTransports.SelRow] := StringReplace(edTransports.Text, ' ', '', [rfReplaceAll]);
    2: sgTransports.Cells[PT_HANDLER, sgTransports.SelRow] := StringReplace(edTransportsHandler.Text, ' ', '', [rfReplaceAll]);
    3: sgTransports.Cells[PT_PARAMS, sgTransports.SelRow] := Trim(meHandlerParams.Text);
  end;
  EnableOptionButtons;
end;

procedure TTcp.ChangeHsTable(Param: Integer);
begin
  if mnHs.Tag = 1 then
    Exit;
  case Param of
    0: sgHs.Cells[HS_NAME, sgHs.SelRow] := edHsName.Text;
    1: sgHs.Cells[HS_INTRO_POINTS, sgHs.SelRow] := IntToStr(udHsNumIntroductionPoints.Position);
    2:
    begin
      if cbHsMaxStreams.Checked then
        sgHs.Cells[HS_MAX_STREAMS, sgHs.SelRow] := IntToStr(udHsMaxStreams.Position)
      else
      begin
        sgHs.Cells[HS_MAX_STREAMS, sgHs.SelRow] := NONE_CHAR;
        udHsMaxStreams.Position := 32;
      end;
    end;
    3: sgHsPorts.Cells[HSP_REAL_PORT, sgHsPorts.SelRow] := IntToStr(udHsRealPort.Position);
    4: sgHsPorts.Cells[HSP_VIRTUAL_PORT, sgHsPorts.SelRow] := IntToStr(udHsVirtualPort.Position);
  end;
  if Param in [3, 4] then
    UpdateHsPorts;
  EnableOptionButtons;
end;

procedure TTcp.edBridgesFileChange(Sender: TObject);
var
  Str: string;
begin
  if TEdit(Sender).Focused then
  begin
    if CtrlKeyPressed('A') then
      Exit;
    Str := Trim(edBridgesFile.Text);
    if BridgesFileName <> Str then
    begin
      BridgesFileName := Str;
      BridgesUpdated := True;
      BridgesFileUpdated := True;
      BridgesRecalculate := True;
      EnableOptionButtons;
    end;
  end;
end;

procedure TTcp.cbExcludeUnsuitableFallbackDirsClick(Sender: TObject);
begin
  if not TCheckBox(Sender).Focused then
    Exit;
  FallbackDirsUpdated := True;
  FallbackDirsRecalculate := True;
  SaveFallbackDirsData;
  EnableOptionButtons;
end;

procedure TTcp.CheckBridgeFileSave;
begin
  if BridgesFileUpdated then
  begin
    if FileExists(BridgesFileName) or (BridgesFileName = '') or not
      TPath.HasValidPathChars(BridgesFileName, False) then
        LoadBridgesFromFile
    else
    begin
      BridgesFileUpdated := False;
      BridgesFileNeedSave := True;
    end;
    SaveBridgesData;
  end;
end;

procedure TTcp.edBridgesFileExit(Sender: TObject);
begin
  if LastPlace <> LP_ROUTERS then
    CheckBridgeFileSave;
end;

procedure TTcp.edBridgesFileKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    CheckBridgeFileSave;
end;

procedure TTcp.edBridgesLimitChange(Sender: TObject);
begin
  if TEdit(Sender).Focused then
  begin
    if CtrlKeyPressed('A') then
      Exit;
    BridgesUpdated := True;
    BridgesRecalculate := True;
    EnableOptionButtons;
  end;
end;

procedure TTcp.edControlPasswordDblClick(Sender: TObject);
begin
  if edControlPassword.PasswordChar = '*' then
    edControlPassword.PasswordChar := #0
  else
    edControlPassword.PasswordChar := '*';
end;

procedure TTcp.edTransportsChange(Sender: TObject);
begin
  if CtrlKeyPressed('A') then
    Exit;
  if TCustomEdit(Sender).Focused then
    ChangeTransportTable(TEdit(Sender).HelpContext)
end;

procedure TTcp.edHsChange(Sender: TObject);
var
  UD: TUpDown;
begin
  if CtrlKeyPressed('A') then
    Exit;
  if TEdit(Sender).Focused then
    ChangeHsTable(TEdit(Sender).HelpContext)
  else
  begin
    UD := GetAssocUpDown(TEdit(Sender).Name);
    if UD <> nil then
      UD.Enabled := TEdit(Sender).Enabled;
  end;
end;

procedure TTcp.udBridgesLimitClick(Sender: TObject; Button: TUDBtnType);
begin
  BridgesUpdated := True;
  BridgesRecalculate := True;
  EnableOptionButtons;
end;

procedure TTcp.udHsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ChangeHsTable(TUpDown(Sender).Tag);
end;

procedure TTcp.SaveLinesLimitData;
begin
  SetConfigInteger('Log', 'LinesLimit', udLinesLimit.Position);
end;

procedure TTcp.udLinesLimitClick(Sender: TObject; Button: TUDBtnType);
begin
  SaveLinesLimitData;
end;

procedure TTcp.udRoutersWeightClick(Sender: TObject; Button: TUDBtnType);
begin
  ShowRouters;
  SaveRoutersFilterdata;
end;

procedure TTcp.EditChange(Sender: TObject);
begin
  if TEdit(Sender).Focused then
  begin
    if CtrlKeyPressed('A') then
      Exit;
    EnableOptionButtons;
  end;
end;

procedure TTcp.SetDownState;
begin
  case LastPlace of
    LP_OPTIONS: sbShowOptions.Down := True;
    LP_LOG: sbShowLog.Down := True;
    LP_STATUS: sbShowStatus.Down := True;
    LP_CIRCUITS: sbShowCircuits.Down := True;
    LP_ROUTERS: sbShowRouters.Down := True;
  end;
end;

procedure TTcp.sbShowOptionsClick(Sender: TObject);
begin
  LastPlace := LP_OPTIONS;
  UpdateOptionsAfterRoutersUpdate;
  IncreaseFormSize;
  ResetFocus;
end;

procedure TTcp.sbShowOptionsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (pcOptions.ActivePage = tsFilter) and (ssDouble in Shift) and (Button = mbLeft) then
    SetGridLastCell(sgFilter, True, True, True);
end;

procedure TTcp.sbShowRoutersClick(Sender: TObject);
begin
  LastPlace := LP_ROUTERS;
  UpdateRoutersAfterFallbackDirsUpdate;
  UpdateRoutersAfterBridgesUpdate;
  IncreaseFormSize;
  ResetFocus;
end;

procedure TTcp.sbShowRoutersMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (ssDouble in Shift) and (Button = mbLeft) then
    SetGridLastCell(sgRouters, True, True, True);
end;

procedure TTcp.sbShowStatusClick(Sender: TObject);
begin
  LastPlace := LP_STATUS;
  IncreaseFormSize;
  ResetFocus;
end;

procedure TTcp.CheckLinesLimitControls;
var
  State: Boolean;
begin
  State := sbUseLinesLimit.Down;
  edLinesLimit.Enabled := State;
  udLinesLimit.Enabled := State;
end;

procedure TTcp.sbUseLinesLimitClick(Sender: TObject);
begin
  CheckLinesLimitControls;
  SetConfigBoolean('Log', 'UseLinesLimit', sbUseLinesLimit.Down);
end;

procedure TTcp.sbWordWrapClick(Sender: TObject);
begin
  meLog.WordWrap := sbWordWrap.Down;
  CheckLogAutoScroll(True);
  SetConfigBoolean('Log', 'WordWrap', sbWordWrap.Down);
end;

procedure TTcp.sbDecreaseFormClick(Sender: TObject);
begin
  CheckOptionsChanged;
  DecreaseFormSize;
end;

procedure TTcp.sbAutoScrollClick(Sender: TObject);
begin
  CheckLogAutoScroll;
  SetConfigBoolean('Log', 'AutoScroll', sbAutoScroll.Down);
end;

procedure TTcp.sbSafeLoggingClick(Sender: TObject);
var
  DataStr: string;
begin
  DataStr := IntToStr(Integer(sbSafeLogging.Down));
  SetTorConfig('SafeLogging', DataStr, [cfAutoSave]);
  SendCommand('SETCONF SafeLogging=' + DataStr);
end;

procedure TTcp.sbShowCircuitsClick(Sender: TObject);
begin
  LastPlace := LP_CIRCUITS;
  IncreaseFormSize;
  ResetFocus;
end;

procedure TTcp.sbShowCircuitsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (ssDouble in Shift) and (Button = mbLeft) then
  begin
    ShowCircuits;
    FindInCircuits(Circuit, ExitNodeID, True);
  end;
end;

procedure TTcp.CheckLogAutoScroll(AlwaysUpdate: Boolean = False);
begin
  if AlwaysUpdate or (sbAutoScroll.Down and not LogHasSel) then
    meLog.Perform(WM_VSCROLL, SB_BOTTOM, 0);
end;

procedure TTcp.sbShowLogClick(Sender: TObject);
begin
  LastPlace := LP_LOG;
  IncreaseFormSize;
  ResetFocus;
end;

procedure TTcp.sbShowLogMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (ssDouble in Shift) and (Button = mbLeft) then
    CheckLogAutoScroll(True);
end;

procedure TTcp.SpinChanging(Sender: TObject; var AllowChange: Boolean);
begin
  EnableOptionButtons;
end;

procedure TTcp.edLinesLimitKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    SaveLinesLimitData;
end;

procedure TTcp.edLinesLimitMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbMiddle then
    SaveLinesLimitData;
end;

procedure TTcp.edPreferredBridgeChange(Sender: TObject);
begin
  if TEdit(Sender).Focused then
  begin
    if CtrlKeyPressed('A') then
      Exit;
    btnFindPreferredBridge.Enabled := PreferredBridgeFound;
    BridgesUpdated := True;
    BridgesRecalculate := True;
    EnableOptionButtons;
  end;
end;

procedure TTcp.edPreferredBridgeExit(Sender: TObject);
begin
  if BridgesRecalculate then
    SaveBridgesData;
end;

procedure TTcp.edPreferredBridgeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    if BridgesRecalculate then
      SaveBridgesData;
  end;
end;

procedure TTcp.edReachableAddressesChange(Sender: TObject);
begin
  if TEdit(Sender).Focused then
  begin
    if CtrlKeyPressed('A') then
      Exit;
    BridgesUpdated := True;
    BridgesRecalculate := True;
    EnableOptionButtons;
  end;
end;

procedure TTcp.edReachableAddressesExit(Sender: TObject);
begin
  if BridgesRecalculate then
    SaveBridgesData;
end;

procedure TTcp.edReachableAddressesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    if BridgesRecalculate then
      SaveBridgesData;
  end;
end;

procedure TTcp.edReachableAddressesKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', #44, #8]) then
    Key := #0;
end;

procedure TTcp.edRoutersWeightKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    ShowRouters;
    SaveRoutersFilterdata;
  end;
end;

procedure TTcp.edRoutersWeightMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbMiddle then
  begin
    ShowRouters;
    SaveRoutersFilterdata;
  end;
end;

procedure TTcp.edRoutersQueryChange(Sender: TObject);
var
  Query: string;
  Data: TAddressType;
  procedure SetIndex(Index: Integer);
  begin
    if (cbxRoutersQuery.ItemIndex <> Index) and
      InRange(Index, 0, cbxRoutersQuery.Items.Count - 1) then
        cbxRoutersQuery.ItemIndex := Index;
  end;
begin
  Query := Trim(edRoutersQuery.Text);
  if ValidHash(Query) then
    SetIndex(0)
  else
  begin
    Data := ValidAddress(RemoveBrackets(Query, True));
    if Data <> atNone then
    begin
      if Data = atIPv4 then
      begin
        if SeparateLeft(Query, '.') <> '0' then
          SetIndex(2)
        else
          SetIndex(6)
      end
      else
        SetIndex(3)
    end;
  end;
end;

procedure TTcp.edRoutersQueryKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    SaveRoutersFilterdata(False, False);
    LoadRoutersFilterData(LastRoutersFilter, False, True);
    if Trim(edRoutersQuery.Text) <> '' then
    begin
      if (miDisableFiltersOnUserQuery.Checked and not (ssCtrl in Shift))
        or (not miDisableFiltersOnUserQuery.Checked and (ssCtrl in Shift)) then
          RoutersCustomFilter := FILTER_BY_QUERY;
    end
    else
      edRoutersQuery.Text := '';
    CheckShowRouters;
    ShowRouters;
    SaveRoutersFilterdata(False, False);
  end;
end;

procedure TTcp.RestoreForm;
begin
  WindowState := wsNormal;
  Visible := True;
  Application.Restore;
  Application.BringToFront;
end;

procedure TTcp.miShowLogClick(Sender: TObject);
begin
  RestoreForm;
  sbShowLog.Click;
end;

procedure TTcp.miShowOptionsClick(Sender: TObject);
begin
  RestoreForm;
  sbShowOptions.Click;
end;

procedure TTcp.miShowPortAlongWithIpClick(Sender: TObject);
begin
  ShowCircuitInfo(sgCircuits.Cells[CIRC_ID, sgCircuits.SelRow]);
  SetConfigBoolean('Circuits', 'ShowPortAlongWithIp', miShowPortAlongWithIp.Checked);
end;

procedure TTcp.miShowStatusClick(Sender: TObject);
begin
  RestoreForm;
  sbShowStatus.Click;
end;

procedure TTcp.miShowStreamsInfoClick(Sender: TObject);
begin
  CheckStreamsControls;
  SetConfigBoolean('Circuits', 'ShowStreamsInfo', miShowStreamsInfo.Checked);
end;

procedure TTcp.miShowCircuitsClick(Sender: TObject);
begin
  RestoreForm;
  sbShowCircuits.Click;
end;

procedure TTcp.miRoutersShowFlagsHintClick(Sender: TObject);
begin
  SetConfigBoolean('Routers', 'RoutersShowFlagsHint', miRoutersShowFlagsHint.Checked);
end;

procedure TTcp.ShowTrafficSelect(Sender: TObject);
begin
  if ConnectState = 2 then
    SendCommand('SETEVENTS ' + GetControlEvents);
  case TMenuItem(Sender).Tag of
    1:
    begin
      CheckCircuitsControls;
      ShowCircuits;
      SetConfigBoolean('Circuits', 'ShowCircuitsTraffic', miShowCircuitsTraffic.Checked);
    end;
    2:
    begin
      CheckStreamsControls;
      SetConfigBoolean('Circuits', 'ShowStreamsTraffic', miShowStreamsTraffic.Checked);
    end;
  end;
end;

procedure TTcp.FastAndStableEnable(State: Boolean; AutoCheck: Boolean = True);
begin
  miShowFast.Enabled := State;
  miShowStable.Enabled := State;
  if AutoCheck and not State then
  begin
    miShowFast.Checked := True;
    miShowStable.Checked := True;
  end;
end;

procedure TTcp.CheckShowRouters;
var
  AuthorityState, BridgeState, AuthorityOrBridgeState: Boolean;
begin
  AuthorityState := not miShowAuthority.Checked;
  BridgeState := not miShowBridge.Checked;
  AuthorityOrBridgeState := AuthorityState and BridgeState;

  if (RoutersCustomFilter > 0) then
  begin
    case RoutersCustomFilter of
      FILTER_BY_BRIDGE: IntToMenu(miRtFilters, 3);
      FILTER_BY_ALIVE: IntToMenu(miRtFilters, 3);
      FILTER_BY_TOTAL: IntToMenu(miRtFilters, 3);
      FILTER_BY_GUARD: IntToMenu(miRtFilters, 3);
      FILTER_BY_EXIT: IntToMenu(miRtFilters, 3);
      FILTER_BY_QUERY: IntToMenu(miRtFilters, 8);
      ENTRY_ID..FALLBACK_DIR_ID: IntToMenu(miRtFilters, 0, True);
    end;
  end;

  if miShowOther.Checked or miShowBridge.Checked or miShowAuthority.Checked or miShowConsensus.Checked then
  begin
    miShowExit.Checked := False;
    miShowGuard.Checked := False;
  end;

  if miShowGuard.Checked or miShowHSDir.Checked then
  begin
    FastAndStableEnable(False);
    if miShowGuard.Checked then
      miShowV2Dir.Checked := True;
    miShowV2Dir.Enabled := not miShowGuard.Checked;
  end
  else
  begin
    FastAndStableEnable(AuthorityOrBridgeState, False);
    miShowV2Dir.Enabled := True;
  end;

  miShowHsDir.Enabled := AuthorityOrBridgeState;
  miShowDirMirror.Enabled := AuthorityOrBridgeState;

  edRoutersQuery.Enabled := miRtFiltersQuery.Checked;
  cbxRoutersQuery.Enabled := miRtFiltersQuery.Checked;
  edRoutersWeight.Enabled := miRtFiltersWeight.Checked;
  udRoutersWeight.Enabled := miRtFiltersWeight.Checked;
  cbxRoutersCountry.Enabled := miRtFiltersCountry.Checked;
  btnShowNodes.Enabled := miRtFiltersType.Checked;
  lbSpeed3.Enabled := miRtFiltersWeight.Checked;
  SetCustomFilterStyle(RoutersCustomFilter);
end;

procedure TTcp.SetCustomFilterStyle(CustomFilterID: Integer);
begin
  if not FirstLoad then
  begin
    TFont(lbFavoritesEntry.Font).Style := [];
    TFont(lbFavoritesMiddle.Font).Style := [];
    TFont(lbFavoritesExit.Font).Style := [];
    TFont(lbFavoritesTotal.Font).Style := [];
    TFont(lbExcludeNodes.Font).Style := [];
    TFont(lbFavoritesBridges.Font).Style := [];
    TFont(lbFavoritesFallbackDirs.Font).Style := [];
  end;
  if CustomFilterID in [ENTRY_ID..FALLBACK_DIR_ID] then
    TFont(GetFavoritesLabel(CustomFilterID).Font).Style := [fsUnderline];
end;

procedure TTcp.SetRoutersFilter(Sender: TObject);
var
  Mask: Integer;

  procedure Selector(Other, Bridge, Authority, Consensus: Boolean);
  begin
    miShowOther.Checked := Other;
    miShowBridge.Checked := Bridge;
    miShowAuthority.Checked := Authority;
    miShowConsensus.Checked := Consensus;
  end;

begin
  Mask := TMenuItem(Sender).Tag;
  case Mask of
    1: if miShowExit.Checked then Selector(False, False, False, False);
    2: if miShowGuard.Checked then Selector(False, False, False, False);
    4: if miShowAuthority.Checked then Selector(False, False, True, False);
    8: if miShowOther.Checked then Selector(True, False, False, False);
   16: if miShowBridge.Checked then Selector(False, True, False, False);
 8192: if miShowConsensus.Checked then Selector(False, False, False, True);
  end;

  if ShowNodesChanged and miDisableFiltersOnAuthorityOrBridge.Checked then
  begin
    if (Mask in [1,2,8]) or (Mask = 8192) or ((Mask in [4,16]) and not TMenuItem(Sender).Checked) then
    begin
      if LastFilters > -1 then
      begin
        IntToMenu(miRtFilters, LastFilters);
        LastFilters := -1;
      end;
    end
    else
    begin
      if TMenuItem(Sender).Checked and (Mask in [4,16])then
      begin
        if LastFilters = -1 then
          LastFilters := MenuToInt(miRtFilters);
        if miRtFiltersCountry.Checked and (cbxRoutersCountry.Tag <> -1) then
          miRtFiltersCountry.Checked := False;
        if miRtFiltersWeight.Checked and (udRoutersWeight.Position > 0) then
          miRtFiltersWeight.Checked := False;
        if miRtFiltersQuery.Checked and (Trim(edRoutersQuery.Text) <> '') then
          miRtFiltersQuery.Checked := False;
      end;
    end;
  end;

  ShowNodesChanged := False;
  CheckShowRouters;
  ShowRouters;
  SaveRoutersFilterdata(False, True);
end;

procedure TTcp.SetRoutersFilterState(Sender: TObject);
begin
  if RoutersCustomFilter in [FILTER_BY_BRIDGE..FILTER_BY_QUERY] then
    RoutersCustomFilter := 0;
  LastFilters := -1;
  CheckShowRouters;
  ShowRouters;
  SaveRoutersFilterdata;
end;

procedure TTcp.LoadRoutersFilterData(Data: string; AutoUpdate: Boolean = True; ResetCustomFilter: Boolean = False);
var
  ParseStr: ArrOfStr;
  i, QueryType: Integer;
begin
  if Trim(Data) = '' then
    Data := DEFAULT_ROUTERS_FILTER_DATA;
  LastRoutersFilter := Data;

  ParseStr := Explode(';', Data);

  for i := 0 to Length(ParseStr) - 1 do
  begin
    case i of
      0:
      begin
        RoutersFilters := StrToIntDef(ParseStr[i], ROUTER_FILTER_DEFAULT);
        IntToMenu(miRtFilters, RoutersFilters);
      end;
      1: LastFilters := StrToIntDef(ParseStr[i], -1);
      2: IntToMenu(mnShowNodes.Items, StrToIntDef(ParseStr[i], SHOW_NODES_FILTER_DEFAULT));
      3: cbxRoutersCountry.Tag := StrToIntDef(ParseStr[i], -1);
      4: udRoutersWeight.Position := StrToIntDef(ParseStr[i], 10);
      5:
      begin
        if ResetCustomFilter then
          RoutersCustomFilter := 0
        else
        begin
          RoutersCustomFilter := StrToIntDef(ParseStr[i], 0);
          if not (RoutersCustomFilter in [0, FILTER_BY_BRIDGE..FALLBACK_DIR_ID]) then
            RoutersCustomFilter := 0;
        end;
      end;
      6:
      begin
        LastRoutersCustomFilter := StrToIntDef(ParseStr[i], 0);
        if not (LastRoutersCustomFilter in [0, FILTER_BY_BRIDGE..FALLBACK_DIR_ID]) then
          LastRoutersCustomFilter := 0;
      end;
      7:
      begin
        QueryType := StrToIntDef(ParseStr[i], -1);
        if (QueryType < 0) or (QueryType > cbxRoutersQuery.Items.Count - 1) then
        begin
          cbxRoutersQuery.ItemIndex := 0;
          edRoutersQuery.Text := '';
          Break;
        end
        else
          if FirstLoad then
            cbxRoutersQuery.ItemIndex := QueryType;
      end;
      8: edRoutersQuery.Text := ParseStr[i];
    end;
  end;

  if AutoUpdate then
  begin
    CheckCountryIndexInList;
    CheckShowRouters;
    ShowRouters;
  end;
end;

procedure TTcp.SaveRoutersFilterdata(Default: Boolean = False; SaveFilters: Boolean = True);
var
  Ident, UserQuery: string;
  Filters, Search: Integer;
begin
  if Default then
  begin
    Ident := 'DefaultFilter';
    LastFilters := -1;
    udRoutersWeight.ResetValue := udRoutersWeight.Position;
  end
  else
    Ident := 'CurrentFilter';
  if SaveFilters then
  begin
    RoutersFilters := MenuToInt(miRtFilters);
    Filters := RoutersFilters;
  end
  else
    Filters := RoutersFilters;

  UserQuery := Trim(edRoutersQuery.Text);
  Search := Pos(';', UserQuery); 
  if Search <> 0 then
  begin
    case cbxRoutersQuery.ItemIndex of
      4,5: UserQuery := StringReplace(UserQuery, ';', ',', [rfReplaceAll]);
      else
        SetLength(UserQuery, Pred(Search));
    end;
  end;
  LastRoutersFilter := IntToStr(Filters) + ';' +
    IntToStr(LastFilters) + ';' +
    IntToStr(MenuToInt(mnShowNodes.Items)) + ';' +
    IntToStr(cbxRoutersCountry.Tag) + ';' +
    IntToStr(udRoutersWeight.Position) + ';' +
    IntToStr(RoutersCustomFilter) + ';' +
    IntToStr(LastRoutersCustomFilter) + ';' +
    IntToStr(cbxRoutersQuery.ItemIndex) + ';' +
    UserQuery;
  if Default then
    SetConfigString('Routers', Ident, LastRoutersFilter);
end;

procedure TTcp.miShowRoutersClick(Sender: TObject);
begin
  RestoreForm;
  sbShowRouters.Click;
end;

procedure TTcp.miSwitchTorClick(Sender: TObject);
begin
  btnSwitchTor.Click;
end;

procedure TTcp.miTplSaveClick(Sender: TObject);
begin
  SetConfigInteger('Filter', 'TplSave', MenuToInt(miTplSave));
end;

procedure TTcp.miTransportsClearClick(Sender: TObject);
begin
  ClearGrid(sgTransports);
  UpdateTransports;
  EnableOptionButtons;
end;

procedure TTcp.miTransportsDeleteClick(Sender: TObject);
begin
  DeleteARow(sgTransports, sgTransports.SelRow);
  UpdateTransports;
  EnableOptionButtons;
end;

procedure TTcp.miTransportsInsertClick(Sender: TObject);
begin
  if IsEmptyGrid(sgTransports) then
    TransportsEnable(True)
  else
  begin
    sgTransports.RowCount := sgTransports.RowCount + 1;
    sgTransports.Row := sgTransports.RowCount - 1;
  end;
  sgTransports.Cells[PT_TRANSPORTS, sgTransports.SelRow] := 'transport';
  sgTransports.Cells[PT_HANDLER, sgTransports.SelRow] := 'program.exe';
  sgTransports.Cells[PT_Type, sgTransports.SelRow] := FAVERR_CHAR;
  sgTransports.Cells[PT_PARAMS, sgTransports.SelRow] := '';
  SelectTransports;
  EnableOptionButtons;
end;

procedure TTcp.miTransportsOpenDirClick(Sender: TObject);
begin
  ShellOpen(GetFullFileName(TransportsDir));
end;

procedure TTcp.miTransportsResetClick(Sender: TObject);
var
  ini: TMemIniFile;
begin
  ini := TMemIniFile.Create(DefaultsFile, TEncoding.UTF8);
  try
    ResetTransports(ini);
  finally
    ini.Free;
  end;
  EnableOptionButtons;
end;

procedure TTcp.StartScannerManual(Sender: TObject);
var
  ScanPurpose: TScanPurpose;
  ScanType: TScanType;
  ScanPing, ScanAlive: Boolean;
begin
  ScanPing := miManualPingMeasure.Checked;
  ScanAlive := miManualDetectAliveNodes.Checked;
  if ScanPing or ScanAlive then
  begin
    if ScanPing and ScanAlive then
      ScanType := stBoth
    else
    begin
      if miManualPingMeasure.Checked then
        ScanType := stPing
      else
        ScanType := stAlive;
    end;
  end
  else
    ScanType := stNone;

  case TMenuItem(Sender).Tag of
    1: ScanPurpose := spNew;
    2: ScanPurpose := spFailed;
    3: ScanPurpose := spBridges;
    4: ScanPurpose := spAll;
    5: ScanPurpose := spGuards;
    6: ScanPurpose := spAlive;
    else
      ScanPurpose := spNone;
  end;

  ScanNetwork(ScanType, ScanPurpose);
end;

procedure TTcp.miTplLoadClick(Sender: TObject);
begin
  SetConfigInteger('Filter', 'TplLoad', MenuToInt(miTplLoad));
end;

procedure TTcp.miSelectExitCircuitWhenItChangesClick(Sender: TObject);
begin
  ShowCircuits;
  SetConfigBoolean('Circuits', 'SelectExitCircuitWhenItChanges', miSelectExitCircuitWhenItChanges.Checked);
end;

procedure TTcp.miSelectGraphDLClick(Sender: TObject);
begin
  pbTraffic.Repaint;
  SetConfigBoolean('Status', 'SelectGraphDL', miSelectGraphDL.Checked);
end;

procedure TTcp.miSelectGraphULClick(Sender: TObject);
begin
  pbTraffic.Repaint;
  SetConfigBoolean('Status', 'SelectGraphUL', miSelectGraphUL.Checked);
end;

procedure TTcp.btnApplyOptionsClick(Sender: TObject);
begin
  ApplyOptions;
end;

procedure TTcp.btnCancelOptionsClick(Sender: TObject);
begin
  ResetOptions;
end;

procedure TTcp.CursorStopTimer(Sender: TObject);
begin
  if CursorShow then
  begin
    CursorShow := False;
    btnChangeCircuit.Enabled := True;
    btnChangeCircuit.Cursor := crDefault;
    FreeAndNil(CursorStop);
  end
  else
  begin
    btnChangeCircuit.Cursor := crNo;
    CursorStop.Interval := 250;
    CursorShow := True;
    btnChangeCircuit.Enabled := False;
  end;
end;

procedure TTcp.ChangeCircuit(DirectClick: Boolean = True);
begin
  if CheckSplitButton(btnChangeCircuit, DirectClick) then
    Exit;
  if (UsedProxyType <> ptNone) and (ConnectState = 2) and (Circuit <> '') then
  begin
    btnChangeCircuit.Enabled := False;
    miChangeCircuit.Enabled := False;
    CloseCircuit(Circuit, False);
    CheckCircuitExists(Circuit, True);
    ResetFocus;
  end
  else
  begin
    if not Assigned(CursorStop) then
    begin
      CursorStop := TTimer.Create(Tcp);
      CursorStop.OnTimer := CursorStopTimer;
      CursorStop.Interval := 25;
    end;
  end;
end;

procedure TTcp.btnChangeCircuitClick(Sender: TObject);
begin
  ChangeCircuit;
end;

procedure TTcp.btnShowNodesClick(Sender: TObject);
var
  P: TPoint;
begin
  P := btnShowNodes.ClientOrigin;
  btnShowNodes.DropDownMenu.Popup(P.X, P.Y + btnShowNodes.Height);
end;

procedure TTcp.btnSwitchTorClick(Sender: TObject);
begin
  if ConnectState = 0 then
  begin
    if not Assigned(Controller) and not Assigned(Logger) and not Assigned(Consensus) and not Assigned(Descriptors) then
    begin
      case CurrentScanPurpose of
        spUserBridges, spNewBridges: ShowMsg(Format(TransStr('400'), [TransStr('659')]));
        spUserFallbackDirs: ShowMsg(Format(TransStr('400'), [TransStr('660')]));
        else
          StartTor;
      end;
    end;
  end
  else
    StopTor;
  ResetFocus;
end;

procedure TTcp.miChangeCircuitClick(Sender: TObject);
begin
  ChangeCircuit(False)
end;

procedure TTcp.SelectCheckIpProxy(Sender: TObject);
begin
  TMenuItem(Sender).Checked := True;
  SetConfigInteger('Network', 'CheckIpProxyType', TMenuItem(Sender).Tag);
end;

procedure TTcp.SetCircuitsUpdateInterval(Sender: TObject);
begin
  if TMenuItem(Sender).Checked then
    Exit;
  TMenuItem(Sender).Checked := True;
  tmCircuits.Interval := TMenuItem(Sender).Tag;
  SetConfigInteger('Circuits', 'UpdateInterval', TMenuItem(Sender).Tag);
end;

procedure TTcp.miCircuitsShowFlagsHintClick(Sender: TObject);
begin
  SetConfigBoolean('Circuits', 'CircuitsShowFlagsHint', miCircuitsShowFlagsHint.Checked);
end;

procedure TTcp.miCircuitsUpdateNowClick(Sender: TObject);
begin
  ShowCircuits;
end;

procedure TTcp.SetCircuitsFilter(Sender: TObject);
begin
  ShowCircuits;
  SetConfigInteger('Circuits', 'PurposeFilter', MenuToInt(miCircuitFilter));
end;

procedure TTcp.miEnableConvertNodesOnIncorrectClearClick(Sender: TObject);
begin
  SetConfigBoolean('Routers', 'EnableConvertNodesOnIncorrectClear', miEnableConvertNodesOnIncorrectClear.Checked);
end;

procedure TTcp.miEnableConvertNodesOnRemoveFromNodesListClick(Sender: TObject);
begin
  SetConfigBoolean('Routers', 'EnableConvertNodesOnRemoveFromNodesList', miEnableConvertNodesOnRemoveFromNodesList.Checked);
end;

procedure TTcp.miEnableTotalsCounterClick(Sender: TObject);
begin
  CheckStatusControls;
  SetConfigBoolean('Status', 'EnableTotalsCounter', miEnableTotalsCounter.Checked);
end;

procedure TTcp.miEnableConvertNodesOnAddToNodesListClick(Sender: TObject);
begin
  SetConfigBoolean('Routers', 'EnableConvertNodesOnAddToNodesList', miEnableConvertNodesOnAddToNodesList.Checked);
end;

procedure TTcp.miExitClick(Sender: TObject);
begin
  Closing := True;
  Tcp.Close;
end;

procedure TTcp.miFilterHideUnusedClick(Sender: TObject);
begin
  ShowFilter;
  SetConfigBoolean('Filter', 'FilterHideUnused', miFilterHideUnused.Checked);
end;

procedure TTcp.miFilterScrollTopClick(Sender: TObject);
begin
  SetConfigBoolean('Filter', 'FilterScrollTop', miFilterScrollTop.Checked);
end;

procedure TTcp.CheckSelectRowOptions(aSg: TStringGrid; Checked: Boolean; Save: Boolean = False);
begin
  if Checked then
    aSg.Options := aSg.Options + [goRowSelect]
  else
  begin
    aSg.Options := aSg.Options - [goRowSelect];
    if aSg.SelRow > 0 then
    begin
      aSg.Row := aSg.SelRow;
      aSg.Col := aSg.SelCol;
    end;
  end;
  if Save then
  begin
    case aSg.Tag of
      GRID_FILTER: SetConfigBoolean(Copy(aSg.Name, 3), 'FilterSelectRow', Checked);
     GRID_ROUTERS: SetConfigBoolean(Copy(aSg.Name, 3), 'RoutersSelectRow', Checked);
    end;
  end;
end;

procedure TTcp.miFilterSelectRowClick(Sender: TObject);
begin
  CheckSelectRowOptions(sgFilter, miFilterSelectRow.Checked, True);
end;

procedure TTcp.miGetBridgesEmailClick(Sender: TObject);
var
  Param: AnsiString;
begin
  if miRequestIPv6Bridges.Checked then
    Param := 'get ipv6'
  else
  begin
    if miRequestObfuscatedBridges.Checked then
      Param := 'get transport obfs4'
    else
      Param := 'get vanilla';
  end;
  ShellOpen('mailto:' + GetDefaultsValue('BridgesEmail', BRIDGES_EMAIL) + '?Body=' + string(EncodeURL(Param)));
end;

procedure TTcp.miRequestIPv6BridgesClick(Sender: TObject);
begin
  SetConfigBoolean('Network', 'RequestIPv6Bridges', miRequestIPv6Bridges.Checked);
end;

procedure TTcp.miRequestObfuscatedBridgesClick(Sender: TObject);
begin
  SetConfigBoolean('Network', 'RequestObfuscatedBridges', miRequestObfuscatedBridges.Checked);
end;

function TTCP.CheckCacheOpConfirmation(OpStr: string): Boolean;
begin
  Result := ShowMsg(Format(TransStr('405'),[OpStr]), '', mtQuestion, True);
end;

procedure TTcp.SaveScanData;
var
  ini: TMemIniFile;
begin
  ini := TMemIniFile.Create(UserConfigFile, TEncoding.UTF8);
  try
    SetSettings('Scanner', 'LastFullScanDate', LastFullScanDate, ini);
    SetSettings('Scanner', 'LastPartialScanDate', LastPartialScanDate, ini);
    SetSettings('Scanner', 'LastPartialScansCounts', LastPartialScansCounts, ini);
  finally
    UpdateConfigFile(ini);
  end;
end;

procedure TTcp.miResetScannerScheduleClick(Sender: TObject);

begin
  if not CheckCacheOpConfirmation(TMenuItem(Sender).Caption) then
    Exit;
  LastFullScanDate := 0;
  LastPartialScanDate := 0;
  LastPartialScansCounts := udPartialScansCounts.Position;
  SaveScanData;
end;

procedure TTcp.miResetTotalsCounterClick(Sender: TObject);
var
  ini: TMemIniFile;
begin
  if not CheckCacheOpConfirmation(TMenuItem(Sender).Caption) then
    Exit;
  ini := TMemIniFile.Create(UserConfigFile, TEncoding.UTF8);
  try
    TotalDL := 0;
    TotalUL := 0;
    TotalsNeedSave := False;
    TotalStartDate := DateTimeToUnix(Now);
    LastSaveStats := DateTimeToUnix(Now);
    SetSettings('Status', 'TotalDL', TotalDL, ini);
    SetSettings('Status', 'TotalUL', TotalUL, ini);
    SetSettings('Status', 'TotalStartDate', TotalStartDate, ini);
    CheckStatusControls;
  finally
    UpdateConfigFile(ini);
  end;
end;

procedure TTcp.miGetBridgesSiteClick(Sender: TObject);
var
  Transport, IPv6: string;
begin
  if miRequestObfuscatedBridges.Checked then
    Transport := 'transport=obfs4'
  else
    Transport := 'transport=0';
  if miRequestIPv6Bridges.Checked then
    IPv6 := '&ipv6=yes'
  else
    IPv6 := '';
  ShellOpen(GetDefaultsValue('BridgesSite', BRIDGES_SITE) + '?' + Transport + IPv6);
end;

procedure TTcp.miGetBridgesTelegramClick(Sender: TObject);
var
  Url: string;
begin
  if RegistryFileExists(HKEY_CLASSES_ROOT, 'tg\shell\open\command', '') and not miPreferWebTelegram.Checked then
    Url := 'tg://resolve?domain='
  else
    Url := 'https://t.me/';
  ShellOpen(Url + GetDefaultsValue('BridgesBot', BRIDGES_BOT));
end;

procedure TTcp.FindInFilter(IpAddr: string);
var
  Index: Integer;
  GeoIpInfo: TGeoIpInfo;
begin
  if ValidAddress(IpAddr) <> atNone then
  begin
    pcOptions.ActivePage := tsFilter;
    sbShowOptions.Click;
    if GeoIpDic.TryGetValue(IpAddr, GeoIpInfo) then
      Index := sgFilter.Cols[FILTER_ID].IndexOf(CountryCodes[GeoIpInfo.cc])
    else
      Index := sgFilter.Cols[FILTER_ID].IndexOf('??');
    SetGridLastCell(sgFilter, True, False, False, Index, FILTER_NAME);
  end;
end;

procedure TTcp.FindInRouters(RouterID: string; SocketStr: string = '');
var
  Index: Integer;
  Router: TRouterInfo;
  Sum, Temp: Integer;
begin
  if not ValidHash(RouterID) then
  begin
    if SocketStr <> '' then
    begin
      RouterID := GetRouterBySocket(SocketStr);
      if RouterID = '' then
        Exit;
    end
    else
      Exit;
  end;
  
  if RoutersDic.TryGetValue(RouterID, Router) then
  begin
    LoadRoutersFilterData(LastRoutersFilter, False, True);

    if miRtFiltersType.Checked then
    begin
      Sum := 0;
      if rfExit in Router.Flags then Inc(Sum, 1);
      if rfGuard in Router.Flags then Inc(Sum, 2);
      if rfAuthority in Router.Flags then Inc(Sum, 4);
      if rfBridge in Router.Flags then Inc(Sum, 16);
      if Sum = 0 then Inc(Sum, 8);
      if rfFast in Router.Flags then Inc(Sum, 32);
      if rfStable in Router.Flags then Inc(Sum, 64);
      if rfV2Dir in Router.Flags then Inc(Sum, 128);
      if rfHSDir in Router.Flags then Inc(Sum, 256);
      if VersionsDic.ContainsKey(Router.Version) then Inc(Sum, 512);
      if Router.DirPort > 0 then Inc(Sum, 1024);
      if (Router.Params and ROUTER_ALIVE <> 0) then Inc(Sum, 2048);

      IntToMenu(mnShowNodes.Items, Sum);
    end;

    if miRtFiltersCountry.Checked then
    begin
      if cbxRoutersCountry.Tag <> -1 then
      begin
        Temp := GetCountryValue(Router.IPv4);
        if cbxRoutersCountry.Tag = -2 then
          if FilterDic.Items[CountryCodes[Temp]].Data <> [] then
            Temp := -2;
        if cbxRoutersCountry.Tag <> Temp then
        begin
          cbxRoutersCountry.ItemIndex := 0;
          cbxRoutersCountry.Tag := -1;
        end;
      end;
    end;

    if miRtFiltersWeight.Checked then
    begin
      if Router.Bandwidth < udRoutersWeight.Position * 1024 then
      begin
        Temp := Floor(Router.Bandwidth/1024);
        if Temp < 5 then
          Temp := 0
        else
          Temp := Temp - (Temp mod 5);
        udRoutersWeight.Position := Temp;
      end;
    end;

    if miRtFiltersQuery.Checked then
    begin
      if Trim(edRoutersQuery.Text) <> '' then
        edRoutersQuery.Text := '';
    end;

    CheckShowRouters;
    ShowRouters;
    Index := sgRouters.Cols[FILTER_ID].IndexOf(RouterID);
    if Index < 0 then
      Index := 1;
    SetGridLastCell(sgRouters, True, False, False, Index, ROUTER_IP);
    sbShowRouters.Click;
    SaveRoutersFilterdata;
  end;
end;

procedure TTcp.HsMaxStreamsEnable(State: Boolean);
begin
  edHsMaxStreams.Enabled := State;
  udHsMaxStreams.Enabled := State;
  if not State then
    udHsMaxStreams.Position := 32;
  lbHsMaxStreams.Enabled := State;
end;

procedure TTcp.TransportsEnable(State: Boolean);
begin
  edTransports.Enabled := State;
  edTransportsHandler.Enabled := State;
  cbxTRansportType.Enabled := State;
  meHandlerParams.Enabled := State;
  lbTransports.Enabled := State;
  lbTransportsHandler.Enabled := State;
  lbTransportType.Enabled := State;
  lbHandlerParams.Enabled := State;
end;

procedure TTcp.HsPortsEnable(State: Boolean);
begin
  edHsRealPort.Enabled := State;
  edHsVirtualPort.Enabled := State;
  udHsRealPort.Enabled := State;
  udHsVirtualPort.Enabled := State;
  cbxHsAddress.Enabled := State;
  lbHsSocket.Enabled := State;
  lbHsVirtualPort.Enabled := State;
end;

procedure TTcp.HsControlsEnable(State: Boolean);
begin
  sgHsPorts.Enabled := State;
  edHsName.Enabled := State;
  edHsNumIntroductionPoints.Enabled := State;
  edRendPostPeriod.Enabled := State and SupportRendPostPeriod;
  udHsNumIntroductionPoints.Enabled := State;
  udRendPostPeriod.Enabled := State and SupportRendPostPeriod;
  cbxHsVersion.Enabled := State;
  cbxHsState.Enabled := State;
  cbHsMaxStreams.Enabled := State;
  HsMaxStreamsEnable(State);
  HsPortsEnable(State);
  lbHsName.Enabled := State;
  lbHsVersion.Enabled := State;
  lbHsNumIntroductionPoints.Enabled := State;
  lbRendPostPeriod.Enabled := State and SupportRendPostPeriod;
  lbMinutes.Enabled := State and SupportRendPostPeriod;
  lbHsState.Enabled := State;
end;

procedure TTcp.miHideCircuitsWithoutStreamsClick(Sender: TObject);
begin
  ShowCircuits;
  SetConfigBoolean('Circuits', 'HideCircuitsWithoutStreams', miHideCircuitsWithoutStreams.Checked);
end;

procedure TTcp.miHsClearClick(Sender: TObject);
var
  i: Integer;
begin
  if tsHs.Tag = 1 then
  begin
    if ShowMsg(Format(TransStr('263'), ['', TransStr('267')]), '', mtQuestion, True) then
    begin
      for i := 1 to sgHs.RowCount - 1 do
      begin
        if sgHs.Cells[HS_PREVIOUS_NAME, i] <> '' then
        begin
          SetLength(HsToDelete, Length(HsToDelete) + 1);
          HsToDelete[Length(HsToDelete) - 1] := sgHs.Cells[HS_PREVIOUS_NAME, i];
        end;
      end;
      ClearGrid(sgHs);
      UpdateHs;
      EnableOptionButtons;
    end;
  end;

  if tsHs.Tag = 2 then
  begin
    ClearGrid(sgHsPorts);
    UpdateHsPorts;
    EnableOptionButtons;
  end;
end;

procedure TTcp.miHsCopyOnionClick(Sender: TObject);
begin
  Clipboard.AsText := miHsCopyOnion.Caption;
end;

procedure TTcp.miHsDeleteClick(Sender: TObject);
begin
  mnHs.Tag := 1;

  if tsHs.Tag = 1 then
  begin
    if ShowMsg(Format(TransStr('263'), [TransStr('367') + ' ', sgHs.Cells[HS_NAME, sgHs.SelRow]]), '', mtQuestion, True) then
    begin
      if sgHs.Cells[HS_PREVIOUS_NAME, sgHs.SelRow] <> '' then
      begin
        SetLength(HsToDelete, Length(HsToDelete) + 1);
        HsToDelete[Length(HsToDelete) - 1] := sgHs.Cells[HS_PREVIOUS_NAME, sgHs.SelRow];
      end;
      DeleteARow(sgHs, sgHs.SelRow);
      UpdateHs;
      EnableOptionButtons;
    end;
  end;

  if tsHs.Tag = 2 then
  begin
    DeleteARow(sgHsPorts, sgHsPorts.SelRow);
    UpdateHsPorts;
    EnableOptionButtons;
  end;

  mnHs.Tag := 0;
end;

procedure TTcp.miHsInsertClick(Sender: TObject);
begin
  mnHs.Tag := 1;

  if tsHs.Tag = 1 then
  begin
    if IsEmptyGrid(sgHs) then
      HsControlsEnable(True)
    else
    begin
      sgHs.RowCount := sgHs.RowCount + 1;
      sgHs.Row := sgHs.RowCount - 1;
    end;
    sgHs.Cells[HS_NAME, sgHs.SelRow] := '';
    sgHs.Cells[HS_VERSION, sgHs.SelRow] := '3';
    sgHs.Cells[HS_INTRO_POINTS, sgHs.SelRow] := '3';
    sgHs.Cells[HS_MAX_STREAMS, sgHs.SelRow] := NONE_CHAR;
    sgHs.Cells[HS_STATE, sgHs.SelRow] := SELECT_CHAR;
    sgHs.Cells[HS_PORTS_DATA, sgHs.SelRow] := LOOPBACK_ADDRESS + ',' + DEFAULT_PORT + ',' + DEFAULT_PORT;
    ClearGrid(sgHsPorts);
    SelectHs;
    if edHsName.CanFocus then
      edHsName.SetFocus;
  end;

  if tsHs.Tag = 2 then
  begin
    if IsEmptyGrid(sgHsPorts) then
      HsControlsEnable(True)
    else
    begin
      sgHsPorts.RowCount := sgHsPorts.RowCount + 1;
      sgHsPorts.Row := sgHsPorts.RowCount - 1;
    end;
    sgHsPorts.Cells[HSP_INTERFACE, sgHsPorts.SelRow] := LOOPBACK_ADDRESS;
    sgHsPorts.Cells[HSP_REAL_PORT, sgHsPorts.SelRow] := DEFAULT_PORT;
    sgHsPorts.Cells[HSP_VIRTUAL_PORT, sgHsPorts.SelRow] := DEFAULT_PORT;
    UpdateHsPorts;
    SelectHsPorts;
  end;
  mnHs.Tag := 0;
  EnableOptionButtons;
end;

procedure TTcp.meTrackHostExitsChange(Sender: TObject);
begin
  lbTotalHosts.Caption := TransStr('203') + ': ' + IntToStr(meTrackHostExits.Lines.Count);
  EnableOptionButtons;
end;

procedure TTcp.InsertNodesMenu(ParentMenu: TMenuItem; NodeID: string; AutoSave: Boolean = True);
begin
  ParentMenu.Clear;
  if not ParentMenu.Enabled then
    Exit;
  if ConnectState = 1 then
    Exit;
  InsertNodesListMenu(InsertMenuItem(ParentMenu, ENTRY_ID, 40, TransStr('288')), NodeID, ENTRY_ID, AutoSave);
  InsertNodesListMenu(InsertMenuItem(ParentMenu, MIDDLE_ID, 41, TransStr('289')), NodeID, MIDDLE_ID, AutoSave);
  InsertNodesListMenu(InsertMenuItem(ParentMenu, EXIT_ID, 42, TransStr('290')), NodeID, EXIT_ID, AutoSave);
  InsertNodesListMenu(InsertMenuItem(ParentMenu, EXCLUDE_ID, 43, TransStr('287')), NodeID, EXCLUDE_ID, AutoSave);
  InsertMenuItem(ParentMenu, 0, -1, '-');
  InsertNodesToDeleteMenu(InsertMenuItem(ParentMenu, 0, 17, TransStr('359')), NodeID, AutoSave);
  InsertMenuItem(ParentMenu, 0, -1, '-');
  InsertMenuItem(ParentMenu, 0, 50, TransStr('360'), RoutersAutoSelectClick,
    False, False, False, (RoutersDic.Count > 0) and (InfoStage = 0) and
    (cbAutoSelEntryEnabled.Checked or cbAutoSelMiddleEnabled.Checked or cbAutoSelExitEnabled.Checked or cbAutoSelFallbackDirEnabled.Checked) and not
    (Assigned(Consensus) or Assigned(Descriptors) or tmScanner.Enabled), not AutoSave);
end;

procedure TTcp.InsertNodesListMenu(ParentMenu: TmenuItem; NodeID: string; NodeTypeID: Integer; AutoSave: Boolean = True);
var
  SubMenu: TMenuItem;
  ls, lr: TStringList;
  i: Integer;
  CountryID: Byte;
  Router: TRouterInfo;
  RangesStr, NodeStr: string;
  ParseStr: ArrOfStr;
  NodeDataType: TNodeDataType;
  FindRouter: Boolean;

  function IpToMask(IpStr: string; Mask: Byte): string;
  var
    i, n: Byte;
    ParseStr: ArrOfStr;
  begin
    ParseStr := Explode('.', IpStr);
    n := 32;
    for i := Length(ParseStr) - 1 downto 0 do
    begin
      dec(n, 8);
      if n >= Mask then
        ParseStr[i] := '0';
    end;
    Result := Format('%s.%s.%s.%s/%d', [ParseStr[0], ParseStr[1], ParseStr[2], ParseStr[3], Mask]);
  end;

begin
  ls := TStringList.Create;
  try
    ls.Add(NodeID);
    if RoutersDic.TryGetValue(NodeID, Router) then
    begin
      FindRouter := True;
      CountryID := GetCountryValue(Router.IPv4);
      ls.Add(Router.IPv4);
      ls.Add('-');
      ls.Add(IpToMask(Router.IPv4, 24));
      ls.Add(IpToMask(Router.IPv4, 16));
      ls.Add(IpToMask(Router.IPv4, 8));
      RangesStr := FindInRanges(Router.IPv4, atIPv4Cidr);
      if RangesStr <> '' then
      begin
        lr := TStringList.Create;
        try
          ls.Add('-');
          ParseStr := Explode(',', RangesStr);
          for i := 0 to Length(ParseStr) - 1 do
            if ls.IndexOf(ParseStr[i]) < 0 then
              lr.Add(ParseStr[i]);
          SortNodesList(lr, SORT_DESC);
          ls.AddStrings(lr);
        finally
          lr.Free;
        end;
      end;
      ls.Add('-');
      ls.Add(UpperCase(CountryCodes[CountryID]) + ' (' + TransStr(CountryCodes[CountryID]) + ')');
    end
    else
      FindRouter := False;

    for i := 0 to ls.Count - 1 do
    begin
      NodeStr := SeparateLeft(ls[i], ' ');
      NodeDataType := ValidNode(NodeStr);
      if NodeDataType = dtCode then
        NodeStr := LowerCase(NodeStr);

      SubMenu := TMenuItem.Create(self);
      SubMenu.Hint := BoolToStr(AutoSave);
      SubMenu.Tag := NodeTypeID;
      SubMenu.Caption := ls[i];

      if NodesDic.ContainsKey(NodeStr) then
      begin
        if TNodeType(NodeTypeID) in NodesDic.Items[NodeStr] then
          SubMenu.Enabled := False;
      end;

      if SubMenu.Enabled and (NodeDataType in [dtHash]) and FindRouter then
      begin
        if (not CheckRouterFlags(NodeTypeID, Router) or (NodeStr = LastPreferBridgeID)) and (NodeTypeID <> EXCLUDE_ID)  then
          SubMenu.Visible := False;
      end;

      if NodeDataType <> dtNone then
      begin
        case NodeDataType of
          dtHash: SubMenu.ImageIndex := 23;
          dtIPv4: SubMenu.ImageIndex := 33;
          dtIPv4Cidr: SubMenu.ImageIndex := 48;
          dtCode: SubMenu.ImageIndex := 57;
        end;
        if SubMenu.Enabled then
          SubMenu.OnClick := AddToNodesListClick;
      end;
      ParentMenu.Add(SubMenu);
    end;
  finally
    ls.Free;
  end;
end;

procedure TTcp.InsertNodesToDeleteMenu(ParentMenu: TmenuItem; NodeID: string; AutoSave: Boolean = True);
var
  Router: TRouterInfo;
  ls: TStringList;
  i: Integer;
  NodeDataType: TNodeDataType;
  RangesStr, NodeStr, DeleteList, CountryCode: string;
  ParseStr: ArrOfStr;
  SubMenu: TMenuItem;
begin
  if RoutersDic.TryGetValue(NodeID, Router) then
  begin
    CountryCode := CountryCodes[GetCountryValue(Router.IPv4)];
    ls := TStringList.Create;
    try
      ls.Add(NodeID);
      ls.Add(Router.IPv4);
      RangesStr := FindInRanges(Router.IPv4, atIPv4Cidr);
      if RangesStr <> '' then
      begin
        ParseStr := Explode(',', RangesStr);
        for i := 0 to Length(ParseStr) - 1 do
          ls.Add(ParseStr[i]);
      end;
      SortNodesList(ls, SORT_DESC);
      ls.Add(UpperCase(CountryCode) + ' (' + TransStr(CountryCode) + ')');

      DeleteList := '';
      for i := 0 to ls.Count - 1 do
      begin
        NodeStr := SeparateLeft(ls[i], ' ');
        NodeDataType := ValidNode(NodeStr);
        if NodeDataType = dtCode then
          NodeStr := LowerCase(NodeStr);

        if NodesDic.ContainsKey(NodeStr) then
        begin
          if NodesDic.Items[NodeStr] <> [] then
          begin
            SubMenu := TMenuItem.Create(self);
            SubMenu.Tag := Integer(AutoSave);
            case NodeDataType of
              dtHash: SubMenu.ImageIndex := 23;
              dtIPv4: SubMenu.ImageIndex := 33;
              dtIPv4Cidr: SubMenu.ImageIndex := 48;
              dtCode: SubMenu.ImageIndex := 57;
            end;
            SubMenu.Caption := ls[i];
            SubMenu.Hint := '';
            SubMenu.OnClick := RemoveFromNodeListClick;
            ParentMenu.Add(SubMenu);
            DeleteList := DeleteList + ',' + ls[i];
          end;
        end;
      end;
      Delete(DeleteList, 1, 1);
      if ParentMenu.Count > 1 then
      begin
        ls.Clear;
        ls.Add('-');
        ls.Add(TransStr('406'));
        for i := 0 to ls.Count - 1 do
        begin
          SubMenu := TMenuItem.Create(self);
          SubMenu.Tag := Integer(AutoSave);
          SubMenu.Caption := ls[i];
          if SubMenu.Caption <> '-' then
          begin
            SubMenu.ImageIndex := 17;
            SubMenu.Hint := DeleteList;
            SubMenu.OnClick := RemoveFromNodeListClick;
          end;
          ParentMenu.Add(SubMenu);
        end;
      end;
      ParentMenu.Visible := ParentMenu.Count > 0;
    finally
      ls.Free;
    end;
  end;
end;

procedure TTcp.CheckNodesListState(NodeTypeID: Integer);
var
  lbComponent: TLabel;
begin
  lbComponent := GetFavoritesLabel(NodeTypeID);
  if Assigned(lbComponent) then
  begin
    if lbComponent.Tag = 0 then
      lbComponent.HelpContext := 1;
  end;
  if NodeTypeID <> EXCLUDE_ID then
  begin
    if (lbFavoritesTotal.Tag = 0) and (cbxFilterMode.ItemIndex <> FILTER_MODE_FAVORITES) then
      cbxFilterMode.ItemIndex := FILTER_MODE_FAVORITES;
  end;
end;

function TTCP.CheckRouterFlags(NodeTypeID: Integer; RouterInfo: TRouterInfo): Boolean;
begin
  Result := False;
  if (rfBridge in RouterInfo.Flags) and not (rfRelay in RouterInfo.Flags) then
    Exit;
  if (NodeTypeID = ENTRY_ID) and not (rfGuard in RouterInfo.Flags) then
    Exit;
  if (NodeTypeID = EXIT_ID) and (not (rfExit in RouterInfo.Flags) or (rfBadExit in RouterInfo.Flags)) then
    Exit;
  Result := True;
end;

procedure TTCP.AddToNodesListClick(Sender: TObject);
var
  NodeStr, NodeCap, ConvertMsg: string;
  ConvertNodes, CtrlPressed, EnableConvertNodes: Boolean;
  NodeTypeID: Integer;
  FNodeTypes: TNodeTypes;
  FilterInfo: TFilterInfo;
  NodeDataType: TNodeDataType;
  Router: TPair<string, TRouterInfo>;
  CidrInfo: TCidrInfo;

  procedure AddRouterToNodesList(RouterID: string; RouterInfo: TRouterInfo);
  begin
    if NodeTypeID <> EXCLUDE_ID then
    begin
      if miAvoidAddingIncorrectNodes.Checked then
      begin
        if not CheckRouterFlags(NodeTypeID, RouterInfo) then
          Exit;
        if RouterInNodesList(RouterID, RouterInfo.IPv4, ntExclude, False, '', atIPv4Cidr) then
          Exit;
      end;
    end;
    NodesDic.TryGetValue(RouterID, FNodeTypes);
    if (ntExclude in FNodeTypes) or (NodeTypeID = EXCLUDE_ID) then
      FNodeTypes := [];
    Include(FNodeTypes, TNodeType(NodeTypeID));
    NodesDic.AddOrSetValue(RouterID, FNodeTypes);
  end;

begin
  ConvertMsg := '';
  CtrlPressed := CtrlKeyPressed(#0);
  NodeCap := TMenuItem(Sender).Caption;
  NodeStr := SeparateLeft(NodeCap, ' ');
  NodeTypeID := TMenuItem(Sender).Tag;
  NodeDataType := ValidNode(NodeStr);
  case NodeDataType of
    dtCode: NodeStr := LowerCase(NodeStr);
    dtIPv4Cidr: CidrInfo := CidrStrToInfo(NodeStr, atIPv4Cidr);
  end;
  ConvertNodes := miEnableConvertNodesOnAddToNodesList.Checked and
      (((NodeDataType = dtIPv4) and miConvertIpNodes.Checked) or
       ((NodeDataType = dtIPv4Cidr) and miConvertCidrNodes.Checked) or
       ((NodeDataType = dtCode) and miConvertCountryNodes.Checked)) and
        (((NodeTypeID = EXCLUDE_ID) and not miIgnoreConvertExcludeNodes.Checked) or
         (NodeTypeID <> EXCLUDE_ID));

  EnableConvertNodes := (ConvertNodes and not CtrlPressed) or (not ConvertNodes and CtrlPressed);
  if EnableConvertNodes then
    ConvertMsg := BR + BR + TransStr('146');

  if ShowMsg(Format(TransStr('268'), [NodeCap, TMenuItem(Sender).Parent.Caption, ConvertMsg]), '', mtQuestion, True) then
  begin
    if EnableConvertNodes then
    begin
      for Router in RoutersDic do
      begin
        case NodeDataType of
          dtIPv4:
          begin
            if Router.Value.IPv4 = NodeStr then
              AddRouterToNodesList(Router.Key, Router.Value);
          end;
          dtIPv4Cidr:
          begin
            if IpInCidr(Router.Value.IPv4, CidrInfo, atIPv4Cidr) then
              AddRouterToNodesList(Router.Key, Router.Value);
          end;
          dtCode:
          begin
            if CountryCodes[GetCountryValue(Router.Value.IPv4)] = NodeStr then
              AddRouterToNodesList(Router.Key, Router.Value);
          end;
        end;
      end;
    end
    else
    begin
      NodesDic.TryGetValue(NodeStr, FNodeTypes);
      if (ntExclude in FNodeTypes) or (NodeTypeID = EXCLUDE_ID) then
        FNodeTypes := [];
      Include(FNodeTypes, TNodeType(NodeTypeID));
      NodesDic.AddOrSetValue(NodeStr, FNodeTypes);

      if NodeTypeID = EXCLUDE_ID then
      begin
        if FilterDic.TryGetValue(NodeStr, FilterInfo) then
        begin
          FilterInfo.Data := [];
          FilterDic.AddOrSetValue(NodeStr, FilterInfo);
        end;
      end;
      if NodeDataType = dtIPv4Cidr then
        CidrsDic.AddOrSetValue(NodeStr, CidrStrToInfo(NodeStr, atIPv4Cidr));
    end;
    CheckNodesListState(NodeTypeID);
    CalculateTotalNodes;

    if NodeTypeID = EXCLUDE_ID then
    begin
      BridgesRecalculate := True;
      FallbackDirsRecalculate := True;
    end;
    RoutersUpdated := True;
    FilterUpdated := True;
    UpdateOptionsAfterRoutersUpdate;
    ShowRouters;

    if StrToBool(TMenuItem(Sender).Hint) then
      ApplyOptions
    else
      EnableOptionButtons;
  end;
end;

procedure TTcp.RemoveFromNodeListClick(Sender: TObject);
var
  ConvertNodes: Boolean;
  NodesList, NodeStr, ConvertMsg: string;
  ParseStr: ArrOfStr;
  NodeDataType: TNodeDataType;
  i: Integer;
  Nodes: ArrOfNodes;

begin
  if TMenuItem(Sender).Hint = '' then
    NodesList := TMenuItem(Sender).Caption
  else
    NodesList := TMenuItem(Sender).Hint;

  ConvertNodes := PrepareNodesToRemove(NodesList, ntNone, Nodes);;
  if ConvertNodes then
    ConvertMsg := BR + BR + TransStr('146')
  else
    ConvertMsg := '';

  if ShowMsg(Format(TransStr('361'), [StringReplace(NodesList, ',', BR, [rfReplaceAll]), ConvertMsg]), '', mtQuestion, True) then
  begin
    ParseStr := Explode(',', NodesList);
    for i := 0 to Length(ParseStr) - 1 do
    begin
      NodeStr := SeparateLeft(ParseStr[i], ' ');
      NodeDataType := ValidNode(NodeStr);
      if NodeDataType = dtCode then
        NodeStr := LowerCase(NodeStr);

      NodesDic.Remove(NodeStr);
      if NodeDataType = dtIPv4Cidr then
        CidrsDic.Remove(NodeStr);
    end;
    if ConvertNodes then
      RemoveFromNodesListWithConvert(Nodes, ntNone);

    CalculateTotalNodes;

    BridgesRecalculate := True;
    FallbackDirsRecalculate := True;
    RoutersUpdated := True;
    FilterUpdated := True;
    UpdateOptionsAfterRoutersUpdate;
    ShowRouters;

    if Boolean(TMenuItem(Sender).Tag) then
      ApplyOptions
    else
      EnableOptionButtons;
  end;
end;

function TTcp.PrepareNodesToRemove(Data: string; NodeType: TNodeType; out Nodes: ArrOfNodes): Boolean;
var
  ParseStr: ArrOfStr;
  i, j: Integer;
  NodeStr: string;
  NodeDataType: TNodeDataType;
  CtrlPressed, ConvertNodes: Boolean;
begin
  Result := False;
  Nodes := nil;
  CtrlPressed := CtrlKeyPressed(#0);
  ParseStr := Explode(',', Data);
  if Length(ParseStr) = 0 then
    Exit;
  j := 0;
  for i := 0 to Length(ParseStr) - 1 do
  begin
    NodeStr := SeparateLeft(ParseStr[i], ' ');
    NodeDataType := ValidNode(NodeStr);

    ConvertNodes := miEnableConvertNodesOnRemoveFromNodesList.Checked and
      (((NodeDataType = dtIPv4) and miConvertIpNodes.Checked) or
       ((NodeDataType = dtIPv4Cidr) and miConvertCidrNodes.Checked) or
       ((NodeDataType = dtCode) and miConvertCountryNodes.Checked));

    if (ConvertNodes and not CtrlPressed) or
       (not ConvertNodes and CtrlPressed and (NodeDataType <> dtHash)) then
    begin
      SetLength(Nodes, j + 1);
      case NodeDataType of
        dtCode: NodeStr := LowerCase(NodeStr);
        dtIPv4Cidr: Nodes[j].CidrInfo := CidrStrToInfo(NodeStr, atIPv4Cidr);
      end;
      Nodes[j].NodeStr := NodeStr;
      Nodes[j].NodeDataType := NodeDataType;
      Inc(j);
    end;
  end;

  Result := Assigned(Nodes);
end;

procedure TTcp.RemoveFromNodesListWithConvert(Nodes: ArrOfNodes; NodeType: TNodeType);
var
  NodesCount, i: Integer;
  Router: TPair<string, TRouterInfo>;

  procedure RemoveRouterFromNodesList(RouterID: string);
  var
    FNodeTypes: TNodeTypes;
  begin
    if NodeType = ntNone then
      NodesDic.Remove(RouterID)
    else
    begin
      if NodesDic.TryGetValue(RouterID, FNodeTypes) then
      begin
        Exclude(FNodeTypes, NodeType);
        NodesDic.AddOrSetValue(RouterID, FNodeTypes);
      end;
    end;
  end;

begin
  NodesCount := Length(Nodes);
  if NodesCount = 0 then
    Exit;
  for Router in RoutersDic do
  begin
    for i := 0 to NodesCount - 1 do
    begin
      case Nodes[i].NodeDataType of
        dtIPv4:
        begin
          if Router.Value.IPv4 = Nodes[i].NodeStr then
            RemoveRouterFromNodesList(Router.Key);
        end;
        dtIPv4Cidr:
        begin
          if IpInCidr(Router.Value.IPv4, Nodes[i].CidrInfo, atIPv4Cidr) then
            RemoveRouterFromNodesList(Router.Key);
        end;
        dtCode:
        begin
          if CountryCodes[GetCountryValue(Router.Value.IPv4)] = Nodes[i].NodeStr then
            RemoveRouterFromNodesList(Router.Key);
        end;
      end;
    end;
  end;

end;

function TTcp.RoutersAutoSelect: Boolean;
var
  Router: Tpair<string, TRouterInfo>;
  cdWeight, cdPing, cdStable, CheckEntryPorts: Boolean;
  GeoIpInfo: TGeoIpInfo;
  RouterInfo: TRouterInfo;
  NodeItem: TPair<string, TNodeTypes>;
  Flags: TRouterFlags;
  PriorityType, PingData, PingSum, PingCount, PingAvg: Integer;
  FilterNodeTypes, AutoSelNodeTypes: TNodeTypes;
  FilterInfo: TFilterInfo;
  CountryID: Byte;
  EntryStr, MiddleStr, ExitStr, FallbackStr, CountryCode, PortsData: string;
  EntryNodes, MiddleNodes, ExitNodes, FallbackDirs: TStringList;
  UniqueList: TDictionary<string, Byte>;
  SortCompare: TStringListSortCompare;
  ParseStr: ArrOfStr;
  i: Integer;

  function ListToStr(ls: TStringList; Max: Integer): string;
  var
    i, Count: Integer;
    Search: Boolean;
    RouterInfo: TRouterInfo;
    GeoIpInfo: TGeoIpInfo;
  begin
    Result := '';
    Count := 0;

    for i := 0 to ls.Count - 1 do
    begin
      if PriorityType = PRIORITY_BALANCED then
      begin
        Search := False;
        if RoutersDic.TryGetValue(ls[i], RouterInfo) then
        begin
          if GeoIpDic.TryGetValue(RouterInfo.IPv4, GeoIpInfo) then
            Search := InRange(GeoIpInfo.ping, 1 , PingAvg);
        end;
      end
      else
        Search := True;

      if Count < Max then
      begin
        if Search then
        begin
          if cbAutoSelUniqueNodes.Checked then
          begin
            if UniqueList.ContainsKey(ls[i]) then
              Continue
            else
            begin
              UniqueList.AddOrSetValue(ls[i], 0);
              Result := Result + ',' + ls[i];
              Inc(Count);
            end;
          end
          else
          begin
            Result := Result + ',' + ls[i];
            Inc(Count);
          end;
        end;

      end
      else
        Break;
    end;
    Delete(Result, 1, 1);
  end;

  procedure AddRouterToList(ls: TStringList; NodeType: TNodeType; NoLimit: Boolean = False);
  var
    FNodeType: TNodeType;
  begin
    if NodeType = ntFallbackDir then
      FNodeType := ntEntry
    else
      FNodeType := NodeType;

    if ((FNodeType in FilterNodeTypes) or NoLimit) and (NodeType in AutoSelNodeTypes) then
    begin
      if (cdWeight or NoLimit) and cdPing  then
      begin
        case PriorityType of
          PRIORITY_BALANCED:
          begin
            ls.AddObject(Router.Key, TObject(Router.Value.Bandwidth));
            if not UniqueList.ContainsKey(Router.Key) then
            begin
              if (PingData <= udAutoSelMaxPing.Position) then
              begin
                UniqueList.AddOrSetValue(Router.Key, 0);
                Inc(PingSum, PingData);
                Inc(PingCount);
              end;
            end;
          end;
          PRIORITY_WEIGHT: ls.AddObject(Router.Key, TObject(Router.Value.Bandwidth));
          PRIORITY_PING: ls.AddObject(Router.Key, TObject(PingData));
          else
            ls.AddObject(Router.Key, TObject(Random(MAXWORD)));
        end;
      end;
    end;
  end;

begin
  Result := False;
  if RoutersDic.Count = 0 then
    Exit;
  if not (cbAutoSelEntryEnabled.Checked or cbAutoSelMiddleEnabled.Checked or cbAutoSelExitEnabled.Checked or cbAutoSelFallbackDirEnabled.Checked) then
    Exit;

  CheckEntryPorts := ReachablePortsExists;
  EntryNodes := TStringList.Create;
  MiddleNodes := TStringList.Create;
  ExitNodes := TStringList.Create;
  FallbackDirs := TStringList.Create;
  UniqueList := TDictionary<string, Byte>.Create;

  if (PingNodesCount = 0) and (PriorityType in [PRIORITY_BALANCED, PRIORITY_PING]) then
    PriorityType := PRIORITY_WEIGHT
  else
    PriorityType := cbxAutoSelPriority.ItemIndex;

  PingCount := 0;
  PingSum := 0;
  PingAvg := 0;

  try
    AutoSelNodeTypes := [];
    if cbAutoSelEntryEnabled.Checked then
      Include(AutoSelNodeTypes, ntEntry);
    if cbAutoSelMiddleEnabled.Checked then
      Include(AutoSelNodeTypes, ntMiddle);
    if cbAutoSelExitEnabled.Checked then
      Include(AutoSelNodeTypes, ntExit);
    if cbAutoSelFallbackDirEnabled.Checked then
      Include(AutoSelNodeTypes, ntFallbackDir);

    for Router in RoutersDic do
    begin
      Flags := Router.Value.Flags;
      CountryID := DEFAULT_COUNTRY_ID;
      PingData := MAXWORD;
      PortsData := '';
      FilterNodeTypes := [ntEntry, ntMiddle, ntExit];

      if PingNodesCount > 0 then
      begin
        if GeoIpDic.TryGetValue(Router.Value.IPv4, GeoIpInfo) then
        begin
          CountryID := GeoIpInfo.cc;
          case GeoIpInfo.ping of
            -1: PingData := MAXINT;
            0: PingData := MAXWORD;
            else
              PingData := GeoIpInfo.ping;
          end;
          PortsData := GeoIpInfo.ports;
        end;
      end;

      cdPing := (PingData <= udAutoSelMaxPing.Position) or ((PingData >= MAXWORD) and not cbAutoSelNodesWithPingOnly.Checked);

      CountryCode := CountryCodes[CountryID];

      cdWeight := Router.Value.Bandwidth >= udAutoSelMinWeight.Position * 1024;

      if (rfRelay in Flags) and not RouterInNodesList(Router.Key, Router.Value.IPv4, ntExclude) then
      begin
        cdStable := rfStable in Flags;
        if cbAutoSelFilterCountriesOnly.Checked and (PingNodesCount > 0) then
        begin
          if FilterDic.TryGetValue(CountryCode, FilterInfo) then
            FilterNodeTypes := FilterInfo.Data;
        end;

        if cdStable or not cbAutoSelStableOnly.Checked then
        begin
          if (Router.Value.Params and ROUTER_ALIVE <> 0) or (AliveNodesCount = 0) then
          begin
            if CheckEntryPorts then
            begin
              if PortsDic.ContainsKey(Router.Value.Port) then
              begin
                if rfGuard in Flags then
                  AddRouterToList(EntryNodes, ntEntry);
                if (rfFast in Flags) and cdStable then
                  AddRouterToList(FallbackDirs, ntFallbackDir, cbAutoSelFallbackDirNoLimit.Checked);
              end;
            end
            else
            begin
              if rfGuard in Flags then
                AddRouterToList(EntryNodes, ntEntry);
              if cdStable and (rfFast in Flags) and cdStable then
                AddRouterToList(FallbackDirs, ntFallbackDir, cbAutoSelFallbackDirNoLimit.Checked);
            end;
          end;

          if (rfExit in Flags) and not (rfBadExit in Flags) then
            AddRouterToList(ExitNodes, ntExit);

          if (not (rfHsDir in Flags) and (Router.Value.DirPort = 0)) or not cbAutoSelMiddleNodesWithoutDir.Checked then
            AddRouterToList(MiddleNodes, ntMiddle);
        end;
      end;
    end;
    if PriorityType = PRIORITY_BALANCED then
    begin
      if PingCount > 0 then
        PingAvg := Round(PingSum / PingCount);
    end;

    case PriorityType of
      PRIORITY_PING: SortCompare := CompIntObjectAsc
      else
        SortCompare := CompIntObjectDesc;
    end;

    UniqueList.Clear;
    if cbAutoSelUniqueNodes.Checked and not
      (cbAutoSelEntryEnabled.Checked and cbAutoSelMiddleEnabled.Checked and cbAutoSelExitEnabled.Checked) then
    begin
      for NodeItem in NodesDic do
      begin
        if ValidHash(NodeItem.Key) then
        begin
          if not cbAutoSelEntryEnabled.Checked and (ntEntry in NodeItem.Value) then
            UniqueList.AddOrSetValue(NodeItem.Key, 0);
          if not cbAutoSelMiddleEnabled.Checked and (ntMiddle in NodeItem.Value) then
            UniqueList.AddOrSetValue(NodeItem.Key, 0);
          if not cbAutoSelExitEnabled.Checked and (ntExit in NodeItem.Value) then
            UniqueList.AddOrSetValue(NodeItem.Key, 0);
        end;
      end;
    end;

    if cbAutoSelFallbackDirEnabled.Checked then
      Exclude(AutoSelNodeTypes, ntFallbackDir);
    ClearRouters(AutoSelNodeTypes);

    if cbAutoSelEntryEnabled.Checked then
    begin
      EntryNodes.CustomSort(SortCompare);
      EntryStr := ListToStr(EntryNodes, udAutoSelEntryCount.Position);
      GetNodes(EntryStr, ntEntry, True);
    end;

    if cbAutoSelExitEnabled.Checked then
    begin
      ExitNodes.CustomSort(SortCompare);
      ExitStr := ListToStr(ExitNodes, udAutoSelExitCount.Position);
      GetNodes(ExitStr, ntExit, True);
    end;

    if cbAutoSelMiddleEnabled.Checked then
    begin
      MiddleNodes.CustomSort(SortCompare);
      MiddleStr := ListToStr(MiddleNodes, udAutoSelMiddleCount.Position);
      GetNodes(MiddleStr, ntMiddle, True);
    end;

    if cbAutoSelFallbackDirEnabled.Checked then
    begin
      FallbackDirs.CustomSort(SortCompare);
      FallbackStr := ListToStr(FallbackDirs, udAutoSelFallbackDirCount.Position);
      cbUseFallbackDirs.Checked := True;
      cbxFallbackDirsType.ItemIndex := FALLBACK_TYPE_USER;
      ParseStr := Explode(',', FallbackStr);
      UsedFallbackDirs.Clear;
      for i := 0 to Length(ParseStr) - 1 do
      begin
        if RoutersDic.TryGetValue(ParseStr[i], RouterInfo) then
          UsedFallbackDirs.AddOrSetValue(RouterInfo.IPv4 + '|' + IntToStr(RouterInfo.Port), GetFallbackStr(ParseStr[i], RouterInfo));
      end;
      SaveFallbackDirsData(nil, True);
    end;

    CheckNodesListState(FAVORITES_ID);
    CalculateTotalNodes;
    ShowRouters;
    RoutersUpdated := True;
    EnableOptionButtons;
    Result := True;
  finally
    EntryNodes.Free;
    MiddleNodes.Free;
    ExitNodes.Free;
    FallbackDirs.Free;
    UniqueList.Free;
    if CheckEntryPorts then
      PortsDic.Clear;
  end;
end;

procedure TTcp.ExcludeUnsuitableFallbackDirs(var Data: TStringList);
var
  FallbackDirsCount, PortData, i: Integer;
  CheckEntryPorts, CheckRouters, FindCountry, NeedCountry, NeedAlive: Boolean;
  cdAlive, cdPorts, cdSocket: Boolean;
  FallbackDir: TFallbackDir;
  GeoIpInfo: TGeoIpInfo;
  BridgeInfo: TBridgeInfo;
  CountryID: Byte;
  CountryStr: string;
  Router: TRouterInfo;
begin
  SuitableFallbackDirsCount := 0;
  FallbackDirsCount := Data.Count;
  if FallbackDirsCount = 0 then
    Exit;
  CheckEntryPorts := ReachablePortsExists;
  CheckRouters := RoutersDic.Count > 0;
  for i := Data.Count - 1 downto 0 do
  begin
    if TryParseFallbackDir(Data[i], FallbackDir, False) then
    begin
      if CheckEntryPorts then
        cdPorts := PortsDic.ContainsKey(FallbackDir.OrPort)
      else
        cdPorts := True;

      cdSocket := False;
      if CheckRouters then
      begin
        if RoutersDic.TryGetValue(FallbackDir.Hash, Router) then
        begin
          if (FallbackDir.IPv4 = Router.IPv4) and (FallbackDir.OrPort = Router.Port) then
          begin
            if rfRelay in Router.Flags then
              cdSocket := True;
          end;
        end;
      end;

      if not cdSocket then
      begin
        if BridgesDic.TryGetValue(FallbackDir.Hash, BridgeInfo) then
          cdSocket := BridgeInfo.Transport = ''
        else
          cdSocket := not CheckRouters;
      end;

      if GeoIpDic.TryGetValue(FallbackDir.IPv4, GeoIpInfo) then
      begin
        CountryID := GeoIpInfo.cc;
        PortData := GetPortsValue(GeoIpInfo.ports, IntToStr(FallbackDir.OrPort));
        cdAlive := PortData <> -1;
        NeedAlive := PortData = 0;
        NeedCountry := CountryID = DEFAULT_COUNTRY_ID;
        FindCountry := NeedCountry and cdAlive;
      end
      else
      begin
        CountryID := DEFAULT_COUNTRY_ID;
        cdAlive := False;
        NeedAlive := True;
        NeedCountry := True;
        FindCountry := True;
      end;

      if FindCountry and GeoIpExists then
        Inc(UnknownFallbackDirCountriesCount);

      CountryStr := CountryCodes[CountryID];

      if cdPorts and cdSocket and (cdAlive or NeedAlive) and not RouterInNodesList(FallbackDir.Hash, FallbackDir.IPv4, ntExclude, NeedCountry and NeedAlive, CountryStr) then
        Inc(SuitableFallbackDirsCount)
      else
        Data.Delete(i);
    end
    else
      Data.Delete(i);
  end;

  if CheckEntryPorts then
    PortsDic.Clear;
end;

procedure TTcp.RoutersAutoSelectClick(Sender: TObject);
begin
  RoutersAutoSelect;
end;

procedure TTcp.SaveFallbackDirs;
var
  ini: TMemIniFile;
begin
  LoadTorConfig;
  ini := TMemIniFile.Create(UserConfigFile, TEncoding.UTF8);
  try
    OptionsLocked := True;
    SaveFallbackDirsData(ini, False, True);
    OptionsLocked := False;
    SaveTorConfig;
  finally
    UpdateConfigFile(ini);
  end;
end;

procedure TTcp.SaveFallbackDirsData(ini: TMemIniFile = nil; UseDic: Boolean = False; FastUpdate: Boolean = False);
var
  AutoSave: Boolean;
  Item: Tpair<string, string>;
  FallbackDir: TFallbackDir; 
  ls: TStringList;
  DataStr: string;
  i: Integer;
begin
  LastFallbackDirsHash := 0;
  UsedFallbackDirsCount := 0;
  AutoSave := ini <> nil;
  if AutoSave then
  begin
    MissingFallbackDirCount := 0;
    UnknownFallbackDirCountriesCount := 0;
    DeleteTorConfig('FallbackDir', [cfMultiLine]);
  end;

  ls := TStringList.Create;
  try
    if UseDic then
    begin
      for Item in UsedFallbackDirs do
        ls.Append(Item.Value);
      SortList(ls, ltFallbackDir, meFallbackDirs.SortType);
    end
    else
      MemoToList(meFallbackDirs, meFallbackDirs.SortType, ls);
    meFallbackDirs.Text := ls.Text;
    if cbExcludeUnsuitableFallbackDirs.Checked then
    begin
      ExcludeUnsuitableFallbackDirs(ls);
      LastFallbackDirsHash := Crc32(AnsiString(ls.Text));
    end;

    if not UseDic then
    begin
      UsedFallbackDirs.Clear;
      for i := 0 to ls.Count - 1 do
      begin
        if TryParseFallbackDir(ls[i], FallbackDir, False) then
          UsedFallbackDirs.AddOrSetValue(FallbackDir.IPv4 + '|' + IntToStr(FallbackDir.OrPort), ls[i]);
      end;
    end;

    if (ls.Text = '') and AutoSave then
      cbUseFallbackDirs.Checked := False;

    if cbUseFallbackDirs.Checked then
      UsedFallbackDirsCount := ls.Count;

    if AutoSave then
    begin
      if (UnknownFallbackDirCountriesCount > 0) and (ConnectState = 0) then
        SetTorConfig('DisableNetwork', '1');

      if cbUseFallbackDirs.Checked then
        SetTorConfig('FallbackDir', ls)
      else
        UsedFallbackDirs.Clear;

      if cbxFallbackDirsType.ItemIndex = FALLBACK_TYPE_USER then
      begin
        ini.EraseSection('FallbackDirs');
        for i := 0 to meFallbackDirs.Lines.Count - 1 do
          SetSettings('FallbackDirs', IntToStr(i), meFallbackDirs.Lines[i], ini);
      end;
      SetSettings('Lists', cbUseFallbackDirs, ini);
      SetSettings('Lists', cbExcludeUnsuitableFallbackDirs, ini);
      SetSettings('Lists', cbxFallbackDirsType, ini);

      if FastUpdate and (ConnectState <> 0) then
      begin
        if cbUseFallbackDirs.Checked then
        begin
          DataStr := '';
          for i := 0 to ls.Count - 1 do
            DataStr := DataStr + ' FallbackDir="' + ls[i] + '"';
          SendCommand('SETCONF' + DataStr);
        end
        else
          SendCommand('SETCONF FallbackDir');
      end;
      UpdateFallbackDirs := False;
    end;
    FallbackDirsCheckControls;
    CountTotalFallbackDirs;
    FallbackDirsRecalculate := False;
  finally
    ls.Free;
  end;
end;

procedure TTcp.miAboutClick(Sender: TObject);
begin
  if ShowMsg(Format(TransStr('356'),
  [
    TransStr('105'),
    GetFileVersionStr(Paramstr(0)),
    'Copyright © 2020-2023, abysshint',
    TransStr('357')
  ]), TransStr('355'), mtInfo, True) then
  begin
    ShellOpen(GITHUB_URL);
  end;
end;

procedure TTcp.miDisableFiltersOnAuthorityOrBridgeClick(Sender: TObject);
begin
  SetConfigBoolean('Routers', 'DisableFiltersOnAuthorityOrBridge', miDisableFiltersOnAuthorityOrBridge.Checked);
end;

procedure TTcp.miDisableFiltersOnUserQueryClick(Sender: TObject);
begin
  SetConfigBoolean('Routers', 'DisableFiltersOnUserQuery', miDisableFiltersOnUserQuery.Checked);
end;

procedure TTcp.miDisableSelectionUnSuitableAsBridgeClick(Sender: TObject);
begin
  SetConfigBoolean('Routers', 'DisableSelectionUnSuitableAsBridge', miDisableSelectionUnSuitableAsBridge.Checked);
end;

procedure TTcp.miAlwaysShowExitCircuitClick(Sender: TObject);
begin
  ShowCircuits;
  SetConfigBoolean('Circuits', 'AlwaysShowExitCircuit', miAlwaysShowExitCircuit.Checked);
end;

procedure TTcp.miAutoClearClick(Sender: TObject);
begin
  SetConfigBoolean('Log', 'AutoClear', miAutoClear.Checked);
end;

procedure TTcp.miAvoidAddingIncorrectNodesClick(Sender: TObject);
begin
  SetConfigBoolean('Routers', 'AvoidAddingIncorrectNodes', miAvoidAddingIncorrectNodes.Checked);
end;

procedure TTcp.miClearDNSCacheClick(Sender: TObject);
begin
  if not CheckCacheOpConfirmation(TMenuItem(Sender).Caption) then
    Exit;
  SendCommand('SIGNAL CLEARDNSCACHE');
end;

procedure TTcp.ClearScannerCacheClick(Sender: TObject);
var
  GeoIpItem: TPair<string, TGeoIpInfo>;
  GeoIpInfo: TGeoIpInfo;
  ClearType: Byte;
begin
  if not CheckCacheOpConfirmation(TMenuItem(Sender).Caption) then
    Exit;
  ClearType := TMenuItem(Sender).Tag;
  for GeoIpItem in GeoIpDic do
  begin
    GeoIpInfo := GeoIpItem.Value;
    case ClearType of
      1: GeoIpInfo.ping := 0;
      2: GeoIpInfo.ports := '';
    end;
    GeoIpDic.AddOrSetValue(GeoIpItem.Key, GeoIpInfo);
  end;
  LoadConsensus;
  if cbUseBridges.Checked and cbUseBridgesLimit.Checked and
    (ClearType = miClearPingCache.Tag) and (cbxBridgesPriority.ItemIndex = PRIORITY_PING) then
  begin
    OptionsLocked := True;
    ApplyOptions(True);
  end;
  if ConnectState = 0 then
    SaveNetworkCache;
end;

procedure TTcp.EditMenuClick(Sender: TObject);
begin
  case TMenuItem(Sender).Tag of
    1: EditMenuHandle(emCut);
    2: EditMenuHandle(emCopy);
    3: EditMenuHandle(emPaste);
    4: EditMenuHandle(emSelectAll);
    5: EditMenuHandle(emClear);
    6: EditMenuHandle(emDelete);
    7: EditMenuHandle(emFind);
  end;
end;

procedure TTcp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Closing := True;
end;

procedure TTcp.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if (cbxMinimizeOnEvent.ItemIndex in [MINIMIZE_ON_ALL, MINIMIZE_ON_CLOSE])
    and not Closing and not WindowsShutdown then
  begin
    CanClose := WindowsShutdown;
    WindowState := wsMinimized;
    Visible := False;
  end;
end;

procedure TTcp.LoadStaticArray(Data: array of TStaticPair);
var
  i: Integer;
begin
  for i := 0 to Length(Data) - 1 do
    ConstDic.AddOrSetValue(Data[i].Key, Data[i].Value);
end;

procedure TTcp.CheckCircuitsControls(UpdateAll: Boolean = True);
begin
  if miShowCircuitsTraffic.Checked then
  begin
    if UpdateAll then
    begin
      sgCircuits.ColWidths[CIRC_PURPOSE] := -1;
      sgCircuits.ColWidths[CIRC_BYTES_READ] := Round(55 * Scale);
      sgCircuits.ColWidths[CIRC_BYTES_WRITTEN] := Round(55 * Scale);
    end;
    GridScrollCheck(sgCircuits, CIRC_FLAGS, 73);
  end
  else
  begin
    if UpdateAll then
    begin
      sgCircuits.ColWidths[CIRC_FLAGS] := -1;
      sgCircuits.ColWidths[CIRC_BYTES_READ] := -1;
      sgCircuits.ColWidths[CIRC_BYTES_WRITTEN] := -1;
    end;
    GridScrollCheck(sgCircuits, CIRC_PURPOSE, 185);
  end;
end;

procedure TTcp.CheckStreamsControls;
begin
  sgStreamsInfo.Visible := miShowStreamsInfo.Checked;
  if miShowStreamsInfo.Checked then
    sgStreams.Height := Round(177 * Scale)
  else
    sgStreams.Height := Round(297 * Scale);
  if miShowStreamsTraffic.Checked then
  begin
    sgStreams.ColWidths[STREAMS_BYTES_READ] := Round(55 * Scale);
    sgStreams.ColWidths[STREAMS_BYTES_WRITTEN] := Round(55 * Scale);
    GridScrollCheck(sgStreams, STREAMS_TARGET, 338);
    sgStreamsInfo.ColWidths[STREAMS_INFO_SOURCE_ADDR] := Round(129 * Scale);
    sgStreamsInfo.ColWidths[STREAMS_INFO_DEST_ADDR] := Round(129 * Scale);
    sgStreamsInfo.ColWidths[STREAMS_INFO_BYTES_READ] := Round(55 * Scale);
    sgStreamsInfo.ColWidths[STREAMS_INFO_BYTES_WRITTEN] := Round(55 * Scale);
    GridScrollCheck(sgStreamsInfo, STREAMS_INFO_PURPOSE, 134);
  end
  else
  begin
    sgStreams.ColWidths[STREAMS_BYTES_READ] := -1;
    sgStreams.ColWidths[STREAMS_BYTES_WRITTEN] := -1;
    GridScrollCheck(sgStreams, STREAMS_TARGET, 451);
    sgStreamsInfo.ColWidths[STREAMS_INFO_SOURCE_ADDR] := Round(164 * Scale);
    sgStreamsInfo.ColWidths[STREAMS_INFO_DEST_ADDR] := Round(164 * Scale);
    sgStreamsInfo.ColWidths[STREAMS_INFO_BYTES_READ] := -1;
    sgStreamsInfo.ColWidths[STREAMS_INFO_BYTES_WRITTEN] := -1;
    GridScrollCheck(sgStreamsInfo, STREAMS_INFO_PURPOSE, 177);
  end;
end;

procedure TTcp.UpdateScaleFactor;
var
  Factor: Integer;
begin
  Scale := 1.0;
  if Screen.PixelsPerInch <> Screen.DefaultPixelsPerInch then
    Scale := Screen.PixelsPerInch / Screen.DefaultPixelsPerInch
  else
  begin
    if (Win32MajorVersion = 6) and (Win32MinorVersion = 3) then
    begin
      Factor := StrToIntDef(RegistryGetValue(HKEY_CURRENT_USER, 'Control Panel\Desktop', 'DesktopDPIOverride'), 0);
      if Factor <> 0 then
      begin
        case Factor of
          1: Scale := 1.25;
          2: Scale := 1.50;
          3: Scale := 2.0;
        end;
      end;
    end;
  end;

  sgHs.ColWidths[HS_VERSION] := Round(50 * Scale);
  sgHs.ColWidths[HS_INTRO_POINTS] := Round(80 * Scale);
  sgHs.ColWidths[HS_MAX_STREAMS] := Round(90 * Scale);
  sgHs.ColWidths[HS_STATE] := Round(24 * Scale);
  sgHs.ColWidths[HS_PORTS_DATA] := -1;
  sgHs.ColWidths[HS_PREVIOUS_NAME] := -1;
  sgHsPorts.ColWidths[HSP_REAL_PORT] := Round(40 * Scale);
  sgHsPorts.ColWidths[HSP_VIRTUAL_PORT] := Round(87 * Scale);
  sgFilter.ColWidths[FILTER_ID] := Round(35 * Scale);
  sgFilter.ColWidths[FILTER_FLAG] := Round(23 * Scale);
  sgFilter.ColWidths[FILTER_TOTAL] := Round(55 * Scale);
  sgFilter.ColWidths[FILTER_GUARD] := Round(55 * Scale);
  sgFilter.ColWidths[FILTER_EXIT] := Round(55 * Scale);
  sgFilter.ColWidths[FILTER_BRIDGE] := Round(55 * Scale);
  sgFilter.ColWidths[FILTER_ALIVE] := Round(55 * Scale);
  sgFilter.ColWidths[FILTER_PING] := Round(55 * Scale);
  sgFilter.ColWidths[FILTER_ENTRY_NODES] := Round(23 * Scale);
  sgFilter.ColWidths[FILTER_MIDDLE_NODES] := Round(23 * Scale);
  sgFilter.ColWidths[FILTER_EXIT_NODES] := Round(23 * Scale);
  sgFilter.ColWidths[FILTER_EXCLUDE_NODES] := Round(23 * Scale);
  sgRouters.ColWidths[ROUTER_ID] := -1;
  sgRouters.ColWidths[ROUTER_FLAG] := Round(23 * Scale);
  sgRouters.ColWidths[ROUTER_WEIGHT] := Round(63 * Scale);
  sgRouters.ColWidths[ROUTER_PORT] := Round(43 * Scale);
  sgRouters.ColWidths[ROUTER_VERSION] := Round(60 * Scale);
  sgRouters.ColWidths[ROUTER_FLAGS] := Round(96 * Scale);
  sgRouters.ColWidths[ROUTER_ENTRY_NODES] := Round(23 * Scale);
  sgRouters.ColWidths[ROUTER_MIDDLE_NODES] := Round(23 * Scale);
  sgRouters.ColWidths[ROUTER_EXIT_NODES] := Round(23 * Scale);
  sgRouters.ColWidths[ROUTER_EXCLUDE_NODES] := Round(23 * Scale);
  sgCircuits.ColWidths[CIRC_ID] := -1;
  sgCircuits.ColWidths[CIRC_PARAMS] := -1;
  sgCircuits.ColWidths[CIRC_STREAMS] := Round(30 * Scale);
  sgCircuitInfo.ColWidths[CIRC_INFO_ID] := -1;
  sgCircuitInfo.ColWidths[CIRC_INFO_FLAG] := Round(23 * Scale);
  sgCircuitInfo.ColWidths[CIRC_INFO_WEIGHT] := Round(66 * Scale);
  sgStreams.ColWidths[STREAMS_ID] := -1;
  sgStreams.ColWidths[STREAMS_TRACK] := Round(24 * Scale);
  sgStreams.ColWidths[STREAMS_COUNT] := Round(30 * Scale);
  sgStreamsInfo.ColWidths[STREAMS_INFO_ID] := -1;
  sgTransports.ColWidths[PT_HANDLER] := Round(120 * Scale);
  sgTransports.ColWidths[PT_TYPE] := Round(37 * Scale);
  sgTransports.ColWidths[PT_PARAMS] := -1;
  CheckScannerControls;
  CheckCircuitsControls;
  CheckStreamsControls;
end;

procedure TTcp.FormMinimize(Sender: TObject);
begin
  if cbMinimizeToTray.Checked then
  begin
    WindowState := wsMinimized;
    Visible := False;
  end;
end;

procedure TTcp.FormCreate(Sender: TObject);
var
  i: Integer;
  Filter: TFilterInfo;
begin
  LastTrayIconType := MAXWORD;
  WindowsShutdown := False;
  FirstLoad := True;
  FormSize := 1;
  LoadIconsFromResource(lsFlags, 'ICON_FLAGS');
  if not StyleServices.Enabled then
  begin
    paStatus.Color := clBtnFace;
    paCircuits.Color := clBtnFace;
    paRouters.Color := clBtnFace;
  end;

  if (Win32MajorVersion = 5) then
  begin
    btnChangeCircuit.ImageMargins.Right := btnChangeCircuit.ImageMargins.Right - 16;
    btnShowNodes.Images := lsMain;
    btnShowNodes.ImageIndex := 14;
    btnShowNodes.ImageMargins.Left := -32;
  end;

  UpdateScaleFactor;

  hJob := CreateJob(nil, PAnsiChar(AnsiString('TCP-' + UserProfile)));
  if hJob <> 0 then
  begin
    jLimit.BasicLimitInformation.LimitFlags := JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE;
    SetInformationJobObject(hJob, JobObjectExtendedLimitInformation, @jLimit, SizeOf(TJobObjectExtendedLimitInformation));
  end;
  EncodingNoBom := TUTF8EncodingNoBOM.Create;
  Application.OnMinimize := FormMinimize;

  ThemesDir := ProgramDir + 'Skins\';
  HsDir := UserDir + 'services\';
  OnionAuthDir := UserDir + 'onion-auth\';
  LogsDir := UserDir + 'logs\';
  ConsensusFile:= UserDir + 'cached-microdesc-consensus';
  DescriptorsFile := UserDir + 'cached-descriptors';
  NewDescriptorsFile := UserDir + 'cached-descriptors.new';
  UserConfigFile := UserDir + 'settings.ini';
  UserBackupFile := UserConfigFile + '.backup';
  LangFile := ProgramDir + 'Translations.ini';
  DefaultsFile := ProgramDir + 'Defaults.ini';
  TorConfigFile := UserDir + 'torrc';
  TorStateFile := UserDir + 'state';
  TorExeFile := ProgramDir + 'Tor\tor.exe';
  NetworkCacheFile := UserDir + 'network-cache';
  BridgesCacheFile := UserDir + 'bridges-cache';

  UsedFallbackDirs := TDictionary<string, string>.Create;
  NewBridgesList := TDictionary<string, string>.Create;
  UsedBridgesList := TDictionary<string, Byte>.Create;
  CompBridgesDic := TDictionary<string, string>.Create;
  GeoIpDic := TDictionary<string, TGeoIpInfo>.Create;
  CircuitsDic := TDictionary<string, TCircuitInfo>.Create;
  StreamsDic := TDictionary<string, TStreamInfo>.Create;
  RoutersDic := TDictionary<string, TRouterInfo>.Create;
  FilterDic := TDictionary<string, TFilterInfo>.Create;
  NodesDic := TDictionary<string, TNodeTypes>.Create;
  TrackHostDic := TDictionary<string, Byte>.Create;
  VersionsDic := TDictionary<string, Byte>.Create;
  CidrsDic := TDictionary<string, TCidrInfo>.Create;
  PortsDic := TDictionary<Word, Byte>.Create;
  ConstDic := TDictionary<string, Integer>.Create;
  TransportsDic := TDictionary<string, TTransportInfo>.Create;
  BridgesDic := TDictionary<string, TBridgeInfo>.Create;
  DirFetches := TDictionary<string, TFetchInfo>.Create;
  TransportsList := TDictionary<string, Byte>.Create;
  RandomBridges := TStringList.Create;

  DefaultsDic := TDictionary<string, string>.Create;
  DefaultsDic.AddOrSetValue('MaxCircuitDirtiness', '600');
  DefaultsDic.AddOrSetValue('SocksTimeout', '120');
  DefaultsDic.AddOrSetValue('CircuitBuildTimeout', '60');
  DefaultsDic.AddOrSetValue('NewCircuitPeriod', '30');
  DefaultsDic.AddOrSetValue('MaxClientCircuitsPending', '32');
  DefaultsDic.AddOrSetValue('AvoidDiskWrites', '0');
  DefaultsDic.AddOrSetValue('TrackHostExitsExpire', '1800');
  DefaultsDic.AddOrSetValue('LearnCircuitBuildTimeout', '1');
  DefaultsDic.AddOrSetValue('SafeLogging', '1');
  DefaultsDic.AddOrSetValue('UseBridges', '0');
  DefaultsDic.AddOrSetValue('BridgeDistribution', 'any');
  DefaultsDic.AddOrSetValue('DirCache', '1');
  DefaultsDic.AddOrSetValue('Nickname', 'Unnamed');
  DefaultsDic.AddOrSetValue('PublishServerDescriptor', '1');
  DefaultsDic.AddOrSetValue('DirReqStatistics', '1');
  DefaultsDic.AddOrSetValue('HiddenServiceStatistics', '1');
  DefaultsDic.AddOrSetValue('EnforceDistinctSubnets', '1');
  DefaultsDic.AddOrSetValue('AssumeReachable', '0');
  DefaultsDic.AddOrSetValue('RendPostPeriod', '3600');
  DefaultsDic.AddOrSetValue('StrictNodes', '0');
  DefaultsDic.AddOrSetValue('ConnectionPadding', 'auto');
  DefaultsDic.AddOrSetValue('ReducedConnectionPadding', '0');
  DefaultsDic.AddOrSetValue('CircuitPadding', '1');
  DefaultsDic.AddOrSetValue('ReducedCircuitPadding', '0');
  DefaultsDic.AddOrSetValue('DisableNetwork', '0');

  udHsMaxStreams.ResetValue := udHsMaxStreams.Position;
  udHsNumIntroductionPoints.ResetValue := udHsNumIntroductionPoints.Position;
  udHsRealPort.ResetValue := udHsRealPort.Position;
  udHsVirtualPort.ResetValue := udHsVirtualPort.Position;
  cbxHsVersion.ResetValue := HS_VERSION_3;

  for i := 0 to MAX_COUNTRIES - 1 do
  begin
    Filter.cc := i;
    Filter.Data := [];
    FilterDic.Add(CountryCodes[i], Filter);
  end;
  for i := 0 to MAX_SPEED_DATA_LENGTH - 1 do
  begin
    SpeedData[i].DL := -1;
    SpeedData[i].UL := -1;
  end;

  LoadStaticArray(CircuitStatuses);
  LoadStaticArray(CircuitPurposes);
  LoadStaticArray(StreamStatuses);
  LoadStaticArray(StreamPurposes);
  LoadStaticArray(ClientProtocols);

  sgHs.ColsDefaultAlignment[HS_VERSION] := taCenter;
  sgHs.ColsDefaultAlignment[HS_INTRO_POINTS] := taCenter;
  sgHs.ColsDefaultAlignment[HS_MAX_STREAMS] := taCenter;
  sgHs.ColsDefaultAlignment[HS_STATE] := taCenter;
  sgHsPorts.ColsDefaultAlignment[HSP_INTERFACE] := taCenter;
  sgHsPorts.ColsDefaultAlignment[HSP_REAL_PORT] := taCenter;
  sgHsPorts.ColsDefaultAlignment[HSP_VIRTUAL_PORT] := taCenter;
  sgFilter.ColsDefaultAlignment[FILTER_ID] := taCenter;
  sgFilter.ColsDefaultAlignment[FILTER_TOTAL] := taCenter;
  sgFilter.ColsDefaultAlignment[FILTER_GUARD] := taCenter;
  sgFilter.ColsDefaultAlignment[FILTER_EXIT] := taCenter;
  sgFilter.ColsDefaultAlignment[FILTER_BRIDGE] := taCenter;
  sgFilter.ColsDefaultAlignment[FILTER_ALIVE] := taCenter;
  sgFilter.ColsDefaultAlignment[FILTER_PING] := taCenter;
  sgFilter.ColsDefaultAlignment[FILTER_ENTRY_NODES] := taCenter;
  sgFilter.ColsDefaultAlignment[FILTER_MIDDLE_NODES] := taCenter;
  sgFilter.ColsDefaultAlignment[FILTER_EXIT_NODES] := taCenter;
  sgFilter.ColsDefaultAlignment[FILTER_EXCLUDE_NODES] := taCenter;
  sgRouters.ColsDefaultAlignment[ROUTER_WEIGHT] := taRightJustify;
  sgRouters.ColsDefaultAlignment[ROUTER_PORT] := taCenter;
  sgRouters.ColsDefaultAlignment[ROUTER_VERSION] := taCenter;
  sgRouters.ColsDefaultAlignment[ROUTER_PING] := taCenter;
  sgRouters.ColsDefaultAlignment[ROUTER_FLAGS] := taCenter;
  sgRouters.ColsDefaultAlignment[ROUTER_ENTRY_NODES] := taCenter;
  sgRouters.ColsDefaultAlignment[ROUTER_MIDDLE_NODES] := taCenter;
  sgRouters.ColsDefaultAlignment[ROUTER_EXIT_NODES] := taCenter;
  sgRouters.ColsDefaultAlignment[ROUTER_EXCLUDE_NODES] := taCenter;
  sgCircuits.ColsDefaultAlignment[CIRC_BYTES_READ] := taRightJustify;
  sgCircuits.ColsDefaultAlignment[CIRC_BYTES_WRITTEN] := taRightJustify;
  sgCircuits.ColsDefaultAlignment[CIRC_STREAMS] := taCenter;
  sgCircuitInfo.ColsDefaultAlignment[CIRC_INFO_WEIGHT] := taRightJustify;
  sgCircuitInfo.ColsDefaultAlignment[CIRC_INFO_PING] := taCenter;
  sgStreams.ColsDefaultAlignment[STREAMS_TRACK] := taCenter;
  sgStreams.ColsDefaultAlignment[STREAMS_COUNT] := taCenter;
  sgStreams.ColsDefaultAlignment[STREAMS_BYTES_READ] := taRightJustify;
  sgStreams.ColsDefaultAlignment[STREAMS_BYTES_WRITTEN] := taRightJustify;
  sgStreamsInfo.ColsDefaultAlignment[STREAMS_INFO_SOURCE_ADDR] := taCenter;
  sgStreamsInfo.ColsDefaultAlignment[STREAMS_INFO_DEST_ADDR] := taCenter;
  sgStreamsInfo.ColsDefaultAlignment[STREAMS_INFO_PURPOSE] := taCenter;
  sgStreamsInfo.ColsDefaultAlignment[STREAMS_INFO_BYTES_READ] := taRightJustify;
  sgStreamsInfo.ColsDefaultAlignment[STREAMS_INFO_BYTES_WRITTEN] := taRightJustify;
  sgTransports.ColsDefaultAlignment[PT_TYPE] := taCenter;

  sgFilter.ColsDataType[FILTER_TOTAL] := dtInteger;
  sgFilter.ColsDataType[FILTER_GUARD] := dtInteger;
  sgFilter.ColsDataType[FILTER_EXIT] := dtInteger;
  sgFilter.ColsDataType[FILTER_BRIDGE] := dtInteger;
  sgFilter.ColsDataType[FILTER_ALIVE] := dtInteger;
  sgRouters.ColsDataType[ROUTER_WEIGHT] := dtSize;
  sgRouters.ColsDataType[ROUTER_PORT] := dtInteger;
  sgRouters.ColsDataType[ROUTER_FLAGS] := dtParams;
  sgCircuits.ColsDataType[CIRC_ID] := dtInteger;
  sgCircuits.ColsDataType[CIRC_FLAGS] := dtFlags;
  sgCircuits.ColsDataType[CIRC_BYTES_READ] := dtSize;
  sgCircuits.ColsDataType[CIRC_BYTES_WRITTEN] := dtSize;
  sgCircuits.ColsDataType[CIRC_STREAMS] := dtInteger;
  sgStreams.ColsDataType[STREAMS_ID] := dtInteger;
  sgStreams.ColsDataType[STREAMS_TRACK] := dtInteger;
  sgStreams.ColsDataType[STREAMS_BYTES_READ] := dtSize;
  sgStreams.ColsDataType[STREAMS_BYTES_WRITTEN] := dtSize;
  sgStreamsInfo.ColsDataType[STREAMS_INFO_ID] := dtInteger;
  sgStreamsInfo.ColsDataType[STREAMS_INFO_BYTES_READ] := dtSize;
  sgStreamsInfo.ColsDataType[STREAMS_INFO_BYTES_WRITTEN] := dtSize;

  sgFilter.Tag := GRID_FILTER;
  sgRouters.Tag := GRID_ROUTERS;
  sgCircuits.Tag := GRID_CIRCUITS;
  sgStreams.Tag := GRID_STREAMS;
  sgHs.Tag := GRID_HS;
  sgHsPorts.Tag := GRID_HSP;
  sgCircuitInfo.Tag := GRID_CIRC_INFO;
  sgStreamsInfo.Tag := GRID_STREAM_INFO;
  sgTransports.Tag := GRID_TRANSPORTS;

  meBridges.Tag := MEMO_BRIDGES;
  meMyFamily.Tag := MEMO_MY_FAMILY;
  meTrackHostExits.Tag := MEMO_TRACK_HOST_EXITS;
  meFallbackDirs.Tag := MEMO_FALLBACK_DIRS;
  meNodesList.Tag := MEMO_NODES_LIST;
  meExitPolicy.Tag := MEMO_EXIT_POLICY;

  meBridges.ListType := ltBridge;
  meMyFamily.ListType := ltHash;
  meTrackHostExits.ListType := ltHost;
  meFallbackDirs.ListType := ltFallbackDir;
  meNodesList.ListType := ltNode;
  meExitPolicy.ListType := ltPolicy;

  miClearFilterEntry.Tag := ENTRY_ID;
  miClearFilterMiddle.Tag := MIDDLE_ID;
  miClearFilterExit.Tag := EXIT_ID;
  miClearFilterExclude.Tag := EXCLUDE_ID;
  miClearFilterAll.Tag := NONE_ID;

  miClearRoutersEntry.Tag := ENTRY_ID;
  miClearRoutersMiddle.Tag := MIDDLE_ID;
  miClearRoutersExit.Tag := EXIT_ID;
  miClearRoutersExclude.Tag := EXCLUDE_ID;
  miClearRoutersFavorites.Tag := FAVORITES_ID;

  lbFavoritesEntry.HelpKeyword := IntToStr(ENTRY_ID);
  lbFavoritesMiddle.HelpKeyword := IntToStr(MIDDLE_ID);
  lbFavoritesExit.HelpKeyword := IntToStr(EXIT_ID);
  lbExcludeNodes.HelpKeyword := IntToStr(EXCLUDE_ID);
  lbFavoritesTotal.HelpKeyword := IntToStr(FAVORITES_ID);
  lbFavoritesBridges.HelpKeyword := IntToStr(BRIDGES_ID);
  lbFavoritesFallbackDirs.HelpKeyword := IntToStr(FALLBACK_DIR_ID);

  CheckFileEncoding(UserConfigFile, UserBackupFile);
  GetTorVersion(True);
end;

procedure TTcp.ShowTimerEvent(Sender: TObject);
begin
  if not FirstLoad then
  begin
    if TTimer(Sender).Tag = 1 then
    begin
      if not Assigned(VersionChecker) then
      begin
        FreeAndNil(ShowTimer);
        if TorVersion <> '0.0.0.0' then
          StartTor
        else
          ShowMsg(TransStr('238'), '', mtWarning);
      end;
    end
    else
    begin
      if not (cbxMinimizeOnEvent.ItemIndex in [MINIMIZE_ON_ALL, MINIMIZE_ON_STARTUP]) then
        RestoreForm;
      FreeAndNil(ShowTimer);
    end;
  end;
end;

procedure TTcp.LoadOptions(FirstStart: Boolean);
begin
  if FirstStart then
    UpdateConfigVersion;
  SupportVanguardsLite := CheckFileVersion(TorVersion, '0.4.7.1');
  SupportRendPostPeriod := not CheckFileVersion(TorVersion, '0.4.8.1');
  ResetOptions;
  if not Assigned(ShowTimer) then
  begin
    ShowTimer := TTimer.Create(Tcp);
    if not FirstStart then
      ShowTimer.Tag := 1;
    ShowTimer.OnTimer := ShowTimerEvent;
    ShowTimer.Interval := 25;
  end;
end;

function TTCP.GetTorVersion(FirstStart: Boolean): Boolean;
var
  ErrorMode: DWORD;
  Fail: Boolean;
  i: Integer;
  ls: TStringList;
  ParseStr: ArrOfStr;
  ini: TMemIniFile;
  TempVersion: string;
  TorFileExists: Boolean;
begin
  Result := True;
  Fail := True;
  TorVersion := '';
  TempVersion := '';
  TorFileExists := FileExists(TorExeFile);
  if TorFileExists and FileExists(TorStateFile) and FileExists(UserConfigFile) then
  begin
    ls := TStringList.Create;
    try
      ls.LoadFromFile(TorStateFile);
      for i := ls.Count - 1 downto 0 do
      begin
        if InsensPosEx('TorVersion ', ls[i]) = 1 then
        begin
          ParseStr := Explode(' ', ls[i]);
          if Length(ParseStr) > 1 then
          begin
            TempVersion := ParseStr[2];
            Fail := False;
            Break;
          end;
        end;
      end;
    finally
      ls.Free;
    end;
    if not Fail then
    begin
      ini := TMemIniFile.Create(UserConfigFile, TEncoding.UTF8);
      try
        TorFileID := GetSettings('Main', 'TorFileID', '', ini);
      finally
        ini.Free;
      end;
      if TorFileID = GetFileID(TorExeFile, TorFileExists, TempVersion) then
      begin
        TorVersion := TempVersion;
        LoadOptions(FirstStart);
        Exit;
      end
      else
        Fail := True;
    end;
  end;

  if TorFileExists then
  begin
    if not Assigned(GetProcAddress(GetModuleHandle('IPHLPAPI.DLL'), 'if_nametoindex')) then
    begin
      ErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);
      SetErrorMode(ErrorMode or SEM_FAILCRITICALERRORS);
    end;
    TorVersionProcess := ExecuteProcess(TorExeFile + ' --version', [pfHideWindow, pfReadStdOut], hJob);
    if TorVersionProcess.hProcess <> 0 then
    begin
      CheckVersionStart(TorVersionProcess.hStdOutput, FirstStart);
      Fail := False;
    end;
    SetErrorMode(0);
  end;

  if Fail then
  begin
    Result := False;
    TorVersion := '0.0.0.0';
    LoadOptions(FirstStart);
  end;
end;

procedure TTcp.FindDialogFind(Sender: TObject);
begin
  if Assigned(FindObject) then
  begin
    if SearchEdit(FindObject, FindDialog.FindText, FindDialog.Options, SearchFirst) then
      SearchFirst := False
    else
    begin
      if frDown in FindDialog.Options then
        FindObject.SelStart := 1
      else
        FindObject.SelStart := FindObject.GetTextLen;

      if SearchEdit(FindObject, FindDialog.FindText, FindDialog.Options, SearchFirst) then
        SearchFirst := False
      else
        ShowMsg(Format(TransStr('378'), [FindDialog.FindText]));
    end;
    if FindObject.CanFocus then
      FindObject.SetFocus;
  end;
end;

procedure TTcp.FindInCircuits(CircID, NodeID: string; AutoSelect: Boolean = False);
var
  CircuitIndex: Integer;
  NodeIndex: Integer;
begin
  if AutoSelect then
    SelectExitCircuit := True;
  if (UsedProxyType = ptNone) or
     (not miAlwaysShowExitCircuit.Checked and
     (miHideCircuitsWithoutStreams.Checked or not miCircExit.Checked)) then
  begin
    SelectExitCircuit := False;
    Exit;
  end;
  CircuitIndex := sgCircuits.Cols[CIRC_ID].IndexOf(CircID);
  if CircuitIndex > 0 then
  begin
    SetGridLastCell(sgCircuits, True, False, False, CircuitIndex, CIRC_PURPOSE);
    NodeIndex := sgCircuitInfo.Cols[CIRC_ID].IndexOf(NodeID);
    if NodeIndex > 0 then
    begin
      SelectExitCircuit := False;
      SetGridLastCell(sgCircuitInfo, True, False, False, NodeIndex, CIRC_INFO_NAME);
      Exit;
    end;
  end;
end;

procedure TTcp.lbClientVersionClick(Sender: TObject);
begin
  ShellOpen(GetDefaultsValue('DownloadUrl', DOWNLOAD_URL));
end;

procedure TTcp.lbExitCountryDblClick(Sender: TObject);
begin
  if (UsedProxyType <> ptNone) and (ConnectState = 2) then
    FindInFilter(lbExitIp.Caption);
end;

procedure TTcp.lbExitIpMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (UsedProxyType <> ptNone) and (ConnectState = 2) then
  begin
    if (Button = mbLeft) and (ssDouble in Shift) then
    begin
      if ssCtrl in Shift then
        FindInRouters(ExitNodeID)
      else
      begin
        ShowCircuits;
        FindInCircuits(Circuit, ExitNodeID, True);
        sbShowCircuits.Click;
      end;
    end;
  end;
end;

procedure TTcp.lbExitMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  State: Boolean;
begin
  State := (UsedProxyType <> ptNone) and (ConnectState = 2);
  if State then
  begin
    SelNodeState := True;
    if (TLabel(Sender) = lbExitCountry) and (lbExitCountry.Hint <> '') then
      Application.ActivateHint(Mouse.CursorPos)
    else
      Application.CancelHint;
  end;
  mnDetails.AutoPopup := State and (ExitNodeID <> '');
end;

procedure TTcp.ShowFavoritesRouters(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  FavoritesID: Integer;
begin
  if (Button = mbLeft) and (ssDouble in Shift) then
  begin
    FavoritesID := StrToInt(TLabel(Sender).HelpKeyword);
    if ssCtrl in Shift then
    begin
      case FavoritesID of
        ENTRY_ID..EXCLUDE_ID:
        begin
          pcOptions.ActivePage := tsLists;
          sbShowOptions.Click;
          cbxNodesListType.ItemIndex := FavoritesToNodes(FavoritesID);
          LoadNodesList;
        end;
        BRIDGES_ID:
        begin
          pcOptions.ActivePage := tsNetwork;
          sbShowOptions.Click;
        end;
        FALLBACK_DIR_ID:
        begin
          pcOptions.ActivePage := tsLists;
          sbShowOptions.Click;
        end;
      end;
    end
    else
    begin
      if RoutersCustomFilter = FavoritesID then
      begin
        IntToMenu(miRtFilters, RoutersFilters);
        RoutersCustomFilter := LastRoutersCustomFilter;
        LastRoutersCustomFilter := 0;
      end
      else
      begin
        if RoutersCustomFilter in [ENTRY_ID..FALLBACK_DIR_ID] then
          LastRoutersCustomFilter := 0
        else
          LastRoutersCustomFilter := RoutersCustomFilter;
        RoutersCustomFilter := FavoritesID;
      end;
      CheckShowRouters;
      ShowRouters;
      SaveRoutersFilterdata(False, False);
    end;
  end;
end;

function TTcp.GetFormPositionStr: string;
begin
  Result := Format('%d,%d,%d,%d', [DecFormPos.X, DecFormPos.Y, IncFormPos.X, IncFormPos.Y]);
end;

procedure TTcp.FormDestroy(Sender: TObject);
var
  ini: TMemIniFile;
begin
  if ConnectState > 0 then
    StopTor;
  ini := TMemIniFile.Create(UserConfigFile, TEncoding.UTF8);
  try
    SetSettings('Main', 'FormPosition', GetFormPositionStr, ini);
    SetSettings('Main', 'OptionsPage', pcOptions.TabIndex, ini);
    SetSettings('Main', 'LastPlace', LastPlace, ini);
    SetSettings('Main', 'Terminated', False, ini);
    SetSettings('Status', 'TotalDL', TotalDL, ini);
    SetSettings('Status', 'TotalUL', TotalUL, ini);
    SetSettings('Routers', 'CurrentFilter', LastRoutersFilter, ini);
  finally
    UpdateConfigFile(ini);
  end;
  SaveNetworkCache(False);
  if cbxBridgesType.ItemIndex = BRIDGES_TYPE_FILE then
  begin
    if (meBridges.Lines.Count > 0) and not FileExists(BridgesFileName) and not OptionsChanged then
    begin
      try
        meBridges.Lines.SaveToFile(BridgesFileName);
      except
      end;
    end;
  end;

  tiTray.Free;
  StreamsDic.Free;
  CircuitsDic.Free;
  FilterDic.Free;
  RoutersDic.Free;
  GeoIpDic.Free;
  NodesDic.Free;
  TrackHostDic.Free;
  VersionsDic.Free;
  TransportsDic.Free;
  TransportsList.Free;
  BridgesDic.Free;
  NewBridgesList.Free;
  UsedBridgesList.Free;
  CompBridgesDic.Free;
  RandomBridges.Free;
  UsedFallbackDirs.Free;
  CidrsDic.Free;
  DirFetches.Free;
  PortsDic.Free;
  ConstDic.Free;
  DefaultsDic.Free;
  LangStr.Free;
  TorConfig.Free;
  EncodingNoBom.Free;
  ExitProcess(Handle);
end;

procedure TTcp.FormPaint(Sender: TObject);
begin
  EnableComposited(Tcp.gbOptions);
  EnableComposited(Tcp.gbControlAuth);
  EnableComposited(Tcp.gbInterface);
  EnableComposited(Tcp.gbProfile);
  EnableComposited(Tcp.gbHsEdit);
  EnableComposited(Tcp.gbNetworkScanner);
  EnableComposited(Tcp.gbAutoSelectRouters);
  if (LastPlace = LP_LOG) and (FormSize = 1) then
    CheckLogAutoScroll;
end;

procedure TTcp.FormResize(Sender: TObject);
begin
  UpdateFormSize;
end;

procedure TTcp.UpdateTrayHint;
var
  DataStr: string;
begin
  if (UsedProxyType <> ptNone) then
  begin
    DataStr := lbExitIpCaption.Caption + ' ' + lbExitIp.Caption + BR +
      lbExitCountryCaption.Caption + ' ' + lbExitCountry.Caption + BR;
  end
  else
  begin
    DataStr := TransStr('609') + ': ' + TransStr('226') + BR;
  end;
  tiTray.Hint := Format(TransStr('106'), [DataStr, Tcp.lbUserDir.Caption]);
end;

procedure TTcp.tiTrayClick(Sender: TObject);
begin
  if Tcp.Visible then
  begin
    FindDialog.CloseDialog;
    WindowState := wsMinimized;
    Visible := False;
  end
  else
    RestoreForm;
end;

procedure TTcp.tmCircuitsTimer(Sender: TObject);
begin
  ShowCircuits(ConnectState <> 2)
end;

procedure TTcp.tmConsensusTimer(Sender: TObject);
var
  ConsensusDate, NewDescriptorsDate: TDatetime;

  procedure UpdateOptions;
  begin
    OptionsLocked := True;
    BridgesUpdated := True;
    ApplyOptions(True);
  end;

begin
  if FileAge(ConsensusFile, ConsensusDate) then
  begin
    if (ConsensusDate <> LastConsensusDate) then
      LoadConsensus
    else
    begin
      if cbUseBridges.Checked then
      begin
        if FileAge(NewDescriptorsFile, NewDescriptorsDate) then
        begin
          if (NewDescriptorsDate <> LastNewDescriptorsDate) then
            LoadDescriptors;
        end;
      end;
    end;
  end;
  if cbUseBridges.Checked and cbExcludeUnsuitableBridges.Checked and (CurrentScanPurpose <> spAuto) then
  begin
    if (FailedBridgesCount > 0) or (((NewBridgesCount > 0) or (NewBridgesStage = 1)) and (ConnectState = 2)) then
      Inc(FailedBridgesInterval, 3);
  end;
  if not (Assigned(Consensus) or Assigned(Descriptors) or tmScanner.Enabled) then
  begin
    if ScanNewBridges and not (FindBridgesCountries or FindFallbackDirCountries) then
      ScanNetwork(stAlive, spNewBridges)
    else
    begin
      if (AutoScanStage = 1) and (ConnectState = 2) then
        ScanNetwork(stBoth, spAuto)
      else
      begin
        if (NewBridgesStage = 1) and (NewBridgesCount = 0) and (FailedBridgesCount = 0) then
        begin
          NewBridgesStage := 0;
          UpdateOptions;
        end
        else
        begin
          if FailedBridgesInterval >= udBridgesCheckDelay.Position then
          begin
            if FailedBridgesCount > 0 then
              UpdateOptions
            else
            begin
              if NewBridgesCount > 0 then
              begin
                if NewBridgesStage = 0 then
                begin
                  NewBridgesStage := 1;
                  UpdateOptions;
                end
                else
                begin
                  if FailedBridgesInterval > udSocksTimeout.Position + udBridgesCheckDelay.Position + (udMaxDirFails.Position + 1) * 15 then
                  begin
                    NewBridgesStage := 0;
                    UpdateOptions;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TTcp.tmUpdateIpTimer(Sender: TObject);
begin
  SendDataThroughProxy;
end;

procedure TTcp.miSaveTemplateClick(Sender: TObject);
var
  ini: TMemIniFile;
  TemplateName, EntryNodes, MiddleNodes, ExitNodes: string;
  FavoritesEntry, FavoritesMiddle, FavoritesExit, ExcludeNodes: string;
  Item: TPair<string, TFilterInfo>;
  NodeItem: TPair<string, TNodeTypes>;
begin
  TemplateName := InputBox(TransStr('256'), TransStr('257') + ':', '');
  if Trim(TemplateName) <> '' then
  begin
    if Pos(';', TemplateName) = 0 then
    begin
      ini := TMemIniFile.Create(UserConfigFile, TEncoding.UTF8);
      try
        EntryNodes := '';
        MiddleNodes := '';
        ExitNodes := '';
        FavoritesEntry := '';
        FavoritesMiddle := '';
        FavoritesExit := '';
        ExcludeNodes := '';

        if miTplSaveCountries.Checked then
        begin
          for Item in FilterDic do
          begin
            if ntEntry in Item.Value.Data then
              EntryNodes := EntryNodes + ',' + Item.Key;
            if ntMiddle in Item.Value.Data then
              MiddleNodes := MiddleNodes + ',' + Item.Key;
            if ntExit in Item.Value.Data then
              ExitNodes := ExitNodes + ',' + Item.Key;
          end;
          Delete(EntryNodes, 1, 1);
          Delete(MiddleNodes, 1, 1);
          Delete(ExitNodes, 1, 1);
        end;

        if miTplSaveRouters.Checked or miTplSaveExcludes.Checked then
        begin
          for NodeItem in NodesDic do
          begin
            if miTplSaveRouters.Checked then
            begin
              if ntEntry in NodeItem.Value then
                FavoritesEntry := FavoritesEntry + ',' + NodeItem.Key;
              if ntMiddle in NodeItem.Value then
                FavoritesMiddle := FavoritesMiddle + ',' + NodeItem.Key;
              if ntExit in NodeItem.Value then
                FavoritesExit := FavoritesExit + ',' + NodeItem.Key;
            end;
            if miTplSaveExcludes.Checked then
              if ntExclude in NodeItem.Value then
                ExcludeNodes := ExcludeNodes + ',' + NodeItem.Key;
          end;
          if miTplSaveRouters.Checked then
          begin
            Delete(FavoritesEntry, 1, 1);
            Delete(FavoritesMiddle, 1, 1);
            Delete(FavoritesExit, 1, 1);
          end;
          if miTplSaveExcludes.Checked then
            Delete(ExcludeNodes, 1, 1);
        end;

        SetSettings('Templates', IntToStr(DateTimeToUnix(Now)), TemplateName + ';' +
          IntToStr(cbxFilterMode.ItemIndex) + ';' +
          EntryNodes + ';' + MiddleNodes + ';' + ExitNodes + ';' +
          FavoritesEntry + ';' + FavoritesMiddle + ';' + FavoritesExit + ';' + ExcludeNodes,
        ini);

      finally
        UpdateConfigFile(ini);
      end;
      ShowBalloon(Format(TransStr('363'), [TemplateName]));
    end
    else
      ShowMsg(Format(TransStr('255'), [';']), '', mtWarning);
  end;
end;

procedure TTcp.SelectLogSeparater(Sender: TObject);
var
  SeparateType: Byte;
begin
  TMenuItem(Sender).Checked := True;
  SeparateType := TMenuItem(Sender).Tag;
  TorLogFile := GetLogFileName(SeparateType);
  SetConfigInteger('Log', 'SeparateType', SeparateType);
end;

procedure TTcp.SelectLogAutoDelInterval(Sender: TObject);
begin
  TMenuItem(Sender).Checked := True;
  LogAutoDelHours := TMenuItem(Sender).Tag;
  SetConfigInteger('Log', 'LogAutoDelType', TMenuItem(Sender).MenuIndex);
end;

procedure TTcp.SelectLogScrollbar(Sender: TObject);
begin
  SetLogScrollBar(TMenuItem(Sender).Tag, TMenuItem(Sender));
end;

procedure TTcp.SetLogScrollBar(ScrollType: Byte; Menu: TMenuItem = nil);
begin
  case ScrollType of
    0: meLog.ScrollBars := ssVertical;
    1: meLog.ScrollBars := ssHorizontal;
    2: meLog.ScrollBars := ssBoth;
    3: meLog.ScrollBars := ssNone;
  end;
  if ScrollType in [1,2] then
    sbWordWrap.Enabled := False
  else
    sbWordWrap.Enabled := True;

  if Menu <> nil then
  begin
    Menu.Checked := True;
    CheckLogAutoScroll(True);
    SetConfigInteger('Log', 'ScrollBars', ScrollType);
  end;
end;

procedure TTcp.miServerInfoClick(Sender: TObject);
begin
  OpenMetricsUrl('#details', lbFingerprint.Caption);
end;

procedure TTcp.miOpenFileLogClick(Sender: TObject);
begin
  ShellOpen(TorLogFile);
end;

procedure TTcp.miOpenLogsFolderClick(Sender: TObject);
begin
  ShellOpen(GetFullFileName(LogsDir));
end;

procedure TTcp.SelectTrafficPeriod(Sender: TObject);
begin
  if TMenuItem(Sender).Checked then
    Exit;
  TMenuItem(Sender).Checked := True;
  CurrentTrafficPeriod := TMenuItem(Sender).Tag;
  pbTraffic.Repaint;
  SetConfigInteger('Status', 'CurrentTrafficPeriod', CurrentTrafficPeriod);
end;

procedure TTcp.miPreferWebTelegramClick(Sender: TObject);
begin
  SetConfigBoolean('Network', 'PreferWebTelegram', miPreferWebTelegram.Checked);
end;

procedure TTcp.ResetGuards(GuardType: TGuardType);
var
  ls: TStringList;
  i: Integer;
  TypeStr: string;
begin
  if not FileExists(TorStateFile) then
    Exit;
  case Byte(GuardType) of
    1: TypeStr := 'in=bridges';
    2: TypeStr := 'in=restricted';
    3: TypeStr := 'in=default';
    else
      TypeStr := '';
  end;

  ls := TStringList.Create;
  try
    ls.LoadFromFile(TorStateFile);
    for i := ls.Count - 1 downto 0 do
    begin
      if (Pos('Guard ' + TypeStr, ls[i]) = 1) then
        ls.Delete(i);
    end;
    ls.SaveToFile(TorStateFile);
    miResetGuards.Tag := 0;
  finally
    ls.Free;
  end;
end;

procedure TTcp.miUpdateIpToCountryCacheClick(Sender: TObject);
begin
  if not CheckCacheOpConfirmation(TMenuItem(Sender).Caption) then
    Exit;
  GeoIpUpdating := True;
  InfoStage := 1;
end;

procedure TTcp.SetResetGuards(Sender: TObject);
var
  Temp: string;
begin
  miResetGuards.Tag := TMenuItem(Sender).Tag;
  if ConnectState = 2 then
    Temp := TransStr('164') + '. '
  else
    Temp := '';
  if ShowMsg(Format(TransStr('346'), [Temp]), '', mtWarning, True) then
  begin
    if ConnectState = 2 then
      RestartTor(1)
    else
      ResetGuards(TGuardType(miResetGuards.Tag));
  end;
end;

procedure TTcp.miRtDisableBridgesClick(Sender: TObject);
begin
  cbUseBridges.Checked := False;
  SaveBridgesData;
  ShowRouters;
  EnableOptionButtons;
end;

procedure TTcp.miRtRelayInfoClick(Sender: TObject);
begin
  ShowRelayInfo(sgRouters, True);
end;

procedure TTcp.miRtResetFilterClick(Sender: TObject);
var
  ini: TMemIniFile;
  Data: string;
  ParseStr: ArrOfStr;
  i: Integer;
begin
  ini := TMemIniFile.Create(UserConfigFile, TEncoding.UTF8);
  try
    Data := GetSettings('Routers', 'DefaultFilter', DEFAULT_ROUTERS_FILTER_DATA, ini);
    LoadRoutersFilterData(Data);
    ParseStr := Explode(';', Data);
    if Length(ParseStr) > 7 then
    begin
      if Trim(ParseStr[8]) = '' then
        ParseStr[7] := IntToStr(cbxRoutersQuery.ItemIndex);
      Data := '';
      for i := 0 to Length(ParseStr) - 1 do
        Data := Data + ';' + ParseStr[i];
      Delete(Data, 1, 1);
    end;
    LastRoutersFilter := Data;
  finally
    ini.Free;
  end;
end;

procedure TTcp.miRtSaveDefaultClick(Sender: TObject);
begin
  SaveRoutersFilterdata(True);
end;

procedure TTcp.miRoutersScrollTopClick(Sender: TObject);
begin
  SetConfigBoolean('Routers', 'RoutersScrollTop', miRoutersScrollTop.Checked);
end;

procedure TTcp.SelectNodeAsBridge(Sender: TObject);
var
  UseIPv6: Boolean;
  BridgeStr, BridgeID: string;
  Router: TRouterInfo;
begin
  BridgeID := TMenuItem(Sender).Hint;
  UseIPv6 := TMenuItem(Sender).Tag = 1;
  if RoutersDic.TryGetValue(BridgeID, Router) then
  begin
    BridgeStr := GetBridgeStr(BridgeID, Router, UseIPv6);
    if BridgeStr <> '' then
    begin
      cbUseBridges.Checked := True;
      cbUsePreferredBridge.Checked := True;
      edPreferredBridge.Text := BridgeStr;
      LastPreferBridgeID := BridgeID;
      SaveBridgesData;
      ShowRouters;
      EnableOptionButtons;
    end;
  end;
end;

procedure TTcp.miRoutersSelectRowClick(Sender: TObject);
begin
  CheckSelectRowOptions(sgRouters, miRoutersSelectRow.Checked, True);
end;

procedure TTcp.OpenMetricsUrl(Page, Query: string);
begin
  if Query = '' then
    Exit;
  ShellOpen(GetDefaultsValue('MetricsUrl', METRICS_URL) + Page + '/' + Query);
end;

procedure TTcp.OptionsChange(Sender: TObject);
begin
  EnableOptionButtons;
end;

procedure TTcp.miDetailsRelayInfoClick(Sender: TObject);
begin
  ShowRelayInfo(sgCircuitInfo, True);
end;

procedure TTcp.miDetailsUpdateIpClick(Sender: TObject);
begin
  SendDataThroughProxy;
end;

procedure TTcp.miDestroyExitCircuitsClick(Sender: TObject);
var
  Item: TPair<string, TCircuitInfo>;
  ParseStr: ArrOfStr;
  Temp: string;
  i: Integer;
begin
  if (ConnectState <> 2) then
    Exit;
    
  Temp := '';
  for Item in CircuitsDic do
    if not (bfInternal in Item.Value.BuildFlags) then
      Temp := Temp + ',' + Item.Key;
  Delete(Temp, 1, 1);
  
  if Temp <> '' then
  begin
    btnChangeCircuit.Enabled := False;
    miChangeCircuit.Enabled := False;
    ParseStr := Explode(',', Temp);
    Temp := '';
    for i := 0 to Length(ParseStr) - 1 do
    begin
      CircuitsDic.Remove(ParseStr[i]);
      Temp := Temp + BR + 'CLOSECIRCUIT ' + ParseStr[i];
    end;
    Delete(Temp, 1, Length(BR));
    ShowCircuits;
    SendCommand(Temp);
  end;
end;

procedure TTcp.CloseCircuit(CircuitID: string; AutoUpdate: Boolean = True);
begin
  if (CircuitID = '') or (ConnectState <> 2) then
    Exit;
  if CircuitsDic.ContainsKey(CircuitID) then
  begin
    CircuitsDic.Remove(CircuitID);
    SendCommand('CLOSECIRCUIT ' + CircuitID);
  end;
  if AutoUpdate then
    ShowCircuits;
end;

procedure TTcp.ClearBridgesCache(Sender: TObject);
var
  IpList: TDictionary<string, Byte>;
  Item: TPair<string, TBridgeInfo>;
  GeoIpInfo: TGeoIpInfo;
  RouterInfo: TRouterInfo;
  ClearAll, Deleted: Boolean;
  Bridge: TBridge;
  i: Integer;
  ls: TStringList;

  procedure AddToRemoveList;
  begin
    ls.Append(Item.Key);
    Deleted := True;
  end;

begin
  if not CheckCacheOpConfirmation(TMenuItem(Sender).Caption) then
    Exit;
  DeleteFile(DescriptorsFile);
  DeleteFile(NewDescriptorsFile);
  ClearAll := TMenuItem(Sender).Tag = 1;
  if ClearAll then
  begin
    for Item in BridgesDic do
    begin
      if RoutersDic.TryGetValue(Item.Key, RouterInfo) then
      begin
        if not (rfRelay in RouterInfo.Flags) then
        begin
          if GeoIpDic.TryGetValue(RouterInfo.IPv4, GeoIpInfo) then
            SetPortsValue(RouterInfo.IPv4, IntToStr(RouterInfo.Port), 0);
          RoutersDic.Remove(Item.Key);
        end;
      end
    end;
    BridgesDic.Clear;
    CompBridgesDic.Clear;
  end
  else
  begin
    IpList := TDictionary<string, Byte>.Create;
    ls := TStringList.Create;
    try
      if cbxBridgesType.ItemIndex <> BRIDGES_TYPE_BUILTIN then
      begin
        for i := 0 to meBridges.Lines.Count - 1 do
        begin
          if TryParseBridge(meBridges.Lines[i], Bridge) then
          begin
            if Bridge.Hash <> '' then
              IpList.AddOrSetValue(Bridge.Hash, 0);
          end;
        end;
      end;
      if TryParseBridge(Trim(edPreferredBridge.Text), Bridge) then
        IpList.AddOrSetValue(Bridge.Hash, 0);

      for Item in BridgesDic do
      begin
        Deleted := False;
        if RoutersDic.TryGetValue(Item.Key, RouterInfo) then
        begin
          if rfRelay in RouterInfo.Flags then
          begin
            if not IpList.ContainsKey(Item.Key) then
              AddToRemoveList;
          end;
        end
        else
        begin
          if Item.Value.Kind = BRIDGE_RELAY then
            AddToRemoveList;
        end;
        if not Deleted then
        begin
          if GeoIpDic.TryGetValue(Item.Value.Router.IPv4, GeoIpInfo) then
          begin
            if GetPortsValue(GeoIpInfo.ports, IntToStr(Item.Value.Router.Port)) = -1 then
              AddToRemoveList;
          end;
        end;
        if Deleted then
        begin
          if Item.Value.Source <> '' then
            CompBridgesDic.Remove(Item.Value.Source);
        end;
      end;
      for i := 0 to ls.Count - 1 do
        BridgesDic.Remove(ls[i]);
    finally
      ls.Free;
      IpList.Free;
    end;
  end;
  ConsensusUpdated := True;
  ApplyOptions(True);
  SaveNetworkCache(False);
end;

procedure TTcp.ClearAvailableCache(Sender: TObject);
var
  ls: TStringList;
  MemoID, i: Integer;
  HashStr, Separator: string;
  DeleteFlag: Boolean;
  CurrentMemo: TMemo;
begin
  MemoID := miClearMenu.Tag;
  case MemoID of
    MEMO_BRIDGES: CurrentMemo := meBridges;
    MEMO_FALLBACK_DIRS: CurrentMemo := meFallbackDirs;
    else
      Exit;
  end;
  DeleteFlag := TMenuItem(Sender).Tag = 1;
  ls := TStringList.Create;
  try
    if MemoID = MEMO_FALLBACK_DIRS then
      Separator := '='
    else
      Separator := '';
    ls.Text := CurrentMemo.Text;
    for i := ls.Count - 1 downto 0 do
    begin
      if TryGetDataFromStr(ls[i], ltHash, HashStr, Separator) then
      begin
        if RoutersDic.ContainsKey(HashStr) then
        begin
          if DeleteFlag then
            ls.Delete(i);
        end
        else
        begin
          if not DeleteFlag then
            ls.Delete(i);
        end;
      end;
    end;
    CurrentMemo.Text := ls.Text;
    case MemoID of
      MEMO_BRIDGES: SaveBridgesData;
      MEMO_FALLBACK_DIRS: SaveFallbackDirsData;
    end;
    if CurrentMemo.Text = '' then
      ResetFocus;
  finally
    ls.Free;
  end;
end;

procedure TTcp.miClearMenuAllClick(Sender: TObject);
begin
  case miClearMenu.Tag of
    MEMO_BRIDGES:
    begin
      meBridges.Text := '';
      SaveBridgesData;
    end;
    MEMO_FALLBACK_DIRS:
    begin
      meFallbackDirs.Text := '';
      SaveFallbackDirsData;
    end
    else
      Exit;
  end;
  EnableOptionButtons;
  ResetFocus;
end;

procedure TTcp.miClearMenuNotAliveClick(Sender: TObject);
begin
  case miClearMenu.Tag of
    MEMO_BRIDGES: ScanNetwork(stAlive, spUserBridges);
    MEMO_FALLBACK_DIRS: ScanNetwork(stAlive, spUserFallbackDirs);
  end;
end;

procedure TTcp.miClearMenuUnsuitableClick(Sender: TObject);
var
  PrefferedBridge: string;
  LastDataCount, SuitableDataCount, MemoID: Integer;
  ls: TStringList;
  CurrentMemo: TMemo;
begin
  MemoID := miClearMenu.Tag;
  case MemoID of
    MEMO_BRIDGES: CurrentMemo := meBridges;
    MEMO_FALLBACK_DIRS: CurrentMemo := meFallbackDirs;
    else
      Exit;
  end;
  LastDataCount := CurrentMemo.Lines.Count;
  ls := TStringList.Create;
  try
    if MemoID = MEMO_BRIDGES then
    begin
      PrefferedBridge := Trim(edPreferredBridge.Text);
      ls.Text := PrefferedBridge;
      ExcludeUnSuitableBridges(ls, True);
      if (SuitableBridgesCount = 0) and (PrefferedBridge <> '') then
      begin
        cbUsePreferredBridge.Checked := False;
        edPreferredBridge.Text := '';
        BridgesUpdated := True;
      end;
    end;

    ls.Text := CurrentMemo.Text;
    case MemoID of
      MEMO_BRIDGES:
      begin
        ExcludeUnSuitableBridges(ls, True);
        SuitableDataCount := SuitableBridgesCount;
      end;
      MEMO_FALLBACK_DIRS:
      begin
        ExcludeUnSuitableFallbackDirs(ls);
        SuitableDataCount := SuitableFallbackDirsCount;
      end;
      else
        Exit;
    end;
    if LastDataCount <> SuitableDataCount then
      CurrentMemo.Text := ls.Text;

    if BridgesUpdated then
      SaveBridgesData;

    if FallbackDirsUpdated then
      SaveFallbackDirsData;

    if CurrentMemo.Text = '' then
      ResetFocus;
  finally
    ls.Free;
  end;
end;

procedure TTcp.miDestroyCircuitClick(Sender: TObject);
begin
  CloseCircuit(sgCircuits.Cells[CIRC_ID, sgCircuits.SelRow]);
end;

procedure TTcp.CloseStream(StreamID: string);
var
  CircuitInfo: TCircuitInfo;
  StreamInfo: TStreamInfo;
begin
  if (ConnectState <> 2) or (StreamID = '') then
    Exit;
  if StreamsDic.TryGetValue(StreamID, StreamInfo) then
  begin
    if CircuitsDic.TryGetValue(StreamInfo.CircuitID, CircuitInfo) then
    begin
      Dec(CircuitInfo.Streams);
      CircuitsDic.AddOrSetValue(StreamInfo.CircuitID, CircuitInfo);
    end;
    StreamsDic.Remove(StreamID);
    SendCommand('CLOSESTREAM ' + StreamID + ' 1');
    ShowCircuits;
  end;
end;

procedure TTcp.CloseStreams(CircuitID: string; FindTarget: Boolean = False; TargetID: string = '');
var
  Item: TPair<string, TStreamInfo>;
  CircuitInfo: TCircuitInfo;
  Temp: string;
  ParseStr: ArrOfStr;
  i: Integer;
  Flag: Boolean;
  StreamsCount: Integer;
begin
  if (ConnectState <> 2) or (CircuitID = '') then
    Exit;
  if FindTarget and (TargetID = '') then
    Exit;
  if sgCircuits.Cells[CIRC_STREAMS, sgCircuits.SelRow] = EXCLUDE_CHAR then
    Exit;
  if CircuitsDic.TryGetValue(CircuitID, CircuitInfo) then
  begin
    StreamsCount := 0;
    Temp := '';
    for Item in StreamsDic do
    begin
      if TargetID = '' then
        Flag := Item.Value.CircuitID = CircuitID
      else
        Flag := (Item.Value.CircuitID = CircuitID) and (Item.Value.Target = TargetID);
      if Flag then
      begin
        Temp := Temp + ',' + Item.Key;
        Inc(StreamsCount);
      end;
    end;
    Delete(Temp, 1, 1);
    if StreamsCount > 0 then
    begin
      ParseStr := Explode(',', Temp);
      Temp := '';
      for i := 0 to Length(ParseStr) - 1 do
      begin
        StreamsDic.Remove(ParseStr[i]);
        Temp := Temp + BR + 'CLOSESTREAM ' + ParseStr[i] + ' 1';
      end;
      Delete(Temp, 1, Length(BR));
      Dec(CircuitInfo.Streams, StreamsCount);
      CircuitsDic.AddOrSetValue(CircuitID, CircuitInfo);
      SendCommand(Temp);
      ShowCircuits;
    end;
  end;
end;

procedure TTcp.miDestroyStreamsClick(Sender: TObject);
begin
  CloseStreams(sgCircuits.Cells[CIRC_ID, sgCircuits.SelRow]);
end;

procedure TTcp.miHsOpenDirClick(Sender: TObject);
begin
  ShellOpen(GetFullFileName(HsDir + sgHs.Cells[HS_NAME, sgHs.SelRow]));
end;

procedure TTcp.miIgnoreTplLoadParamsOutsideTheFilterClick(Sender: TObject);
begin
  SetConfigBoolean('Filter', 'IgnoreTplLoadParamsOutsideTheFilter', miIgnoreTplLoadParamsOutsideTheFilter.Checked);
end;

procedure TTcp.miLoadCachedRoutersOnStartupClick(Sender: TObject);
begin
  if miLoadCachedRoutersOnStartup.Checked and (ConnectState = 0) and (RoutersDic.Count = 0) then
    LoadConsensus;
  SetConfigBoolean('Routers', 'LoadCachedRoutersOnStartup', miLoadCachedRoutersOnStartup.Checked);
end;

procedure TTcp.miManualDetectAliveNodesClick(Sender: TObject);
begin
  SetConfigBoolean('Scanner', 'ManualDetectAliveNodes', miManualDetectAliveNodes.Checked);
end;

procedure TTcp.miManualPingMeasureClick(Sender: TObject);
begin
  SetConfigBoolean('Scanner', 'ManualPingMeasure', miManualPingMeasure.Checked);
end;

procedure TTcp.miNotLoadEmptyTplDataClick(Sender: TObject);
begin
  SetConfigBoolean('Filter', 'NotLoadEmptyTplData', miNotLoadEmptyTplData.Checked);
end;

end.
