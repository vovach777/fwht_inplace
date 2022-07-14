# Fast in-place Walsh-Hadamard Transform
- Author or source: Timo H Tossavainen
- Type: wavelet transform
- Created: 2002-01-17 01:54:52

IIRC, They're also called walsh-hadamard transforms.
Basically like Fourier, but the basis functions are squarewaves with different sequencies.
I did this for a transform data compression study a while back.
Here's some code to do a walsh hadamard transform on long ints in-place (you need to
divide by n to get transform) the order is bit-reversed at output, IIRC.
The inverse transform is the same as the forward transform (expects bit-reversed input).
i.e. x = 1/n * FWHT(FWHT(x)) (x is a vector)

## usage Sample 
```
function splitInt(const s : string) : TArray<Integer>; forward;

procedure TForm2.Memo1Change(Sender: TObject);
var
  lst : TFHWList;
  i : integer;
  s : string;
begin
  lst := TFHWList.create;
  lst.AddRange( splitInt( memo1.Text ));
  lst.transform;
  s := '';
  for i := 0 to lst.count-1 do
  begin
    s := s +  Format('%6d',[ lst.sequency_ordering[i]] );
    if (i+1) mod round( Sqrt( lst.count ) ) = 0 then
       s := s + #13#10;
// cut filter
//    if i > lst.Count div 2 then
//       lst.sequency_ordering[i] := 0;
  end;
  lst.inverse;

  s := s + #13#10+'--------------------------'#13#10;

  for i := 0 to lst.count-1 do
  begin
    s := s +  Format('%6d',[ lst[i]] );
    if (i+1) mod round( Sqrt( lst.count ) ) = 0 then
       s := s + #13#10;
  end;
  memo2.Text := s;

  lst.free;
end;
```
<details><summary>function splitInt(const s : string) : TArray<Integer>;</summary>
<p>

```
function clip_s(s : char) : char; inline;
  begin
    if (s < '0') or (s > '9') then
      exit( ' ' )
    else
       exit(s);
  end;

function splitInt(const s : string) : TArray<Integer>;
var
  I,L,K,R : integer;

begin
   I := 1;
   R := 0;
   L := Length(s);
   SetLength(result,0);
   while i <= L do
   begin
     while (i <= L) and (clip_s(S[i]) = ' ')  do inc(I);
     K := i;
     while (i <= L) and (clip_s(S[i]) <> ' ') do inc(I);
     if K <> I then
     begin
       if R = Length(Result) then
         setLength(result,R+16);

       result[R] := StrToInt( copy(S,K,I-K) );
       if (K>1) and (S[K-1] = '-') then
            result[R] := -result[R];
       inc(R);
     end;
   end;
  setLength(result,R);
end;
```

</p>
</details>
