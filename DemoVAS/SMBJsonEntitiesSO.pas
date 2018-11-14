unit SMBJsonEntitiesSO;

interface

uses
  Generics.Collections, XSuperJSON, XSuperObject;

type
  TErrors = class
  private
    FCode: Integer;
    FMessage: string;
  public
    property code: Integer read FCode write FCode;
    property message: string read FMessage write FMessage;
  end;

  TMetaSO = class
  private
    FErrors: TArray<TErrors>;
    FRecordCount: Integer;
    FStatus: string;
    FSuccess: Boolean;
  public
    destructor Destroy; override;

    property success: Boolean read FSuccess write FSuccess;
    property status: string read FStatus write FStatus;
    property recordCount: Integer read FRecordCount write FRecordCount;
    //[REVAL(roEmptyArrayToNull)]
    property errors: TArray<TErrors> read FErrors write FErrors;
  end;

  TValueSO = class
  private
    FClosed: Boolean;
    FClosedAt: TDateTime;
    FMaxValue: Extended;
    FMinValue: Extended;
    FPreviousValue: Extended;
    FValue: Extended;
  public
    property closed: Boolean read FClosed write FClosed;
    property closedAt: TDateTime read FClosedAt write FClosedAt;
    property maxValue: Extended read FMaxValue write FMaxValue;
    property minValue: Extended read FMinValue write FMinValue;
    property previousValue: Extended read FPreviousValue write FPreviousValue;
    property value: Extended read FValue write FValue;
  end;

  TEntitiesSO = class
  private
    FAssignedToAnimal: string;
    FClosed: Boolean;
    FCreatedOn: TDateTime;
    FId: Integer;
    FKey: string;
    FSender: string;
    FValue: TValueSO;
    FDay: string;
    FEartag: string;
    FHour: Integer;
    FRuminateMinutes: Integer;
    FActiveMinutes: Integer;
    FHighActiveMinutes: Integer;
    FInactiveMinutes: Integer;
    FAnimalEartag: string;
    Fanimalnumber: Integer;
    FDeviceMac: string;
    FAssignedTo: string;
    FCreatedBy: string;
    FDate: string;
    FUid: string;
    FArchived: Boolean;
    FBirthdate: TDate;
    FDeleted: Boolean;
    FDelivery: string;
    FDevice: string;
    FLabel: string;
  public
    constructor Create;
    destructor Destroy; override;

    property assignedToAnimal: string read FAssignedToAnimal write FAssignedToAnimal;
    property closed: Boolean read FClosed write FClosed;
    property createdOn: TDateTime read FCreatedOn write FCreatedOn;
    property id: Integer read FId write FId;
    property key: string read FKey write FKey;
    property sender: string read FSender write FSender;
    property value: TValueSO read FValue write FValue;
    property eartag: string read FEartag write FEartag;
    property day: string read FDay write FDay;
    property hour: Integer read FHour write FHour;
    property ruminateMinutes: Integer read FRuminateMinutes write FRuminateMinutes;
    property activeMinutes: Integer read FActiveMinutes write FActiveMinutes;
    property highActiveMinutes: Integer read FHighActiveMinutes write FHighActiveMinutes;
    property inactiveMinutes: Integer read FInactiveMinutes write FInactiveMinutes;
    property animalEartag: string read FAnimalEartag write FAnimalEartag;
    property animalnumber: Integer read Fanimalnumber write Fanimalnumber;
    property deviceMac: string read FDeviceMac write FDeviceMac;
    property assignedTo: string read FAssignedTo write FAssignedTo;
    property createdBy: string read FCreatedBy write FCreatedBy;
    property date: string read FDate write FDate;
    property uid: string read FUid write FUid;
    property archived: Boolean read FArchived write FArchived;
    property birthdate: TDate read FBirthdate write FBirthdate;
    property deleted: Boolean read FDeleted write FDeleted;
    property delivery: string read FDelivery write FDelivery;
    property device: string read FDevice write FDevice;
    [ALIAS('label')]
    property &label: string read FLabel write FLabel;
  end;

  TSMBResponseSO = class
  private
    FEntities: TArray<TEntitiesSO>;
    FMeta: TMetaSO;
  public
    constructor Create;
    destructor Destroy; override;

    function ToJson: string;
    class function FromJsonString(const AJsonString: string): TSMBResponseSO;
    class function FromJsonFile(const AFileName: string): TSMBResponseSO;

    property meta: TMetaSO read FMeta write FMeta;
    //[REVAL(roEmptyArrayToNull)]
    property entities: TArray<TEntitiesSO> read FEntities write FEntities;
  end;

implementation

uses
  System.IOUtils;

{ TMetaSO }

destructor TMetaSO.Destroy;
var
  errorsItem: TErrors;
begin
  for errorsItem in FErrors do
    errorsItem.Free;

  inherited;
end;

{ TEntitiesSO }

constructor TEntitiesSO.Create;
begin
  inherited;
//FValue := TValueSO.Create();
end;

destructor TEntitiesSO.Destroy;
begin
//FValue.Free;
  inherited;
end;

{ TSMBResponse }

constructor TSMBResponseSO.Create;
begin
  inherited;
  FMeta := TMetaSO.Create();
end;

destructor TSMBResponseSO.Destroy;
var
  entitiesItem: TEntitiesSO;
begin
  for entitiesItem in FEntities do
    entitiesItem.Free;

  FMeta.Free;
  inherited;
end;

function TSMBResponseSO.ToJson: string;
begin
  try
    Result := Self.AsJSON; //TgoBsonSerializer.Serialize(Self, Result);
  except
    Result := '{}';
  end;
end;

class function TSMBResponseSO.FromJsonFile(const AFileName: string): TSMBResponseSO;
begin
  // Result := Self.Create;
  Result := Self.FromJSON(TFile.ReadAllText(AFileName));
   //TgoBsonSerializer.Deserialize(TFile.ReadAllText(AFileName), Result);
end;

class function TSMBResponseSO.FromJsonString(const AJsonString: string): TSMBResponseSO;
begin
  Result := nil;
  Result := Self.FromJSON(AJsonString);
  //TgoBsonSerializer.Deserialize(AJsonString, Result);
end;

end.

