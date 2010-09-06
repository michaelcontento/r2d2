unit uTypes;

interface

uses Forms, SysUtils;

type
  TWay = (NORTH, SOUTH, WEST, EAST);

  TStep = record
    posX: Integer;
    posY: Integer;
    way: TWay;
  end;

const
  LEFT   = 65;
  RIGHT  = 68;
  FORWRD = 87;
  BCKWRD = 83;

var
  ApplicationDir: string;
implementation

begin
  ApplicationDir := ExtractFilePath(Application.ExeName);
end.
