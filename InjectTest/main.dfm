object fmMain: TfmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'DLL Inject Test'
  ClientHeight = 92
  ClientWidth = 152
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object btGetVersion: TButton
    Left = 40
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Get Version'
    TabOrder = 0
    OnClick = btGetVersionClick
  end
end
