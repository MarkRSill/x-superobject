unit DemoUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm2 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses
  XSuperJSON, XSuperObject, System.Generics.Collections;

{$R *.dfm}

type
  TSubClass = class
    A: Integer;
    B: Integer;
  end;

  TMyClass = class
  private
    FField: Integer;
    FSampler: string;
    FSubClass: TSubClass;
  published
    property field: Integer read FField write FField;
    property subClass: TSubClass read FSubClass write FSubClass;
  end;

procedure TForm2.Button3Click(Sender: TObject);
var
  MyClass: TMyClass;
  S: string;
begin
  Memo1.Lines.Clear;

  MyClass := TMyClass.FromJSON('{"field":12}'); //,"subClass":{"A":208,"B":39}}');
  if MyClass.field = 12 then
    Memo1.Lines.Add('MyClass.field has the correct value of 12');
  if Assigned(MyClass.subClass) and (MyClass.subClass.A = 208) then
    Memo1.Lines.Add('MyClass.subClass.A has the correct value of 208');

  S := MyClass.AsJSON;
  Memo1.Lines.Add(S);

  if not Assigned(MyClass.subClass) then
    MyClass.subClass := TSubClass.Create;
  MyClass.subClass.A := 345;
  MyClass.subClass.B := 1024;

  S := MyClass.AsJSON;
  Memo1.Lines.Add(S);
end;




type
  TTestSet = (ttA, ttB, ttC);

  TTestSets = set of TTestSet;

  TSubRec = record
    A: Integer;
    B: String;
  end;

  TSubObj = class
    A: Integer;
    B: Integer;
  end;

  TTest = class // Field, Property Support
  private
    FB: String;
    FSubObj: TSubObj;
    FSubRec: TSubRec;
    FTestSets: TTestSets;
    FH: TDateTime;
    FJ: TDate;
    FK: TTime;
    FList: TObjectList<TSubObj>; // or TList<>; But only object types are supported
  public
    A: Integer;
    B: TTestSet;
    C: Boolean;
    property D: String read FB write FB;
    property E: TSubRec read FSubRec write FSubRec;
    property F: TSubObj read FSubObj write FSubObj;
    property G: TTestSets read FTestSets write FTestSets;
    property H: TDateTime read FH write FH;
    property J: TDate read FJ write FJ;
    property K: TTime read FK write FK;
    property L: TObjectList<TSubObj> read FList write FList;
  end;

  TTestRec = record // Only Field Support
    A: Integer;
    B: TTestSet;
    C: Boolean;
    D: String;
    E: TSubRec;
    F: TSubObj;
    G: TTestSets;
    H: TDateTime;
    J: TDate;
    K: TTime;
    L: TObjectList<TSubObj>; // or TList<>; But only object types are supported
  end;

procedure TForm2.Button1Click(Sender: TObject);
var
  Parse: TTest; // For Class;
  S: String;
begin
  Parse := TTest.FromJSON('{"A": 1, "B": 0, "C": true, "D": "Hello", "E":{"A": 3, "B": "Delphi"}, "F": {"A": 4, "B": 5}, "G": [0,2], "H": "2014-05-03T03:25:05.059", "J": "2014-05-03", "K": "03:25:05", "L":[{"A": 4, "B": 5},{"A": 6, "B": 7}] }');
  S := Parse.AsJSON;

  Memo1.Lines.Text := S;
end;

procedure TForm2.Button2Click(Sender: TObject);
var
  Parse: TTestRec; // For Record;
  S: String;
begin
  Parse := TJSON.Parse<TTestRec>('{"A": 1, "B": 0, "C": true, "D": "Hello", "E":{"A": 3, "B": "Delphi"}, "F": {"A": 4, "B": 5}, "G": [0,2], "H": "2014-05-03T03:25:05.059", "J": "2014-05-03", "K": "03:25:05", "L":[{"A": 4, "B": 5},{"A": 6, "B": 7}]}');
  S := TJSON.Stringify<TTestRec>(Parse);

  Memo1.Lines.Text := S;
end;

end.













    uses
      XSuperJSON, XSuperObject;

    type
      TSubClass = class
        A: Integer;
        B: Integer;
      end;

      TMyClass = class
      private
        FField: Integer;
        FSampler: TDateTime;
        FSubClass: TSubClass;
      published
        property field: Integer read FField write FField;
        property sampler: TDateTime read FSampler write FSampler;
        property subClass: TSubClass read FSubClass write FSubClass;
      end;

    procedure TForm2.Button3Click(Sender: TObject);
    var
      MyClass: TMyClass;
      S: string;
    begin
      Memo1.Lines.Clear;

      MyClass := TMyClass.FromJSON('{"field":12}'); //,"subClass":{"A":208,"B":39}}');
      if MyClass.field = 12 then
        Memo1.Lines.Add('MyClass.field has the correct value of 12');
      if Assigned(MyClass.subClass) and (MyClass.subClass.A = 208) then
        Memo1.Lines.Add('MyClass.subClass.A has the correct value of 208');

      S := MyClass.AsJSON;
      Memo1.Lines.Add(S);

      if not Assigned(MyClass.subClass) then
        MyClass.subClass := TSubClass.Create;
      MyClass.subClass.A := 345;
      MyClass.subClass.B := 1024;
      MyClass.sampler := now;

      S := MyClass.AsJSON;
      Memo1.Lines.Add(S);
    end;

