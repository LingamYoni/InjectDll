object fmMain: TfmMain
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'DLL Injector'
  ClientHeight = 309
  ClientWidth = 470
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
  object laProcessName: TLabel
    Left = 127
    Top = 20
    Width = 70
    Height = 13
    Caption = 'Process name:'
  end
  object btEnumProcesses: TButton
    Left = 8
    Top = 8
    Width = 113
    Height = 25
    Caption = 'Enum processes'
    TabOrder = 0
    OnClick = btEnumProcessesClick
  end
  object lvProcesses: TListView
    Left = 8
    Top = 39
    Width = 449
    Height = 202
    Columns = <
      item
        Caption = 'Process ID'
        Width = 100
      end
      item
        Caption = 'Name'
        Width = 300
      end>
    ColumnClick = False
    GridLines = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
  end
  object btInject: TButton
    Left = 8
    Top = 247
    Width = 75
    Height = 25
    Caption = 'Inject'
    TabOrder = 2
    OnClick = btInjectClick
  end
  object edProcessName: TEdit
    Left = 203
    Top = 12
    Width = 173
    Height = 21
    TabOrder = 3
    Text = 'InjectTest.exe'
  end
  object btFind: TButton
    Left = 382
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Find'
    TabOrder = 4
    OnClick = btFindClick
  end
end
