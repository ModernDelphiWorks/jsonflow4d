unit JsonFlow.SchemaRefSynapse;

interface

uses
  SysUtils,
  Classes,
  SynapseHTTP,
  JsonFlow.Interfaces,
  JsonFlow.Reader;

type
  TJSONSchemaRefSynapse = class(TInterfacedObject, IJSONSchemaRef)
  private
    FHTTP: TSynapseHTTPClient;
    FReader: TJSONReader;
  public
    constructor Create;
    destructor Destroy; override;
    function FetchReference(const ARef: string): IJSONElement;
  end;

implementation

constructor TJSONSchemaRefSynapse.Create;
begin
  FHTTP := TSynapseHTTPClient.Create;
  FReader := TJSONReader.Create;
end;

destructor TJSONSchemaRefSynapse.Destroy;
begin
  FReader.Free;
  FHTTP.Free;
  inherited;
end;

function TJSONSchemaRefSynapse.FetchReference(const ARef: string): IJSONElement;
var
  LStream: TStringStream;
  LResponse: string;
begin
  LStream := TStringStream.Create;
  try
    LResponse := FHTTP.Get(ARef);
    LStream.WriteString(LResponse);
    LStream.Position := 0;
    Result := FReader.ReadFromStream(LStream);
  except
    on E: Exception do
      raise EInvalidOperation.CreateFmt('Failed to fetch reference "%s": %s', [ARef, E.Message]);
  finally
    LStream.Free;
  end;
end;

end.
