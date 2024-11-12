unit UMyQueue;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TMyQueue = class
  public
    FItems: array of UTF8String;
    FFront: integer;
    FRear: integer;
    function GetFront: UTF8String;
    function GetRear: UTF8String;
    function GetSize: integer;
    constructor Create;
    destructor Destroy; override;
    procedure Enqueue(s: UTF8String);
    function Dequeue: UTF8String;
    function IsEmpty: boolean;
    property Front: UTF8String read GetFront;
    property Size: integer read GetSize;
    property Rear: UTF8String read GetRear;
  end;

implementation

{TQueue}

constructor TMyQueue.Create;
begin
  SetLength(FItems, 100);
  FFront := 0;
  FRear := -1;
end;

destructor TMyQueue.Destroy;
begin
  FItems := nil;
  inherited;
end;

function TMyQueue.GetSize: integer;
begin
  result := ((FRear - FFront) mod 100) + 1;
end;

function TMyQueue.GetFront: UTF8String;
begin
  if not IsEmpty then
    result := FItems[FFront];
end;

function TMyQueue.GetRear: UTF8String;
begin
  if not IsEmpty then
    result := FItems[FRear];
end;

function TMyQueue.IsEmpty: boolean;
begin
  result := Size = 0;
end;

function TMyQueue.Dequeue: UTF8String;
begin
  if not IsEmpty then
  begin
    result := FItems[FFront];
    inc(FFront);
  end;
end;

procedure TMyQueue.Enqueue(s: UTF8String);
begin
  if FRear < 99 then
  begin
    inc(FRear);
    FItems[FRear] := s;
  end;
end;

end.
