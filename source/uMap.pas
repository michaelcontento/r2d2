unit uMap;

interface

uses
  Windows, Graphics,  StrUtils, uCell, uCellList, uTypes;

type

  TMap = class(TObject)
    Map: array of array of TCell;
    CellList: TCellList;
  private
    procedure InitMap;
  public
    { Public-Deklarationen }
    constructor Create(x, y: Integer);
    destructor Destroy; override;
  end;

implementation

constructor TMap.Create(x, y: Integer);
var
  i: Integer;
begin
  inherited Create;

  // Speicherplatz für Map initialisieren
  SetLength(map, x);
  for i := 0 to x - 1 do
  begin
    SetLength(map[i], y);
  end;

  CellList := TCellList.Create(ApplicationDir + 'data\CellList.ini');
  InitMap;
end;

procedure TMap.InitMap;
var x, y: integer;
begin
  for x := 0 to Length(Map) - 1 do
  begin
    for y := 0 to Length(Map[x]) - 1 do
    begin
      Map[x, y].Def       := @CellList.Celllist[0];
      Map[x, y].isMovable := CellList.cellList[0].isMovable;
    end;
  end;
end;

destructor TMap.Destroy;
begin
  map := nil;
  CellList.Destroy;
  inherited Destroy;
end;

end.
