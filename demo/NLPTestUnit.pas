unit NLPTestUnit;

interface

{
  Delphi XE JNI HanLP Test

  Written by caowm (remobjects@qq.com)
  16 September 2020
}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Generics.Collections,
  Vcl.Graphics, JNI, JNIUtils, JNI_TOOL, JNI_HanLP,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TJniNlpTestForm = class(TForm)
    InputMemo: TMemo;
    LogMemo: TMemo;
    Button3: TButton;
    Button4: TButton;
    Button1: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
  private
    FJVM: TJNIEnv;
    FHanLP: THanLP;
    FSystemClass: JClass;
    FNLPSegment: TSegment;
    FSpeedSegment: TSegment;
    procedure Log(Text: Variant);
    procedure PrintSystemProperty(const PropName: string);
    procedure PrintTermList(TermList: TObjectList<TTerm>);
  public
    { Public declarations }
  end;

var
  JniNlpTestForm: TJniNlpTestForm;

implementation

{$R *.dfm}

procedure TJniNlpTestForm.Log(Text: Variant);
begin
  LogMemo.Lines.Add(Text);
end;

procedure TJniNlpTestForm.PrintSystemProperty(const PropName: string);
var
  Result: Variant;
begin
  if (PropName <> '') and (PropName[1] >= 'a') and (PropName[1] <= 'z') then
  begin
    Result := CallMethod(FJVM, FSystemClass, 'getProperty', 'String(String)',
      [PropName], True);
    Log(Format('%s=%s', [PropName, Result]));
  end;
end;

procedure TJniNlpTestForm.PrintTermList(TermList: TObjectList<TTerm>);
var
  Term: TTerm;
  S: string;
begin
  for Term in TermList do
  begin
    S := S + ' ' + Term.ToString();
  end;
  Log(S);
end;

procedure TJniNlpTestForm.Button2Click(Sender: TObject);
var
  S: string;
begin
  for S in InputMemo.Lines do
    PrintSystemProperty(Trim(S));
end;

procedure TJniNlpTestForm.Button3Click(Sender: TObject);
begin
  Log('============全拼============');
  Log(FHanLP.ConvertToPinyinString(InputMemo.Text, ' ', False));
end;

procedure TJniNlpTestForm.Button4Click(Sender: TObject);
begin
  Log('============拼音首字母============');
  Log(FHanLP.ConvertToPinyinFirstCharString(InputMemo.Text, '', True));
end;

procedure TJniNlpTestForm.Button5Click(Sender: TObject);
begin
  Log('============简转繁============');
  Log(FHanLP.ConvertToTraditionalChinese(InputMemo.Text));
end;

procedure TJniNlpTestForm.Button6Click(Sender: TObject);
var
  PinyinList: TObjectList<TPinyin>;
  PinyinItem: TPinyin;
  Pinyin: string;
  PinyinWithTone: string;
  PinyinWithoutTone: string;
  Head: string;
  FirstChar: string;
  Tone: string;
  Yunmu: string;
begin
  Log('============拼音列表============');
  Pinyin := '拼音:';
  PinyinWithTone := '带音调拼音:';
  PinyinWithoutTone := '无音调拼音:';
  Head := '声母:';
  FirstChar := '首字母:';
  Tone := '声调:';
  Yunmu := '韵母:';
  PinyinList := FHanLP.ConvertToPinyinList(InputMemo.Text);
  for PinyinItem in PinyinList do
  begin
    if PinyinItem.Pinyin <> 'none5' then
    begin
      Pinyin := Pinyin + ' ' + PinyinItem.Pinyin;
      PinyinWithTone := PinyinWithTone + ' ' + PinyinItem.PinyinWithToneMark;
      PinyinWithoutTone := PinyinWithoutTone + ' ' +
        PinyinItem.PinyinWithoutTone;
      Head := Head + ' ' + PinyinItem.Head;
      FirstChar := FirstChar + ' ' + PinyinItem.FirstChar;
      Tone := Tone + ' ' + IntToStr(PinyinItem.Tone);
      Yunmu := Yunmu + ' ' + PinyinItem.Yunmu;
    end;
  end;
  Log(Pinyin);
  Log(PinyinWithTone);
  Log(PinyinWithoutTone);
  Log(Head);
  Log(FirstChar);
  Log(Tone);
  Log(Yunmu);
  PinyinList.Free;
end;

procedure TJniNlpTestForm.Button7Click(Sender: TObject);
var
  Keywords: TArray<string>;
  S: string;
begin
  Log('============关键词============');
  Keywords := FHanLP.ExtractKeyword(InputMemo.Text, 10);
  for S in Keywords do
  begin
    Log(S);
  end;
end;

procedure TJniNlpTestForm.Button8Click(Sender: TObject);
var
  Phrase: TArray<string>;
  S: string;
begin
  Log('============短语============');
  Phrase := FHanLP.ExtractPhrase(InputMemo.Text, 10);
  for S in Phrase do
  begin
    Log(S);
  end;
end;

procedure TJniNlpTestForm.Button9Click(Sender: TObject);
var
  Phrase: TArray<string>;
  S: string;
begin
  Log('============摘要列表============');
  Phrase := FHanLP.ExtractSummary(InputMemo.Text, 5);
  for S in Phrase do
  begin
    Log(S);
  end;
end;

procedure TJniNlpTestForm.Button10Click(Sender: TObject);
begin
  Log('============50字摘要============');
  Log(FHanLP.GetSummary(InputMemo.Text, 50));
end;

procedure TJniNlpTestForm.Button11Click(Sender: TObject);
var
  TermList: TObjectList<TTerm>;
begin
  Log('============分词结果============');
  TermList := FHanLP.Segment(InputMemo.Text);
  PrintTermList(TermList);
  TermList.Free;
end;

procedure TJniNlpTestForm.Button12Click(Sender: TObject);
begin
  LogMemo.Clear;
end;

procedure TJniNlpTestForm.Button13Click(Sender: TObject);
var
  TermList: TObjectList<TTerm>;
begin
  if (FNLPSegment = nil) then
  begin
    FNLPSegment := FHanLP.NewSegment('perceptron');
    Log('NLP分词类名：' + FNLPSegment.SegmentClassName());
  end;
  Log('============NLP分词结果============');
  TermList := FNLPSegment.Seg(InputMemo.Text);
  PrintTermList(TermList);
  TermList.Free;
end;

procedure TJniNlpTestForm.Button14Click(Sender: TObject);
var
  TermList: TObjectList<TTerm>;
begin
  if (FSpeedSegment = nil) then
  begin
    FSpeedSegment := FHanLP.NewSegment('dat');
    Log('极速分词类名：' + FSpeedSegment.SegmentClassName());
  end;
  Log('============极速分词结果============');
  TermList := FSpeedSegment.Seg(InputMemo.Text);
  PrintTermList(TermList);
  TermList.Free;
end;

procedure TJniNlpTestForm.Button1Click(Sender: TObject);
begin
  Log('============繁转简============');
  Log(FHanLP.ConvertToSimplifiedChinese(InputMemo.Text));
end;

procedure TJniNlpTestForm.FormCreate(Sender: TObject);
begin
  FJVM := Create_JVM(JNI_VERSION_1_8,
    ['-Djava.class.path=./;./hanlp-1.7.8.jar']);
  FHanLP := THanLP.Create(FJVM);
  FSystemClass := FJVM.FindClass('java/lang/System');

  Log('============JVM创建成功============');
  PrintSystemProperty('java.version');
  PrintSystemProperty('java.class.path');
  PrintSystemProperty('user.dir');
  PrintSystemProperty('user.home');
//  PrintSystemProperty('user.name');
//  PrintSystemProperty('os.name');
  //PrintSystemProperty('java.library.path');
end;

procedure TJniNlpTestForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FNLPSegment);
  FreeAndNil(FSpeedSegment);
  FreeAndNil(FHanLP);
  FreeAndNil(FJVM);
end;

end.
