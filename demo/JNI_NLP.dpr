program JNI_NLP;

uses
  FastMM4,
  Vcl.Forms,
  NLPTestUnit in 'NLPTestUnit.pas' {JniNlpTestForm} ,
  JNI_Tool in '..\source\JNI_Tool.pas',
  JNI_HanLP in '..\source\JNI_HanLP.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TJniNlpTestForm, JniNlpTestForm);
  Application.Run;

end.
