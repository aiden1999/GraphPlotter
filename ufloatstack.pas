unit ufloatstack;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TFloatStack = class
  strict private
    FItems: array of double;
    FTop:integer;
    function GetTop:double; //inspect top item without popping
    function GetSize:integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Push(s:double);
    function Pop:double;
    function IsEmpty:boolean;
    property Top: double read GetTop;
    property Size: integer read GetSize;
  end;

implementation
{ TStack }

constructor TFloatStack.Create;
begin
  SetLength(FItems,100);
  FTop:=-1;
end;

destructor TFloatStack.Destroy;
begin
  FItems:=nil;
  inherited;
end;

function TFloatStack.GetSize: integer;
begin
 result:=FTop+1;
end;

function TFloatStack.GetTop: double;
begin
  if not IsEmpty then
  result:=FItems[FTop];

end;

function TFloatStack.IsEmpty: boolean;
begin
  result:=Size=0;
end;

function TFloatStack.Pop: double;
begin
  if not IsEmpty then
  begin
    result:=GetTop;
    dec (FTop);
    if FTop+105<length(FItems) then
      SetLength(FItems,length(FItems)-100);
  end;
end;

procedure TFloatStack.Push(s: double);
begin
  inc(FTop);
  FItems[FTop]:=s;
  if FTop> length(FItems)-5 then
  SetLength(FItems,length(FItems)+100);
end;

end.
