unit uGame;

interface

uses
  Windows, Graphics, StdCtrls, Forms, TabNotBk, Types, Classes, uMap,
  uR2D2, uTools, uTypes;

type
  TStepsBmp = record
    NORTH,
    SOUTH,
    WEST,
    EAST: TBitMap;
  end;

  TGame = class(TObject)
    map: TMap;
    Canvas :TCanvas;
    OwnerForm: TForm;
    OwnerTab: TTabbedNotebook;
    OwnerLB: TListBox;
    BatterieCanvas: TCanvas;
    Raster: Integer;
    Buffer: TBitmap;
    BatterieBuffer: TBitmap;
    Robots: array of TR2D2;
  public
    constructor Create(Form: TForm; Bottom: TTabbedNotebook; ListBox: TListBox);
    destructor Destroy; override;

    function  AddRobot(Name: String; StartX, StartY: Integer): integer;
    function  Robot(Name: String): TR2D2;
    function  RobotExist(Name: string): boolean;
    procedure DeactivateAllRobots;
    procedure RemoveRobot(Name: string);

    procedure PaintGame;
    procedure Paint;
    procedure CreateMap(X, Y: Integer);
    function GetPosition(PixelX, PixelY: Integer): TPoint;
    procedure RandomFillMap;

    procedure LoadGame(FileName: String);
    procedure SaveGame(FileName: String);
  end;

var
  StepsBmp: TStepsBmp;

implementation

uses uCell;

constructor TGame.Create(Form: TForm; Bottom: TTabbedNotebook; ListBox: TListBox);
begin
  inherited Create;

  OwnerForm := Form;
  OwnerTab  := Bottom;
  OwnerLB   := ListBox;

  // Bildpuffer initialisieren
  Buffer        := TBitmap.Create;
  Buffer.Width  := 100;
  Buffer.Height := 100;

  BatterieBuffer        := TBitmap.Create;
  BatterieBuffer.Width  := 15;
  BatterieBuffer.Height := 367;

  StepsBmp.NORTH := TBitmap.Create;
  StepsBmp.SOUTH := TBitmap.Create;
  StepsBmp.EAST  := TBitmap.Create;
  StepsBmp.WEST  := TBitmap.Create;

  StepsBmp.NORTH.LoadFromFile(ApplicationDir + 'data\pics\StepsN.bmp');
  StepsBmp.SOUTH.LoadFromFile(ApplicationDir + 'data\pics\StepsS.bmp');
  StepsBmp.EAST.LoadFromFile(ApplicationDir + 'data\pics\StepsE.bmp');
  StepsBmp.WEST.LoadFromFile(ApplicationDir + 'data\pics\StepsW.bmp');

  raster := 30;

end;

destructor TGame.Destroy;
var
  i: Integer;
begin
  for i := 0 to Length(robots) - 1 do
    robots[i].Free;

  buffer.Free;
  BatterieBuffer.Free;

  inherited Destroy;
end;

procedure TGame.DeactivateAllRobots;
var i: integer;
begin
  for i := 0 to Length(robots) - 1 do
    robots[i].active := false;
end;

function TGame.AddRobot(Name: String; StartX, StartY: Integer): integer;
var i: integer;
begin
  DeactivateAllRobots;
  SetLength(robots, Length(robots) + 1);
  map.Map[StartX, StartY].isMovable         := false;
  
  robots[Length(robots) - 1]                := TR2D2.Create(Name, StartX, StartY);
  robots[Length(robots) - 1].map            := @map;
  robots[Length(robots) - 1].active         := true;
  robots[Length(robots) - 1].BatterieBuffer := @BatterieBuffer;
  robots[Length(robots) - 1].BatterieCanvas := @BatterieCanvas;
  robots[Length(robots) - 1].Color          := clRed;
  robots[Length(robots) - 1].ShowBatterie;

  PaintGame;
end;

procedure TGame.RemoveRobot(Name: string);
var
  i: Integer;
begin
  for i := 0 to Length(Robots) - 1 do
  begin
    if Robots[i].Name = Name then
    begin
      Robots[i].Free;

      if i <> Length(Robots) then
        robots[i] := robots[Length(Robots) - 1];

      SetLength(robots, Length(robots) - 1);
    end;
  end;
end;

function TGame.RobotExist(name: string): boolean;
var x: integer;
    res: boolean;
begin
  res := false;

  for x := 0 to Length(Robots) - 1 do
    if Robots[x].Name = name then res := true;

  result := res;
end;

procedure TGame.RandomFillmap;
var x, y: integer;
begin
  for x := 0 to Length(map.Map) - 1 do
  begin
    for y := 0 to Length(map.Map[x]) -1 do
    begin
      map.Map[x, y].def       := @map.CellList.CellList[Random(Length(map.CellList.cellList))];
      map.Map[x, y].isMovable := map.Map[x, y].def.isMovable;
    end;
  end;
end;

function TGame.Robot(Name: String): TR2D2;
var
  i: Integer;
begin
  for i := 0 to Length(Robots) - 1 do
  begin
    if Robots[i].Name = Name then
      result := Robots[i];
  end;
end;

procedure TGame.PaintGame;
var
  x, y, eyeX, eyeY, rx, ry: Integer;
begin
  if map <> nil then
  begin
    buffer.Canvas.Brush.Color := clWhite;
    buffer.Canvas.Rectangle(0,
                            0,
                            Raster * Length(map.Map),
                            Raster * Length(map.Map[0]));

    for x := 0 to Length(map.Map) - 1 do
    begin
      for y := 0 to Length(map.Map[x]) - 1 do
      begin
        buffer.Canvas.Brush.Color := clWhite;
        buffer.Canvas.Rectangle(Raster * x + 1, Raster * y + 1, Raster * x + Raster - 1, Raster * y + Raster - 1);
        if Map.Map[x, y].def <> nil then
          buffer.Canvas.Draw(Raster * x + 2, Raster * y + 2, Map.Map[x,y].def.imgGround);
      end;
    end;
  end;

  // Steps Zeichnen
  for x := 0 to Length(Robots) - 1 do
  begin
    for y := Length(Robots[x].Steps) - 1 downto 1 do
    begin
      buffer.Canvas.Brush.Color := clWhite;

      case Robots[x].Steps[y].way of
        NORTH: buffer.Canvas.Draw(Raster * Robots[x].Steps[y].PosX + 2, Raster * Robots[x].Steps[y].PosY + 2, StepsBmp.NORTH);
        SOUTH: buffer.Canvas.Draw(Raster * Robots[x].Steps[y].PosX + 2, Raster * Robots[x].Steps[y].PosY + 2, StepsBmp.SOUTH);
        EAST : buffer.Canvas.Draw(Raster * Robots[x].Steps[y].PosX + 2, Raster * Robots[x].Steps[y].PosY + 2, StepsBmp.EAST);
        WEST : buffer.Canvas.Draw(Raster * Robots[x].Steps[y].PosX + 2, Raster * Robots[x].Steps[y].PosY + 2, StepsBmp.WEST);
      end;
    end;
  end;

  // Roboter zeichen
  for x := 0 to Length(Robots) - 1 do
  begin
    rx := robots[x].posX;
    ry := robots[x].posY;

    buffer.Canvas.Brush.Color := robots[x].Color;
    buffer.Canvas.Ellipse(Raster * rx + 3, Raster * ry + 3, Raster * rx + raster - 3, raster * ry + raster - 3);
    buffer.Canvas.Brush.Color := clBlue;
    case robots[x].GetWay of
      NORTH : begin
        eyeX := raster * rx + raster div 2 - 5;
        eyeY := raster * ry + 2;
      end;
      EAST  : begin
        eyeX := raster * rx + raster - 12;
        eyeY := raster * ry + raster div 2 - 5;
      end;
      SOUTH : begin
        eyeX := raster * rx + raster div 2 - 5;
        eyeY := raster * ry + raster - 12;
      end;
      WEST  : begin
        eyeX := raster * rx + 2;
        eyeY := raster * ry + raster div 2 - 5;
      end;
    end;
    buffer.Canvas.Ellipse(eyeX, eyeY, eyeX + 10, eyeY + 10);
  end;

  // Buffer auf Canvas zimmern
  Paint;

end;

procedure TGame.Paint;
begin
  if ( map <> nil ) and ( Buffer <> nil ) then
    BitBlt(Canvas.Handle, 0, 0, Pred(buffer.Width), Pred(buffer.Height),
           buffer.Canvas.Handle, 0, 0, buffer.Canvas.CopyMode);

  if ( batterieCanvas <> nil ) and ( batterieBuffer <> nil ) then
    BitBlt(BatterieCanvas.Handle, 0, 0, Pred(batterieBuffer.Width), Pred(batterieBuffer.Height),
           batterieBuffer.Canvas.Handle, 0, 0, batterieBuffer.Canvas.CopyMode);

end;

procedure TGame.CreateMap(X, Y: Integer);
var i: integer;
begin
  Map := TMap.Create(x, y);

  OwnerLb.Items.Clear;
  for i := 0 to length(map.CellList.cellList) - 1 do
    OwnerLB.Items.Add(map.CellList.cellList[i].name);
  OWnerLb.ItemIndex := 0;

  Buffer.Width  := raster * x;
  Buffer.Height := Raster * y;

  OwnerForm.ClientWidth  := BatterieBuffer.Width + 10 + (raster * x);
  OwnerForm.ClientHeight := OwnerTab.Height      + 36 + (raster * y);
  BatterieBuffer.Height  := raster * y;

  PaintGame;
end;

function TGame.GetPosition(PixelX, PixelY: Integer): TPoint;
var
  Pos: TPoint;
begin
  pos.X := PixelX div Raster;
  pos.Y := PixelY div Raster;
  if pos.X > Length(map.Map) - 1 then
    Result.X := Length(map.Map) - 1
  else
    Result.X := Pos.X;

  if pos.Y > Length(map.Map[0]) - 1 then
    Result.Y := Length(map.Map[0]) - 1
  else
    Result.Y := Pos.Y;
end;

procedure TGame.LoadGame(FileName: String);
var
  s, ps: TMemoryStream;
  anz, posX, PosY, i, l, x, y: Integer;
  Name: String;
  way: TWay;
begin

  s  := TMemoryStream.Create;
  ps := TMemoryStream.Create;

  try
    ps.LoadFromFile(ApplicationDir + 'saves\' + FileName);
    DeCompressStream(ps, s);

    { Karte Laden }
    s.ReadBuffer(x, SizeOf(x));
    s.ReadBuffer(y, SizeOf(y));

    CreateMap(x, y);
    for x := 0 to Length(Map.Map) - 1 do
    begin
      for y := 0 to Length(Map.Map[x]) - 1 do
      begin
        s.ReadBuffer(i, SizeOf(i));
        Map.Map[x, y].def := @Map.CellList.cellList[i];
        Map.Map[x, y].isMovable := map.map[x, y].def.isMovable;
      end;
    end;

    { Robots Laden
    s.ReadBuffer(anz, SizeOf(anz));

    for i := 0 to anz - 1 do
    begin
      s.ReadBuffer(l, SizeOf(l));
      SetLength(Name, l);
      s.ReadBuffer(PChar(Name)^, l);
      s.ReadBuffer(posX, SizeOf(posX));
      s.ReadBuffer(posY, SizeOf(posY));

      AddRobot(Name, PosX, PosX);
      s.ReadBuffer(way, SizeOf(Way));
      Robot(Name).way := way;
    end;                     }

  finally
    ps.Free;
    s.Free;
  end;

  PaintGame;

end;

procedure TGame.SaveGame(FileName: String);
var
  s, ps: TMemoryStream;
  i, l, x, y: Integer;
begin
  s  := TMemoryStream.Create;
  ps := TMemoryStream.Create;

  try
    { Karte Speichern }
    x := Length(Map.Map);            // Breite der Karte
    s.WriteBuffer(x, SizeOf(x));

    y := Length(Map.Map[0]);         // Höhe der Karte
    s.WriteBuffer(y, SizeOf(y));

    for x := 0 to Length(Map.Map) - 1 do
    begin
      for y := 0 to Length(Map.Map[0]) - 1 do
      begin
        s.WriteBuffer(map.map[x, y].def.Index, SizeOf(map.map[x, y].def.Index));
      end;
    end;

    { Robots Speichern
    i := Length(Robots);            // Anzahl Robots
    s.WriteBuffer(i, SizeOf(i));

    for i := 0 to Length(Robots) - 1 do
    begin
      l := Length(Robots[i].Name);
      s.WriteBuffer(l, SizeOf(l));
      s.WriteBuffer(PChar(Robots[i].Name)^, l);

      s.WriteBuffer(Robots[i].PosX, SizeOf(Robots[i].PosX));
      s.WriteBuffer(Robots[i].PosY, SizeOf(Robots[i].PosY));
      s.WriteBuffer(Robots[i].way, SizeOf(Robots[i].way));
    end;                    }

    CompressStream(s, ps);
    ps.SaveToFile(ApplicationDir + 'saves\' + FileName);
  finally
    ps.Free;
    s.Free;
  end;
end;

end.

