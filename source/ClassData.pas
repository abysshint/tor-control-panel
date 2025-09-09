unit ClassData;

interface

uses
  Winapi.Windows, System.Generics.Collections, System.Generics.Defaults,
  System.Math, System.SysUtils, ConstData;

const
  NODE_HAS_VALUE = $01;
  NODE_BIT_VALUE = $02;

type
  TValueSet = TNodeTypes;

  PNode = ^TNode;
  TNode = packed record
    Children: array[Boolean] of PNode;
    Value: TValueSet;
    Flags: Byte;
    PrefixLength: Byte;
  end;
  TNodeArray = array[0..(MaxInt div SizeOf(TNode)) - 1] of TNode;
  PNodeArray = ^TNodeArray;

  TCidrValuePair = record
    Cidr: string;
    Value: TValueSet;
  end;
  TCidrValuePairs = TArray<TCidrValuePair>;

  TIPv4 = Cardinal;
  TIPv4CidrInfo = record
    Network: TIPv4;
    PrefixLength: Byte;
  end;

  TIPv6 = array[0..15] of Byte;
  TIPv6CidrInfo = record
    Network: TIPv6;
    PrefixLength: Byte;
  end;

  TArrayHelper = class
  public
    class procedure AddToArray<T>(var Arr: TArray<T>; var Count: Integer; const Value: T); overload; static;
    class procedure AddToArray<T>(var Arr: TArray<T>; const Value: T); overload; static;
  end;

	TNodePool = class
  private
    FBlocks: TList<PNodeArray>;
    FNextFree: PNode;
    FNodesPerBlock: Integer;
    FAllocationFailed: Boolean;
    FLastFailTime: UInt64;
    function TryAllocateBlock(Size: Integer): Boolean;
    procedure RecoverFromOOM;
  public
    constructor Create(InitialSize: Integer = 16);
    destructor Destroy; override;
    function GetNode: PNode;
    procedure ReturnNode(Node: PNode);
    property AllocationFailed: Boolean read FAllocationFailed;
  end;

  TIPv4RadixTree = class
  private
    FRoot: PNode;
    FCount: Integer;
    FNodePool: TNodePool;
    procedure FreeNode(Node: PNode);
    function FindNodeByCIDR(const CIDR: string): PNode;
    function FindExactCIDRInternal(const CIDR: string; const CidrInfo: TIPv4CidrInfo; out Node: PNode): Boolean;
    function FindBestMatchIPInternal(IPValue: TIPv4; out BestMatch: PNode; out Network: TIPv4): Boolean;
    {$IFDEF DEBUG}
    function FindWorstMatchIPInternal(IPValue: TIPv4; out WorstMatch: PNode; out Network: TIPv4): Boolean;
    {$ENDIF}
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure EnumerateAllNodes(var Results: TCidrValuePairs);
    procedure RemoveIncorrectCIDRs;
    function AddOrSetCIDR(const CIDR: string; Value: TValueSet): Boolean;
    function FindAllMatchesIP(const IP: string): TCidrValuePairs;
    function RemoveCIDR(const CIDR: string): Boolean;
    function FindExactCIDR(const CIDR: string; out Value: TValueSet): Boolean; overload;
    function FindBestMatchIP(const IP: string; out Value: TValueSet): Boolean; overload;
    {$IFDEF DEBUG}
    function FindExactCIDR(const CIDR: string; out Pair: TCidrValuePair): Boolean; overload;
    function FindBestMatchIP(const IP: string; out Pair: TCidrValuePair): Boolean; overload;
    function FindWorstMatchIP(const IP: string; out Value: TValueSet): Boolean; overload;
    function FindWorstMatchIP(const IP: string; out Pair: TCidrValuePair): Boolean; overload;
    {$ENDIF}
    property Count: Integer read FCount;
    class function ParseIP(const IP: string; out IPValue: TIPv4): Boolean; static;
    class function ParseCIDR(const CIDR: string; out CidrInfo: TIPv4CidrInfo): Boolean; static;
    class function IPInCIDR(IPValue: TIPv4; const CidrInfo: TIPv4CidrInfo): Boolean; overload; static;
    class function IPInCIDR(const IP: string; const CidrInfo: TIPv4CidrInfo): Boolean; overload; static;
    {$IFDEF DEBUG}
    class function IPInCIDR(const IP: string; const CIDR: string): Boolean; overload; static;
    {$ENDIF}
  private
    class function NetworkToCIDR(const CidrInfo: TIPv4CidrInfo): string; static;
  end;

  TIPv6RadixTree = class
  private
    FRoot: PNode;
    FCount: Integer;
    FNodePool: TNodePool;
    procedure FreeNode(Node: PNode);
    function FindExactCIDRInternal(const CIDR: string; const CidrInfo: TIPv6CidrInfo; out Node: PNode): Boolean;
    function FindBestMatchIPInternal(const IPValue: TIPv6; out BestMatch: PNode; out Network: TIPv6): Boolean;
    {$IFDEF DEBUG}
    function FindWorstMatchIPInternal(const IPValue: TIPv6; out WorstMatch: PNode; out Network: TIPv6): Boolean;
    {$ENDIF}
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure EnumerateAllNodes(var Results: TCidrValuePairs);
    function AddOrSetCIDR(const CIDR: string; Value: TValueSet): Boolean;
    function FindAllMatchesIP(const IP: string): TCidrValuePairs;
    function RemoveCIDR(const CIDR: string): Boolean;
    function FindExactCIDR(const CIDR: string; out Value: TValueSet): Boolean; overload;
    function FindBestMatchIP(const IP: string; out Value: TValueSet): Boolean; overload;
    {$IFDEF DEBUG}
    function FindExactCIDR(const CIDR: string; out Pair: TCidrValuePair): Boolean; overload;
    function FindBestMatchIP(const IP: string; out Pair: TCidrValuePair): Boolean; overload;
    function FindWorstMatchIP(const IP: string; out Value: TValueSet): Boolean; overload;
    function FindWorstMatchIP(const IP: string; out Pair: TCidrValuePair): Boolean; overload;
    {$ENDIF}
    property Count: Integer read FCount;
    class function ParseCIDR(const CIDR: string; out CidrInfo: TIPv6CidrInfo): Boolean; static;
    class function ParseIP(const IP: string; out IPValue: TIPv6): Boolean; static;
    class function IPInCIDR(const IPValue: TIPv6; const CidrInfo: TIPv6CidrInfo): Boolean; overload; static;
    class function IPInCIDR(const IP: string; const CidrInfo: TIPv6CidrInfo): Boolean; overload; static;
    {$IFDEF DEBUG}
    class function IPInCIDR(const IP: string; const CIDR: string): Boolean; overload; static;
    {$ENDIF}
    class function GetBit(const IPValue: TIPv6; BitPosition: Integer): Boolean; static; inline;
  private
    class function IPv6ToBytes(const IP: string): TIPv6; static;
    class function NetworkToCIDR(const CidrInfo: TIPv6CidrInfo): string; static;
    class function ParseHexChar(c: Char): Byte; static; inline;
  end;

  function GetNodeFlag(Node: Pointer; Flag: Byte): Boolean; inline;
  procedure SetNodeFlag(Node: Pointer; Flag: Byte; Value: Boolean); inline;

const
  cDefaultCidrValuePair: TCidrValuePair = (Cidr: ''; VAlue: []);

implementation

{ Common functions }

function GetNodeFlag(Node: Pointer; Flag: Byte): Boolean;
begin
  Result := (PNode(Node)^.Flags and Flag) <> 0;
end;

procedure SetNodeFlag(Node: Pointer; Flag: Byte; Value: Boolean);
begin
  if Value then
    PNode(Node)^.Flags := PNode(Node)^.Flags or Flag
  else
    PNode(Node)^.Flags := PNode(Node)^.Flags and not Flag;
end;

{ TArrayHelper }

class procedure TArrayHelper.AddToArray<T>(var Arr: TArray<T>; var Count: Integer; const Value: T);
var
  ArrLen: Integer;
begin
  ArrLen := Length(Arr);
  if Count >= ArrLen then
    SetLength(Arr, ArrLen + Max(16, ArrLen div 2));
  Arr[Count] := Value;
  Inc(Count);
end;

class procedure TArrayHelper.AddToArray<T>(var Arr: TArray<T>; const Value: T);
var
  ArrLen: Integer;
begin
  ArrLen := Length(Arr);
  SetLength(Arr, ArrLen + 1);
  Arr[ArrLen] := Value;
end;

{ TNodePool }

constructor TNodePool.Create(InitialSize: Integer = 16);
begin
  FBlocks := TList<PNodeArray>.Create;
  FNodesPerBlock := InitialSize;
  FNextFree := nil;
  FAllocationFailed := False;
  FLastFailTime := 0;
  TryAllocateBlock(FNodesPerBlock);
end;

destructor TNodePool.Destroy;
var
  i: Integer;
  Block: PNodeArray;
begin
  for i := 0 to FBlocks.Count - 1 do
  begin
    Block := FBlocks[i];
    FreeMem(Block);
  end;
  FBlocks.Free;
  inherited;
end;

function TNodePool.TryAllocateBlock(Size: Integer): Boolean;
var
  i: Integer;
  NewBlock: PNodeArray;
begin
  Result := False;
  if Size < 16 then Exit;
  try
    GetMem(NewBlock, SizeOf(TNode) * Size);
    if not Assigned(NewBlock) then Exit;

    for I := 0 to Size - 2 do
    begin
      NewBlock^[i].Children[False] := @NewBlock^[i + 1];
      NewBlock^[i].Children[True] := nil;
    end;

    NewBlock^[Size - 1].Children[False] := FNextFree;
    NewBlock^[Size - 1].Children[True] := nil;

    FNextFree := @NewBlock^[0];
    FBlocks.Add(NewBlock);
    Result := True;
  except
    on EOutOfMemory do
    begin
      FLastFailTime := GetTickCount64;
      FAllocationFailed := True;
    end;
  end;

end;

procedure TNodePool.RecoverFromOOM;
begin
  if TryAllocateBlock(FNodesPerBlock) then
  begin
    FAllocationFailed := False;
    Exit;
  end;
  if TryAllocateBlock(Max(16, FNodesPerBlock div 2)) then
  begin
    FAllocationFailed := False;
    FNodesPerBlock := Max(16, FNodesPerBlock div 2);
  end;
end;

function TNodePool.GetNode: PNode;
begin
  if Assigned(FNextFree) then
  begin
    Result := FNextFree;
    FNextFree := Result^.Children[False];
    FillChar(Result^, SizeOf(TNode), 0);
    Exit;
  end;

  if not FAllocationFailed then
  begin
    if not TryAllocateBlock(FNodesPerBlock * 2) then
      FNodesPerBlock := FNodesPerBlock * 2;
  end
  else if GetTickCount64 - FLastFailTime > 5000 then
  begin
    RecoverFromOOM;
  end;

  if Assigned(FNextFree) then
  begin
    Result := FNextFree;
    FNextFree := Result^.Children[False];
    FillChar(Result^, SizeOf(TNode), 0);
  end
  else
    Result := nil;
end;

procedure TNodePool.ReturnNode(Node: PNode);
begin
  if not Assigned(Node) then Exit;
  if FAllocationFailed and (FBlocks.Count > 0) and
     (FBlocks.Count * FNodesPerBlock div 2 < FBlocks.Count * FNodesPerBlock - FBlocks.Count) then
  begin
    FAllocationFailed := False;
  end;

  Node^.Children[False] := FNextFree;
  Node^.Children[True] := nil;
  FNextFree := Node;
end;

{ TIPv4RadixTree }

constructor TIPv4RadixTree.Create;
begin
  FRoot := nil;
  FCount := 0;
  FNodePool := TNodePool.Create;
end;

destructor TIPv4RadixTree.Destroy;
begin
  Clear;
  FNodePool.Free;
  inherited;
end;

procedure TIPv4RadixTree.Clear;
begin
  FreeNode(FRoot);
  FRoot := nil;
  FCount := 0;
end;

procedure TIPv4RadixTree.FreeNode(Node: PNode);
begin
  if Node = nil then Exit;
  FreeNode(Node^.Children[False]);
  FreeNode(Node^.Children[True]);
  FNodePool.ReturnNode(Node);
end;

class function TIPv4RadixTree.ParseIP(const IP: string; out IPValue: TIPv4): Boolean;
var
  P: PChar;
  Octet, I: Integer;
begin
  IPValue := 0;
  P := PChar(IP);

  for I := 0 to 3 do
  begin
    Octet := 0;
    while (P^ >= '0') and (P^ <= '9') do
    begin
      Octet := Octet * 10 + (Ord(P^) - Ord('0'));
      if Octet > 255 then
        Exit(False);
      Inc(P);
    end;
    if (I < 3) and (P^ <> '.') then
      Exit(False);
    PByte(@IPValue)[3 - I] := Octet;
    if I < 3 then Inc(P);
  end;

  Result := P^ = #0;
end;

class function TIPv4RadixTree.NetworkToCIDR(const CidrInfo: TIPv4CidrInfo): string;
begin
  Result := Format('%d.%d.%d.%d/%d', [
    (CidrInfo.Network shr 24) and $FF,
    (CidrInfo.Network shr 16) and $FF,
    (CidrInfo.Network shr 8) and $FF,
    CidrInfo.Network and $FF,
    CidrInfo.PrefixLength
  ]);
end;

class function TIPv4RadixTree.ParseCIDR(const CIDR: string; out CidrInfo: TIPv4CidrInfo): Boolean;
var
  IPStr: string;
  SlashPos, Prefix: Integer;
begin
  Result := False;
  CidrInfo.Network := 0;
  CidrInfo.PrefixLength := 0;

  SlashPos := Pos('/', CIDR);
  if SlashPos < 2 then Exit;

  IPStr := Copy(CIDR, 1, SlashPos - 1);
  if not ParseIP(IPStr, CidrInfo.Network) then Exit;

  if not TryStrToInt(Copy(CIDR, SlashPos + 1, MaxInt), Prefix) then Exit;
  if (Prefix < 0) or (Prefix > 32) then Exit;
  CidrInfo.PrefixLength := Prefix;

  if CidrInfo.PrefixLength < 32 then
    CidrInfo.Network := CidrInfo.Network and (TIPv4($FFFFFFFF) shl (32 - CidrInfo.PrefixLength));

  Result := True;
end;

class function TIPv4RadixTree.IPInCIDR(IPValue: TIPv4; const CidrInfo: TIPv4CidrInfo): Boolean;
var
  NetworkMask: TIPv4;
begin
  if CidrInfo.PrefixLength = 32 then
    Result := IPValue = CidrInfo.Network
  else if CidrInfo.PrefixLength = 0 then
    Result := True
  else
  begin
    NetworkMask := $FFFFFFFF shl (32 - CidrInfo.PrefixLength);
    Result := (IPValue and NetworkMask) = CidrInfo.Network;
  end;
end;

class function TIPv4RadixTree.IPInCIDR(const IP: string; const CidrInfo: TIPv4CidrInfo): Boolean;
var
  IPValue: TIPv4;
begin
  Result := ParseIP(IP, IPValue) and
            IPInCIDR(IPValue, CidrInfo);
end;

{$IFDEF DEBUG}
class function TIPv4RadixTree.IPInCIDR(const IP: string; const CIDR: string): Boolean;
var
  IPValue: TIPv4;
  CidrInfo: TIPv4CidrInfo;
begin
  Result := ParseIP(IP, IPValue) and
            ParseCIDR(CIDR, CidrInfo) and
            IPInCIDR(IPValue, CidrInfo);
end;
{$ENDIF}

function TIPv4RadixTree.AddOrSetCIDR(const CIDR: string; Value: TValueSet): Boolean;
var
  CidrInfo: TIPv4CidrInfo;
  Node: PNode;
  BitPos: Integer;
  Bit: Boolean;
begin
  if not ParseCIDR(CIDR, CidrInfo) then
    Exit(False);
  if FRoot = nil then
    FRoot := FNodePool.GetNode;
  Node := FRoot;
  for BitPos := 0 to CidrInfo.PrefixLength - 1 do
  begin
    Bit := (CidrInfo.Network and (TIPv4(1) shl (31 - BitPos))) <> 0;
    if Node^.Children[Bit] = nil then
    begin
      Node^.Children[Bit] := FNodePool.GetNode;
      SetNodeFlag(Node^.Children[Bit], NODE_BIT_VALUE, Bit);
    end;
    Node := Node^.Children[Bit];
  end;

  if not GetNodeFlag(Node, NODE_HAS_VALUE) then Inc(FCount);
  Node^.Value := Value;
  Node^.PrefixLength := CidrInfo.PrefixLength;
  SetNodeFlag(Node, NODE_HAS_VALUE, True);
  Result := True;
end;

function TIPv4RadixTree.RemoveCIDR(const CIDR: string): Boolean;
var
  CidrInfo: TIPv4CidrInfo;
  Path: array of PNode;
  Node, Parent: PNode;
  BitPos, i: Integer;
  Bit, CanFree: Boolean;
begin
  if FRoot = nil then Exit(False);
  if not ParseCIDR(CIDR, CidrInfo) then
    Exit(False);

  SetLength(Path, CidrInfo.PrefixLength + 1);
  Node := FRoot;
  Path[0] := FRoot;

  for BitPos := 0 to CidrInfo.PrefixLength - 1 do
  begin
    Bit := (CidrInfo.Network and (TIPv4(1) shl (31 - BitPos))) <> 0;
    Node := Node^.Children[Bit];
    if Node = nil then Exit(False);
    Path[BitPos + 1] := Node;
  end;

  if not GetNodeFlag(Node, NODE_HAS_VALUE) then
    Exit(False);
  Dec(FCount);
  SetNodeFlag(Node, NODE_HAS_VALUE, False);
  Node^.Value := [];

  for I := High(Path) downto 0 do
  begin
    Node := Path[i];
    CanFree := not GetNodeFlag(Node, NODE_HAS_VALUE)
               and (Node^.Children[False] = nil)
               and (Node^.Children[True] = nil);
    if not CanFree then Break;

    if I > 0 then
    begin
      Parent := Path[i - 1];
      Bit := GetNodeFlag(Node, NODE_BIT_VALUE);
      Parent^.Children[Bit] := nil;
    end
    else
      FRoot := nil;

    FNodePool.ReturnNode(Node);
  end;

  Result := True;
end;

function TIPv4RadixTree.FindExactCIDRInternal(const CIDR: string; const CidrInfo: TIPv4CidrInfo; out Node: PNode): Boolean;
var
  BitPos: Integer;
  Bit: Boolean;
begin
  Node := FRoot;
  for BitPos := 0 to CidrInfo.PrefixLength - 1 do
  begin
    Bit := (CidrInfo.Network and (TIPv4(1) shl (31 - BitPos))) <> 0;
    Node := Node^.Children[Bit];
    if Node = nil then Exit(False);
  end;
  Result := GetNodeFlag(Node, NODE_HAS_VALUE);
end;

function TIPv4RadixTree.FindExactCIDR(const CIDR: string; out Value: TValueSet): Boolean;
var
  CidrInfo: TIPv4CidrInfo;
  Node: PNode;
begin
  if FRoot = nil then Exit(False);
  if not ParseCIDR(CIDR, CidrInfo) then
    Exit(False);
  Result := FindExactCIDRInternal(CIDR, CidrInfo, Node);
  if Result then
    Value := Node^.Value
  else
    Value := [];
end;

{$IFDEF DEBUG}
function TIPv4RadixTree.FindExactCIDR(const CIDR: string; out Pair: TCidrValuePair): Boolean;
var
  CidrInfo: TIPv4CidrInfo;
  Node: PNode;
begin
  if FRoot = nil then Exit(False);
  if not ParseCIDR(CIDR, CidrInfo) then
    Exit(False);
  Result := FindExactCIDRInternal(CIDR, CidrInfo, Node);
  if Result then
  begin
    Pair.Cidr := NetworkToCIDR(CidrInfo);
    Pair.Value := Node^.Value;
  end
  else
    Pair := cDefaultCidrValuePair;
end;
{$ENDIF}

function TIPv4RadixTree.FindBestMatchIPInternal(IPValue: TIPv4; out BestMatch: PNode; out Network: TIPv4): Boolean;
var
  Node: PNode;
  BitPos: Integer;
  Bit: Boolean;
begin
  BestMatch := nil;
  Network := 0;
  Node := FRoot;

  for BitPos := 0 to 31 do
  begin
    if GetNodeFlag(Node, NODE_HAS_VALUE) then
    begin
      BestMatch := Node;
      Network := IPValue and (TIPv4($FFFFFFFF) shl (32 - BitPos));
    end;

    Bit := (IPValue and (TIPv4(1) shl (31 - BitPos))) <> 0;
    Node := Node^.Children[Bit];
    if Node = nil then Break;
  end;

  if (Node <> nil) and GetNodeFlag(Node, NODE_HAS_VALUE) then
  begin
    BestMatch := Node;
    Network := IPValue;
  end;
  Result := (BestMatch <> nil) and GetNodeFlag(BestMatch, NODE_HAS_VALUE);
end;

function TIPv4RadixTree.FindBestMatchIP(const IP: string; out Value: TValueSet): Boolean;
var
  IPValue, Network: TIPv4;
  BestMatch: PNode;
begin
  if FRoot = nil then Exit(False);
  if not ParseIP(IP, IPValue) then
    Exit(False);
  Result := FindBestMatchIPInternal(IPValue, BestMatch, Network);
  if Result then
    Value := BestMatch^.Value
  else
    Value := [];
end;

{$IFDEF DEBUG}
function TIPv4RadixTree.FindBestMatchIP(const IP: string; out Pair: TCidrValuePair): Boolean;
var
  BestMatch: PNode;
  IPValue, Network: TIPv4;
  CidrInfo: TIPv4CidrInfo;
begin
  if FRoot = nil then Exit(False);
  if not ParseIP(IP, IPValue) then
    Exit(False);
  Result := FindBestMatchIPInternal(IPValue, BestMatch, Network);
  if Result then
  begin
    CidrInfo.Network := Network;
    CidrInfo.PrefixLength := BestMatch^.PrefixLength;
    Pair.Cidr := NetworkToCIDR(CidrInfo);
    Pair.Value := BestMatch^.Value;
  end
  else
    Pair := cDefaultCidrValuePair;
end;

function TIPv4RadixTree.FindWorstMatchIPInternal(IPValue: TIPv4; out WorstMatch: PNode; out Network: TIPv4): Boolean;
var
  Node: PNode;
  BitPos: Integer;
  Bit: Boolean;
begin
  WorstMatch := nil;
  Network := 0;
  Node := FRoot;

  if GetNodeFlag(Node, NODE_HAS_VALUE) then
  begin
    WorstMatch := Node;
    Network := 0;
  end;

  for BitPos := 0 to 31 do
  begin
    Bit := (IPValue and (TIPv4(1) shl (31 - BitPos)) <> 0);
    Node := Node^.Children[Bit];
    if Node = nil then Break;

    if (WorstMatch = nil) and GetNodeFlag(Node, NODE_HAS_VALUE) then
    begin
      WorstMatch := Node;
      Network := IPValue and (TIPv4($FFFFFFFF) shl (32 - BitPos - 1));
    end;
  end;

  if (WorstMatch = nil) and GetNodeFlag(FRoot, NODE_HAS_VALUE) then
  begin
    WorstMatch := FRoot;
    Network := 0;
  end;

  Result := (WorstMatch <> nil);
end;

function TIPv4RadixTree.FindWorstMatchIP(const IP: string; out Value: TValueSet): Boolean;
var
  IPValue, Network: TIPv4;
  WorstMatch: PNode;
begin
  if FRoot = nil then Exit(False);
  if not ParseIP(IP, IPValue) then
    Exit(False);
  Result := FindWorstMatchIPInternal(IPValue, WorstMatch, Network);
  if Result then
    Value := WorstMatch^.Value
  else
    Value := [];
end;

function TIPv4RadixTree.FindWorstMatchIP(const IP: string; out Pair: TCidrValuePair): Boolean;
var
  IPValue, Network: TIPv4;
  WorstMatch: PNode;
  CidrInfo: TIPv4CidrInfo;
begin
  if FRoot = nil then Exit(False);
  if not ParseIP(IP, IPValue) then
    Exit(False);
  Result := FindWorstMatchIPInternal(IPValue, WorstMatch, Network);
  if Result then
  begin
    CidrInfo.Network := Network;
    CidrInfo.PrefixLength := WorstMatch^.PrefixLength;
    Pair.Cidr := NetworkToCIDR(CidrInfo);
    Pair.Value := WorstMatch^.Value;
  end
  else
    Pair := cDefaultCidrValuePair;
end;
{$ENDIF}

function TIPv4RadixTree.FindAllMatchesIP(const IP: string): TCidrValuePairs;
var
  IPValue, Network: TIPv4;
  Node: PNode;
  BitPos: Integer;
  Bit: Boolean;
  CidrInfo: TIPv4CidrInfo;
begin
  Result := nil;
  if FRoot = nil then Exit;
  if not ParseIP(IP, IPValue) then Exit;

  Network := 0;
  Node := FRoot;
  for BitPos := 0 to 31 do
  begin
    if GetNodeFlag(Node, NODE_HAS_VALUE) then
    begin
      SetLength(Result, Length(Result) + 1);
      CidrInfo.Network := Network;
      CidrInfo.PrefixLength := Node^.PrefixLength;
      Result[High(Result)].Cidr := NetworkToCIDR(CidrInfo);
      Result[High(Result)].Value := Node^.Value;
    end;

    Bit := (IPValue and (TIPv4(1) shl (31 - BitPos))) <> 0;
    Node := Node^.Children[Bit];
    if Node = nil then Exit;

    if Bit then
      Network := Network or (TIPv4(1) shl (31 - BitPos));
  end;

  if (Node <> nil) and GetNodeFlag(Node, NODE_HAS_VALUE) then
  begin
    SetLength(Result, Length(Result) + 1);
    CidrInfo.Network := Network;
    CidrInfo.PrefixLength := Node^.PrefixLength;
    Result[High(Result)].Cidr := NetworkToCIDR(CidrInfo);
    Result[High(Result)].Value := Node^.Value;
  end;
end;

procedure TIPv4RadixTree.EnumerateAllNodes(var Results: TCidrValuePairs);
type
  TStackItem = record
    Node: PNode;
    Network: TIPv4;
    Prefix: Integer;
  end;
var
  Stack: array of TStackItem;
  StackPos: Integer;
  Current: TStackItem;
  CidrInfo: TIPv4CidrInfo;
begin
  SetLength(Results, 0);
  if FRoot = nil then Exit;

  SetLength(Stack, 33);
  Stack[0].Node := FRoot;
  Stack[0].Network := 0;
  Stack[0].Prefix := 0;
  StackPos := 0;

  while StackPos >= 0 do
  begin
    Current := Stack[StackPos];
    Dec(StackPos);

    if (Current.Node^.Flags and NODE_HAS_VALUE) <> 0 then
    begin
      SetLength(Results, Length(Results) + 1);
      CidrInfo.Network := Current.Network;
      CidrInfo.PrefixLength := Current.Node^.PrefixLength;
      Results[High(Results)].Cidr := NetworkToCIDR(CidrInfo);
      Results[High(Results)].Value := Current.Node^.Value;
    end;

    if Current.Node^.Children[True] <> nil then
    begin
      Inc(StackPos);
      Stack[StackPos].Node := Current.Node^.Children[True];
      Stack[StackPos].Network := Current.Network or (TIPv4(1) shl (31 - Current.Prefix));
      Stack[StackPos].Prefix := Current.Prefix + 1;
    end;

    if Current.Node^.Children[False] <> nil then
    begin
      Inc(StackPos);
      Stack[StackPos].Node := Current.Node^.Children[False];
      Stack[StackPos].Network := Current.Network;
      Stack[StackPos].Prefix := Current.Prefix + 1;
    end;
  end;
end;

function TIPv4RadixTree.FindNodeByCIDR(const CIDR: string): PNode;
var
  BitPos: Integer;
  Bit: Boolean;
  CidrInfo: TIPv4CidrInfo;
begin
  Result := nil;
  if not ParseCIDR(CIDR, CidrInfo) then Exit;

  Result := FRoot;
  for BitPos := 0 to CidrInfo.PrefixLength - 1 do
  begin
    if Result = nil then Exit;
    Bit := (CidrInfo.Network and (Cardinal(1) shl (31 - BitPos))) <> 0;
    Result := Result.Children[Bit];
  end;
end;

procedure TIPv4RadixTree.RemoveIncorrectCIDRs;
type
  TNetworkInfo = record
    Network: TIPv4;
    Prefix: Byte;
    Value: TValueSet;
    CIDR: string;
  end;
  TNetworkArray = TArray<TNetworkInfo>;
var
  NetworksByPrefix: array[0..32] of TNetworkArray;
  Counts: array[0..32] of Integer;
  NodesToRemove: THashSet<string>;
  Results: TCidrValuePairs;
  CidrInfo: TIPv4CidrInfo;
  Masks: array[0..32] of TIPv4;
  CIDR: string;
  i,j: Integer;
  NetInfo: TNetworkInfo;
  Node: PNode;

  procedure ProcessChild(const Parent: TNetworkInfo; const Child: TNetworkInfo);
  begin
    if ntExclude in Parent.Value then
      NodesToRemove.Add(Child.CIDR)
    else if ntExclude in Child.Value then
      NodesToRemove.Add(Parent.CIDR)
    else if (Child.Value = Parent.Value) then
      NodesToRemove.Add(Child.CIDR);
  end;

  procedure ProcessSupernetParent(const Parent: TNetworkInfo);
  var
    i,j: Integer;
  begin
    for i := 0 to 32 do
    begin
      if Counts[i] = 0 then Continue;
      for j := 0 to Counts[i] - 1 do
      begin
        var Child := NetworksByPrefix[i][j];
        if (Child.Prefix > Parent.Prefix) and (Child.Network <> Parent.Network) then
          ProcessChild(Parent, Child);
      end;
    end;
  end;

  procedure ProcessNormalParent(const Parent: TNetworkInfo);
  var
    ParentMask, ChildNetworkMasked, ParentNetworkMasked: TIPv4;
    LowIdx, HighIdx, MidIdx, LeftIdx, RightIdx, i: Integer;
    CompareResult: ShortInt;
    Child: TNetworkInfo;
  begin
    ParentMask := Masks[Parent.Prefix];
    ParentNetworkMasked := Parent.Network and ParentMask;

    for i := Parent.Prefix + 1 to 32 do
    begin
      if Counts[i] = 0 then Continue;

      LowIdx := 0;
      HighIdx := Counts[i] - 1;

      while LowIdx <= HighIdx do
      begin
        MidIdx := (LowIdx + HighIdx) div 2;
        Child := NetworksByPrefix[i][MidIdx];
        ChildNetworkMasked := Child.Network and ParentMask;

        CompareResult := CompareValue(ChildNetworkMasked, ParentNetworkMasked);

        if CompareResult = 0 then
        begin
          LeftIdx := MidIdx - 1;
          while (LeftIdx >= LowIdx) and
                ((NetworksByPrefix[i][LeftIdx].Network and ParentMask) = ParentNetworkMasked) do
          begin
            ProcessChild(Parent, NetworksByPrefix[i][LeftIdx]);
            Dec(LeftIdx);
          end;
          ProcessChild(Parent, Child);

          RightIdx := MidIdx + 1;
          while (RightIdx <= HighIdx) and
                ((NetworksByPrefix[i][RightIdx].Network and ParentMask) = ParentNetworkMasked) do
          begin
            ProcessChild(Parent, NetworksByPrefix[i][RightIdx]);
            Inc(RightIdx);
          end;

          Break;
        end
        else if CompareResult < 0 then
          LowIdx := MidIdx + 1
        else
          HighIdx := MidIdx - 1;
      end;
    end;
  end;

begin
  for i := 0 to 32 do
    Masks[i] := TIPv4($FFFFFFFF) shl (32 - i);

  NodesToRemove := THashSet<string>.Create;
  try
    FillChar(Counts, SizeOf(Counts), 0);
    EnumerateAllNodes(Results);

    for i := 0 to High(Results) do
    begin
      if ParseCIDR(Results[i].Cidr, CidrInfo) then
        Inc(Counts[CidrInfo.PrefixLength]);
    end;

    for i := 0 to 32 do
      SetLength(NetworksByPrefix[i], Counts[i]);

    FillChar(Counts, SizeOf(Counts), 0);

    for i := 0 to High(Results) do
    begin
      if ParseCIDR(Results[i].Cidr, CidrInfo) then
      begin
        NetInfo.Network := CidrInfo.Network;
        NetInfo.Prefix := CidrInfo.PrefixLength;
        NetInfo.CIDR := Results[i].Cidr;
        NetInfo.Value := Results[i].Value;

        if (ntExclude in NetInfo.Value) and (NetInfo.Value <> [ntExclude]) then
        begin
          NetInfo.Value := [ntExclude];
          Node := FindNodeByCIDR(NetInfo.CIDR);
          if Node <> nil then
            Node.Value := [ntExclude];
        end;

        NetworksByPrefix[CidrInfo.PrefixLength][Counts[CidrInfo.PrefixLength]] := NetInfo;
        Inc(Counts[CidrInfo.PrefixLength]);
      end;
    end;

    for i := 0 to 32 do
    begin
      if Counts[i] > 0 then
      begin
        TArray.Sort<TNetworkInfo>(NetworksByPrefix[i], TComparer<TNetworkInfo>.Construct(
          function(const Left, Right: TNetworkInfo): Integer
          begin
            Result := CompareValue(Left.Network, Right.Network);
          end
        ));
      end;
    end;

    for i := 0 to 32 do
    begin
      if Counts[i] = 0 then
        Continue;
      for j := 0 to Counts[i] - 1 do
      begin
        NetInfo := NetworksByPrefix[i][j];
        if (i = 0) and (NetInfo.Network = 0) then
          ProcessSupernetParent(NetInfo)
        else
          ProcessNormalParent(NetInfo);
      end;
    end;

    for CIDR in NodesToRemove do
      RemoveCIDR(CIDR);

  finally
    NodesToRemove.Free;
  end;
end;

{ TIPv6RadixTree }

constructor TIPv6RadixTree.Create;
begin
  FRoot := nil;
  FCount := 0;
  FNodePool := TNodePool.Create;
end;

destructor TIPv6RadixTree.Destroy;
begin
  Clear;
  FNodePool.Free;
  inherited;
end;

procedure TIPv6RadixTree.Clear;
begin
  FreeNode(FRoot);
  FRoot := nil;
  FCount := 0;
end;

procedure TIPv6RadixTree.FreeNode(Node: PNode);
begin
  if Node = nil then Exit;
  FreeNode(Node^.Children[False]);
  FreeNode(Node^.Children[True]);
  FNodePool.ReturnNode(Node);
end;

class function TIPv6RadixTree.ParseHexChar(c: Char): Byte;
begin
  case c of
    '0'..'9': Result := Ord(c) - Ord('0');
    'a'..'f': Result := Ord(c) - Ord('a') + 10;
    'A'..'F': Result := Ord(c) - Ord('A') + 10;
  else
    Result := 0;
  end;
end;

class function TIPv6RadixTree.IPv6ToBytes(const IP: string): TIPv6;
var
  i, j, ColonCount, ZeroPos, NumParts: Integer;
  Parts: array[0..7] of Word;
  Chars: array[0..3] of Char;
  PartStr: string;
  Expanded: string;
  P: PChar;
begin
  FillChar(Result, SizeOf(Result), 0);
  if IP = '::' then Exit;

  ColonCount := 0;
  for i := 1 to Length(IP) do
    if IP[i] = ':' then Inc(ColonCount);

  if ColonCount < 7 then
  begin
    ZeroPos := Pos('::', IP);
    if ZeroPos > 0 then
    begin
      PartStr := Copy(IP, 1, ZeroPos - 1);
      Expanded := PartStr;
      for I := 1 to 8 - ColonCount do
        Expanded := Expanded + ':0';
      if ZeroPos + 1 <= Length(IP) then
        Expanded := Expanded + ':' + Copy(IP, ZeroPos + 2, MaxInt);
    end
    else
      Expanded := IP;
  end
  else
    Expanded := IP;

  NumParts := 0;
  P := PChar(Expanded);
  while (P^ <> #0) and (NumParts < 8) do
  begin
    I := 0;
    while (P^ <> ':') and (P^ <> #0) and (I < 4) do
    begin
      Chars[i] := P^;
      Inc(I);
      Inc(P);
    end;
    if P^ = ':' then Inc(P);

    Parts[NumParts] := 0;
    for J := 0 to I - 1 do
      Parts[NumParts] := (Parts[NumParts] shl 4) or ParseHexChar(Chars[j]);
    Inc(NumParts);
  end;

  for I := 0 to 7 do
  begin
    Result[i * 2] := Hi(Parts[i]);
    Result[i * 2 + 1] := Lo(Parts[i]);
  end;
end;

class function TIPv6RadixTree.NetworkToCIDR(const CidrInfo: TIPv6CidrInfo): string;
var
  i: Integer;
  ZeroStart, ZeroEnd: Integer;
  MaxZeroLength, CurrentZeroLength: Integer;
  Parts: array[0..7] of Word;
  Output: TStringBuilder;
  InZeroBlock: Boolean;
begin
  for I := 0 to 7 do
    Parts[i] := (CidrInfo.Network[I*2] shl 8) or CidrInfo.Network[I*2+1];

  ZeroStart := -1;
  ZeroEnd := -1;
  MaxZeroLength := 0;
  CurrentZeroLength := 0;

  for I := 0 to 7 do
  begin
    if Parts[i] = 0 then
    begin
      Inc(CurrentZeroLength);
      if (CurrentZeroLength > MaxZeroLength) then
      begin
        MaxZeroLength := CurrentZeroLength;
        ZeroEnd := i;
        ZeroStart := I - CurrentZeroLength + 1;
      end;
    end
    else
      CurrentZeroLength := 0;
  end;

  Output := TStringBuilder.Create;
  try
    InZeroBlock := False;

    for i := 0 to 7 do
    begin
      if (MaxZeroLength > 1) and (I >= ZeroStart) and (I <= ZeroEnd) then
      begin
        if not InZeroBlock then
        begin
          if (i = 0) then
            Output.Append('::')
          else if (Output.Length > 0) and (Output.Chars[Output.Length-1] <> ':') then
            Output.Append('::')
          else
            Output.Append(':');
          InZeroBlock := True;
        end;
        Continue;
      end;

      if (Output.Length > 0) and not InZeroBlock and
         (Output.Chars[Output.Length - 1] <> ':') then
        Output.Append(':');

      Output.Append(IntToHex(Parts[i], 1));
      InZeroBlock := False;
    end;

    if Output.Length = 0 then
      Output.Append('::')
    else if (Output.Chars[0] = ':') and (Output.Length = 1) then
      Output.Insert(0, ':');
    Result := LowerCase(Output.ToString) + '/' + IntToStr(CidrInfo.PrefixLength);
  finally
    Output.Free;
  end;
end;

class function TIPv6RadixTree.ParseCIDR(const CIDR: string; out CidrInfo: TIPv6CidrInfo): Boolean;
var
  SlashPos, Prefix: Integer;
  IPStr: string;
  i: Integer;
  BitsLeft: Integer;
begin
  Result := False;
  FillChar(CidrInfo.Network, SizeOf(CidrInfo.Network), 0);
  CidrInfo.PrefixLength := 0;

  SlashPos := Pos('/', CIDR);
  if SlashPos < 2 then Exit;

  IPStr := Copy(CIDR, 1, SlashPos - 1);
  CidrInfo.Network := IPv6ToBytes(IPStr);

  if not TryStrToInt(Copy(CIDR, SlashPos + 1, MaxInt), Prefix) then Exit;
  if (Prefix < 0) or (Prefix > 128) then Exit;
  CidrInfo.PrefixLength := Prefix;

  BitsLeft := CidrInfo.PrefixLength;
  for I := 0 to 15 do
  begin
    if BitsLeft <= 0 then
      CidrInfo.Network[i] := 0
    else if BitsLeft < 8 then
      CidrInfo.Network[i] := CidrInfo.Network[i] and (Byte($FF) shl (8 - BitsLeft));
    Dec(BitsLeft, 8);
  end;

  Result := True;
end;

class function TIPv6RadixTree.ParseIP(const IP: string; out IPValue: TIPv6): Boolean;
begin
  IPValue := IPv6ToBytes(IP);
  Result := True;
end;

class function TIPv6RadixTree.IPInCIDR(const IPValue: TIPv6; const CidrInfo: TIPv6CidrInfo): Boolean;
var
  I: Integer;
begin
  for I := 0 to CidrInfo.PrefixLength - 1 do
    if GetBit(IPValue, I) <> GetBit(CidrInfo.Network, I) then
      Exit(False);
  Result := True;
end;

class function TIPv6RadixTree.IPInCIDR(const IP: string; const CidrInfo: TIPv6CidrInfo): Boolean;
var
  IPValue: TIPv6;
begin
  Result := ParseIP(IP, IPValue) and
            IPInCIDR(IPValue, CidrInfo);
end;

{$IFDEF DEBUG}
class function TIPv6RadixTree.IPInCIDR(const IP: string; const CIDR: string): Boolean;
var
  IPValue: TIPv6;
  CidrInfo: TIPv6CidrInfo;
begin
  Result := ParseIP(IP, IPValue) and
            ParseCIDR(CIDR, CidrInfo) and
            IPInCIDR(IPValue, CidrInfo);
end;
{$ENDIF}

class function TIPv6RadixTree.GetBit(const IPValue: TIPv6; BitPosition: Integer): Boolean;
var
  BytePos: Integer;
  BitInByte: Integer;
begin
  BytePos := BitPosition div 8;
  BitInByte := 7 - (BitPosition mod 8);
  Result := (IPValue[BytePos] and (1 shl BitInByte)) <> 0;
end;

function TIPv6RadixTree.AddOrSetCIDR(const CIDR: string; Value: TValueSet): Boolean;
var
  Node: PNode;
  BitPos: Integer;
  Bit: Boolean;
  CidrInfo: TIPv6CidrInfo;
begin
  if not ParseCIDR(CIDR, CidrInfo) then
    Exit(False);
  if FRoot = nil then
    FRoot := FNodePool.GetNode;
  Node := FRoot;
  for BitPos := 0 to CidrInfo.PrefixLength - 1 do
  begin
    Bit := GetBit(CidrInfo.Network, BitPos);
    if Node^.Children[Bit] = nil then
    begin
      Node^.Children[Bit] := FNodePool.GetNode;
      SetNodeFlag(Node^.Children[Bit], NODE_BIT_VALUE, Bit);
    end;
    Node := Node^.Children[Bit];
  end;

  if not GetNodeFlag(Node, NODE_HAS_VALUE) then Inc(FCount);
  Node^.Value := Value;
  Node^.PrefixLength := CidrInfo.PrefixLength;
  SetNodeFlag(Node, NODE_HAS_VALUE, True);
  Result := True;
end;

function TIPv6RadixTree.RemoveCIDR(const CIDR: string): Boolean;
var
  Path: array of PNode;
  Node, Parent: PNode;
  BitPos, i: Integer;
  Bit, CanFree: Boolean;
  CidrInfo: TIPv6CidrInfo;
begin
  if FRoot = nil then Exit(False);
  if not ParseCIDR(CIDR, CidrInfo) then
    Exit(False);

  SetLength(Path, CidrInfo.PrefixLength + 1);
  Node := FRoot;
  Path[0] := FRoot;

  for BitPos := 0 to CidrInfo.PrefixLength - 1 do
  begin
    Bit := GetBit(CidrInfo.Network, BitPos);
    Node := Node^.Children[Bit];
    if Node = nil then Exit(False);
    Path[BitPos + 1] := Node;
  end;

  if GetNodeFlag(Node, NODE_HAS_VALUE) then
  begin
    Dec(FCount);
    SetNodeFlag(Node, NODE_HAS_VALUE, False);
    Node^.Value := [];
  end
  else
    Exit(False);

  for I := High(Path) downto 0 do
  begin
    Node := Path[i];
    CanFree := not GetNodeFlag(Node, NODE_HAS_VALUE)
               and (Node^.Children[False] = nil)
               and (Node^.Children[True] = nil);

    if not CanFree then Break;

    if i > 0 then
    begin
      Parent := Path[i - 1];
      Bit := GetNodeFlag(Node, NODE_BIT_VALUE);
      Parent^.Children[Bit] := nil;
    end
    else
      FRoot := nil;

    FNodePool.ReturnNode(Node);
  end;

  Result := True;
end;

function TIPv6RadixTree.FindExactCIDRInternal(const CIDR: string; const CidrInfo: TIPv6CidrInfo; out Node: PNode): Boolean;
var
  BitPos: Integer;
  Bit: Boolean;
begin
  Node := FRoot;
  for BitPos := 0 to CidrInfo.PrefixLength - 1 do
  begin
    Bit := GetBit(CidrInfo.Network, BitPos);
    Node := Node^.Children[Bit];
    if Node = nil then Exit(False);
  end;
  Result := GetNodeFlag(Node, NODE_HAS_VALUE);
end;

function TIPv6RadixTree.FindExactCIDR(const CIDR: string; out Value: TValueSet): Boolean;
var
  CidrInfo: TIPv6CidrInfo;
  Node: PNode;
begin
  if FRoot = nil then Exit(False);
  if not ParseCIDR(CIDR, CidrInfo) then
    Exit(False);
  Result := FindExactCIDRInternal(CIDR, CidrInfo, Node);
  if Result then
    Value := Node^.Value
  else
    Value := [];
end;

{$IFDEF DEBUG}
function TIPv6RadixTree.FindExactCIDR(const CIDR: string; out Pair: TCidrValuePair): Boolean;
var
  CidrInfo: TIPv6CidrInfo;
  Node: PNode;
begin
  if FRoot = nil then Exit(False);
  if not ParseCIDR(CIDR, CidrInfo) then
    Exit(False);
  Result := FindExactCIDRInternal(CIDR, CidrInfo, Node);
  if Result then
  begin
    Pair.Cidr := NetworkToCIDR(CidrInfo);
    Pair.Value := Node^.Value;
  end
  else
    Pair := cDefaultCidrValuePair;
end;
{$ENDIF}

function TIPv6RadixTree.FindBestMatchIPInternal(const IPValue: TIPv6; out BestMatch: PNode; out Network: TIPv6): Boolean;
var
  Node: PNode;
  BitPos: Integer;
  Bit: Boolean;
  I: Integer;
begin
  BestMatch := nil;
  FillChar(Network, SizeOf(Network), 0);
  Node := FRoot;

  for BitPos := 0 to 127 do
  begin
    if GetNodeFlag(Node, NODE_HAS_VALUE) then
    begin
      BestMatch := Node;
      FillChar(Network, SizeOf(Network), 0);
      for I := 0 to BitPos-1 do
      begin
        if GetBit(IPValue, I) then
          Network[I div 8] := Network[I div 8] or (1 shl (7 - (I mod 8)));
      end;
    end;

    Bit := GetBit(IPValue, BitPos);
    Node := Node^.Children[Bit];
    if Node = nil then Break;
  end;

  if (Node <> nil) and GetNodeFlag(Node, NODE_HAS_VALUE) then
  begin
    BestMatch := Node;
    Network := IPValue;
  end;

  Result := (BestMatch <> nil);
end;

function TIPv6RadixTree.FindBestMatchIP(const IP: string; out Value: TValueSet): Boolean;
var
  IPValue, Network: TIPv6;
  BestMatch: PNode;
begin
  if FRoot = nil then Exit(False);
  if not ParseIP(IP, IPValue) then
    Exit(False);
  Result := FindBestMatchIPInternal(IPValue, BestMatch, Network);
  if Result then
    Value := BestMatch^.Value
  else
    Value := [];
end;

{$IFDEF DEBUG}
function TIPv6RadixTree.FindBestMatchIP(const IP: string; out Pair: TCidrValuePair): Boolean;
var
  IPValue, Network: TIPv6;
  BestMatch: PNode;
  CidrInfo: TIPv6CidrInfo;
begin
  if FRoot = nil then Exit(False);
  if not ParseIP(IP, IPValue) then
    Exit(False);
  Result := FindBestMatchIPInternal(IPValue, BestMatch, Network);
  if Result then
  begin
    CidrInfo.Network := Network;
    CidrInfo.PrefixLength := BestMatch^.PrefixLength;
    Pair.Cidr := NetworkToCIDR(CidrInfo);
    Pair.Value := BestMatch^.Value;
  end
  else
    Pair := cDefaultCidrValuePair;
end;

function TIPv6RadixTree.FindWorstMatchIPInternal(const IPValue: TIPv6; out WorstMatch: PNode; out Network: TIPv6): Boolean;
var
  Node: PNode;
  BitPos: Integer;
  Bit: Boolean;
  I: Integer;
begin
  WorstMatch := nil;
  FillChar(Network, SizeOf(Network), 0);
  Node := FRoot;

  if GetNodeFlag(Node, NODE_HAS_VALUE) then
  begin
    WorstMatch := Node;
    FillChar(Network, SizeOf(Network), 0);
  end;

  for BitPos := 0 to 127 do
  begin
    Bit := GetBit(IPValue, BitPos);
    Node := Node^.Children[Bit];
    if Node = nil then Break;

    if (WorstMatch = nil) and GetNodeFlag(Node, NODE_HAS_VALUE) then
    begin
      WorstMatch := Node;
      FillChar(Network, SizeOf(Network), 0);
      for I := 0 to BitPos do
      begin
        if GetBit(IPValue, I) then
          Network[I div 8] := Network[I div 8] or (1 shl (7 - (I mod 8)));
      end;
    end;
  end;

  if (WorstMatch = nil) and GetNodeFlag(FRoot, NODE_HAS_VALUE) then
  begin
    WorstMatch := FRoot;
    FillChar(Network, SizeOf(Network), 0);
  end;

  Result := (WorstMatch <> nil);
end;

function TIPv6RadixTree.FindWorstMatchIP(const IP: string; out Value: TValueSet): Boolean;
var
  IPValue, Network: TIPv6;
  WorstMatch: PNode;
begin
  if FRoot = nil then Exit(False);
  if not ParseIP(IP, IPValue) then
    Exit(False);
  Result := FindWorstMatchIPInternal(IPValue, WorstMatch, Network);
  if Result then
    Value := WorstMatch^.Value
  else
    Value := [];
end;

function TIPv6RadixTree.FindWorstMatchIP(const IP: string; out Pair: TCidrValuePair): Boolean;
var
  IPValue, Network: TIPv6;
  WorstMatch: PNode;
  CidrInfo: TIPv6CidrInfo;
begin
  if FRoot = nil then Exit(False);
  if not ParseIP(IP, IPValue) then
    Exit(False);
  Result := FindWorstMatchIPInternal(IPValue, WorstMatch, Network);
  if Result then
  begin
    CidrInfo.Network := Network;
    CidrInfo.PrefixLength := WorstMatch^.PrefixLength;
    Pair.Cidr := NetworkToCIDR(CidrInfo);
    Pair.Value := WorstMatch^.Value;
  end
  else
    Pair := cDefaultCidrValuePair;
end;
{$ENDIF}

function TIPv6RadixTree.FindAllMatchesIP(const IP: string): TCidrValuePairs;
var
  IPValue: TIPv6;
  Node: PNode;
  BitPos: Integer;
  Bit: Boolean;
  Network: TIPv6;
  BytePos, BitInByte: Integer;
  CidrInfo: TIPv6CidrInfo;
begin
  Result := nil;
  if FRoot = nil then Exit;
  if not ParseIP(IP, IPValue) then Exit;

  FillChar(Network, SizeOf(Network), 0);
  Node := FRoot;
  for BitPos := 0 to 127 do
  begin
    if GetNodeFlag(Node, NODE_HAS_VALUE) then
    begin
      SetLength(Result, Length(Result) + 1);
      CidrInfo.Network := Network;
      CidrInfo.PrefixLength := Node^.PrefixLength;
      Result[High(Result)].Cidr := NetworkToCIDR(CidrInfo);
      Result[High(Result)].Value := Node^.Value;
    end;

    Bit := GetBit(IPValue, BitPos);
    Node := Node^.Children[Bit];
    if Node = nil then Exit;

    if Bit then
    begin
      BytePos := BitPos div 8;
      BitInByte := 7 - (BitPos mod 8);
      Network[BytePos] := Network[BytePos] or (1 shl BitInByte);
    end;
  end;

  if (Node <> nil) and GetNodeFlag(Node, NODE_HAS_VALUE) then
  begin
    SetLength(Result, Length(Result) + 1);
    CidrInfo.Network := Network;
    CidrInfo.PrefixLength := Node^.PrefixLength;
    Result[High(Result)].Cidr := NetworkToCIDR(CidrInfo);
    Result[High(Result)].Value := Node^.Value;
  end;
end;

procedure TIPv6RadixTree.EnumerateAllNodes(var Results: TCidrValuePairs);
type
  TStackItem = record
    Node: PNode;
    Network: TIPv6;
    Prefix: Integer;
  end;
var
  Stack: array of TStackItem;
  StackPos: Integer;
  Current: TStackItem;
  BytePos, BitInByte: Integer;
  CidrInfo: TIPv6CidrInfo;
begin
  SetLength(Results, 0);
  if FRoot = nil then Exit;

  SetLength(Stack, 129);
  Stack[0].Node := FRoot;
  FillChar(Stack[0].Network, SizeOf(TIPv6), 0);
  Stack[0].Prefix := 0;
  StackPos := 0;

  while StackPos >= 0 do
  begin
    Current := Stack[StackPos];
    Dec(StackPos);

    if (Current.Node^.Flags and NODE_HAS_VALUE) <> 0 then
    begin
      SetLength(Results, Length(Results) + 1);
      CidrInfo.Network := Current.Network;
      CidrInfo.PrefixLength := Current.Node^.PrefixLength;
      Results[High(Results)].Cidr := NetworkToCIDR(CidrInfo);
      Results[High(Results)].Value := Current.Node^.Value;
    end;

    if Current.Node^.Children[True] <> nil then
    begin
      Inc(StackPos);
      Stack[StackPos].Node := Current.Node^.Children[True];
      Stack[StackPos].Network := Current.Network;
      BytePos := Current.Prefix div 8;
      BitInByte := 7 - (Current.Prefix mod 8);
      Stack[StackPos].Network[BytePos] := Stack[StackPos].Network[BytePos] or (1 shl BitInByte);
      Stack[StackPos].Prefix := Current.Prefix + 1;
    end;

    if Current.Node^.Children[False] <> nil then
    begin
      Inc(StackPos);
      Stack[StackPos].Node := Current.Node^.Children[False];
      Stack[StackPos].Network := Current.Network;
      Stack[StackPos].Prefix := Current.Prefix + 1;
    end;
  end;
end;

end.

