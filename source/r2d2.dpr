program r2d2;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  uMap in 'uMap.pas',
  uCell in 'uCell.pas',
  uR2D2 in 'uR2D2.pas',
  uGame in 'uGame.pas',
  uCellList in 'uCellList.pas',
  uTools in 'uTools.pas',
  uTypes in 'uTypes.pas',
  uSplash in 'uSplash.pas' {SplashForm};

{$R *.res}

begin
  Application.Initialize;
  SplashForm := TForm1.Create(Application);
  SplashForm.Show;
  SplashForm.Update;
  Application.CreateForm(TMainForm, MainForm);
  SplashForm.Close;
  Application.Run;
end.
