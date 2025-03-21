unit core;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Types, LResources;

var
  AppPath: String;

  function ArrayToString(StringArray: TStringDynArray; const Delimiter: String): String;

const
  SOFTWARE_VERSION = '0.0.2';

implementation

function ArrayToString(StringArray: TStringDynArray; const Delimiter: String): String;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to Length(StringArray) - 1 do
    Result := Result + StringArray[I] + Delimiter;
  SetLength(Result, Length(Result) - Length(Delimiter));
end;

initialization
  {$I res\bip39_en.lrs}
  AppPath := ExtractFilePath(ParamStr(0));

end.

