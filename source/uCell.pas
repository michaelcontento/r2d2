// Stift - Kommentare kommen noch ^^
unit uCell;

interface

uses
  graphics;

type
  TCellDef = class (TObject)
      Index    : Integer;
      imgGround: TBitmap; // Untergrund textur
      imgMain  : TBitmap; // Hauttextur (einheit, ...)
      name     : string;
      isMovable: boolean;
      costs    : integer; // Wegkosten

      constructor Create;
      destructor Destroy; override;
  end;

  TCell = record
    isMovable: boolean;
    Def: ^TCellDef;
  end;

implementation

uses SysUtils;

constructor TCellDef.Create;
begin
  inherited Create;

  imgGround := TBitmap.Create;
  imgMain   := TBitmap.Create;

end;

destructor TCellDef.Destroy;
begin
  imgGround.Free;
  imgMain.Free;

  inherited Destroy;
end;

end.


