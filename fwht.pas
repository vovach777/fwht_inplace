(* port  https://www.musicdsp.org/en/latest/Analysis/18-fast-in-place-walsh-hadamard-transform.html *)
unit fwht;

interface

uses Generics.Collections;

interface

procedure FWHT(data: TList<Integer>);

implementation

procedure wht_bfly(data: TList<Integer>; a,b : integer); inline;
var
  tmp : integer;
begin
  tmp := data[a];
  data[a] := data[a] + data[b];
  data[b] := tmp     - data[b];
end;

function l2(x : cardinal) : integer; inline;
begin
  result := 0;
  while x > 0 do
  begin
    inc(result);
    x := x shr 1;
  end;
end;

procedure FWHT(data: TList<Integer>);
var
  log2,i,j,k : integer;
begin
  log2 := l2(data.Count)-1;
  for i := 0 to log2-1 do
  begin
     j := 0;
     while j < (1 shl log2) do
     begin
       for k := 0 to (1 shl i)-1 do
       begin
         wht_bfly(data, j+k, j+k + (1 shl i));
       end;
       inc(j,1 shl (i+1));
     end;
  end;
end;

end.
