unit uR2D2;

interface

uses
  Windows, Graphics, ExtCtrls, Types, uMap, uTypes, DIALOGS;

type
  TR2D2 = class(TObject)
    Name: String;
    doSteps: boolean;
    active: boolean;
    map: ^TMap;
    batterieBuffer: ^TBitmap;
    batterieCanvas: ^TCanvas;
    posX,
    posY,
    MaxPower,
    PowerStat: Integer;
    Color: TColor;
    Steps: array of TStep;
    way: TWay;
  private
    powerTimer: TTimer;
    MaxStep: Integer;
    procedure Timer(Sender: TObject);
  public
    { Public-Deklarationen }
    constructor Create(AName: String; StartX, StartY: Integer);
    destructor Destroy; override;
    procedure Turn(key: Word);
    procedure Move(key: Word);
    procedure DoMove(x, y: integer);
    function GetWay: TWay;
    procedure SetStep(x, y: Integer);
    procedure ShowBatterie;
  end;

implementation

uses SysUtils, uCell;

procedure TR2D2.Timer(Sender: TObject);
begin
  if active then
    ShowBatterie;
    
  if PowerStat < MaxPower then
  begin
    Inc(PowerStat, 1);
  end
  else
    TTimer(Sender).Enabled := False;
end;

constructor TR2D2.Create(AName: String; StartX, StartY: Integer);
begin
  inherited Create;

  posX := StartX;
  posY := StartY;

  MaxPower  := 160;
  MaxStep   := 5;
  way       := SOUTH;
  PowerStat := MaxPower;
  Name      := AName;

  PowerTimer := TTimer.Create(nil);
  PowerTimer.Enabled  := False;
  PowerTimer.Interval := 250;
  PowerTimer.OnTimer  := Timer;

  SetLength(Steps, 1);
  Steps[0].posX := posX;
  Steps[0].posY := posY;

  doSteps := true;
  active  := true;
end;

destructor TR2D2.Destroy;
begin
  PowerTimer.Enabled := False;
  PowerTimer.Free;
  inherited Destroy;
end;

procedure TR2D2.Turn(key: Word);
begin
  case key of
    LEFT : begin // links
      case way of
        NORTH : way := WEST;
        EAST  : way := NORTH;
        SOUTH : way := EAST;
        WEST  : way := SOUTH;
      end;
    end;
    RIGHT : begin // rechts
      case way of
        NORTH : way := EAST;
        EAST  : way := SOUTH;
        SOUTH : way := WEST;
        WEST  : way := NORTH;
      end;
    end;
  end;

  if Length(Steps) > 0 then
    Steps[0].way := way;
    
  Dec(PowerStat, 1);

end;

procedure TR2D2.Move(key: Word);
begin
 if ( key = LEFT ) or ( key = RIGHT ) or ( key = FORWRD ) or ( key = BCKWRD ) then
 begin
   PowerTimer.Enabled  := True;
   ShowBatterie;
 end;

 case key of

   LEFT, RIGHT : begin //links, rechts
     if PowerStat > 0 then
       Turn(key);
   end;

   FORWRD : begin // Vor
     case way of
       NORTH : begin
         if PosY > 0 then
           DoMove(posX, PosY - 1);
       end;
       EAST  : begin
         if PosX < Length(map.Map) - 1 then
           DoMove(posX + 1, posY);
       end;
       SOUTH : begin
         if PosY < Length(map.Map[PosX]) - 1 then
           DoMove(PosX, PosY + 1);
       end;
       WEST  : begin
         if PosX > 0 then
           DoMove(PosX - 1, PosY);
       end;
     end;
   end;

   BCKWRD : begin  // rückwärts
     case way of
       NORTH : begin
         if PosY < Length(map.Map[Posx]) - 1 then
           DoMove(PosX, PosY + 1);
       end;
       EAST  : begin
         if PosX > 0 then
           DoMove(PosX - 1, PosY);
       end;
       SOUTH : begin
         if PosY > 0 then
           DoMove(PosX, PosY - 1);
       end;
       WEST  : begin
         if PosX < Length(map.Map) - 1 then
           DoMove(PosX + 1, PosY);
       end;
     end;
   end;
 end;

end;

procedure TR2D2.DoMove(x, y: integer);
begin
  if (map^.Map[x, y].isMovable = true) and
     (PowerStat >= map^.map[x, y].def.costs) then
  begin
    map^.Map[posX, posY].isMovable := true;
    map^.Map[x, y].isMovable := false;
    posX := x;
    posY := y;
    Dec(PowerStat, map^.Map[x, y].def.costs);

    if doSteps then
      SetStep(x, y);
  end;
end;

procedure TR2D2.SetStep(x, y: Integer);
var
  i: Integer;
begin
  if Length(Steps) < MaxStep then
    SetLength(Steps, Length(Steps) + 1);

  for i := Length(Steps) - 1 downto 1 do
  begin
    Steps[i] := Steps[i - 1];
  end;
  Steps[0].posX := x;
  Steps[0].posY := y;
  Steps[0].way  := way;
end;

function TR2D2.GetWay: TWay;
begin
  Result := way;
end;

procedure TR2D2.ShowBatterie;
var
  i: Integer;
  Segmente: Integer;
  percent: Integer;
begin

  with BatterieBuffer^ do
  begin
    Canvas.Brush.Color := clBlack;
    Canvas.FillRect(Rect(0, 0, Width, Height));

    Segmente := Height div 4 - 2;

    percent := Trunc(PowerStat
                   / MaxPower
                   * 100);
    for i := Segmente downTo 0 do
    begin
      if ( i / Segmente * 100 < 33 ) then
        Canvas.Brush.Color := clLime;
      if ( i / Segmente * 100 < 66 ) and ( i / Segmente * 100 >= 33 ) then
        Canvas.Brush.Color := clYellow;
      if ( i / Segmente * 100 > 66 ) then
        Canvas.Brush.Color := clRed;
      if ( 100 - i / Segmente * 100  > percent ) then
        Canvas.Brush.Color := clGray;

      Canvas.FillRect(Rect(2, 4 * i + 2, Width - 2, 4 * i + 5));
    end;
  end;

  BitBlt(BatterieCanvas^.Handle, 0, 0, Pred(batterieBuffer^.Width), Pred(batterieBuffer^.Height),
         batterieBuffer^.Canvas.Handle, 0, 0, batterieBuffer^.Canvas.CopyMode);

end;



end.
