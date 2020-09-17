object JniNlpTestForm: TJniNlpTestForm
  Left = 0
  Top = 0
  Caption = 'Delphi JNI-NLP Test'
  ClientHeight = 314
  ClientWidth = 742
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    742
    314)
  PixelsPerInch = 96
  TextHeight = 13
  object InputMemo: TMemo
    Left = 8
    Top = 8
    Width = 569
    Height = 87
    Anchors = [akLeft, akTop, akRight]
    Lines.Strings = (
      #25105#26032#36896#19968#20010#35789#21483#24187#24819#20065#20320#33021#35782#21035#24182#26631#27880#27491#30830#35789#24615#21527#65311
      #25105#30340#24076#26395#26159#24076#26395#24352#26202#38686#30340#32972#24433#34987#26202#38686#26144#32418
      #25903#25588#33274#28771#27491#39636#39321#28207#32321#39636#65306#24494#36719#20844#21496#26044'1975'#24180#30001#27604#29246#183#33995#33586#21644#20445#32645#183#33406#20523#21109#31435#12290)
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object LogMemo: TMemo
    Left = 8
    Top = 101
    Width = 569
    Height = 205
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Button3: TButton
    Left = 660
    Top = 8
    Width = 72
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #20840#25340
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 660
    Top = 70
    Width = 72
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #25340#38899#39318#23383#27597
    TabOrder = 3
    OnClick = Button4Click
  end
  object Button1: TButton
    Left = 583
    Top = 39
    Width = 71
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #32321#36716#31616
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button5: TButton
    Left = 583
    Top = 8
    Width = 72
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #31616#36716#32321
    TabOrder = 5
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 660
    Top = 39
    Width = 72
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #25340#38899#21015#34920
    TabOrder = 6
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 660
    Top = 99
    Width = 72
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #25552#21462#20851#38190#35789
    TabOrder = 7
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 660
    Top = 130
    Width = 72
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #25552#21462#30701#35821
    TabOrder = 8
    OnClick = Button8Click
  end
  object Button9: TButton
    Left = 583
    Top = 161
    Width = 71
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #25688#35201#21015#34920
    TabOrder = 9
    OnClick = Button9Click
  end
  object Button10: TButton
    Left = 660
    Top = 161
    Width = 72
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '50'#23383#25688#35201
    TabOrder = 10
    OnClick = Button10Click
  end
  object Button11: TButton
    Left = 583
    Top = 70
    Width = 71
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #26631#20934#20998#35789
    TabOrder = 11
    OnClick = Button11Click
  end
  object Button12: TButton
    Left = 583
    Top = 192
    Width = 148
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Clear'
    TabOrder = 12
    OnClick = Button12Click
  end
  object Button13: TButton
    Left = 583
    Top = 99
    Width = 71
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'NLP'#20998#35789
    TabOrder = 13
    OnClick = Button13Click
  end
  object Button14: TButton
    Left = 583
    Top = 130
    Width = 71
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #26497#36895#20998#35789
    TabOrder = 14
    OnClick = Button14Click
  end
end
