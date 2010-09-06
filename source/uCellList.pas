// Stift - Kommentare kommen noch ^^
unit uCellList;

interface

uses
  iniFiles, Math, SysUtils, StdCtrls, classes, uCell;

type
  TCellList = class (TObject)
    cellList: array of TCellDef;
  private
    iniPath : string;
    procedure fillCellList;
  public
    constructor Create(path: string);
    destructor Destroy; override;
    function indexOf(itemName: string): integer;
  end;

implementation


constructor TCellList.Create(path: string);
begin
  inherited Create;

  if FileExists(path) then
  begin
    iniPath := path;
    fillCellList;
  end;
end;

destructor TCellList.Destroy;
var
  i: Integer;
begin

  for i := 0 to Length(celllist) - 1 do
    cellList[i].Free;

  SetLength(cellList, 0);

  inherited Destroy;
end;

procedure TCellList.fillCellList;
var ini: TIniFile;
    iniSections: TStringList;
    i: integer;
begin
  // Initialisierung
  ini         := TIniFile.Create(iniPath);
  iniSections := TStringList.Create;

  // Sectionen Herausfinden und Arraylänge setzen
  ini.ReadSections(iniSections);
  SetLength(cellList, iniSections.Count);

  // Arrayfüllen
  for i := 0 to iniSections.Count - 1 do
  begin
    cellList[i]           := TCellDef.Create;
    cellList[i].Index     := i;
    cellList[i].name      := ini.ReadString (iniSections.Strings[i], 'name', 'Error: CellList.ini No Name');
    cellList[i].isMovable := ini.ReadBool   (iniSections.Strings[i], 'movable', false);
    cellList[i].costs     := ini.ReadInteger(iniSections.Strings[i], 'costs', 1);

    if FileExists(ini.ReadString            (iniSections.Strings[i], 'imgGround', '')) then
      cellList[i].imgGround.LoadFromFile    (ini.ReadString(iniSections.Strings[i], 'imgGround', ''));

    if FileExists(ini.ReadString            (iniSections.Strings[i], 'imgMain', '')) then
      cellList[i].imgMain.LoadFromFile      (ini.ReadString(iniSections.Strings[i], 'imgMain', ''));
  end;

  // Aufräumen
  iniSections.Free;
  ini.Free;
end;

function TCellList.indexOf(itemName: string): integer;
var i, ergebnis: integer;
    ok: boolean;
begin
  ok := false;
  ergebnis := -1;
  i  := 0;

  while (i <= Length(cellList) - 1)
  and   (ok = false) do
  begin
    if itemName = cellList[i].name then
    begin
      ergebnis := i;
      ok     := true;
    end;
    i := i + 1;
  end;

  result := ergebnis;
end;

end.
