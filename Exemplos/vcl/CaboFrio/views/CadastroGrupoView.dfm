object CadastroGrupoView: TCadastroGrupoView
  Left = 0
  Top = 0
  Caption = 'Cadastro Produtos'
  ClientHeight = 246
  ClientWidth = 473
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 0
    Top = 41
    Width = 473
    Height = 205
    Align = alClient
    BorderStyle = bsNone
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 473
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 816
    object Button1: TButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 75
      Height = 35
      Align = alLeft
      Caption = 'Abrir'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      AlignWithMargins = True
      Left = 395
      Top = 3
      Width = 75
      Height = 35
      Align = alRight
      Caption = 'Enviar'
      TabOrder = 1
      OnClick = Button2Click
      ExplicitLeft = 738
    end
    object Button3: TButton
      AlignWithMargins = True
      Left = 84
      Top = 3
      Width = 75
      Height = 35
      Align = alLeft
      Caption = 'Fechar'
      TabOrder = 2
      OnClick = Button3Click
    end
  end
  object ODataDatasetBuilder1: TODataDatasetBuilder
    Dataset = ODataFDMemTable1
    Params = <>
    BaseURL = 'http://mvcbr.ddns.com.br:8080'
    ServicePrefix = '/OData'
    Service = '/OData.svc'
    ResourceName = 'cliente'
    Resource = <
      item
        Resource = 'cliente'
        ResourceParams = <>
      end>
    TopRows = 0
    SkipRows = 0
    Count = False
    Left = 304
    Top = 144
  end
  object DataSource1: TDataSource
    DataSet = ODataFDMemTable1
    Left = 160
    Top = 64
  end
  object ODataFDMemTable1: TODataFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 200
    Top = 120
  end
end
