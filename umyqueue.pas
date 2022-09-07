unit UMyQueue;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TMyQueue = class
  public
    FItems: array of string;
    FFront: integer;
    FRear: integer;
    function GetFront: string;
    function GetRear: string;
    function GetSize: integer;
    constructor Create;
    destructor Destroy; override;
    procedure Enqueue(s: string);
    function Dequeue: string;
    function IsEmpty: boolean;
    property Front: string read GetFront;
    property Size: integer read GetSize;
    property Rear: string read GetRear;
  end;

implementation

{TQueue}

constructor TMyQueue.Create;
begin
  SetLength(FItems, 5);
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
  result := ((FRear - FFront) mod 5) + 1;
end;

function TMyQueue.GetFront: String;
begin
  if not IsEmpty then
    result := FItems[FFront];
end;

function TMyQueue.GetRear: String;
begin
  if not IsEmpty then
    result := FItems[FRear];
end;

function TMyQueue.IsEmpty: boolean;
begin
  result := Size = 0;
end;

function TMyQueue.Dequeue: string;
begin
  if not IsEmpty then
  begin
    result := FItems[FFront];
    inc(FFront);
  end;
end;

procedure TMyQueue.Enqueue(s: string);
begin
  if FRear < 4 then
  begin
    inc(FRear);
    FItems[FRear] := s;
  end;
end;

end.
