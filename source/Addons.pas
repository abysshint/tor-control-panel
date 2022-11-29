unit Addons;

interface

uses
  Winapi.Windows, Vcl.Graphics, Winapi.Messages, System.Classes, System.SysUtils,
  Vcl.Controls, Vcl.Forms, Vcl.Grids, Vcl.StdCtrls, Vcl.Themes, Vcl.ComCtrls, Vcl.Menus,
  Vcl.Clipbrd;

type
  TColsDataType = (dtInteger, dtText, dtSize, dtParams);

  TUpDown = class (Vcl.ComCtrls.TUpDown)
  public
    ResetValue: Integer;
  end;

  TComboBox = class (Vcl.StdCtrls.TComboBox)
  public
    ResetValue: Integer;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Integer); override;
  end;

  TEdit = class (Vcl.StdCtrls.TEdit)
  public
    ResetValue: string;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Integer); override;
    procedure DoExit; override;
  end;

  TCheckBox = class (Vcl.StdCtrls.TCheckBox)
  public
    ResetValue: Boolean;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Integer); override;
  end;

  TMemo = class (Vcl.StdCtrls.TMemo)
  private
    FTextHint: TStrings;
    FTextHintFont: TFont;
    procedure WMPaste(var msg: TMessage); message WM_PASTE;
  protected
    FCanvas: TCanvas;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property OnExit;
    property TextHint: TStrings read FTextHint write FTextHint;
    property TextHintFont: TFont read FTextHintFont write FTextHintFont;
    procedure SetTextHintFont(const Value: TFont); inline;
  end;

  TButton = class (Vcl.StdCtrls.TButton)
  strict private
    class constructor Create;
    class destructor Destroy;
  end;

  TSplitButtonStyleHook = class(TButtonStyleHook)
  protected
    procedure Paint(Canvas: TCanvas); override;
  end;

  TStringGrid = class(Vcl.Grids.TStringGrid)
  private
    FCellsAlignment: TStringList;
    FColsDefaultAlignment: TStringList;
    FColsDataType: TStringList;
    function GetCellsAlignment(ACol, ARow: Integer): TAlignment;
    function GetColsDefaultAlignment(ACol: Integer): TAlignment;
    function GetColsDataType(ACol: Integer): TColsDataType;
    procedure SetCellsAlignment(ACol, ARow: Integer; const Alignment: TAlignment);
    procedure SetColsDefaultAlignment(ACol: Integer; const Alignment: TAlignment);
    procedure SetColsDataType(ACol: Integer; const ColsDataType: TColsDataType);
  protected
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
  public
    SelCol, SelRow, MovCol, MovRow: Integer;
    SortType, SortCol: Byte;
    ScrollKeyDown: Boolean;
    RowID: string;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property CellsAlignment[ACol, ARow: Integer]: TAlignment read GetCellsAlignment write SetCellsAlignment;
    property ColsDefaultAlignment[ACol: Integer]: TAlignment read GetColsDefaultAlignment write SetColsDefaultAlignment;
    property ColsDataType[ACol: Integer]: TColsDataType read GetColsDataType write SetColsDataType;
  end;

  TStyleManagerHelper = class helper for TStyleManager
  public
    class procedure RemoveStyle(StyleName: string);
  end;

implementation

Uses Main, Functions;

class constructor TButton.Create;
begin
  TCustomStyleEngine.RegisterStyleHook(TButton, TSplitButtonStyleHook);
end;

class destructor TButton.Destroy;
begin
  TCustomStyleEngine.UnRegisterStyleHook(TButton, TSplitButtonStyleHook);
end;

function TStringGrid.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
  Perform(WM_VSCROLL, SB_LINEDOWN, 0);
  Result := True;
end;

function TStringGrid.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
  Perform(WM_VSCROLL, SB_LINEUP, 0);
  Result := True;
end;

procedure TComboBox.MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Integer);
begin
  if Button = mbMiddle then
  begin
    if (ItemIndex <> ResetValue) and CanFocus then
    begin
      SetFocus;
      ItemIndex := ResetValue;
      Change;
    end;
  end;
  Inherited;
end;

procedure TCheckBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbMiddle then
  begin
    if (Checked <> ResetValue) and CanFocus then
    begin
      SetFocus;
      Checked := ResetValue;
    end;
  end;
  inherited;
end;

procedure TEdit.DoExit;
var
  UpDown: TUpDown;
begin
  UpDown := GetAssocUpDown(Name);
  if UpDown <> nil then
    Text := IntToStr(UpDown.Position);
  inherited;
end;

procedure TEdit.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  UpDown: TUpDown;
begin
  if Button = mbMiddle then
  begin
    UpDown := GetAssocUpDown(Name);
    if CanFocus then
    begin
      SetFocus;
      if UpDown <> nil then
      begin
        if (UpDown.Position <> UpDown.ResetValue) then
          UpDown.Position := UpDown.ResetValue;
      end
      else
      begin
        if Text <> ResetValue then
          Text := ResetValue;
      end;
      SelStart := Length(Text);
    end;
  end;
  inherited;
end;

procedure TSplitButtonStyleHook.Paint(Canvas: TCanvas);
var
  Icon: TIcon;
begin
  Inherited;
  if (Win32MajorVersion = 5) and (TButton(Control).Style = bsSplitButton) then
  begin
    Icon := TIcon.Create;
    try
      Tcp.lsMain.GetIcon(14, Icon);
      Canvas.MoveTo(Control.Width - 15, 2);
      Canvas.LineTo(Control.Width - 15, Control.Height - 2);
      Canvas.Draw(Control.Width - 16, (Control.Height - 16) div 2, Icon);
      ReleaseDC(Handle, Canvas.Handle);
    finally
      Icon.Free;
    end;
  end;
end;

class procedure TStyleManagerHelper.RemoveStyle(StyleName: string);
var
  Style: TCustomStyleServices;
begin
  if TStyleManager.Style[StyleName] <> nil then
  begin
    if TStyleManager.FRegisteredStyles.ContainsKey(StyleName) then
    begin
      Style := TStyleManager.Style[StyleName];
      TStyleManager.FStyles.Remove(Style);
      TStyleManager.FRegisteredStyles.Remove(StyleName);
      FreeAndNil(Style);
    end;
  end;
end;

constructor TMemo.Create(AOwner: TComponent);
begin
  inherited;
  FTextHint := TStringList.Create;
  FCanvas := TControlCanvas.Create;
  FTextHintFont := TFont.Create;
  FTextHintFont.Color := StyleServices.GetStyleFontColor(sfEditBoxTextDisabled);
  FTextHintFont.Name := 'Lucida Console';
  TControlCanvas(FCanvas).Control := Self;
end;

destructor TMemo.Destroy;
begin
  FreeAndNil(FTextHintFont);
  FreeAndNil(FCanvas);
  FTextHint.Clear;
  FreeAndNil(FTextHint);
  inherited;
end;

procedure TMemo.WMPaste(var msg: TMessage);
begin
  if Clipboard.HasFormat(cf_Text) then
    SelText := AdjustLineBreaks(Clipboard.AsText);
end;

procedure TMemo.WMPaint(var Message: TWMPaint);
var
  i, TextHeight: Integer;
begin
  inherited;
  if (Text = '') and (not Focused) then
  begin
    FCanvas.Font := FTextHintFont;
    FCanvas.Brush.Color := StyleServices.GetStyleColor(scEdit);
    TextHeight := FCanvas.TextHeight('yY');
    for i := 0 to FTextHint.Count - 1 do
      FCanvas.TextOut(1, 1 + (i * TextHeight), FTextHint[i]);
  end;
end;

procedure TMemo.SetTextHintFont(const Value: TFont);
begin
  FTextHintFont.Assign(Value);
end;

constructor TStringGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCellsAlignment := TStringList.Create;
  FCellsAlignment.CaseSensitive := True;
  FCellsAlignment.Sorted := True;
  FCellsAlignment.Duplicates := dupIgnore;
  FColsDefaultAlignment := TStringList.Create;
  FColsDefaultAlignment.CaseSensitive := True;
  FColsDefaultAlignment.Sorted := True;
  FColsDefaultAlignment.Duplicates := dupIgnore;
  FColsDataType := TStringList.Create;
  FColsDataType.CaseSensitive := True;
  FColsDataType.Sorted := True;
  FColsDataType.Duplicates := dupIgnore;
end;

destructor TStringGrid.Destroy;
begin
  FCellsAlignment.Free;
  FColsDefaultAlignment.Free;
  FColsDataType.Free;
  inherited Destroy;
end;

procedure TStringGrid.SetCellsAlignment(ACol, ARow: Integer; const Alignment: TAlignment);
var
  Index: Integer;
begin
  Index := 0;
  if (Index > -1) then
    FCellsAlignment.Objects[Index] := TObject(Alignment)
  else
    FCellsAlignment.AddObject(IntToStr(ACol) + '-' + IntToStr(ARow), TObject(Alignment));
end;

function TStringGrid.GetCellsAlignment(ACol, ARow: Integer): TAlignment;
var
  Index: Integer;
begin
  Index := FCellsAlignment.IndexOf(IntToStr(ACol) + '-' + IntToStr(ARow));
  if (Index > -1) then
    GetCellsAlignment := TAlignment(FCellsAlignment.Objects[Index])
  else
    GetCellsAlignment := ColsDefaultAlignment[ACol];
end;

procedure TStringGrid.SetColsDefaultAlignment(ACol: Integer; const Alignment: TAlignment);
var
  Index: Integer;
begin
  Index := FColsDefaultAlignment.IndexOf(IntToStr(ACol));
  if (Index > -1) then
    FColsDefaultAlignment.Objects[Index] := TObject(Alignment)
  else
    FColsDefaultAlignment.AddObject(IntToStr(ACol), TObject(Alignment));
end;

function TStringGrid.GetColsDefaultAlignment(ACol: Integer): TAlignment;
var
  Index: Integer;
begin
  Index := FColsDefaultAlignment.IndexOf(IntToStr(ACol));
  if (Index > -1) then
    GetColsDefaultAlignment := TAlignment(FColsDefaultAlignment.Objects[Index])
  else
    GetColsDefaultAlignment := taLeftJustify;
end;

procedure TStringGrid.SetColsDataType(ACol: Integer; const ColsDataType: TColsDataType);
var
  Index: Integer;
begin
  Index := FColsDataType.IndexOf(IntToStr(ACol));
  if (Index > -1) then
    FColsDataType.Objects[Index] := TObject(ColsDataType)
  else
    FColsDataType.AddObject(IntToStr(ACol), TObject(ColsDataType));
end;

function TStringGrid.GetColsDataType(ACol: Integer): TColsDataType;
var
  Index: Integer;
begin
  Index := FColsDataType.IndexOf(IntToStr(ACol));
  if (Index > -1) then
    GetColsDataType := TColsDataType(FColsDataType.Objects[Index])
  else
    GetColsDataType := dtText;
end;

procedure TStringGrid.DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState);
var
  Temp: Boolean;
  NewText: String;
begin
  if DefaultDrawing then
  begin
    NewText := Cells[ACol, ARow];
    case CellsAlignment[ACol, ARow] of
      taLeftJustify:
      begin
        ARect.Left := ARect.Left + 2;
        Canvas.TextRect(ARect, NewText, [tfLeft, tfEndEllipsis, tfSingleLine, tfVerticalCenter]);
      end;
      taRightJustify:
      begin
        ARect.Right := ARect.Right - 2;
        Canvas.TextRect(ARect, NewText, [tfRight, tfEndEllipsis, tfSingleLine, tfVerticalCenter]);
      end;
      taCenter:
      begin
        ARect.Left := ARect.Left + 2;
        Canvas.TextRect(ARect, NewText, [tfCenter, tfEndEllipsis, tfSingleLine, tfVerticalCenter]);
      end;
    end;
  end;
  Temp := DefaultDrawing;
  DefaultDrawing := False;
  inherited DrawCell(ACol, ARow, ARect, AState);
  DefaultDrawing := Temp;
end;

end.
