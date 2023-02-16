unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.CommCtrl, Winapi.Winsock, Winapi.ShellApi,
  Winapi.ShlObj, Winapi.GDIPAPI, Winapi.GDIPOBJ, System.SysUtils, System.IniFiles,
  System.Generics.Collections, System.ImageList, System.DateUtils, System.Math,
  Vcl.Forms, System.Classes, System.Masks, Vcl.ImgList, Vcl.Controls, Vcl.ExtCtrls,
  Vcl.Menus, Vcl.StdCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.Clipbrd, Vcl.Dialogs, Vcl.Graphics,
  Vcl.Themes, Vcl.Buttons, blcksock, dnssend, httpsend, pingsend, synacode, synautil,
  ConstData, Functions, Addons, Languages;

type
  TUserGrid = class(TCustomGrid);

  TRouterFlag = (rfAuthority, rfBadExit, rfExit, rfFast, rfGuard, rfHSDir, rfStable, rfV2Dir, rfBridge, rfRelay);
  TRouterFlags = set of TRouterFlag;
  TRouterInfo = record
    Name: string;
    IPv4: string;
    IPv6: string;
    OrPort: Word;
    DirPort: Word;
    Flags: TRouterFlags;
    Version: string;
    Bandwidth: Integer;
    Params: Byte;
  end;

  TSpeedData = record
    DL: Integer;
    UL: Integer;
  end;

  TTransportInfo = record
    TransportID: Byte;
    BridgeType: TBridgeTypes;
  end;

  TBridgeInfo = record
    Router: TRouterInfo;
    Kind: Byte;
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
    Date: string;
    BytesRead: int64;
    BytesWritten: int64;
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
    CountryCode, IpID: Byte;
    procedure GetData;
    procedure SendData(cmd: string);
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
    miAutoScroll: TMenuItem;
    miShowOptions: TMenuItem;
    miShowLog: TMenuItem;
    miDelimiter1: TMenuItem;
    miDelimiter2: TMenuItem;
    miWriteLogFile: TMenuItem;
    miSafeLogging: TMenuItem;
    miLogOptions: TMenuItem;
    miLogSelectAll: TMenuItem;
    miLogCopy: TMenuItem;
    miDelimiter3: TMenuItem;
    miDelimiter4: TMenuItem;
    miLogLevel: TMenuItem;
    miDebug: TMenuItem;
    miInfo: TMenuItem;
    miNotice: TMenuItem;
    miWarn: TMenuItem;
    miErr: TMenuItem;
    miWordWrap: TMenuItem;
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
    miDetailsCopy: TMenuItem;
    miDetailsCopyFingerprint: TMenuItem;
    miDetailsCopyIPv4: TMenuItem;
    miDetailsSelectTemplate: TMenuItem;
    miDelimiter8: TMenuItem;
    miDetailsCopyNickname: TMenuItem;
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
    lbSeconds4: TLabel;
    lbTotalHosts: TLabel;
    lbTrackHostExitsExpire: TLabel;
    lbTotalNodesList: TLabel;
    meTrackHostExits: TMemo;
    cbUseTrackHostExits: TCheckBox;
    cbEnableNodesList: TCheckBox;
    meNodesList: TMemo;
    edTrackHostExitsExpire: TEdit;
    udTrackHostExitsExpire: TUpDown;
    lbTotalMyFamily: TLabel;
    tmConsensus: TTimer;
    miFilterOptions: TMenuItem;
    miDelimiter19: TMenuItem;
    miFilterHideUnused: TMenuItem;
    miFilterScrollTop: TMenuItem;
    mnRouters: TPopupMenu;
    miRtCopy: TMenuItem;
    miRtCopyNickname: TMenuItem;
    miRtCopyIPv4: TMenuItem;
    miRtCopyFingerprint: TMenuItem;
    miRtRelayInfo: TMenuItem;
    lbFilterCount: TLabel;
    lbFilterEntry: TLabel;
    lbFilterMiddle: TLabel;
    lbFilterExit: TLabel;
    miClearFilterExit: TMenuItem;
    miDelimiter20: TMenuItem;
    lbFavoritesChar: TLabel;
    lbFavoritesEntry: TLabel;
    lbFavoritesMiddle: TLabel;
    lbFavoritesExit: TLabel;
    lbExcludeNodes: TLabel;
    lbExcludeChar: TLabel;
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
    miRtCopyIPv6: TMenuItem;
    miDetailsCopyIPv6: TMenuItem;
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
    cbMinimizeOnClose: TCheckBox;
    cbMinimizeOnStartup: TCheckBox;
    cbConnectOnStartup: TCheckBox;
    cbRestartOnControlFail: TCheckBox;
    cbNoDesktopBorders: TCheckBox;
    cbRememberEnlargedPosition: TCheckBox;
    gbOptions: TGroupBox;
    lbMaxCircuitDirtiness: TLabel;
    lbSeconds1: TLabel;
    lbCircuitBuildTimeout: TLabel;
    lbSeconds2: TLabel;
    lbSeconds3: TLabel;
    lbNewCircuitPeriod: TLabel;
    cbAvoidDiskWrites: TCheckBox;
    cbLearnCircuitBuildTimeout: TCheckBox;
    cbEnforceDistinctSubnets: TCheckBox;
    edMaxCircuitDirtiness: TEdit;
    udMaxCircuitDirtiness: TUpDown;
    edNewCircuitPeriod: TEdit;
    udNewCircuitPeriod: TUpDown;
    edCircuitBuildTimeout: TEdit;
    udCircuitBuildTimeout: TUpDown;
    cbUseOpenDNS: TCheckBox;
    cbUseOpenDNSOnlyWhenUnknown: TCheckBox;
    miStreamsSortTrack: TMenuItem;
    miSelectExitCircuitWhetItChanges: TMenuItem;
    lsTray: TImageList;
    paButtons: TPanel;
    sbShowLog: TSpeedButton;
    sbShowOptions: TSpeedButton;
    paLog: TPanel;
    meLog: TMemo;
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
    lbULCirc: TLabel;
    lbDLCirc: TLabel;
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
    miRtCopyBridgeIPv4: TMenuItem;
    miDetailsCopyBridgeIPv4: TMenuItem;
    miDelimiter44: TMenuItem;
    miDelimiter45: TMenuItem;
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
    miShowFlagsHint: TMenuItem;
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
    lbBridgesList: TLabel;
    miDelimiter54: TMenuItem;
    miRequestIPv6Bridges: TMenuItem;
    miRequestObfuscatedBridges: TMenuItem;
    miGetBridgesTelegram: TMenuItem;
    miPreferWebTelegram: TMenuItem;
    miDelimiter55: TMenuItem;
    miClearBridgesNotAlive: TMenuItem;
    miClearBridges: TMenuItem;
    miClearBridgesAll: TMenuItem;
    miDelimiter56: TMenuItem;
    miClearBridgesNonCached: TMenuItem;
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
    miRtCopyBridgeIpv6: TMenuItem;
    miDetailsCopyBridgeIPv6: TMenuItem;
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
    miClearBridgesCached: TMenuItem;
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
    lbAutoSelEntry: TLabel;
    lbAutoSelMiddle: TLabel;
    lbAutoSelExit: TLabel;
    miEnableConvertNodesOnRemoveFromNodesList: TMenuItem;
    cbAutoSelNodesWithPingOnly: TCheckBox;
    cbAutoSelUniqueNodes: TCheckBox;
    cbAutoSelStableOnly: TCheckBox;
    lbAutoSelMaxPing: TLabel;
    lbAutoSelMinWeight: TLabel;
    lbSpeed5: TLabel;
    lbMiliseconds5: TLabel;
    edAutoSelMaxPing: TEdit;
    udAutoSelMaxPing: TUpDown;
    edAutoSelMinWeight: TEdit;
    udAutoSelMinWeight: TUpDown;
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
    miAutoSelNodesType: TMenuItem;
    miAutoSelEntryEnabled: TMenuItem;
    miAutoSelMiddleEnabled: TMenuItem;
    miAutoSelExitEnabled: TMenuItem;
    miDelimiter65: TMenuItem;
    miAutoSelNodesSA: TMenuItem;
    miAutoSelNodesUA: TMenuItem;
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
    cbMinimizeToTray: TCheckBox;
    miShowPortAlongWithIp: TMenuItem;
    miResetTotalsCounter: TMenuItem;
    miEnableTotalsCounter: TMenuItem;
    miTotalsCounter: TMenuItem;
    miDelimiter68: TMenuItem;
    miDelimiter69: TMenuItem;
    miAddRelaysToBridgesCache: TMenuItem;
    miDisplayedLinesCount: TMenuItem;
    miDelimiter70: TMenuItem;
    miDisplayedLinesNoLimit: TMenuItem;
    miDisplayedLines65k: TMenuItem;
    miDisplayedLines32k: TMenuItem;
    miDisplayedLines16k: TMenuItem;
    miDisplayedLines8k: TMenuItem;
    miDisplayedLines4k: TMenuItem;
    miDisplayedLines2k: TMenuItem;
    miDisplayedLines1k: TMenuItem;
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
    miClearBridgesUnsuitable: TMenuItem;
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
    function FindInRanges(IpStr: string): string;
    function RouterInNodesList(RouterID: string; IpStr: string; NodeType: TNodeType; SkipCodes: Boolean = False; CodeStr: string = ''): Boolean;
    function GetTrackHostDomains(Host: string; OnlyExists: Boolean): string;
    function GetControlEvents: string;
    function GetTorHs: Integer;
    function LoadHiddenServices(ini: TMemIniFile): Integer;
    function PreferredBridgeFound: Boolean;
    function CheckRouterFlags(NodeTypeID: Integer; RouterInfo: TRouterInfo): Boolean;
    procedure UpdateBridgesControls(UpdateList: Boolean = True; UpdateUserBridges: Boolean = True);
    procedure ShowRoutersParamsHint;
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
    procedure InsertNodesMenu(ParentMenu: TMenuItem; NodeID: string; AutoSave: Boolean = True);
    procedure InsertNodesListMenu(ParentMenu: TmenuItem; NodeID: string; NodeTypeID: Integer; AutoSave: Boolean = True);
    procedure InsertNodesToDeleteMenu(ParentMenu: TmenuItem; NodeID: string; AutoSave: Boolean = True);
    procedure ChangeFilter;
    procedure ChangeRouters;
    procedure UpdateRoutersAfterFilterUpdate;
    procedure UpdateOptionsAfterRoutersUpdate;
    procedure UpdateRoutersAfterBridgesUpdate;
    procedure SaveRoutersFilterdata(Default: Boolean = False; SaveFilters: Boolean = True);
    procedure LoadRoutersFilterData(Data: string; AutoUpdate: Boolean = True; ResetCustomFilter: Boolean = False);
    procedure ChangeHsTable(Param: Integer);
    procedure ChangeTransportTable(Param: Integer);
    procedure SetDesktopPosition(ALeft, ATop: Integer; AutoUpdate: Boolean = True);
    procedure LoadOptions(FirstStart: Boolean);
    function GetTorVersion(FirstStart: Boolean): Boolean;
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
    procedure ServerAddressEnable(State: Boolean);
    procedure BridgesCheckControls;
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
    function GetScanTypeStr: string;
    procedure LoadConsensus;
    procedure LoadDescriptors;
    procedure CheckCountryIndexInList;
    procedure CheckNodesListControls;
    procedure CheckFavoritesState(FavoritesID: Integer = -1);
    procedure LoadNodesList(UseDic: Boolean = True; NodesStr: string = '');
    procedure SaveNodesList(NodesID: Integer);
    procedure LoadFilterTotals;
    procedure LoadRoutersCountries;
    procedure MaxMemInQueuesEnable(State: Boolean);
    procedure NumCPUsEnable(State: Boolean);
    procedure OpenMetricsUrl(Page, Query: string);
    procedure ProxyParamCheck;
    procedure RelayBandwidthEnable(State: Boolean);
    procedure ReloadTorConfig;
    function CheckRequiredFiles(AutoSave: Boolean = False): Boolean;
    function ReachablePortsExists: Boolean;
    procedure SetIconsColor;
    procedure SaveHiddenServices(ini: TMemIniFile);
    procedure SavePaddingOptions(ini: TMemIniFile);
    procedure CheckPaddingControls;
    procedure UpdateConfigVersion;
    procedure LoadUserBridges(ini: TMemIniFile);
    procedure LoadBuiltinBridges(ini: TMemIniFile; UpdateBridges, UpdateList: Boolean; ListName: string = '');
    procedure ResetTransports(ini: TMemIniFile);
    procedure LoadTransportsData(Data: TStringList);
    procedure LoadProxyPorts(PortControl: TUpdown; HostControl: TCombobox; EnabledControl: TCheckBox; ini: TMemIniFile);
    procedure SaveReachableAddresses(ini: TMemIniFile);
    procedure SaveProxyData(ini: TMemIniFile);
    procedure SaveTransportsData(ini: TMemIniFile; ReloadServerTransport: Boolean);
    procedure SaveBridgesData(ini: TMemIniFile);
    procedure LimitBridgesList(var BridgesData: string; Separator: string);
    procedure ExcludeUnSuitableBridges(out BridgesData: string; Separator: string; BridgeType: TBridgeType; DeleteUnsuitable: Boolean = False);
    procedure SetButtonGlyph(ls: TImageList; Index: Integer; Button: TSpeedButton);
    procedure LoadStaticArray(Data: array of TStaticPair);
    procedure ResetOptions;
    procedure RestartTor(RestartCode: Byte = 0);
    procedure UpdateSystemInfo;
    procedure RestoreForm;
    procedure SelectHs;
    procedure SelectHsPorts;
    procedure SelectTransports;
    procedure CheckStreamsControls;
    procedure ChangeCircuit(DirectClick: Boolean = True);
    procedure SendCommand(const cmd: string);
    procedure CheckSelectRowOptions(aSg: TStringGrid; Checked: Boolean; Save: Boolean = False);
    procedure SetButtonsProp(Btn: TSpeedButton; LeftSmall, LeftBig: Integer);
    procedure ShowBalloon(Msg: string; Title: string = ''; Notice: Boolean = False; MsgType: TMsgType = mtInfo);
    procedure ShowCircuits;
    procedure ShowStreams(CircID: string);
    procedure ShowStreamsInfo(CircID, TargetStr: string);
    procedure ShowCircuitInfo(CircID: string);
    procedure ShowRouters;
    procedure CheckNodesListState(NodeTypeID: Integer);
    procedure CheckCircuitExists(CircID: string; UpdateStreamsCount: Boolean = False);
    procedure CheckCircuitStreams(CircID: string; TargetStreams: Integer);
    procedure SelectRowPopup(aSg: TStringGrid; aPopup: TPopupMenu);
    procedure SaveTrackHostExits(ini: TMemIniFile; UseDic: Boolean = False);
    procedure SaveServerOptions(ini: TMemIniFile);
    procedure SetOptionsEnable(State: Boolean);
    procedure StartTor(AutoResolveErrors: Boolean = False);
    procedure StopTor;
    procedure UpdateConnectProgress(Value: Integer);
    procedure UpdateConnectControls(State: Byte);
    procedure SetSortMenuData(aSg: TStringGrid);
    procedure SetCustomFilterStyle(CustomFilterID: Integer);
    procedure ResetGuards(GuardType: TGuardType);
    procedure MyFamilyEnable(State: Boolean);
    procedure TransportPortEnable(State: Boolean);
    procedure FastAndStableEnable(State: Boolean; AutoCheck: Boolean = True);
    procedure HsControlsEnable(State: Boolean);
    procedure CheckLogAutoScroll(AlwaysUpdate: Boolean = False);
    procedure UpdateBridgeCopyMenu(Menu: TMenuItem; RouterID: string; Router: TRouterInfo; UseIPv6: Boolean);
    procedure UpdateHs;
    procedure UpdateHsPorts;
    procedure UpdateUsedProxyTypes(ini: TMemIniFile);
    procedure UpdateTransports;
    procedure UseDirPortEnable(State: Boolean);
    procedure SaveSortData;
    procedure UpdateScaleFactor;
    procedure CheckTorAutoStart;
    procedure UpdateTrayHint;
    procedure CountTotalBridges(ConfigUpdating: Boolean = False);
    procedure CheckPrefferedBridgeExclude(RouterID: string; IpStr: string = ''; CodeStr: string = '');
    function PrepareNodesToRemove(Data: string; NodeType: TNodeType; out Nodes: ArrOfNodes): Boolean;
    procedure RemoveFromNodesListWithConvert(Nodes: ArrOfNodes; NodeType: TNodeType);
    procedure SortPrepare(aSg: TStringGrid; ACol: Integer; ManualSort: Boolean = False);
    procedure GridSort(aSg: TStringGrid);
    procedure SelectLogAutoDelInterval(Sender: TObject);
    procedure SelectLogLinesLimit(Sender: TObject);
    procedure SelectLogSeparater(Sender: TObject);
    procedure SelectLogScrollbar(Sender: TObject);
    procedure StartScannerManual(Sender: TObject);
    procedure SelectCircuitsSort(Sender: TObject);
    procedure ShowTrafficSelect(Sender: TObject);
    procedure SelectStreamsSort(Sender: TObject);
    procedure SelectStreamsInfoSort(Sender: TObject);
    procedure ClearScannerCacheClick(Sender: TObject);
    procedure lbStatusProxyAddrClick(Sender: TObject);
    procedure SetLogLevel(Sender: TObject);
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
    procedure MemoExit(Sender: TObject);
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
    procedure cbUseMaxMemInQueuesClick(Sender: TObject);
    procedure cbUseNumCPUsClick(Sender: TObject);
    procedure cbUseRelayBandwidthClick(Sender: TObject);
    procedure cbShowBalloonHintClick(Sender: TObject);
    procedure cbStayOnTopClick(Sender: TObject);
    procedure cbUseTrackHostExitsClick(Sender: TObject);
    procedure cbUseBridgesClick(Sender: TObject);
    procedure cbUseDirPortClick(Sender: TObject);
    procedure cbUseProxyClick(Sender: TObject);
    procedure cbUseUPnPClick(Sender: TObject);
    procedure cbxBridgeTypeChange(Sender: TObject);
    procedure cbxExitPolicyTypeChange(Sender: TObject);
    procedure cbxHsAddressChange(Sender: TObject);
    procedure cbxHsVersionChange(Sender: TObject);
    procedure cbxProxyTypeChange(Sender: TObject);
    procedure cbxServerModeChange(Sender: TObject);
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
    procedure miAutoScrollClick(Sender: TObject);
    procedure miChangeCircuitClick(Sender: TObject);
    procedure miClearDNSCacheClick(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure miHsDeleteClick(Sender: TObject);
    procedure miHsInsertClick(Sender: TObject);
    procedure miOpenFileLogClick(Sender: TObject);
    procedure miDetailsRelayInfoClick(Sender: TObject);
    procedure miSafeLoggingClick(Sender: TObject);
    procedure miSaveTemplateClick(Sender: TObject);
    procedure miServerInfoClick(Sender: TObject);
    procedure miShowLogClick(Sender: TObject);
    procedure miShowOptionsClick(Sender: TObject);
    procedure miShowStatusClick(Sender: TObject);
    procedure miSwitchTorClick(Sender: TObject);
    procedure miWordWrapClick(Sender: TObject);
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
    procedure cbListenIPv6Click(Sender: TObject);
    procedure cbDirCacheMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure cbUseAddressClick(Sender: TObject);
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
    procedure miSelectExitCircuitWhetItChangesClick(Sender: TObject);
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
    procedure cbUseMyFamilyClick(Sender: TObject);
    procedure lbExitIpMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure cbxRoutersCountryDropDown(Sender: TObject);
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
    procedure miShowFlagsHintClick(Sender: TObject);
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
    procedure cbxBridgesTypeChange(Sender: TObject);
    procedure cbxBridgesListChange(Sender: TObject);
    procedure cbxBridgesTypeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbxBridgesListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbxNodesListTypeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbxBridgesTypeCloseUp(Sender: TObject);
    procedure cbxBridgesListCloseUp(Sender: TObject);
    procedure miRequestIPv6BridgesClick(Sender: TObject);
    procedure miRequestObfuscatedBridgesClick(Sender: TObject);
    procedure miGetBridgesTelegramClick(Sender: TObject);
    procedure miPreferWebTelegramClick(Sender: TObject);
    procedure miClearBridgesNotAliveClick(Sender: TObject);
    procedure ClearBridgesAvailableCache(Sender: TObject);
    procedure cbUsePreferredBridgeClick(Sender: TObject);
    procedure miDisableSelectionUnSuitableAsBridgeClick(Sender: TObject);
    procedure miRtDisableBridgesClick(Sender: TObject);
    procedure edPreferredBridgeChange(Sender: TObject);
    procedure edPreferredBridgeExit(Sender: TObject);
    procedure cbUsePreferredBridgeExit(Sender: TObject);
    procedure cbUseBridgesExit(Sender: TObject);
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
    procedure meLogMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure meLogMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure miEnableConvertNodesOnRemoveFromNodesListClick(Sender: TObject);
    procedure miManualPingMeasureClick(Sender: TObject);
    procedure miManualDetectAliveNodesClick(Sender: TObject);
    procedure cbxAutoSelPriorityChange(Sender: TObject);
    procedure pbTrafficPaint(Sender: TObject);
    procedure SelectTrafficPeriod(Sender: TObject);
    procedure tmTrafficTimer(Sender: TObject);
    procedure miSelectGraphDLClick(Sender: TObject);
    procedure miSelectGraphULClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure AutoSelNodesType(Sender: TObject);
    procedure cbEnableHttpClick(Sender: TObject);
    procedure lbStatusProxyAddrMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure SelectCheckIpProxy(Sender: TObject);
    procedure miOpenLogsFolderClick(Sender: TObject);
    procedure lbStatusFilterModeClick(Sender: TObject);
    procedure cbxAutoScanTypeDropDown(Sender: TObject);
    procedure cbxAutoScanTypeChange(Sender: TObject);
    procedure miExcludeBridgesWhenCountingClick(Sender: TObject);
    procedure miShowPortAlongWithIpClick(Sender: TObject);
    procedure mnTrafficPopup(Sender: TObject);
    procedure miEnableTotalsCounterClick(Sender: TObject);
    procedure miAddRelaysToBridgesCacheClick(Sender: TObject);
    procedure ShowTimerEvent(Sender: TObject);
    procedure pbScanProgressMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cbExcludeUnsuitableBridgesClick(Sender: TObject);
    procedure edReachableAddressesChange(Sender: TObject);
    procedure miClearBridgesUnsuitableClick(Sender: TObject);
    procedure cbUseBridgesLimitClick(Sender: TObject);
  private
    procedure WMExitSizeMove(var msg: TMessage); message WM_EXITSIZEMOVE;
    procedure WMDpiChanged(var msg: TWMDpi); message WM_DPICHANGED;
    procedure WMQueryEndSession(var Message: TWMQueryEndSession); message WM_QUERYENDSESSION;
    procedure WMEndSession(var Message: TWMEndSession); message WM_ENDSESSION;
  end;

var
  Tcp: TTcp;
  TorConfig, NewBridgesList: TStringList;
  CountryTotals: array [0..MAX_TOTALS - 1, 0..MAX_COUNTRIES - 1] of Integer;
  SpeedData: array [0..MAX_SPEED_DATA_LENGTH - 1] of TSpeedData;
  RoutersDic: TDictionary<string, TRouterInfo>;
  FilterDic: TDictionary<string, TFilterInfo>;
  GeoIpDic: TDictionary<string, TGeoIpInfo>;
  NodesDic: TDictionary<string, TNodeTypes>;
  CircuitsDic: TDictionary<string, TCircuitInfo>;
  StreamsDic: TDictionary<string, TStreamInfo>;
  TrackHostDic: TDictionary<string, Byte>;
  VersionsDic: TDictionary<string, Byte>;
  TransportsDic: TDictionary<string, TTransportInfo>;
  BridgesDic: TDictionary<string, TBridgeInfo>;
  DirFetchDic: TDictionary<string, TFetchInfo>;
  RangesDic: TDictionary<string, TIPv4Range>;
  PortsDic: TDictionary<Word, Byte>;
  ConstDic: TDictionary<string, Integer>;
  DefaultsDic: TDictionary<string, string>;
  ProgramDir, UserDir, HsDir, ThemesDir, TransportsDir, OnionAuthDir, LogsDir: string;
  DefaultsFile, UserConfigFile, UserBackupFile, TorConfigFile, TorStateFile, TorLogFile,
  TorExeFile, GeoIpFile, GeoIpv6File, NetworkCacheFile, BridgesCacheFile,
  UserProfile, LangFile, ConsensusFile, DescriptorsFile, NewDescriptorsFile: string;
  ControlPassword, SelectedNode, SearchStr, UPnPMsg, GeoFileID, TorFileID: string;
  Circuit, LastRoutersFilter, LastPreferredBridgeHash, ExitNodeID, ServerIPv4, ServerIPv6, TorVersion: string;
  jLimit: TJobObjectExtendedLimitInformation;
  TorVersionProcess, TorMainProcess: TProcessInfo;
  hJob: THandle;
  DLSpeed, ULSpeed, MaxDLSpeed, MaxULSpeed, CurrentTrafficPeriod, DisplayedLinesCount, LogAutoDelHours: Integer;
  SessionDL, SessionUL, TotalDL, TotalUL: Int64;
  ConnectState, StopCode, FormSize, LastPlace, InfoStage, GetIpStage, NodesListStage, NewBridgesStage: Byte;
  EncodingNoBom: TUTF8EncodingNoBOM;
  SearchTimer, LastCountriesHash: Cardinal;
  DecFormPos, IncFormPos, IncFormSize: TPoint;
  RoutersCustomFilter, LastRoutersCustomFilter, RoutersFilters, LastFilters: Integer;
  GeoIpExists, FirstLoad, Restarting, Closing, WindowsShutdown, CursorShow, GeoIpUpdating, GeoIpModified, ServerIsObfs4: Boolean;
  CursorStop, StartTimer, RestartTimeout, ShowTimer: TTimer;
  Controller: TControlThread;
  Consensus: TConsensusThread;
  Descriptors: TDescriptorsThread;
  Logger, VersionChecker: TReadPipeThread;
  OptionsLocked, OptionsChanged, ShowNodesChanged, Connected, AlreadyStarted, SearchFirst, StopScan: Boolean;
  ConsensusUpdated, DescriptorsUpdated, FilterUpdated, RoutersUpdated, ExcludeUpdated, OpenDNSUpdated, LanguageUpdated, BridgesUpdated: Boolean;
  SelectExitCircuit, TotalsNeedSave, SupportVanguardsLite: Boolean;
  Scale: Real;
  HsToDelete: ArrOfStr;
  SystemLanguage: Word;
  LastAuthCookieDate, LastConsensusDate, LastNewDescriptorsDate, LastTorrcDate: TDateTime;
  LastFullScanDate, LastPartialScanDate, TotalStartDate, LastSaveStats: Int64;
  LastPartialScansCounts: Integer;
  LockCircuits, LockCircuitInfo, LockStreams, LockStreamsInfo, UpdateTraffic: Boolean;
  FindObject: TMemo;
  ScanStage, AutoScanStage: Byte;
  CurrentScanType: TScanType;
  CurrentScanPurpose, CurrentAutoScanPurpose: TScanPurpose;
  ScanThreads, CurrentScans, TotalScans, AliveNodesCount, PingNodesCount, ConnectProgress: Integer;
  SuitableBridgesCount, UnknownBridgesCountriesCount, FailedBridgesCount, FailedBridgesInterval, NewBridgesCount: Integer;
  Scanner: TScanThread;
  UsedProxyType: TProxyType;
  LastUserStreamProtocol: Integer;
  FindBridgesCountries: Boolean;

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

procedure TReadPipeThread.UpdateVersionInfo;
var
  ParseStr: ArrOfStr;
  ini: TMemIniFile;
begin
  ParseStr := Explode(' ', Data);
  if Length(ParseStr) > 1 then
  begin
    TorVersion := ParseStr[2];
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
  if DisplayedLinesCount <> 0 then
    MaxLines := DisplayedLinesCount
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
        Tcp.meLog.Tag := 0;
    end;

    if Tcp.miAutoScroll.Checked and (Tcp.meLog.Tag = 0) then
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
  ls: TStringList;
  Item: TPair<string,TRouterInfo>;
  GeoIpInfo: TGeoIpInfo;
  AvailMemoryBefore: Int64;
  NeedScan: Boolean;
  ParseStr: ArrOfStr;
  i, PortsData: Integer;
  IpToScan, IpStr: string;
  PortToScan: Word;
  Bridge: TBridge;

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

    if sScanPurpose = spUserBridges then
    begin
      ParseStr := Explode('|', MemoToLine(Tcp.meBridges, ltBridge, False, '|'));
      for i := 0 to Length(ParseStr) - 1 do
      begin
        if TryParseBridge(ParseStr[i], Bridge) then
        begin
          IpStr := GetBridgeIp(Bridge);
          if IpInRanges(IpStr, DocRanges) then
            Continue;
          ls.Append(IpStr + ':' + IntToStr(Bridge.Port));
        end;
      end;
    end
    else
    begin
      for Item in RoutersDic do
        AddToScanList(Item.Value.IPv4, IntToStr(Item.Value.OrPort), Item.Value.Flags);
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
  if cbUseBridges.Checked or DescriptorsUpdated then
    LoadDescriptors
  else
  begin
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
  DescriptorsUpdated := False;
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
  ls, lb: TStringList;
  i, j: Integer;
  Find: Boolean;
  RouterID, Key: string;
  ParseStr: ArrOfStr;
  Router: TRouterInfo;
  Bridge: TPair<string, TBridgeInfo>;
  BridgeInfo: TBridgeInfo;
  HashList: TDictionary<string, Byte>;
begin
  if not FileExists(ConsensusFile) then
    Exit;
  VersionsDic.Clear;
  HashList := TDictionary<string, Byte>.Create;
  ls := TStringList.Create;
  try
    for Key in RoutersDic.Keys do
      HashList.AddOrSetValue(Key, 0);
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
        Router.OrPort := StrToInt(ParseStr[6]);
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
        if Pos('Authority', ls[i]) <> 0 then
        begin
          Include(Router.Flags, rfAuthority);
          Inc(Router.Params, ROUTER_AUTHORITY);
        end;
        if Pos('BadExit', ls[i]) <> 0 then
        begin
          Include(Router.Flags, rfBadExit);
          Inc(Router.Params, ROUTER_BAD_EXIT);
        end;
        if Pos('Exit', ls[i]) <> 0 then
          Include(Router.Flags, rfExit);
        if Pos('Fast', ls[i]) <> 0 then
          Include(Router.Flags, rfFast);
        if Pos('Guard', ls[i]) <> 0 then
          Include(Router.Flags, rfGuard);
        if Pos('HSDir', ls[i]) <> 0 then
        begin
          Include(Router.Flags, rfHSDir);
          Inc(Router.Params, ROUTER_HS_DIR);
        end;
        if Pos('Stable', ls[i]) <> 0 then
          Include(Router.Flags, rfStable);
        if Pos('V2Dir', ls[i]) <> 0 then
          Include(Router.Flags, rfV2Dir);
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
          Inc(Router.Params, ROUTER_BRIDGE);
          BridgeInfo.Router := Router;          
          BridgeInfo.Kind := BRIDGE_RELAY;
          BridgesDic.AddOrSetValue(RouterID, BridgeInfo);
        end;

        RoutersDic.AddOrSetValue(RouterID, Router);
        HashList.Remove(RouterID);
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

    for Key in HashList.Keys do
      RoutersDic.Remove(Key);

    if BridgesDic.Count > 0 then
    begin
      lb := TStringList.Create;
      try
        for Bridge in BridgesDic do
        begin
          Find := RoutersDic.ContainsKey(Bridge.Key); 
          if Bridge.Value.Kind = BRIDGE_RELAY then
          begin
            if not Find then
            begin
              lb.Append(Bridge.Key);
              Continue;
            end;
          end
          else
          begin
            BridgeInfo := Bridge.Value;
            if TryUpdateMask(BridgeInfo.Router.Params, ROUTER_NOT_RECOMMENDED,
              not VersionsDic.ContainsKey(BridgeInfo.Router.Version)) then
                BridgesDic.AddOrSetValue(Bridge.Key, BridgeInfo);
            RoutersDic.AddOrSetValue(Bridge.Key, BridgeInfo.Router);
          end;
        end;
        if lb.Count > 0 then
        begin
          for i := 0 to lb.Count - 1 do
            BridgesDic.Remove(lb[i]);  
        end;
      finally
        lb.Free;
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
  i: Integer;
  ParseStr: ArrOfStr;
  DescRouter, Router: TRouterInfo;
  UserBridges: TDictionary<string, TBridge>;
  Bridge: TBridge;
  RouterID, Temp: string;
  BridgeData: TBridgeInfo;
  BridgeRelay, UpdateFromDesc: Boolean;

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

    procedure Update;
    begin
      if not IpInRanges(Bridge.Ip, DocRanges) then
        RouterInfo.OrPort := Bridge.Port;
      BridgeInfo.Transport := Bridge.Transport;
      BridgeInfo.Params := Bridge.Params;    
    end;
    
  begin
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
          if BridgesDic.TryGetValue(RouterID, BridgeInfoDic) then
          begin
            RouterInfo.OrPort := BridgeInfoDic.Router.OrPort;
            BridgeInfo.Transport := BridgeInfoDic.Transport;
            BridgeInfo.Params := BridgeInfoDic.Params;
          end
          else
          begin
            BridgeInfo.Transport := '';
            BridgeInfo.Params := '';
          end;      
        end;
      end;
    end;

    if rfRelay in RouterInfo.Flags then
      BridgeInfo.Kind := BRIDGE_RELAY
    else
      BridgeInfo.Kind := BRIDGE_NATIVE;
    BridgeInfo.Router := RouterInfo;
    BridgesDic.AddOrSetValue(RouterID, BridgeInfo);
  end;

begin
  ls := TStringList.Create;
  lb := TStringList.Create;
  UserBridges := TDictionary<string, TBridge>.Create;
  try
    if Tcp.cbUsePreferredBridge.Checked then
      lb.Append(Tcp.edPreferredBridge.Text)
    else
      lb.Text := Tcp.meBridges.Text;

    for i := 0 to lb.Count - 1 do
    begin
      if TryParseBridge(lb[i], Bridge) then
      begin
        if Bridge.Hash <> '' then
          UserBridges.AddOrSetValue(Bridge.Hash, Bridge)
        else
          UserBridges.AddOrSetValue(Bridge.Ip, Bridge)          
      end;
    end;
    BridgeRelay := False;
    UpdateFromDesc := False;
    LoadDesc(DescriptorsFile);
    LoadDesc(NewDescriptorsFile);
    for i := 0 to ls.Count - 1 do
    begin
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
          DescRouter.OrPort := StrToInt(ParseStr[3]);
          DescRouter.DirPort := 0;
          DescRouter.Flags := [rfBridge];
          DescRouter.Params := ROUTER_BRIDGE;
          DescRouter.Version := '';
          Continue;
        end;

        if Pos('or-address ', ls[i]) = 1 then
        begin
          Temp := Copy(ls[i], 12, RPos(':', ls[i]) - 12);
          if ValidAddress(Temp, False, True) = 2 then
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
            if (rfRelay in Router.Flags) and (Tcp.miAddRelaysToBridgesCache.Checked) then
            begin
              if not (rfBridge in Router.Flags) then
              begin
                Include(Router.Flags, rfBridge);
                Inc(Router.Params, ROUTER_BRIDGE);
              end;
              if Router.Bandwidth < DescRouter.Bandwidth then
                Router.Bandwidth := DescRouter.Bandwidth;
              UpdateBridges(Router);
              RoutersDic.AddOrSetValue(RouterID, Router);
            end;
            UpdateFromDesc := False;
          end;
          if UpdateFromDesc then
          begin
            UpdateBridges(DescRouter);
            RoutersDic.AddOrSetValue(RouterID, DescRouter);
            UpdateFromDesc := False;
          end;
          if ConnectState <> 0 then
          begin
            if BridgesDic.TryGetValue(RouterID, BridgeData) then
              SetPortsValue(BridgeData.Router.IPv4, IntToStr(BridgeData.Router.OrPort), 1);
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

procedure TControlThread.SendData(cmd: string);
begin
  if Connected then
    SendBuffer := SendBuffer + cmd + BR;
end;

procedure TControlThread.GetData;
var
  i: Integer;
  UpdateCountry: Boolean;
  Item: TPair<string, TRouterInfo>;
  GeoIpItem: TPair<string, TGeoIpInfo>;
  ls: TStringList;
  GeoIpInfo: TGeoIpInfo;
  FilterInfo: TFilterInfo;
  RouterInfo: TRouterInfo;
  Bridge: TBridge;
  Target: TTarget;
  FetchInfo: TFetchInfo;
  IpStr: string;
begin
  if InfoStage > 0 then
  begin

    if InfoStage = 1 then
    begin
      Temp := '';
      InfoCount := 0;

      if GeoIpExists then
      begin
        if FindBridgesCountries then
        begin
          ls := TStringList.Create;
          try
            ls.Text := Tcp.meBridges.Text;
            ls.Append(Tcp.edPreferredBridge.Text);
            for i := 0 to ls.Count - 1 do
            begin
              if TryParseBridge(ls[i], Bridge) then
              begin
                IpStr := GetBridgeIp(Bridge);
                if IpInRanges(IpStr, DocRanges) then
                  Continue;
                UpdateCountry := True;
                if GeoIpDic.TryGetValue(IpStr, GeoIpInfo) then
                begin
                  if GeoIpInfo.cc <> DEFAULT_COUNTRY_ID then
                    UpdateCountry := False;
                end;
                if UpdateCountry then
                begin
                  Inc(InfoCount);
                  Temp := Temp + ' ip-to-country/' + IpStr;
                end;
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
            begin
              Inc(InfoCount);
              Temp := Temp + ' ip-to-country/' + GeoIpItem.Key;
            end;
          end
          else
          begin
            for Item in RoutersDic do
            begin
              UpdateCountry := True;
              if GeoIpDic.TryGetValue(Item.Value.IPv4, GeoIpInfo) then
              begin
                if GeoIpInfo.cc <> DEFAULT_COUNTRY_ID then
                  UpdateCountry := False;
              end;
              if UpdateCountry then
              begin
                Inc(InfoCount);
                Temp := Temp + ' ip-to-country/' + Item.Value.IPv4;
              end;
            end;
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
      if FindBridgesCountries then
      begin
        FindBridgesCountries := False;
        OptionsLocked := True;
        Tcp.ApplyOptions(True);
        if not Tcp.cbUseBridges.Checked then
          SendData('SETCONF UseBridges=0');
        SendData('SETCONF DisableNetwork=0');
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

        Tcp.SaveNetworkCache;
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
      case ConnectProgress of
         75: Tcp.LoadConsensus;
        100:
        begin
          ConnectState := 2;
          AlreadyStarted := True;
          Tcp.UpdateConnectControls(ConnectState);
          Tcp.SetOptionsEnable(True);
          Tcp.GetServerInfo;
          Tcp.SendDataThroughProxy;        
        end
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
        for i := 7 to Length(ParseStr) - 1 do
        begin
          if Pos('TIME_CREATED', ParseStr[i]) <> 0 then
          begin
            CircuitInfo.Date := TorDateFormat(SeparateRight(ParseStr[i], '='));
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
      end;
      CLOSED:
      begin
        CircuitsDic.Remove(CircuitID);
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
                  Tcp.lbExitCountry.Left := Round(206 * Scale);
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
                  if Tcp.miSelectExitCircuitWhetItChanges.Checked then
                    SelectExitCircuit := True;
                  Tcp.UpdateTrayHint;
                end;
              end;
            end;
          end;
        end;
      end;
      FAILED:
      begin
        if Tcp.cbUseBridges.Checked and Tcp.cbExcludeUnsuitableBridges.Checked and (CircuitID = '0') then
        begin
          if StreamsDic.TryGetValue(StreamID, StreamInfo) then
          begin
            if StreamInfo.PurposeID = DIR_FETCH then
            begin
              if TryParseTarget(StreamInfo.Target, Target) then
              begin
                if (Target.AddrType = atExit) and IsIPv4(Target.Hostname) then
                begin
                  if DirFetchDic.TryGetValue(Target.Hash, FetchInfo) then
                  begin
                    Inc(FetchInfo.FailsCount);
                    DirFetchDic.AddOrSetValue(Target.Hash, FetchInfo);
                    if FetchInfo.FailsCount > Tcp.udMaxDirFails.Position then
                    begin
                      SetPortsValue(FetchInfo.IpStr, FetchInfo.PortStr, -1);
                      DirFetchDic.Remove(Target.Hash);
                      Inc(FailedBridgesCount);
                    end;
                  end
                  else
                  begin
                    FetchInfo.IpStr := Target.Hostname;
                    FetchInfo.PortStr := Target.Port;
                    FetchInfo.FailsCount := 1;
                    DirFetchDic.AddOrSetValue(Target.Hash, FetchInfo);
                  end;
                end;
              end;
            end;
          end;
        end;
        Exit;
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
          IpID := ValidAddress(Temp);
          case IpID of
            1: if Temp <> ServerIPv4 then ServerIPv4 := Temp;
            2: if Temp <> ServerIPv6 then ServerIPv6 := Temp;
          end;
          if IpID <> 0 then
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
    InflateRect(PRect(Msg.LParam)^, 3, 1)
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
  lbExitIp.Tag := 0;
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
begin
  if ARow = 0 then
  begin
    case ACol of
      CIRC_PURPOSE: DrawText(sgCircuits.Canvas.Handle, PChar(CircuitsHeader[ACol - 1]), Length(CircuitsHeader[ACol - 1]), Rect, DT_CENTER);
      CIRC_STREAMS: GridDrawIcon(sgCircuits, Rect, lsMain, 8);
    end;
    if (ACol = sgCircuits.SortCol) and (ACol = CIRC_PURPOSE) then
      GridDrawSortArrows(sgCircuits, Rect);
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
      GridDrawIcon(sgFilter, Rect, lsFlags, FilterDic.Items[AnsiLowerCase(sgFilter.Cells[FILTER_ID, ARow])].cc, 20, 13);
  end;
end;

procedure TTcp.UpdateRoutersAfterBridgesUpdate;
begin
  if BridgesUpdated then
  begin
    ShowRouters;
    BridgesUpdated := False;
  end;
end;

procedure TTcp.UpdateRoutersAfterFilterUpdate;
begin
  if FilterUpdated then
  begin
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
  Key := AnsiLowerCase(sgFilter.Cells[FILTER_ID, sgFilter.SelRow]);
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
    CountTotalBridges;
    CheckPrefferedBridgeExclude('', '', Key);
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
        FILTER_ALIVE:
        begin
          RoutersCustomFilter := FILTER_BY_ALIVE;
          if miExcludeBridgesWhenCounting.Checked then
            IntToMenu(mnShowNodes.Items, 10240)
          else
            IntToMenu(mnShowNodes.Items, 2048);
        end;
      end;
      CountryIndex := FilterDic.Items[AnsiLowerCase(sgFilter.Cells[FILTER_ID, sgFilter.MovRow])].cc;
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
  GridScrollCheck(sgHs, HS_NAME, 183);
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
  GridScrollCheck(sgHsPorts, HSP_INTERFACE, 151);
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
  Indent, Mask, Interval: Integer;

  procedure DrawFlagIcon(Flag: Byte; Index: Integer);
  begin
    if Mask and Flag <> 0 then
    begin
      lsMenus.Draw(sgRouters.Canvas, Rect.Left + (Rect.Width - Indent) div 2 + Interval, Rect.Top + (Rect.Height - 16) div 2, Index, True);
      Inc(Interval, 16);
    end;
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
          DrawFlagIcon(ROUTER_BRIDGE, 28);
          DrawFlagIcon(ROUTER_AUTHORITY, 54);
          DrawFlagIcon(ROUTER_ALIVE, 56);
          DrawFlagIcon(ROUTER_REACHABLE_IPV6, 34);
          DrawFlagIcon(ROUTER_HS_DIR, 53);
          DrawFlagIcon(ROUTER_DIR_MIRROR, 38);
          DrawFlagIcon(ROUTER_NOT_RECOMMENDED, 44);
          DrawFlagIcon(ROUTER_BAD_EXIT, 43);
        end;
      end;
    end;
  end;
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
  if (Key = VK_RETURN) and (sgRouters.SelCol > ROUTER_FLAGS) then
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

  if (sgRouters.SelCol > ROUTER_FLAGS) and (sgRouters.MovRow > 0) and (Button = mbLeft) then
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
  PreferredBridge: TBridge;
  ItemID: TListType;
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
          NodesList.Append(AnsiUpperCase(NodeStr) + ' (' + TransStr(NodeStr) + ')');
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
    FindCidr := FindInRanges(RouterInfo.IPv4);
    if FindCidr <> '' then
    begin
      ParseStr := Explode(',', FindCidr);
      for i := 0 to Length(ParseStr) - 1 do
        FindNode(ParseStr[i], NodeType);
      SortNodesList(NodesList, True);
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
            if (SelData = FAVERR_CHAR) and ((not CheckRouterFlags(Integer(NodeTypeID), RouterInfo)) or (Key = LastPreferredBridgeHash)) then
              sgRouters.Cells[sgRouters.SelCol, sgRouters.SelRow] := NONE_CHAR
            else
              sgRouters.Cells[sgRouters.SelCol, sgRouters.SelRow] := '';
          end;
          Exclude(FNodeTypes, NodeTypeID);
        end;
        NodesDic.AddOrSetValue(Key, FNodeTypes);
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
              ItemID := GetNodeType(NodeStr);
              if ItemID = ltCode then
                NodeStr := AnsiLowerCase(NodeStr);
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
    if TryParseBridge(edPreferredBridge.Text, PreferredBridge) then
    begin
      if PreferredBridge.Hash = '' then
        PreferredBridge.Hash := GetRouterBySocket(FormatHost(PreferredBridge.Ip) + ':' + IntToStr(PreferredBridge.Port));
      CheckPrefferedBridgeExclude(PreferredBridge.Hash);
    end;

    CheckNodesListState(Integer(NodeTypeID));
    CalculateTotalNodes(False);
    if not HashMode then
    begin
      ShowRouters;
      FilterUpdated := FindCountry;
    end;
    RoutersUpdated := True;
    EnableOptionButtons;
    if NodeTypeID = ntExclude then
      CountTotalBridges;
  end;
end;

procedure TTcp.ShowRoutersParamsHint;
var
  RouterInfo: TRouterInfo;
  Mask, MaxItems: Integer;
  Fail: Boolean;
  CellRect, CellPoint: TRect;
  Data: array of Byte;
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

        CellRect := sgRouters.CellRect(9, sgRouters.MovRow);
        CellPoint := sgRouters.ClientToScreen(CellRect);

        ArrayIndex := (Mouse.CursorPos.X - CellPoint.Left - (CellRect.Width - MaxItems * 16) div 2);
        if InRange(ArrayIndex, 0, MaxItems * 16) then
        begin
          case Data[ArrayIndex div 16] of
            ROUTER_BRIDGE: sgRouters.Hint := TransStr('384');
            ROUTER_AUTHORITY: sgRouters.Hint := TransStr('385');
            ROUTER_ALIVE: sgRouters.Hint := TransStr('386');
            ROUTER_REACHABLE_IPV6: sgRouters.Hint := TransStr('387');
            ROUTER_HS_DIR: sgRouters.Hint := TransStr('388');
            ROUTER_DIR_MIRROR: sgRouters.Hint := Format(TransStr('389'), [RouterInfo.DirPort]);
            ROUTER_NOT_RECOMMENDED: sgRouters.Hint := TransStr('390');
            ROUTER_BAD_EXIT: sgRouters.Hint := TransStr('391');
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
  if miShowFlagsHint.Checked and (sgRouters.MovCol = ROUTER_FLAGS) then
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
  if (ARow = 0) and (ACol < PT_PARAMS) then
    DrawText(sgTransports.Canvas.Handle, PChar(TransportsHeader[ACol]), Length(TransportsHeader[ACol]), Rect, DT_CENTER);
  GridScrollCheck(sgTransports, PT_TRANSPORTS, 194);
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
    6: AutoSelNodesType(Sender);
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
    if ValidAddress(ServerIPv4) = 1 then
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

  IsIPv4 := ValidAddress(ServerIPv4) = 1;
  IsIPv6 := (ValidAddress(ServerIPv6) = 2) and cbListenIPv6.Checked;
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
  TorrcDate: TDateTime;
  TorrcChanged, PathChanged, BridgesChanged: Boolean;
begin
  FileAge(TorConfigFile, TorrcDate);
  TorrcChanged := TorrcDate <> LastTorrcDate;
  PathChanged := not CheckRequiredFiles;
  BridgesChanged := FailedBridgesCount > 0;
  if OptionsChanged or TorrcChanged or PathChanged or BridgesChanged then
  begin
    if Restarting or TorrcChanged or PathChanged or BridgesChanged then
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
          begin
            FindBridgesCountries := True;
            InfoStage := 1;
          end;
        end;
        StopCode := STOP_NORMAL;
        if miAutoClear.Checked then
          meLog.Clear;
        StreamsDic.Clear;
        CircuitsDic.Clear;
        DirFetchDic.Clear;
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
        LockCircuits := False;
        LockCircuitInfo := False;
        LockStreams := False;
        LockStreamsInfo := False;
        tmTraffic.Enabled := True;
        tmCircuits.Enabled := True;
        tmConsensus.Enabled := True;
        UpdateConnectControls(ConnectState);
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
          or (not cbConnectOnStartup.Checked or (cbConnectOnStartup.Checked and cbMinimizeOnStartup.Checked)) then
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

procedure TTcp.UpdateConnectControls(State: Byte);
var
  Value: Integer;
begin
  case State of
    1: Value := 0;
    2: Value := 100;
    else
      Value := -1;       
  end;
  UpdateConnectProgress(Value);
  btnSwitchTor.Caption := TransStr('10' + IntToStr(State)); 
  btnSwitchTor.ImageIndex := State;
  miSwitchTor.Caption := btnSwitchTor.Caption;
  miSwitchTor.ImageIndex := State;
  tiTray.IconIndex := State;
end;

procedure TTcp.StopTor;
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
  lbExitCountry.Left := Round(180 * Scale);
  lbExitCountry.Caption := TransStr('110');
  lbExitCountry.Cursor := crDefault;
  lbExitCountry.Hint := '';
  lbExitIp.Caption := TransStr('109');
  lbExitIp.Cursor := crDefault;
  UpdateConnectControls(ConnectState);
  UpdateTrayHint;
  if not Restarting then
  begin
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

procedure TTcp.ReloadTorConfig;
begin
  if ConnectState = 2 then
  begin
    SendCommand('SIGNAL RELOAD');
    SendDataThroughProxy;
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

  lsButtons.GetIcon(6, imGeneratePassword.Picture.Icon);
  lsButtons.GetIcon(7, imUPnPTest.Picture.Icon);
  SetButtonGlyph(lsButtons, 4, sbShowOptions);
  SetButtonGlyph(lsButtons, 5, sbShowLog);
  SetButtonGlyph(lsButtons, 9, sbShowStatus);
  SetButtonGlyph(lsButtons, 10, sbShowCircuits);
  SetButtonGlyph(lsButtons, 8, sbShowRouters);
  SetButtonGlyph(lsButtons, 11, sbDecreaseForm);

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
        DeleteSettings('Main', 'LastGeoIpUpdateDate', ini);
        ConfigVersion := 4;
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
        if ValidSocket(ParseStr[1]) <> 0 then
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
          if ValidAddress(Address) <> 0 then
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
              if (ValidAddress(Address) = 0) or (cbxHsAddress.Items.IndexOf(Address) = -1) then
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
    if Count > 0 then
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
              T.BridgeType := [];
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
          if cbUsePreferredBridge.Checked then
            InBridges := btPrefer in T.BridgeType
          else
            InBridges := btList in T.BridgeType;
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

procedure TTcp.LoadUserBridges(ini: TMemIniFile);
var
  Bridges: TStringList;
  i: Integer;
begin
  meBridges.Clear;
  Bridges := TStringList.Create;
  try
    ini.ReadSectionValues('Bridges', Bridges);
    if Bridges.Count > 0 then
    begin
      for i := Bridges.Count - 1 downto 0 do
      begin
        Bridges[i] := Trim(SeparateRight(Bridges[i], '='));
        if not ValidBridge(Bridges[i], btNone) then
          Bridges.Delete(i);
      end;
      meBridges.Text := Bridges.Text;
    end;
  finally
    Bridges.Free;
  end;
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
            if ValidBridge(Value, btNone) then
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
              LineToMemo(Str, meBridges, ltBridge, False, Delimiter);
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

procedure TTcp.ExcludeUnSuitableBridges(out BridgesData: string; Separator: string; BridgeType: TBridgeType; DeleteUnsuitable: Boolean = False);
var
  cdPorts, cdAlive, cdCached: Boolean;
  CheckEntryPorts, NeedCountry, NeedAlive: Boolean;
  BridgesCount, CachedBridgesCount: Integer;
  Bridge: TBridge;
  GeoIpInfo: TGeoIpInfo;
  T: TTransportInfo;
  ls: TStringList;
  CountryStr, PreferStr, IpStr: string;
  i, CountryID, PortData: Integer;
begin
  BridgesCount := 0;
  SuitableBridgesCount := 0;
  BridgesData := '';

  PreferStr := Trim(edPreferredBridge.Text);
  if BridgeType = btPrefer then
  begin
    if Length(PreferStr) > 0 then
      BridgesCount := 1;
  end
  else
    BridgesCount := meBridges.Lines.Count;
  if BridgesCount = 0 then
    Exit;
  CachedBridgesCount := BridgesDic.Count;
  CheckEntryPorts := ReachablePortsExists;
  ls := TStringList.Create;
  try
    if BridgeType = btPrefer then
      ls.Text := PreferStr
    else
      ls.Text := meBridges.Text;
    for i := 0 to ls.Count - 1 do
    begin
      if TryParseBridge(ls[i], Bridge) then
      begin
        if CheckEntryPorts then
          cdPorts := PortsDic.ContainsKey(Bridge.Port)
        else
          cdPorts := True;

        IpStr := GetBridgeIp(Bridge);
        if GeoIpDic.TryGetValue(IpStr, GeoIpInfo) then
        begin
          CountryID := GeoIpInfo.cc;
          PortData := GetPortsValue(GeoIpInfo.ports, IntToStr(Bridge.Port));
          NeedCountry := CountryID = DEFAULT_COUNTRY_ID;
          NeedAlive := PortData = 0;
          cdAlive := PortData <> -1;
        end
        else
        begin
          CountryID := DEFAULT_COUNTRY_ID;
          NeedCountry := True;
          NeedAlive := True;
          cdAlive := True;
        end;

        if CachedBridgesCount > 0 then
        begin
          cdCached := BridgesDic.ContainsKey(Bridge.Hash);
          if not cdCached then
          begin
            cdCached := NeedAlive;
            if cdCached and cbCacheNewBridges.Checked and cbUseBridgesLimit.Checked then
            begin
              Inc(NewBridgesCount);
              if NewBridgesStage = 1 then
                NewBridgesList.Append(ls[i]);
            end;
          end;
        end
        else
          cdCached := True;

        if NeedCountry and GeoIpExists then
        begin
          if not IpInRanges(IpStr, DocRanges) then
            Inc(UnknownBridgesCountriesCount);
        end;

        CountryStr := CountryCodes[CountryID];

        if cdPorts and cdAlive and cdCached and not RouterInNodesList(Bridge.Hash, Bridge.Ip, ntExclude, False, CountryStr) then
        begin
          if not DeleteUnsuitable then
          begin
            BridgesData := BridgesData + Separator + ls[i];
            if TransportsDic.TryGetValue(Bridge.Transport, T) then
            begin
              if T.TransportID <> TRANSPORT_SERVER then
              begin
                Include(T.BridgeType, btList);
                TransportsDic.AddOrSetValue(Bridge.Transport, T);
              end;
            end;
          end;
          Inc(SuitableBridgesCount);
        end
        else
          ls[i] := '';
      end
      else
        ls[i] := '';
    end;
    if not DeleteUnsuitable then
      Delete(BridgesData, 1, Length(Separator));
    if BridgeType = btPrefer then
    begin
      if SuitableBridgesCount = 0 then
        BridgesData := edPreferredBridge.Text;
    end
    else
    begin
      if DeleteUnsuitable then
      begin
        for i := 0 to ls.Count - 1 do
        begin
          if ls[i] <> '' then
            BridgesData := BridgesData + Separator + ls[i];
        end;
        Delete(BridgesData, 1, Length(Separator));
      end;
    end;
  finally
    ls.Free;
    if CheckEntryPorts then
      PortsDic.Clear;
  end;
end;

procedure TTcp.LimitBridgesList(var BridgesData: string; Separator: string);
var
  ParseStr: ArrOfStr;
  i, PriorityType, Ping, Bandwidth, Max, Count: Integer;
  SortCompare: TStringListSortCompare;
  GeoIpInfo: TGeoIpInfo;
  Bridge: TBridge;
  BridgeInfo: TBridgeInfo;
  IpStr: string;
  ls: TStringList;
begin
  if BridgesData = '' then
    Exit;
  PriorityType := cbxBridgesPriority.ItemIndex;
  if (PingNodesCount = 0) and (PriorityType = PRIORITY_PING) then
    PriorityType := PRIORITY_BANDWIDTH;

  ParseStr := Explode(Separator, BridgesData);
  ls := TStringList.Create;
  try
    for i := 0 to Length(ParseStr) - 1 do
    begin
      if TryParseBridge(ParseStr[i], Bridge) then
      begin
        case PriorityType of
          PRIORITY_BANDWIDTH:
          begin
            if BridgesDic.TryGetValue(Bridge.Hash, BridgeInfo) then
              Bandwidth := BridgeInfo.Router.Bandwidth
            else
              Bandwidth := 0;
            ls.AddObject(ParseStr[i], TObject(Bandwidth));
          end;
          PRIORITY_PING:
          begin
            Ping := MAXWORD;
            if PingNodesCount > 0 then
            begin
              IpStr := GetBridgeIp(Bridge);
              if GeoIpDic.TryGetValue(IpStr, GeoIpInfo) then
              begin
                case GeoIpInfo.ping of
                  -1: Ping := MAXINT;
                  0: Ping := MAXWORD;
                  else
                    Ping := GeoIpInfo.ping;
                end;
              end
            end;
            ls.AddObject(ParseStr[i], TObject(Ping));
          end;
          else
            ls.AddObject(ParseStr[i], TObject(Random(MAXWORD)));
        end;
      end;
    end;

    case PriorityType of
      PRIORITY_PING: SortCompare := CompIntObjectAsc
      else
        SortCompare := CompIntObjectDesc;
    end;
    if PriorityType <> PRIORITY_BY_ORDER then
      ls.CustomSort(SortCompare);

    Max := udBridgesLimit.Position;
    Count := 0;
    BridgesData := '';

    for i := 0 to ls.Count - 1 do
    begin
      if Count < Max then
      begin
        BridgesData := BridgesData + Separator + ls[i];
        Inc(Count);
      end
      else
        Break;
    end;
    Delete(BridgesData, 1, Length(Separator));
    if NewBridgesStage = 1 then
    begin
      for i := 0 to NewBridgesList.Count - 1 do
        BridgesData := BridgesData + Separator + NewBridgesList[i];
    end;
    
  finally
    ls.Free;
  end;
end;

procedure TTcp.SaveBridgesData(ini: TMemIniFile);
const
  Delimiter = '|';
var
  Bridges, PreferredBridge: string;
  i: Integer;
begin
  NewBridgesList.Clear;
  UnknownBridgesCountriesCount := 0;
  NewBridgesCount := 0;
  FailedBridgesCount := 0;
  FailedBridgesInterval := 0;
  DeleteTorConfig('Bridge', [cfMultiLine]);
  DeleteTorConfig('DisableNetwork');
  PreferredBridge := Trim(edPreferredBridge.Text);
  if not ValidBridge(PreferredBridge, btPrefer) then
  begin
    PreferredBridge := '';
    cbUsePreferredBridge.Checked := False;
  end
  else
  begin
    if cbUsePreferredBridge.Checked and cbExcludeUnsuitableBridges.Checked then
    begin
      ExcludeUnSuitableBridges(PreferredBridge, Delimiter, btPrefer);
      if SuitableBridgesCount = 0 then
        cbUsePreferredBridge.Checked := False;
    end;
  end;
  edPreferredBridge.Text := PreferredBridge;

  Bridges := MemoToLine(meBridges, ltBridge, False, Delimiter, cbExcludeUnsuitableBridges.Checked);
  if cbExcludeUnsuitableBridges.Checked then
    ExcludeUnSuitableBridges(Bridges, Delimiter, btList);

  if cbUseBridgesLimit.Checked then
    LimitBridgesList(Bridges, Delimiter);

  if (Bridges = '') and ((cbUsePreferredBridge.Checked and (PreferredBridge = '')) or not cbUsePreferredBridge.Checked) then
    cbUseBridges.Checked := False;

  SetTorConfig('UseBridges', IntToStr(Integer(cbUseBridges.Checked)));
  if cbUseBridges.Checked then
  begin
    if cbUsePreferredBridge.Checked then
      SetTorConfig('Bridge', PreferredBridge)
    else
      SetTorConfig('Bridge', Bridges, [cfMultiLine], Delimiter);
  end;

  if (UnknownBridgesCountriesCount > 0) and (ConnectState = 0) then
    SetTorConfig('DisableNetwork', '1');

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
  SetSettings('Network', cbxBridgesPriority, ini);
  SetSettings('Network', udBridgesLimit, ini);
  SetSettings('Network', udMaxDirFails, ini);
  SetSettings('Network', udBridgesCheckDelay, ini);
  SetSettings('Network', edPreferredBridge, ini);
  BridgesCheckControls;
  CountTotalBridges(True);
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
  if (ValidAddress(Host) = 0) or (HostControl.Items.IndexOf(Host) = -1) then
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

  if ValidSocket(ParseStr[0]) <> 0 then
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

procedure TTcp.ResetOptions;
var
  i, LogID: Integer;
  ini, inidef: TMemIniFile;
  ScrollBars, SeparateType, DisplayedLinesType, LogAutoDelType: Byte;
  ParseStr: ArrOfStr;
  Transports: TStringList;
  FilterEntry, FilterMiddle, FilterExit, Temp: string;
  FavoritesEntry, FavoritesMiddle, FavoritesExit, ExcludeNodes: string;
begin
  LoadTorConfig;

  ini := TMemIniFile.Create(UserConfigFile, TEncoding.UTF8);
  inidef := TMemIniFile.Create(DefaultsFile, TEncoding.UTF8);
  try
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

    DefaultsDic.AddOrSetValue('BridgesBot', GetSettings('UserOverrides', 'BridgesBot', BRIDGES_BOT, inidef));
    DefaultsDic.AddOrSetValue('BridgesEmail', GetSettings('UserOverrides', 'BridgesEmail', BRIDGES_EMAIL, inidef));
    DefaultsDic.AddOrSetValue('BridgesSite', GetSettings('UserOverrides', 'BridgesSite', BRIDGES_SITE, inidef));
    DefaultsDic.AddOrSetValue('CheckUrl', GetSettings('UserOverrides', 'CheckUrl', CHECK_URL, inidef));
    DefaultsDic.AddOrSetValue('DownloadUrl', GetSettings('UserOverrides', 'DownloadUrl', DOWNLOAD_URL, inidef));
    DefaultsDic.AddOrSetValue('MetricsUrl', GetSettings('UserOverrides', 'MetricsUrl', METRICS_URL, inidef));

    GetSettings('Main', cbConnectOnStartup, ini);
    GetSettings('Main', cbRestartOnControlFail, ini);
    GetSettings('Main', cbMinimizeToTray, ini);
    GetSettings('Main', cbMinimizeOnClose, ini);
    GetSettings('Main', cbMinimizeOnStartup, ini);
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
    GetSettings('Log', miAutoScroll, ini);
    GetSettings('Log', miWordWrap, ini, False);
    GetSettings('Log', miAutoClear, ini);

    GetSettings('Network', miPreferWebTelegram, ini);
    GetSettings('Network', miRequestIPv6Bridges, ini, False);
    GetSettings('Network', miRequestObfuscatedBridges, ini);

    GetSettings('Lists', cbUseHiddenServiceVanguards, ini);
    GetSettings('Lists', cbxVanguardLayerType, ini);

    GetSettings('Filter', miFilterHideUnused, ini);
    GetSettings('Filter', miFilterScrollTop, ini);
    GetSettings('Filter', miFilterSelectRow, ini);
    GetSettings('Filter', miIgnoreTplLoadParamsOutsideTheFilter, ini);
    GetSettings('Filter', miNotLoadEmptyTplData, ini, False);
    GetSettings('Filter', miReplaceDisabledFavoritesWithCountries, ini);
    GetSettings('Filter', miExcludeBridgesWhenCounting, ini, False);

    GetSettings('Routers', miRoutersScrollTop, ini);
    GetSettings('Routers', miRoutersSelectRow, ini);
    GetSettings('Routers', miShowFlagsHint, ini);
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
    GetSettings('Routers', miAddRelaysToBridgesCache, ini, False);

    GetSettings('Circuits', miHideCircuitsWithoutStreams, ini, False);
    GetSettings('Circuits', miAlwaysShowExitCircuit, ini);
    GetSettings('Circuits', miSelectExitCircuitWhetItChanges, ini);
    GetSettings('Circuits', miShowCircuitsTraffic, ini);
    GetSettings('Circuits', miShowStreamsTraffic, ini);
    GetSettings('Circuits', miShowStreamsInfo, ini);
    GetSettings('Circuits', miShowPortAlongWithIp, ini);

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

    GetSettings('AutoSelNodes', cbxAutoSelPriority, ini);
    GetSettings('AutoSelNodes', udAutoSelEntryCount, ini);
    GetSettings('AutoSelNodes', udAutoSelMiddleCount, ini);
    GetSettings('AutoSelNodes', udAutoSelExitCount, ini);
    GetSettings('AutoSelNodes', udAutoSelMinWeight, ini);
    GetSettings('AutoSelNodes', udAutoSelMaxPing, ini);
    GetSettings('AutoSelNodes', cbAutoSelStableOnly, ini);
    GetSettings('AutoSelNodes', cbAutoSelFilterCountriesOnly, ini);
    GetSettings('AutoSelNodes', cbAutoSelUniqueNodes, ini);
    GetSettings('AutoSelNodes', cbAutoSelNodesWithPingOnly, ini);
    GetSettings('AutoSelNodes', cbAutoSelMiddleNodesWithoutDir, ini);

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
    IntToMenu(miAutoSelNodesType, GetSettings('AutoSelNodes', 'AutoSelNodesType', AUTOSEL_NODES_DEFAULT, ini));

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

    meLog.WordWrap := miWordWrap.Checked;
    SeparateType := GetIntDef(GetSettings('Log', 'SeparateType', 1, ini), 1, 0, 3);
    miLogSeparate.items[SeparateType].Checked := True;
    TorLogFile := GetLogFileName(SeparateType);

    ScrollBars := GetIntDef(GetSettings('Log', 'ScrollBars', 0, ini), 0, 0, 3);
    miScrollBars.items[ScrollBars].Checked := True;
    SetLogScrollBar(ScrollBars);

    DisplayedLinesType := GetIntDef(GetSettings('Log', 'DisplayedLinesType', 2, ini), 2, 0, 7);
    miDisplayedLinesCount.Items[DisplayedLinesType].Checked := True;
    DisplayedLinesCount := miDisplayedLinesCount.Items[DisplayedLinesType].Tag;

    LogAutoDelType := GetIntDef(GetSettings('Log', 'LogAutoDelType', 0, ini), 0, 0, 10);
    if LogAutoDelType in [2, 3] then
      LogAutoDelType := 0;
    miLogAutoDelType.Items[LogAutoDelType].Checked := True;
    LogAutoDelHours := miLogAutoDelType.Items[LogAutoDelType].Tag;

    LogID := GetArrayIndex(LogLevels, AnsiLowerCase(SeparateLeft(GetTorConfig('Log', 'notice stdout', [cfAutoAppend]), ' ')));
    if LogID <> -1 then
      miLogLevel.items[LogID].Checked := True
    else
    begin
      miNotice.Checked := True;
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

    GetSettings(miSafeLogging);
    GetSettings(cbLearnCircuitBuildTimeout);
    GetSettings(cbAvoidDiskWrites);
    GetSettings(cbStrictNodes, [cfBoolInvert]);
    GetSettings(cbEnforceDistinctSubnets);
    GetSettings(udMaxCircuitDirtiness);
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
    GetSettings('Network', udBridgesLimit, ini);
    GetSettings('Network', udMaxDirFails, ini);
    GetSettings('Network', udBridgesCheckDelay, ini);
    GetSettings('Network', cbxBridgesPriority, ini);
    GetSettings('Network', edPreferredBridge, ini);
    LoadBuiltinBridges(inidef, cbxBridgesType.ItemIndex = BRIDGES_TYPE_BUILTIN, True, GetSettings('Network', 'BridgesList', '', ini));
    if cbxBridgesType.ItemIndex = BRIDGES_TYPE_USER then
      LoadUserBridges(ini);
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
    LineToMemo(GetSettings('Server', 'CustomExitPolicy', DEFAULT_CUSTOM_EXIT_POLICY, ini), meExitPolicy, ltPolicy);
    LineToMemo(GetSettings('Server', 'MyFamily', '', ini), meMyFamily, ltHash, True);
    SaveServerOptions(ini);
    SaveTransportsData(ini, True);

    GetSettings('Main', cbxConnectionPadding, ini);
    GetSettings('Main', cbxCircuitPadding, ini);
    SavePaddingOptions(ini);
    CheckPaddingControls;

    GetSettings('Lists', cbUseTrackHostExits, ini);
    GetSettings('Lists', udTrackHostExitsExpire, ini);
    LineToMemo(GetSettings('Lists', 'TrackHostExits', '', ini), meTrackHostExits, ltHost, True);
    SaveTrackHostExits(ini);

    CheckServerControls;
    CheckScannerControls;
    if not FirstLoad then
      CheckStatusControls;
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
      RoutersUpdated := False;
      FilterUpdated := False;
    end;
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
            if ValidAddress(ParseStr[0]) = 1 then
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
    if not (AutoSave or GeoIpModified) then
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
        if DataLength in [8..10] then
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
              1: BridgeInfo.Router.IPv4 := IpStr[j];   
              2: BridgeInfo.Router.IPv6 := IpStr[j];      
            end;  
          end;
          if BridgeInfo.Router.IPv6 <> '' then
            Inc(BridgeInfo.Router.Params, ROUTER_REACHABLE_IPV6);
          BridgeInfo.Router.OrPort := StrToIntDef(ParseStr[3], 0);
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

          BridgeStr := Trim(
            BridgeInfo.Transport + ' ' +
            BridgeInfo.Router.IPv4 + ':' +
            IntToStr(BridgeInfo.Router.OrPort) + ' ' +
            ParseStr[0] + ' ' +
            BridgeInfo.Params
          );
          if ValidBridge(BridgeStr, btNone) then
            BridgesDic.AddOrSetValue(ParseStr[0], BridgeInfo);
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
  Address, Transport, Params: string;
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
      BridgesCache.Append(
        Item.Key + '|' +
        Item.Value.Router.Name + '|' +
        Address + '|' +
        IntToStr(Item.Value.Router.OrPort) + '|' +
        IntToStr(Item.Value.Router.Bandwidth) + '|' +
        Item.Value.Router.Version + '|' +
        IntToStr(Item.Value.Kind) + '|' +
        IntToStr(Integer(rfV2Dir in Item.Value.Router.Flags)) +
        Transport +
        Params
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
  if (FMode = 2) and (lbFavoritesTotal.Tag = 0) then
    FMode := 1;
  if (FMode = 2) and (lbFavoritesEntry.HelpContext = 0) and (lbFavoritesMiddle.HelpContext = 0) and (lbFavoritesExit.HelpContext = 0) then
    FMode := 1;
  if (FMode = 1) and (lbFilterEntry.Tag = 0) and (lbFilterMiddle.Tag = 0) and (lbFilterExit.Tag = 0) then
    FMode := 0;
  if (FMode = 1) and not GeoIpExists then
    FMode := 0;
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
      T.BridgeType := [];
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

function TTcp.RouterInNodesList(RouterID: string; IpStr: string; NodeType: TNodeType; SkipCodes: Boolean = False; CodeStr: string = ''): Boolean;
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
      KeyStr := FindInRanges(IpStr);
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
    0:
    begin
      DeleteTorConfig('EntryNodes');
      DeleteTorConfig('MiddleNodes');
      DeleteTorConfig('ExitNodes');
    end;
    1:
    begin
      if cbUseBridges.Checked then
        DeleteTorConfig('EntryNodes')
      else
        SetTorConfig('EntryNodes', FilterEntry);
      SetTorConfig('MiddleNodes', FilterMiddle);
      SetTorConfig('ExitNodes', FilterExit);
    end;
    2:
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
  ini: TMemIniFile;
  i: Integer;
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
    SetSettings('Main', cbMinimizeOnClose, ini);
    SetSettings('Main', cbMinimizeOnStartup, ini);
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

    SetSettings('AutoSelNodes', udAutoSelEntryCount, ini);
    SetSettings('AutoSelNodes', udAutoSelMiddleCount, ini);
    SetSettings('AutoSelNodes', udAutoSelExitCount, ini);
    SetSettings('AutoSelNodes', udAutoSelMinWeight, ini);
    SetSettings('AutoSelNodes', udAutoSelMaxPing, ini);
    SetSettings('AutoSelNodes', cbxAutoSelPriority, ini);
    SetSettings('AutoSelNodes', cbAutoSelStableOnly, ini);
    SetSettings('AutoSelNodes', cbAutoSelFilterCountriesOnly, ini);
    SetSettings('AutoSelNodes', cbAutoSelUniqueNodes, ini);
    SetSettings('AutoSelNodes', cbAutoSelNodesWithPingOnly, ini);
    SetSettings('AutoSelNodes', cbAutoSelMiddleNodesWithoutDir, ini);

    SetDesktopPosition(Tcp.Left, Tcp.Top);
    SetSettings('Main', 'FormPosition', GetFormPositionStr, ini);

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

    for i := 0 to miLogLevel.Count - 1 do
    begin
      if miLogLevel.items[i].Checked then
      begin
        SetTorConfig('Log', AnsiLowerCase(copy(miLogLevel.items[i].Name, 3, Length(miLogLevel.items[i].Name) - 2)) + ' stdout');
        Break;
      end;
    end;

    SetTorConfig('SafeLogging', IntToStr(Integer(miSafeLogging.Checked)));
    SetTorConfig('MaxCircuitDirtiness', IntToStr(udMaxCircuitDirtiness.Position));
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
    UpdateBridgesControls(True, False);
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
        if RoutersUpdated then
          ShowRouters;
      end;
    end;

    if cbxLanguage.ItemIndex <> cbxLanguage.Tag then
      cbxLanguage.Tag := cbxLanguage.ItemIndex;

    UpdateOptionsAfterRoutersUpdate;

    SaveTorConfig;
    ReloadTorConfig;
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
    RangesDic.Clear;
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
  IpList: TDictionary<string, Byte>;
  NodeItem: TPair<string, TNodeTypes>;
  RouterItem: TPair<string, TRouterInfo>;
  ListItem: TPair<string, Byte>;
  DeleteExcludeNodes, Search: Boolean;
  Cidr: TIPv4Range;

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
  IpList := TDictionary<string, Byte>.Create;
  try
    for RouterItem in RoutersDic do
      IpList.AddOrSetValue(RouterItem.Value.IPv4, 0);

    for NodeItem in NodesDic do
    begin
      if ValidHash(NodeItem.Key) then
      begin
        if not RoutersDic.ContainsKey(NodeItem.Key) then
          SetNodesData;
      end
      else
      begin
        if ValidAddress(NodeItem.Key, True, True) = 1 then
        begin
          if Pos('/', NodeItem.Key) = 0 then
          begin
            if not IpList.ContainsKey(NodeItem.Key) then
              SetNodesData;
          end
          else
          begin
            Search := False;
            Cidr := CidrToRange(NodeItem.Key);
            for ListItem in IpList do
              if InRange(IpToInt(ListItem.Key), Cidr.IpStart, Cidr.IpEnd) then
              begin
                Search := True;
                Break;
              end;
            if not Search then
            begin
              RangesDic.Remove(NodeItem.Key);
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
          if (ntExit in NodeTypes) and not (rfExit in Flags) then
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
    RangeItem: TPair<string, TIpv4Range>;
    RangeInfo: TNodeTypes;
    NodeID: string;
  begin
    if RangesDic.Count > 0 then
    begin
      if HashID = '' then
        NodeID := NodeIp
      else
        NodeID := HashID;
      for RangeItem in RangesDic do
      begin
        if InRange(IpToInt(NodeIp), RangeItem.Value.IpStart, RangeItem.Value.IpEnd) then
        begin
          if NodesDic.TryGetValue(RangeItem.Key, RangeInfo) then
          begin
            if NodeTypes = [ntNone] then
              CheckNode(RangeItem.Key, RangeInfo, HashID)
            else
            begin
              if NodesDic.ContainsKey(NodeID) then
              begin
                if (ntExclude in RangeInfo) then
                begin
                  if NodeTypes <> [ntExclude] then
                    NodesDic.AddOrSetValue(NodeID, [])
                end
                else
                begin
                  if ntExclude in NodesDic.Items[NodeID] then
                    NodesDic.AddOrSetValue(RangeItem.Key, [])
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
    RangeItem: TPair<string, TIpv4Range>;
    Range: TIpv4Range;
  begin
    if RangesDic.Count > 1 then
    begin
      if RangesDic.ContainsKey(RangeID) then
        Range := RangesDic.Items[RangeID]
      else
        Range := CidrToRange(RangeID);
      for RangeItem in RangesDic do
      begin
        if RangeID <> RangeItem.Key then
        begin
          if InRange(Range.IpStart, RangeItem.Value.IpStart, RangeItem.Value.IpEnd) and
            InRange(Range.IpEnd, RangeItem.Value.IpStart, RangeItem.Value.IpEnd) then
          begin
            if NodesDic.ContainsKey(RangeItem.Key) then
            begin
              if (ntExclude in NodesDic.Items[RangeItem.Key]) then
              begin
                if NodesDic.ContainsKey(RangeID) then
                  NodesDic.AddOrSetValue(RangeID, []);
              end
              else
              begin
                if (ntExclude in NodeTypes) then
                  NodesDic.AddOrSetValue(RangeItem.Key, [])
                else
                  if NodesDic.Items[RangeItem.Key] = NodeTypes then
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

  procedure ConvertNodesToHash(NodeIp, HashID: string);
  var
    RangeItem: TPair<string, TIpv4Range>;
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
      if RangesDic.Count > 0 then
      begin
        for RangeItem in RangesDic do
        begin
          if InRange(IpToInt(NodeIp), RangeItem.Value.IpStart, RangeItem.Value.IpEnd) then
            UpdateNodes(RangeItem.Key);
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
            RangesDic.Remove(UpdateItem.Key);
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
          if ValidAddress(NodeItem.Key) = 1 then
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
  if FileExists(UserDir + 'cached-consensus') or
    FileExists(UserDir + 'cached-consensus.tmp') then
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
      AddToIpList(Router.Value.IPv4, IntToStr(Router.Value.OrPort));

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

procedure TTcp.cbxExitPolicyTypeChange(Sender: TObject);
begin
  if cbxExitPolicyType.ItemIndex = 2 then
    meExitPolicy.Enabled := True
  else
    meExitPolicy.Enabled := False;
  EnableOptionButtons;
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

  ini := TMemIniFile.Create(UserConfigFile, TEncoding.UTF8);
  try
    ParseStr := Explode(';', GetSettings('Templates', IntToStr(TMenuItem(Sender).Tag), '', ini));
    n := Length(ParseStr);
    if n in [5,9] then
    begin
      if ValidInt(ParseStr[1], 0, 2) then
        cbxFilterMode.ItemIndex := StrToInt(ParseStr[1])
      else
      begin
        ShowMsg(TransStr('254'), '', mtError);
        Exit;
      end;

      FUpdated := False;
      RUpdated := False;
      ImmediateApplyOptions := TMenuItem(Sender).Hint = 'ApplyOptions';
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
        UpdateOptionsAfterRoutersUpdate;
        ShowRouters;
        FilterUpdated := False;
      end;

      if FUpdated or RUpdated then
      begin
        if ImmediateApplyOptions and not OptionsChanged then
          ApplyOptions(True)
        else
        begin
          EnableOptionButtons;
          CountTotalBridges;
        end;
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
  TemplateName, TimeStampStr: string;
  Router: TRouterInfo;
  Search, IsIPv6: Boolean;
begin
  if lbExitIp.Tag = 1 then
    SelectedNode := ExitNodeID
  else
  begin
    SelectRowPopup(sgCircuitInfo, mnDetails);
    SelectedNode := sgCircuitInfo.Cells[CIRC_INFO_ID, sgCircuitInfo.SelRow];
  end;
  miDetailsCopyFingerprint.Caption := SelectedNode;

  Search := False;
  IsIPv6 := False;
  if RoutersDic.TryGetValue(SelectedNode, Router) then
  begin
    Search := True;
    IsIPv6 := Router.IPv6 <> '';
    miDetailsCopyNickname.Caption := Router.Name;
    miDetailsCopyIPv4.Caption := Router.IPv4;
    miDetailsCopyIPv6.Caption := Router.IPv6;
    UpdateBridgeCopyMenu(miDetailsCopyBridgeIPv4, SelectedNode, Router, False);
    UpdateBridgeCopyMenu(miDetailsCopyBridgeIPv6, SelectedNode, Router, True);
  end;

  miDetailsCopyNickname.Visible := Search;
  miDetailsCopyIPv4.Visible := Search;
  miDetailsCopyIPv6.Visible := IsIPv6;
  miDetailsCopyBridgeIPv4.Visible := Search;
  miDetailsCopyBridgeIPv6.Visible := IsIPv6;

  miDetailsUpdateIp.Enabled := ConnectState = 2;
  miDetailsAddToNodesList.Enabled := Search and (ConnectState <> 1);
  miDetailsSelectTemplate.Enabled := False;

  if miDetailsAddToNodesList.Enabled then
    InsertNodesMenu(miDetailsAddToNodesList, SelectedNode);

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
          SelectMenu.OnClick := Tcp.FilterLoadClick;
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
  if not aSg.SortType in [SORT_ASC..SORT_DESC] then
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
          LoadMenu.OnClick := Tcp.FilterLoadClick;
          miLoadTemplate.Add(LoadMenu);

          DeleteMenu := TMenuItem.Create(self);
          DeleteMenu.Caption := TemplateName;
          if TemplateList.Count > 1 then
            DeleteMenu.Tag := TimeStamp
          else
            DeleteMenu.Tag := 0;
          DeleteMenu.OnClick := Tcp.FilterDeleteClick;
          miDeleteTemplate.Add(DeleteMenu);
        end;
        DeleteMenu := TMenuItem.Create(self);
        DeleteMenu.Caption := '-';
        miDeleteTemplate.Add(DeleteMenu);

        DeleteMenu := TMenuItem.Create(self);
        DeleteMenu.Caption := TransStr('264');
        DeleteMenu.Tag := 0;
        DeleteMenu.OnClick := Tcp.FilterDeleteClick;
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
var
  State: Boolean;
begin
  State := ConnectState <> 1;
  miLogLevel.Enabled := State;
  miSafeLogging.Enabled := State;
  miOpenFileLog.Enabled := FileExists(TorLogFile);
  miOpenLogsFolder.Enabled := DirectoryExists(LogsDir);
  miLogSeparate.Enabled := miWriteLogFile.Checked;

  EditMenuEnableCheck(miLogCopy, emCopy);
  EditMenuEnableCheck(miLogSelectAll, emSelectAll);
  EditMenuEnableCheck(miLogClear, emClear);
  EditMenuEnableCheck(miLogFind, emFind);
end;

procedure TTcp.UpdateBridgeCopyMenu(Menu: TMenuItem; RouterID: string; Router: TRouterInfo; UseIPv6: Boolean);
var
  Data, BridgeStr, Transport, IpStr: string;
  BridgeInfo: TBridgeInfo;
begin
  if UseIPv6 then
    IpStr := Router.IPv6
  else
    IpStr := Router.IPv4;
  Menu.Hint := '';
  Menu.Caption := '';
  Menu.Visible := IpStr <> '';
  if not Menu.Visible then
    Exit;
  Data := IpStr + ':' + IntToStr(Router.OrPort) + ' ' + RouterID;

  if BridgesDic.TryGetValue(RouterID, BridgeInfo) then
    BridgeStr := Trim(BridgeInfo.Transport + ' ' + IpStr + ':' + IntToStr(BridgeInfo.Router.OrPort) + ' ' + RouterID + ' ' + BridgeInfo.Params)
  else
    BridgeStr := '';

  if TryGetDataFromStr(BridgeStr, ltTransport, Transport) then
  begin
    Data := Transport + ' ' + Data;
    if BridgesDic.ContainsKey(RouterID) then
      Menu.Hint := BridgeStr
    else
      Menu.Hint := Data + Copy(BridgeStr, Pos(RouterID, BridgeStr) + Length(RouterID));
    Data := Data + '...';
  end;
  Menu.Caption := Data;
end;

procedure TTcp.mnRoutersPopup(Sender: TObject);
var
  State, ClearState, ActionState, TypeState, NotStarting, FindPorts: Boolean;
  Router: TRouterInfo;
  RouterID: string;
begin
  SelectRowPopup(sgRouters, mnRouters);
  NotStarting := ConnectState <> 1;
  State := not IsEmptyRow(sgRouters, sgRouters.SelRow);

  miRtCopy.Visible := State;
  miRtRelayInfo.Visible := State;
  miRtAddToNodesList.Visible := State;
  miRtAddToNodesList.Enabled := NotStarting;
  miRtSelectAsBridge.Visible := State;
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
  MenuSelectPrepare(miAutoSelNodesSA, miAutoSelNodesUA);

  if State then
  begin
    RouterID := sgRouters.Cells[ROUTER_ID, sgRouters.SelRow];
    if RoutersDic.TryGetValue(RouterID, Router) then
    begin
      miRtCopyNickname.Caption := Router.Name;
      miRtCopyFingerprint.Caption := RouterID;
      miRtCopyIPv4.Caption := Router.IPv4;
      miRtCopyIPv6.Caption := Router.IPv6;
      miRtCopyIPv6.Visible := Router.IPv6 <> '';
      UpdateBridgeCopyMenu(miRtCopyBridgeIPv4, RouterID, Router, False);
      UpdateBridgeCopyMenu(miRtCopyBridgeIPv6, RouterID, Router, True);
      miRtSelectAsBridgeIPv4.Caption := miRtCopyBridgeIPv4.Caption;
      miRtSelectAsBridgeIPv4.Hint := miRtCopyBridgeIPv4.Hint;
      miRtSelectAsBridgeIPv4.Visible := miRtCopyBridgeIPv4.Caption <> '';
      miRtSelectAsBridgeIPv6.Caption := miRtCopyBridgeIPv6.Caption;
      miRtSelectAsBridgeIPv6.Hint := miRtCopyBridgeIPv6.Hint;
      miRtSelectAsBridgeIPv6.Visible := miRtCopyBridgeIPv6.Caption <> '';

      if ReachablePortsExists then
      begin
        FindPorts := PortsDic.ContainsKey(Router.OrPort);
        PortsDic.Clear;
      end
      else
        FindPorts := True;
      miRtSelectAsBridge.Visible := (cbxServerMode.ItemIndex = SERVER_MODE_NONE) and
        (sgRouters.Cells[ROUTER_EXCLUDE_NODES, sgRouters.SelRow] <> EXCLUDE_CHAR) and
        ((rfBridge in Router.Flags) or (rfGuard in Router.Flags)) and
        (((Router.Params and ROUTER_ALIVE <> 0) and FindPorts) or not miDisableSelectionUnSuitableAsBridge.Checked);
      miRtDisableBridges.Visible := cbUseBridges.Checked;
    end;
    InsertNodesMenu(miRtAddToNodesList, RouterID, False);
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
        HostMenu.OnClick := Tcp.BindToExitNodeClick;
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
    (FileExists(UserDir + 'cached-consensus') or FileExists(UserDir + 'cached-consensus.tmp'));
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
  IsBridgeEdit, IsUserBridges, State: Boolean;
  BridgesCount: Integer;
begin
  BridgesCount := meBridges.Lines.Count;
  IsBridgeEdit := Screen.ActiveControl = meBridges;
  IsUserBridges := IsBridgeEdit and (cbxBridgesType.ItemIndex = BRIDGES_TYPE_USER) and (BridgesCount > 0);
  State := IsUserBridges and not tmScanner.Enabled;

  miGetBridges.Visible := IsBridgeEdit;
  miClear.Visible := not IsUserBridges;
  miClearBridges.Visible := IsUserBridges;

  miGetBridgesEmail.Enabled := IsBridgeEdit and RegistryFileExists(HKEY_CLASSES_ROOT, 'mailto\shell\open\command', '');
  miGetBridgesTelegram.Enabled := IsBridgeEdit and (RegistryFileExists(HKEY_CLASSES_ROOT, 'tg\shell\open\command', '') or miPreferWebTelegram.Checked);

  miClearBridgesNotAlive.Enabled := State and cbEnableDetectAliveNodes.Checked;
  miClearBridgesCached.Enabled := State;
  miClearBridgesNonCached.Enabled := State;
  miClearBridgesUnsuitable.Enabled := State and cbExcludeUnsuitableBridges.Checked and
    (SuitableBridgesCount < BridgesCount);

  EditMenuEnableCheck(miCopy, emCopy);
  EditMenuEnableCheck(miCut, emCut);
  EditMenuEnableCheck(miPaste, emPaste);
  EditMenuEnableCheck(miSelectAll, emSelectAll);
  if IsUserBridges then
    miClearBridgesAll.Enabled := State
  else
    EditMenuEnableCheck(miClear, emClear);
  EditMenuEnableCheck(miDelete, emDelete);
  EditMenuEnableCheck(miFind, emFind);
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
  sbShowOptions.Click;
  pcOptions.TabIndex := tsFilter.TabIndex;
end;

procedure TTcp.lbStatusProxyAddrClick(Sender: TObject);
begin
  Clipboard.AsText := TLabel(Sender).Caption;
end;

procedure TTcp.lbStatusProxyAddrMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if ValidSocket(TLabel(Sender).Caption, False) <> 0 then
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
    Btn.Width := Round(117 * Scale);
    Btn.Left := Round(LeftBig * Scale);
  end;
end;

procedure TTcp.ChangeButtonsCaption;
begin
  if FormSize = 0 then
  begin
    btnChangeCircuit.Width := Round(117 * Scale);
    btnSwitchTor.Width := Round(117 * Scale);
  end
  else
  begin
    btnChangeCircuit.Width := Round(117 * Scale);
    btnSwitchTor.Width := Round(117 * Scale);
  end;
  SetButtonsProp(sbShowOptions, 122, 122);
  SetButtonsProp(sbShowLog, 164, 241);
  SetButtonsProp(sbShowStatus, 206, 360);
  SetButtonsProp(sbShowCircuits, 248, 479);
  SetButtonsProp(sbShowRouters, 290, 598);
  CheckLabelEndEllipsis(lbExitCountry, 150, epEndEllipsis, True, False);
end;

procedure TTcp.UpdateFormSize;
var
  H, W: Integer;
begin
  if FormSize = 0 then
  begin
    H := Round(91 * Scale);
    W := Round(333 * Scale);
  end
  else
  begin
    H := Round(556 * Scale);
    W := Round(760 * Scale);
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
    cc := AnsiLowerCase(sgFilter.Cells[FILTER_ID, sgFilter.SelRow])
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
    ls := TStringList.Create;;
    try
      for Item in TrackHostDic do
        ls.Append(Item.Key);
      ls.CustomSort(CompTextAsc);
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
    TrackHostExits := MemoToLine(meTrackHostExits, ltHost, True);
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
      SendCommand('SETCONF TrackHostExits=');
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

  MyFamily := MemoToLine(meMyFamily, ltHash, True);
  ExitPolicy := MemoToLine(meExitPolicy, ltPolicy);
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
      if CurrentScanPurpose = spUserBridges then
        Result := TransStr('396')
      else
        Result := TransStr('383');
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
end;

procedure TTcp.ScanNetwork(ScanType: TScanType; ScanPurpose: TScanPurpose);
var
  CurrentDate: Int64;
  MaxPartialScans: Integer;
begin
  if (ScanType = stNone) or (ScanPurpose = spNone) then
    Exit;
  if cbEnablePingMeasure.Checked or cbEnableDetectAliveNodes.Checked or (ScanPurpose = spUserBridges) then
  begin
    if not tmScanner.Enabled then
    begin
      CurrentDate := DateTimeToUnix(Now);
      CurrentScanPurpose := ScanPurpose;
      ScanStage := 1;
      if ScanType = stBoth then
      begin
        if (cbEnablePingMeasure.Checked and cbEnableDetectAliveNodes.Checked) or (ScanPurpose = spUserBridges) then
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
        MaxPartialScans := udPartialScansCounts.Position;
        if CurrentDate >= (LastFullScanDate + (udFullScanInterval.Position * 3600)) then
        begin
          CurrentAutoScanPurpose := spAll;
          LastFullScanDate := CurrentDate;
          LastPartialScanDate := CurrentDate;
          LastPartialScansCounts := MaxPartialScans;
        end
        else
        begin
          CurrentAutoScanPurpose := spNew;
          if cbxAutoScanType.ItemIndex <> 4 then
          begin
            if (LastPartialScansCounts > 0) and (CurrentDate >= (LastPartialScanDate + (udPartialScanInterval.Position * 3600))) then
            begin
              case cbxAutoScanType.ItemIndex of
                0:
                begin
                  if LastPartialScansCounts mod 3 = 0 then
                    CurrentAutoScanPurpose := spNewAndFailed
                  else
                    CurrentAutoScanPurpose := spNewAndAlive
                end;
                1: CurrentAutoScanPurpose := spNewAndFailed;
                2: CurrentAutoScanPurpose := spNewAndAlive;
                3: CurrentAutoScanPurpose := spNewAndBridges;
              end;
              LastPartialScanDate := CurrentDate;
              Dec(LastPartialScansCounts);
            end;
          end;
        end;
        AutoScanStage := 2;
      end
      else
        CurrentAutoScanPurpose := spNone;

      case ScanStage of
        1: ScanStart(ScanType, CurrentScanPurpose);
        2: ScanStart(stPing, CurrentScanPurpose);
      end;

      if CurrentScanPurpose = spUserBridges then
        SetOptionsEnable(False);

      tmScanner.Enabled := True;
    end;
  end;
end;

procedure TTcp.tmScannerTimer(Sender: TObject);
var
  ls: TStringList;
  i: Integer;
  IpStr, PortStr: string;
  GeoIpInfo: TGeoIpInfo;
  Bridge: TBridge;
  ini: TMemIniFile;
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
      if (CurrentScanPurpose = spUserBridges) and (CurrentScanType = stAlive) then
      begin
        if meBridges.Text <> '' then
        begin
          ls := TStringList.Create;
          try
            ls.Text := meBridges.Text;
            for i := ls.Count - 1 downto 0 do
            begin
              if TryParseBridge(ls[i], Bridge) then
              begin
                IpStr := GetBridgeIp(Bridge);
                PortStr := IntToStr(Bridge.Port);
                if IpInRanges(IpStr, DocRanges) then
                  Continue;
                if GeoIpDic.TryGetValue(IpStr, GeoIpInfo) then
                begin
                  if GetPortsValue(GeoIpInfo.ports, PortStr) = -1 then
                    ls.Delete(i);
                  if (GeoIpInfo.cc = DEFAULT_COUNTRY_ID) and (GeoIpInfo.ping = 0) then
                    GeoIpDic.Remove(IpStr);
                end;
              end;
            end;
            if not StopScan then
              meBridges.Text := ls.Text;
          finally
            ls.Free;
          end;
        end;
      end;

      case CurrentScanPurpose of
        spUserBridges: SetOptionsEnable(True);
        spAuto:
        begin
          if not StopScan then
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
        end;
      end;
      if AutoScanStage = 2 then
      begin
        if ConnectState <> 0 then
          AutoScanStage := 3
        else
          AutoScanStage := 0;
      end;
      LoadConsensus;
      if ConnectState = 0 then
        SaveNetworkCache;
      ScanStage := 0;
      UpdateScannerControls;
      CurrentScanPurpose := spNone;
      CurrentAutoScanPurpose := spNone;
      CurrentScanType := stNone;
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

      if CountryTotals[TOTAL_ALIVES][CountryID] > 0 then
        sgFilter.Cells[FILTER_ALIVE, FilterCount] := IntToStr(CountryTotals[5][CountryID])
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
    GridScrollCheck(sgFilter, FILTER_NAME, 312)
  else
  begin
    if cbEnablePingMeasure.Checked or cbEnableDetectAliveNodes.Checked then
      GridScrollCheck(sgFilter, FILTER_NAME, 368)
    else
      GridScrollCheck(sgFilter, FILTER_NAME, 424);
  end;
  EndUpdateTable(sgFilter);
  lbFilterCount.Caption := Format(TransStr('321'), [FilterCount, FilterDic.Count]);
end;

function TTcp.FindInRanges(IpStr: string): string;
var
  RangeItem: TPair<string, TIPv4Range>;
begin
  Result := '';
  if IpStr = '' then
    Exit;
  if RangesDic.Count > 0 then
  begin
    for RangeItem in RangesDic do
      if InRange(IpToInt(IpStr), RangeItem.Value.IpStart, RangeItem.Value.IpEnd) then
        Result := Result + ',' + RangeItem.Key;
    Delete(Result, 1, 1);
  end;
end;

procedure TTcp.ShowRouters;
var
  RoutersCount, i, j: Integer;
  cdExit, cdGuard, cdAuthority, cdOther, cdBridge, cdFast, cdStable, cdV2Dir, cdHSDir, cdRecommended, cdDirMirror, cdAlive, cdConsensus: Boolean;
  cdRouterType, cdCountry, cdWeight, cdQuery, cdFavorites: Boolean;
  Item: TPair<string, TRouterInfo>;
  CountryCode: string;
  CountryID: Byte;
  FindCountry, FindHash, FindIp, IsExclude, IsNativeBridge, IsPrefferedBridge, WrongQuery: Boolean;
  FindCidr, Query, Temp: string;
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
            if IsPrefferedBridge then
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
      8:if not TransportsDic.ContainsKey(Query) and (Query <> '-') then
          WrongQuery := True;
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
      FindCidr := '';
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
          4: cdQuery := PortsDic.ContainsKey(Item.Value.OrPort);
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
                cdQuery := BridgeInfo.Transport = Query
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

      if RoutersCustomFilter in [ENTRY_ID..FAVORITES_ID] then
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
              FindCidr := FindInRanges(Item.Value.IPv4);
              if FindCidr <> '' then
              begin
                cdFavorites := False;
                ParseStr := Explode(',', FindCidr);
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
      end
      else
        cdFavorites := True;

      if cdRouterType and cdWeight and cdCountry and cdFavorites and cdQuery then
      begin
        Inc(RoutersCount);
        sgRouters.Cells[ROUTER_ID, RoutersCount] := Item.Key;
        sgRouters.Cells[ROUTER_NAME, RoutersCount] := Item.Value.Name;
        sgRouters.Cells[ROUTER_IP, RoutersCount] := Item.Value.IPv4;
        sgRouters.Cells[ROUTER_COUNTRY, RoutersCount] := TransStr(CountryCode);
        sgRouters.Cells[ROUTER_WEIGHT, RoutersCount] := BytesFormat(Item.Value.Bandwidth * 1024) + '/' + TransStr('180');
        sgRouters.Cells[ROUTER_PORT, RoutersCount] := IntToStr(Item.Value.OrPort);
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
        IsPrefferedBridge := (Item.Key = LastPreferredBridgeHash) and cbUseBridges.Checked and cbUsePreferredBridge.Checked;

        if not (rfGuard in Item.Value.Flags) or IsNativeBridge then
          sgRouters.Cells[ROUTER_ENTRY_NODES, RoutersCount] := NONE_CHAR;
        if not (rfExit in Item.Value.Flags) or IsNativeBridge then
          sgRouters.Cells[ROUTER_EXIT_NODES, RoutersCount] := NONE_CHAR;
        if IsNativeBridge then
          sgRouters.Cells[ROUTER_MIDDLE_NODES, RoutersCount] := NONE_CHAR;

        FindHash := NodesDic.ContainsKey(Item.Key);
        FindIp := NodesDic.ContainsKey(Item.Value.IPv4);
        FindCountry := NodesDic.ContainsKey(CountryCode);
        FindCidr := FindInRanges(Item.Value.IPv4);

        IsExclude := False;

        if FindHash then
          if ntExclude in NodesDic.Items[Item.Key] then
            IsExclude := True;
        if FindCountry then
          if ntExclude in NodesDic.Items[CountryCode] then
            IsExclude := True;
        if FindIp then
          if ntExclude in NodesDic.Items[Item.Value.IPv4] then
            IsExclude := True;
        if FindCidr <> '' then
        begin
          ParseStr := Explode(',', FindCidr);
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

        if IsPrefferedBridge then
        begin
          sgRouters.Cells[ROUTER_ENTRY_NODES, RoutersCount] := BOTH_CHAR;
          sgRouters.Cells[ROUTER_MIDDLE_NODES, RoutersCount] := NONE_CHAR;
          sgRouters.Cells[ROUTER_EXIT_NODES, RoutersCount] := NONE_CHAR;
        end;

        if FindHash then
          SelectNodes(Item.Key, IsExclude);
        if FindCountry then
          SelectNodes(CountryCode, IsExclude);
        if FindIp then
          SelectNodes(Item.Value.IPv4, IsExclude);
        if FindCidr <> '' then
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
    GridScrollCheck(sgRouters, ROUTER_COUNTRY, 121)
  else
    GridScrollCheck(sgRouters, ROUTER_COUNTRY, 141);
  EndUpdateTable(sgRouters);
  lbRoutersCount.Caption := Format(TransStr('321'), [RoutersCount, RoutersDic.Count]);

  if PortsDic.Count > 0 then
    PortsDic.Clear;
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
          if Pos(IntToStr(Item.Value.OrPort) + ':1', ParseStr[i]) = 1 then
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

procedure TTcp.ShowCircuits;
var
  CircuitsCount: Integer;
  Item: TPair<string, TCircuitInfo>;
  PurposeStr: string;
  TotalConnections: Integer;
begin
  if LockCircuits then
    Exit;
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
        if (Item.Key = Circuit) then
        begin
          if not miAlwaysShowExitCircuit.Checked then
            Continue;
        end
        else
          Continue;
      end;
    end;
    PurposeStr := '';
    if bfOneHop in (Item.Value.BuildFlags) then
    begin
      if miCircOneHop.Checked then
        PurposeStr := TransStr('331')
    end
    else
    begin
      case Item.Value.PurposeID of
        GENERAL:
        begin
          if bfInternal in (Item.Value.BuildFlags) then
          begin
            if miCircInternal.Checked then
              PurposeStr := TransStr('332')
          end
          else
            if miCircExit.Checked or (miAlwaysShowExitCircuit.Checked and (Item.Key = Circuit)) then
              PurposeStr := TransStr('333')
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
        else
          if miCircOther.Checked then PurposeStr := TransStr('345');
      end;
    end;
    if PurposeStr <> '' then
    begin
      Inc(CircuitsCount);
      sgCircuits.Cells[CIRC_ID, CircuitsCount] := Item.Key;
      sgCircuits.Cells[CIRC_PURPOSE, CircuitsCount] := PurposeStr;
      if Item.Value.Streams > 0 then
        sgCircuits.Cells[CIRC_STREAMS, CircuitsCount] := IntToStr(Item.Value.Streams)
      else
        sgCircuits.Cells[CIRC_STREAMS, CircuitsCount] := NONE_CHAR;
      sgCircuits.Cells[CIRC_BYTES_READ, CircuitsCount] := IntToStr(Item.Value.BytesRead);
      sgCircuits.Cells[CIRC_BYTES_WRITTEN, CircuitsCount] := IntToStr(Item.Value.BytesWritten);
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
  GridScrollCheck(sgCircuits, CIRC_PURPOSE, 180);
  EndUpdateTable(sgCircuits);
  lbCircuitsCount.Caption := Format(TransStr('349'), [CircuitsCount, CircuitsDic.Count]);
  lbStreamsCount.Caption := TransStr('350') + ': ' + IntToStr(TotalConnections);
  ShowCircuitInfo(sgCircuits.Cells[CIRC_ID, sgCircuits.SelRow]);
  LockCircuits := False;
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
          sgCircuitInfo.Cells[CIRC_INFO_IP, NodesCount] := Router.IPv4 + ':' + IntToStr(Router.OrPort)
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
    lbDetailsTime.Caption := TransStr('221') + ': ' + CircuitInfo.Date;
  end
  else
  begin
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
    lbDLCirc.Caption := TransStr('214') + ': ' + BytesFormat(CircuitInfo.BytesRead);
    lbULCirc.Caption := TransStr('215') + ': ' + BytesFormat(CircuitInfo.BytesWritten);
  end
  else
  begin
    lbDLCirc.Caption := TransStr('214') + ': ' + INFINITY_CHAR;
    lbULCirc.Caption := TransStr('215') + ': ' + INFINITY_CHAR;
  end;

  if StreamsCount > 0 then
    sgStreams.RowCount := StreamsCount + 1
  else
    sgStreams.RowCount := 2;

  GridSort(sgStreams);
  SetGridLastCell(sgStreams, False, False, False, -1, -1, 1);
  if miShowStreamsTraffic.Checked then
    GridScrollCheck(sgStreams, STREAMS_TARGET, 323)
  else
    GridScrollCheck(sgStreams, STREAMS_TARGET, 446);
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
              case Target.AddrType of
                atExit: sgStreamsInfo.Cells[STREAMS_INFO_DEST_ADDR, StreamsCount] := Target.Hostname + ':' + Target.Port;
                atOnion: sgStreamsInfo.Cells[STREAMS_INFO_DEST_ADDR, StreamsCount] := TransStr('122');
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
    GridScrollCheck(sgStreamsInfo, STREAMS_INFO_PURPOSE, 119)
  else
    GridScrollCheck(sgStreamsInfo, STREAMS_INFO_PURPOSE, 163);
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
    FindInRouters(LastPreferredBridgeHash, FormatHost(Bridge.Ip) + ':' + IntToStr(Bridge.Port))
  else
    FindInRouters(LastPreferredBridgeHash);
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
  EnableOptionButtons;
  BridgesCheckControls;
  CountTotalBridges;
end;

procedure TTcp.ServerAddressEnable(State: Boolean);
begin
  edAddress.Enabled := State;
  lbAddress.Enabled := State;
end;

procedure TTcp.cbUseAddressClick(Sender: TObject);
begin
  if cbUseAddress.Checked then
    ServerAddressEnable(True)
  else
    ServerAddressEnable(False);
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
  TypeState := cbxAutoScanType.ItemIndex <> 4;

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
  lbAutoScanType.Enabled := AutoState;
  cbxAutoScanType.Enabled := AutoState;
  cbAutoScanNewNodes.Enabled := State;

  if PingState and AliveState then
  begin
    sgFilter.ColWidths[FILTER_ALIVE] := Round(55 * Scale);
    sgFilter.ColWidths[FILTER_PING] := Round(55 * Scale);
    GridScrollCheck(sgFilter, FILTER_NAME, 312);
  end
  else
  begin
    if PingState and not AliveState then
    begin
      sgFilter.ColWidths[FILTER_ALIVE] := -1;
      sgFilter.ColWidths[FILTER_PING] := Round(55 * Scale);
      GridScrollCheck(sgFilter, FILTER_NAME, 368);
    end
    else
    begin
      if AliveState and not PingState then
      begin
        sgFilter.ColWidths[FILTER_ALIVE] := Round(55 * Scale);
        sgFilter.ColWidths[FILTER_PING] := -1;
        GridScrollCheck(sgFilter, FILTER_NAME, 368);
      end
      else
      begin
        sgFilter.ColWidths[FILTER_ALIVE] := -1;
        sgFilter.ColWidths[FILTER_PING] := -1;
        GridScrollCheck(sgFilter, FILTER_NAME, 424);
      end;
    end;
  end;

  if PingState then
  begin
    sgCircuitInfo.ColWidths[CIRC_INFO_NAME] := Round(120 * Scale);
    sgCircuitInfo.ColWidths[CIRC_INFO_IP] := Round(120 * Scale);
    sgCircuitInfo.ColWidths[CIRC_INFO_COUNTRY] := Round(119 * Scale);
    sgCircuitInfo.ColWidths[CIRC_INFO_PING] := Round(48 * Scale);
    sgRouters.ColWidths[ROUTER_NAME] := Round(106 * Scale);
    sgRouters.ColWidths[ROUTER_IP] := Round(88 * Scale);
    sgRouters.ColWidths[ROUTER_PING] := Round(44 * Scale);
    GridScrollCheck(sgRouters, ROUTER_COUNTRY, 121);
  end
  else
  begin
    sgCircuitInfo.ColWidths[CIRC_INFO_NAME] := Round(135 * Scale);
    sgCircuitInfo.ColWidths[CIRC_INFO_IP] := Round(135 * Scale);
    sgCircuitInfo.ColWidths[CIRC_INFO_COUNTRY] := Round(139 * Scale);
    sgCircuitInfo.ColWidths[CIRC_INFO_PING] := -1;
    sgRouters.ColWidths[ROUTER_NAME] := Round(121 * Scale);
    sgRouters.ColWidths[ROUTER_IP] := Round(98 * Scale);
    sgRouters.ColWidths[ROUTER_PING] := Round(-1 * Scale);
    GridScrollCheck(sgRouters, ROUTER_COUNTRY, 141);
  end;
end;

procedure TTcp.cbEnablePingMeasureClick(Sender: TObject);
begin
  if cbEnablePingMeasure.Focused then
  begin
    CheckScannerControls;
    CheckStatusControls;
    if cbEnablePingMeasure.Checked then
      ConsensusUpdated := True;
    EnableOptionButtons;
  end;
end;

procedure TTcp.cbEnableDetectAliveNodesClick(Sender: TObject);
begin
  if cbEnableDetectAliveNodes.Focused then
  begin
    CheckScannerControls;
    CheckStatusControls;
    if cbEnableDetectAliveNodes.Checked then
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

procedure TTcp.CountTotalBridges(ConfigUpdating: Boolean = False);
var
  NumStr: string;
  BridgesCount: Integer;
begin
  BridgesCount := meBridges.Lines.Count;
  if cbExcludeUnsuitableBridges.Checked then
  begin
    if OptionsChanged and not ConfigUpdating then
      NumStr := INFINITY_CHAR
    else
      NumStr := IntToStr(SuitableBridgesCount);
    lbTotalBridges.Caption := Format(TransStr('632'), [NumStr, BridgesCount]);
  end
  else
    lbTotalBridges.Caption := TransStr('203') + ': ' + IntToStr(BridgesCount);
end;

procedure TTcp.meBridgesChange(Sender: TObject);
begin
  if not meBridges.Focused and (CurrentScanPurpose <> spUserBridges) and (ConnectState <> 1) then
    Exit;
  EnableOptionButtons;
  CountTotalBridges;
end;

procedure TTcp.meLogMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    meLog.Tag := 1;
end;

procedure TTcp.meLogMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    if meLog.SelLength = 0 then
      meLog.Tag := 0;
  end;
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
    else
      if aSg.SortType = SORT_ASC then aCompare := CompTextAsc else aCompare := CompTextDesc;
  end;
  if aSg.ColsDataType[aSg.SortCol] = dtParams then
    aCol := 0
  else
    aCol := aSg.SortCol;
  sgSort(aSg, aCol, aCompare);
end;

procedure TTcp.SortPrepare(aSg: TStringGrid; ACol: Integer; ManualSort: Boolean = False);
var
  ScrollTop: Boolean;
begin
  if (aSg.SortCol = ACol) then
    case aSg.SortType of
      SORT_ASC: aSg.SortType := SORT_DESC;
      SORT_DESC: aSg.SortType := SORT_ASC;
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
  FindDialog.CloseDialog;
  if NodesListStage = 1 then
    SaveNodesList(cbxNodesListType.ItemIndex);
end;

procedure TTcp.meMyFamilyChange(Sender: TObject);
begin
  lbTotalMyFamily.Caption := TransStr('203') + ': ' + IntToStr(meMyFamily.Lines.Count);
  EnableOptionButtons;
end;

procedure TTcp.MaxMemInQueuesEnable(State: Boolean);
begin
  edMaxMemInQueues.Enabled := State;
  udMaxMemInQueues.Enabled := State;
  lbMaxMemInQueues.Enabled := State;
  lbSizeMb.Enabled := State;
end;

procedure TTcp.cbUseMaxMemInQueuesClick(Sender: TObject);
begin
  if not cbUseMaxMemInQueues.Focused then
    Exit;
  MaxMemInQueuesEnable(cbUseMaxMemInQueues.Checked);
  EnableOptionButtons;
end;

procedure TTcp.NumCPUsEnable(State: Boolean);
begin
  edNumCPUs.Enabled := State;
  udNumCPUs.Enabled := State;
  lbNumCPUs.Enabled := State;
end;

procedure TTcp.cbNoDesktopBordersClick(Sender: TObject);
begin
  cbNoDesktopBordersOnlyEnlarged.Enabled := cbNoDesktopBorders.Checked;
  EnableOptionButtons;
end;

procedure TTcp.cbUseNumCPUsClick(Sender: TObject);
begin
  if not cbUseNumCPUs.Focused then
    Exit;
  NumCPUsEnable(cbUseNumCPUs.Checked);
  EnableOptionButtons;
end;

procedure TTcp.RelayBandwidthEnable(State: Boolean);
begin
  edRelayBandwidthRate.Enabled := State;
  edRelayBandwidthBurst.Enabled := State;
  edMaxAdvertisedBandwidth.Enabled := State;
  udRelayBandwidthRate.Enabled := State;
  udRelayBandwidthBurst.Enabled := State;
  udMaxAdvertisedBandwidth.Enabled := State;
  lbRelayBandwidthRate.Enabled := State;
  lbRelayBandwidthBurst.Enabled := State;
  lbMaxAdvertisedBandwidth.Enabled := State;
  lbSpeed1.Enabled := State;
  lbSpeed2.Enabled := State;
  lbSpeed4.Enabled := State;
end;

procedure TTcp.cbUseReachableAddressesClick(Sender: TObject);
var
  State: Boolean;
begin
  State := cbUseReachableAddresses.Checked;
  edReachableAddresses.Enabled := State;
  lbReachableAddresses.Enabled := State;
  EnableOptionButtons;
  if cbUseReachableAddresses.Focused then
    CountTotalBridges;
end;

procedure TTcp.cbUseRelayBandwidthClick(Sender: TObject);
begin
  RelayBandwidthEnable(cbUseRelayBandwidth.Checked);
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

procedure TTcp.cbxRoutersCountryDropDown(Sender: TObject);
begin
  ComboBoxAutoWidth(cbxRoutersCountry);
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
begin
  LastPreferredBridgeHash := '';
  Result := TryParseBridge(Trim(edPreferredBridge.Text), Bridge);
  if Result then
  begin
    Result := RoutersDic.ContainsKey(Bridge.Hash);
    if Result then
      LastPreferredBridgeHash := Bridge.Hash
    else
    begin
      LastPreferredBridgeHash := GetRouterBySocket(FormatHost(Bridge.Ip) + ':' + IntToStr(Bridge.Port));
      Result := LastPreferredBridgeHash <> '';
    end;
  end;

end;

procedure TTcp.BridgesCheckControls;
var
  State, BuiltinState, LimitState, PreferredState, UnsuitableState: Boolean;
begin
  if cbUseBridges.HelpContext = 1 then
    Exit;
  State := cbUseBridges.Checked;
  PreferredState := State and cbUsePreferredBridge.Checked;
  LimitState := State and cbUseBridgesLimit.Checked;
  UnsuitableState := State and cbExcludeUnsuitableBridges.Checked;
  BuiltinState := State and (cbxBridgesType.ItemIndex = BRIDGES_TYPE_BUILTIN) and (cbxBridgesList.Items.Count > 0);

  edBridgesLimit.Enabled := LimitState;
  edMaxDirFails.Enabled := UnsuitableState;
  edBridgesCheckDelay.Enabled := UnsuitableState;
  edPreferredBridge.Enabled := PreferredState;
  cbxBridgesType.Enabled := State;
  cbxBridgesList.Enabled := BuiltinState;
  cbxBridgesPriority.Enabled := LimitState;
  cbExcludeUnsuitableBridges.Enabled := State;
  cbUseBridgesLimit.Enabled := State;
  cbCacheNewBridges.Enabled := LimitState and cbExcludeUnsuitableBridges.Checked;
  cbUsePreferredBridge.Enabled := State;
  udBridgesLimit.Enabled := LimitState;
  udMaxDirFails.Enabled := UnsuitableState;
  udBridgesCheckDelay.Enabled := UnsuitableState;
  meBridges.Enabled := BuiltinState or (State and (cbxBridgesType.ItemIndex = BRIDGES_TYPE_USER));
  meBridges.ReadOnly := cbxBridgesType.ItemIndex = BRIDGES_TYPE_BUILTIN;
  btnFindPreferredBridge.Enabled := PreferredState and PreferredBridgeFound;
  lbBridgesType.Enabled := State;
  lbBridgesList.Enabled := BuiltinState;
  lbTotalBridges.Enabled := State;
  lbBridgesLimit.Enabled := LimitState;
  lbBridgesPriority.Enabled := LimitState;
  lbMaxDirFails.Enabled := UnsuitableState;
  lbBridgesCheckDelay.Enabled := UnsuitableState;
  lbCount4.Enabled := UnsuitableState;
  lbSeconds5.Enabled := UnsuitableState;
  lbPreferredBridge.Enabled := PreferredState;
  if not PreferredState then
    LastPreferredBridgeHash := '';
end;

procedure TTcp.cbUseBridgesClick(Sender: TObject);
begin
  if not cbUseBridges.Focused then
    Exit;
  BridgesUpdated := True;
  BridgesCheckControls;
  EnableOptionButtons;
end;

procedure TTcp.cbUseBridgesExit(Sender: TObject);
begin
  UpdateRoutersAfterBridgesUpdate;
end;

procedure TTcp.cbUseBridgesLimitClick(Sender: TObject);
begin
  if not cbUseBridgesLimit.Focused then
    Exit;
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

procedure TTcp.cbUseDirPortClick(Sender: TObject);
begin
  UseDirPortEnable(cbUseDirPort.Checked);
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

procedure TTcp.cbUseMyFamilyClick(Sender: TObject);
begin
  if FirstLoad then
    Exit;
  MyFamilyEnable(cbUseMyFamily.Checked);
  if cbUseMyFamily.Checked then
  begin
    if meMyFamily.CanFocus then
      meMyFamily.SetFocus;
  end;
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
  if not cbUsePreferredBridge.Focused then
    Exit;
  BridgesUpdated := True;
  BridgesCheckControls;
  EnableOptionButtons;
end;

procedure TTcp.cbUsePreferredBridgeExit(Sender: TObject);
begin
  UpdateRoutersAfterBridgesUpdate;
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

procedure TTcp.cbUseUPnPClick(Sender: TObject);
begin
  imUPnPTest.Visible := cbUseUPnP.Checked;
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

procedure TTcp.cbListenIPv6Click(Sender: TObject);
begin
  if cbListenIPv6.Checked and (cbxServerMode.ItemIndex = SERVER_MODE_EXIT) then
    cbIPv6Exit.Enabled := True
  else
    cbIPv6Exit.Enabled := False;
  EnableOptionButtons;
end;

procedure TTcp.cbxAuthMetodChange(Sender: TObject);
begin
  CheckAuthMetodContols;
  EnableOptionButtons;
end;

procedure TTcp.cbxAutoScanTypeChange(Sender: TObject);
begin
  CheckScannerControls;
  EnableOptionButtons;
end;

procedure TTcp.cbxAutoScanTypeDropDown(Sender: TObject);
begin
  ComboBoxAutoWidth(cbxAutoScanType);
end;

procedure TTcp.cbxAutoSelPriorityChange(Sender: TObject);
begin
  CheckAutoSelControls;
  EnableOptionButtons;
end;

procedure TTCP.CheckAutoSelControls;
begin
  cbAutoSelNodesWithPingOnly.Enabled := cbxAutoSelPriority.ItemIndex in [1, 3];
end;

procedure TTcp.TransportPortEnable(State: Boolean);
begin
  edTransportPort.Enabled := State;
  udTransportPort.Enabled := State;
  lbTransportPort.Enabled := State;
end;

procedure TTcp.cbxBridgesListChange(Sender: TObject);
begin
  UpdateBridgesControls(False);
end;

procedure TTcp.cbxBridgesListCloseUp(Sender: TObject);
begin
  if meBridges.CanFocus then
    meBridges.SetFocus;
end;

procedure TTcp.cbxBridgesListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) and meBridges.CanFocus then
    meBridges.SetFocus;
end;

procedure TTcp.cbxBridgeTypeChange(Sender: TObject);
begin
  TransportPortEnable(cbxBridgeType.ItemIndex > 0);
  EnableOptionButtons;
end;

procedure TTcp.UpdateBridgesControls(UpdateList: Boolean = True; UpdateUserBridges: Boolean = True);
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
      if UpdateUserBridges and FileExists(UserConfigFile) then
      begin
        ini := TMemIniFile.Create(UserConfigFile, TEncoding.UTF8);
        try
          LoadUserBridges(ini);
        finally
          ini.Free;
        end;
      end;
    end;
  end;
  BridgesCheckControls;
  EnableOptionButtons;
end;

procedure TTcp.cbxBridgesTypeChange(Sender: TObject);
begin
  UpdateBridgesControls;
end;

procedure TTcp.cbxBridgesTypeCloseUp(Sender: TObject);
begin
  if meBridges.CanFocus then
    meBridges.SetFocus;
end;

procedure TTcp.cbxBridgesTypeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) and meBridges.CanFocus then
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
      lbComponent.Caption := TransStr(lbComponent.Hint) + ': ' + IntToStr(Counters[j])
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
        RangesDic.Remove(NodeItem.Key);
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
      lbComponent.Caption := TransStr(lbComponent.Hint) + ': ' + IntToStr(Counters[j])
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
  NodesList := MemoToLine(meNodesList, ltNode, True);
  GetNodes(NodesList, TNodeType(FavoritesID), True);
  CalculateTotalNodes;
  if NodesListStage > 0 then
    NodesListStage := 0;
  ShowRouters;
  FilterUpdated := True;
  UpdateOptionsAfterRoutersUpdate;
  if FavoritesID = EXCLUDE_ID then
    CountTotalBridges;
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

  LineToMemo(RemoveBrackets(NodesStr), meNodesList, ltNode, True);
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
  State: Boolean;
begin
  if cbxServerMode.HelpContext = 1 then
    Exit;
  State := cbxServerMode.ItemIndex <> SERVER_MODE_NONE;
  edNickname.Enabled := State;
  edContactInfo.Enabled := State;
  edORPort.Enabled := State;
  udOrPort.Enabled := State;
  cbUseRelayBandwidth.Enabled := State;
  cbUseMaxMemInQueues.Enabled := State;
  cbUseNumCPUs.Enabled := State;
  cbUseUPnP.Enabled := State;
  cbPublishServerDescriptor.Enabled := State;
  cbDirReqStatistics.Enabled := State;
  cbHiddenServiceStatistics.Enabled := State;
  cbAssumeReachable.Enabled := State;
  cbListenIPv6.Enabled := State;
  cbUseAddress.Enabled := State;
  if State then
  begin
    if cbUseRelayBandwidth.Checked then
      RelayBandwidthEnable(True);
    if cbUseMaxMemInQueues.Checked then
      MaxMemInQueuesEnable(True);
    if cbUseNumCPUs.Checked then
      NumCPUsEnable(True);
    if cbUseAddress.Checked then
      ServerAddressEnable(True);
    if cbxServerMode.ItemIndex <> SERVER_MODE_BRIDGE then
    begin
      MyFamilyEnable(cbUseMyFamily.Checked);
      UseDirPortEnable(cbUseDirPort.Checked);
      cbUseMyFamily.Enabled := True;
    end
    else
    begin
      cbUseMyFamily.Enabled := False;
      MyFamilyEnable(False);
    end;
    imUPnPTest.Visible := True;
    lbNickname.Enabled := True;
    lbContactInfo.Enabled := True;
    lbPorts.Enabled := True;
    lbORPort.Enabled := True;
  end
  else
  begin
    cbUseDirPort.Enabled := False;
    cbUseMyFamily.Enabled := False;
    TransportPortEnable(False);
    UseDirPortEnable(False);
    RelayBandwidthEnable(False);
    MaxMemInQueuesEnable(False);
    NumCPUsEnable(False);
    MyFamilyEnable(False);
    ServerAddressEnable(False);
    meExitPolicy.Enabled := False;
    imUPnPTest.Visible := False;
    lbNickname.Enabled := False;
    lbContactInfo.Enabled := False;
    lbPorts.Enabled := False;
    lbORPort.Enabled := False;
    lbTotalMyFamily.Enabled := False;
  end;

  if cbxServerMode.ItemIndex = SERVER_MODE_EXIT then
  begin
    if cbListenIPv6.Checked then
      cbIPv6Exit.Enabled := True;
    cbxExitPolicyType.Enabled := True;
    meExitPolicy.enabled := cbxExitPolicyType.ItemIndex = 2;
    lbExitPolicy.Enabled := True;
  end
  else
  begin
    cbIPv6Exit.Enabled := False;
    cbxExitPolicyType.Enabled := False;
    meExitPolicy.enabled := False;
    lbExitPolicy.Enabled := False;
  end;

  if cbxServerMode.ItemIndex = SERVER_MODE_BRIDGE then
  begin
    cbUseDirPort.Checked := False;
    cbUseDirPort.Enabled := False;
    cbDirCache.Enabled := False;
    cbDirCache.Checked := True;
    cbxBridgeType.Enabled := True;
    cbxBridgeDistribution.Enabled := True;
    cbUseMyFamily.Checked := False;
    TransportPortEnable(cbxBridgeType.ItemIndex > 0);
    lbBridgeType.Enabled := True;
    lbBridgeDistribution.Enabled := True;
  end
  else
  begin
    cbxBridgeType.Enabled := False;
    cbxBridgeDistribution.Enabled := False;
    if cbxServerMode.ItemIndex > SERVER_MODE_NONE then
      cbUseDirPort.Enabled := True;
    TransportPortEnable(False);
    lbBridgeType.Enabled := False;
    lbBridgeDistribution.Enabled := False;
  end;
end;

procedure TTcp.cbxServerModeChange(Sender: TObject);
begin
  CheckServerControls;
  EnableOptionButtons
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
    ChangeTransportTable(TEdit(Sender).Tag)
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

procedure TTcp.udHsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ChangeHsTable(TUpDown(Sender).Tag);
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

procedure TTcp.MemoExit(Sender: TObject);
begin
  FindDialog.CloseDialog;
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
  if (pcOptions.TabIndex = 2) and (ssDouble in Shift) and (Button = mbLeft) then
    SetGridLastCell(sgFilter, True, True, True);
end;

procedure TTcp.sbShowRoutersClick(Sender: TObject);
begin
  LastPlace := LP_ROUTERS;
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

procedure TTcp.sbDecreaseFormClick(Sender: TObject);
begin
  CheckOptionsChanged;
  DecreaseFormSize;
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
  if AlwaysUpdate or (miAutoScroll.Checked and (meLog.Tag = 0)) then
    meLog.Perform(WM_VSCROLL, SB_BOTTOM, 0);
end;

procedure TTcp.sbShowLogClick(Sender: TObject);
begin
  LastPlace := LP_LOG;
  CheckLogAutoScroll;
  IncreaseFormSize;
  ResetFocus;
end;

procedure TTcp.SpinChanging(Sender: TObject; var AllowChange: Boolean);
begin
  EnableOptionButtons;
end;

procedure TTcp.edPreferredBridgeChange(Sender: TObject);
begin
  if CtrlKeyPressed('A') then
    Exit;
  if not TEdit(Sender).Focused then
    Exit;
  btnFindPreferredBridge.Enabled := PreferredBridgeFound;
  BridgesUpdated := True;
  EnableOptionButtons;
end;

procedure TTcp.edPreferredBridgeExit(Sender: TObject);
begin
  UpdateRoutersAfterBridgesUpdate;
end;

procedure TTcp.edReachableAddressesChange(Sender: TObject);
begin
  if TEdit(Sender).Focused then
  begin
    if CtrlKeyPressed('A') then
      Exit;
    EnableOptionButtons;
    CountTotalBridges;
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
  ShowRouters;
  SaveRoutersFilterdata;
end;

procedure TTcp.edRoutersQueryChange(Sender: TObject);
var
  Query: string;
  Data: Integer;
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
    if Data <> 0 then
    begin
      if Data = 1 then
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

procedure TTcp.miShowFlagsHintClick(Sender: TObject);
begin
  SetConfigBoolean('Routers', 'ShowFlagsHint', miShowFlagsHint.Checked);
end;

procedure TTcp.CheckStreamsControls;
begin
  lbDLCirc.Visible := miShowCircuitsTraffic.Checked;
  lbULCirc.Visible := miShowCircuitsTraffic.Checked;
  sgStreamsInfo.Visible := miShowStreamsInfo.Checked;
  if miShowStreamsInfo.Checked then
    sgStreams.Height := Round(176 * Scale)
  else
    sgStreams.Height := Round(296 * Scale);

  if miShowStreamsTraffic.Checked then
  begin
    sgStreams.ColWidths[STREAMS_BYTES_READ] := Round(60 * Scale);
    sgStreams.ColWidths[STREAMS_BYTES_WRITTEN] := Round(60 * Scale);
    GridScrollCheck(sgStreams, STREAMS_TARGET, 323);
    sgStreamsInfo.ColWidths[STREAMS_INFO_SOURCE_ADDR] := Round(129 * Scale);
    sgStreamsInfo.ColWidths[STREAMS_INFO_DEST_ADDR] := Round(129 * Scale);
    sgStreamsInfo.ColWidths[STREAMS_INFO_BYTES_READ] := Round(60 * Scale);
    sgStreamsInfo.ColWidths[STREAMS_INFO_BYTES_WRITTEN] := Round(60 * Scale);
    GridScrollCheck(sgStreamsInfo, STREAMS_INFO_PURPOSE, 119);
  end
  else
  begin
    sgStreams.ColWidths[STREAMS_BYTES_READ] := -1;
    sgStreams.ColWidths[STREAMS_BYTES_WRITTEN] := -1;
    GridScrollCheck(sgStreams, STREAMS_TARGET, 446);
    sgStreamsInfo.ColWidths[STREAMS_INFO_SOURCE_ADDR] := Round(169 * Scale);
    sgStreamsInfo.ColWidths[STREAMS_INFO_DEST_ADDR] := Round(169 * Scale);
    sgStreamsInfo.ColWidths[STREAMS_INFO_BYTES_READ] := -1;
    sgStreamsInfo.ColWidths[STREAMS_INFO_BYTES_WRITTEN] := -1;
    GridScrollCheck(sgStreamsInfo, STREAMS_INFO_PURPOSE, 163);
  end;
end;

procedure TTcp.ShowTrafficSelect(Sender: TObject);
begin
  CheckStreamsControls;
  if ConnectState = 2 then
    SendCommand('SETEVENTS ' + GetControlEvents);
  case TMenuItem(Sender).Tag of
    1: SetConfigBoolean('Circuits', 'ShowCircuitsTraffic', miShowCircuitsTraffic.Checked);
    2: SetConfigBoolean('Circuits', 'ShowStreamsTraffic', miShowStreamsTraffic.Checked);
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
      FILTER_BY_ALIVE: IntToMenu(miRtFilters, 3);
      FILTER_BY_TOTAL: IntToMenu(miRtFilters, 3);
      FILTER_BY_GUARD: IntToMenu(miRtFilters, 3);
      FILTER_BY_EXIT:  IntToMenu(miRtFilters, 3);
      FILTER_BY_QUERY: IntToMenu(miRtFilters, 8);
      ENTRY_ID..FAVORITES_ID: IntToMenu(miRtFilters, 0, True);
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
  end;
  if CustomFilterID in [ENTRY_ID..FAVORITES_ID] then
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
  if RoutersCustomFilter in [FILTER_BY_ALIVE..FILTER_BY_QUERY] then
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
          if not (RoutersCustomFilter in [0, FILTER_BY_ALIVE..FAVORITES_ID]) then
            RoutersCustomFilter := 0;
        end;
      end;
      6:
      begin
        LastRoutersCustomFilter := StrToIntDef(ParseStr[i], 0);
        if not (LastRoutersCustomFilter in [0, FILTER_BY_ALIVE..FAVORITES_ID]) then
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

procedure TTcp.miSelectExitCircuitWhetItChangesClick(Sender: TObject);
begin
  ShowCircuits;
  SetConfigBoolean('Circuits', 'SelectExitCircuitWhetItChanges', miSelectExitCircuitWhetItChanges.Checked);
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
      if CurrentScanPurpose = spUserBridges then
        ShowMsg(TransStr('400'))
      else
        StartTor;
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

procedure TTcp.miResetScannerScheduleClick(Sender: TObject);
var
  ini: TMemIniFile;
begin
  if not CheckCacheOpConfirmation(TMenuItem(Sender).Caption) then
    Exit;
  LastFullScanDate := 0;
  LastPartialScanDate := 0;
  LastPartialScansCounts := udPartialScansCounts.Position;
  ini := TMemIniFile.Create(UserConfigFile, TEncoding.UTF8);
  try
    SetSettings('Scanner', 'LastFullScanDate', LastFullScanDate, ini);
    SetSettings('Scanner', 'LastPartialScanDate', LastPartialScanDate, ini);
    SetSettings('Scanner', 'LastPartialScansCounts', LastPartialScansCounts, ini);
  finally
    UpdateConfigFile(ini);
  end;
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
  if ValidAddress(IpAddr) <> 0 then
  begin
    sbShowOptions.Click;
    pcOptions.TabIndex := tsFilter.TabIndex;
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
  edRendPostPeriod.Enabled := State;
  udHsNumIntroductionPoints.Enabled := State;
  udRendPostPeriod.Enabled := State;
  cbxHsVersion.Enabled := State;
  cbxHsState.Enabled := State;
  cbHsMaxStreams.Enabled := State;
  HsMaxStreamsEnable(State);
  HsPortsEnable(State);
  lbHsName.Enabled := State;
  lbHsVersion.Enabled := State;
  lbHsNumIntroductionPoints.Enabled := State;
  lbRendPostPeriod.Enabled := State;
  lbMinutes.Enabled := State;
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
var
  SubMenu: TMenuItem;
  i: Integer;
begin
  ParentMenu.Clear;
  if ConnectState = 1 then
    Exit;
  for i := ENTRY_ID to EXCLUDE_ID do
  begin
    SubMenu := TMenuItem.Create(self);
    SubMenu.Tag := i;
    case i of
      ENTRY_ID:
      begin
        SubMenu.Caption := TransStr('288'); SubMenu.ImageIndex := 40;
      end;
      MIDDLE_ID:
      begin
        SubMenu.Caption := TransStr('289'); SubMenu.ImageIndex := 41;
      end;
      EXIT_ID:
      begin
        SubMenu.Caption := TransStr('290'); SubMenu.ImageIndex := 42;
      end;
      EXCLUDE_ID:
      begin
        SubMenu.Caption := TransStr('287'); SubMenu.ImageIndex := 43;
      end;
    end;
    InsertNodesListMenu(SubMenu, NodeID, i, AutoSave);
    ParentMenu.Add(SubMenu);
  end;

  for i := 1 to 4 do
  begin
    SubMenu := TMenuItem.Create(self);
    SubMenu.Tag := i;
    case i of
      1,3: SubMenu.Caption := '-';
      2:
      begin
        SubMenu.Caption := TransStr('359');
        SubMenu.ImageIndex := 17;
        InsertNodesToDeleteMenu(SubMenu, NodeID, AutoSave);
      end;
      4:
      begin
        SubMenu.Caption := TransStr('360');
        SubMenu.ImageIndex := 50;
        SubMenu.OnClick := RoutersAutoSelectClick;
        Submenu.Enabled := (RoutersDic.Count > 0) and (InfoStage = 0) and
          (miAutoSelEntryEnabled.Checked or miAutoSelMiddleEnabled.Checked or miAutoSelExitEnabled.Checked) and
          not (Assigned(Consensus) or Assigned(Descriptors) or tmScanner.Enabled);
        Submenu.Visible := not AutoSave;
      end;
    end;
    ParentMenu.Add(SubMenu);
  end;
end;

procedure TTcp.InsertNodesToDeleteMenu(ParentMenu: TmenuItem; NodeID: string; AutoSave: Boolean = True);
var
  Router: TRouterInfo;
  ls: TStringList;
  i: Integer;
  ItemID: TListType;
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
      RangesStr := FindInRanges(Router.IPv4);
      if RangesStr <> '' then
      begin
        ParseStr := Explode(',', RangesStr);
        for i := 0 to Length(ParseStr) - 1 do
          ls.Add(ParseStr[i]);
      end;
      SortNodesList(ls, True);
      ls.Add(AnsiUpperCase(CountryCode) + ' (' + TransStr(CountryCode) + ')');

      DeleteList := '';
      for i := 0 to ls.Count - 1 do
      begin
        NodeStr := SeparateLeft(ls[i], ' ');
        ItemID := GetNodeType(NodeStr);
        if ItemID = ltCode then
          NodeStr := AnsiLowerCase(NodeStr);

        if NodesDic.ContainsKey(NodeStr) then
        begin
          if NodesDic.Items[NodeStr] <> [] then
          begin
            SubMenu := TMenuItem.Create(self);
            SubMenu.Tag := Integer(AutoSave);
            case ItemID of
              ltHash: SubMenu.ImageIndex := 23;
              ltIp: SubMenu.ImageIndex := 33;
              ltCidr: SubMenu.ImageIndex := 48;
              ltCode: SubMenu.ImageIndex := 57;
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

procedure TTcp.InsertNodesListMenu(ParentMenu: TmenuItem; NodeID: string; NodeTypeID: Integer; AutoSave: Boolean = True);
var
  SubMenu: TMenuItem;
  ls, lr: TStringList;
  i: Integer;
  CountryID: Byte;
  Router: TRouterInfo;
  RangesStr, NodeStr: string;
  ParseStr: ArrOfStr;
  ItemID: TListType;
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
      RangesStr := FindInRanges(Router.IPv4);
      if RangesStr <> '' then
      begin
        lr := TStringList.Create;
        try
          ls.Add('-');
          ParseStr := Explode(',', RangesStr);
          for i := 0 to Length(ParseStr) - 1 do
            if ls.IndexOf(ParseStr[i]) < 0 then
              lr.Add(ParseStr[i]);
          SortNodesList(lr, True);
          ls.AddStrings(lr);
        finally
          lr.Free;
        end;
      end;
      ls.Add('-');
      ls.Add(AnsiUpperCase(CountryCodes[CountryID]) + ' (' + TransStr(CountryCodes[CountryID]) + ')');
    end
    else
      FindRouter := False;

    for i := 0 to ls.Count - 1 do
    begin
      NodeStr := SeparateLeft(ls[i], ' ');
      ItemID := GetNodeType(NodeStr);
      if ItemID = ltCode then
        NodeStr := AnsiLowerCase(NodeStr);

      SubMenu := TMenuItem.Create(self);
      SubMenu.Hint := BoolToStr(AutoSave);
      SubMenu.Tag := NodeTypeID;
      SubMenu.Caption := ls[i];

      if NodesDic.ContainsKey(NodeStr) then
      begin
        if TNodeType(NodeTypeID) in NodesDic.Items[NodeStr] then
          SubMenu.Enabled := False;
      end;

      if SubMenu.Enabled and (ItemID in [ltHash]) and FindRouter then
      begin
        if (not CheckRouterFlags(NodeTypeID, Router) or (NodeStr = LastPreferredBridgeHash)) and (NodeTypeID <> EXCLUDE_ID)  then
          SubMenu.Visible := False;
      end;

      if ItemID <> ltNoCheck then
      begin
        case ItemID of
          ltHash: SubMenu.ImageIndex := 23;
          ltIp: SubMenu.ImageIndex := 33;
          ltCidr: SubMenu.ImageIndex := 48;
          ltCode: SubMenu.ImageIndex := 57;
        end;
        if SubMenu.Enabled then
          SubMenu.OnClick := Tcp.AddToNodesListClick;
      end;
      ParentMenu.Add(SubMenu);
    end;
  finally
    ls.Free;
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
    if (lbFavoritesTotal.Tag = 0) and (cbxFilterMode.ItemIndex <> 2) then
      cbxFilterMode.ItemIndex := 2;
  end;
end;

function TTCP.CheckRouterFlags(NodeTypeID: Integer; RouterInfo: TRouterInfo): Boolean;
begin
  Result := False;
  if (rfBridge in RouterInfo.Flags) and not (rfRelay in RouterInfo.Flags) then
    Exit;
  if (NodeTypeID = ENTRY_ID) and not (rfGuard in RouterInfo.Flags) then
    Exit;
  if (NodeTypeID = EXIT_ID) and not (rfExit in RouterInfo.Flags) then
    Exit;
  Result := True;
end;

procedure TTcp.CheckPrefferedBridgeExclude(RouterID: string; IpStr: string = ''; CodeStr: string = '');
var
  RouterInfo: TRouterInfo;

  procedure UpdateControls;
  begin
    cbUsePreferredBridge.Checked := False;
    BridgesCheckControls;
  end;

begin
  if cbUsePreferredBridge.Checked then
  begin
    if RoutersDic.TryGetValue(RouterID, RouterInfo) then
    begin
      if RouterInNodesList(RouterID, RouterInfo.IPv4, ntExclude) then
        UpdateControls;
    end
    else
    begin
      if (IpStr <> '') or (CodeStr <> '') then
      begin
        if RouterInNodesList(RouterID, IpStr, ntExclude, False, CodeStr) then
          UpdateControls;
      end;
    end;
  end;
end;

procedure TTCP.AddToNodesListClick(Sender: TObject);
var
  NodeStr, NodeCap, ConvertMsg: string;
  ConvertNodes, CtrlPressed, EnableConvertNodes: Boolean;
  NodeTypeID: Integer;
  FNodeTypes: TNodeTypes;
  FilterInfo: TFilterInfo;
  ItemID: TListType;
  Router: TPair<string, TRouterInfo>;
  Range: TIPv4Range;
  PreferredBridge: TBridge;

  procedure AddRouterToNodesList(RouterID: string; RouterInfo: TRouterInfo);
  begin
    if NodeTypeID <> EXCLUDE_ID then
    begin
      if miAvoidAddingIncorrectNodes.Checked then
      begin
        if not CheckRouterFlags(NodeTypeID, RouterInfo) then
          Exit;
        if RouterInNodesList(RouterID, RouterInfo.IPv4, ntExclude) then
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
  ItemID := GetNodeType(NodeStr);
  case ItemID of
    ltCode: NodeStr := AnsiLowerCase(NodeStr);
    ltCidr: Range := CidrToRange(NodeStr);
  end;
  ConvertNodes := miEnableConvertNodesOnAddToNodesList.Checked and
      (((ItemID = ltIp) and miConvertIpNodes.Checked) or
       ((ItemID = ltCidr) and miConvertCidrNodes.Checked) or
       ((ItemID = ltCode) and miConvertCountryNodes.Checked)) and
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
        case ItemID of
          ltIp:
          begin
            if Router.Value.IPv4 = NodeStr then
              AddRouterToNodesList(Router.Key, Router.Value);
          end;
          ltCidr:
          begin
            if InRange(IpToInt(Router.Value.IPv4), Range.IpStart, Range.IpEnd) then
              AddRouterToNodesList(Router.Key, Router.Value);
          end;
          ltCode:
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

      if ItemID = ltCidr then
        RangesDic.AddOrSetValue(NodeStr, CidrToRange(NodeStr));
    end;
    if TryParseBridge(edPreferredBridge.Text, PreferredBridge) then
      CheckPrefferedBridgeExclude(PreferredBridge.Hash);
    CheckNodesListState(NodeTypeID);
    CalculateTotalNodes;
    ShowRouters;
    RoutersUpdated := True;
    FilterUpdated := True;
    UpdateOptionsAfterRoutersUpdate;

    if StrToBool(TMenuItem(Sender).Hint) then
      ApplyOptions
    else
    begin
      EnableOptionButtons;
      if NodeTypeID = EXCLUDE_ID then
        CountTotalBridges;
    end;
  end;
end;

procedure TTcp.RemoveFromNodeListClick(Sender: TObject);
var
  ConvertNodes: Boolean;
  NodesList, NodeStr, ConvertMsg: string;
  ParseStr: ArrOfStr;
  ItemID: TListType;
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
      ItemID := GetNodeType(NodeStr);
      if ItemID = ltCode then
        NodeStr := AnsiLowerCase(NodeStr);

      NodesDic.Remove(NodeStr);
      if ItemID = ltCidr then
        RangesDic.Remove(NodeStr);
    end;
    if ConvertNodes then
      RemoveFromNodesListWithConvert(Nodes, ntNone);

    CalculateTotalNodes;
    ShowRouters;
    RoutersUpdated := True;
    FilterUpdated := True;
    UpdateOptionsAfterRoutersUpdate;

    if Boolean(TMenuItem(Sender).Tag) then
      ApplyOptions
    else
    begin
      EnableOptionButtons;
      CountTotalBridges;
    end;
  end;
end;

function TTcp.PrepareNodesToRemove(Data: string; NodeType: TNodeType; out Nodes: ArrOfNodes): Boolean;
var
  ParseStr: ArrOfStr;
  i, j: Integer;
  NodeStr: string;
  NodeID: TListType;
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
    NodeID := GetNodeType(NodeStr);

    ConvertNodes := miEnableConvertNodesOnRemoveFromNodesList.Checked and
      (((NodeID = ltIp) and miConvertIpNodes.Checked) or
       ((NodeID = ltCidr) and miConvertCidrNodes.Checked) or
       ((NodeID = ltCode) and miConvertCountryNodes.Checked));

    if (ConvertNodes and not CtrlPressed) or
       (not ConvertNodes and CtrlPressed and (NodeID <> ltHash)) then
    begin
      SetLength(Nodes, j + 1);
      case NodeID of
        ltCode: NodeStr := AnsiLowerCase(NodeStr);
        ltCidr: Nodes[j].RangeData := CidrToRange(NodeStr);
      end;
      Nodes[j].NodeStr := NodeStr;
      Nodes[j].NodeID := NodeID;
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
      case Nodes[i].NodeID of
        ltIp:
        begin
          if Router.Value.IPv4 = Nodes[i].NodeStr then
            RemoveRouterFromNodesList(Router.Key);
        end;
        ltCidr:
        begin
          if InRange(IpToInt(Router.Value.IPv4), Nodes[i].RangeData.IpStart, Nodes[i].RangeData.IpEnd) then
            RemoveRouterFromNodesList(Router.Key);
        end;
        ltCode:
        begin
          if CountryCodes[GetCountryValue(Router.Value.IPv4)] = Nodes[i].NodeStr then
            RemoveRouterFromNodesList(Router.Key);
        end;
      end;
    end;
  end;

end;

procedure TTcp.RoutersAutoSelectClick(Sender: TObject);
var
  Router: Tpair<string, TRouterInfo>;
  cdWeight, cdPing, CheckEntryPorts: Boolean;
  GeoIpInfo: TGeoIpInfo;
  NodeItem: TPair<string, TNodeTypes>;
  Flags: TRouterFlags;
  PriorityType, PingData, PingSum, PingCount, PingAvg: Integer;
  FilterNodeTypes, AutoSelNodeTypes: TNodeTypes;
  FilterInfo: TFilterInfo;
  CountryID: Byte;
  EntryStr, MiddleStr, ExitStr, CountryCode, PortsData: string;
  EntryNodes, MiddleNodes, ExitNodes: TStringList;
  UniqueList: TDictionary<string, Byte>;
  SortCompare: TStringListSortCompare;

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

  procedure AddRouterToList(ls: TStringList; NodeType: TNodeType);
  begin
    if (NodeType in FilterNodeTypes) and (NodeType in AutoSelNodeTypes) then
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

begin
  if (RoutersDic.Count = 0) or (InfoStage > 0) or Assigned(Consensus) or Assigned(Descriptors) or tmScanner.Enabled then
    Exit;

  CheckEntryPorts := ReachablePortsExists;
  EntryNodes := TStringList.Create;
  MiddleNodes := TStringList.Create;
  ExitNodes := TStringList.Create;
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
    if miAutoSelEntryEnabled.Checked then
      Include(AutoSelNodeTypes, ntEntry);
    if miAutoSelMiddleEnabled.Checked then
      Include(AutoSelNodeTypes, ntMiddle);
    if miAutoSelExitEnabled.Checked then
      Include(AutoSelNodeTypes, ntExit);

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

      if cdWeight and cdPing and (rfRelay in Flags) and not RouterInNodesList(Router.Key, Router.Value.IPv4, ntExclude) then
      begin
        if cbAutoSelFilterCountriesOnly.Checked and (PingNodesCount > 0) then
        begin
          if FilterDic.TryGetValue(CountryCode, FilterInfo) then
            FilterNodeTypes := FilterInfo.Data;
        end;

        if (rfStable in Flags) or not cbAutoSelStableOnly.Checked then
        begin
          if (rfGuard in Flags) then
          begin
            if (Router.Value.Params and ROUTER_ALIVE <> 0) or (AliveNodesCount = 0) then
            begin
              if CheckEntryPorts then
              begin
                if PortsDic.ContainsKey(Router.Value.OrPort) then
                  AddRouterToList(EntryNodes, ntEntry);
              end
              else
                AddRouterToList(EntryNodes, ntEntry);
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
      (miAutoSelEntryEnabled.Checked and miAutoSelMiddleEnabled.Checked and miAutoSelExitEnabled.Checked) then
    begin
      for NodeItem in NodesDic do
      begin
        if ValidHash(NodeItem.Key) then
        begin
          if not miAutoSelEntryEnabled.Checked and (ntEntry in NodeItem.Value) then
            UniqueList.AddOrSetValue(NodeItem.Key, 0);
          if not miAutoSelMiddleEnabled.Checked and (ntMiddle in NodeItem.Value) then
            UniqueList.AddOrSetValue(NodeItem.Key, 0);
          if not miAutoSelExitEnabled.Checked and (ntExit in NodeItem.Value) then
            UniqueList.AddOrSetValue(NodeItem.Key, 0);
        end;
      end;
    end;

    ClearRouters(AutoSelNodeTypes);

    if miAutoSelEntryEnabled.Checked then
    begin
      EntryNodes.CustomSort(SortCompare);
      EntryStr := ListToStr(EntryNodes, udAutoSelEntryCount.Position);
      GetNodes(EntryStr, ntEntry, True);
    end;

    if miAutoSelExitEnabled.Checked then
    begin
      ExitNodes.CustomSort(SortCompare);
      ExitStr := ListToStr(ExitNodes, udAutoSelExitCount.Position);
      GetNodes(ExitStr, ntExit, True);
    end;

    if miAutoSelMiddleEnabled.Checked then
    begin
      MiddleNodes.CustomSort(SortCompare);
      MiddleStr := ListToStr(MiddleNodes, udAutoSelMiddleCount.Position);
      GetNodes(MiddleStr, ntMiddle, True);
    end;

    CheckNodesListState(FAVORITES_ID);
    CalculateTotalNodes;
    ShowRouters;
    RoutersUpdated := True;
    EnableOptionButtons;

  finally
    EntryNodes.Free;
    MiddleNodes.Free;
    ExitNodes.Free;
    UniqueList.Free;
    if CheckEntryPorts then
      PortsDic.Clear;
  end;

end;

procedure TTcp.miAboutClick(Sender: TObject);
begin
  if ShowMsg(Format(TransStr('356'),
  [
    TransStr('105'),
    GetFileVersionStr(Paramstr(0)),
    'Copyright © 2020, abysshint',
    TransStr('357')
  ]), TransStr('355'), mtInfo, True) then
  begin
    ShellOpen(GITHUB_URL);
  end;
end;

procedure TTcp.miAddRelaysToBridgesCacheClick(Sender: TObject);
begin
  if miAddRelaysToBridgesCache.Checked then
    LoadConsensus;
  SetConfigBoolean('Routers', 'AddRelaysToBridgesCache', miAddRelaysToBridgesCache.Checked);
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

procedure TTcp.miAutoScrollClick(Sender: TObject);
begin
  SetConfigBoolean('Log', 'AutoScroll', miAutoScroll.Checked);
  CheckLogAutoScroll;
end;

procedure TTcp.AutoSelNodesType(Sender: TObject);
begin
  SetConfigInteger('AutoSelNodes', 'AutoSelNodesType', MenuToInt(miAutoSelNodesType));
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
  if (cbMinimizeOnClose.Checked) and not Closing and not WindowsShutdown then
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
  sgCircuits.ColWidths[CIRC_STREAMS] := Round(30 * Scale);
  sgCircuits.ColWidths[CIRC_BYTES_READ] := 0;
  sgCircuits.ColWidths[CIRC_BYTES_WRITTEN] := 0;
  sgCircuitInfo.ColWidths[CIRC_INFO_ID] := -1;
  sgCircuitInfo.ColWidths[CIRC_INFO_FLAG] := Round(23 * Scale);
  sgCircuitInfo.ColWidths[CIRC_INFO_WEIGHT] := Round(64 * Scale);
  sgStreams.ColWidths[STREAMS_ID] := -1;
  sgStreams.ColWidths[STREAMS_TRACK] := Round(24 * Scale);
  sgStreams.ColWidths[STREAMS_COUNT] := Round(30 * Scale);
  sgStreamsInfo.ColWidths[STREAMS_INFO_ID] := -1;
  sgTransports.ColWidths[PT_HANDLER] := Round(120 * Scale);
  sgTransports.ColWidths[PT_TYPE] := Round(35 * Scale);
  sgTransports.ColWidths[PT_PARAMS] := -1;
  CheckScannerControls;
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

  NewBridgesList := TStringList.Create;
  GeoIpDic := TDictionary<string, TGeoIpInfo>.Create;
  CircuitsDic := TDictionary<string, TCircuitInfo>.Create;
  StreamsDic := TDictionary<string, TStreamInfo>.Create;
  RoutersDic := TDictionary<string, TRouterInfo>.Create;
  FilterDic := TDictionary<string, TFilterInfo>.Create;
  NodesDic := TDictionary<string, TNodeTypes>.Create;
  TrackHostDic := TDictionary<string, Byte>.Create;
  VersionsDic := TDictionary<string, Byte>.Create;
  RangesDic := TDictionary<string, TIPv4Range>.Create;
  PortsDic := TDictionary<Word, Byte>.Create;
  ConstDic := TDictionary<string, Integer>.Create;
  TransportsDic := TDictionary<string, TTransportInfo>.Create;
  BridgesDic := TDictionary<string, TBridgeInfo>.Create;
  DirFetchDic := TDictionary<string, TFetchInfo>.Create;

  DefaultsDic := TDictionary<string, string>.Create;
  DefaultsDic.AddOrSetValue('MaxCircuitDirtiness', '600');
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
  sgFilter.ColsDataType[FILTER_ALIVE] := dtInteger;
  sgRouters.ColsDataType[ROUTER_WEIGHT] := dtSize;
  sgRouters.ColsDataType[ROUTER_PORT] := dtInteger;
  sgRouters.ColsDataType[ROUTER_FLAGS] := dtParams;
  sgCircuits.ColsDataType[CIRC_ID] := dtInteger;
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
      if not cbMinimizeOnStartup.Checked then
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
    lbExitIp.Tag := 1;
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
    if (ssCtrl in Shift) and (FavoritesID in [ENTRY_ID..EXCLUDE_ID]) then
    begin
      sbShowOptions.Click;
      pcOptions.TabIndex := tsLists.TabIndex;
      cbxNodesListType.ItemIndex := FavoritesToNodes(FavoritesID);
      LoadNodesList;
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
        if RoutersCustomFilter in [ENTRY_ID..FAVORITES_ID] then
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
  SaveNetworkCache;
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
  BridgesDic.Free;
  DirFetchDic.Free;
  NewBridgesList.Free;
  RangesDic.Free;
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
  ShowCircuits;
end;

procedure TTcp.tmConsensusTimer(Sender: TObject);
var
  ConsensusDate, NewDescriptorsDate: TDatetime;

  procedure UpdateOptions;
  begin
    OptionsLocked := True;
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
  if cbUseBridges.Checked and cbExcludeUnsuitableBridges.Checked then
  begin
    Inc(FailedBridgesInterval, 3);
    if FailedBridgesInterval > 3600 then
      FailedBridgesInterval := udBridgesCheckDelay.Position;
  end;
  if not (Assigned(Consensus) or Assigned(Descriptors) or tmScanner.Enabled) then
  begin
    if AutoScanStage = 1 then
      ScanNetwork(stBoth, spAuto)
    else
    begin
      if FailedBridgesInterval >= udBridgesCheckDelay.Position then
      begin
        if FailedBridgesCount > 0 then
          UpdateOptions
        else
        begin
          if NewBridgesStage = 0 then
          begin
            if (NewBridgesCount > 0) and (ExitNodeID <> '') then
            begin
              NewBridgesStage := 1;
              UpdateOptions;
            end;
          end
          else
          begin
            NewBridgesStage := 0;
            UpdateOptions;
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

procedure TTcp.miSafeLoggingClick(Sender: TObject);
begin
  SetTorConfig('SafeLogging', IntToStr(Integer(miSafeLogging.Checked)), [cfAutoSave]);
  ReloadTorConfig;
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

procedure TTcp.SelectLogLinesLimit(Sender: TObject);
begin
  TMenuItem(Sender).Checked := True;
  DisplayedLinesCount := TMenuItem(Sender).Tag;
  SetConfigInteger('Log', 'DisplayedLinesType', TMenuItem(Sender).MenuIndex);
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
    miWordWrap.Enabled := False
  else
    miWordWrap.Enabled := True;

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

procedure TTcp.SetLogLevel(Sender: TObject);
begin
  if TMenuItem(Sender).Checked then
    Exit;
  TMenuItem(Sender).Checked := True;
  SetTorConfig('Log', AnsiLowerCase(copy(TMenuItem(Sender).Name, 3, Length(TMenuItem(Sender).Name) - 2)) + ' stdout', [cfAutoSave]);
  ReloadTorConfig;
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
  BridgesCheckControls;  
  ShowRouters;
  EnableOptionButtons;
end;

procedure TTcp.miRtRelayInfoClick(Sender: TObject);
begin
  OpenMetricsUrl('#details', miRtCopyFingerprint.Caption);
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
  BridgeStr, BridgeID: string;
begin
  cbUseBridges.Checked := True;
  cbUsePreferredBridge.Checked := True;
  BridgeStr := TMenuItem(Sender).Hint;
  if BridgeStr = '' then
    BridgeStr := TMenuItem(Sender).Caption;
  edPreferredBridge.Text := BridgeStr;
  if TryGetDataFromStr(BridgeStr, ltHash, BridgeID) then
    LastPreferredBridgeHash := BridgeID;
  BridgesCheckControls;     
  ShowRouters;
  EnableOptionButtons;
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
  OpenMetricsUrl('#details', SelectedNode);
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
  Item: TPair<string, TBridgeInfo>;
  GeoIpInfo: TGeoIpInfo;
  RouterInfo: TRouterInfo;
  PreferredBridge: TBridge;
  LastPreferredBridge: string;
  ClearAll, Deleted: Boolean;
  i: Integer;
  ls: TStringList;
begin
  if not CheckCacheOpConfirmation(TMenuItem(Sender).Caption) then
    Exit;
  DeleteFile(DescriptorsFile);
  DeleteFile(NewDescriptorsFile);
  ClearAll := TMenuItem(Sender).Tag = 1;
  if ClearAll then
    BridgesDic.Clear
  else
  begin
    ls := TStringList.Create;
    try
      LastPreferredBridge := '';
      if TryParseBridge(edPreferredBridge.Text, PreferredBridge) then;
        LastPreferredBridge := PreferredBridge.Hash;
      for Item in BridgesDic do
      begin
        Deleted := False;
        if RoutersDic.TryGetValue(Item.Key, RouterInfo) then
        begin
          if rfRelay in RouterInfo.Flags then
          begin
            if LastPreferredBridge <> Item.Key then
            begin
              ls.Append(Item.Key);
              Deleted := True;
            end;
          end;
        end;
        if not Deleted then
        begin
          if GeoIpDic.TryGetValue(Item.Value.Router.IPv4, GeoIpInfo) then
          begin
            if GetPortsValue(GeoIpInfo.ports, IntToStr(Item.Value.Router.OrPort)) = -1 then
              ls.Append(Item.Key);
          end;
        end;
      end;
      for i := 0 to ls.Count - 1 do
        BridgesDic.Remove(ls[i]);
    finally
      ls.Free;
    end;
  end;
  DescriptorsUpdated := True;
  LoadConsensus;
end;

procedure TTcp.ClearBridgesAvailableCache(Sender: TObject);
var
  ls: TStringList;
  i: Integer;
  HashStr: string;
  DeleteFound: Boolean;
begin
  DeleteFound := TMenuItem(Sender).Tag = 1;
  ls := TStringList.Create;
  try
    ls.Text := meBridges.Text;
    for i := ls.Count - 1 downto 0 do
    begin
      if TryGetDataFromStr(ls[i], ltHash, HashStr) then
      begin
        if BridgesDic.ContainsKey(HashStr) then
        begin
          if DeleteFound then
            ls.Delete(i);
        end
        else
        begin
          if not DeleteFound then
            ls.Delete(i);
        end;
      end;
    end;
    meBridges.Text := ls.Text;
  finally
    ls.Free;
  end;
end;

procedure TTcp.miClearBridgesNotAliveClick(Sender: TObject);
begin
  ScanNetwork(stAlive, spUserBridges);
end;

procedure TTcp.miClearBridgesUnsuitableClick(Sender: TObject);
var
  BridgesData, lastPrefferedBridge: string;
  LastBridgesCount: Integer;
  UpdateControls: Boolean;
begin
  UpdateControls := False;
  LastBridgesCount := meBridges.Lines.Count;
  lastPrefferedBridge := Trim(edPreferredBridge.Text);

  ExcludeUnSuitableBridges(BridgesData, BR, btPrefer);
  if (SuitableBridgesCount = 0) and (lastPrefferedBridge <> '') then
  begin
    cbUsePreferredBridge.Checked := False;
    edPreferredBridge.Text := '';
    BridgesUpdated := True;
  end;

  ExcludeUnSuitableBridges(BridgesData, BR, btList, True);
  if LastBridgesCount <> SuitableBridgesCount then
    meBridges.Text := BridgesData;

  if BridgesUpdated or UpdateControls then
  begin
    EnableOptionButtons;
    BridgesCheckControls;
    CountTotalBridges;
    UpdateRoutersAfterBridgesUpdate;
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

procedure TTcp.miWordWrapClick(Sender: TObject);
begin
  SetConfigBoolean('Log', 'WordWrap', miWordWrap.Checked);
  meLog.WordWrap := miWordWrap.Checked;
  CheckLogAutoScroll(True);  
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
