object MainForm: TMainForm
  Left = 299
  Top = 60
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'R2D2 - [Welt]'
  ClientHeight = 609
  ClientWidth = 405
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object State: TStatusBar
    Left = 0
    Top = 590
    Width = 405
    Height = 19
    Panels = <>
  end
  object boxSpielfeld: TGroupBox
    Left = 0
    Top = 0
    Width = 405
    Height = 409
    Align = alClient
    Caption = ' Spielfeld '
    TabOrder = 1
    object pbMain: TPaintBox
      Left = 2
      Top = 15
      Width = 382
      Height = 392
      Align = alClient
      OnMouseDown = pbMainMouseDown
      OnMouseMove = pbMainMouseMove
      OnMouseUp = pbMainMouseUp
      OnPaint = pbMainPaint
    end
    object pbBatterie: TPaintBox
      Left = 384
      Top = 15
      Width = 19
      Height = 392
      Align = alRight
    end
  end
  object Management: TTabbedNotebook
    Left = 0
    Top = 409
    Width = 405
    Height = 181
    Align = alBottom
    TabFont.Charset = DEFAULT_CHARSET
    TabFont.Color = clBtnText
    TabFont.Height = -11
    TabFont.Name = 'MS Sans Serif'
    TabFont.Style = []
    TabOrder = 2
    object TTabPage
      Left = 4
      Top = 24
      Caption = 'Roboter Management'
      object GroupBox3: TGroupBox
        Left = 0
        Top = 0
        Width = 125
        Height = 97
        Caption = ' Roboter Liste '
        TabOrder = 0
        object lbRobots: TListBox
          Left = 2
          Top = 15
          Width = 121
          Height = 80
          Align = alClient
          BorderStyle = bsNone
          ItemHeight = 13
          TabOrder = 0
          OnClick = lbRobotsClick
        end
      end
      object GroupBox4: TGroupBox
        Left = 128
        Top = 0
        Width = 265
        Height = 153
        Caption = ' Informationen '#252'ber den Aktiven Roboter '
        Enabled = False
        TabOrder = 1
        object Label6: TLabel
          Left = 8
          Top = 20
          Width = 39
          Height = 13
          Caption = 'Energie:'
        end
        object Label7: TLabel
          Left = 132
          Top = 20
          Width = 30
          Height = 13
          Caption = 'Farbe:'
        end
        object edEnergie: TEdit
          Left = 52
          Top = 16
          Width = 41
          Height = 21
          TabOrder = 0
        end
        object ColorBox1: TColorBox
          Left = 172
          Top = 16
          Width = 85
          Height = 22
          ItemHeight = 16
          TabOrder = 1
        end
      end
      object btnAddRobot: TButton
        Left = 4
        Top = 100
        Width = 113
        Height = 25
        Caption = '&Hinzuf'#252'gen'
        TabOrder = 2
        OnClick = btnAddRobotClick
      end
      object btnDelRobot: TButton
        Left = 4
        Top = 128
        Width = 113
        Height = 25
        Caption = '&L'#246'schen'
        TabOrder = 3
        OnClick = btnDelRobotClick
      end
    end
    object TTabPage
      Left = 4
      Top = 24
      Caption = 'Karten Management'
      object btnRandomMap: TButton
        Left = 268
        Top = 35
        Width = 125
        Height = 25
        Caption = 'Zufalls Karte'
        TabOrder = 0
        OnClick = btnRandomMapClick
      end
      object boxEinheiten: TGroupBox
        Left = 0
        Top = 0
        Width = 125
        Height = 149
        Caption = ' Objektliste '
        TabOrder = 1
        object lbEinheiten: TListBox
          Left = 2
          Top = 15
          Width = 121
          Height = 132
          Align = alClient
          BorderStyle = bsNone
          ItemHeight = 13
          TabOrder = 0
        end
      end
      object btnEmptyMap: TButton
        Left = 268
        Top = 4
        Width = 125
        Height = 25
        Caption = 'Leeres Spielfeld'
        TabOrder = 2
        OnClick = btnEmptyMapClick
      end
      object GroupBox1: TGroupBox
        Left = 132
        Top = 0
        Width = 125
        Height = 149
        Caption = ' Spielfeld Settings '
        TabOrder = 3
        object Label1: TLabel
          Left = 4
          Top = 40
          Width = 30
          Height = 13
          Caption = 'Breite:'
        end
        object Label2: TLabel
          Left = 4
          Top = 68
          Width = 29
          Height = 13
          Caption = 'H'#246'he:'
        end
        object Label3: TLabel
          Left = 88
          Top = 40
          Width = 29
          Height = 13
          Caption = 'Felder'
        end
        object Label4: TLabel
          Left = 88
          Top = 68
          Width = 29
          Height = 13
          Caption = 'Felder'
        end
        object Label5: TLabel
          Left = 6
          Top = 19
          Width = 47
          Height = 13
          Align = alCustom
          Caption = 'G r '#246' '#223' e :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsUnderline]
          ParentFont = False
        end
        object seHeight: TSpinEdit
          Left = 44
          Top = 64
          Width = 41
          Height = 22
          MaxValue = 16
          MinValue = 8
          TabOrder = 0
          Value = 13
        end
        object seWidth: TSpinEdit
          Left = 44
          Top = 36
          Width = 41
          Height = 22
          MaxValue = 25
          MinValue = 8
          TabOrder = 1
          Value = 13
        end
      end
      object btnFillMapSelected: TButton
        Left = 268
        Top = 67
        Width = 125
        Height = 25
        Caption = 'Kate mit Selection F'#252'llen'
        TabOrder = 4
        OnClick = btnFillMapSelectedClick
      end
    end
    object TTabPage
      Left = 4
      Top = 24
      Caption = 'Allgemeine Verwaltung'
      object GroupBox2: TGroupBox
        Left = 0
        Top = 0
        Width = 125
        Height = 149
        Caption = ' Sicherungen '
        TabOrder = 0
        object btnSaveGame: TButton
          Left = 4
          Top = 80
          Width = 113
          Height = 29
          Caption = 'Karte: Speichern'
          TabOrder = 0
          OnClick = btnSaveGameClick
        end
        object btnLoadGame: TButton
          Left = 4
          Top = 116
          Width = 113
          Height = 25
          Caption = 'Karte: Laden'
          TabOrder = 1
          OnClick = btnLoadGameClick
        end
        object Button1: TButton
          Left = 8
          Top = 16
          Width = 109
          Height = 25
          Caption = 'Alles: Speichern'
          Enabled = False
          TabOrder = 2
        end
        object Button2: TButton
          Left = 8
          Top = 48
          Width = 109
          Height = 25
          Caption = 'Alles: Laden'
          Enabled = False
          TabOrder = 3
        end
      end
      object GroupBox5: TGroupBox
        Left = 128
        Top = 0
        Width = 269
        Height = 149
        Caption = ' Informationen '#252'ber das Spiel '
        TabOrder = 1
      end
    end
  end
end
