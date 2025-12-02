unit ConstData;

interface

uses
  System.Types, Winapi.Windows;

const
  BR = #13#10;
  TAB = #9;
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

  DEFAULT_ENTRY_COUNTRIES = '{bg},{ch},{cz},{de},{fi},{fr},{gb},{hr},{lt},{lu},{nl},{no},{pl},{ro},{se}';
  DEFAULT_MIDDLE_COUNTRIES = '{at},{bg},{ch},{cz},{de},{dk},{fi},{fr},{gb},{hr},{hu},{it},{lt},{lu},{md},{nl},{no},{pl},{ro},{se}';
  DEFAULT_EXIT_COUNTRIES = '{at},{ch},{de},{fr},{lu},{nl},{no},{pl},{ro},{se}';

  DEFAULT_ROUTERS_FILTER_DATA = '15;-1;739;-1;10;0;0;0;';
  DEFAULT_CUSTOM_EXIT_POLICY = 'accept *:80,accept *:443,reject *:*';
  DEFAULT_ALLOWED_PORTS = '80,443';
  DEFAULT_COUNTRY_ID = 249;
  DEFAULT_PORT = '80';

  LOOPBACK_ADDRESS = '127.0.0.1';

  CURRENT_CONFIG_VERSION = 15;
  MAX_SPEED_DATA_LENGTH = 24 * 60 * 60;
  BUFSIZE = 1024 * 1024;

  MAX_COUNTRIES = 252;
  MAX_TOTALS = 7;
  MAX_URLS_TO_OPEN = 10;

  CIRCUIT_FILTER_DEFAULT = 262143;
  CIRCUIT_FILTER_MAX = 262143;
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
  STOP_HALT = 3;

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

  SORT_DATA_TYPE = 0;
  SORT_DATA_COL = 1;

  SORT_NONE = 0;
  SORT_ASC = 1;
  SORT_DESC = 2;

  PRIORITY_BY_ORDER = 0;
  PRIORITY_BANDWIDTH = 1;

  PRIORITY_BALANCED = 0;
  PRIORITY_WEIGHT = 1;
  PRIORITY_PING = 2;
  PRIORITY_RANDOM = 3;

  PRIORITY_THROUGHPUT = 0;
  PRIORITY_LATENCY = 1;

  UNIQUE_TYPE_NONE = 0;
  UNIQUE_TYPE_HASH = 1;
  UNIQUE_TYPE_IP = 2;
  UNIQUE_TYPE_CIDR_24 = 3;
  UNIQUE_TYPE_CIDR_16 = 4;
  UNIQUE_TYPE_CIDR_8 = 5;
  UNIQUE_TYPE_COUNTRY = 6;

  CONFLUX_TYPE_AUTO = 0;
  CONFLUX_TYPE_ENABLED = 1;
  CONFLUX_TYPE_DISABLED = 2;

  BRIDGE_RELAY = 0;
  BRIDGE_NATIVE = 1;

  BRIDGES_TYPE_BUILTIN = 0;
  BRIDGES_TYPE_USER = 1;
  BRIDGES_TYPE_FILE = 2;

  BRIDGE_FILE_FORMAT_AUTO = 0;
  BRIDGE_FILE_FORMAT_COMPAT = 1;
  BRIDGE_FILE_FORMAT_NORMAL = 2;

  REQUEST_TYPE_VANILLA = 1;
  REQUEST_TYPE_OBFUSCATED = 2;
  REQUEST_TYPE_WEBTUNNEL = 3;

  FALLBACK_TYPE_BUILTIN = 0;
  FALLBACK_TYPE_USER = 1;

  TRANSPORT_CLIENT = 0;
  TRANSPORT_SERVER = 1;
  TRANSPORT_BOTH = 2;

  CONTROL_AUTH_COOKIE = 0;
  CONTROL_AUTH_PASSWORD = 1;

  MINIMIZE_ON_NONE = 0;
  MINIMIZE_ON_ALL = 1;
  MINIMIZE_ON_CLOSE = 2;
  MINIMIZE_ON_STARTUP = 3;

  PROXY_TYPE_SOCKS4 = 0;
  PROXY_TYPE_SOCKS5 = 1;
  PROXY_TYPE_HTTPS = 2;

  FILTER_TYPE_NONE = 0;
  FILTER_TYPE_COUNTRIES = 1;
  FILTER_TYPE_FAVORITES = 2;

  COUNTRY_TYPE_ALL = -1;
  COUNTRY_TYPE_FILTER = -2;

  NL_TYPE_ENTRY = 0;
  NL_TYPE_MIDDLE = 1;
  NL_TYPE_EXIT = 2;
  NL_TYPE_EXLUDE = 3;

  SERVER_MODE_NONE = 0;
  SERVER_MODE_RELAY = 1;
  SERVER_MODE_EXIT = 2;
  SERVER_MODE_BRIDGE = 3;

  HS_VERSION_3 = 0;

  HS_STATE_ENABLED = 0;
  HS_STATE_DISABLED = 1;

  PT_STATE_AUTO = 0;
  PT_STATE_ENABLED = 1;
  PT_STATE_DISABLED = 2;

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

  CONTROL_TYPE_MEMO = 0;
  CONTROL_TYPE_GRID = 1;

  PING_DEAD = -1;
  PING_NONE = 0;

  PORT_FAKE = -2;
  PORT_DEAD = -1;
  PORT_NONE = 0;
  PORT_ALIVE = 1;

  GRID_FILTER = 1;
  GRID_ROUTERS = 2;
  GRID_CIRCUITS = 3;
  GRID_STREAMS = 4;
  GRID_HS = 5;
  GRID_HS_PORTS = 6;
  GRID_CIRC_INFO = 7;
  GRID_STREAMS_INFO = 8;
  GRID_TRANSPORTS = 9;

  MEMO_NONE = 0;
  MEMO_BRIDGES = 1;
  MEMO_MY_FAMILY = 2;
  MEMO_TRACK_HOST_EXITS = 3;
  MEMO_FALLBACK_DIRS = 4;
  MEMO_NODES_LIST = 5;
  MEMO_EXIT_POLICY = 6;

  EXTRACT_PREVIEW = 0;
  EXTRACT_PORT = 1;
  EXTRACT_IPV4 = 2;
  EXTRACT_IPV6 = 3;
  EXTRACT_HASH = 4;
  EXTRACT_IPV4_BRIDGE = 5;
  EXTRACT_IPV6_BRIDGE = 6;
  EXTRACT_FALLBACK_DIR = 7;
  EXTRACT_NICKNAME = 8;
  EXTRACT_COUNTRY_CODE = 9;
  EXTRACT_IPV4_COUNTRY_CODE = 17;
  EXTRACT_IPV6_COUNTRY_CODE = 18;
  EXTRACT_CSV = 10;
  EXTRACT_IPV4_SOCKET = 11;
  EXTRACT_IPV6_SOCKET = 12;
  EXTRACT_HOST = 13;
  EXTRACT_HOST_SOCKET = 14;
  EXTRACT_HOST_ROOT = 15;
  EXTRACT_IPV4_CIDR = 16;

  OPTION_FORMAT_IPV6 = 1;
  OPTION_SORT = 2;
  OPTION_REMOVE_DUPLICATES = 3;
  OPTION_FORMAT_CODES = 4;
  OPTION_SHOW_FULL_MENU = 5;

  DELIM_AUTO = 0;
  DELIM_NEW_LINE = 1;
  DELIM_COMMA = 2;

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
  ROUTER_ADDR_IPV4 = 2;
  ROUTER_COUNTRY_FLAG = 3;
  ROUTER_COUNTRY_NAME = 4;
  ROUTER_ADDR_IPV6 = 5;
  ROUTER_WEIGHT = 6;
  ROUTER_PORT = 7;
  ROUTER_VERSION = 8;
  ROUTER_PING = 9;
  ROUTER_FLAGS = 10;
  ROUTER_ENTRY_NODES = 11;
  ROUTER_MIDDLE_NODES = 12;
  ROUTER_EXIT_NODES = 13;
  ROUTER_EXCLUDE_NODES = 14;

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
  CIRC_INFO_ADDR_IPV4 = 2;
  CIRC_INFO_COUNTRY_FLAG = 3;
  CIRC_INFO_COUNTRY_NAME = 4;
  CIRC_INFO_ADDR_IPV6 = 5;
  CIRC_INFO_WEIGHT = 6;
  CIRC_INFO_PING = 7;

  STREAMS_INFO_ID = 0;
  STREAMS_INFO_SOURCE_ADDR = 1;
  STREAMS_INFO_DEST_ADDR = 2;
  STREAMS_INFO_PURPOSE = 3;
  STREAMS_INFO_BYTES_READ = 4;
  STREAMS_INFO_BYTES_WRITTEN = 5;

  PT_TRANSPORTS = 0;
  PT_HANDLER = 1;
  PT_PARAMS = 2;
  PT_PARAMS_STATE = 3;
  PT_TYPE = 4;
  PT_STATE = 5;

  ROUTER_MIDDLE_ONLY = 1;
  ROUTER_BAD_EXIT = 2;
  ROUTER_NOT_RECOMMENDED = 4;
  ROUTER_UNSTABLE = 8;
  ROUTER_HS_DIR = 16;
  ROUTER_REACHABLE_IPV6 = 32;
  ROUTER_AUTHORITY = 64;
  ROUTER_SUPPORT_CONFLUX = 128;
  ROUTER_ALIVE = 256;
  ROUTER_BRIDGE = 512;

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
  CONFLUX_LINKED = 39;
  CONFLUX_UNLINKED = 40;

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
  XOFF_SENT = 41;
  XOFF_RECV = 42;
  XON_SENT = 43;
  XON_RECV = 44;

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
  METRICS = 45;

  PURPOSE_CHANGED = 46;
  CANNIBALIZED = 47;

  FILTER_MODE_NONE = 0;
  FILTER_MODE_COUNTRIES = 1;
  FILTER_MODE_FAVORITES = 2;

  FILTER_BY_BRIDGE = 25;
  FILTER_BY_ALIVE = 26;
  FILTER_BY_TOTAL = 27;
  FILTER_BY_GUARD = 28;
  FILTER_BY_EXIT = 29;
  FILTER_BY_QUERY = 30;

  USER_QUERY_HASH = 0;
  USER_QUERY_NICKNAME = 1;
  USER_QUERY_IPV4 = 2;
  USER_QUERY_IPV6 = 3;
  USER_QUERY_PORT = 4;
  USER_QUERY_VERSION = 5;
  USER_QUERY_PING = 6;
  USER_QUERY_TRANSPORT = 7;

  RF_CURRENT_TYPES = 0;
  RF_PREVIOUS_TYPES = 1;
  RF_NODE_TYPES = 2;
  RF_COUNTRY = 3;
  RF_WEIGHT = 4;
  RF_CURRENT_CUSTOM = 5;
  RF_PREVIOUS_CUSTOM = 6;
  RF_QUERY_TYPE = 7;
  RF_QUERY_TEXT = 8;

  NONE_ID = 0;
  ENTRY_ID = 1;
  MIDDLE_ID = 2;
  EXIT_ID = 3;
  EXCLUDE_ID = 4;
  FAVORITES_ID = 5;
  BRIDGES_ID = 6;
  FALLBACK_DIR_ID = 7;

  CF_EXIT = 1;
  CF_INTERNAL = 2;
  CF_CONFLUX_LINKED = 4;
  CF_CONFLUX_UNLINKED = 8;
  CF_DIR_REQUEST = 16;
  CF_HIDDEN_SERVICE = 32;
  CF_VANGUARDS = 64;
  CF_REND = 128;
  CF_INTRO = 256;
  CF_CLIENT = 512;
  CF_SERVICE = 1024;
  CF_MEASURE_TIMEOUT = 2048;
  CF_CIRCUIT_PADDING = 4096;
  CF_TESTING = 8192;
  CF_PATH_BIAS_TESTING = 16384;
  CF_CONTROLLER = 32768;
  CF_OTHER = 65536;

type
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
  TGeoIpType = (gitNone, gitIPv4, gitIPv6, gitBoth);
  TCloseType = (ctCircuit, ctTarget, ctStream);
  TAddressType = (atNone, atIPv4, atIPv6, atIPv4Cidr, atIPv6Cidr);
  TSocketType = (soNone, soIPv4, soIPv6, soHost);
  TTargetType = (ttNone, ttNormal, ttExit, ttOnion);
  THostType = (htNone, htDomain, htIPv4, htIPv6, htRoot);
  TEditMenuType = (emCopy, emCut, emPaste, emSelectAll, emClear, emDelete, emFind);
  TNodeDataType = (dtNone, dtHash, dtIPv4, dtIPv4Cidr, dtCode);
  TListType = (ltNone, ltHost, ltHash, ltPolicy, ltBridge, ltNode, ltSocket, ltTransport, ltFallbackDir);
  TGuardType = (gtNone, gtBridges, gtRestricted, gtDefault, gtAll);
  TMsgType = (mtInfo, mtWarning, mtError, mtQuestion);
  TParamType = (ptString, ptInteger, ptBoolean);
  TTaskBarPos = (tbTop, tbBottom, tbLeft, tbRight, tbNone);
  TScanType = (stNone, stPing, stAlive, stBoth);
  TScanPurpose = (spNone, spNew, spFailed, spUserBridges, spUserFallbackDirs, spAll, spNewAndFailed, spNewAndAlive, spNewAndBridges, spBridges, spGuards, spAlive, spNewBridges, spAuto, spSelected);
  TProxyType = (ptNone, ptSocks, ptHttp, ptBoth);
  TBracketsType = (btCurly, btSquare, btRound);
  TConfigFlag = (cfAutoAppend, cfAutoSave, cfFindComments, cfExistCheck, cfBoolInvert, cfDeleteBlankLines, cfParamWithSpace);
  TConfigFlags = set of TConfigFlag;
  TRouterFlag = (rfAuthority, rfBadExit, rfExit, rfFast, rfGuard, rfHSDir, rfStable, rfV2Dir, rfBridge, rfRelay, rfMiddleOnly, rfNoBridgeRelay);
  TRouterFlags = set of TRouterFlag;

  TProcessFlag = (pfHideWindow, pfReadStdOut);
  TProcessFlags = set of TProcessFlag;
  TProcessInfo = record
    ProcessID: DWORD;
    hProcess: THandle;
    hStdOutput: THandle;
  end;

  TIPRangeType = (rtNone, rtAny, rtLoopback, rtPrivate, rtDoc);
  TIPRangeTypes = set of TIPRangeType;
  TStaticRanges = record
    Cidr: string;
    AddrType: TAddressType;
    Group: TIPRangeType;
  end;

  TStaticPair = record
    Key: string;
    Value: ShortInt;
  end;

  TStaticData = record
    Key: Byte;
    Value: Byte;
  end;

  TStringPair = record
    Key: string;
    Value: string;
  end;

const
  cDefaultProcessInfo: TProcessInfo = (ProcessID: 0; hProcess: INVALID_HANDLE_VALUE; hStdOutput: INVALID_HANDLE_VALUE);
  cDefaultStringPair: TStringPair = (Key: ''; Value: '');

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
    'gq','er','ee','et','za','gs','ss','jm','jp','??','eu','ap');

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

  GeoIpDirs: array [0..2] of string = (
    '%UserDir%',
    '%ProgramDir%\Data\',
    '%ProgramDir%\Data\Tor\'
  );

  TransportDirs: array [0..1] of string = (
    '%ProgramDir%\Tor\Pluggable_Transports\',
    '%ProgramDir%\Tor\PluggableTransports\'
  );

  ReservedRanges: array [0..17] of TStaticRanges = (
    (Cidr: '0.0.0.0/8'; AddrType: atIPv4Cidr; Group: rtAny),
    (Cidr: '10.0.0.0/8'; AddrType: atIPv4Cidr; Group: rtPrivate),
    (Cidr: '127.0.0.0/8'; AddrType: atIPv4Cidr; Group: rtLoopback),
    (Cidr: '100.64.0.0/10'; AddrType: atIPv4Cidr; Group: rtPrivate),
    (Cidr: '169.254.0.0/16'; AddrType: atIPv4Cidr; Group: rtPrivate),
    (Cidr: '172.16.0.0/12'; AddrType: atIPv4Cidr; Group: rtPrivate),
    (Cidr: '192.168.0.0/16'; AddrType: atIPv4Cidr; Group: rtPrivate),
    (Cidr: '192.0.2.0/24'; AddrType: atIPv4Cidr; Group: rtDoc),
    (Cidr: '198.51.100.0/24'; AddrType: atIPv4Cidr; Group: rtDoc),
    (Cidr: '203.0.113.0/24'; AddrType: atIPv4Cidr; Group: rtDoc),
    (Cidr: '233.252.0.0/24'; AddrType: atIPv4Cidr; Group: rtDoc),
    (Cidr: '::/128'; AddrType: atIPv6Cidr; Group: rtAny),
    (Cidr: '::1/128'; AddrType: atIPv6Cidr; Group: rtLoopback),
    (Cidr: '2001:db8::/32'; AddrType: atIPv6Cidr; Group: rtDoc),
    (Cidr: '3fff::/20'; AddrType: atIPv6Cidr; Group: rtDoc),
    (Cidr: 'fc00::/7'; AddrType: atIPv6Cidr; Group: rtPrivate),
    (Cidr: 'fe80::/10'; AddrType: atIPv6Cidr; Group: rtPrivate),
    (Cidr: 'fec0::/10'; AddrType: atIPv6Cidr; Group: rtPrivate)
  );

  CircuitPurposes: array[0..14] of TStaticPair = (
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
    (Key: 'CONTROLLER'; Value: CONTROLLER_CIRCUIT),
    (Key: 'CONFLUX_LINKED'; Value: CONFLUX_LINKED),
    (Key: 'CONFLUX_UNLINKED'; Value: CONFLUX_UNLINKED)
  );

  CircuitStatuses: array[0..5] of TStaticPair = (
    (Key: 'LAUNCHED'; Value: LAUNCHED),
    (Key: 'BUILT'; Value: BUILT),
    (Key: 'GUARD_WAIT'; Value: GUARD_WAIT),
    (Key: 'EXTENDED'; Value: EXTENDED),
    (Key: 'FAILED'; Value: FAILED),
    (Key: 'CLOSED'; Value: CLOSED)
  );

  CircuitStatusesMinor: array[0..1] of TStaticPair = (
    (Key: 'PURPOSE_CHANGED'; Value: PURPOSE_CHANGED),
    (Key: 'CANNIBALIZED'; Value: CANNIBALIZED)
  );

  StreamPurposes: array[0..4] of TStaticPair = (
    (Key: 'DIR_FETCH'; Value: DIR_FETCH),
    (Key: 'DIR_UPLOAD'; Value: DIR_UPLOAD),
    (Key: 'DIRPORT_TEST'; Value: DIRPORT_TEST),
    (Key: 'DNS_REQUEST'; Value: DNS_REQUEST),
    (Key: 'USER'; Value: USER)
  );

  StreamStatuses: array[0..13] of TStaticPair = (
    (Key: 'NEW'; Value: NEW),
    (Key: 'NEWRESOLVE'; Value: NEWRESOLVE),
    (Key: 'REMAP'; Value: REMAP),
    (Key: 'SENTCONNECT'; Value: SENTCONNECT),
    (Key: 'SENTRESOLVE'; Value: SENTRESOLVE),
    (Key: 'SUCCEEDED'; Value: SUCCEEDED),
    (Key: 'FAILED'; Value: FAILED),
    (Key: 'CLOSED'; Value: CLOSED),
    (Key: 'DETACHED'; Value: DETACHED),
    (Key: 'CONTROLLER_WAIT'; Value: CONTROLLER_WAIT),
    (Key: 'XOFF_SENT'; Value: XOFF_SENT),
    (Key: 'XOFF_RECV'; Value: XOFF_RECV),
    (Key: 'XON_SENT'; Value: XON_SENT),
    (Key: 'XON_RECV'; Value: XON_RECV)
  );

  ClientProtocols: array[0..7] of TStaticPair = (
    (Key: 'SOCKS4'; Value: SOCKS4),
    (Key: 'SOCKS5'; Value: SOCKS5),
    (Key: 'TRANS'; Value: TRANS),
    (Key: 'NATD'; Value: NATD),
    (Key: 'DNS'; Value: DNS),
    (Key: 'HTTPCONNECT'; Value: HTTPCONNECT),
    (Key: 'METRICS'; Value: METRICS),
    (Key: 'UNKNOWN'; Value: UNKNOWN)
  );

  DEFAULT_GRID_SORT_DATA: array[0..9] of TStaticData = (
    (Key: GRID_FILTER; Value: SORT_DESC),
    (Key: GRID_FILTER; Value: FILTER_TOTAL),
    (Key: GRID_ROUTERS; Value: SORT_DESC),
    (Key: GRID_ROUTERS; Value: ROUTER_WEIGHT),
    (Key: GRID_CIRCUITS; Value: SORT_DESC),
    (Key: GRID_CIRCUITS; Value: CIRC_ID),
    (Key: GRID_STREAMS; Value: SORT_DESC),
    (Key: GRID_STREAMS; Value: STREAMS_ID),
    (Key: GRID_STREAMS_INFO; Value: SORT_DESC),
    (Key: GRID_STREAMS_INFO; Value: STREAMS_INFO_ID)
  );

  DEFAULT_MEMO_SORT_DATA: array[0..4] of TStaticData = (
    (Key: MEMO_BRIDGES; Value: SORT_NONE),
    (Key: MEMO_MY_FAMILY; Value: SORT_ASC),
    (Key: MEMO_TRACK_HOST_EXITS; Value: SORT_ASC),
    (Key: MEMO_NODES_LIST; Value: SORT_ASC),
    (Key: MEMO_FALLBACK_DIRS; Value: SORT_ASC)
  );

implementation

end.
