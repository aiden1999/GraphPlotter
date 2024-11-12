unit UPrototype;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, TACustomSeries, TAFuncSeries, UStringStack,
  UMyQueue, Character, Math, UFloatStack;

type

  { TGraphPlotter }

  TGraphPlotter = class(TForm)
    Area: TAreaSeries;
    PiButton: TButton;
    Chart1: TChart;
    DiffAnswerLabel: TLabel;
    DifferentialEdit: TEdit;
    DifferentiateButton: TButton;
    Eqn1DiffRadioButton: TRadioButton;
    Eqn1IntRadioButton: TRadioButton;
    Eqn2DiffRadioButton: TRadioButton;
    Eqn2IntRadioButton: TRadioButton;
    Eqn3DiffRadioButton: TRadioButton;
    Eqn3IntRadioButton: TRadioButton;
    Eqn4DiffRadioButton: TRadioButton;
    Eqn4IntRadioButton: TRadioButton;
    Eqn5DiffRadioButton: TRadioButton;
    Eqn5IntRadioButton: TRadioButton;
    Eqn6DiffRadioButton: TRadioButton;
    Eqn6IntRadioButton: TRadioButton;
    GraphListLabel: TLabel;
    Graph1Label: TLabel;
    Graph2Label: TLabel;
    Graph3Label: TLabel;
    Graph4Label: TLabel;
    Graph5Label: TLabel;
    Graph6Label: TLabel;
    IntAnswerLabel: TLabel;
    IntegralLowerEdit: TEdit;
    IntegralUpperEdit: TEdit;
    IntegrateButton: TButton;
    Line1: TLineSeries;
    Line2: TLineSeries;
    Line3: TLineSeries;
    Line4: TLineSeries;
    Line5: TLineSeries;
    Line6: TLineSeries;
    MaximumEdit: TEdit;
    MaximumLabel: TLabel;
    MinimumEdit: TEdit;
    MinimumLabel: TLabel;
    ParametricRadioButton: TRadioButton;
    ParaXEdit: TEdit;
    ParaYEdit: TEdit;
    PlotButton: TButton;
    RemoveButton1: TButton;
    RemoveButton2: TButton;
    RemoveButton3: TButton;
    RemoveButton4: TButton;
    RemoveButton5: TButton;
    RemoveButton6: TButton;
    XAxis: TLineSeries;
    XEqualsRadioButton: TRadioButton;
    XYEquationEdit: TEdit;
    YAxis: TLineSeries;
    YEqualsRadioButton: TRadioButton;

    procedure DifferentialEditClick(Sender: TObject);
    procedure DifferentiateButtonClick(Sender: TObject);
    procedure Eqn1DiffRadioButtonClick(Sender: TObject);
    procedure Eqn1IntRadioButtonClick(Sender: TObject);
    procedure Eqn2DiffRadioButtonClick(Sender: TObject);
    procedure Eqn2IntRadioButtonClick(Sender: TObject);
    procedure Eqn3DiffRadioButtonClick(Sender: TObject);
    procedure Eqn3IntRadioButtonClick(Sender: TObject);
    procedure Eqn4DiffRadioButtonClick(Sender: TObject);
    procedure Eqn4IntRadioButtonClick(Sender: TObject);
    procedure Eqn5DiffRadioButtonClick(Sender: TObject);
    procedure Eqn5IntRadioButtonClick(Sender: TObject);
    procedure Eqn6DiffRadioButtonClick(Sender: TObject);
    procedure Eqn6IntRadioButtonClick(Sender: TObject);
    procedure IntegralLowerEditClick(Sender: TObject);
    procedure IntegralUpperEditClick(Sender: TObject);
    procedure IntegrateButtonClick(Sender: TObject);
    procedure MaximumEditClick(Sender: TObject);
    procedure MinimumEditClick(Sender: TObject);
    procedure OnFormCreate(Sender: TObject);
    procedure ParametricRadioButtonChange(Sender: TObject);
    procedure ParaXEditClick(Sender: TObject);
    procedure ParaYEditClick(Sender: TObject);
    procedure PiButtonClick(Sender: TObject);
    procedure PlotButtonClick(Sender: TObject);
    procedure RemoveButton1Click(Sender: TObject);
    procedure RemoveButton2Click(Sender: TObject);
    procedure RemoveButton3Click(Sender: TObject);
    procedure RemoveButton4Click(Sender: TObject);
    procedure RemoveButton5Click(Sender: TObject);
    procedure RemoveButton6Click(Sender: TObject);
    procedure XEqualsRadioButtonChange(Sender: TObject);
    procedure XYEquationEditClick(Sender: TObject);
    procedure YEqualsRadioButtonChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    procedure AddGraphToList;
    procedure ChooseLine;
    procedure DifferentiationShow;
    procedure HideGraphList;
    procedure IntegrationShow;
    procedure PlotAxis(AxisType : char; Min, Max: real);
    procedure PlotIntegrationArea(Eqn : UTF8String; Min, Max : real; Line : integer);
    procedure PlotParametricLine(ParaEqnX, ParaEqnY: UTF8String);
    procedure PlotXEqualsLine(Eqn: UTF8String);
    procedure PlotYEqualsLine(Eqn: UTF8String);
    function ReturnValue(InputValue: double): double;
    procedure ShuntingYard(SYInput: UTF8String);
    function SYRV(EqnInput: UTF8String; ValueInput: double): double;
  end;

var
  Line01, Line02, Line03, Line04, Line05, Line06: boolean;
  ChosenLine, NumGraphs: integer;
  Line01Type, Line02Type, Line03Type, Line04Type, Line05Type, Line06Type,
    PreviousEdit : string;
  Line01Eqn, Line02Eqn, Line03Eqn, Line04Eqn, Line05Eqn, Line06Eqn,
    ParaX01Eqn, ParaX02Eqn, ParaX03Eqn, ParaX04Eqn, ParaX05Eqn, ParaX06Eqn,
    ParaY01Eqn, ParaY02Eqn, ParaY03Eqn, ParaY04Eqn, ParaY05Eqn, ParaY06Eqn : UTF8String;
  GraphPlotter: TGraphPlotter;
  OutputQueue: TMyQueue;
implementation

{$R *.lfm}

{ TGraphPlotter }

procedure TGraphPlotter.AddGraphToList;
 { adds plotted lines to the graph list, and makes the appropriate form components
visible }
begin
  GraphListLabel.Visible := True;
  if ChosenLine = 1 then
  begin
    Graph1Label.Visible := True;
    RemoveButton1.Visible := True;
    Eqn1DiffRadioButton.Visible := true;
    Eqn1IntRadioButton.Visible := true;
    if YEqualsRadioButton.Checked then
      Graph1Label.Caption := 'y=' + XYEquationEdit.Text;
    if XEqualsRadioButton.Checked then
      Graph1Label.Caption := 'x=' + XYEquationEdit.Text;
    if ParametricRadioButton.Checked then
      Graph1Label.Caption := 'x=' + ParaXEdit.Text + ', y=' + ParaYEdit.Text;
  end;
  if ChosenLine = 2 then
  begin
    Graph2Label.Visible := True;
    RemoveButton2.Visible := True;
    Eqn2DiffRadioButton.Visible := true;
    Eqn2IntRadioButton.Visible := true;
    if YEqualsRadioButton.Checked then
      Graph2Label.Caption := 'y=' + XYEquationEdit.Text;
    if XEqualsRadioButton.Checked then
      Graph2Label.Caption := 'x=' + XYEquationEdit.Text;
    if ParametricRadioButton.Checked then
      Graph2Label.Caption := 'x=' + ParaXEdit.Text + ', y=' + ParaYEdit.Text;
  end;
  if ChosenLine = 3 then
  begin
    Graph3Label.Visible := True;
    RemoveButton3.Visible := True;
    Eqn3DiffRadioButton.Visible := true;
    Eqn3IntRadioButton.Visible := true;
    if YEqualsRadioButton.Checked then
      Graph3Label.Caption := 'y=' + XYEquationEdit.Text;
    if XEqualsRadioButton.Checked then
      Graph3Label.Caption := 'x=' + XYEquationEdit.Text;
    if ParametricRadioButton.Checked then
      Graph3Label.Caption := 'x=' + ParaXEdit.Text + ', y=' + ParaYEdit.Text;
  end;
  if ChosenLine = 4 then
  begin
    Graph4Label.Visible := True;
    RemoveButton4.Visible := True;
    Eqn4DiffRadioButton.Visible := true;
    Eqn4IntRadioButton.Visible := true;
    if YEqualsRadioButton.Checked then
      Graph4Label.Caption := 'y=' + XYEquationEdit.Text;
    if XEqualsRadioButton.Checked then
      Graph4Label.Caption := 'x=' + XYEquationEdit.Text;
    if ParametricRadioButton.Checked then
      Graph4Label.Caption := 'x=' + ParaXEdit.Text + ', y=' + ParaYEdit.Text;
  end;
  if ChosenLine = 5 then
  begin
    Graph5Label.Visible := True;
    RemoveButton5.Visible := True;
    Eqn5DiffRadioButton.Visible := true;
    Eqn5IntRadioButton.Visible := true;
    if YEqualsRadioButton.Checked then
      Graph5Label.Caption := 'y=' + XYEquationEdit.Text;
    if XEqualsRadioButton.Checked then
      Graph5Label.Caption := 'x=' + XYEquationEdit.Text;
    if ParametricRadioButton.Checked then
      Graph5Label.Caption := 'x=' + ParaXEdit.Text + ', y=' + ParaYEdit.Text;
  end;
  if ChosenLine = 6 then
  begin
    Graph6Label.Visible := True;
    RemoveButton6.Visible := True;
    Eqn6DiffRadioButton.Visible := true;
    Eqn6IntRadioButton.Visible := true;
    if YEqualsRadioButton.Checked then
      Graph6Label.Caption := 'y=' + XYEquationEdit.Text;
    if XEqualsRadioButton.Checked then
      Graph6Label.Caption := 'x=' + XYEquationEdit.Text;
    if ParametricRadioButton.Checked then
      Graph6Label.Caption := 'x=' + ParaXEdit.Text + ', y=' + ParaYEdit.Text;
  end;
end;

procedure TGraphPlotter.ChooseLine;
 { for choosing which coloured line is used to plot, based on whether it has
already been used or not }
var
  I: integer;
begin
  for I := 1 to 6 do
  begin
    if (I = 1) and (not Line01) then
    begin
      Line01 := True;
      ChosenLine := 1;
      break;
    end;
    if (I = 2) and (not Line02) then
    begin
      Line02 := True;
      ChosenLine := 2;
      break;
    end;
    if (I = 3) and (not Line03) then
    begin
      Line03 := True;
      ChosenLine := 3;
      break;
    end;
    if (I = 4) and (not Line04) then
    begin
      Line04 := True;
      ChosenLine := 4;
      break;
    end;
    if (I = 5) and (not Line05) then
    begin
      Line05 := True;
      ChosenLine := 5;
      break;
    end;
    if (I = 6) and (not Line06) then
    begin
      Line06 := True;
      ChosenLine := 6;
      break;
    end;
  end;
end;

procedure TGraphPlotter.DifferentiationShow;
 { shows the form components needed to differentiate }
begin
  DifferentialEdit.Visible := true;
  DifferentiateButton.Visible := true;
  DiffAnswerLabel.Visible := true;
end;

procedure TGraphPlotter.HideGraphList;
 { hides all the form components which make up the list of graphs }
begin
  GraphListLabel.Visible := false;
  RemoveButton1.Visible := false;
  RemoveButton2.Visible := false;
  RemoveButton3.Visible := false;
  RemoveButton4.Visible := false;
  RemoveButton5.Visible := false;
  RemoveButton6.Visible := false;
  Graph1Label.Visible := false;
  Graph2Label.Visible := false;
  Graph3Label.Visible := false;
  Graph4Label.Visible := false;
  Graph5Label.Visible := false;
  Graph6Label.Visible := false;
  Eqn1DiffRadioButton.Visible := false;
  Eqn2DiffRadioButton.Visible := false;
  Eqn3DiffRadioButton.Visible := false;
  Eqn4DiffRadioButton.Visible := false;
  Eqn5DiffRadioButton.Visible := false;
  Eqn6DiffRadioButton.Visible := false;
  Eqn1IntRadioButton.Visible := false;
  Eqn2IntRadioButton.Visible := false;
  Eqn3IntRadioButton.Visible := false;
  Eqn4IntRadioButton.Visible := false;
  Eqn5IntRadioButton.Visible := false;
  Eqn6IntRadioButton.Visible := false;
end;

procedure TGraphPlotter.IntegrationShow;
 { shows the form components needed for integration }
begin
  IntAnswerLabel.Visible := true;
  IntegralLowerEdit.Visible := true;
  IntegralUpperEdit.Visible := true;
  IntegrateButton.Visible := true;
end;

procedure TGraphPlotter.PlotAxis(AxisType: char; Min, Max: real);
 { plots the axes }
var
  I: integer;
  X, Y: real;
begin
  for I := 0 to 999 do
  begin
    if AxisType = 'x' then
    begin
      X := Min + (Max - Min) * I / 999;
      XAxis.AddXY(X, 0);
    end;
    if AxisType = 'y' then
    begin
      Y := Min + (Max - Min) * I / 999;
      YAxis.AddXY(0, Y);
    end;
  end;
end;

procedure TGraphPLotter.PlotIntegrationArea(Eqn : UTF8String; Min, Max : real;
  Line : integer);
 { plots the area represented by a definite integral }
var
  N, I : integer;
  X, Y : real;
begin
  N := 1000;
  case Line of
  1 : Area.AreaLinesPen.Color := $000000E7;
  2 : Area.AreaLinesPen.Color := $00008CFF;
  3 : Area.AreaLinesPen.Color := $0000EFFF;
  4 : Area.AreaLinesPen.Color := $001F8100;
  5 : Area.AreaLinesPen.Color := $00FF4400;
  6 : Area.AreaLinesPen.Color := $00890076;
  end;
  for I := 0 to N - 1 do
  begin
    X := Min + (Max - Min) * I / (N - 1);
    Y := SYRV(Eqn, X);
    Area.AddXY(X, Y);
  end;
end;

procedure TGraphPlotter.PlotParametricLine(ParaEqnX, ParaEqnY: UTF8String);
 { plots lines made up of a pair of parametric equations }
var
  TMin, TMax, T, X, Y, YMin, YMax, XMin, XMax: real;
  I, N: integer;
begin
  N := 1000;
  TMin := strtofloat(MinimumEdit.Text);
  TMax := strtofloat(MaximumEdit.Text);
  ChooseLine;
  for I := 0 to N - 1 do
  begin
    T := TMin + (TMax - TMin) * I / (N - 1);
    X := SYRV(ParaEqnX, T);
    Y := SYRV(ParaEqnY, T);
    case ChosenLine of
      1:
      begin
        Line1.AddXY(X, Y);
        Line01Type := 'parametric';
        ParaX01Eqn := ParaEqnX;
        ParaY01Eqn := ParaEqnY;
      end;
      2:
      begin
        Line2.AddXY(X, Y);
        Line02Type := 'parametric';
        ParaX02Eqn := ParaEqnX;
        ParaY02Eqn := ParaEqnY;
      end;
      3:
      begin
        Line3.AddXY(X, Y);
        Line03Type := 'parametric';
        ParaX03Eqn := ParaEqnX;
        ParaY03Eqn := ParaEqnY;
      end;
      4:
      begin
        Line4.AddXY(X, Y);
        Line04Type := 'parametric';
        ParaX04Eqn := ParaEqnX;
        ParaY04Eqn := ParaEqnY;
      end;
      5:
      begin
        Line5.AddXY(X, Y);
        Line05Type := 'parametric';
        ParaX05Eqn := ParaEqnX;
        ParaY05Eqn := ParaEqnY;
      end;
      6:
      begin
        Line6.AddXY(X, Y);
        Line06Type := 'parametric';
        ParaX06Eqn := ParaEqnX;
        ParaY06Eqn := ParaEqnY;
      end;
    end;
    if I = 0 then
    begin
      XMin := X;
      XMax := X;
      YMax := Y;
      YMin := Y;
    end;
    if I <> 0 then
    begin
      if X > XMax then
        XMax := X;
      if X < XMin then
        XMin := X;
      if Y > YMax then
        YMax := Y;
      if Y < YMin then
        YMin := Y;
    end;
  end;
  if (YMin * YMax) < 0 then
    PlotAxis('x', XMin, XMax);
  if (XMin * XMax) < 0 then
    PlotAxis('y', XMin, XMax);
end;

procedure TGraphPlotter.PlotXEqualsLine(Eqn: UTF8String);
 { plots lines with an equation in the form x= }
var
  YMin, YMax, Y, X, XMin, XMax: real;
  I, N: integer;
begin
  N := 1000;
  YMin := strtofloat(MinimumEdit.Text);
  YMax := strtofloat(MaximumEdit.Text);
  ChooseLine;
  for I := 0 to N - 1 do
  begin
    Y := YMin + (YMax - YMin) * I / (N - 1);
    X := SYRV(Eqn, Y);
    case ChosenLine of
      1:
      begin
        Line1.AddXY(X, Y);
        Line01Type := 'x equals';
        Line01Eqn := Eqn;
      end;
      2:
      begin
        Line2.AddXY(X, Y);
        Line02Type := 'x equals';
        Line02Eqn := Eqn;
      end;
      3:
      begin
        Line3.AddXY(X, Y);
        Line03Type := 'x equals';
        Line03Eqn := Eqn;
      end;
      4:
      begin
        Line4.AddXY(X, Y);
        Line04Type := 'x equals';
        Line04Eqn := Eqn;
      end;
      5:
      begin
        Line5.AddXY(X, Y);
        Line05Type := 'x equals';
        Line05Eqn := Eqn;
      end;
      6:
      begin
        Line6.AddXY(X, Y);
        Line06Type := 'x equals';
        Line06Eqn := Eqn;
      end;
    end;
    if I = 0 then
    begin
      XMin := X;
      XMax := X;
    end;
    if I <> 0 then
    begin
      if X > XMax then
        XMax := X;
      if X < XMin then
        XMin := X;
    end;
  end;
  if (YMin * YMax) < 0 then
    PlotAxis('x', XMin, XMax);
  if (XMin * XMax) < 0 then
    PlotAxis('y', YMin, YMax);
end;

procedure TGraphPlotter.PlotYEqualsLine(Eqn: UTF8String);
 { plots lines with an equation in the form y= }
var
  XMin, XMax, X, Y, YMin, YMax: real;
  I, N: integer;
begin
  XMin := strtofloat(MinimumEdit.Text);
  XMax := strtofloat(MaximumEdit.Text);
  N := 1000;
  ChooseLine;
  for I := 0 to N - 1 do
  begin
    X := XMin + (XMax - XMin) * I / (N - 1);
    Y := SYRV(Eqn, X);
    case ChosenLine of
      1:
      begin
        Line1.AddXY(X, Y);
        Line01Type := 'y equals';
        Line01Eqn := Eqn;
      end;
      2:
      begin
        Line2.AddXY(X, Y);
        Line02Type := 'y equals';
        Line02Eqn := Eqn;
      end;
      3:
      begin
        Line3.AddXY(X, Y);
        Line03Type := 'y equals';
        Line03Eqn := Eqn;
      end;
      4:
      begin
        Line4.AddXY(X, Y);
        Line04Type := 'y equals';
        Line04Eqn := Eqn;
      end;
      5:
      begin
        Line5.AddXY(X, Y);
        Line05Type := 'y equals';
        Line05Eqn := Eqn;
      end;
      6:
      begin
        Line6.AddXY(X, Y);
        Line06Type := 'y equals';
        Line06Eqn := Eqn;
      end;
    end;
    if I = 0 then
    begin
      YMin := Y;
      YMax := Y;
    end;
    if I <> 0 then
    begin
      if Y > YMax then
        YMax := Y;
      if Y < YMin then
        YMin := Y;
    end;
  end;
  if (XMin * XMax) < 0 then
    PlotAxis('y', YMin, YMax);
  if (YMin * YMax) < 0 then
    PlotAxis('x', XMin, XMax);
end;

function TGraphPlotter.ReturnValue(InputValue: double): double;
 { Takes in x and returns f(x) or whatever is relevent to that specfic
equation(s) }
var
  Current: UTF8String;
  CalcStack: TFloatStack;
  StackTemp1, StackTemp2: double;
begin
  CalcStack := TFloatStack.Create;
  repeat
    begin
      Current := OutputQueue.Front;
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
      else if Current = 'sin' then
      begin
        StackTemp1 := CalcStack.Pop;
        CalcStack.Push(sin(StackTemp1));
      end
      else if Current = 'cos' then
      begin
        StackTemp1 := CalcStack.Pop;
        CalcStack.Push(cos(StackTemp1));
      end
      else if ((Current = 'x') or (Current = 'y')) or (Current = 't') then
        CalcStack.Push(InputValue)
      else
        CalcStack.Push(strtofloat(Current));
      OutputQueue.Dequeue;
    end;
  until OutputQueue.Size = 0;
  Result := CalcStack.Pop;
  CalcStack.Free;
  OutputQueue.Free;
end;

procedure TGraphPlotter.ShuntingYard(SYInput: UTF8String);
 { Converts eqaution string in infix notation to a queue with the individual
'elements' of the equation in postfix (reverse polish) notation }
var
  II, J, M: integer;
  Character: char;
  NumStr, Temp, Temp2: UTF8String;
  IsAlgebra: boolean;
  OperatorStack: TStringStack;

begin
  OutputQueue := TMyQueue.Create;
  M := 0;
  OperatorStack := TStringStack.Create;
  for II := 1 to Length(SYInput) do
  begin
    IsAlgebra := False;
    Character := SYInput[II + M];
    if Character = 's' then
    begin
      if SYInput[II + M + 1] = 'i' then
      begin
        if SYInput[II + M + 2] = 'n' then
        begin
          if not OperatorStack.IsEmpty then
          begin
            if OperatorStack.Top <> '(' then
            begin
              repeat
              begin
                Temp := OperatorStack.Pop;
                OutputQueue.Enqueue(Temp);
              end;
              until OperatorStack.IsEmpty or (OperatorStack.Top = '(');
            end;
          end;
        OperatorStack.Push('sin');
        end;
      end;
    end;
    if Character = 'c' then
    begin
      if SYInput[II + M + 1] = 'o' then
      begin
        if SYInput[II + M + 2] = 's' then
        begin
          if not OperatorStack.IsEmpty then
          begin
            if OperatorStack.Top <> '(' then
            begin
              repeat
              begin
                Temp := OperatorStack.Pop;
                OutputQueue.Enqueue(Temp);
              end;
              until OperatorStack.IsEmpty or (OperatorStack.Top = '(');
            end;
          end;
        OperatorStack.Push('cos');
        end;
      end;
    end;
    if Character = '+' then
    begin
      if not OperatorStack.IsEmpty then
      begin
        if OperatorStack.Top <> '(' then
        begin
          repeat
            begin
              Temp := OperatorStack.Pop;
              OutputQueue.Enqueue(Temp);
            end;
          until OperatorStack.IsEmpty or (OperatorStack.Top = '(');
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
          repeat
            begin
              Temp := OperatorStack.Pop;
              OutputQueue.Enqueue(Temp);
            end;
          until OperatorStack.IsEmpty or (OperatorStack.Top = '(');
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
          repeat
            begin
              Temp := OperatorStack.Pop;
              OutputQueue.Enqueue(Temp);
            end;
          until OperatorStack.IsEmpty or (OperatorStack.Top = '(');
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
          repeat
            begin
              Temp := OperatorStack.Pop;
              OutputQueue.Enqueue(Temp);
            end;
          until OperatorStack.IsEmpty or (OperatorStack.Top <> '(');
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
          repeat
            begin
              Temp := OperatorStack.Pop;
              OutputQueue.Enqueue(Temp);
            end;
          until OperatorStack.Top = '(';
        end;
        OperatorStack.Pop;
      end;
    end;
    if TCharacter.IsNumber(Character) then
    begin
      NumStr := Character;
      for J := (II + M + 1) to Length(SYInput) do
      begin
        if (TCharacter.IsNumber(SYInput[J])) or (SYInput[J] = '.') then
        begin
          M := M + 1;
          NumStr := NumStr + SYInput[J];
        end;
        if (SYInput[J] = 'x')
          or (SYInput[J] = 'y')
          or (SYInput[J] = 't')
          or (SYInput[J] = 'e')
          or (SYInput[J] = #207) then
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
        if (Temp2 = 'e')
          or (Temp2 = #207) then
          begin
            case Temp2 of
              'e' : OutputQueue.Enqueue('2.718281828459');
              #207 : OutputQueue.Enqueue('3.141592653589');
            end;
          end
        else
          OutputQueue.Enqueue(Temp2);
        OutputQueue.Enqueue('*');
      end;
    end;
    if (((Character = 'x') or (Character = 'y')) or ((Character = 't'))) then
      OutputQueue.Enqueue(Character);
    if Character = 'e' then
      OutputQueue.Enqueue('2.718281828459');
    if Character = #207 then
      OutputQueue.Enqueue('3.141592653589');
  end;

  if not OperatorStack.IsEmpty then
  begin
    repeat
      begin
        Temp := OperatorStack.Pop;
        OutputQueue.Enqueue(Temp);
      end;
    until OperatorStack.IsEmpty;
  end;
  OperatorStack.Free;
end;

function TGraphPlotter.SYRV(EqnInput: UTF8String; ValueInput: double): double;
 { combines ReturnValue and ShuntingYard into one function }
begin
  ShuntingYard(EqnInput);
  Result := ReturnValue(ValueInput);
end;

{ Form Component Procedures }

procedure TGraphPlotter.PlotButtonClick(Sender: TObject);
var
  Eqn, ParaEqnX, ParaEqnY: UTF8String;
begin
  Eqn := XYEquationEdit.Text;
  ParaEqnX := ParaXEdit.Text;
  ParaEqnY := ParaYEdit.Text;
  NumGraphs := NumGraphs + 1;
  if YEqualsRadioButton.Checked then
    PlotYEqualsLine(Eqn);
  if XEqualsRadioButton.Checked then
    PlotXEqualsLine(Eqn);
  if ParametricRadioButton.Checked then
    PlotParametricLine(ParaEqnX, ParaEqnY);
  AddGraphToList;
  if NumGraphs = 6 then
    PlotButton.Enabled := False;
end;

procedure TGraphPlotter.RemoveButton1Click(Sender: TObject);
begin
  RemoveButton1.Visible := False;
  Graph1Label.Caption := '';
  Line1.Clear;
  Line01 := False;
  NumGraphs := NumGraphs - 1;
  PlotButton.Enabled := True;
  Eqn1DiffRadioButton.Visible := false;
  Eqn1IntRadioButton.Visible := false;
end;

procedure TGraphPlotter.RemoveButton2Click(Sender: TObject);
begin
  RemoveButton2.Visible := False;
  Graph2Label.Caption := '';
  Line2.Clear;
  Line02 := False;
  NumGraphs := NumGraphs - 1;
  PlotButton.Enabled := True;
  Eqn2DiffRadioButton.Visible := false;
  Eqn2IntRadioButton.Visible := false;
end;

procedure TGraphPlotter.RemoveButton3Click(Sender: TObject);
begin
  RemoveButton3.Visible := False;
  Graph3Label.Caption := '';
  Line3.Clear;
  Line03 := False;
  NumGraphs := NumGraphs - 1;
  PlotButton.Enabled := True;
  Eqn3DiffRadioButton.Visible := false;
  Eqn3IntRadioButton.Visible := false;
end;

procedure TGraphPlotter.RemoveButton4Click(Sender: TObject);
begin
  RemoveButton4.Visible := False;
  Graph4Label.Caption := '';
  Line4.Clear;
  Line04 := False;
  NumGraphs := NumGraphs - 1;
  PlotButton.Enabled := True;
  Eqn4DiffRadioButton.Visible := false;
  Eqn4IntRadioButton.Visible := false;
end;

procedure TGraphPlotter.RemoveButton5Click(Sender: TObject);
begin
  RemoveButton5.Visible := False;
  Graph5Label.Caption := '';
  Line5.Clear;
  Line05 := False;
  NumGraphs := NumGraphs - 1;
  PlotButton.Enabled := True;
  Eqn5DiffRadioButton.Visible := false;
  Eqn5IntRadioButton.Visible := false;
end;

procedure TGraphPlotter.RemoveButton6Click(Sender: TObject);
begin
  RemoveButton6.Visible := False;
  Graph6Label.Caption := '';
  Line6.Clear;
  Line06 := False;
  NumGraphs := NumGraphs - 1;
  PlotButton.Enabled := True;
  Eqn6DiffRadioButton.Visible := false;
  Eqn6IntRadioButton.Visible := false;
end;

procedure TGraphPlotter.ParametricRadioButtonChange(Sender: TObject);
begin
  if ParametricRadioButton.Checked then
  begin
    XYEquationEdit.Visible := False;
    ParaXEdit.Visible := True;
    ParaYEdit.Visible := True;
    MinimumLabel.Caption := 't Minimum';
    MaximumLabel.Caption := 't Maximum';
  end;
end;

procedure TGraphPlotter.ParaXEditClick(Sender: TObject);
begin
  PreviousEdit := 'ParaX';
end;

procedure TGraphPlotter.ParaYEditClick(Sender: TObject);
begin
  PreviousEdit := 'ParaY';
end;

procedure TGraphPlotter.PiButtonClick(Sender: TObject);
begin
  case PreviousEdit of
    'XYEquation': XYEquationEdit.text := XYEquationEdit.Text + 'π';
    'ParaX' : ParaXEdit.text := ParaXEdit.text + 'π';
    'ParaY' : ParaYEdit.text := ParaYEdit.text + 'π';
    'Differential' : DifferentialEdit.text := DifferentialEdit.text + 'π';
    'IntegralLower' : IntegralLowerEdit.text := IntegralLowerEdit.text + 'π';
    'IntegralUpper' : IntegralUpperEdit.text := IntegralUpperEdit.text + 'π';
    'Maximum' : MaximumEdit.text := MaximumEdit.text + 'π';
    'Minimum' : MinimumEdit.text := MinimumEdit.text + 'π';
  end;
end;

procedure TGraphPlotter.OnFormCreate(Sender: TObject);
begin
  HideGraphList;
  MinimumLabel.Caption := '  Minimum';
  MaximumLabel.Caption := '  Maximum';
  Line01 := False;
  Line02 := False;
  Line03 := False;
  Line04 := False;
  Line05 := False;
  Line06 := False;
  DifferentialEdit.Visible := false;
  DifferentiateButton.Visible := false;
  DiffAnswerLabel.Visible := false;
  IntAnswerLabel.Visible := false;
  IntegralLowerEdit.Visible := false;
  IntegrateButton.Visible := false;
  IntegralUpperEdit.Visible := false;
end;

procedure TGraphPlotter.DifferentiateButtonClick(Sender: TObject);
 { does the differentiation }
var
  Point, UpperX, LowerX, UpperY, LowerY, DeltaY, DeltaX, Answer,
    UpperT, LowerT : real;
  Eqn1, Eqn2, LineType : UTF8String;
begin
  if Eqn1DiffRadioButton.Checked then
  begin
    LineType := Line01Type;
    if LineType = 'parametric' then
    begin
      Eqn1 := ParaX01Eqn;
      Eqn2 := ParaY01Eqn;
    end;
    if (LineType = 'y equals') or (LineType = 'x equals') then
      Eqn1 := Line01Eqn;
  end;
  if Eqn2DiffRadioButton.Checked then
  begin
    LineType := Line02Type;
    if LineType = 'parametric' then
    begin
      Eqn1 := ParaX02Eqn;
      Eqn2 := ParaY02Eqn;
    end;
    if (LineType = 'y equals') or (LineType = 'x equals') then
      Eqn1 := Line02Eqn;
  end;
  if Eqn3DiffRadioButton.Checked then
  begin
    LineType := Line03Type;
    if LineType = 'parametric' then
    begin
      Eqn1 := ParaX03Eqn;
      Eqn2 := ParaY03Eqn;
    end;
    if (LineType = 'y equals') or (LineType = 'x equals') then
      Eqn1 := Line03Eqn; ;
  end;
  if Eqn4DiffRadioButton.Checked then
  begin
    LineType := Line04Type;
    if LineType = 'parametric' then
    begin
      Eqn1 := ParaX04Eqn;
      Eqn2 := ParaY04Eqn;
    end;
    if (LineType = 'y equals') or (LineType = 'x equals') then
      Eqn1 := Line04Eqn;
  end;
  if Eqn5DiffRadioButton.Checked then
  begin
    LineType := Line05Type;
    if LineType = 'parametric' then
    begin
      Eqn1 := ParaX05Eqn;
      Eqn2 := ParaY05Eqn;
    end;
    if (LineType = 'y equals') or (LineType = 'x equals') then
      Eqn1 := Line05Eqn;
  end;
  if Eqn6DiffRadioButton.Checked then
  begin
    LineType := Line06Type;
    if LineType = 'parametric' then
    begin
      Eqn1 := ParaX06Eqn;
      Eqn2 := ParaY06Eqn;
    end;
    if (LineType = 'y equals') or (LineType = 'x equals') then
      Eqn1 := Line06Eqn;
  end;

  Point := strtofloat(DifferentialEdit.Text);
  if LineType = 'y equals' then
  begin
    UpperX := Point + (Point / 1000000);
    LowerX := Point - (Point / 1000000);
    UpperY := SYRV(Eqn1, UpperX);
    LowerY := SYRV(Eqn1, LowerX);
  end;
  if LineType = 'x equals' then
  begin
    UpperY := Point + (Point / 1000000);
    LowerY := Point - (Point / 1000000);
    UpperX := SYRV(Eqn1, UpperY);
    LowerX := SYRV(Eqn1, LowerY);
  end;
  if LineType = 'parametric' then
  begin
    UpperT := Point + (Point / 1000000);
    LowerT := Point - (Point / 1000000);
    UpperX := SYRV(Eqn1, UpperT);
    LowerX := SYRV(Eqn1, LowerT);
    UpperY := SYRV(Eqn2, UpperT);
    LowerY := SYRV(Eqn1, LowerT);
  end;
  DeltaX := abs(UpperX - LowerX);
  DeltaY := abs(UpperY - LowerY);
  Answer := DeltaY / DeltaX;
  DiffAnswerLabel.Caption := floattostr(Answer);
end;

procedure TGraphPlotter.DifferentialEditClick(Sender: TObject);
begin
  PreviousEdit := 'Differential';
end;

procedure TGraphPlotter.Eqn1DiffRadioButtonClick(Sender: TObject);
begin
  DifferentiationShow;
  case Line01Type of
  'y equals' : DifferentialEdit.TextHint := 'x =';
  'x equals' : DifferentialEdit.TextHint := 'y =';
  'parametric' : DifferentialEdit.TextHint := 't =';
  end;

end;

procedure TGraphPlotter.Eqn1IntRadioButtonClick(Sender: TObject);
begin
  IntegrationShow;
  case Line01Type of
  'y equals' :
    begin
      IntegralLowerEdit.TextHint := 'Lower x =';
      IntegralUpperEdit.TextHint := 'Upper x =';
    end;
  'x equals' :
    begin
      IntegralLowerEdit.TextHint := 'Lower y =';
      IntegralUpperEdit.TextHint := 'Upper y =';
    end;
  'parametric' :
    begin
      IntegralLowerEdit.TextHint := 'Lower t =';
      IntegralUpperEdit.TextHint := 'Upper t =';
    end;
  end;
end;

procedure TGraphPlotter.Eqn2DiffRadioButtonClick(Sender: TObject);
begin
  DifferentiationShow;
  case Line02Type of
  'y equals' : DifferentialEdit.TextHint := 'x =';
  'x equals' : DifferentialEdit.TextHint := 'y =';
  'parametric' : DifferentialEdit.TextHint := 't =';
  end;
end;

procedure TGraphPlotter.Eqn2IntRadioButtonClick(Sender: TObject);
begin
  IntegrationShow;
  case Line02Type of
  'y equals' :
    begin
      IntegralLowerEdit.TextHint := 'Lower x =';
      IntegralUpperEdit.TextHint := 'Upper x =';
    end;
  'x equals' :
    begin
      IntegralLowerEdit.TextHint := 'Lower y =';
      IntegralUpperEdit.TextHint := 'Upper y =';
    end;
  'parametric' :
    begin
      IntegralLowerEdit.TextHint := 'Lower t =';
      IntegralUpperEdit.TextHint := 'Upper t =';
    end;
  end;
end;

procedure TGraphPlotter.Eqn3DiffRadioButtonClick(Sender: TObject);
begin
  DifferentiationShow;
  case Line03Type of
  'y equals' : DifferentialEdit.TextHint := 'x =';
  'x equals' : DifferentialEdit.TextHint := 'y =';
  'parametric' : DifferentialEdit.TextHint := 't =';
  end;
end;

procedure TGraphPlotter.Eqn3IntRadioButtonClick(Sender: TObject);
begin
  IntegrationShow;
  case Line03Type of
  'y equals' :
    begin
      IntegralLowerEdit.TextHint := 'Lower x =';
      IntegralUpperEdit.TextHint := 'Upper x =';
    end;
  'x equals' :
    begin
      IntegralLowerEdit.TextHint := 'Lower y =';
      IntegralUpperEdit.TextHint := 'Upper y =';
    end;
  'parametric' :
    begin
      IntegralLowerEdit.TextHint := 'Lower t =';
      IntegralUpperEdit.TextHint := 'Upper t =';
    end;
  end;
end;

procedure TGraphPlotter.Eqn4DiffRadioButtonClick(Sender: TObject);
begin
  DifferentiationShow;
  case Line04Type of
  'y equals' : DifferentialEdit.TextHint := 'x =';
  'x equals' : DifferentialEdit.TextHint := 'y =';
  'parametric' : DifferentialEdit.TextHint := 't =';
  end;
end;

procedure TGraphPlotter.Eqn4IntRadioButtonClick(Sender: TObject);
begin
  IntegrationShow;
  case Line04Type of
  'y equals' :
    begin
      IntegralLowerEdit.TextHint := 'Lower x =';
      IntegralUpperEdit.TextHint := 'Upper x =';
    end;
  'x equals' :
    begin
      IntegralLowerEdit.TextHint := 'Lower y =';
      IntegralUpperEdit.TextHint := 'Upper y =';
    end;
  'parametric' :
    begin
      IntegralLowerEdit.TextHint := 'Lower t =';
      IntegralUpperEdit.TextHint := 'Upper t =';
    end;
  end;
end;

procedure TGraphPlotter.Eqn5DiffRadioButtonClick(Sender: TObject);
begin
  DifferentiationShow;
  case Line05Type of
  'y equals' : DifferentialEdit.TextHint := 'x =';
  'x equals' : DifferentialEdit.TextHint := 'y =';
  'parametric' : DifferentialEdit.TextHint := 't =';
  end;
end;

procedure TGraphPlotter.Eqn5IntRadioButtonClick(Sender: TObject);
begin
  IntegrationShow;
  case Line05Type of
  'y equals' :
    begin
      IntegralLowerEdit.TextHint := 'Lower x =';
      IntegralUpperEdit.TextHint := 'Upper x =';
    end;
  'x equals' :
    begin
      IntegralLowerEdit.TextHint := 'Lower y =';
      IntegralUpperEdit.TextHint := 'Upper y =';
    end;
  'parametric' :
    begin
      IntegralLowerEdit.TextHint := 'Lower t =';
      IntegralUpperEdit.TextHint := 'Upper t =';
    end;
  end;
end;

procedure TGraphPlotter.Eqn6DiffRadioButtonClick(Sender: TObject);
begin
  DifferentiationShow;
  case Line06Type of
  'y equals' : DifferentialEdit.TextHint := 'x =';
  'x equals' : DifferentialEdit.TextHint := 'y =';
  'parametric' : DifferentialEdit.TextHint := 't =';
  end;
end;

procedure TGraphPlotter.Eqn6IntRadioButtonClick(Sender: TObject);
begin
  IntegrationShow;
  case Line06Type of
  'y equals' :
    begin
      IntegralLowerEdit.TextHint := 'Lower x =';
      IntegralUpperEdit.TextHint := 'Upper x =';
    end;
  'x equals' :
    begin
      IntegralLowerEdit.TextHint := 'Lower y =';
      IntegralUpperEdit.TextHint := 'Upper y =';
    end;
  'parametric' :
    begin
      IntegralLowerEdit.TextHint := 'Lower t =';
      IntegralUpperEdit.TextHint := 'Upper t =';
    end;
  end;
end;

procedure TGraphPlotter.IntegralLowerEditClick(Sender: TObject);
begin
  PreviousEdit := 'IntegralLower';
end;

procedure TGraphPlotter.IntegralUpperEditClick(Sender: TObject);
begin
  PreviousEdit := 'IntegralUpper';
end;

procedure TGraphPlotter.IntegrateButtonClick(Sender: TObject);
 { does the integration }
var
  LowerLimit, UpperLimit, H, X, Y, Mult4, Mult2, Answer, Y0, YN, X0, XN, T : real;
  N , SelectedLine : integer;
  LineType, Eqn1, Eqn2 : UTF8String;
begin
  if Eqn1IntRadioButton.Checked then
  begin
    LineType := Line01Type;
    if LineType = 'parametric' then
    begin
      Eqn1 := ParaX01Eqn;
      Eqn2 := ParaY01Eqn;
    end;
    if (LineType = 'y equals') or (LineType = 'x equals') then
      Eqn1 := Line01Eqn;
    SelectedLine := 1;
  end;
  if Eqn2IntRadioButton.Checked then
  begin
    LineType := Line02Type;
    if LineType = 'parametric' then
    begin
      Eqn1 := ParaX02Eqn;
      Eqn2 := ParaY02Eqn;
    end;
    if (LineType = 'y equals') or (LineType = 'x equals') then
      Eqn1 := Line02Eqn;
    SelectedLine := 2;
  end;
  if Eqn3IntRadioButton.Checked then
  begin
    LineType := Line03Type;
    if LineType = 'parametric' then
    begin
      Eqn1 := ParaX03Eqn;
      Eqn2 := ParaY03Eqn;
    end;
    if (LineType = 'y equals') or (LineType = 'x equals') then
      Eqn1 := Line03Eqn;
    SelectedLine := 3;
  end;
  if Eqn4IntRadioButton.Checked then
  begin
    LineType := Line04Type;
    if LineType = 'parametric' then
    begin
      Eqn1 := ParaX04Eqn;
      Eqn2 := ParaY04Eqn;
    end;
    if (LineType = 'y equals') or (LineType = 'x equals') then
      Eqn1 := Line04Eqn;
    SelectedLine := 4;
  end;
  if Eqn5IntRadioButton.Checked then
  begin
    LineType := Line05Type;
    if LineType = 'parametric' then
    begin
      Eqn1 := ParaX05Eqn;
      Eqn2 := ParaY05Eqn;
    end;
    if (LineType = 'y equals') or (LineType = 'x equals') then
      Eqn1 := Line05Eqn;
    SelectedLine := 5;
  end;
  if Eqn6IntRadioButton.Checked then
  begin
    LineType := Line06Type;
    if LineType = 'parametric' then
    begin
      Eqn1 := ParaX06Eqn;
      Eqn2 := ParaY06Eqn;
    end;
    if (LineType = 'y equals') or (LineType = 'x equals') then
      Eqn1 := Line06Eqn;
    SelectedLine := 6;
  end;
  N := 20;
  Mult2 := 0;
  Mult4 := 0;
  LowerLimit := strtofloat(IntegralLowerEdit.text);
  UpperLimit := strtofloat(IntegralUpperEdit.text);
  H := (UpperLimit - LowerLimit) / N;
  if LineType = 'y equals' then
  begin
    for N := 1 to N - 1 do
    begin
      X := LowerLimit + (H * N);
      Y := SYRV(Eqn1, X);
      if N mod 2 = 1 then
        Mult4 := Mult4 + Y;
      if N mod 2 = 0 then
        Mult2 := Mult2 + Y;
    end;
    Y0 := SYRV(Eqn1, LowerLimit);
    YN := SYRV(Eqn1, UpperLimit);
    Answer := (H/3)*(Y0 + YN + (4 * Mult4) + (2 * Mult2));
    PlotIntegrationArea(Eqn1, LowerLimit, UpperLimit, SelectedLine);
  end;
  if LineType = 'x equals' then
  begin
    for N := 1 to N - 1 do
    begin
      Y := LowerLimit + (H * N);
      X := SYRV(Eqn1, Y);
      if N mod 2 = 1 then
        Mult4 := Mult4 + X;
      if N mod 2 = 0 then
        Mult2 := Mult2 + X;
    end;
    X0 := SYRV(Eqn1, LowerLimit);
    XN := SYRV(Eqn1, UpperLimit);
    Answer := (H/3)*(X0 + XN + (4 * Mult4) + (2 * Mult2));
  end;
  if LineType = 'parametric' then
  begin
    for N := 1 to N - 1 do
    begin
      T := LowerLimit + (H * N);
      Y := SYRV(Eqn2, T);
      if N mod 2 = 1 then
        Mult4 := Mult4 + Y;
      if N mod 2 = 0 then
        Mult2 := Mult2 + Y;
    end;
    Y0 := SYRV(Eqn2, LowerLimit);
    YN := SYRV(Eqn2, UpperLimit);
    Answer := (H/3)*(Y0 + YN + (4 * Mult4) + (2 * Mult2));
  end;
  IntAnswerLabel.Caption := floattostr(Answer);
end;

procedure TGraphPlotter.MaximumEditClick(Sender: TObject);
begin
  PreviousEdit := 'Maximum';
end;

procedure TGraphPlotter.MinimumEditClick(Sender: TObject);
begin
  PreviousEdit := 'Minimum';
end;

procedure TGraphPlotter.XEqualsRadioButtonChange(Sender: TObject);
begin
  if XEqualsRadioButton.Checked then
  begin
    XYEquationEdit.Visible := True;
    ParaXEdit.Visible := False;
    ParaYEdit.Visible := False;
    MinimumLabel.Caption := 'y Minimum';
    MaximumLabel.Caption := 'y Maximum';
  end;
end;

procedure TGraphPlotter.XYEquationEditClick(Sender: TObject);
begin
  PreviousEdit := 'XYEquation';
end;

procedure TGraphPlotter.YEqualsRadioButtonChange(Sender: TObject);
begin
  if YEqualsRadioButton.Checked then
  begin
    XYEquationEdit.Visible := True;
    ParaXEdit.Visible := False;
    ParaYEdit.Visible := False;
    MinimumLabel.Caption := 'x Minimum';
    MaximumLabel.Caption := 'x Maximum';
  end;
end;

end.
