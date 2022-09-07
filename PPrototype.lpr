program PPrototype;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, UPrototype, tachartlazaruspkg, ufloatstack, UMYQueue, UStringStack
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TGraphPlotter, GraphPlotter);
  Application.Run;
end.

