unit SeedWordRecoverer;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, HlpIHash, HlpHashFactory, StrUtils, Types, Core, LResources;

type
  EInvalidSeedPhrase = class(Exception);

  TLastWordRecoverer = class(TObject)
  const
    BIN_INDEX_LENGTH = 11;
    ENTROPY_BITS_MOD = 32;
  private
    Hasher: IHash;
    Bip39Wordlist: TStringList;
    InputSeedWords: TStringList;
    FLastSeedWords: TStringDynArray;
    function FirstTwoBytesToBin(const Bytes: TBytes): String;
    function BinToBytes(const Binary: String): TBytes;
    function GetBinIndex(const SeedWord: String): String;
    function GetSeedPhrase: String;
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Recover(const SeedPhrase: String);
    property SeedPhrase: String read GetSeedPhrase;
    property LastSeedWords: TStringDynArray read FLastSeedWords;
  end;

implementation

constructor TLastWordRecoverer.Create;
var
  ResourceStream: TLazarusResourceStream;
begin
  inherited Create;

  Bip39Wordlist := TStringList.Create;
  ResourceStream := TLazarusResourceStream.Create('bip39_en', nil);
  Bip39Wordlist.LoadFromStream(ResourceStream);
  ResourceStream.Free;

  InputSeedWords := TStringList.Create;
  InputSeedWords.Delimiter := ' ';
  InputSeedWords.StrictDelimiter := true;

  Hasher := THashFactory.TCrypto.CreateSHA2_256;
end;

destructor TLastWordRecoverer.Destroy;
begin
  Bip39Wordlist.Free;
  InputSeedWords.Free;

  inherited Destroy;
end;

procedure TLastWordRecoverer.Clear;
begin
  SetLength(FLastSeedWords, 0);
end;

function TLastWordRecoverer.GetSeedPhrase: String;
begin
  Result := InputSeedWords.DelimitedText;
end;

procedure TLastWordRecoverer.Recover(const SeedPhrase: String);
var
  FullEntropyBits, PartialEntropyBits, ChecksumBits, HashFirstBits, LastWordBits: String;
  I, ChecksumBitLength, TotalBitLength: Integer;
  FullEntropyBytes: TBytes;
begin
  // We reset some variables
  Clear;

  // We verify that the user has input a valid number of seed words
  InputSeedWords.DelimitedText := Lowercase(Trim(SeedPhrase));
  if (InputSeedWords.Count <> 11) and (InputSeedWords.Count <> 14) and (InputSeedWords.Count <> 17) and (InputSeedWords.Count <> 20) and (InputSeedWords.Count <> 23) then
    raise EInvalidSeedPhrase.Create('Invalid number of seed words. Make sure you enter 11, 14, 17, 20 or 23 words.');

  // We calculate the number of bits our checksum will have
  TotalBitLength := (InputSeedWords.Count + 1) * BIN_INDEX_LENGTH;
  ChecksumBitLength := TotalBitLength mod ENTROPY_BITS_MOD;

  // We create a binary string based on the input seed words
  PartialEntropyBits := '';
  for I := 0 to InputSeedWords.Count - 1 do
    PartialEntropyBits := PartialEntropyBits + GetBinIndex(InputSeedWords.Strings[I]);

  // For the final seed word, we are going to try each word in the BIP39 wordlist
  for I := 0 to Bip39Wordlist.Count - 1 do
  begin
    // We get the bin index for the current word in the BIP39 wordlist
    LastWordBits := BinStr(I, BIN_INDEX_LENGTH);

    // We compute the full entropy and the checksum bits
    FullEntropyBits := PartialEntropyBits + Copy(LastWordBits, 1, BIN_INDEX_LENGTH - ChecksumBitLength);
    ChecksumBits := Copy(LastWordBits, Length(LastWordBits) - ChecksumBitLength + 1, ChecksumBitLength);

    // We calculate a SHA256 hash of the full entropy bits and verify if its first bits match our checksum bits
    FullEntropyBytes := BinToBytes(FullEntropyBits);
    HashFirstBits := FirstTwoBytesToBin(Hasher.ComputeBytes(FullEntropyBytes).GetBytes);
    if (LeftStr(HashFirstBits, ChecksumBitLength) = ChecksumBits) then
    begin
      SetLength(FLastSeedWords, Length(FLastSeedWords) + 1);
      FLastSeedWords[Length(FLastSeedWords) - 1] := Bip39Wordlist.Strings[I]
    end;
  end;
end;

function TLastWordRecoverer.GetBinIndex(const SeedWord: String): String;
var
  WordIndex: Integer;
begin
  WordIndex := Bip39Wordlist.IndexOf(SeedWord);
  if (WordIndex = -1) then
    raise EInvalidSeedPhrase.Create('Cannot find seed word ' + SeedWord + '. Double-check for typos. Make sure you entered a word that is in the BIP39 wordlist.');
  Result := BinStr(WordIndex, BIN_INDEX_LENGTH);
end;

function TLastWordRecoverer.BinToBytes(const Binary: String): TBytes;
var
  CurrentEntropyByte, I: Integer;
  TempBits: String;
begin
  Result := nil;
  SetLength(Result, Length(Binary) div 8);
  CurrentEntropyByte := 0;
  TempBits := '';

  for I := 1 to Length(Binary) do
  begin
   TempBits := TempBits + Binary[I];
   if (Length(TempBits) = 8) then
   begin
     Result[CurrentEntropyByte] := StrToInt('%' + TempBits);
     Inc(CurrentEntropyByte);
     TempBits := '';
   end;
  end;
end;

function TLastWordRecoverer.FirstTwoBytesToBin(const Bytes: TBytes): String;
var
  I, J: Integer;
begin
  Result := '';
  for I := 0 to 1 do
  begin
    for J := 7 downto 0 do
      Result := Result + Chr(Ord('0') + ((Bytes[I] shr J) and 1));
  end;
end;

end.

