{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvDesktopAlert.PAS, released on 2004-03-23.

The Initial Developer of the Original Code is Peter Thornqvist <peter3 at sourceforge dot net>
Portions created by Peter Thornqvist are Copyright (C) 2004 Peter Thornqvist.
All Rights Reserved.

Contributor(s):
Hans-Eric Gr�nlund (stack logic)

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id$
unit JvDesktopAlert;

interface
uses
  Windows, Classes, SysUtils, Controls, Graphics, Forms, Menus, ImgList,
  JvComponent, JvBaseDlg, JvDesktopAlertForm;

type
  TJvDesktopAlertStack = class;
  TJvDesktopAlertChangePersistent = class(TPersistent)
  private
    FOnChange: TNotifyEvent;
  protected
    procedure Change;
  public
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TJvDesktopAlertColors = class(TJvDesktopAlertChangePersistent)
  private
    FWindowFrom: TColor;
    FCaptionTo: TColor;
    FWindowTo: TColor;
    FFrame: TColor;
    FCaptionFrom: TColor;

    procedure SetCaptionFrom(const Value: TColor);
    procedure SetCaptionTo(const Value: TColor);
    procedure SetFrame(const Value: TColor);
    procedure SetWindowFrom(const Value: TColor);
    procedure SetWindowTo(const Value: TColor);
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;

  published
    property Frame: TColor read FFrame write SetFrame default $00943000;
    property WindowFrom: TColor read FWindowFrom write SetWindowFrom default $00FFE7CE;
    property WindowTo: TColor read FWindowTo write SetWindowTo default $00E7A67B;
    property CaptionFrom: TColor read FCaptionFrom write SetCaptionFrom default $00D68652;
    property CaptionTo: TColor read FCaptionTo write SetCaptionTo default $00944110;
  end;

  TJvDesktopAlertPosition = (dapTopLeft, dapTopRight, dapBottomLeft, dapBottomRight, dapCustom);

  TJvDesktopAlertLocation = class(TJvDesktopAlertChangePersistent)
  private
    FTop: integer;
    FLeft: integer;
    FPosition: TJvDesktopAlertPosition;
    FAlwaysResetPosition: boolean;
    procedure SetTop(const Value: integer);
    procedure SetLeft(const Value: integer);
    procedure SetPosition(const Value: TJvDesktopAlertPosition);
  public
    constructor Create;
  published
    property Position: TJvDesktopAlertPosition read FPosition write SetPosition default dapBottomRight;
    property Top: integer read FTop write SetTop;
    property Left: integer read FLeft write SetLeft;
    property AlwaysResetPosition: boolean read FAlwaysResetPosition write FAlwaysResetPosition default True;
  end;

  TJvDesktopAlertButtonItem = class(TCollectionItem)
  private
    FImageIndex: integer;
    FOnClick: TNotifyEvent;
    FTag: integer;
  public
    procedure Assign(Source: TPersistent); override;

  published
    property ImageIndex: integer read FImageIndex write FImageIndex;
    property Tag: integer read FTag write FTag;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
  end;

  TJvDesktopAlertButtons = class(TOwnedCollection)
  private
    function GetItem(Index: integer): TJvDesktopAlertButtonItem;
    procedure SetItem(Index: integer; const Value: TJvDesktopAlertButtonItem);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TJvDesktopAlertButtonItem;

    property Items[Index: integer]: TJvDesktopAlertButtonItem read GetItem write SetItem; default;
    procedure Assign(Source: TPersistent); override;
  end;

  TJvDesktopAlertOption = (daoCanClick, daoCanMove, daoCanMoveAnywhere, daoCanClose, daoCanFade);
  TJvDesktopAlertOptions = set of TJvDesktopAlertOption;

  TJvDesktopAlert = class(TJvCommonDialogP)
  private
    FStacker: TJvDesktopAlertStack;
    FImages: TCustomImageList;
    FButtons: TJvDesktopAlertButtons;
    FColors: TJvDesktopAlertColors;
    FLocation: TJvDesktopAlertLocation;
    FOptions: TJvDesktopAlertOptions;
    FOnClose: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
    FOnMessageClick: TNotifyEvent;
    FOnShow: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    FData: TObject;
    FAutoFocus: boolean;
    function GetStacker: TJvDesktopAlertStack;
    procedure SetButtons(const Value: TJvDesktopAlertButtons);
    procedure SetColors(const Value: TJvDesktopAlertColors);
    procedure SetDropDownMenu(const Value: TPopUpMenu);
    procedure SetFont(const Value: TFont);
    procedure SetHeaderFont(const Value: TFont);
    procedure SetImage(const Value: TPicture);
    procedure SetImages(const Value: TCustomImageList);
    procedure SetPopupMenu(const Value: TPopupMenu);
    procedure InternalOnShow(Sender: TObject);
    procedure InternalOnClose(Sender: TObject; var Action: TCloseAction);
    procedure InternalMouseEnter(Sender: TObject);
    procedure InternalMouseLeave(Sender: TObject);
    procedure InternalMessageClick(Sender: TObject);
    procedure InternalOnMove(Sender: TObject);
    function GetAlertStack: TJvDesktopAlertStack;
    procedure SetAlertStack(const Value: TJvDesktopAlertStack);
    function GetFadeInTime: integer;
    function GetFadeOutTime: integer;
    function GetFont: TFont;
    function GetHeaderFont: TFont;
    function GetImage: TPicture;
    function GetAlphaBlendValue: byte;
    function GetWaitTime: integer;
    procedure SetFadeInTime(const Value: integer);
    procedure SetFadeOutTime(const Value: integer);
    procedure SetAlphaBlendValue(const Value: byte);
    function GetDropDownMenu: TPopUpMenu;
    function GetHeaderText: string;
    function GetMessageText: string;
    function GetPopupMenu: TPopupMenu;
    procedure SetHeaderText(const Value: string);
    procedure SetLocation(const Value: TJvDesktopAlertLocation);
    procedure SetMessageText(const Value: string);
    procedure DoLocationChange(Sender:TObject);
    function GetParentFont: boolean;
    function GetShowHint: boolean;
    function GetHint: string;
    procedure SetHint(const Value: string);
    procedure SetParentFont(const Value: boolean);
    procedure SetShowHint(const Value: boolean);
    procedure SetWaitTime(const Value: integer);
    procedure SetOptions(const Value: TJvDesktopAlertOptions);
  protected
    FFormButtons: array of TControl;
    FDesktopForm: TJvFormDesktopAlert;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Showing: boolean;
    procedure Execute;override;
    property Data: TObject read FData write FData;
  published
    property AlertStack: TJvDesktopAlertStack read GetAlertStack write SetAlertStack;
    property AutoFocus:boolean read FAutoFocus write FAutoFocus default False; 
    property HeaderText: string read GetHeaderText write SetHeaderText;
    property MessageText: string read GetMessageText write SetMessageText;

    property HeaderFont: TFont read GetHeaderFont write SetHeaderFont;
    property Hint:string read GetHint write SetHint;
    property ShowHint:boolean read GetShowHint write SetShowHint;
    property Font: TFont read GetFont write SetFont;
    property ParentFont:boolean read GetParentFont write SetParentFont;
    property Options: TJvDesktopAlertOptions read FOptions write SetOptions default [daoCanClick..daoCanFade];
    property Colors: TJvDesktopAlertColors read FColors write SetColors;
    property Buttons: TJvDesktopAlertButtons read FButtons write SetButtons;
    property Location: TJvDesktopAlertLocation read FLocation write SetLocation;
    property Image: TPicture read GetImage write SetImage;
    property Images: TCustomImageList read FImages write SetImages;
    property DropDownMenu: TPopUpMenu read GetDropDownMenu write SetDropDownMenu;
    property PopupMenu: TPopupMenu read GetPopupMenu write SetPopupMenu;

    property FadeInTime: integer read GetFadeInTime write SetFadeInTime default 25;
    property FadeOutTime: integer read GetFadeOutTime write SetFadeOutTime default 50;
    property WaitTime: integer read GetWaitTime write SetWaitTime default 1400;
    property AlphaBlendValue: byte read GetAlphaBlendValue write SetAlphaBlendValue default 255;

    property OnShow: TNotifyEvent read FOnShow write FOnShow;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnMessageClick: TNotifyEvent read FOnMessageClick write FOnMessageClick;
  end;

  TJvDesktopAlertStack = class(TJvComponent)
  private
    FItems: TList; 
    FPosition: TJvDesktopAlertPosition;
    function GetCount: integer;
    function GetItems(Index: integer): TJvFormDesktopAlert; 
    procedure SetPosition(const Value: TJvDesktopAlertPosition);
  protected
    procedure UpdatePositions; 
  public
    procedure Add(AForm: TForm);
    procedure Remove(AForm: TForm);

    property Items[Index: integer]: TJvFormDesktopAlert read GetItems;
    property Count: integer read GetCount;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    // all forms must have the same position property
    property Position: TJvDesktopAlertPosition read FPosition write SetPosition default dapBottomRight;
  end;

implementation

var
  FGlobalStacker: TJvDesktopAlertStack = nil;

function GlobalStacker: TJvDesktopAlertStack;
begin
  if FGlobalStacker = nil then
    FGlobalStacker := TJvDesktopAlertStack.Create(nil);
  Result := FGlobalStacker;
end;

{ TJvDesktopAlertChangePersistent }

procedure TJvDesktopAlertChangePersistent.Change;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

{ TJvDesktopAlertColors }

procedure TJvDesktopAlertColors.Assign(Source: TPersistent);
begin
  if (Source is TJvDesktopAlertColors) and (Source <> Self) then
  begin
    FFrame := TJvDesktopAlertColors(Source).Frame;
    FWindowFrom := TJvDesktopAlertColors(Source).WindowFrom;
    FWindowTo := TJvDesktopAlertColors(Source).WindowTo;
    FCaptionFrom := TJvDesktopAlertColors(Source).CaptionFrom;
    FCaptionTo := TJvDesktopAlertColors(Source).CaptionTo;
    Change;
    Exit;
  end;
  inherited;
end;

constructor TJvDesktopAlertColors.Create;
begin
  inherited Create;
  FFrame := $00943000;
  FWindowFrom := $00FFE7CE;
  FWindowTo := $00E7A67B;
  FCaptionFrom := $00D68652;
  FCaptionTo := $00944110;
end;

procedure TJvDesktopAlertColors.SetCaptionFrom(const Value: TColor);
begin
  if FCaptionFrom <> Value then
  begin
    FCaptionFrom := Value;
    Change;
  end;
end;

procedure TJvDesktopAlertColors.SetCaptionTo(const Value: TColor);
begin
  if FCaptionTo <> Value then
  begin
    FCaptionTo := Value;
    Change;
  end;
end;

procedure TJvDesktopAlertColors.SetFrame(const Value: TColor);
begin
  if FFrame <> Value then
  begin
    FFrame := Value;
    Change;
  end;
end;

procedure TJvDesktopAlertColors.SetWindowFrom(const Value: TColor);
begin
  if FWindowFrom <> Value then
  begin
    FWindowFrom := Value;
    Change;
  end;
end;

procedure TJvDesktopAlertColors.SetWindowTo(const Value: TColor);
begin
  if FWindowTo <> Value then
  begin
    FWindowTo := Value;
    Change;
  end;
end;

{ TJvDesktopAlertLocation }

constructor TJvDesktopAlertLocation.Create;
begin
  inherited Create;
  FPosition := dapBottomRight;
  FAlwaysResetPosition := true;
end;

procedure TJvDesktopAlertLocation.SetLeft(const Value: integer);
begin
  if FLeft <> Value then
  begin
    FLeft := Value;
    Change;
  end;
end;

procedure TJvDesktopAlertLocation.SetPosition(
  const Value: TJvDesktopAlertPosition);
begin
//  if FPosition <> Value then
  begin
    FPosition := Value;
    Change;
  end;
end;

procedure TJvDesktopAlertLocation.SetTop(const Value: integer);
begin
  if FTop <> Value then
  begin
    FTop := Value;
    Change;
  end;
end;

{ TJvDesktopAlertButtonItem }

procedure TJvDesktopAlertButtonItem.Assign(Source: TPersistent);
begin
  if (Source is TJvDesktopAlertButtonItem) and (Source <> Self) then
  begin
    ImageIndex := TJvDesktopAlertButtonItem(Source).ImageIndex;
    OnClick := TJvDesktopAlertButtonItem(Source).OnClick;
    Tag := TJvDesktopAlertButtonItem(Source).Tag;
    Exit;
  end;
  inherited;
end;

{ TJvDesktopAlertButtons }

function TJvDesktopAlertButtons.Add: TJvDesktopAlertButtonItem;
begin
  Result := TJvDesktopAlertButtonItem(inherited Add);
end;

procedure TJvDesktopAlertButtons.Assign(Source: TPersistent);
var
  i: integer;
begin
  if (Source is TJvDesktopAlertButtons) and (Source <> Self) then
  begin
    Clear;
    for i := 0 to TJvDesktopAlertButtons(Source).Count - 1 do
      Add.Assign(TJvDesktopAlertButtons(Source)[i]);
    Exit;
  end;
  inherited;
end;

constructor TJvDesktopAlertButtons.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TJvDesktopAlertButtonItem);
end;

function TJvDesktopAlertButtons.GetItem(Index: integer): TJvDesktopAlertButtonItem;
begin
  Result := TJvDesktopAlertButtonItem(inherited Items[Index]);
end;

procedure TJvDesktopAlertButtons.SetItem(Index: integer; const Value: TJvDesktopAlertButtonItem);
begin
  inherited Items[Index] := Value;
end;

{ TJvDesktopAlert }

constructor TJvDesktopAlert.Create(AOwner: TComponent);
begin
  inherited;
  FColors := TJvDesktopAlertColors.Create;
  FButtons := TJvDesktopAlertButtons.Create(Self);
  FLocation := TJvDesktopAlertLocation.Create;
  FLocation.OnChange := DoLocationChange;
  FDesktopForm := TJvFormDesktopAlert.CreateNew(Self, 1);
//  FDesktopForm.FreeNotification(Self);
  FOptions := [daoCanClick..daoCanFade];
  FadeInTime := 25;
  FadeOutTime := 50;
  WaitTime := 1400;
  AlphaBlendValue := 255;
end;

destructor TJvDesktopAlert.Destroy;
begin
  if (FDesktopForm <> nil) and FDesktopForm.Showing then
    FDesktopForm.Close;
  FColors.Free;
  FButtons.Free;
  FLocation.Free;
  GetStacker.Remove(FDesktopForm);
  FDesktopForm.Release;
  inherited Destroy;
end;

procedure TJvDesktopAlert.DoLocationChange(Sender: TObject);
begin
  if (GetStacker.Position <> Location.Position) then
  begin
    if (GetStacker = FGlobalStacker) then
      GetStacker.Position := Location.Position
    else
      Location.Position := GetStacker.Position;
  end;
end;

procedure TJvDesktopAlert.Execute;
var
  ARect: TRect;
  i, X, Y: integer;
  FActiveWindow:HWND;
begin
  Assert(FDesktopForm <> nil);
  if FDesktopForm.Visible then FDesktopForm.Close;
  SystemParametersInfo(SPI_GETWORKAREA, 0, @ARect, 0);
  case Location.Position of
    dapTopLeft:
      begin
        FDesktopForm.Top := ARect.Top;
        FDesktopForm.Left := ARect.Left;
      end;
    dapTopRight:
      begin
        FDesktopForm.Top := ARect.Top;
        FDesktopForm.Left := ARect.Right - FDesktopForm.Width;
      end;
    dapBottomLeft:
      begin
        FDesktopForm.Top := ARect.Bottom - FDesktopForm.Height;
        FDesktopForm.Left := ARect.Left;
      end;
    dapBottomRight:
      begin
        FDesktopForm.Top := ARect.Bottom - FDesktopForm.Height;
        FDesktopForm.Left := ARect.Right - FDesktopForm.Width;
      end;
    dapCustom:
      begin
        FDesktopForm.Top := Location.Top;
        FDesktopForm.Left := Location.Left;
      end;
  end;
  FDesktopForm.OnShow := InternalOnShow;
  FDesktopForm.OnClose := InternalOnClose;
  FDesktopForm.OnMouseEnter := InternalMouseEnter;
  FDesktopForm.OnMouseLeave := InternalMouseLeave;
  FDesktopForm.OnUserMove := InternalOnMove;
  FDesktopForm.lblText.OnClick := InternalMessageClick;
  FDesktopForm.Moveable := (daoCanMove in Options);
  FDesktopForm.MoveAnywhere := (daoCanMoveAnywhere in Options);
  FDesktopForm.Closeable := (daoCanClose in Options);

  FDesktopForm.ClickableMessage := daoCanClick in Options;
  if not (daoCanFade in Options) or (csDesigning in ComponentState) then
  begin
    FDesktopForm.FadeInTime := 0;
    FDesktopForm.FadeOutTime := 0;
  end
  else
  begin
    FDesktopForm.FadeInTime := FadeInTime;
    FDesktopForm.FadeOutTime := FadeOutTime;
  end;

  FDesktopForm.WaitTime := WaitTime;
  FDesktopForm.MaxAlphaBlendValue := AlphaBlendValue;

  FDesktopForm.tbDropDown.DropDownMenu := DropDownMenu;
  FDesktopForm.imIcon.Picture := Image;

  FDesktopForm.Font := Font;
  FDesktopForm.lblHeader.Caption := HeaderText;
  FDesktopForm.lblHeader.Font := HeaderFont;
  FDesktopForm.lblText.Caption := MessageText;
  FDesktopForm.WindowColorFrom := Colors.WindowFrom;
  FDesktopForm.WindowColorTo := Colors.WindowTo;
  FDesktopForm.CaptionColorFrom := Colors.CaptionFrom;
  FDesktopForm.CaptionColorTo := Colors.CaptionTo;
  FDesktopForm.FrameColor := Colors.Frame;

  for i := 0 to Length(FFormButtons) - 1 do
    FFormButtons[i].Free;
  SetLength(FFormButtons, Buttons.Count);
  X := 2;
  Y := FDesktopForm.Height - 23;
  for i := 0 to Length(FFormButtons) - 1 do
  begin
    FFormButtons[i] := TJvDesktopAlertButton.Create(FDesktopForm);
    with TJvDesktopAlertButton(FFormButtons[i]) do
    begin
      SetBounds(X, Y, 21, 21);
      ToolType := abtImage;
      Images := Self.Images;
      ImageIndex := Buttons[i].ImageIndex;
      Tag := Buttons[i].Tag;
      OnClick := Buttons[i].OnClick;
      Parent := FDesktopForm;
      Inc(X, 22);
    end;
  end;
  Location.Position := GetStacker.Position;
  if not AutoFocus then
    FActiveWindow := GetActiveWindow
  else
    FActiveWindow := 0;
  FDesktopForm.Show;
  if not AutoFocus and (FActiveWindow <> 0) then
    SetActiveWindow(FActiveWindow);
  GetStacker.Add(FDesktopForm);
end;

function TJvDesktopAlert.GetAlertStack: TJvDesktopAlertStack;
begin
  if FStacker = GlobalStacker then
    Result := nil
  else
    Result := FStacker;
end;

function TJvDesktopAlert.GetDropDownMenu: TPopUpMenu;
begin
  Result := FDeskTopForm.tbDropDown.DropDownMenu;
end;

function TJvDesktopAlert.GetFadeInTime: integer;
begin
  Result := FDesktopForm.FadeInTime;
end;

function TJvDesktopAlert.GetFadeOutTime: integer;
begin
  Result := FDesktopForm.FadeOutTime;
end;

function TJvDesktopAlert.GetFont: TFont;
begin
  Result := FDesktopForm.lblText.Font;
end;

function TJvDesktopAlert.GetHeaderFont: TFont;
begin
  Result := FDesktopForm.lblHeader.Font;
end;

function TJvDesktopAlert.GetHeaderText: string;
begin
  Result := FDeskTopForm.lblHeader.Caption;
end;

function TJvDesktopAlert.GetImage: TPicture;
begin
  Result := FDesktopForm.imIcon.Picture;
end;

function TJvDesktopAlert.GetAlphaBlendValue: byte;
begin
  Result := FDesktopForm.MaxAlphaBlendValue;
end;

function TJvDesktopAlert.GetMessageText: string;
begin
  Result := FDeskTopForm.lblText.Caption;
end;

function TJvDesktopAlert.GetParentFont: boolean;
begin
  Result := FDesktopForm.ParentFont;
end;


function TJvDesktopAlert.GetPopupMenu: TPopupMenu;
begin
  Result := FDeskTopForm.PopupMenu;
end;

function TJvDesktopAlert.GetShowHint: boolean;
begin
  Result := FDesktopForm.ShowHint;
end;

function TJvDesktopAlert.GetStacker: TJvDesktopAlertStack;
begin
  if FStacker = nil then
    Result := GlobalStacker
  else
    Result := FStacker;
end;

function TJvDesktopAlert.GetWaitTime: integer;
begin
  Result := FDesktopForm.WaitTime;
end;

function TJvDesktopAlert.GetHint: string;
begin
  Result := FDesktopForm.Hint;
end;

procedure TJvDesktopAlert.InternalMessageClick(Sender: TObject);
begin
  if Assigned(FOnMessageClick) and (daoCanClick in Options) then
    FOnMessageClick(Self)
end;

procedure TJvDesktopAlert.InternalMouseEnter(Sender: TObject);
begin
  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(Self);
end;

procedure TJvDesktopAlert.InternalMouseLeave(Sender: TObject);
begin
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(Self);
end;

procedure TJvDesktopAlert.InternalOnClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Location.Position = dapCustom then
  begin
    Location.Top := FDesktopForm.Top;
    Location.Left := FDesktopForm.Left;
  end;
  if Assigned(FOnClose) then
    FOnClose(Self);
  GetStacker.Remove(FDesktopForm); 
end;

procedure TJvDesktopAlert.InternalOnMove(Sender: TObject);
begin
  if not (csDesigning in ComponentState) and not Location.AlwaysResetPosition and (Location.Position <> dapCustom) then
  begin
    GetStacker.Remove(FDesktopForm);
    Location.Position := dapCustom;
  end;
end;

procedure TJvDesktopAlert.InternalOnShow(Sender: TObject);
begin
  if Assigned(FOnShow) then
    FOnShow(Self);
end;

procedure TJvDesktopAlert.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
    if AComponent = FStacker then
      AlertStack := nil;
  end;
end;

procedure TJvDesktopAlert.SetAlertStack(const Value: TJvDesktopAlertStack);
begin
  if FStacker <> Value then
  begin
    FStacker := Value;
    if FStacker <> nil then
    begin
      Location.Position := FStacker.Position;
      FStacker.FreeNotification(Self);
    end;
  end;
end;

procedure TJvDesktopAlert.SetButtons(const Value: TJvDesktopAlertButtons);
begin
  FButtons.Assign(Value);
end;

procedure TJvDesktopAlert.SetColors(const Value: TJvDesktopAlertColors);
begin
  FColors.Assign(Value);
end;

procedure TJvDesktopAlert.SetDropDownMenu(const Value: TPopUpMenu);
begin
  FDesktopForm.tbDropDown.DropDownMenu := Value;
end;

procedure TJvDesktopAlert.SetFadeInTime(const Value: integer);
begin
  FDesktopForm.FadeInTime := Value;
end;

procedure TJvDesktopAlert.SetFadeOutTime(const Value: integer);
begin
  FDesktopForm.FadeOutTime := Value;
end;

procedure TJvDesktopAlert.SetFont(const Value: TFont);
begin
  FDesktopForm.lblText.Font := Value;
end;

procedure TJvDesktopAlert.SetHeaderFont(const Value: TFont);
begin
  FDesktopForm.lblHeader.Font := Value;
end;

procedure TJvDesktopAlert.SetHeaderText(const Value: string);
begin
  FDeskTopForm.lblHeader.Caption := Value;
end;

procedure TJvDesktopAlert.SetHint(const Value: string);
begin
  FDesktopForm.Hint := Value;
end;

procedure TJvDesktopAlert.SetImage(const Value: TPicture);
begin
  FDesktopForm.imIcon.Picture := Value;
end;

procedure TJvDesktopAlert.SetImages(const Value: TCustomImageList);
begin
  if FImages <> Value then
  begin
    FImages := Value;
    if FImages <> nil then
      FImages.FreeNotification(Self);
  end;
end;

procedure TJvDesktopAlert.SetLocation(const Value: TJvDesktopAlertLocation);
begin
  //
end;

procedure TJvDesktopAlert.SetAlphaBlendValue(const Value: byte);
begin
  FDesktopForm.MaxAlphaBlendValue := Value;
end;

procedure TJvDesktopAlert.SetMessageText(const Value: string);
begin
  FDeskTopForm.lblText.Caption := Value;
end;

procedure TJvDesktopAlert.SetParentFont(const Value: boolean);
begin
  FDesktopForm.ParentFont := Value;
end;


procedure TJvDesktopAlert.SetPopupMenu(const Value: TPopupMenu);
begin
  FDesktopForm.PopupMenu := Value;
end;

procedure TJvDesktopAlert.SetShowHint(const Value: boolean);
begin
  FDesktopForm.ShowHint := Value;
end;

function TJvDesktopAlert.Showing: boolean;
begin
  Result := (FDesktopForm <> nil) and FDesktopForm.Showing;
end;

procedure TJvDesktopAlert.SetWaitTime(const Value: integer);
begin
  FDesktopForm.WaitTime := Value;
end;

procedure TJvDesktopAlert.SetOptions(const Value: TJvDesktopAlertOptions);
begin
  if Foptions <> Value then
  begin
    FOptions := Value;
    if not (daoCanMove in FOptions) then
      Exclude(FOptions, daoCanMoveAnywhere);
  end;
end;

{ TJvDesktopAlertStack }

procedure TJvDesktopAlertStack.Add(AForm: TForm);
begin
  FItems.Add(AForm); 
  UpdatePositions;
end;

constructor TJvDesktopAlertStack.Create(AOwner: TComponent);
begin
  inherited;
  FItems := TList.Create;
  FPosition := dapBottomRight;
end;

destructor TJvDesktopAlertStack.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TJvDesktopAlertStack.GetCount: integer;
begin
  Result := FItems.Count; 
end;

function TJvDesktopAlertStack.GetItems(Index: integer): TJvFormDesktopAlert;
begin
  Result := TJvFormDesktopAlert(FItems[Index]);
  Assert((Result = nil) or (Result is TJvFormDesktopAlert));
end;

procedure TJvDesktopAlertStack.Remove(AForm: TForm);
var
  Index, PrevNilSlot: Integer;
  Form: TJvFormDesktopAlert;
begin
  if (AForm <> nil) and (AForm is TJvFormDesktopAlert) then
  begin
    // The basic trick here is to push piling forms down in the list, while keeping the
    // static ones (i.e. a form that has the mouse pointer over it) in place.
    Index := FItems.IndexOf(AForm);
    if (Index >= 0) then
    begin
      FItems[Index] := nil;

      Inc(Index);
      while Index < FItems.Count do
      begin
        Form := Items[Index];
        if Assigned(Form) and (not Form.MouseInControl) then
        begin
          PrevNilSlot := Pred(Index);
          while FItems[PrevNilSlot] <> nil do
            Dec(PrevNilSlot);
          FItems[PrevNilSlot] := FItems[Index];
          FItems[Index] := nil;
        end;

        Inc(Index);
      end;

      while (Pred(FItems.Count) >= 0) and (FItems[Pred(FItems.Count)] = nil) do
        FItems.Delete(Pred(FItems.Count));

      UpdatePositions;
    end;
  end;
end;

procedure TJvDesktopAlertStack.SetPosition(const Value: TJvDesktopAlertPosition);
begin
  if FPosition <> Value then
  begin
//    if Value = dapCustom then raise
//      Exception.Create('TJvDesktopAlertStack does not handle dapCustom alerts!');
//    FItems.Clear;
    FPosition := Value;
  end;
end;


procedure TJvDesktopAlertStack.UpdatePositions;
var
  C, I: Integer;
  Form: TJvFormDesktopAlert;
  X,Y: Integer;
  R: TRect;
begin
  C := Count;
  if C > 0 then
  begin
    SystemParametersInfo(SPI_GETWORKAREA, 0, @R, 0);
    case Position of
      dapBottomRight, dapBottomLeft:
      begin
        if Position = dapBottomRight then
          X := R.Right - Items[0].Width // assume all forms have the same width
        else
          X := R.Left;
        Y := R.Bottom;
        for I := 0 to Pred(C) do
        begin
          Form := Items[i];
          if Assigned(Form) and Form.Visible then
          begin
            Dec(Y, Form.Height);
            Form.SetNewOrigin(X,Y);
          end;
        end;
      end;

      dapTopRight, dapTopLeft:
      begin
        Y := R.Top;
        if Position = dapTopRight then
          X := R.Right - Items[0].Width // assume all forms have the same width
        else
          X := R.Left;
        for I := 0 to Pred(C) do
        begin
          Form := Items[i];
          if Assigned(Form) and Form.Visible then
          begin
            Form.SetNewOrigin(X,Y);
            Inc(Y, Form.Height);
          end;
        end;
      end;
    end;
  end;
end;

initialization

finalization
  FGlobalStacker.Free;

end.

