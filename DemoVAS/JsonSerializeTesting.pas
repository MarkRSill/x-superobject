unit JsonSerializeTesting;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, DBXJSON, Vcl.ExtCtrls,
  SMBJsonEntitiesSO, LelyAnimalsDef;

type
  TForm3 = class(TForm)
    btnStart: TButton;
    memLog: TMemo;
    MemTimer: TTimer;
    Button3: TButton;
    Button4: TButton;
    btnSuperObject: TButton;
    procedure btnStartClick(Sender: TObject);
    procedure MemTimerTimer(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure btnSuperObjectClick(Sender: TObject);
  private
    procedure LogMsg(const Msg: string);
    function GetJSONContent: TJSONValue;
    class function MBMemoryUsed: Real; static;
    function GetSuperObjectClass: TSMBResponseSO;
    function GetSuperObjectAnimals: TLelyDataClass;
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses
  System.Diagnostics, System.IOUtils, Winapi.PsAPI, jfUtils;

{$R *.dfm}

procedure TForm3.btnStartClick(Sender: TObject);
var
  ms: Real;
var
  Timer: TStopwatch;
  jv: TJSONValue;
  meta: TJSONValue;
  entitiesChk: TJSONValue;
  entities: TJSONArray;
  success: Boolean;
  entitiesCount: Integer;
  active: Integer;
  highActive: Integer;
  totalActive: Integer;
  totalHighActive: Integer;
begin
  ms := MBMemoryUsed;
  LogMsg(Format('Loading JSON into TJSONObject: %fMB', [ms]));

  Timer := TStopwatch.StartNew;
  entitiesCount := 0;
  jv := GetJSONContent;
  try
// This code was for Tokyo and haven't taken the time yet to determine how to implement in XE2
//
//    if jv. TryGetValue('meta', meta) and meta.TryGetValue('success', success) and success then begin
//      if jv.TryGetValue('entities', entitiesChk) and (entitiesChk is TJSONArray) then
//        entitiesCount := TJSONArray(entitiesChk).Count;
//    end;
//    Timer.Stop;
//    TThread.Synchronize(nil, procedure begin
//      LogMsg(Format('Loaded JSON into TJSONObject: %d items - %s  %fMB',
//        [entitiesCount, Timer.Elapsed.ToString, MBMemoryUsed - ms]));
//    end);
//
//    Timer.Start;
//    totalActive := 0;
//    totalHighActive := 0;
//    if entitiesCount > 0 then begin
//      entities := TJSONArray(entitiesChk);
//      for entitiesCount := 0 to entities.Count - 1 do
//      begin
//        if entities.Items[entitiesCount].TryGetValue('activeMinutes', active) then
//          Inc(totalActive, active);
//        if entities.Items[entitiesCount].TryGetValue('highActiveMinutes', highActive) then
//          Inc(totalHighActive, highActive);
//      end;
//    end;
//
//    SaveStringToFile(jv.ToJson, 'Test1.json');
//
//    Timer.Stop;
//    TThread.Synchronize(nil, procedure begin
//      LogMsg(Format('Total Active: %d highActive %d - %s', [totalActive, totalHighActive, Timer.Elapsed.ToString]));
//    end);
  finally
    jv.Free;
  end;
end;

procedure TForm3.btnSuperObjectClick(Sender: TObject);
var
  ms: Real;
  Timer: TStopwatch;
  jv: TLelyDataClass;
  entitiesCount: Integer;
  active: Integer;
  highActive: Integer;
  totalActive: Integer;
  totalHighActive: Integer;
  Json: string;
begin
  ms := MBMemoryUsed;
  LogMsg(Format('Loading JSON into SuperObject Class: %fMB', [ms]));

  Timer := TStopwatch.StartNew;
  entitiesCount := 0;
  jv := GetSuperObjectAnimals;
  if Assigned(jv.Animals) then
    entitiesCount := jv.Animals.Count;
  try
    Timer.Stop;
    TThread.Synchronize(nil, procedure begin
      LogMsg(Format('Loaded JSON into TLelyDataClass: %d items - %s  %fMB',
        [entitiesCount, IntToStr(Timer.Elapsed.Seconds), MBMemoryUsed - ms]));
    end);

    Timer.Start;
    totalActive := 0;
    totalHighActive := 0;
    if entitiesCount > 0 then begin
      for entitiesCount := 0 to jv.Animals.Count - 1 do
      begin
        active := Trunc(StrToIntDef(jv.Animals[entitiesCount].ID, 0));
        Inc(totalActive, active);
        highActive := Trunc(StrToIntDef(jv.Animals[entitiesCount].RESP, 0));
        Inc(totalHighActive, highActive);
      end;
    end;
    LogMsg(Format('Sum ID: %d RESP %d - %s', [totalActive, totalHighActive, IntToStr(Timer.Elapsed.Seconds)]));
    Json := jv.ToJson;
    SaveStringToFile(Json, 'Test4.json');
    Timer.Stop;

    LogMsg(Format('JSON Size: %d - %s'#13#10, [Length(Json), IntToStr(Timer.Elapsed.Seconds)]));
    if Length(Json) < 1000 then
      LogMsg(Json);
  finally
    jv.Free;
  end;
end;

procedure TForm3.Button4Click(Sender: TObject);
var
  ms: Real;
  Timer: TStopwatch;
  jv: TSMBResponseSO;
  entitiesCount: Integer;
  active: Integer;
  highActive: Integer;
  totalActive: Integer;
  totalHighActive: Integer;
  Json: string;
begin
  ms := MBMemoryUsed;
  LogMsg(Format('Loading JSON into SuperObject Class: %fMB', [ms]));

  Timer := TStopwatch.StartNew;
  entitiesCount := 0;
  jv := GetSuperObjectClass;
  if Assigned(jv.meta) and jv.meta.success and Assigned(jv.entities) then
    entitiesCount := Length(jv.entities);
  try
    Timer.Stop;
    TThread.Synchronize(nil, procedure begin
      LogMsg(Format('Loaded JSON into TSMBResponseClass: %d items - %s  %fMB',
        [entitiesCount, IntToStr(Timer.Elapsed.Seconds), MBMemoryUsed - ms]));
    end);

    Timer.Start;
    totalActive := 0;
    totalHighActive := 0;
    if entitiesCount > 0 then begin
      for entitiesCount := 0 to Length(jv.entities) - 1 do
      begin
        active := Trunc(jv.entities[entitiesCount].activeMinutes);
        Inc(totalActive, active);
        highActive := Trunc(jv.entities[entitiesCount].highActiveMinutes);
        Inc(totalHighActive, highActive);
      end;
    end;
    LogMsg(Format('Total Active: %d highActive %d - %s', [totalActive, totalHighActive, IntToStr(Timer.Elapsed.Seconds)]));
    Json := jv.ToJson;
    SaveStringToFile(Json, 'Test4.json');
    Timer.Stop;

    LogMsg(Format('JSON Size: %d - %s'#13#10, [Length(Json), IntToStr(Timer.Elapsed.Seconds)]));
    if Length(Json) < 1000 then
      LogMsg(Json);
  finally
    jv.Free;
  end;
end;

function TForm3.GetJSONContent: TJSONValue;
var
  fileName: TFileName;
begin
  fileName := TPath.Combine(ExtractFilePath(Application.ExeName),
    'Activity-20180807.json');
  Result := TJSONObject.ParseJSONValue(TFile.ReadAllText(fileName));
end;

function TForm3.GetSuperObjectAnimals: TLelyDataClass;
var
  fileName: TFileName;
begin
  fileName := TPath.Combine(ExtractFilePath(Application.ExeName), 'animals_32504509.json');
  Result := TLelyDataClass.FromJsonFile(fileName);
end;

function TForm3.GetSuperObjectClass: TSMBResponseSO;
var
  fileName: TFileName;
begin
  fileName := TPath.Combine(ExtractFilePath(Application.ExeName), 'Activity-20180807.json');
  Result := TSMBResponseSO.FromJsonFile(fileName);
end;

procedure TForm3.LogMsg(const Msg: string);
begin
  memLog.Lines.Add(Msg);
end;

class function TForm3.MBMemoryUsed: Real;
var
  MemCounters: TProcessMemoryCounters;
begin
  MemCounters.cb := SizeOf(MemCounters);
  if GetProcessMemoryInfo(GetCurrentProcess, @MemCounters, SizeOf(MemCounters))
  then
    Result := MemCounters.WorkingSetSize / 1024 / 1024
  else
    Result := 0;
end;

procedure TForm3.MemTimerTimer(Sender: TObject);
begin
  Caption := Format('JSON Test - %fMB', [MBMemoryUsed]);
end;

end.
