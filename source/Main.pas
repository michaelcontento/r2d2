unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uGame, ComCtrls, uCell, TabNotBk, Spin;

type
  TMainForm = class(TForm)
    State: TStatusBar;
    boxSpielfeld: TGroupBox;
    pbMain: TPaintBox;
    pbBatterie: TPaintBox;
    Management: TTabbedNotebook;
    boxEinheiten: TGroupBox;
    lbEinheiten: TListBox;
    btnEmptyMap: TButton;
    GroupBox1: TGroupBox;
    seHeight: TSpinEdit;
    seWidth: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    btnRandomMap: TButton;
    btnFillMapSelected: TButton;
    Label5: TLabel;
    GroupBox2: TGroupBox;
    btnSaveGame: TButton;
    btnLoadGame: TButton;
    GroupBox3: TGroupBox;
    lbRobots: TListBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    btnAddRobot: TButton;
    btnDelRobot: TButton;
    Button1: TButton;
    Button2: TButton;
    edEnergie: TEdit;
    Label6: TLabel;
    ColorBox1: TColorBox;
    Label7: TLabel;
    procedure pbMainMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbMainMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnDelRobotClick(Sender: TObject);
    procedure lbRobotsClick(Sender: TObject);
    procedure btnAddRobotClick(Sender: TObject);
    procedure pbMainPaint(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnSaveGameClick(Sender: TObject);
    procedure btnLoadGameClick(Sender: TObject);
    procedure btnRandomMapClick(Sender: TObject);
    procedure pbMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnEmptyMapClick(Sender: TObject);
    procedure btnFillMapSelectedClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure UpdateRobotInfo;
    function GetSelectedRobot: string;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;


var
  mainScreen: TBitmap;
  MainForm: TMainForm;
  Game: TGame;
  isDragging: boolean;
  
implementation

{$R *.dfm}


procedure TMainForm.pbMainPaint(Sender: TObject);
begin
  if Game <> nil then
  begin
     pbBatterie.Width := 17;
    Game.Paint;
  end
  else
    pbMain.Canvas.Draw(0, 0, mainScreen);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Game.Free;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Game <> NIl) and (lbRobots.ItemIndex >= 0) then
  begin
    game.Robot(GetSelectedRobot).Move(Key);
    game.PaintGame;
  end;
end;

procedure TMainForm.btnSaveGameClick(Sender: TObject);
begin
  Game.SaveGame('save.r2d');
end;

procedure TMainForm.btnLoadGameClick(Sender: TObject);
begin
  if Game <> nil then
    Game.Free;

  lbRobots.Clear;
  Game                := TGame.Create(Self, Management, lbEinheiten);
  Game.Canvas         := pbMain.Canvas;
  Game.BatterieCanvas := pbBatterie.Canvas;
  Game.LoadGame('save.r2d');
end;

procedure TMainForm.btnRandomMapClick(Sender: TObject);
begin
  if Game <> nil then
    Game.Free;
    
  lbRobots.Clear;
  Game                := TGame.Create(Self, Management, lbEinheiten);
  Game.Canvas         := pbMain.Canvas;
  Game.BatterieCanvas := pbBatterie.Canvas;
  Game.CreateMap(seWidth.Value, seHeight.Value);
  Game.RandomFillmap;
  Game.PaintGame;
end;

procedure TMainForm.pbMainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  pos: TPoint;
begin
  isDragging := true;
  if (Game <> nil) and (lbEinheiten.Items.Count > 0) then
  begin
    pos := Game.GetPosition(x, y);
    Game.map.Map[pos.X, pos.Y].def := @Game.map.CellList.celllist[lbEinheiten.itemindex];
    game.PaintGame;
  end;
end;

procedure TMainForm.btnEmptyMapClick(Sender: TObject);
begin
  if Game <> nil then
    Game.Free;

  lbRobots.Clear;
  Game                := TGame.Create(Self, Management, lbEinheiten);
  Game.Canvas         := pbMain.Canvas;
  Game.BatterieCanvas := pbBatterie.Canvas;
  Game.CreateMap(seWidth.Value, seHeight.Value);
  Game.PaintGame;
end;

procedure TMainForm.btnFillMapSelectedClick(Sender: TObject);
var x, y: integer;
begin
  if game <> NIL then
  begin
    for x := 0 to Length(Game.map.Map) - 1 do
    begin
      for y := 0 to Length(Game.map.Map[x]) - 1 do
      begin
        Game.map.Map[x, y].def := @Game.map.CellList.celllist[lbEinheiten.itemindex];
      end;
    end;
    Game.PaintGame;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  pbBatterie.Width := 0;
  ClientWidth      := 405;
  mainScreen       := TBitmap.Create;
  mainScreen.LoadFromFile('data\r2d2.bmp');
  Sleep(1500);
  isDragging       := false;
end;

procedure TMainForm.btnAddRobotClick(Sender: TObject);
var i: integer;
    tmp: string;
begin
  if Game <> NIL then
  begin
    i := 0;

    repeat;
      i := i + 1;
      tmp := 'Robot-' + IntToStr(i);
    until Game.RobotExist(tmp) = false;

    lbRobots.AddItem(tmp, Sender);
    lbRobots.itemindex := lbRobots.Items.Count - 1;
    Game.AddRobot(tmp, 0, 0);
  end
  else
    ShowMessage('Fehler: Keine Karte vorhanden, in der ein Roboter erstellt werden könnte.');
end;

procedure TMainForm.lbRobotsClick(Sender: TObject);
begin
  Game.DeactivateAllRobots;
  Game.Robot(GetSelectedRobot).active := true;
  Game.Robot(GetSelectedRobot).ShowBatterie;
  Game.PaintGame;
  UpdateRobotInfo;
end;

function TMainForm.GetSelectedRobot: string;
begin
  result := lbRobots.Items[lbRobots.itemindex];
end;

procedure TMainForm.btnDelRobotClick(Sender: TObject);
begin
  if  (Game <> NIl)
  and (lbRobots.Items.Count > 0) then
  begin
    Game.RemoveRobot(GetSelectedRobot);
    lbRobots.DeleteSelected;

    if lbRobots.Items.Count > 0 then
      lbRobots.ItemIndex := lbRobots.Items.Count - 1;
      
    Game.PaintGame;
  end;
end;

procedure TMainForm.pbMainMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var posx, posy: integer;
    tmp: string;
    pos: TPoint;
begin
  if Game <> nil then
  begin
    // Statuszeile
    posx := x div game.raster + 1;
    posy := y div game.raster + 1;

    tmp := 'x: ' + IntToStr(posx) + ' ' + 'y: ' + IntToStr(posy) + ' // '
         + 'Begehbar: ';

    if  (posy > 0) and (posy <= Length(game.map.Map[0]))
    and (posx > 0) and (posx <= Length(game.map.Map))   then
    begin
      if game.map.Map[posx - 1, posy - 1].def.isMovable then tmp := tmp + 'Ja'
      else                                                   tmp := tmp + 'Nein';
      tmp := tmp + ' // Einheit: '   + game.map.map[posx - 1, posy - 1 ].def.name;
      tmp := tmp + ' // Wegkosten: ' + IntToStr(game.map.map[posx - 1, posy - 1 ].def.costs);
    end;

    // Einheiten Malen
    if (lbEinheiten.Items.Count > 0) and isDragging then
    begin
      pos := Game.GetPosition(x, y);
      Game.map.Map[pos.X, pos.Y].def := @Game.map.CellList.celllist[lbEinheiten.itemindex];
      game.PaintGame;
    end;
  end
  else
  begin
    tmp := '';
  end;
  State.SimpleText := tmp;
end;

procedure TMainForm.UpdateRobotInfo;
begin
  if lbRobots.itemindex <> -1 then
  begin
    edEnergie.Text := IntToStr(Game.Robot(GetSelectedRobot).PowerStat);
  end;
end;

procedure TMainForm.pbMainMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  isDragging := false;
end;

end.
