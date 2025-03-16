{
  For more information on how BIP39 works, consult the following page:
  https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki
}

unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  Core, SeedWordRecoverer, LCLType;

type

  { TForm1 }

  TForm1 = class(TForm)
    Go: TButton;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    InputSeedWords: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    LastWords: TMemo;
    FullSeedPhrases: TMemo;
    procedure GoClick(Sender: TObject);
  private
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.GoClick(Sender: TObject);
var
  LastWordRecoverer: TLastWordRecoverer;
  I: Integer;
begin
  // We update the GUI
  Go.Enabled := false;
  LastWords.Clear;
  FullSeedPhrases.Clear;
  LastWords.Lines.BeginUpdate;
  FullSeedPhrases.Lines.BeginUpdate;
  Application.ProcessMessages;

  // We check for possible last words
  LastWordRecoverer := TLastWordRecoverer.Create;
  try
    LastWordRecoverer.Recover(InputSeedWords.Text);
    for I := 0 to Length(LastWordRecoverer.LastSeedWords) - 1 do
    begin
      LastWords.Lines.Add(LastWordRecoverer.LastSeedWords[I]);
      FullSeedPhrases.Lines.Add(LastWordRecoverer.SeedPhrase + ' ' + LastWordRecoverer.LastSeedWords[I]);
    end;
    Application.MessageBox('The check is complete.', 'Done', MB_ICONINFORMATION);
  except
    on E:Exception do
      Application.MessageBox(PChar(E.Message), 'Error', MB_ICONERROR);
  end;
  LastWordRecoverer.Free;

  // We update the GUI
  LastWords.Lines.EndUpdate;
  FullSeedPhrases.Lines.EndUpdate;
  Go.Enabled := true;
end;

end.

