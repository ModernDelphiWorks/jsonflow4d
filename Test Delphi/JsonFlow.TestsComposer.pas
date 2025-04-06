﻿unit JsonFlow.TestsComposer;

interface

uses
  SysUtils,
  Variants,
  Classes,
  DUnitX.TestFramework,
  JsonFlow.Interfaces,
  JsonFlow.Writer,
  JsonFlow.Composer;

type
  [TestFixture]
  TJSONComposerTests = class
  public
    [Test]
    procedure TestSimpleObject;
    [Test]
    procedure TestNestedArray;
    [Test]
    procedure TestAddChar;
    [Test]
    procedure TestAddVariant;
    [Test]
    procedure TestForEachObject;
    [Test]
    procedure TestClear;
    [Test]
    procedure TestAddJSON;
    [Test]
    procedure TestAddTArrayInteger;
    [Test]
    procedure TestAddTArrayChar;
    [Test]
    procedure TestAddTArrayVariant;
    [Test]
    procedure TestMerge;
    [Test]
    procedure TestLoadAndEditJSON;
    [Test]
    procedure TestAddObjectToArray;
    [Test]
    procedure TestAddArrayToArray;
    [Test]
    procedure TestMergeArray;
    [Test]
    procedure TestRemoveFromArray;
    [Test]
    procedure TestReplaceArray;
    [Test]
    procedure TestAddObject;
    [Test]
    procedure TestRemoveKey;
    [Test]
    procedure TestClone;
    [Test]
    procedure TestSetValueWithIndex;
    [Test]
    procedure TestAddToArrayWithIndex;
  end;

implementation

procedure TJSONComposerTests.TestSimpleObject;
var
  LComposer: TJSONComposer;
begin
  LComposer := TJSONComposer.Create;
  LComposer.BeginObject
    .Add('nome', 'João')
    .Add('idade', 30)
    .EndObject;
  Assert.AreEqual('{"nome":"João","idade":30}', LComposer.ToJSON);
  LComposer.Free;
end;

procedure TJSONComposerTests.TestNestedArray;
var
  LComposer: TJSONComposer;
begin
  LComposer := TJSONComposer.Create;
  LComposer.BeginObject
    .BeginObject('pessoa')
    .Add('nome', 'João')
    .AddArray('notas', [85, 90, 95])
    .EndObject
    .EndObject;
  Assert.AreEqual('{"pessoa":{"nome":"João","notas":[85,90,95]}}', LComposer.ToJSON);
  LComposer.Free;
end;

procedure TJSONComposerTests.TestAddChar;
var
  LComposer: TJSONComposer;
begin
  LComposer := TJSONComposer.Create;
  LComposer.BeginObject
    .Add('letra', 'A')
    .EndObject;
  Assert.AreEqual('{"letra":"A"}', LComposer.ToJSON);
  LComposer.Free;
end;

procedure TJSONComposerTests.TestAddVariant;
var
  LComposer: TJSONComposer;
begin
  LComposer := TJSONComposer.Create;
  LComposer.BeginObject;
  LComposer.Add('numero', 42);
  LComposer.Add('decimal', 3.14);
  LComposer.Add('flag', True);
  LComposer.Add('data', Now);
  LComposer.Add('nulo', Null);
  LComposer.EndObject;
  Assert.AreEqual('{"numero":42,"decimal":3.14,"flag":true,"data":"' + FormatDateTime('yyyy-mm-dd"T"hh:nn:ss', Now) + '","nulo":null}', LComposer.ToJSON);
  LComposer.Free;
end;

procedure TJSONComposerTests.TestForEachObject;
var
  LComposer: TJSONComposer;
  LOutput: TStringBuilder;
begin
  LOutput := TStringBuilder.Create;
  try
    LComposer := TJSONComposer.Create;
    LComposer.BeginObject
      .Add('nome', 'João')
      .Add('idade', 30)
      .ForEach(procedure(AName: String; AValue: IJSONElement)
               begin
                 LOutput.Append(AName).Append('=').Append(AValue.AsJSON).Append(';');
               end)
      .EndObject;
    Assert.AreEqual('nome="João";idade=30;', LOutput.ToString);
  finally
    LOutput.Free;
  end;
  LComposer.Free;
end;

procedure TJSONComposerTests.TestClear;
var
  LComposer: TJSONComposer;
begin
  LComposer := TJSONComposer.Create;
  LComposer.BeginObject
    .Add('nome', 'João')
    .EndObject;
  Assert.AreEqual('{"nome":"João"}', LComposer.ToJSON);
  LComposer.Clear
    .BeginObject
    .Add('outro', 'teste')
    .EndObject;
  Assert.AreEqual('{"outro":"teste"}', LComposer.ToJSON);
  LComposer.Free;
end;

procedure TJSONComposerTests.TestAddJSON;
var
  LComposer: TJSONComposer;
begin
  LComposer := TJSONComposer.Create;
  LComposer.BeginObject
    .AddJSON('data', '{"key":"value"}')
    .EndObject;
  Assert.AreEqual('{"data":{"key":"value"}}', LComposer.ToJSON);
  LComposer.Free;
end;

procedure TJSONComposerTests.TestAddTArrayInteger;
var
  LComposer: TJSONComposer;
begin
  LComposer := TJSONComposer.Create;
  LComposer.BeginObject
    .Add('numeros', TArray<Integer>.Create(1, 2, 3))
    .EndObject;
  Assert.AreEqual('{"numeros":[1,2,3]}', LComposer.ToJSON);
  LComposer.Free;
end;

procedure TJSONComposerTests.TestAddTArrayChar;
var
  LComposer: TJSONComposer;
begin
  LComposer := TJSONComposer.Create;
  LComposer.BeginObject
    .Add('letras', TArray<Char>.Create('A', 'B', 'C'))
    .EndObject;
  Assert.AreEqual('{"letras":["A","B","C"]}', LComposer.ToJSON);
  LComposer.Free;
end;

procedure TJSONComposerTests.TestAddTArrayVariant;
var
  LComposer: TJSONComposer;
begin
  LComposer := TJSONComposer.Create;
  LComposer.BeginObject
    .Add('mix', TArray<Variant>.Create(42, 'texto', True))
    .EndObject;
  Assert.AreEqual('{"mix":[42,"texto",true]}', LComposer.ToJSON);
  LComposer.Free;
end;

procedure TJSONComposerTests.TestMerge;
var
  LComposer, LOther: TJSONComposer;
begin
  LComposer := TJSONComposer.Create;
  LOther := TJSONComposer.Create;
  LOther.BeginObject
    .Add('idade', 30)
    .Add('ativo', True)
    .EndObject;
  LComposer.BeginObject
    .Add('nome', 'João')
    .Merge(LOther.ToElement)
    .EndObject;
  Assert.AreEqual('{"nome":"João","idade":30,"ativo":true}', LComposer.ToJSON);
  LComposer.Free;
  LOther.Free;
end;

procedure TJSONComposerTests.TestLoadAndEditJSON;
var
  LComposer: TJSONComposer;
begin
  LComposer := TJSONComposer.Create;
  LComposer.LoadJSON('{"pessoa":{"nome":"João","notas":[85,90]}}')
    .AddToArray('pessoa.notas', 95)
    .SetValue('pessoa.nome', 'Maria');
  Assert.AreEqual('{"pessoa":{"nome":"Maria","notas":[85,90,95]}}', LComposer.ToJSON);
  LComposer.Free;
end;

procedure TJSONComposerTests.TestAddObjectToArray;
var
  LComposer, LObject: TJSONComposer;
begin
  LComposer := TJSONComposer.Create;
  LObject := TJSONComposer.Create;
  LObject.BeginObject
    .Add('id', 2)
    .Add('nome', 'teste')
    .EndObject;
  LComposer.LoadJSON('{"pessoa":{"nome":"João","itens":[{"id":1}]}}')
    .AddToArray('pessoa.itens', LObject.ToElement);
  Assert.AreEqual('{"pessoa":{"nome":"João","itens":[{"id":1},{"id":2,"nome":"teste"}]}}', LComposer.ToJSON);
  LComposer.Free;
  LObject.Free;
end;

procedure TJSONComposerTests.TestAddArrayToArray;
var
  LComposer: TJSONComposer;
begin
  LComposer := TJSONComposer.Create;
  LComposer.LoadJSON('{"pessoa":{"nome":"João","notas":[85,90]}}')
    .AddToArray('pessoa.notas', TArray<Variant>.Create(95, 100));
  Assert.AreEqual('{"pessoa":{"nome":"João","notas":[85,90,[95,100]]}}', LComposer.ToJSON);
  LComposer.Free;
end;

procedure TJSONComposerTests.TestMergeArray;
var
  LComposer: TJSONComposer;
begin
  LComposer := TJSONComposer.Create;
  LComposer.LoadJSON('{"pessoa":{"nome":"João","notas":[85,90]}}')
    .MergeArray('pessoa.notas', TArray<Variant>.Create(95, 100));
  Assert.AreEqual('{"pessoa":{"nome":"João","notas":[85,90,95,100]}}', LComposer.ToJSON);
  LComposer.Free;
end;

procedure TJSONComposerTests.TestRemoveFromArray;
var
  LComposer: TJSONComposer;
begin
  LComposer := TJSONComposer.Create;
  LComposer.LoadJSON('{"pessoa":{"nome":"João","notas":[85,90,95]}}')
    .RemoveFromArray('pessoa.notas', 1);
  Assert.AreEqual('{"pessoa":{"nome":"João","notas":[85,95]}}', LComposer.ToJSON);
  LComposer.Free;
end;

procedure TJSONComposerTests.TestReplaceArray;
var
  LComposer: TJSONComposer;
begin
  LComposer := TJSONComposer.Create;
  LComposer.LoadJSON('{"pessoa":{"nome":"João","notas":[85,90]}}')
    .ReplaceArray('pessoa.notas', TArray<Variant>.Create(1, 2, 3));
  Assert.AreEqual('{"pessoa":{"nome":"João","notas":[1,2,3]}}', LComposer.ToJSON);
  LComposer.Free;
end;

procedure TJSONComposerTests.TestAddObject;
var
  LComposer: TJSONComposer;
begin
  LComposer := TJSONComposer.Create;
  LComposer.LoadJSON('{"pessoa":{"nome":"João"}}')
    .AddObject('pessoa', 'filho')
    .Add('nome', 'Ana')
    .EndObject;
  Assert.AreEqual('{"pessoa":{"nome":"João","filho":{"nome":"Ana"}}}', LComposer.ToJSON);
  LComposer.Free;
end;

procedure TJSONComposerTests.TestRemoveKey;
var
  LComposer: TJSONComposer;
begin
  LComposer := TJSONComposer.Create;
  LComposer.LoadJSON('{"pessoa":{"nome":"João","idade":30}}')
    .RemoveKey('pessoa.idade');
  Assert.AreEqual('{"pessoa":{"nome":"João"}}', LComposer.ToJSON);
  LComposer.Free;
end;

procedure TJSONComposerTests.TestClone;
var
  LComposer: TJSONComposer;
  LCloned: IJSONElement;
  LJSONWriter: IJSONWriter;
begin
  LComposer := TJSONComposer.Create;
  LJSONWriter := TJSONWriter.Create;
  LComposer.LoadJSON('{"pessoa":{"nome":"João","notas":[85,90]}}');
  LCloned := LComposer.Clone;
  LComposer.SetValue('pessoa.nome', 'Maria');
  Assert.AreEqual('{"pessoa":{"nome":"João","notas":[85,90]}}', LJSONWriter.Write(LCloned));
  Assert.AreEqual('{"pessoa":{"nome":"Maria","notas":[85,90]}}', LComposer.ToJSON);
  LComposer.Free;
end;

procedure TJSONComposerTests.TestSetValueWithIndex;
var
  LComposer: TJSONComposer;
begin
  LComposer := TJSONComposer.Create;
  LComposer.LoadJSON('{"pessoa":{"nome":"João","notas":[85,90]}}')
    .SetValue('pessoa.notas[1]', 95);
  Assert.AreEqual('{"pessoa":{"nome":"João","notas":[85,95]}}', LComposer.ToJSON);
  LComposer.Free;
end;

procedure TJSONComposerTests.TestAddToArrayWithIndex;
var
  LComposer: TJSONComposer;
begin
  LComposer := TJSONComposer.Create;
  LComposer.LoadJSON('{"pessoa":{"nome":"João","notas":[85,90]}}')
    .AddToArray('pessoa.notas[1]', 95);
  Assert.AreEqual('{"pessoa":{"nome":"João","notas":[85,95,90]}}', LComposer.ToJSON);
  LComposer.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TJSONComposerTests);

end.
