object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Export / Import CSV files with Firebird database'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnActivate = FormActivate
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 185
    Align = alTop
    Color = clGradientActiveCaption
    ParentBackground = False
    TabOrder = 0
    ExplicitWidth = 640
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 192
      Height = 21
      Caption = 'Select Firebird Database :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 8
      Top = 85
      Width = 107
      Height = 15
      Caption = 'Selected database :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 8
      Top = 135
      Width = 72
      Height = 15
      Caption = 'Select table :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 284
      Top = 35
      Width = 148
      Height = 15
      Caption = 'Enter Firebird server port :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label8: TLabel
      Left = 531
      Top = 35
      Width = 71
      Height = 15
      Caption = 'Default : 3050'
    end
    object btnSelecBD: TButton
      Left = 8
      Top = 48
      Width = 145
      Height = 25
      Caption = 'Browse Firebird database'
      TabOrder = 0
      OnClick = btnSelecBDClick
    end
    object edtBD: TEdit
      Left = 8
      Top = 106
      Width = 609
      Height = 23
      ReadOnly = True
      TabOrder = 1
    end
    object cbbTabela: TComboBox
      Left = 8
      Top = 156
      Width = 154
      Height = 23
      Style = csDropDownList
      TabOrder = 2
      OnExit = cbbTabelaExit
    end
    object edtPort: TEdit
      Left = 460
      Top = 32
      Width = 65
      Height = 23
      Alignment = taCenter
      MaxLength = 4
      NumbersOnly = True
      TabOrder = 3
      Text = '3050'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 250
    Width = 640
    Height = 167
    Color = 10930928
    ParentBackground = False
    TabOrder = 1
    object Label5: TLabel
      Left = 8
      Top = 7
      Width = 323
      Height = 21
      Caption = 'Import CSV file into selected Firebird table'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 8
      Top = 72
      Width = 101
      Height = 15
      Caption = 'Selected CSV file :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnSelectCSV: TButton
      Left = 8
      Top = 34
      Width = 137
      Height = 25
      Caption = 'Browse CSV file'
      TabOrder = 0
      OnClick = btnSelectCSVClick
    end
    object edtCSV: TEdit
      Left = 8
      Top = 90
      Width = 609
      Height = 23
      ReadOnly = True
      TabOrder = 1
    end
    object ProgressBar1: TProgressBar
      Left = 0
      Top = 134
      Width = 624
      Height = 28
      TabOrder = 2
    end
    object btnImport: TButton
      Left = 272
      Top = 34
      Width = 75
      Height = 25
      Caption = 'Import'
      TabOrder = 3
      OnClick = btnImportClick
    end
  end
  object Panel3: TPanel
    Left = -4
    Top = 185
    Width = 644
    Height = 64
    Color = clMoneyGreen
    ParentBackground = False
    TabOrder = 2
    object Label4: TLabel
      Left = 8
      Top = 7
      Width = 306
      Height = 21
      Caption = 'Export selected Firebird table to CSV file'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnExport: TButton
      Left = 276
      Top = 34
      Width = 75
      Height = 25
      Caption = 'Export'
      TabOrder = 0
      OnClick = btnExportClick
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 418
    Width = 624
    Height = 23
    Align = alBottom
    Caption = 'Developed in Delphi 12.1, FireDAC components, version 0.1 (2025)'
    TabOrder = 3
  end
  object OpenDialog1: TOpenDialog
    Left = 416
    Top = 136
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'DriverID=FB'
      'User_Name=sysdba'
      'Password=masterkey')
    Left = 520
    Top = 136
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 568
    Top = 272
  end
  object FDTable1: TFDTable
    Connection = FDConnection1
    Left = 568
    Top = 192
  end
end
