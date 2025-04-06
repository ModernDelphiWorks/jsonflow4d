program TestJsonFlow4D;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}
{$STRONGLINKTYPES ON}
uses
  FastMM4,
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ELSE}
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  {$ENDIF }
  DUnitX.TestFramework,
  JsonFlow.Arrays in '..\Source\Core\JsonFlow.Arrays.pas',
  JsonFlow.Interfaces in '..\Source\Core\JsonFlow.Interfaces.pas',
  JsonFlow.Objects in '..\Source\Core\JsonFlow.Objects.pas',
  JsonFlow.Pair in '..\Source\Core\JsonFlow.Pair.pas',
  JsonFlow in '..\Source\JsonFlow.pas',
  JsonFlow.Reader in '..\Source\Core\JsonFlow.Reader.pas',
  JsonFlow.Serializer in '..\Source\Core\JsonFlow.Serializer.pas',
  JsonFlow.Value in '..\Source\Core\JsonFlow.Value.pas',
  JsonFlow.Writer in '..\Source\Core\JsonFlow.Writer.pas',
  JsonFlow.Utils in '..\Source\Core\JsonFlow.Utils.pas',
  JsonFlow.Navigator in '..\Source\Core\JsonFlow.Navigator.pas',
  JsonFlow.Composer in '..\Source\Core\JsonFlow.Composer.pas',
  JsonFlow.SchemaReader in '..\Source\Schema\JsonFlow.SchemaReader.pas',
  JsonFlow.MiddlewareDatatime in '..\Source\Middleware\JsonFlow.MiddlewareDatatime.pas',
  JsonFlow.SchemaRefIndy in '..\Source\Http\JsonFlow.SchemaRefIndy.pas',
  JsonFlow.SchemaNavigator in '..\Source\Schema\JsonFlow.SchemaNavigator.pas',
  JsonFlow.SchemaComposer in '..\Source\Schema\JsonFlow.SchemaComposer.pas',
  JsonFlow.Schema in '..\Source\Schema\JsonFlow.Schema.pas',
  JsonFlowTestsShemaComposer in 'JsonFlowTestsShemaComposer.pas',
  JsonFlow.SchemaValidator in '..\Source\Schema\JsonFlow.SchemaValidator.pas',
  JsonFlow.TraitType in '..\Source\Schema\Traits\JsonFlow.TraitType.pas',
  JsonFlow.TraitDeprecated in '..\Source\Schema\Traits\JsonFlow.TraitDeprecated.pas',
  JsonFlow.TraitWriteOnly in '..\Source\Schema\Traits\JsonFlow.TraitWriteOnly.pas',
  JsonFlow.TraitReadOnly in '..\Source\Schema\Traits\JsonFlow.TraitReadOnly.pas',
  JsonFlow.TraitExamples in '..\Source\Schema\Traits\JsonFlow.TraitExamples.pas',
  JsonFlow.TraitDefault in '..\Source\Schema\Traits\JsonFlow.TraitDefault.pas',
  JsonFlow.TraitDescription in '..\Source\Schema\Traits\JsonFlow.TraitDescription.pas',
  JsonFlow.TraitTitle in '..\Source\Schema\Traits\JsonFlow.TraitTitle.pas',
  JsonFlow.TraitElse in '..\Source\Schema\Traits\JsonFlow.TraitElse.pas',
  JsonFlow.TraitThen in '..\Source\Schema\Traits\JsonFlow.TraitThen.pas',
  JsonFlow.TraitIf in '..\Source\Schema\Traits\JsonFlow.TraitIf.pas',
  JsonFlow.TraitNot in '..\Source\Schema\Traits\JsonFlow.TraitNot.pas',
  JsonFlow.TraitOneOf in '..\Source\Schema\Traits\JsonFlow.TraitOneOf.pas',
  JsonFlow.TraitAnyof in '..\Source\Schema\Traits\JsonFlow.TraitAnyof.pas',
  JsonFlow.TraitAllof in '..\Source\Schema\Traits\JsonFlow.TraitAllof.pas',
  JsonFlow.TraitMaxContains in '..\Source\Schema\Traits\JsonFlow.TraitMaxContains.pas',
  JsonFlow.TraitMinContains in '..\Source\Schema\Traits\JsonFlow.TraitMinContains.pas',
  JsonFlow.TraitContains in '..\Source\Schema\Traits\JsonFlow.TraitContains.pas',
  JsonFlow.TraitUniqueItems in '..\Source\Schema\Traits\JsonFlow.TraitUniqueItems.pas',
  JsonFlow.TraitMaxItems in '..\Source\Schema\Traits\JsonFlow.TraitMaxItems.pas',
  JsonFlow.TraitMinItems in '..\Source\Schema\Traits\JsonFlow.TraitMinItems.pas',
  JsonFlow.TraitAdditionalItems in '..\Source\Schema\Traits\JsonFlow.TraitAdditionalItems.pas',
  JsonFlow.TraitItems in '..\Source\Schema\Traits\JsonFlow.TraitItems.pas',
  JsonFlow.TraitDependencies in '..\Source\Schema\Traits\JsonFlow.TraitDependencies.pas',
  JsonFlow.TraitDependentSchemas in '..\Source\Schema\Traits\JsonFlow.TraitDependentSchemas.pas',
  JsonFlow.TraitDependentRequired in '..\Source\Schema\Traits\JsonFlow.TraitDependentRequired.pas',
  JsonFlow.TraitMaxProperties in '..\Source\Schema\Traits\JsonFlow.TraitMaxProperties.pas',
  JsonFlow.TraitMinProperties in '..\Source\Schema\Traits\JsonFlow.TraitMinProperties.pas',
  JsonFlow.TraitPropertyNames in '..\Source\Schema\Traits\JsonFlow.TraitPropertyNames.pas',
  JsonFlow.TraitRequired in '..\Source\Schema\Traits\JsonFlow.TraitRequired.pas',
  JsonFlow.TraitPatternProperties in '..\Source\Schema\Traits\JsonFlow.TraitPatternProperties.pas',
  JsonFlow.TraitAdditionalProperties in '..\Source\Schema\Traits\JsonFlow.TraitAdditionalProperties.pas',
  JsonFlow.TraitProperties in '..\Source\Schema\Traits\JsonFlow.TraitProperties.pas',
  JsonFlow.TraitContentSchema in '..\Source\Schema\Traits\JsonFlow.TraitContentSchema.pas',
  JsonFlow.TraitContentMediaType in '..\Source\Schema\Traits\JsonFlow.TraitContentMediaType.pas',
  JsonFlow.TraitContentenCoding in '..\Source\Schema\Traits\JsonFlow.TraitContentenCoding.pas',
  JsonFlow.TraitFormat in '..\Source\Schema\Traits\JsonFlow.TraitFormat.pas',
  JsonFlow.TraitPattern in '..\Source\Schema\Traits\JsonFlow.TraitPattern.pas',
  JsonFlow.TraitMaxLength in '..\Source\Schema\Traits\JsonFlow.TraitMaxLength.pas',
  JsonFlow.TraitMinLength in '..\Source\Schema\Traits\JsonFlow.TraitMinLength.pas',
  JsonFlow.TraitDivisibleby in '..\Source\Schema\Traits\JsonFlow.TraitDivisibleby.pas',
  JsonFlow.TraitMultipleOf in '..\Source\Schema\Traits\JsonFlow.TraitMultipleOf.pas',
  JsonFlow.TraitExclusiveMaximum in '..\Source\Schema\Traits\JsonFlow.TraitExclusiveMaximum.pas',
  JsonFlow.TraitExclusiveMinimum in '..\Source\Schema\Traits\JsonFlow.TraitExclusiveMinimum.pas',
  JsonFlow.TraitMaximum in '..\Source\Schema\Traits\JsonFlow.TraitMaximum.pas',
  JsonFlow.TraitEnum in '..\Source\Schema\Traits\JsonFlow.TraitEnum.pas',
  JsonFlow.TraitConst in '..\Source\Schema\Traits\JsonFlow.TraitConst.pas',
  JsonFlow.TraitComment in '..\Source\Schema\Traits\JsonFlow.TraitComment.pas',
  JsonFlow.TraitVocabulary in '..\Source\Schema\Traits\JsonFlow.TraitVocabulary.pas',
  JsonFlow.TraitAnchor in '..\Source\Schema\Traits\JsonFlow.TraitAnchor.pas',
  JsonFlow.TraitDefs in '..\Source\Schema\Traits\JsonFlow.TraitDefs.pas',
  JsonFlow.TraitRef in '..\Source\Schema\Traits\JsonFlow.TraitRef.pas',
  JsonFlow.TraitId in '..\Source\Schema\Traits\JsonFlow.TraitId.pas',
  JsonFlow.TraitSchema in '..\Source\Schema\Traits\JsonFlow.TraitSchema.pas',
  JsonFlow.TraitMinimum in '..\Source\Schema\Traits\JsonFlow.TraitMinimum.pas',
  JsonFlow.TestsArrays in 'JsonFlow.TestsArrays.pas',
  JsonFlow.TestsComposer in 'JsonFlow.TestsComposer.pas',
  JsonFlow.Tests in 'JsonFlow.Tests.pas',
  JsonFlow.TestsNavigator in 'JsonFlow.TestsNavigator.pas',
  JsonFlow.TestsObjects in 'JsonFlow.TestsObjects.pas',
  JsonFlow.TestsPair in 'JsonFlow.TestsPair.pas',
  JsonFlow.TestsReader in 'JsonFlow.TestsReader.pas',
  JsonFlow.TestsSchemaNavigator in 'JsonFlow.TestsSchemaNavigator.pas',
  JsonFlow.TestsSchemaReader in 'JsonFlow.TestsSchemaReader.pas',
  JsonFlow.TestsSchemaValidator in 'JsonFlow.TestsSchemaValidator.pas',
  JsonFlow.TestsSerializer in 'JsonFlow.TestsSerializer.pas',
  JsonFlow.TestsTraitsAnchors in 'JsonFlow.TestsTraitsAnchors.pas',
  JsonFlow.TestsTraitsArrays in 'JsonFlow.TestsTraitsArrays.pas',
  JsonFlow.TestsTraitsCombinator in 'JsonFlow.TestsTraitsCombinator.pas',
  JsonFlow.TestsTraitsConditional in 'JsonFlow.TestsTraitsConditional.pas',
  JsonFlow.TestsTraitsConsts in 'JsonFlow.TestsTraitsConsts.pas',
  JsonFlow.TestsTraitsContent in 'JsonFlow.TestsTraitsContent.pas',
  JsonFlow.TestsTraitsDefinitions in 'JsonFlow.TestsTraitsDefinitions.pas',
  JsonFlow.TestsTraitsDependencies in 'JsonFlow.TestsTraitsDependencies.pas',
  JsonFlow.TestsTraitsEnum in 'JsonFlow.TestsTraitsEnum.pas',
  JsonFlow.TestsTraitsFormat in 'JsonFlow.TestsTraitsFormat.pas',
  JsonFlow.TestsTraitsMeta in 'JsonFlow.TestsTraitsMeta.pas',
  JsonFlow.TestsTraitsNumber in 'JsonFlow.TestsTraitsNumber.pas',
  JsonFlow.TestsTraitsObjects in 'JsonFlow.TestsTraitsObjects.pas',
  JsonFlow.TestsTraitsPatternProperties in 'JsonFlow.TestsTraitsPatternProperties.pas',
  JsonFlow.TestsTraitsPropertys in 'JsonFlow.TestsTraitsPropertys.pas',
  JsonFlow.TestsTraitsRequired in 'JsonFlow.TestsTraitsRequired.pas',
  JsonFlow.TestsTraitsStrings in 'JsonFlow.TestsTraitsStrings.pas',
  JsonFlow.TestsTraitsTypes in 'JsonFlow.TestsTraitsTypes.pas',
  JsonFlow.TestsTraitsUniqueItems in 'JsonFlow.TestsTraitsUniqueItems.pas',
  JsonFlow.TestsValue in 'JsonFlow.TestsValue.pas';

{ keep comment here to protect the following conditional from being removed by the IDE when adding a unit }
{$IFNDEF TESTINSIGHT}
var
  runner: ITestRunner;
  results: IRunResults;
  logger: ITestLogger;
  nunitLogger : ITestLogger;
{$ENDIF}
begin
  ReportMemoryLeaksOnShutdown := True;
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
{$ELSE}
  try
    //Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    //Create the test runner
    runner := TDUnitX.CreateRunner;
    //Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    //When true, Assertions must be made during tests;
    runner.FailsOnNoAsserts := False;

    //tell the runner how we will log things
    //Log to the console window if desired
    if TDUnitX.Options.ConsoleMode <> TDunitXConsoleMode.Off then
    begin
      logger := TDUnitXConsoleLogger.Create(TDUnitX.Options.ConsoleMode = TDunitXConsoleMode.Quiet);
      runner.AddLogger(logger);
    end;
    //Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);

    //Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
    //We don't want this happening when running under CI.
    TDUnitX.Options.ExitBehavior := TDUnitXExitBehavior.Pause ;
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
{$ENDIF}
end.
