unit JNI_HanLP;

{
  JNI_HanLP
  ===============================================================
  Call HanLP using JNI.pas.

  Written by caowm (remobjects@qq.com)
  16 September 2020

  Reference
  ===============================================================
  HanLP: Han Language Processing
  https://github.com/hankcs/HanLP/tree/1.x

  DelphiJNI: A Delphi/Kylix Java Native Interface implementation
  https://github.com/aleroot/DelphiJNI
}

interface

uses
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  System.Variants,
  JNI,
  JNIUtils,
  JNI_Tool;

type

  // 拼音，组成部分=声母+韵母+声调12345
  TPinyin = class
  public
    Shengmu: string;
    Yunmu: string;
    Tone: integer;
    Head: string;
    FirstChar: Variant;
    Pinyin: string;
    PinyinWithToneMark: string;
    PinyinWithoutTone: string;
  end;

  // 一个单词，用户可以直接访问此单词的全部属性
  TTerm = class
  public
    Word: string;
    Nature: string;
    Offset: integer;
    function ToString(): string; override;
  end;

  // 分词器（分词服务）
  TSegment = class
  private
    FJVM: TJNIEnv;
    FSegment: JObject;
  public
    constructor Create(JVM: TJNIEnv; ASegment: JObject);

    function SegmentClassName(): string;

    // 分词
    function Seg(const Text: string): TObjectList<TTerm>;

    // 分词断句 输出句子形式
    function Seg2sentence(const Text: string): TObjectList<TObjectList<TTerm>>;
  end;

  // 汉语言处理包，常用接口工具类
  THanLP = class
  private
    FJVM: TJNIEnv;
    FHanLPClass: JClass;
  public
    constructor Create(JVM: TJNIEnv);

    // 转化为拼音
    function ConvertToPinyinString(const Text, Separator: string;
      RemainNone: boolean): string;

    // 转化为拼音（首字母）
    function ConvertToPinyinFirstCharString(const Text, Separator: string;
      RemainNone: boolean): string;

    // 转化为拼音
    function ConvertToPinyinList(const Text: string): TObjectList<TPinyin>;

    // 繁转简
    function ConvertToSimplifiedChinese(const TraditionalChineseString
      : string): string;

    // 简转繁
    function ConvertToTraditionalChinese(const SimplifiedChineseString
      : string): string;

    // 提取关键词
    function ExtractKeyword(const Document: string; Size: integer)
      : TArray<string>;

    // 提取关键词
    function ExtractPhrase(const Text: string; Size: integer): TArray<string>;

    // 自动摘要 分割目标文档时的默认句子分割符为，,。:：“”？?！!；;
    function ExtractSummary(const Document: string; Size: integer)
      : TArray<string>;

    // 自动摘要 分割目标文档时的默认句子分割符为，,。:：“”？?！!；;
    function GetSummary(const Document: string; MaxLength: integer): string;

    // 分词
    function Segment(const Text: string): TObjectList<TTerm>;

    // 创建一个分词器 这是一个工厂方法
    function NewSegment(): TSegment; overload;

    {
      创建一个分词器

      algorithm - 分词算法，传入算法的中英文名都可以，可选列表：
      维特比 (viterbi)：效率和效果的最佳平衡
      双数组trie树 (dat)：极速词典分词，千万字符每秒
      条件随机场 (crf)：分词、词性标注与命名实体识别精度都较高，适合要求较高的NLP任务
      感知机 (perceptron)：分词、词性标注与命名实体识别，支持在线学习
      N最短路 (nshort)：命名实体识别稍微好一些，牺牲了速度
    }
    function NewSegment(const Algorithm: string): TSegment; overload;

  end;

  // Pinyin to TPinyin
function ConvertPinyin(JVM: TJNIEnv; Obj: JObject): TPinyin;

// Term to TTerm
function ConvertTerm(JVM: TJNIEnv; Obj: JObject): TTerm;

implementation

function ConvertPinyin(JVM: TJNIEnv; Obj: JObject): TPinyin;
begin
  Result := TPinyin.Create;

  Result.Pinyin := CallMethod(JVM, Obj, 'toString', 'String()', []);
  Result.PinyinWithToneMark := CallMethod(JVM, Obj, 'getPinyinWithToneMark',
    'String()', []);
  Result.PinyinWithoutTone := CallMethod(JVM, Obj, 'getPinyinWithoutTone',
    'String()', []);
  Result.Head := CallMethod(JVM, Obj, 'getHeadString', 'String()', []);
  Result.Shengmu := Result.Head;
  Result.FirstChar := CallMethod(JVM, Obj, 'getFirstChar', 'char()', []);
  Result.Tone := CallMethod(JVM, Obj, 'getTone', 'int()', []);
  // Yunmu在Java是个enum，这里转换成string
  Result.Yunmu := JObjectToString(JVM, CallObjectMethod(JVM, Obj, 'getYunmu',
    'com.hankcs.hanlp.dictionary.py.Yunmu()', []));
end;

function ConvertTerm(JVM: TJNIEnv; Obj: JObject): TTerm;
begin
  Result := TTerm.Create;
  Result.Word := GetFieldValue(JVM, Obj, 'word', 'String');
  Result.Offset := GetFieldValue(JVM, Obj, 'offset', 'int');
  Result.Nature := JObjectToString(JVM, GetObjectFieldValue(JVM, Obj, 'nature',
    'com.hankcs.hanlp.corpus.tag.Nature'));
end;

{ TTerm }

function TTerm.ToString: string;
begin
  Result := Word + '/' + Nature;
end;

{ TSegment }

constructor TSegment.Create(JVM: TJNIEnv; ASegment: JObject);
begin
  FJVM := JVM;
  FSegment := ASegment;
end;

function TSegment.SegmentClassName: string;
begin
  Result := GetClassName(FJVM, FSegment);
end;

function TSegment.Seg(const Text: string): TObjectList<TTerm>;
var
  List: JObject;
begin
  List := CallObjectMethod(FJVM, FSegment, 'seg',
    'java.util.List(String)', [Text]);
  Result := TObjectList<TTerm>(ConvertObjectList(FJVM, List, @ConvertTerm));
end;

function TSegment.Seg2sentence(const Text: string)
  : TObjectList<TObjectList<TTerm>>;
begin
  // todo:
end;

{ THanLP }

function THanLP.ConvertToPinyinFirstCharString(const Text, Separator: string;
  RemainNone: boolean): string;
begin
  Result := CallMethod(FJVM, FHanLPClass, 'convertToPinyinFirstCharString',
    'String(String,String,boolean)', [Text, Separator, RemainNone], True);
end;

function THanLP.ConvertToPinyinList(const Text: string): TObjectList<TPinyin>;
var
  List: JObject;
begin
  List := CallObjectMethod(FJVM, FHanLPClass, 'convertToPinyinList',
    'java.util.List(String)', [Text], True);
  Result := TObjectList<TPinyin>(ConvertObjectList(FJVM, List, @ConvertPinyin));
end;

function THanLP.ConvertToPinyinString(const Text, Separator: string;
  RemainNone: boolean): string;
begin
  Result := CallMethod(FJVM, FHanLPClass, 'convertToPinyinString',
    'String(String,String,boolean)', [Text, Separator, RemainNone], True);
end;

function THanLP.ConvertToSimplifiedChinese(const TraditionalChineseString
  : string): string;
begin
  Result := CallMethod(FJVM, FHanLPClass, 'convertToSimplifiedChinese',
    'String(String)', [TraditionalChineseString], True);
end;

function THanLP.ConvertToTraditionalChinese(const SimplifiedChineseString
  : string): string;
begin
  Result := CallMethod(FJVM, FHanLPClass, 'convertToTraditionalChinese',
    'String(String)', [SimplifiedChineseString], True);
end;

constructor THanLP.Create(JVM: TJNIEnv);
begin
  FJVM := JVM;
  FHanLPClass := FJVM.FindClass('com/hankcs/hanlp/HanLP');
end;

function THanLP.ExtractKeyword(const Document: string; Size: integer)
  : TArray<string>;
var
  List: JObject;
begin
  List := CallObjectMethod(FJVM, FHanLPClass, 'extractKeyword',
    'java.util.List(String,int)', [Document, Size], True);
  Result := ConvertStringList(FJVM, List);
end;

function THanLP.ExtractPhrase(const Text: string; Size: integer)
  : TArray<string>;
var
  List: JObject;
begin
  List := CallObjectMethod(FJVM, FHanLPClass, 'extractPhrase',
    'java.util.List(String,int)', [Text, Size], True);
  Result := ConvertStringList(FJVM, List);
end;

function THanLP.ExtractSummary(const Document: string; Size: integer)
  : TArray<string>;
var
  List: JObject;
begin
  List := CallObjectMethod(FJVM, FHanLPClass, 'extractSummary',
    'java.util.List(String,int)', [Document, Size], True);
  Result := ConvertStringList(FJVM, List);
end;

function THanLP.GetSummary(const Document: string; MaxLength: integer): string;
begin
  Result := CallMethod(FJVM, FHanLPClass, 'getSummary', 'String(String,int)',
    [Document, MaxLength], True);
end;

function THanLP.NewSegment(const Algorithm: string): TSegment;
begin
  Result := TSegment.Create(FJVM, CallObjectMethod(FJVM, FHanLPClass,
    'newSegment', 'com.hankcs.hanlp.seg.Segment(String)', [Algorithm], True));
end;

function THanLP.NewSegment: TSegment;
begin
  Result := TSegment.Create(FJVM, CallObjectMethod(FJVM, FHanLPClass,
    'newSegment', 'com.hankcs.hanlp.seg.Segment()', [], True));
end;

function THanLP.Segment(const Text: string): TObjectList<TTerm>;
var
  List: JObject;
begin
  List := CallObjectMethod(FJVM, FHanLPClass, 'segment',
    'java.util.List(String)', [Text], True);
  Result := TObjectList<TTerm>(ConvertObjectList(FJVM, List, @ConvertTerm));
end;

end.
