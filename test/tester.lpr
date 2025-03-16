program tester;

{$mode objfpc}{$H+}

uses
  Classes, consoletestrunner, TestLastWordRecoverer;

type

  { TApplicationTestRunner }

  TApplicationTestRunner = class(TTestRunner)
  protected
  // override the protected methods of TTestRunner to customize its behavior
  end;

var
  Application: TApplicationTestRunner;

begin
  Application := TApplicationTestRunner.Create(nil);
  Application.Initialize;
  Application.Title := 'Bitcoin Seed Phrase Recoverer - Test Runner';
  Application.Run;
  Application.Free;
end.
