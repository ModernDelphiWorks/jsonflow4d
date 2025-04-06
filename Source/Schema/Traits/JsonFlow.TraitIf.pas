unit JsonFlow.TraitIf;

interface

uses
  SysUtils,
  Generics.Collections,
  JsonFlow.Value,
  JsonFlow.Interfaces,
  JsonFlow.SchemaValidator;

type
  TIfTrait = class(TJsonSchemaTrait)
  private
    FCondition: TSchemaNode;
  public
    constructor Create(const AValidator: TJSONSchemaValidator); override;
    destructor Destroy; override;
    procedure Parse(const ANode: IJSONObject); override;
    function Validate(const ANode: IJSONElement; const APath: String;
      const AErrors: TList<TValidationError>): Boolean; override;
  end;

implementation

constructor TIfTrait.Create(const AValidator: TJSONSchemaValidator);
begin
  inherited Create(AValidator);

end;

destructor TIfTrait.Destroy;
begin
  FCondition.Free;
  inherited;
end;

procedure TIfTrait.Parse(const ANode: IJSONObject);
begin
  if ANode.ContainsKey('if') then
    FCondition := FValidator.ParseNode(ANode.GetValue('if'), '/if');
end;

function TIfTrait.Validate(const ANode: IJSONElement; const APath: String;
  const AErrors: TList<TValidationError>): Boolean;
var
  LThenNode, LElseNode: TSchemaNode;
  LConditionErrors: TList<TValidationError>;
  LFor: Integer;
begin
  Result := True;
  if Assigned(FCondition) then
  begin
    LConditionErrors := TList<TValidationError>.Create;
    try
      if FCondition.Trait.Validate(ANode, APath + '/if', LConditionErrors) then
      begin
        for LFor := 0 to FCondition.Children.Count - 1 do
          if FCondition.Children[LFor].Keyword = 'then' then
          begin
            LThenNode := FCondition.Children[LFor];
            Result := LThenNode.Trait.Validate(ANode, APath, AErrors);
            Break;
          end;
      end
      else
      begin
        AErrors.AddRange(LConditionErrors);
        for LFor := 0 to FCondition.Children.Count - 1 do
          if FCondition.Children[LFor].Keyword = 'else' then
          begin
            LElseNode := FCondition.Children[LFor];
            Result := LElseNode.Trait.Validate(ANode, APath, AErrors);
            Break;
          end;
      end;
    finally
      LConditionErrors.Free;
//      LThenNode := nil;
//      LElseNode := nil;
    end;
  end;
end;

end.
