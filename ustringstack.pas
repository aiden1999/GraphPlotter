unit UStringStack;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;
type
  TStringStack = class
  strict private
    FItems: array of UTF8string;
    FTop:integer;
    function GetTop:UTF8String; //inspect top item without popping
    function GetSize:integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Push(s:UTF8String);
    function Pop:UTF8String;
    function IsEmpty:boolean;
    property Top: UTF8String read GetTop;
    property Size: integer read GetSize;
  end;

implementation

constructor TStringStack.Create;
begin
  SetLength(FItems,100);
  FTop:=-1;
end;

destructor TStringStack.Destroy;
begin
  FItems:=nil;
  inherited;
end;

function TStringStack.GetSize: integer;
begin
 result:=FTop+1;
end;

function TStringStack.GetTop: UTF8String;
begin
  if not IsEmpty then
  result:=FItems[FTop];

end;

function TStringStack.IsEmpty: boolean;
begin
  result:=Size=0;
end;

function TStringStack.Pop: UTF8String;
begin
  if not IsEmpty then
  begin
    result:=GetTop;
    dec (FTop);
    if FTop+105<length(FItems) then
      SetLength(FItems,length(FItems)-100);
  end;
end;

procedure TStringStack.Push(s: UTF8String);
begin
  inc(FTop);
  FItems[FTop]:=s;
  if FTop> length(FItems)-5 then
  SetLength(FItems,length(FItems)+100);
end;

end.

