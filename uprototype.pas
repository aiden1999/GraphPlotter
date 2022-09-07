unit UPrototype;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, StdCtrls, TACustomSeries, UStringStack,
  UMyQueue, Character, Math, UFloatStack;

type

  { TGraphPlotter }

  TGraphPlotter = class(TForm)
    TESTING_sycontentsLabel: TLabel;
    TESTING_yLabel: TLabel;
    TESTING_xLabel: TLabel;
    LimitWarningLabel: TLabel;
    RemoveButton1: TButton;
    RemoveButton10: TButton;
    RemoveButton11: TButton;
    RemoveButton12: TButton;
    RemoveButton13: TButton;
    RemoveButton14: TButton;
    RemoveButton15: TButton;
    RemoveButton16: TButton;
    RemoveButton17: TButton;
    RemoveButton18: TButton;
    RemoveButton19: TButton;
    RemoveButton2: TButton;
    RemoveButton20: TButton;
    RemoveButton3: TButton;
    RemoveButton4: TButton;
    RemoveButton5: TButton;
    RemoveButton6: TButton;
    RemoveButton7: TButton;
    RemoveButton8: TButton;
    RemoveButton9: TButton;
    GraphListLabel: TLabel;
    Graph2Label: TLabel;
    Graph8Label: TLabel;
    Graph13Label: TLabel;
    Graph18Label: TLabel;
    Graph20Label: TLabel;
    Graph17Label: TLabel;
    Graph19Label: TLabel;
    Graph5Label: TLabel;
    Graph4Label: TLabel;
    Graph11Label: TLabel;
    Graph3Label: TLabel;
    Graph7Label: TLabel;
    Graph15Label: TLabel;
    Graph9Label: TLabel;
    Graph6Label: TLabel;
    Graph12Label: TLabel;
    Graph10Label: TLabel;
    Graph14Label: TLabel;
    Graph16Label: TLabel;
    Graph1Label: TLabel;
    ParaXEdit: TEdit;
    ParaYEdit: TEdit;
    XLine1: TLineSeries;
    YMinimumEdit: TEdit;
    YMaximumEdit: TEdit;
    YMaximumLabel: TLabel;
    YMinimumLabel: TLabel;
    XAxis: TLineSeries;
    YAxis: TLineSeries;
    XMinimumEdit: TEdit;
    XMaximumEdit: TEdit;
    XMinimumLabel: TLabel;
    XMaximumLabel: TLabel;
    PlotButton: TButton;
    Chart1: TChart;
    YLine1: TLineSeries;
    XYEquationEdit: TEdit;
    YEqualsRadioButton: TRadioButton;
    XEqualsRadioButton: TRadioButton;
    ParametricRadioButton: TRadioButton;
    procedure OnFormCreate(Sender: TObject);
    procedure ParametricRadioButtonChange(Sender: TObject);
    procedure PlotButtonClick(Sender: TObject);
    procedure XEqualsRadioButtonChange(Sender: TObject);
    procedure YEqualsRadioButtonChange(Sender: TObject);
  private
    { private declarations }
     procedure HideGraphList;
  public
    { public declarations }
     procedure ShuntingYard (SYInput: string);
    function ReturnValue (InputValue: double) : double;
  end;

var
  GraphPlotter: TGraphPlotter;
  OutputQueue: TMyQueue;

implementation

{$R *.lfm}

{ TGraphPlotter }

procedure TGraphPlotter.ShuntingYard (SYInput: string);
//Converts in infix equation to postfix
var
  I, J, M : integer;
  Character: char;
  NumStr, Temp, Temp2: string;
  IsAlgebra : boolean;
  OperatorStack: TStringStack;

begin
  M := 0;
  OperatorStack := TStringStack.Create;
  for I := 1 to Length(SYInput) do
  begin
    IsAlgebra := false;
    Character := SYInput[I + M];
    if Character = '+' then
    begin
      if not OperatorStack.IsEmpty then
      begin
        if OperatorStack.Top <> '(' then
        begin
          Repeat
          begin
            Temp := OperatorStack.Pop;
            OutputQueue.Enqueue(Temp);
          end;
          Until OperatorStack.IsEmpty or (OperatorStack.Top = '(');
        end;
      end;
      OperatorStack.Push(Character);
    end;
    if Character = '-' then
    begin
      if not OperatorStack.IsEmpty then
      begin
        if OperatorStack.Top <> '(' then
        begin
          Repeat
          begin
            Temp := OperatorStack.Pop;
            OutputQueue.Enqueue(Temp);
          end;
          Until OperatorStack.IsEmpty or (OperatorStack.Top = '(');
        end;
      end;
      OperatorStack.Push(Character);
    end;
    if Character = '/' then
    begin
      if not OperatorStack.IsEmpty then
      begin
        if ((OperatorStack.Top = '/') or (OperatorStack.Top = '^')) and
          (OperatorStack.Top <> '(') then
        begin
          Repeat
          begin
            Temp := OperatorStack.Pop;
            OutputQueue.Enqueue(Temp);
          end;
          Until OperatorStack.IsEmpty or (OperatorStack.Top = '(');
        end;
      end;
      OperatorStack.Push(Character);
    end;
    if Character = '*' then
    begin
      if not OperatorStack.IsEmpty then
      begin
        if ((OperatorStack.Top = '/') or (OperatorStack.Top = '^')) and
          (OperatorStack.Top <> '(') then
        begin
          Repeat
          begin
            Temp := OperatorStack.Pop;
            OutputQueue.Enqueue(Temp);
          end;
          Until OperatorStack.IsEmpty or (OperatorStack.Top <> '(');
        end;
      end;
      OperatorStack.Push(Character);
    end;
    if Character = '^' then
      OperatorStack.Push(Character);
    if Character = '(' then
    begin
      OperatorStack.Push(Character);
    end;
    if Character = ')' then
    begin
      if not OperatorStack.IsEmpty then
      begin
        if OperatorStack.Top <> '(' then
        begin
          Repeat
          begin
            Temp := OperatorStack.Pop;
            OutputQueue.Enqueue(Temp);
          end;
          Until OperatorStack.Top = '(';
        end;
        OperatorStack.Pop;
      end;
    end;
    if TCharacter.IsNumber(Character) then
    begin
      NumStr := Character;
      for J := (I + M + 1) to Length(SYInput) do
      begin
        if (TCharacter.IsNumber(SYInput[J])) or (SYInput[J] = '.') then
        begin
          M := M + 1;
          NumStr := NumStr + SYInput[J];
        end;
        if (SYInput[J] = 'x') or (SYInput[J] = 'y') then
        begin
          M := M + 1;
          Temp2 := SYInput[J];
          IsAlgebra := True;
        end
        else
          break;
      end;
      OutputQueue.Enqueue(NumStr);
      if IsAlgebra then
      begin
        OutputQueue.Enqueue(Temp2);
        OutputQueue.Enqueue('*');
      end;
    end;
    if (Character = 'x') or (Character = 'y') then
      OutputQueue.Enqueue(Character);

  if not OperatorStack.IsEmpty then
  begin
    Repeat
    begin
      Temp := OperatorStack.Pop;
      OutputQueue.Enqueue(Temp);
    end;
    Until OperatorStack.IsEmpty;
  end;
  OperatorStack.Destroy;
end;

end;

function TGraphPlotter.ReturnValue (InputValue: double) : double;
//Takes in x and returns f(x)
var
  Current : string;
  CalcStack : TFloatStack;
  StackTemp1, StackTemp2 : double;
  OutputQueueCopy : TMyQueue;
begin
  CalcStack := TFloatStack.Create;
  OutputQueueCopy := TMyQueue.Create;
  OutputQueueCopy := OutputQueue;
  Repeat
  Current := OutputQueueCopy.Front;
  if Current = '+' then
  begin
    StackTemp2 := CalcStack.Pop;
    StackTemp1 := CalcStack.Pop;
    CalcStack.Push(StackTemp1 + StackTemp2);
  end
  else if Current = '-' then
  begin
    StackTemp2 := CalcStack.Pop;
    StackTemp1 := CalcStack.Pop;
    CalcStack.Push(StackTemp1 - StackTemp2);
  end
  else if Current = '*' then
  begin
    StackTemp2 := CalcStack.Pop;
    StackTemp1 := CalcStack.Pop;
    CalcStack.Push(StackTemp1 * StackTemp2);
  end
  else if Current = '/' then
  begin
    StackTemp2 := CalcStack.Pop;
    StackTemp1 := CalcStack.Pop;
    CalcStack.Push(StackTemp1 / StackTemp2);
  end
  else if Current = '^' then
  begin
    StackTemp2 := CalcStack.Pop;
    StackTemp1 := CalcStack.Pop;
    CalcStack.Push(StackTemp1 ** StackTemp2);
  end
  else if Current = 'x' then
    CalcStack.Push(InputValue)
  else CalcStack.Push(strtofloat(Current));
  OutputQueueCopy.Dequeue;
  Until OutputQueueCopy.Size = 0;
  result := CalcStack.Pop;
  CalcStack.Destroy;
  OutputQueueCopy.Destroy;
end;

procedure TGraphPlotter.HideGraphList;
begin
GraphListLabel.Visible := false;
RemoveButton1.Visible := false;
RemoveButton2.Visible := false;
RemoveButton3.Visible := false;
RemoveButton4.Visible := false;
RemoveButton5.Visible := false;
RemoveButton6.Visible := false;
RemoveButton7.Visible := false;
RemoveButton8.Visible := false;
RemoveButton9.Visible := false;
RemoveButton10.Visible := false;
RemoveButton11.Visible := false;
RemoveButton12.Visible := false;
RemoveButton13.Visible := false;
RemoveButton14.Visible := false;
RemoveButton15.Visible := false;
RemoveButton16.Visible := false;
RemoveButton17.Visible := false;
RemoveButton18.Visible := false;
RemoveButton19.Visible := false;
RemoveButton20.Visible := false;
Graph1Label.Visible := false;
Graph2Label.Visible := false;
Graph3Label.Visible := false;
Graph4Label.Visible := false;
Graph5Label.Visible := false;
Graph6Label.Visible := false;
Graph7Label.Visible := false;
Graph8Label.Visible := false;
Graph9Label.Visible := false;
Graph10Label.Visible := false;
Graph11Label.Visible := false;
Graph12Label.Visible := false;
Graph13Label.Visible := false;
Graph14Label.Visible := false;
Graph15Label.Visible := false;
Graph16Label.Visible := false;
Graph17Label.Visible := false;
Graph18Label.Visible := false;
Graph19Label.Visible := false;
Graph20Label.Visible := false;
end;

procedure TGraphPlotter.PlotButtonClick(Sender: TObject);
var
X, Y, XMin, XMax, YMin, YMax, XSmallest, XBiggest, YSmallest, YBiggest : double;
N, I, J, K : integer;

begin
//setting the ranges for both axis
XMin := strtofloat(XMinimumEdit.text);
XMax := strtofloat(XMaximumEdit.text);
YMin := strtofloat(YMinimumEdit.text);
YMax := strtofloat(YMaximumEdit.text);
N := 5;

ShuntingYard(XYEquationEdit.text);

if YEqualsRadioButton.Checked then
begin
for I:=0 to N-1 do
    begin
    X := XMin + (XMax - XMin) * I /(N - 1);
    //testing
    TESTING_xLabel.Caption := floattostr(X);
    Y := ReturnValue(X);
    //testing
    TESTING_yLabel.Caption := floattostr(Y);
    YLine1.AddXY(X, Y);
    if I = 0 then
       begin
       YBiggest := Y;
       YSmallest := Y;
       end;
    if Y > YBiggest then YBiggest := Y;
    if Y < YSmallest then YSmallest := Y;
    end;
if YBiggest > YMax then
  begin
  YMax := YBiggest;
  LimitWarningLabel.Visible := true;
  end;
if YSmallest < YMin then YMin := YSmallest;
end;

if XEqualsRadioButton.Checked then
begin
for I:=0 to N-1 do
    begin
    Y := YMin + (YMax - YMin) * I / (N - 1 );
    X := sin(Y);
    XLine1.AddXY(X, Y);
    if I = 0 then
       begin
       XBiggest := X;
       XSmallest := X;
       end;
    if X > XBiggest then XBiggest := X;
    if X < XSmallest then XSmallest := X;
    end;
if XBiggest > XMax then
  begin
  XMax := XBiggest;
  LimitWarningLabel.Visible := true;
  end;
if XSmallest < XMin then
  begin
  XMin := XSmallest;
  LimitWarningLabel.Visible := true;
end;


//checks that the ranges for x are from a -ve to +ve number
//so y axis will only be plotted if it will be visible
if (XMin * XMax) < 0 then
  begin
  for J:=0 to N-1 do
      begin
      Y := YMin + (YMax - YMin) * J /(N - 1);
      YAxis.AddXY(0, Y);
      end;
  end;

//checks that the ranges for y are from a -ve to +ve number
//so x axis will only be plotted if it will be visible
if (YMin * YMax) < 0 then
  begin
  for K:=0 to N-1 do
      begin
      X := XMin + (XMax - XMin) * K /(N - 1);
      XAxis.AddXY(X, 0);
      end;
  end;

end;

end;

procedure TGraphPlotter.ParametricRadioButtonChange(Sender: TObject);
begin
  if ParametricRadioButton.Checked then
    begin
    XYEquationEdit.Visible := false;
    ParaXEdit.Visible := true;
    ParaYEdit.Visible := true;
    end;
end;

procedure TGraphPlotter.OnFormCreate(Sender: TObject);
begin
 HideGraphList;
 OutputQueue := TMyQueue.Create;
end;

procedure TGraphPlotter.XEqualsRadioButtonChange(Sender: TObject);
begin
  if XEqualsRadioButton.Checked then
    begin
    XYEquationEdit.Visible := true;
    ParaXEdit.Visible := false;
    ParaYEdit.Visible := false;
    end;
end;

procedure TGraphPlotter.YEqualsRadioButtonChange(Sender: TObject);
begin
  if YEqualsRadioButton.Checked then
    begin
    XYEquationEdit.Visible := true;
    ParaXEdit.Visible := false;
    ParaYEdit.Visible := false;
    end;
end;

end.
