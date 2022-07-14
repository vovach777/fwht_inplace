(* port  https://www.musicdsp.org/en/latest/Analysis/18-fast-in-place-walsh-hadamard-transform.html *)
unit fwht;

interface

uses Types, Generics.Collections;

type
 TFHWList = class( TList<Integer> )
 private
    function Getsequency_ordering(Index: Integer): Integer;
    procedure Setsequency_ordering(Index: Integer; const Value: Integer);
 public
    procedure transform;
    procedure inverse;
    function DoPermutationMap(Index: Integer): Integer;
    property sequency_ordering[Index: Integer]: Integer read Getsequency_ordering
        write Setsequency_ordering;
 end;

implementation

threadvar
  g_permutation_maps : TArray<TArray<Integer>>;


procedure wht_bfly(data: TList<Integer>; a,b : integer); inline;
var
  tmp : integer;
begin
  tmp := data[a];
  data[a] := data[a] + data[b];
  data[b] := tmp     - data[b];
end;


{$IFDEF PUREPASCAL}
function ilog2(x : cardinal) : cardinal;
begin
  result := 0;
  if x = 0 then
     exit;
  repeat
    inc(result);
    x := x shr 1;
  until x = 0;
  result := result-1;
end;

{$ELSE}

function ilog2(x : cardinal) : cardinal; assembler;
asm
  bsr eax,x
  jnz  @ret
  xor eax,eax
@ret:
end;

{$ENDIF}

procedure bitrev(t : integer; var c : TArray<Integer>);
var
  n,L,q,j : integer;
begin
  n := 1 shl t;
  L := 1;
  c[0] := 0;
  for q := 0 to t-1 do
  begin
     n := n div 2;
     for j := 0 to L-1 do
       c[L+j] := c[j] + n;
     L := L * 2;
  end;
end;

procedure sequency_permutation(order: integer; var p : TArray<Integer>);
var
  n,i : integer;
  tmp : TArray<Integer>;
begin
  n := 1 shl order;
  SetLength(tmp,n);
  bitrev(order, tmp);
  setLength(p, n);
  for i:=0 to n-1 do
  begin
    p[i] := tmp[ (i shr 1) xor i ];
  end;
end;

function TFHWList.Getsequency_ordering(Index: Integer): Integer;
begin
  Result := Items[ DoPermutationMap(index) ];
end;

procedure TFHWList.inverse;
var
  i : integer;
begin
   transform;
   for i := 0 to Count-1 do
      Items[i] := Items[i] div count;
end;

function TFHWList.DoPermutationMap(Index: Integer): Integer;
var
  log2 : integer;
begin
  if Index < 0 then
    Index := 0
  else
  if Index >= count then
     Index := count-1;

  log2 := ilog2(count);

  if log2 > length( g_permutation_maps ) then
     SetLength( g_permutation_maps, log2+1 );

  if length( g_permutation_maps[ log2 ] ) = 0 then
  begin
      sequency_permutation( log2, g_permutation_maps[ log2 ] );
  end;
  result := g_permutation_maps[ log2 ][Index];
end;

procedure TFHWList.Setsequency_ordering(Index: Integer; const Value: Integer);
begin
  Items[ DoPermutationMap(index) ] := value;
end;

procedure TFHWList.transform;
var
  log2,i,j,k,max_k : integer;
begin
  if Count = 0 then
    exit;
  log2 := ilog2(Count);
  count := 1 shl log2; //adject count
  for i := 0 to log2-1 do
  begin
     j := 0;
     while j < count do
     begin
       max_k := (1 shl i);
       for k := 0 to max_k-1 do
       begin
         wht_bfly(self, j+k, j+k+max_k);
       end;
       inc(j,1 shl (i+1));
     end;
  end;
end;

end.
