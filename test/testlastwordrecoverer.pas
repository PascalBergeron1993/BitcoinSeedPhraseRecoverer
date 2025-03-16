unit TestLastWordRecoverer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, SeedWordRecoverer, Core;

type
  TTestLastWordRecoverer = class(TTestCase)
  private
    LastWordRecoverer: TLastWordRecoverer;
    procedure TryInvalidSeedWordsCount;
    procedure TryInvalidBIP39SeedWord;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure Test12Words;
    procedure Test15Words;
    procedure Test18Words;
    procedure Test21Words;
    procedure Test24Words;
    procedure TestNormalizedSeedPhrase;
    procedure TestInvalidSeedWordsCount;
    procedure TestInvalidBIP39SeedWord;
  end;

implementation

procedure TTestLastWordRecoverer.SetUp;
begin
  LastWordRecoverer := TLastWordRecoverer.Create;
end;

procedure TTestLastWordRecoverer.TearDown;
begin
  LastWordRecoverer.Free;
end;

procedure TTestLastWordRecoverer.TryInvalidSeedWordsCount;
begin
  LastWordRecoverer.Recover('caught control anxiety tomato chimney legend steel unable virtual ski network lucky');
end;

procedure TTestLastWordRecoverer.TryInvalidBIP39SeedWord;
begin
  LastWordRecoverer.Recover('xxxx modify various cake grocery lake ticket release velvet matter crash jungle');
end;

procedure TTestLastWordRecoverer.Test12Words;
begin
  LastWordRecoverer.Recover('okay absorb check slogan truly pretty climb defense pudding vehicle refuse');
  AssertEquals(ArrayToString(LastWordRecoverer.LastSeedWords, ','), 'absurd,address,aerobic,allow,anger,armor,assume,august,ball,barrel,belt,blast,blouse,bridge,budget,burst,cancel,case,caution,check,choice,close,coin,convince,crack,crash,crush,dance,decrease,deny,differ,disorder,donkey,dumb,east,elevator,enable,enrich,evil,exist,express,fashion,field,film,fix,force,fresh,garment,gentle,give,gospel,guitar,hair,hidden,hospital,hurt,immune,initial,inside,involve,juice,kid,later,lawn,leopard,lonely,love,man,marriage,menu,mimic,modify,museum,need,night,north,okay,option,orphan,palm,patch,pen,picnic,poem,pottery,profit,project,purpose,radar,real,regular,rescue,return,rocket,rotate,sail,scene,sense,sheriff,shoulder,silent,skull,smoke,soft,special,sport,stairs,struggle,success,swim,table,taste,thunder,together,tomorrow,trade,truck,tunnel,uncover,urban,vapor,video,void,walnut,wedding,will,wish,youth');
end;

procedure TTestLastWordRecoverer.Test15Words;
begin
  LastWordRecoverer.Recover('bracket father eight essence top certain gadget little library stadium water plug fog uncle');
  AssertEquals(ArrayToString(LastWordRecoverer.LastSeedWords, ','), 'addict,all,argue,asset,badge,best,brave,broom,capable,cave,chunk,coil,core,cup,decline,dilemma,dove,elbow,engine,excess,exotic,figure,flat,frog,gloom,grape,harsh,horn,income,invest,knee,leisure,lizard,mad,mercy,mixture,motor,noble,offer,ostrich,penalty,picture,poverty,puppy,rapid,reopen,risk,rug,scatter,sheriff,similar,snow,square,stone,swim,tenant,thought,top,twenty,use,utility,visual,wealth,zone');
end;

procedure TTestLastWordRecoverer.Test18Words;
begin
  LastWordRecoverer.Recover('immense reward staff slush raw leave absorb fork address april enact music pen myself try veteran analyst');
  AssertEquals(ArrayToString(LastWordRecoverer.LastSeedWords, ','), 'aim,arctic,banana,bronze,can,comic,cruel,define,dog,erase,farm,forget,goat,hire,inject,know,lottery,market,night,output,planet,program,ranch,rubber,shrimp,sing,stool,system,toilet,twin,wash,young');
end;

procedure TTestLastWordRecoverer.Test21Words;
begin
  LastWordRecoverer.Recover('limb bubble palm weird already emerge denial pact pipe design people between valley cash just husband dove estate tilt risk');
  AssertEquals(ArrayToString(LastWordRecoverer.LastSeedWords, ','), 'aim,bus,catch,danger,engine,fever,history,jazz,mimic,neglect,parent,satisfy,sound,such,trim,you');
end;

procedure TTestLastWordRecoverer.Test24Words;
begin
  LastWordRecoverer.Recover('cave rough display already section together reject marble raccoon decorate between climb senior genre change survey what palm carpet nest pudding conduct bag');
  AssertEquals(ArrayToString(LastWordRecoverer.LastSeedWords, ','), 'beauty,claim,either,hello,marine,park,suggest,want');
end;

procedure TTestLastWordRecoverer.TestNormalizedSeedPhrase;
begin
  LastWordRecoverer.Recover(' spend OKAY enough knife vast quarter chapter antenna wire math riot ');
  AssertEquals(LastWordRecoverer.SeedPhrase, 'spend okay enough knife vast quarter chapter antenna wire math riot');
end;

procedure TTestLastWordRecoverer.TestInvalidSeedWordsCount;
begin
  AssertException(EInvalidSeedPhrase, @TryInvalidSeedWordsCount);
end;

procedure TTestLastWordRecoverer.TestInvalidBIP39SeedWord;
begin
  AssertException(EInvalidSeedPhrase, @TryInvalidBIP39SeedWord)
end;

initialization
  RegisterTest(TTestLastWordRecoverer);

end.

