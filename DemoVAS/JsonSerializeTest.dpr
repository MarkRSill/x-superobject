program JsonSerializeTest;

uses
  Vcl.Forms,
  JsonSerializeTesting in 'JsonSerializeTesting.pas' {Form3},
  jfUtils in 'jfUtils.pas',
  SMBJsonEntitiesSO in 'SMBJsonEntitiesSO.pas',
  LelyAnimalsDef in 'LelyAnimalsDef.pas';

{$R *.res}

begin
  //ReportMemoryLeaksOnShutdown := DebugHook <> 0;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
