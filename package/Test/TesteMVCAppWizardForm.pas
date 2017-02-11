unit TesteMVCAppWizardForm;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit
  being tested.

}

interface

uses
  TestFramework, Windows, Buttons, eMVC.toolbox, Forms, Dialogs, Controls,
  Classes, ExtCtrls,
  SysUtils, ComCtrls, Graphics, Messages, eMVC.AppWizardForm, StdCtrls;

type
  // Test methods for class TFormAppWizard

  TestTFormAppWizard = class(TTestCase)
  strict private
    FFormAppWizard: TFormAppWizard;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestShowAppWizard;
    procedure TestShowConfig;
  end;

implementation

procedure TestTFormAppWizard.SetUp;
begin
  FFormAppWizard := TFormAppWizard.Create(nil);
end;

procedure TestTFormAppWizard.TearDown;
begin
  FFormAppWizard.Free;
  FFormAppWizard := nil;
end;

procedure TestTFormAppWizard.TestShowAppWizard;
begin
  FFormAppWizard.showmodal;
end;

procedure TestTFormAppWizard.TestShowConfig;
begin
  FFormAppWizard.config.Click;
end;

initialization

// Register any test cases with the test runner
RegisterTest(TestTFormAppWizard.Suite);

end.
