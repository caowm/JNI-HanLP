# JNI-HanLP
Delphi通过JNI封装的HanLP库


## 介绍

### [HanLP: Han Language Processing](https://github.com/hankcs/HanLP/tree/1.x)
HanLP是一系列模型与算法组成的NLP工具包，目标是普及自然语言处理在生产环境中的应用。HanLP具备功能完善、性能高效、架构清晰、语料时新、可自定义的特点。

### [DelphiJNI](https://github.com/aleroot/DelphiJNI)
此转换库允许从Delphi调用Java程序。由于Java程序与平台无关，因此它也适用于Linux。

### JNI-HanLP
在前面两个库的基础上进行二次封装，方便Delphi开发者使用汉语言处理功能。


## 开发准备

1. 下载jar包：[hanlp-1.7.8.jar](http://nlp.hankcs.com/download.php?file=jar)，和程序放在一起。
2. 下载HanLP要用的数据文件并解压：[data.zip](http://nlp.hankcs.com/download.php?file=data)。把hanlp.properties和程序放在一起，并配置好里面的root。
3. 下载 [Delphi-JNI](https://github.com/aleroot/DelphiJNI)，把源码路径添加到Delphi Options->Library。
4. 下载本项目，把源码路径添加到Delphi Options->Library。

## 注意事项
1. 配置好JRE目录，jvm.dll要在搜索路径中，否则程序无法启动。
2. 程序目标平台要与jvm相同(32位jvm配32位程序，64位jvm配64位程序)。
3. 加载jvm时，option要写出jar包名称，比如：-Djava.class.path=./hanlp-1.7.8.jar.
4. 调试模式下加载jvm会报access violation，调用时偶尔也报，just ignore it.

## 示例

### 初始化
```pascal
var
  JVM: TJNIEnv;
  HanLP: THanLP;
begin
  // 指定参数加载jvm
  JVM := Create_JVM(JNI_VERSION_1_8, ['-Djava.class.path=./hanlp-1.7.8.jar']);
  // 创建HanLP
  HanLP := THanLP.Create(JVM);
end;
```

### 调用HanLP功能
```pascal
var
  TermList: TObjectList<TTerm>;
  Term: TTerm;
  S: string;
begin
  // 全拼: chong zai bu shi zhong ren
  Log(HanLP.ConvertToPinyinString('重载不是重任', ' ', False));
  
  // 标准分词
  TermList := HanLP.Segment('我的希望是希望张晚霞的背影被晚霞映红');
  for Term in TermList do
  begin
    S := S + ' ' + Term.ToString();
  end;
  Log(S);
  TermList.Free;
end;
```

更多代码请参考demo。

作者：caowm (remobjects.qq.com)
