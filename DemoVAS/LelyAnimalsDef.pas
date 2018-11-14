unit LelyAnimalsDef;

(*

{
  "Animals": [{
    "ID": "3287",
    "REG": "982000417793713",
    "RESP": "100111",
    "Gender": "F",
    "BDAT": "20111015",
    "FPEN": "33",
    "FDAT": "20170811",
    "CDAT": "20180518",
    "RC": "1",
    "ABDAT": "",
    "DDAT": "20181029",
    "PODAT": "20181030",
    "ARDAT": "20181031",
    "CAR": 0,
    "Deleted": false
  },
  {
    "ID": "3288",
    "REG": "982000417793714",
    "RESP": "100112",
    "Gender": "F",
    "BDAT": "20111016",
    "FPEN": "33",
    "FDAT": "20170811",
    "CDAT": "20180518",
    "RC": "1",
    "ABDAT": "",
    "DDAT": "20181029",
    "PODAT": "",
    "ARDAT": "",
    "CAR": 8,
    "Deleted": false
  }]
}
*)

interface

uses
  Generics.Collections;

type
  TAnimalsClass = class
  private
    FID: string;
    FREG: string;
    FRESP: string;
    FGender: string;
    FBDAT: TDate;
    FFPEN: string;
    FFDAT: TDate;
    FCDAT: TDate;
    FRC: string;
    FABDAT: TDate;
    FDDAT: TDate;
    FPODAT: TDate;
    FARDAT: TDate;
    FCAR: Extended;
    FDeleted: Boolean;
  public
    property ID: string read FID write FID;
    property REG: string read FREG write FREG;
    property RESP: string read FRESP write FRESP;
    property Gender: string read FGender write FGender;
    property BDAT: TDate read FBDAT write FBDAT;
    property FPEN: string read FFPEN write FFPEN;
    property FDAT: TDate read FFDAT write FFDAT;
    property CDAT: TDate read FCDAT write FCDAT;
    property RC: string read FRC write FRC;
    property ABDAT: TDate read FABDAT write FABDAT;
    property DDAT: TDate read FDDAT write FDDAT;
    property PODAT: TDate read FPODAT write FPODAT;
    property ARDAT: TDate read FARDAT write FARDAT;
    property CAR: Extended read FCAR write FCAR;
    property Deleted: Boolean read FDeleted write FDeleted;
  end;

  TLelyDataClass = class
  private
    FAnimals: TList<TAnimalsClass>;
  public
    destructor Destroy; override;

    function ToJson: string;

    class function FromJsonFile(const AFileName: string): TLelyDataClass;

    property Animals: TList<TAnimalsClass> read FAnimals write FAnimals;
  end;

implementation

uses
  XSuperObject, System.IOUtils;

{ TLelyDataClass }

destructor TLelyDataClass.Destroy;
var
  AnimalsItem: TAnimalsClass;
begin
  for AnimalsItem in FAnimals do
    AnimalsItem.Free;

  inherited;
end;

class function TLelyDataClass.FromJsonFile(const AFileName: string): TLelyDataClass;
begin
  Result := Self.FromJSON(TFile.ReadAllText(AFileName));
end;

function TLelyDataClass.ToJson: string;
begin
  try
    Result := Self.AsJSON;
  except
    Result := '{}';
  end;
end;

end.
