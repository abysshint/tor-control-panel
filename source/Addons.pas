unit Addons;

interface

uses
  Winapi.Windows, Vcl.Graphics, Winapi.Messages, System.Classes, System.SysUtils,
  Vcl.Controls, Vcl.Forms, Vcl.Grids, Vcl.StdCtrls, Vcl.Themes, Vcl.ComCtrls, Vcl.Menus,
  Vcl.Buttons, Vcl.Clipbrd, ConstData;

type
  TColsDataType = (dtInteger, dtText, dtSize, dtParams, dtFlags);

  TSpeedButton = class(Vcl.Buttons.TSpeedButton)
  public
    ResetValue: Boolean;
  end;

  TUpDown = class (Vcl.ComCtrls.TUpDown)
  public
    ResetValue: Integer;
  end;

  TComboBox = class (Vcl.StdCtrls.TComboBox)
  public
    ResetValue: Integer;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Integer); override;
    procedure DropDown; override;
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
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    SortType: Byte;
    ListType: TListType;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property TextHint: TStrings read FTextHint write FTextHint;
    property TextHintFont: TFont read FTextHintFont write FTextHintFont;
    procedure SetTextHintFont(const Value: TFont); inline;
  end;

  TButton = class (Vcl.StdCtrls.TButton)
  protected
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure CMTextChanged(var Msg: TMessage); message CM_TEXTCHANGED;
    procedure CMEnabledChanged(var Msg: TMessage); message CM_ENABLEDCHANGED;
  strict private
    class constructor Create;
    class destructor Destroy;
  end;

  TSplitButtonStyleHook = class(TButtonStyleHook)
  protected
    procedure Paint(Canvas: TCanvas); override;
  end;

  TProgressBar = class (Vcl.Comctrls.TProgressBar)
  private
    FProgressText: string;
    procedure SetProgressText(TextStr: string);
  protected
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
  published
    property ProgressText: string read FProgressText write SetProgressText;
  strict private
    class constructor Create;
    class destructor Destroy;
  end;

  TCustomProgressBarStyleHook = class(TProgressBarStyleHook)
  protected
    procedure Paint(Canvas: TCanvas); override;
  end;

  TStringGrid = class (Vcl.Grids.TStringGrid)
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

class constructor TProgressBar.Create;
begin
  TCustomStyleEngine.RegisterStyleHook(TProgressBar, TCustomProgressBarStyleHook);
end;

class destructor TProgressBar.Destroy;
begin
  TCustomStyleEngine.UnRegisterStyleHook(TProgressBar, TCustomProgressBarStyleHook);
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

procedure TComboBox.DropDown;
var
  FullWidth, ItemWidth, ScrollSize, i: Integer;
begin
  inherited;
  ScrollSize := 0;
  FullWidth := 0;
  if DropDownCount < Items.Count then
    ScrollSize := GetSystemMetrics(SM_CXVSCROLL);
  for i := 0 to Items.Count - 1 do
  begin
    ItemWidth := ScrollSize + Canvas.TextWidth(Items[i]) + 8;
    if ItemWidth > FullWidth then
		  FullWidth := ItemWidth;
  end;
  if FullWidth < Width then
    FullWidth := Width;
  SendMessage(Handle, CB_SETDROPPEDWIDTH, FullWidth, 0);
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

procedure DrawSplitButton(Control: TWinControl; Handle: HDC = 0);
var
  Icon: TIcon;
  ControlCanvas: TControlCanvas;
  Color: TColor;
begin
  if (Win32MajorVersion = 5) and (Control is TButton) then
  begin
    if TButton(Control).Style = bsSplitButton then
    begin
      Icon := TIcon.Create;
      try
        Tcp.lsMain.GetIcon(14, Icon);
        ControlCanvas := TControlCanvas.Create;
        try
          if Handle <> 0 then
            ControlCanvas.Handle := Handle
          else
            ControlCanvas.Control := Control;
          ControlCanvas.Pen.Width := 2;
          if StyleServices.IsSystemStyle then
            Color := clGray
          else
            Color := StyleServices.GetStyleColor(scBorder);
          ControlCanvas.Pen.Color := Color;
          ControlCanvas.MoveTo(Control.Width - 15, 4);
          ControlCanvas.LineTo(Control.Width - 15, Control.Height - 5);
          ControlCanvas.Draw(Control.Width - 17, (Control.Height - 16) div 2, Icon);
          ReleaseDC(Control.Handle, ControlCanvas.Handle);
        finally
          ControlCanvas.Free;
        end;
      finally
        Icon.Free;
      end;
    end;
  end;
end;

procedure TSplitButtonStyleHook.Paint(Canvas: TCanvas);
begin
  Inherited;
  DrawSplitButton(Control, Canvas.Handle);
end;

procedure TButton.WMPaint(var Message: TWMPaint);
begin
  inherited;
  DrawSplitButton(Self);
end;

procedure DrawCustomProgressBar(Control: TWinControl; Handle: HDC = 0);
var
  ControlCanvas: TControlCanvas;
  LastBkMode: Integer;
  TextStr: string;
  R: TRect;
begin
  if Control is TProgressBar then
  begin
    TextStr := TProgressBar(Control).ProgressText;
    if TextStr <> '' then
    begin
      ControlCanvas := TControlCanvas.Create;
      try
        if Handle <> 0 then
          ControlCanvas.Handle := Handle
        else
          ControlCanvas.Control := Control;
        R := Control.ClientRect;
        R.Left := R.Left + 8;
        LastBkMode := SetBkMode(ControlCanvas.Handle, TRANSPARENT);
        ControlCanvas.Font.Color := StyleServices.GetStyleFontColor(sfWindowTextNormal);
        ControlCanvas.TextRect(R, TextStr, [tfSingleLine, tfCenter, tfVerticalCenter]);
        SetBkMode(ControlCanvas.Handle, LastBkMode);
        ReleaseDC(Control.Handle, ControlCanvas.Handle);
      finally
        ControlCanvas.Free;
      end;
    end;
  end;
end;

procedure TProgressBar.SetProgressText(TextStr: string);
begin
  FProgressText := TextStr;
  Invalidate;
end;

procedure TProgressBar.WMPaint(var Msg: TWMPaint);
begin
  Inherited;
  DrawCustomProgressBar(Self);
end;

procedure TCustomProgressBarStyleHook.Paint(Canvas: TCanvas);
begin
  Inherited;
  DrawCustomProgressBar(Control, Canvas.Handle);
end;

procedure TButton.CMTextChanged(var Msg: TMessage);
begin
  inherited;
  if Win32MajorVersion = 5 then
  begin
    if (Style = bsSplitButton) and TStyleManager.ActiveStyle.IsSystemStyle then
      Invalidate;
  end;
end;

procedure TButton.CMEnabledChanged(var Msg: TMessage);
begin
  inherited;
  if Win32MajorVersion = 5 then
  begin
    if (Style = bsSplitButton) and TStyleManager.ActiveStyle.IsSystemStyle then
      Invalidate;
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
  ListType := ltNoCheck;
  SortType := SORT_NONE;
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
var
  Str: string;
begin
  try
    if Clipboard.HasFormat(cf_Text) then
    begin
      Str := Clipboard.AsText;
      Str := AdjustLineBreaks(Str);
      SelText := Str;
    end;
  except
    on E:Exception do
      Exit
  end;
end;

procedure TMemo.CMExit(var Message: TCMExit);
begin
  Tcp.FindDialog.CloseDialog;
  Inherited;
end;

procedure TMemo.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Button = mbMiddle then
  begin
    if CanFocus then
      SetFocus;
  end;
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
