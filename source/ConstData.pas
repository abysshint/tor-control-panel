unit ConstData;

interface

uses
  System.Types;

const
  BR = #13#10;
  SELECT_CHAR = '★';
  FAVERR_CHAR = '☆';
  BOTH_CHAR = '✿';
  EXCLUDE_CHAR = '✖';
  NONE_CHAR = '-';
  INFINITY_CHAR = '∞';

  BRIDGES_BOT = 'GetBridgesBot';
  BRIDGES_EMAIL = 'bridges@torproject.org';
  BRIDGES_SITE = 'https://bridges.torproject.org/bridges';
  CHECK_URL = 'https://check.torproject.org';
  DOWNLOAD_URL = 'https://www.torproject.org/download/languages';
  METRICS_URL = 'https://metrics.torproject.org/rs.html';
  GITHUB_URL = 'https://github.com/abysshint/tor-control-panel';

  DEFAULT_ENTRY_NODES = '{cz},{fi},{fr},{gb},{se},{nl},{de},{no},{at},{ch}';
  DEFAULT_MIDDLE_NODES = '{cz},{fi},{fr},{gb},{se},{nl},{de},{no},{at},{dk},{pl},{ch}';
  DEFAULT_EXIT_NODES = '{gb},{se},{nl},{de},{no},{hr},{at},{pl},{ro},{ch}';
  DEFAULT_ROUTERS_FILTER_DATA = '15;-1;739;-1;10;0;0;0;';
  DEFAULT_CUSTOM_EXIT_POLICY = 'accept *:80,accept *:443,reject *:*';
  DEFAULT_ALLOWED_PORTS = '80,443';
  DEFAULT_COUNTRY_ID = 249;
  DEFAULT_PORT = '80';

  LOOPBACK_ADDRESS = '127.0.0.1';

  CURRENT_CONFIG_VERSION = 6;
  MAX_SPEED_DATA_LENGTH = 24 * 60 * 60;
  BUFSIZE = 1024 * 1024;

  MAX_COUNTRIES = 251;
  MAX_TOTALS = 7;

  CIRCUIT_FILTER_DEFAULT = 65535;
  CIRCUIT_FILTER_MAX = 65535;
  ROUTER_FILTER_DEFAULT = 15;
  ROUTER_FILTER_MAX = 15;
  SHOW_NODES_FILTER_DEFAULT = 739;
  SHOW_NODES_FILTER_MAX = 16352;
  TPL_MENU_DEFAULT = 7;
  TPL_MENU_MAX = 7;

  L1_NUM_GUARDS = 2;
  L2_NUM_GUARDS = 4;
  L3_NUM_GUARDS = 8;

  VG_AUTO = 0;
  VG_L2 = 1;
  VG_L3 = 2;
  VG_L2_L3 = 3;

  TIME_MILLISECOND = 0;
  TIME_SECOND = 1;
  TIME_MINUTE = 2;
  TIME_HOUR = 3;
  TIME_DAY = 4;
  TIME_WEEK = 5;
  TIME_MONTH = 6;
  TIME_YEAR = 7;

  STOP_NORMAL = 0;
  STOP_CONFIG_ERROR = 1;
  STOP_AUTH_ERROR = 2;

  LP_OPTIONS = 0;
  LP_LOG = 1;
  LP_STATUS = 2;
  LP_CIRCUITS = 3;
  LP_ROUTERS = 4;

  TOTAL_RELAYS = 0;
  TOTAL_GUARDS = 1;
  TOTAL_EXITS = 2;
  TOTAL_PING_SUM = 3;
  TOTAL_PING_COUNTS = 4;
  TOTAL_ALIVES = 5;
  TOTAL_BRIDGES = 6;

  SORT_ASC = 1;
  SORT_DESC = 2;

  PRIORITY_BY_ORDER = 0;
  PRIORITY_BANDWIDTH = 1;

  PRIORITY_BALANCED = 0;
  PRIORITY_WEIGHT = 1;
  PRIORITY_PING = 2;
  PRIORITY_RANDOM = 3;

  BRIDGE_RELAY = 0;
  BRIDGE_NATIVE = 1;

  BRIDGES_TYPE_BUILTIN = 0;
  BRIDGES_TYPE_USER = 1;
  BRIDGES_TYPE_FILE = 2;

  FALLBACK_TYPE_BUILTIN = 0;
  FALLBACK_TYPE_USER = 1;

  TRANSPORT_CLIENT = 0;
  TRANSPORT_SERVER = 1;
  TRANSPORT_BOTH = 2;

  CONTROL_AUTH_COOKIE = 0;
  CONTROL_AUTH_PASSWORD = 1;

  PROXY_TYPE_SOCKS4 = 0;
  PROXY_TYPE_SOCKS5 = 1;
  PROXY_TYPE_HTTPS = 2;

  FILTER_TYPE_NONE = 0;
  FILTER_TYPE_COUNTRIES = 1;
  FILTER_TYPE_FAVORITES = 2;

  NL_TYPE_ENTRY = 0;
  NL_TYPE_MIDDLE = 1;
  NL_TYPE_EXIT = 2;
  NL_TYPE_EXLUDE = 3;

  SERVER_MODE_NONE = 0;
  SERVER_MODE_RELAY = 1;
  SERVER_MODE_EXIT = 2;
  SERVER_MODE_BRIDGE = 3;

  HS_VERSION_2 = 0;
  HS_VERSION_3 = 1;

  HS_STATE_ENABLED = 0;
  HS_STATE_DISABLED = 1;

  AUTOSCAN_AUTO = 0;
  AUTOSCAN_NEW_AND_FAILED = 1;
  AUTOSCAN_NEW_AND_ALIVE = 2;
  AUTOSCAN_NEW_AND_BRIDGES = 3;
  AUTOSCAN_NEW = 4;

  AUTOSEL_SCAN_DISABLED = 0;
  AUTOSEL_SCAN_ANY = 1;
  AUTOSEL_SCAN_FULL = 2;
  AUTOSEL_SCAN_PARTIAL = 3;
  AUTOSEL_SCAN_NEW = 4;

  GRID_FILTER = 1;
  GRID_ROUTERS = 2;
  GRID_CIRCUITS = 3;
  GRID_STREAMS = 4;
  GRID_HS = 5;
  GRID_HSP = 6;
  GRID_CIRC_INFO = 7;
  GRID_STREAM_INFO = 8;
  GRID_TRANSPORTS = 9;

  MEMO_NONE = 0;
  MEMO_BRIDGES = 1;
  MEMO_FALLBACK_DIRS = 2;

  EXTRACT_PREVIEW = 0;
  EXTRACT_PORT = 1;
  EXTRACT_IPV4 = 2;
  EXTRACT_IPV6 = 3;
  EXTRACT_HASH = 4;
  EXTRACT_IPV4_BRIDGE = 5;
  EXTRACT_IPV6_BRIDGE = 6;
  EXTRACT_FALLBACK_DIR = 7;

  FILTER_ID = 0;
  FILTER_FLAG = 1;
  FILTER_NAME = 2;
  FILTER_TOTAL = 3;
  FILTER_GUARD = 4;
  FILTER_EXIT = 5;
  FILTER_BRIDGE = 6;
  FILTER_ALIVE = 7;
  FILTER_PING = 8;
  FILTER_ENTRY_NODES = 9;
  FILTER_MIDDLE_NODES = 10;
  FILTER_EXIT_NODES = 11;
  FILTER_EXCLUDE_NODES = 12;

  ROUTER_ID = 0;
  ROUTER_NAME = 1;
  ROUTER_IP = 2;
  ROUTER_FLAG = 3;
  ROUTER_COUNTRY = 4;
  ROUTER_WEIGHT = 5;
  ROUTER_PORT = 6;
  ROUTER_VERSION = 7;
  ROUTER_PING = 8;
  ROUTER_FLAGS = 9;
  ROUTER_ENTRY_NODES = 10;
  ROUTER_MIDDLE_NODES = 11;
  ROUTER_EXIT_NODES = 12;
  ROUTER_EXCLUDE_NODES = 13;

  CIRC_ID = 0;
  CIRC_PURPOSE = 1;
  CIRC_FLAGS = 2;
  CIRC_PARAMS = 3;
  CIRC_BYTES_READ = 4;
  CIRC_BYTES_WRITTEN = 5;
  CIRC_STREAMS = 6;

  STREAMS_ID = 0;
  STREAMS_TARGET = 1;
  STREAMS_TRACK = 2;
  STREAMS_COUNT = 3;
  STREAMS_BYTES_READ = 4;
  STREAMS_BYTES_WRITTEN = 5;

  HS_NAME = 0;
  HS_VERSION = 1;
  HS_INTRO_POINTS = 2;
  HS_MAX_STREAMS = 3;
  HS_PORTS_DATA = 4;
  HS_PREVIOUS_NAME = 5;
  HS_STATE = 6;


  HSP_INTERFACE = 0;
  HSP_REAL_PORT = 1;
  HSP_VIRTUAL_PORT = 2;

  CIRC_INFO_ID = 0;
  CIRC_INFO_NAME = 1;
  CIRC_INFO_IP = 2;
  CIRC_INFO_FLAG = 3;
  CIRC_INFO_COUNTRY = 4;
  CIRC_INFO_WEIGHT = 5;
  CIRC_INFO_PING = 6;

  STREAMS_INFO_ID = 0;
  STREAMS_INFO_SOURCE_ADDR = 1;
  STREAMS_INFO_DEST_ADDR = 2;
  STREAMS_INFO_PURPOSE = 3;
  STREAMS_INFO_BYTES_READ = 4;
  STREAMS_INFO_BYTES_WRITTEN = 5;

  PT_TRANSPORTS = 0;
  PT_HANDLER = 1;
  PT_PARAMS = 2;
  PT_TYPE = 3;

  ROUTER_MIDDLE_ONLY = 1;
  ROUTER_BAD_EXIT = 2;
  ROUTER_NOT_RECOMMENDED = 4;
  ROUTER_DIR_MIRROR = 8;
  ROUTER_HS_DIR = 16;
  ROUTER_REACHABLE_IPV6 = 32;
  ROUTER_ALIVE = 64;
  ROUTER_AUTHORITY = 128;
  ROUTER_BRIDGE = 256;

  GENERAL = 0;
  HS_CLIENT_HSDIR = 1;
  HS_CLIENT_INTRO = 2;
  HS_CLIENT_REND = 3;
  HS_SERVICE_HSDIR = 4;
  HS_SERVICE_INTRO = 5;
  HS_SERVICE_REND = 6;
  HS_VANGUARDS = 7;
  PATH_BIAS_TESTING = 8;
  TESTING = 9;
  CIRCUIT_PADDING = 10;
  MEASURE_TIMEOUT = 11;
  CONTROLLER_CIRCUIT = 38;

  LAUNCHED = 12;
  BUILT = 13;
  GUARD_WAIT = 14;
  EXTENDED = 15;
  FAILED = 16;
  CLOSED = 17;

  NEW = 18;
  NEWRESOLVE = 19;
  REMAP = 20;
  SENTCONNECT = 21;
  SENTRESOLVE = 22;
  SUCCEEDED = 23;
  DETACHED = 24;
  CONTROLLER_WAIT = 25;

  DIR_FETCH = 26;
  DIR_UPLOAD = 27;
  DIRPORT_TEST = 28;
  DNS_REQUEST = 29;
  USER = 30;

  SOCKS4 = 31;
  SOCKS5 = 32;
  TRANS = 33;
  NATD = 34;
  DNS = 35;
  HTTPCONNECT = 36;
  UNKNOWN = 37;

  FILTER_BY_BRIDGE = 4;
  FILTER_BY_ALIVE = 5;
  FILTER_BY_TOTAL = 6;
  FILTER_BY_GUARD = 7;
  FILTER_BY_EXIT = 8;
  FILTER_BY_QUERY = 9;

  NONE_ID = 0;
  ENTRY_ID = ROUTER_ENTRY_NODES;
  MIDDLE_ID = ROUTER_MIDDLE_NODES;
  EXIT_ID = ROUTER_EXIT_NODES;
  EXCLUDE_ID = ROUTER_EXCLUDE_NODES;
  FAVORITES_ID = 14;
  BRIDGES_ID = 15;
  FALLBACK_DIR_ID = 16;

  CF_EXIT = 1;
  CF_INTERNAL = 2;
  CF_DIR_REQUEST = 4;
  CF_HIDDEN_SERVICE = 8;
  CF_VANGUARDS = 16;
  CF_REND = 32;
  CF_INTRO = 64;
  CF_CLIENT = 128;
  CF_SERVICE = 256;
  CF_MEASURE_TIMEOUT = 512;
  CF_CIRCUIT_PADDING = 1024;
  CF_TESTING = 2048;
  CF_PATH_BIAS_TESTING = 4096;
  CF_CONTROLLER = 8192;
  CF_OTHER = 16384;

type
  ArrOfStr = array of string;
  ArrOfPoint = array of TPoint;

  TNodeType = (
    ntNone = NONE_ID,
    ntEntry = ENTRY_ID,
    ntMiddle = MIDDLE_ID,
    ntExit = EXIT_ID,
    ntExclude = EXCLUDE_ID,
    ntFavorites = FAVORITES_ID,
    ntFallbackDir = FALLBACK_DIR_ID
  );
  TNodeTypes = set of TNodeType;

  TAddressType = (atNone, atNormal, atExit, atOnion);
  TEditMenuType = (emCopy, emCut, emPaste, emSelectAll, emClear, emDelete, emFind);
  TListType = (ltNoCheck, ltHost, ltHash, ltPolicy, ltBridge, ltNode, ltSocket, ltTransport, ltIp, ltCidr, ltCode, ltFallbackDir);
  TGuardType = (gtNone, gtBridges, gtRestricted, gtDefault, gtAll);
  TMsgType = (mtInfo, mtWarning, mtError, mtQuestion);
  TParamType = (ptString, ptInteger, ptBoolean, ptSocket, ptHost, ptBridge);
  TTaskBarPos = (tbTop, tbBottom, tbLeft, tbRight, tbNone);
  TScanType = (stNone, stPing, stAlive, stBoth);
  TScanPurpose = (spNone, spNew, spFailed, spUserBridges, spUserFallbackDirs, spAll, spNewAndFailed, spNewAndAlive, spNewAndBridges, spBridges, spGuards, spAlive, spNewBridges, spAuto);
  TProxyType = (ptNone, ptSocks, ptHttp, ptBoth);

  TConfigFlag = (cfAutoAppend, cfAutoSave, cfFindComments, cfExistCheck, cfMultiLine, cfBoolInvert);
  TConfigFlags = set of TConfigFlag;

  TProcessFlag = (pfHideWindow, pfReadStdOut);
  TProcessFlags = set of TProcessFlag;
  TProcessInfo = record
    hProcess: THandle;
    hStdOutput: THandle;
  end;

  TStaticPair = record
    Key: string;
    Value: Integer;
  end;

  TIPv4Range = record
    IpStart: Cardinal;
    IpEnd: Cardinal;
  end;

  TSocket = record
    Ip: string;
    Port: Word;
  end;

  TNodeData = record
    NodeStr: string;
    NodeID: TListType;
    RangeData: TIPv4Range;
  end;
  ArrOfNodes = array of TNodeData;
var
  CountryCodes: array [0..MAX_COUNTRIES - 1] of string = (
    'au','at','az','ax','al','dz','as','ai','ao','ad','aq','ag','ar','am','aw',
    'af','bs','bd','bb','bh','bz','by','be','bj','bm','bg','bo','bq','ba','bw',
    'br','io','bn','bf','bi','bt','vu','va','gb','hu','ve','vg','vi','um','tl',
    'vn','ga','gy','ht','gm','gh','gp','gt','gf','gn','gw','de','gg','gi','hn',
    'hk','ps','gd','gl','gr','ge','gu','dk','cd','je','dj','dm','do','eg','zm',
    'zw','ye','il','in','id','jo','iq','ir','ie','is','es','it','cv','kz','kh',
    'cm','ca','qa','ke','cy','kg','ki','cn','kp','cc','co','km','cr','ci','cu',
    'kw','cw','la','lv','ls','lr','lb','ly','lt','li','lu','mu','mr','mg','yt',
    'mo','mk','mw','my','ml','mv','mt','ma','mq','mh','mx','fm','mz','md','mc',
    'mn','ms','mm','na','nr','np','ne','ng','nl','ni','nu','nz','nc','no','ae',
    'om','bv','im','nf','cx','ky','ck','pn','sh','pk','pw','pa','pg','py','pe',
    'pl','pt','pr','cg','kr','re','ru','rw','ro','eh','sv','ws','sm','st','sa',
    'sz','mp','sc','bl','sn','mf','pm','vc','kn','lc','rs','sg','sx','sy','sk',
    'si','sb','so','sd','sr','us','sl','tj','tw','th','tz','tc','tg','tk','to',
    'tt','tv','tn','tm','tr','ug','uz','ua','wf','uy','fo','fj','ph','fi','fk',
    'fr','pf','tf','hm','hr','cf','td','me','cz','cl','ch','se','sj','lk','ec',
    'gq','er','ee','et','za','gs','ss','jm','jp','??','eu');

  PlotIntervals: array [0..8] of Integer = (
    60, 300, 900, 1800, 3600, 10800, 21600, 43200, 86400
  );
  BridgeDistributions: array [0..4] of string = (
    'any', 'https', 'email', 'moat', 'none'
  );
  LogLevels: array [0..4] of string = (
    'debug', 'info', 'notice', 'warn', 'err'
  );
  PolicyTypes: array [0..3] of string = (
    'accept', 'reject', 'accept6', 'reject6'
  );
  MaskTypes: array [0..3] of string = (
    '*', '*4', '*6', 'private'
  );
  PrefixSizes: array [0..4] of string = (
    '', 'kilo', 'mega', 'giga', 'tera'
  );
  PrefixShortSizes: array [0..4] of string = (
    '', 'k', 'm', 'g', 't'
  );
  PrivateRanges: array [0..3] of string = (
    '192.168.0.0/16',
    '172.16.0.0/12',
    '169.254.0.0/16',
    '10.0.0.0/8'
  );
  DocRanges: array [0..0] of string = (
    '192.0.2.0/24'
  );

  GeoIpDirs: array [0..2] of string = (
    '%UserDir%',
    '%ProgramDir%\Data\',
    '%ProgramDir%\Data\Tor\'
  );

  TransportDirs: array [0..1] of string = (
    '%ProgramDir%\Tor\Pluggable_Transports\',
    '%ProgramDir%\Tor\PluggableTransports\'
  );

  CircuitPurposes: array[0..12] of TStaticPair = (
    (Key: 'GENERAL'; Value: GENERAL),
    (Key: 'HS_CLIENT_HSDIR'; Value: HS_CLIENT_HSDIR),
    (Key: 'HS_CLIENT_INTRO'; Value: HS_CLIENT_INTRO),
    (Key: 'HS_CLIENT_REND'; Value: HS_CLIENT_REND),
    (Key: 'HS_SERVICE_HSDIR'; Value: HS_SERVICE_HSDIR),
    (Key: 'HS_SERVICE_INTRO'; Value: HS_SERVICE_INTRO),
    (Key: 'HS_SERVICE_REND'; Value: HS_SERVICE_REND),
    (Key: 'HS_VANGUARDS'; Value: HS_VANGUARDS),
    (Key: 'PATH_BIAS_TESTING'; Value: PATH_BIAS_TESTING),
    (Key: 'TESTING'; Value: TESTING),
    (Key: 'CIRCUIT_PADDING'; Value: CIRCUIT_PADDING),
    (Key: 'MEASURE_TIMEOUT'; Value: MEASURE_TIMEOUT),
    (Key: 'CONTROLLER'; Value: CONTROLLER_CIRCUIT)
  );

  CircuitStatuses: array[0..5] of TStaticPair = (
    (Key: 'LAUNCHED'; Value: LAUNCHED),
    (Key: 'BUILT'; Value: BUILT),
    (Key: 'GUARD_WAIT'; Value: GUARD_WAIT),
    (Key: 'EXTENDED'; Value: EXTENDED),
    (Key: 'FAILED'; Value: FAILED),
    (Key: 'CLOSED'; Value: CLOSED)
  );

  StreamPurposes: array[0..4] of TStaticPair = (
    (Key: 'DIR_FETCH'; Value: DIR_FETCH),
    (Key: 'DIR_UPLOAD'; Value: DIR_UPLOAD),
    (Key: 'DIRPORT_TEST'; Value: DIRPORT_TEST),
    (Key: 'DNS_REQUEST'; Value: DNS_REQUEST),
    (Key: 'USER'; Value: USER)
  );

  StreamStatuses: array[0..9] of TStaticPair = (
    (Key: 'NEW'; Value: NEW),
    (Key: 'NEWRESOLVE'; Value: NEWRESOLVE),
    (Key: 'REMAP'; Value: REMAP),
    (Key: 'SENTCONNECT'; Value: SENTCONNECT),
    (Key: 'SENTRESOLVE'; Value: SENTRESOLVE),
    (Key: 'SUCCEEDED'; Value: SUCCEEDED),
    (Key: 'FAILED'; Value: FAILED),
    (Key: 'CLOSED'; Value: CLOSED),
    (Key: 'DETACHED'; Value: DETACHED),
    (Key: 'CONTROLLER_WAIT'; Value: CONTROLLER_WAIT)
  );

  ClientProtocols: array[0..6] of TStaticPair = (
    (Key: 'SOCKS4'; Value: SOCKS4),
    (Key: 'SOCKS5'; Value: SOCKS5),
    (Key: 'TRANS'; Value: TRANS),
    (Key: 'NATD'; Value: NATD),
    (Key: 'DNS'; Value: DNS),
    (Key: 'HTTPCONNECT'; Value: HTTPCONNECT),
    (Key: 'UNKNOWN'; Value: UNKNOWN)
  );

implementation

end.
