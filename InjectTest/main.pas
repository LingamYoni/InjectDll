(*
 * Copyright (C) 2023 Marina Petrichenko
 * 
 * marina@btframework.com  
 *   https://www.facebook.com/marina.petrichenko.1  
 *   https://www.btframework.com
 * 
 * It is free for non-commercial and/or education use only.
 *   
 *)

unit main;

interface

uses
  Vcl.Forms, System.Classes, Vcl.Controls, Vcl.StdCtrls;

type
  TfmMain = class(TForm)
    btGetVersion: TButton;
    procedure btGetVersionClick(Sender: TObject);
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

uses
  Windows, Dialogs, SysUtils;

procedure TfmMain.btGetVersionClick(Sender: TObject);
var
  Ver: TOSVersionInfo;
begin
  ZeroMemory(@Ver, SizeOf(TOSVersionInfo));
  Ver.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);

  if GetVersionEx(Ver) then begin
    ShowMessage(IntToStr(Ver.dwMajorVersion) + #13#10 +
      IntToStr(Ver.dwMinorVersion));
  end;
end;

end.
