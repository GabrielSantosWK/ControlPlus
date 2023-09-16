unit Helper.Edit;

interface

uses FMX.Edit,SysUtils;

type
  TEditHelper = class helper for TCustomEdit
    function ToCurrency: Currency;
  end;

implementation

{ TScrollHelper }

{ TEditHelper }

function TEditHelper.ToCurrency: Currency;
begin
  var LValueStr := String(Self.Text).Replace('.','',[rfReplaceAll]);
  //.Replace(',','.',[rfReplaceAll]);
  Result := StrToCurr(LValueStr);
end;

end.
