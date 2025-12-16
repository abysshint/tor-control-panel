object Tcp: TTcp
  Left = 300
  Top = 191
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1055#1072#1085#1077#1083#1100' '#1091#1087#1088#1072#1074#1083#1077#1085#1080#1103' Tor'
  ClientHeight = 604
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poDesigned
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  OnResize = FormResize
  TextHeight = 13
  object paStatus: TPanel
    Left = 3
    Top = 92
    Width = 793
    Height = 508
    BevelInner = bvLowered
    Color = clWindow
    DoubleBuffered = True
    ParentBackground = False
    ParentDoubleBuffered = False
    ShowCaption = False
    TabOrder = 3
    Visible = False
    object gbSession: TGroupBox
      Left = 12
      Top = 126
      Width = 161
      Height = 57
      Caption = #1042#1089#1077#1075#1086' '#1079#1072' '#1089#1077#1089#1089#1080#1102
      ParentBackground = False
      TabOrder = 2
      object lbSessionDLCaption: TLabel
        Left = 42
        Top = 16
        Width = 53
        Height = 13
        Alignment = taRightJustify
        Caption = #1055#1086#1083#1091#1095#1077#1085#1086':'
        Transparent = True
      end
      object lbSessionULCaption: TLabel
        Left = 29
        Top = 32
        Width = 66
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = #1054#1090#1087#1088#1072#1074#1083#1077#1085#1086':'
        Transparent = True
      end
      object lbSessionDL: TLabel
        Left = 98
        Top = 16
        Width = 25
        Height = 13
        Caption = '0,0 '#1041
        Transparent = True
      end
      object lbSessionUL: TLabel
        Left = 98
        Top = 32
        Width = 25
        Height = 13
        Caption = '0,0 '#1041
        Transparent = True
      end
    end
    object gbServerInfo: TGroupBox
      Left = 12
      Top = 320
      Width = 770
      Height = 177
      Caption = #1057#1077#1088#1074#1077#1088
      ParentBackground = False
      TabOrder = 6
      Visible = False
      object lbServerExternalIpCaption: TLabel
        Left = 19
        Top = 16
        Width = 81
        Height = 13
        Alignment = taRightJustify
        Caption = #1042#1085#1077#1096#1085#1080#1081' '#1072#1076#1088#1077#1089':'
        Transparent = True
      end
      object lbFingerprintCaption: TLabel
        Left = 14
        Top = 33
        Width = 86
        Height = 13
        Alignment = taRightJustify
        Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088':'
        Transparent = True
      end
      object lbServerExternalIp: TLabel
        Left = 103
        Top = 17
        Width = 71
        Height = 13
        Caption = #1053#1077' '#1086#1087#1088#1077#1076#1077#1083#1105#1085
        PopupMenu = mnServerInfo
        Transparent = True
        OnMouseMove = lbServerInfoMouseMove
      end
      object lbFingerprint: TLabel
        Left = 103
        Top = 33
        Width = 71
        Height = 13
        Caption = #1053#1077' '#1086#1087#1088#1077#1076#1077#1083#1105#1085
        PopupMenu = mnServerInfo
        Transparent = True
        OnMouseMove = lbServerInfoMouseMove
      end
      object lbBridgeCaption: TLabel
        Left = 33
        Top = 49
        Width = 67
        Height = 13
        Alignment = taRightJustify
        Caption = #1040#1076#1088#1077#1089' '#1084#1086#1089#1090#1072':'
        Transparent = True
      end
      object lbBridge: TLabel
        Left = 103
        Top = 49
        Width = 71
        Height = 13
        Caption = #1053#1077' '#1086#1087#1088#1077#1076#1077#1083#1105#1085
        PopupMenu = mnServerInfo
        Transparent = True
        OnMouseMove = lbServerInfoMouseMove
      end
    end
    object gbTraffic: TGroupBox
      Left = 12
      Top = 6
      Width = 161
      Height = 57
      Caption = #1057#1082#1086#1088#1086#1089#1090#1100
      ParentBackground = False
      TabOrder = 0
      object lbDownloadSpeedCaption: TLabel
        Left = 45
        Top = 16
        Width = 50
        Height = 13
        Alignment = taRightJustify
        Caption = #1047#1072#1075#1088#1091#1079#1082#1072':'
        Transparent = True
      end
      object lbUploadSpeedCaption: TLabel
        Left = 41
        Top = 32
        Width = 54
        Height = 13
        Alignment = taRightJustify
        Caption = #1054#1090#1087#1088#1072#1074#1082#1072':'
        Transparent = True
      end
      object lbDLSpeed: TLabel
        Left = 98
        Top = 16
        Width = 34
        Height = 13
        Caption = '0,0 '#1041'/c'
        Transparent = True
      end
      object lbULSpeed: TLabel
        Left = 98
        Top = 32
        Width = 34
        Height = 13
        Caption = '0,0 '#1041'/c'
        Transparent = True
      end
    end
    object gbInfo: TGroupBox
      Left = 12
      Top = 247
      Width = 770
      Height = 70
      Caption = #1057#1074#1077#1076#1077#1085#1080#1103
      ParentBackground = False
      TabOrder = 5
      object lbClientVersionCaption: TLabel
        Left = 16
        Top = 16
        Width = 84
        Height = 13
        Alignment = taRightJustify
        Caption = #1042#1077#1088#1089#1080#1103' '#1082#1083#1080#1077#1085#1090#1072':'
        Transparent = True
      end
      object lbClientVersion: TLabel
        Left = 103
        Top = 16
        Width = 77
        Height = 13
        Cursor = crHandPoint
        Caption = #1053#1077' '#1086#1087#1088#1077#1076#1077#1083#1077#1085#1072
        ParentShowHint = False
        ShowHint = True
        Transparent = True
        OnClick = lbClientVersionClick
      end
      object lbUserDirCaption: TLabel
        Left = 51
        Top = 32
        Width = 49
        Height = 13
        Alignment = taRightJustify
        Caption = #1055#1088#1086#1092#1080#1083#1100':'
        Transparent = True
      end
      object lbUserDir: TLabel
        Left = 103
        Top = 32
        Width = 73
        Height = 13
        Cursor = crHandPoint
        Caption = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
        ParentShowHint = False
        ShowHint = True
        Transparent = True
        OnClick = lbUserDirClick
      end
      object lbStatusSocksAddrCaption: TLabel
        Left = 331
        Top = 16
        Width = 76
        Height = 13
        Alignment = taRightJustify
        Caption = 'SOCKS-'#1087#1088#1086#1082#1089#1080':'
        Transparent = True
      end
      object lbStatusSocksAddr: TLabel
        Left = 410
        Top = 16
        Width = 76
        Height = 13
        Caption = '127.0.0.1:9050'
        ParentShowHint = False
        ShowHint = True
        Transparent = True
        OnClick = lbStatusProxyAddrClick
        OnMouseMove = lbStatusProxyAddrMouseMove
      end
      object lbStatusScannerCaption: TLabel
        Left = 322
        Top = 48
        Width = 85
        Height = 13
        Alignment = taRightJustify
        Caption = #1057#1077#1090#1077#1074#1086#1081' '#1089#1082#1072#1085#1077#1088':'
        Transparent = True
      end
      object lbStatusScanner: TLabel
        Left = 410
        Top = 48
        Width = 119
        Height = 13
        Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080#1081' '#1088#1077#1078#1080#1084
        Transparent = True
      end
      object lbStatusHttpAddrCaption: TLabel
        Left = 339
        Top = 32
        Width = 68
        Height = 13
        Alignment = taRightJustify
        Caption = 'HTTP-'#1087#1088#1086#1082#1089#1080':'
        Transparent = True
      end
      object lbStatusHttpAddr: TLabel
        Left = 410
        Top = 32
        Width = 59
        Height = 13
        Caption = #1042#1099#1082#1083#1102#1095#1077#1085#1086
        ParentShowHint = False
        ShowHint = True
        Transparent = True
        OnClick = lbStatusProxyAddrClick
        OnMouseMove = lbStatusProxyAddrMouseMove
      end
      object lbStatusFilterModeCaption: TLabel
        Left = 17
        Top = 48
        Width = 83
        Height = 13
        Alignment = taRightJustify
        Caption = #1056#1077#1078#1080#1084' '#1092#1080#1083#1100#1090#1088#1072':'
        Transparent = True
      end
      object lbStatusFilterMode: TLabel
        Left = 103
        Top = 48
        Width = 98
        Height = 13
        Cursor = crHandPoint
        Caption = #1042#1099#1073#1088#1072#1085#1085#1099#1077' '#1089#1090#1088#1072#1085#1099
        ParentShowHint = False
        ShowHint = True
        Transparent = True
        OnClick = lbStatusFilterModeClick
      end
    end
    object gbSpeedGraph: TGroupBox
      Left = 182
      Top = 6
      Width = 600
      Height = 238
      Caption = #1043#1088#1072#1092#1080#1082' '#1089#1082#1086#1088#1086#1089#1090#1080
      ParentBackground = False
      TabOrder = 4
      object pbTraffic: TPaintBox
        Left = 2
        Top = 15
        Width = 596
        Height = 221
        Align = alClient
        PopupMenu = mnTraffic
        OnPaint = pbTrafficPaint
      end
    end
    object gbMaxTraffic: TGroupBox
      Left = 12
      Top = 66
      Width = 161
      Height = 57
      Caption = #1052#1072#1082#1089#1080#1084#1091#1084
      ParentBackground = False
      TabOrder = 1
      object lbMaxDLSpeedCaption: TLabel
        Left = 45
        Top = 16
        Width = 50
        Height = 13
        Alignment = taRightJustify
        Caption = #1047#1072#1075#1088#1091#1079#1082#1072':'
        Transparent = True
      end
      object lbMaxULSpeedCaption: TLabel
        Left = 41
        Top = 32
        Width = 54
        Height = 13
        Alignment = taRightJustify
        Caption = #1054#1090#1087#1088#1072#1074#1082#1072':'
        Transparent = True
      end
      object lbMaxDLSpeed: TLabel
        Left = 98
        Top = 16
        Width = 34
        Height = 13
        Caption = '0,0 '#1041'/c'
        Transparent = True
      end
      object lbMaxULSpeed: TLabel
        Left = 98
        Top = 32
        Width = 34
        Height = 13
        Caption = '0,0 '#1041'/c'
        Transparent = True
      end
    end
    object gbTotal: TGroupBox
      Left = 12
      Top = 187
      Width = 161
      Height = 57
      Caption = #1042#1089#1077#1075#1086' '#1079#1072' '#1074#1089#1105' '#1074#1088#1077#1084#1103
      ParentBackground = False
      TabOrder = 3
      object lbTotalDLCaption: TLabel
        Left = 42
        Top = 16
        Width = 53
        Height = 13
        Alignment = taRightJustify
        Caption = #1055#1086#1083#1091#1095#1077#1085#1086':'
        Transparent = True
      end
      object lbTotalULCaption: TLabel
        Left = 29
        Top = 32
        Width = 66
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = #1054#1090#1087#1088#1072#1074#1083#1077#1085#1086':'
        Transparent = True
      end
      object lbTotalDL: TLabel
        Left = 98
        Top = 16
        Width = 25
        Height = 13
        Caption = '0,0 '#1041
        Transparent = True
      end
      object lbTotalUL: TLabel
        Left = 98
        Top = 32
        Width = 25
        Height = 13
        Caption = '0,0 '#1041
        Transparent = True
      end
    end
  end
  object paButtons: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 90
    BevelOuter = bvNone
    DoubleBuffered = True
    ParentBackground = False
    ParentDoubleBuffered = False
    TabOrder = 0
    OnDblClick = paButtonsDblClick
    object sbShowLog: TSpeedButton
      Left = 245
      Top = 53
      Width = 119
      Height = 35
      GroupIndex = 1
      Caption = #1046#1091#1088#1085#1072#1083
      ImageIndex = 5
      Images = lsButtons
      Spacing = 8
      OnClick = sbShowLogClick
      OnMouseDown = sbShowLogMouseDown
    end
    object sbShowOptions: TSpeedButton
      Left = 124
      Top = 53
      Width = 119
      Height = 35
      GroupIndex = 1
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      ImageIndex = 4
      Images = lsButtons
      Spacing = 6
      OnClick = sbShowOptionsClick
      OnMouseDown = sbShowOptionsMouseDown
    end
    object sbShowStatus: TSpeedButton
      Left = 366
      Top = 53
      Width = 119
      Height = 35
      GroupIndex = 1
      Caption = #1057#1090#1072#1090#1091#1089
      ImageIndex = 7
      Images = lsButtons
      Spacing = 8
      OnClick = sbShowStatusClick
    end
    object imExitFlag: TImage
      Left = 183
      Top = 32
      Width = 20
      Height = 13
      ParentShowHint = False
      ShowHint = True
      Stretch = True
      Visible = False
    end
    object lbExitCountryCaption: TLabel
      Left = 139
      Top = 31
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Caption = #1057#1090#1088#1072#1085#1072':'
      Transparent = True
    end
    object lbExitIpCaption: TLabel
      Left = 133
      Top = 12
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = 'IP '#1072#1076#1088#1077#1089':'
      Transparent = True
    end
    object lbExitIp: TLabel
      Left = 182
      Top = 12
      Width = 58
      Height = 13
      Caption = #1053#1077' '#1087#1086#1083#1091#1095#1077#1085
      PopupMenu = mnCircuitInfo
      Transparent = True
      OnMouseDown = lbExitIpMouseDown
      OnMouseMove = lbExitMouseMove
    end
    object lbExitCountry: TLabel
      Left = 182
      Top = 31
      Width = 77
      Height = 13
      Caption = #1053#1077' '#1086#1087#1088#1077#1076#1077#1083#1077#1085#1072
      ParentShowHint = False
      PopupMenu = mnCircuitInfo
      ShowHint = True
      Transparent = True
      OnDblClick = lbExitCountryDblClick
      OnMouseMove = lbExitMouseMove
    end
    object sbShowCircuits: TSpeedButton
      Left = 487
      Top = 53
      Width = 119
      Height = 35
      GroupIndex = 1
      Caption = #1062#1077#1087#1086#1095#1082#1080
      ImageIndex = 8
      Images = lsButtons
      Spacing = 8
      OnClick = sbShowCircuitsClick
      OnMouseDown = sbShowCircuitsMouseDown
    end
    object sbShowRouters: TSpeedButton
      Left = 608
      Top = 53
      Width = 119
      Height = 35
      GroupIndex = 1
      Caption = #1056#1086#1091#1090#1077#1088#1099
      ImageIndex = 6
      Images = lsButtons
      Spacing = 8
      OnClick = sbShowRoutersClick
      OnMouseDown = sbShowRoutersMouseDown
    end
    object sbDecreaseForm: TSpeedButton
      Left = 764
      Top = 53
      Width = 33
      Height = 35
      ImageIndex = 9
      Images = lsButtons
      ParentShowHint = False
      ShowHint = True
      OnClick = sbDecreaseFormClick
    end
    object lbScanType: TLabel
      Left = 617
      Top = 11
      Width = 181
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1076#1086#1089#1090#1091#1087#1085#1086#1089#1090#1080' '#1082#1072#1090#1072#1083#1086#1075#1086#1074'..'
      Transparent = True
      Visible = False
    end
    object lbScanProgress: TLabel
      Left = 627
      Top = 26
      Width = 46
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1088#1086#1075#1088#1077#1089#1089
      Transparent = True
      Visible = False
    end
    object sbStayOnTop: TSpeedButton
      Left = 729
      Top = 53
      Width = 33
      Height = 35
      AllowAllUp = True
      GroupIndex = 2
      ImageIndex = 10
      Images = lsButtons
      ParentShowHint = False
      ShowHint = True
      OnClick = sbStayOnTopClick
    end
    object btnChangeCircuit: TButton
      Left = 3
      Top = 3
      Width = 119
      Height = 48
      Caption = #1057#1084#1077#1085#1080#1090#1100' '#1094#1077#1087#1086#1095#1082#1091
      DoubleBuffered = False
      DropDownMenu = mnChangeCircuit
      ImageIndex = 3
      ImageMargins.Left = 5
      Images = lsButtons
      ParentDoubleBuffered = False
      Style = bsSplitButton
      TabOrder = 1
      WordWrap = True
      OnClick = btnChangeCircuitClick
    end
    object btnSwitchTor: TButton
      Left = 3
      Top = 53
      Width = 119
      Height = 35
      Caption = #1057#1090#1072#1088#1090
      DoubleBuffered = False
      ImageIndex = 0
      ImageMargins.Left = 8
      ImageMargins.Right = -8
      Images = lsButtons
      ParentDoubleBuffered = False
      TabOrder = 0
      OnClick = btnSwitchTorClick
    end
    object pbScanProgress: TProgressBar
      Left = 676
      Top = 27
      Width = 120
      Height = 13
      Cursor = crHandPoint
      ParentShowHint = False
      Step = 1
      ShowHint = True
      TabOrder = 2
      Visible = False
      OnMouseDown = pbScanProgressMouseDown
    end
  end
  object paLog: TPanel
    Left = 3
    Top = 92
    Width = 793
    Height = 508
    BevelInner = bvLowered
    Color = clWindow
    DoubleBuffered = True
    ParentBackground = False
    ParentDoubleBuffered = False
    ShowCaption = False
    TabOrder = 2
    Visible = False
    object sbAutoScroll: TSpeedButton
      Left = 4
      Top = 482
      Width = 24
      Height = 23
      AllowAllUp = True
      GroupIndex = 1
      Down = True
      ImageIndex = 23
      Images = lsMain
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnClick = sbAutoScrollClick
    end
    object sbWordWrap: TSpeedButton
      Left = 30
      Top = 482
      Width = 24
      Height = 23
      AllowAllUp = True
      GroupIndex = 2
      ImageIndex = 22
      Images = lsMain
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnClick = sbWordWrapClick
    end
    object sbUseLinesLimit: TSpeedButton
      Left = 713
      Top = 482
      Width = 24
      Height = 23
      AllowAllUp = True
      GroupIndex = 4
      Down = True
      ImageIndex = 25
      Images = lsMain
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnClick = sbUseLinesLimitClick
    end
    object lbLogLevel: TLabel
      Left = 527
      Top = 486
      Width = 43
      Height = 13
      Alignment = taRightJustify
      Caption = #1059#1088#1086#1074#1077#1085#1100
      Transparent = True
    end
    object sbSafeLogging: TSpeedButton
      Left = 687
      Top = 482
      Width = 24
      Height = 23
      AllowAllUp = True
      GroupIndex = 3
      Down = True
      ImageIndex = 24
      Images = lsMain
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnClick = sbSafeLoggingClick
    end
    object bvLog: TBevel
      Left = 2
      Top = 478
      Width = 790
      Height = 3
      Shape = bsBottomLine
    end
    object edLinesLimit: TEdit
      Left = 739
      Top = 483
      Width = 38
      Height = 21
      Alignment = taCenter
      MaxLength = 5
      NumbersOnly = True
      PopupMenu = EditMenu
      TabOrder = 2
      Text = '32768'
      OnKeyDown = edLinesLimitKeyDown
      OnMouseDown = edLinesLimitMouseDown
    end
    object udLinesLimit: TUpDown
      Left = 777
      Top = 483
      Width = 13
      Height = 21
      HelpContext = 10
      Associate = edLinesLimit
      ArrowKeys = False
      DoubleBuffered = True
      Min = 1024
      Max = 65536
      Increment = 1024
      ParentDoubleBuffered = False
      Position = 32768
      TabOrder = 3
      Thousands = False
      OnClick = udLinesLimitClick
    end
    object cbxLogLevel: TComboBox
      Left = 573
      Top = 483
      Width = 112
      Height = 21
      AutoDropDown = True
      Style = csDropDownList
      DoubleBuffered = False
      DropDownCount = 9
      ItemIndex = 2
      ParentDoubleBuffered = False
      TabOrder = 1
      Text = #1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1103
      OnChange = cbxLogLevelChange
      Items.Strings = (
        #1054#1090#1083#1072#1076#1082#1072
        #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103
        #1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1103
        #1055#1088#1077#1076#1091#1087#1088#1077#1078#1076#1077#1085#1080#1103
        #1054#1096#1080#1073#1082#1080)
    end
    object meLog: TMemo
      Left = 4
      Top = 2
      Width = 788
      Height = 477
      BorderStyle = bsNone
      DoubleBuffered = True
      HideSelection = False
      ParentDoubleBuffered = False
      PopupMenu = mnLog
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      WordWrap = False
      OnMouseUp = meLogMouseUp
    end
  end
  object paCircuits: TPanel
    Left = 3
    Top = 92
    Width = 793
    Height = 508
    BevelInner = bvLowered
    Color = clWindow
    DoubleBuffered = True
    ParentBackground = False
    ParentDoubleBuffered = False
    ShowCaption = False
    TabOrder = 4
    Visible = False
    object lbCircuitInfoTime: TLabel
      Left = 622
      Top = 10
      Width = 160
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103': '#1053#1077' '#1086#1087#1088#1077#1076#1077#1083#1077#1085#1072
      Transparent = True
    end
    object lbCircuitsCount: TLabel
      Left = 12
      Top = 10
      Width = 80
      Height = 13
      Caption = #1062#1077#1087#1086#1095#1077#1082': 0 '#1080#1079' 0'
      Transparent = True
    end
    object lbStreamsCount: TLabel
      Left = 157
      Top = 10
      Width = 75
      Height = 13
      Alignment = taRightJustify
      Caption = #1057#1086#1077#1076#1080#1085#1077#1085#1080#1081': 0'
      Transparent = True
    end
    object lbCircuitPurpose: TLabel
      Left = 261
      Top = 10
      Width = 77
      Height = 13
      Caption = #1053#1077' '#1086#1087#1088#1077#1076#1077#1083#1077#1085#1086
      Transparent = True
    end
    object imCircuitPurpose: TImage
      Left = 242
      Top = 9
      Width = 16
      Height = 16
      ParentShowHint = False
      ShowHint = True
    end
    object sgStreamsInfo: TStringGrid
      Tag = 8
      Left = 243
      Top = 372
      Width = 538
      Height = 125
      ColCount = 6
      DefaultRowHeight = 16
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goRowSelect, goThumbTracking, goFixedRowClick]
      ParentShowHint = False
      PopupMenu = mnStreamsInfo
      ScrollBars = ssVertical
      ShowHint = True
      TabOrder = 3
      OnDrawCell = sgStreamsInfoDrawCell
      OnFixedCellClick = sgStreamsInfoFixedCellClick
      OnKeyDown = sgStreamsInfoKeyDown
      OnMouseDown = sgStreamsInfoMouseDown
      OnMouseMove = sgStreamsInfoMouseMove
      OnSelectCell = sgStreamsInfoSelectCell
    end
    object sgStreams: TStringGrid
      Tag = 4
      Left = 243
      Top = 152
      Width = 538
      Height = 209
      ColCount = 6
      DefaultRowHeight = 16
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goRowSelect, goThumbTracking, goFixedRowClick]
      ParentShowHint = False
      PopupMenu = mnStreams
      ScrollBars = ssVertical
      ShowHint = True
      TabOrder = 2
      OnDblClick = sgStreamsDblClick
      OnDrawCell = sgStreamsDrawCell
      OnFixedCellClick = sgStreamsFixedCellClick
      OnKeyDown = sgStreamsKeyDown
      OnKeyUp = sgStreamsKeyUp
      OnMouseDown = sgStreamsMouseDown
      OnMouseMove = sgStreamsMouseMove
      OnSelectCell = sgStreamsSelectCell
    end
    object sgCircuitInfo: TStringGrid
      Tag = 7
      Left = 243
      Top = 33
      Width = 538
      Height = 108
      ColCount = 8
      DefaultRowHeight = 16
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goRowSelect, goThumbTracking]
      ParentShowHint = False
      PopupMenu = mnCircuitInfo
      ScrollBars = ssVertical
      ShowHint = True
      TabOrder = 1
      OnDblClick = sgCircuitInfoDblClick
      OnDrawCell = sgCircuitInfoDrawCell
      OnKeyDown = sgCircuitInfoKeyDown
      OnMouseDown = sgCircuitInfoMouseDown
      OnMouseMove = sgCircuitInfoMouseMove
      OnSelectCell = sgCircuitInfoSelectCell
    end
    object sgCircuits: TStringGrid
      Tag = 3
      Left = 12
      Top = 33
      Width = 220
      Height = 464
      ColCount = 7
      DefaultRowHeight = 16
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goRowSelect, goThumbTracking, goFixedRowClick]
      ParentShowHint = False
      PopupMenu = mnCircuits
      ScrollBars = ssVertical
      ShowHint = True
      TabOrder = 0
      OnDrawCell = sgCircuitsDrawCell
      OnFixedCellClick = sgCircuitsFixedCellClick
      OnKeyDown = sgCircuitsKeyDown
      OnMouseDown = sgCircuitsMouseDown
      OnMouseMove = sgCircuitsMouseMove
      OnSelectCell = sgCircuitsSelectCell
    end
  end
  object paRouters: TPanel
    Left = 3
    Top = 92
    Width = 793
    Height = 508
    BevelInner = bvLowered
    Color = clWindow
    DoubleBuffered = True
    ParentBackground = False
    ParentDoubleBuffered = False
    ShowCaption = False
    TabOrder = 5
    Visible = False
    OnClick = paRoutersClick
    object lbRoutersCount: TLabel
      Left = 702
      Top = 10
      Width = 84
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1086#1082#1072#1079#1072#1085#1086': 0 '#1080#1079' 0'
      Transparent = True
    end
    object lbSpeed3: TLabel
      Left = 293
      Top = 10
      Width = 23
      Height = 13
      Caption = #1052#1041'/c'
      Transparent = True
    end
    object lbFavoritesEntry: TLabel
      Left = 145
      Top = 486
      Width = 6
      Height = 13
      Cursor = crHandPoint
      Hint = '288'
      Caption = '0'
      Transparent = True
      OnMouseDown = ShowFavoritesRouters
    end
    object lbFavoritesMiddle: TLabel
      Left = 206
      Top = 486
      Width = 6
      Height = 13
      Cursor = crHandPoint
      Hint = '289'
      Caption = '0'
      Transparent = True
      OnMouseDown = ShowFavoritesRouters
    end
    object lbFavoritesExit: TLabel
      Left = 264
      Top = 486
      Width = 6
      Height = 13
      Cursor = crHandPoint
      Hint = '290'
      Caption = '0'
      Transparent = True
      OnMouseDown = ShowFavoritesRouters
    end
    object lbExcludeNodes: TLabel
      Left = 378
      Top = 486
      Width = 6
      Height = 13
      Cursor = crHandPoint
      Hint = '287'
      Caption = '0'
      Transparent = True
      OnMouseDown = ShowFavoritesRouters
    end
    object lbFavoritesTotal: TLabel
      Left = 322
      Top = 486
      Width = 6
      Height = 13
      Cursor = crHandPoint
      Caption = '0'
      Transparent = True
      OnMouseDown = ShowFavoritesRouters
    end
    object lbFavoritesTotalSelected: TLabel
      Left = 33
      Top = 486
      Width = 79
      Height = 13
      Alignment = taRightJustify
      Caption = #1042#1089#1077#1075#1086' '#1074#1099#1073#1088#1072#1085#1086':'
      Transparent = True
    end
    object imFavoritesMiddle: TImage
      Left = 186
      Top = 485
      Width = 16
      Height = 16
      ParentShowHint = False
      ShowHint = True
    end
    object imFavoritesExit: TImage
      Left = 245
      Top = 485
      Width = 16
      Height = 16
      ParentShowHint = False
      ShowHint = True
    end
    object imFavoritesTotal: TImage
      Left = 302
      Top = 485
      Width = 16
      Height = 16
      ParentShowHint = False
      ShowHint = True
    end
    object imExcludeNodes: TImage
      Left = 358
      Top = 485
      Width = 16
      Height = 16
      ParentShowHint = False
      ShowHint = True
    end
    object imFavoritesBridges: TImage
      Left = 411
      Top = 485
      Width = 16
      Height = 16
      ParentShowHint = False
      ShowHint = True
    end
    object lbFavoritesBridges: TLabel
      Left = 431
      Top = 486
      Width = 6
      Height = 13
      Cursor = crHandPoint
      Caption = '0'
      Transparent = True
      OnMouseDown = ShowFavoritesRouters
    end
    object imFavoritesFallbackDirs: TImage
      Left = 464
      Top = 484
      Width = 16
      Height = 16
      ParentShowHint = False
      ShowHint = True
    end
    object lbFavoritesFallbackDirs: TLabel
      Left = 484
      Top = 486
      Width = 6
      Height = 13
      Cursor = crHandPoint
      Caption = '0'
      Transparent = True
      OnMouseDown = ShowFavoritesRouters
    end
    object imSelectedRouters: TImage
      Left = 517
      Top = 485
      Width = 16
      Height = 16
      ParentShowHint = False
      ShowHint = True
    end
    object lbSelectedRouters: TLabel
      Left = 537
      Top = 486
      Width = 6
      Height = 13
      Cursor = crHandPoint
      Caption = '0'
      Transparent = True
      OnMouseDown = lbSelectedRoutersMouseDown
    end
    object imFavoritesEntry: TImage
      Left = 125
      Top = 485
      Width = 16
      Height = 16
      ParentShowHint = False
      ShowHint = True
    end
    object sgRouters: TStringGrid
      Tag = 2
      Left = 1
      Top = 33
      Width = 792
      Height = 447
      ColCount = 15
      DefaultRowHeight = 16
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goRowSelect, goThumbTracking, goFixedRowClick]
      ParentShowHint = False
      PopupMenu = mnRouters
      ScrollBars = ssVertical
      ShowHint = True
      TabOrder = 0
      OnDblClick = sgRoutersDblClick
      OnDrawCell = sgRoutersDrawCell
      OnFixedCellClick = sgRoutersFixedCellClick
      OnKeyDown = sgRoutersKeyDown
      OnKeyPress = sgRoutersKeyPress
      OnMouseDown = sgRoutersMouseDown
      OnMouseMove = sgRoutersMouseMove
      OnSelectCell = sgRoutersSelectCell
    end
    object btnShowNodes: TButton
      Left = 6
      Top = 7
      Width = 84
      Height = 21
      Caption = #1058#1080#1087' '#1091#1079#1083#1072
      DropDownMenu = mnShowNodes
      Style = bsSplitButton
      TabOrder = 1
      OnClick = btnShowNodesClick
    end
    object cbxRoutersCountry: TComboBox
      Tag = -1
      Left = 93
      Top = 7
      Width = 146
      Height = 21
      AutoDropDown = True
      Style = csDropDownList
      DoubleBuffered = False
      ParentDoubleBuffered = False
      Sorted = True
      TabOrder = 2
      OnChange = cbxRoutersCountryChange
      OnEnter = cbxRoutersCountryEnter
    end
    object edRoutersWeight: TEdit
      Left = 243
      Top = 7
      Width = 35
      Height = 21
      Alignment = taCenter
      MaxLength = 5
      NumbersOnly = True
      PopupMenu = EditMenu
      TabOrder = 3
      Text = '10'
      OnKeyDown = edRoutersWeightKeyDown
      OnMouseDown = edRoutersWeightMouseDown
    end
    object udRoutersWeight: TUpDown
      Left = 278
      Top = 7
      Width = 13
      Height = 21
      HelpContext = 10
      Associate = edRoutersWeight
      ArrowKeys = False
      DoubleBuffered = True
      Max = 65535
      Increment = 5
      ParentDoubleBuffered = False
      Position = 10
      TabOrder = 4
      Thousands = False
      OnClick = udRoutersWeightClick
    end
    object cbxRoutersQuery: TComboBox
      Tag = -1
      Left = 320
      Top = 7
      Width = 75
      Height = 21
      AutoDropDown = True
      Style = csDropDownList
      DoubleBuffered = False
      DropDownCount = 9
      ItemIndex = 0
      ParentDoubleBuffered = False
      TabOrder = 5
      Text = #1061#1101#1096
      OnChange = cbxRoutersQueryChange
      Items.Strings = (
        #1061#1101#1096
        #1053#1080#1082
        'IPv4'
        'IPv6'
        #1055#1086#1088#1090
        #1042#1077#1088#1089#1080#1103
        #1055#1080#1085#1075
        #1058#1088#1072#1085#1089#1087#1086#1088#1090)
    end
    object edRoutersQuery: TEdit
      Left = 399
      Top = 7
      Width = 203
      Height = 21
      PopupMenu = EditMenu
      TabOrder = 6
      OnChange = edRoutersQueryChange
      OnKeyDown = edRoutersQueryKeyDown
    end
  end
  object pcOptions: TPageControl
    Left = 4
    Top = 93
    Width = 794
    Height = 506
    ActivePage = tsMain
    DoubleBuffered = True
    Images = lsMain
    ParentDoubleBuffered = False
    TabHeight = 26
    TabOrder = 1
    TabPosition = tpBottom
    object tsMain: TTabSheet
      Caption = #1054#1073#1097#1080#1077
      object gbProfile: TGroupBox
        Left = 426
        Top = 401
        Width = 354
        Height = 65
        Caption = #1055#1088#1086#1092#1080#1083#1100
        TabOrder = 3
        object lbCreateProfile: TLabel
          Left = 79
          Top = 21
          Width = 161
          Height = 26
          Alignment = taRightJustify
          AutoSize = False
          Caption = #1071#1088#1083#1099#1082' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' '#1089' '#1085#1086#1074#1099#1084' '#1087#1088#1086#1092#1080#1083#1077#1084' '#1085#1072' '#1088#1072#1073#1086#1095#1077#1084' '#1089#1090#1086#1083#1077
          Transparent = True
          WordWrap = True
        end
        object btnCreateProfile: TButton
          Left = 260
          Top = 25
          Width = 75
          Height = 21
          Caption = #1057#1086#1079#1076#1072#1090#1100'..'
          TabOrder = 0
          OnClick = btnCreateProfileClick
        end
      end
      object gbControlAuth: TGroupBox
        Left = 10
        Top = 401
        Width = 406
        Height = 65
        Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077
        TabOrder = 1
        object lbControlPort: TLabel
          Left = 11
          Top = 40
          Width = 25
          Height = 13
          Alignment = taRightJustify
          Caption = #1055#1086#1088#1090
          Transparent = True
        end
        object lbAuthMetod: TLabel
          Left = 194
          Top = 15
          Width = 87
          Height = 13
          Alignment = taRightJustify
          Caption = #1040#1091#1090#1077#1085#1090#1080#1092#1080#1082#1072#1094#1080#1103
          Transparent = True
        end
        object lbControlPassword: TLabel
          Left = 163
          Top = 40
          Width = 37
          Height = 13
          Alignment = taRightJustify
          Caption = #1055#1072#1088#1086#1083#1100
          Enabled = False
          Transparent = True
        end
        object sbGeneratePassword: TSpeedButton
          Left = 380
          Top = 37
          Width = 22
          Height = 22
          ImageIndex = 21
          Images = lsMain
          Flat = True
          Transparent = False
          OnClick = sbGeneratePasswordClick
        end
        object edControlPort: TEdit
          Left = 39
          Top = 37
          Width = 42
          Height = 21
          MaxLength = 5
          NumbersOnly = True
          PopupMenu = EditMenu
          TabOrder = 0
          Text = '9051'
          OnChange = EditChange
        end
        object udControlPort: TUpDown
          Left = 81
          Top = 37
          Width = 13
          Height = 21
          Associate = edControlPort
          Min = 1
          Max = 65535
          Position = 9051
          TabOrder = 1
          Thousands = False
          OnChanging = SpinChanging
        end
        object cbxAuthMetod: TComboBox
          Left = 284
          Top = 12
          Width = 116
          Height = 21
          AutoDropDown = True
          Style = csDropDownList
          DoubleBuffered = False
          ItemIndex = 0
          ParentDoubleBuffered = False
          TabOrder = 2
          Text = 'Cookie-'#1092#1072#1081#1083
          OnChange = cbxAuthMetodChange
          Items.Strings = (
            'Cookie-'#1092#1072#1081#1083
            #1055#1072#1088#1086#1083#1100)
        end
        object edControlPassword: TEdit
          Left = 202
          Top = 37
          Width = 177
          Height = 21
          Enabled = False
          MaxLength = 255
          PasswordChar = '*'
          PopupMenu = EditMenu
          TabOrder = 3
          OnChange = EditChange
          OnDblClick = edControlPasswordDblClick
        end
      end
      object gbInterface: TGroupBox
        Left = 426
        Top = 5
        Width = 354
        Height = 392
        Caption = #1048#1085#1090#1077#1088#1092#1077#1081#1089
        TabOrder = 2
        object lbTheme: TLabel
          Left = 206
          Top = 297
          Width = 24
          Height = 13
          Alignment = taRightJustify
          Caption = #1058#1077#1084#1072
          Transparent = True
        end
        object lbLanguage: TLabel
          Left = 36
          Top = 297
          Width = 26
          Height = 13
          Alignment = taRightJustify
          Caption = #1071#1079#1099#1082
          Transparent = True
        end
        object lbMinimizeOnEvent: TLabel
          Left = 60
          Top = 249
          Width = 170
          Height = 13
          Alignment = taRightJustify
          Caption = #1057#1074#1086#1088#1072#1095#1080#1074#1072#1090#1100' '#1074' '#1090#1088#1077#1081' '#1087#1088#1080' '#1089#1086#1073#1099#1090#1080#1080
          Transparent = True
        end
        object lbTrayIconType: TLabel
          Left = 137
          Top = 272
          Width = 93
          Height = 13
          Alignment = taRightJustify
          Caption = #1058#1080#1087' '#1080#1082#1086#1085#1082#1080' '#1074' '#1090#1088#1077#1077
          Transparent = True
        end
        object cbShowBalloonOnlyWhenHide: TCheckBox
          Left = 29
          Top = 85
          Width = 304
          Height = 17
          Caption = #1058#1086#1083#1100#1082#1086' '#1082#1086#1075#1076#1072' '#1087#1088#1086#1075#1088#1072#1084#1084#1072' '#1089#1074#1105#1088#1085#1091#1090#1072
          Checked = True
          State = cbChecked
          TabOrder = 3
          OnClick = OptionsChange
        end
        object cbShowBalloonHint: TCheckBox
          Left = 13
          Top = 62
          Width = 320
          Height = 17
          Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1074#1089#1087#1083#1099#1074#1072#1102#1097#1080#1077' '#1089#1086#1086#1073#1097#1077#1085#1080#1103
          Checked = True
          State = cbChecked
          TabOrder = 2
          OnClick = cbShowBalloonHintClick
        end
        object cbConnectOnStartup: TCheckBox
          Left = 13
          Top = 16
          Width = 320
          Height = 17
          Caption = #1055#1086#1076#1082#1083#1102#1095#1072#1090#1100#1089#1103' '#1087#1088#1080' '#1079#1072#1087#1091#1089#1082#1077' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
          TabOrder = 0
          OnClick = OptionsChange
        end
        object cbRestartOnControlFail: TCheckBox
          Left = 13
          Top = 39
          Width = 320
          Height = 17
          Caption = #1055#1077#1088#1077#1079#1072#1087#1091#1089#1082' '#1087#1088#1080' '#1086#1073#1088#1099#1074#1077' '#1089#1074#1103#1079#1080' '#1089' '#1082#1083#1080#1077#1085#1090#1086#1084
          Checked = True
          State = cbChecked
          TabOrder = 1
          OnClick = OptionsChange
        end
        object cbNoDesktopBorders: TCheckBox
          Left = 13
          Top = 108
          Width = 320
          Height = 17
          Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1086#1082#1085#1091' '#1074#1099#1093#1086#1076#1080#1090#1100' '#1079#1072' '#1075#1088#1072#1085#1080#1094#1099' '#1101#1082#1088#1072#1085#1072
          Checked = True
          State = cbChecked
          TabOrder = 4
          OnClick = cbNoDesktopBordersClick
        end
        object cbRememberEnlargedPosition: TCheckBox
          Left = 13
          Top = 154
          Width = 320
          Height = 17
          Caption = #1047#1072#1087#1086#1084#1080#1085#1072#1090#1100' '#1087#1086#1079#1080#1094#1080#1102' '#1091#1074#1077#1083#1080#1095#1077#1085#1085#1086#1075#1086' '#1086#1082#1085#1072
          TabOrder = 6
          OnClick = OptionsChange
        end
        object cbHideIPv6Addreses: TCheckBox
          Left = 13
          Top = 177
          Width = 320
          Height = 17
          Caption = #1057#1082#1088#1099#1074#1072#1090#1100' IPv6-'#1072#1076#1088#1077#1089#1072' '#1074' '#1089#1087#1080#1089#1082#1072#1093' '#1080#1085#1090#1077#1088#1092#1077#1081#1089#1086#1074
          Checked = True
          State = cbChecked
          TabOrder = 7
          OnClick = OptionsChange
        end
        object cbNoDesktopBordersOnlyEnlarged: TCheckBox
          Left = 29
          Top = 131
          Width = 304
          Height = 17
          Caption = #1058#1086#1083#1100#1082#1086' '#1087#1088#1080' '#1091#1074#1077#1083#1080#1095#1077#1085#1085#1086#1084' '#1086#1082#1085#1077' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
          Checked = True
          State = cbChecked
          TabOrder = 5
          OnClick = OptionsChange
        end
        object cbClearPreviousSearchQuery: TCheckBox
          Left = 13
          Top = 200
          Width = 320
          Height = 17
          Caption = #1054#1095#1080#1097#1072#1090#1100' '#1087#1088#1077#1076#1099#1076#1091#1097#1080#1081' '#1087#1086#1080#1089#1082#1086#1074#1099#1081' '#1079#1072#1087#1088#1086#1089' '#1074' '#1089#1087#1080#1089#1082#1072#1093
          TabOrder = 8
          OnClick = OptionsChange
        end
        object cbxThemes: TComboBox
          Left = 233
          Top = 294
          Width = 116
          Height = 21
          AutoDropDown = True
          Style = csDropDownList
          DoubleBuffered = False
          ItemIndex = 0
          ParentDoubleBuffered = False
          TabOrder = 12
          Text = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
          OnChange = cbxThemesChange
          OnDropDown = cbxThemesDropDown
          Items.Strings = (
            #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102)
        end
        object cbxLanguage: TComboBox
          Left = 65
          Top = 294
          Width = 116
          Height = 21
          AutoDropDown = True
          Style = csDropDownList
          DoubleBuffered = False
          ItemIndex = 0
          ParentDoubleBuffered = False
          Sorted = True
          TabOrder = 13
          Text = #1056#1091#1089#1089#1082#1080#1081
          OnChange = OptionsChange
          Items.Strings = (
            #1056#1091#1089#1089#1082#1080#1081)
        end
        object cbMinimizeToTray: TCheckBox
          Left = 13
          Top = 223
          Width = 320
          Height = 17
          Caption = #1057#1074#1086#1088#1072#1095#1080#1074#1072#1090#1100' '#1074' '#1090#1088#1077#1081' '#1074#1084#1077#1089#1090#1086' '#1087#1072#1085#1077#1083#1080' '#1079#1072#1076#1072#1095
          TabOrder = 9
          OnClick = OptionsChange
        end
        object cbxMinimizeOnEvent: TComboBox
          Left = 233
          Top = 246
          Width = 116
          Height = 21
          AutoDropDown = True
          Style = csDropDownList
          DoubleBuffered = False
          ItemIndex = 2
          ParentDoubleBuffered = False
          TabOrder = 10
          Text = #1047#1072#1082#1088#1099#1090#1080#1077' '#1086#1082#1085#1072
          OnChange = OptionsChange
          Items.Strings = (
            #1054#1090#1082#1083#1102#1095#1077#1085#1086
            #1042#1089#1077' '#1089#1086#1073#1099#1090#1080#1103
            #1047#1072#1082#1088#1099#1090#1080#1077' '#1086#1082#1085#1072
            #1047#1072#1087#1091#1089#1082' '#1087#1088#1086#1075#1088#1072#1084#1084#1099)
        end
        object cbxTrayIconType: TComboBox
          Left = 233
          Top = 270
          Width = 116
          Height = 21
          AutoDropDown = True
          Style = csDropDownList
          DoubleBuffered = False
          ItemIndex = 0
          ParentDoubleBuffered = False
          TabOrder = 11
          Text = #1042#1089#1090#1088#1086#1077#1085#1085#1072#1103
          OnChange = cbxTrayIconTypeChange
          Items.Strings = (
            #1042#1089#1090#1088#1086#1077#1085#1085#1072#1103
            #1048#1079' '#1092#1072#1081#1083#1072)
        end
      end
      object gbOptions: TGroupBox
        Left = 10
        Top = 5
        Width = 406
        Height = 392
        Caption = #1054#1089#1085#1086#1074#1085#1099#1077
        TabOrder = 0
        object lbMaxCircuitDirtiness: TLabel
          Left = 98
          Top = 17
          Width = 222
          Height = 13
          Alignment = taRightJustify
          Caption = #1052#1077#1085#1103#1090#1100' '#1094#1077#1087#1086#1095#1082#1091' '#1089#1091#1097#1077#1089#1090#1074#1091#1102#1097#1091#1102' '#1073#1086#1083#1077#1077' '#1095#1077#1084
          Transparent = True
        end
        object lbSeconds1: TLabel
          Left = 381
          Top = 17
          Width = 21
          Height = 13
          Caption = #1089#1077#1082'.'
          Transparent = True
        end
        object lbMaxClientCircuitsPending: TLabel
          Left = 104
          Top = 109
          Width = 216
          Height = 13
          Alignment = taRightJustify
          Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1086#1078#1080#1076#1072#1102#1097#1080#1093' '#1094#1077#1087#1086#1095#1077#1082' '#1082#1083#1080#1077#1085#1090#1072
          Transparent = True
        end
        object lbConnectionPadding: TLabel
          Left = 32
          Top = 249
          Width = 250
          Height = 13
          Alignment = taRightJustify
          Caption = #1047#1072#1087#1086#1083#1085#1077#1085#1080#1077' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1081' '#1084#1072#1089#1082#1080#1088#1091#1102#1097#1080#1084' '#1090#1088#1072#1092#1080#1082#1086#1084
          Transparent = True
        end
        object lbCircuitPadding: TLabel
          Left = 50
          Top = 273
          Width = 232
          Height = 13
          Alignment = taRightJustify
          Caption = #1047#1072#1087#1086#1083#1085#1077#1085#1080#1077' '#1094#1077#1087#1086#1095#1077#1082' '#1084#1072#1089#1082#1080#1088#1091#1102#1097#1080#1084' '#1090#1088#1072#1092#1080#1082#1086#1084
          Transparent = True
        end
        object lbSocksTimeout: TLabel
          Left = 87
          Top = 40
          Width = 233
          Height = 13
          Alignment = taRightJustify
          Caption = #1052#1072#1082#1089'. '#1074#1088#1077#1084#1103' '#1085#1072' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' OR-'#1089#1086#1077#1076#1080#1085#1077#1085#1080#1081
          Transparent = True
        end
        object lbSeconds6: TLabel
          Left = 381
          Top = 40
          Width = 21
          Height = 13
          Caption = #1089#1077#1082'.'
          Transparent = True
        end
        object lbCircuitBuildTimeout: TLabel
          Left = 136
          Top = 86
          Width = 184
          Height = 13
          Alignment = taRightJustify
          Caption = #1052#1072#1082#1089'. '#1074#1088#1077#1084#1103' '#1085#1072' '#1087#1086#1089#1090#1088#1086#1077#1085#1080#1077' '#1094#1077#1087#1086#1095#1082#1080
          Enabled = False
          Transparent = True
        end
        object lbSeconds2: TLabel
          Left = 381
          Top = 86
          Width = 21
          Height = 13
          Caption = #1089#1077#1082'.'
          Enabled = False
          Transparent = True
        end
        object lbSeconds3: TLabel
          Left = 381
          Top = 63
          Width = 21
          Height = 13
          Caption = #1089#1077#1082'.'
          Transparent = True
        end
        object lbNewCircuitPeriod: TLabel
          Left = 75
          Top = 63
          Width = 245
          Height = 13
          Alignment = taRightJustify
          Caption = #1048#1085#1090#1077#1088#1074#1072#1083' '#1084#1077#1078#1076#1091' '#1087#1086#1087#1099#1090#1082#1072#1084#1080' '#1087#1086#1089#1090#1088#1086#1080#1090#1100' '#1094#1077#1087#1086#1095#1082#1091
          Transparent = True
        end
        object lbUseConflux: TLabel
          Left = 46
          Top = 297
          Width = 236
          Height = 13
          Alignment = taRightJustify
          Caption = #1056#1072#1079#1076#1077#1083#1103#1090#1100' '#1090#1088#1072#1092#1080#1082' '#1084#1077#1078#1076#1091' '#1094#1077#1087#1086#1095#1082#1072#1084#1080' (Conflux)'
          Transparent = True
        end
        object lbConfluxPriority: TLabel
          Left = 88
          Top = 321
          Width = 194
          Height = 13
          Alignment = taRightJustify
          Caption = #1055#1088#1080#1086#1088#1080#1090#1077#1090' '#1087#1088#1080' '#1086#1073#1098#1077#1076#1080#1085#1077#1085#1080#1080' '#1090#1088#1072#1092#1080#1082#1072
          Transparent = True
        end
        object cbAvoidDiskWrites: TCheckBox
          Left = 13
          Top = 200
          Width = 385
          Height = 17
          Caption = #1042#1099#1087#1086#1083#1085#1103#1090#1100' '#1084#1077#1085#1100#1096#1077' '#1086#1087#1077#1088#1072#1094#1080#1081' '#1089' '#1076#1080#1089#1082#1086#1084
          TabOrder = 13
          OnClick = OptionsChange
        end
        object cbLearnCircuitBuildTimeout: TCheckBox
          Left = 13
          Top = 131
          Width = 385
          Height = 17
          Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1074#1099#1073#1080#1088#1072#1090#1100' '#1074#1088#1077#1084#1103' '#1085#1072' '#1087#1086#1089#1090#1088#1086#1077#1085#1080#1077' '#1094#1077#1087#1086#1095#1082#1080
          Checked = True
          State = cbChecked
          TabOrder = 10
          OnClick = cbLearnCircuitBuildTimeoutClick
        end
        object cbEnforceDistinctSubnets: TCheckBox
          Left = 13
          Top = 154
          Width = 385
          Height = 17
          Caption = #1053#1077' '#1089#1090#1088#1086#1080#1090#1100' '#1094#1077#1087#1086#1095#1082#1080' '#1080#1079' '#1091#1079#1083#1086#1074' '#1086#1076#1085#1086#1081' '#1087#1086#1076#1089#1077#1090#1080
          Checked = True
          State = cbChecked
          TabOrder = 11
          OnClick = OptionsChange
        end
        object edMaxCircuitDirtiness: TEdit
          Left = 323
          Top = 14
          Width = 42
          Height = 21
          MaxLength = 7
          NumbersOnly = True
          ParentShowHint = False
          PopupMenu = EditMenu
          ShowHint = True
          TabOrder = 0
          Text = '600'
          OnChange = EditChange
        end
        object udMaxCircuitDirtiness: TUpDown
          Left = 365
          Top = 14
          Width = 13
          Height = 21
          Associate = edMaxCircuitDirtiness
          Min = 10
          Max = 2592000
          Increment = 30
          Position = 600
          TabOrder = 1
          Thousands = False
          OnChanging = SpinChanging
        end
        object cbUseNetworkCache: TCheckBox
          Left = 13
          Top = 223
          Width = 385
          Height = 17
          Caption = #1050#1101#1096#1080#1088#1086#1074#1072#1090#1100' IP-cc-'#1079#1072#1087#1088#1086#1089#1099' '#1080' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1089#1077#1090#1077#1074#1086#1075#1086' '#1089#1082#1072#1085#1077#1088#1072
          Checked = True
          State = cbChecked
          TabOrder = 14
          OnClick = OptionsChange
        end
        object cbStrictNodes: TCheckBox
          Left = 13
          Top = 177
          Width = 385
          Height = 17
          Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1079#1072#1087#1088#1077#1097#1105#1085#1085#1099#1077' '#1091#1079#1083#1099' '#1076#1083#1103' '#1074#1085#1091#1090#1088#1077#1085#1085#1080#1093' '#1094#1077#1087#1086#1095#1077#1082
          Checked = True
          State = cbChecked
          TabOrder = 12
          OnClick = OptionsChange
        end
        object edMaxClientCircuitsPending: TEdit
          Left = 323
          Top = 106
          Width = 42
          Height = 21
          MaxLength = 4
          NumbersOnly = True
          PopupMenu = EditMenu
          TabOrder = 8
          Text = '32'
          OnChange = EditChange
        end
        object udMaxClientCircuitsPending: TUpDown
          Left = 365
          Top = 106
          Width = 13
          Height = 21
          Associate = edMaxClientCircuitsPending
          Min = 1
          Max = 1024
          Increment = 8
          Position = 32
          TabOrder = 9
          Thousands = False
          OnChanging = SpinChanging
        end
        object cbxCircuitPadding: TComboBox
          Left = 285
          Top = 269
          Width = 116
          Height = 21
          AutoDropDown = True
          Style = csDropDownList
          DoubleBuffered = False
          ItemIndex = 0
          ParentDoubleBuffered = False
          TabOrder = 16
          Text = #1042#1082#1083#1102#1095#1077#1085#1086
          OnChange = OptionsChange
          Items.Strings = (
            #1042#1082#1083#1102#1095#1077#1085#1086
            #1054#1075#1088#1072#1085#1080#1095#1077#1085#1086
            #1042#1099#1082#1083#1102#1095#1077#1085#1086)
        end
        object cbxConnectionPadding: TComboBox
          Left = 285
          Top = 245
          Width = 116
          Height = 21
          AutoDropDown = True
          Style = csDropDownList
          DoubleBuffered = False
          ItemIndex = 0
          ParentDoubleBuffered = False
          TabOrder = 15
          Text = #1040#1074#1090#1086#1074#1099#1073#1086#1088
          OnChange = OptionsChange
          Items.Strings = (
            #1040#1074#1090#1086#1074#1099#1073#1086#1088
            #1042#1082#1083#1102#1095#1077#1085#1086
            #1054#1075#1088#1072#1085#1080#1095#1077#1085#1086
            #1042#1099#1082#1083#1102#1095#1077#1085#1086)
        end
        object edSocksTimeout: TEdit
          Left = 323
          Top = 37
          Width = 42
          Height = 21
          MaxLength = 7
          NumbersOnly = True
          ParentShowHint = False
          PopupMenu = EditMenu
          ShowHint = True
          TabOrder = 2
          Text = '120'
          OnChange = EditChange
        end
        object udSocksTimeout: TUpDown
          Left = 365
          Top = 37
          Width = 13
          Height = 21
          Associate = edSocksTimeout
          Min = 10
          Max = 2592000
          Increment = 10
          Position = 120
          TabOrder = 3
          Thousands = False
          OnChanging = SpinChanging
        end
        object edCircuitBuildTimeout: TEdit
          Left = 323
          Top = 83
          Width = 42
          Height = 21
          Enabled = False
          MaxLength = 7
          NumbersOnly = True
          PopupMenu = EditMenu
          TabOrder = 6
          Text = '60'
          OnChange = EditChange
        end
        object udCircuitBuildTimeout: TUpDown
          Left = 365
          Top = 83
          Width = 13
          Height = 21
          Associate = edCircuitBuildTimeout
          Enabled = False
          Min = 10
          Max = 2592000
          Increment = 5
          Position = 60
          TabOrder = 7
          Thousands = False
          OnChanging = SpinChanging
        end
        object edNewCircuitPeriod: TEdit
          Left = 323
          Top = 60
          Width = 42
          Height = 21
          MaxLength = 7
          NumbersOnly = True
          PopupMenu = EditMenu
          TabOrder = 4
          Text = '30'
          OnChange = EditChange
        end
        object udNewCircuitPeriod: TUpDown
          Left = 365
          Top = 60
          Width = 13
          Height = 21
          Associate = edNewCircuitPeriod
          Min = 1
          Max = 2592000
          Increment = 5
          Position = 30
          TabOrder = 5
          Thousands = False
          OnChanging = SpinChanging
        end
        object cbxUseConflux: TComboBox
          Left = 285
          Top = 293
          Width = 116
          Height = 21
          AutoDropDown = True
          Style = csDropDownList
          DoubleBuffered = False
          ItemIndex = 0
          ParentDoubleBuffered = False
          TabOrder = 17
          Text = #1040#1074#1090#1086#1074#1099#1073#1086#1088
          OnChange = cbxUseConfluxChange
          Items.Strings = (
            #1040#1074#1090#1086#1074#1099#1073#1086#1088
            #1042#1082#1083#1102#1095#1077#1085#1086
            #1042#1099#1082#1083#1102#1095#1077#1085#1086)
        end
        object cbxConfluxPriority: TComboBox
          Left = 285
          Top = 317
          Width = 116
          Height = 21
          AutoDropDown = True
          Style = csDropDownList
          DoubleBuffered = False
          ItemIndex = 0
          ParentDoubleBuffered = False
          TabOrder = 18
          Text = #1057#1082#1086#1088#1086#1089#1090#1100' '#1082#1072#1085#1072#1083#1072
          OnChange = OptionsChange
          Items.Strings = (
            #1057#1082#1086#1088#1086#1089#1090#1100' '#1082#1072#1085#1072#1083#1072
            #1052#1080#1085'. '#1079#1072#1076#1077#1088#1078#1082#1072)
        end
      end
    end
    object tsNetwork: TTabSheet
      Caption = #1057#1077#1090#1100
      ImageIndex = 1
      object lbReachableAddresses: TLabel
        Left = 28
        Top = 32
        Width = 75
        Height = 13
        Alignment = taRightJustify
        Caption = #1057#1087#1080#1089#1086#1082' '#1087#1086#1088#1090#1086#1074
        Enabled = False
        Transparent = True
      end
      object lbProxyAddress: TLabel
        Left = 119
        Top = 80
        Width = 31
        Height = 13
        Alignment = taRightJustify
        Caption = #1040#1076#1088#1077#1089
        Enabled = False
        Transparent = True
      end
      object lbProxyUser: TLabel
        Left = 502
        Top = 81
        Width = 30
        Height = 13
        Alignment = taRightJustify
        Caption = #1051#1086#1075#1080#1085
        Enabled = False
        Transparent = True
      end
      object lbProxyPort: TLabel
        Left = 403
        Top = 81
        Width = 25
        Height = 13
        Alignment = taRightJustify
        Caption = #1055#1086#1088#1090
        Enabled = False
        Transparent = True
      end
      object lbProxyPassword: TLabel
        Left = 644
        Top = 81
        Width = 37
        Height = 13
        Alignment = taRightJustify
        Caption = #1055#1072#1088#1086#1083#1100
        Enabled = False
        Transparent = True
      end
      object lbProxyType: TLabel
        Left = 28
        Top = 81
        Width = 18
        Height = 13
        Alignment = taRightJustify
        Caption = #1058#1080#1087
        Enabled = False
        Transparent = True
      end
      object lbTotalBridges: TLabel
        Left = 695
        Top = 127
        Width = 85
        Height = 13
        Alignment = taRightJustify
        Caption = #1044#1086#1089#1090#1091#1087#1085#1086': 0 '#1080#1079' 0'
        Enabled = False
        Transparent = True
      end
      object lbBridgesType: TLabel
        Left = 28
        Top = 127
        Width = 18
        Height = 13
        Alignment = taRightJustify
        Caption = #1058#1080#1087
        Enabled = False
        Transparent = True
      end
      object lbBridgesSubType: TLabel
        Left = 201
        Top = 127
        Width = 36
        Height = 13
        Alignment = taRightJustify
        Caption = #1057#1087#1080#1089#1086#1082
        Transparent = True
      end
      object lbPreferredBridge: TLabel
        Left = 28
        Top = 448
        Width = 25
        Height = 13
        Alignment = taRightJustify
        Caption = #1052#1086#1089#1090
        Enabled = False
        Transparent = True
      end
      object lbUseBuiltInProxy: TLabel
        Left = 621
        Top = 9
        Width = 159
        Height = 13
        Alignment = taRightJustify
        Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1074#1089#1090#1088#1086#1077#1085#1085#1099#1093' '#1087#1088#1086#1082#1089#1080
        Transparent = True
      end
      object lbBridgesLimit: TLabel
        Left = 28
        Top = 379
        Width = 49
        Height = 13
        Alignment = taRightJustify
        Caption = #1052#1072#1082#1089#1080#1084#1091#1084
        Enabled = False
        Transparent = True
      end
      object lbBridgesPriority: TLabel
        Left = 158
        Top = 379
        Width = 55
        Height = 13
        Alignment = taRightJustify
        Caption = #1055#1088#1080#1086#1088#1080#1090#1077#1090
        Enabled = False
        Transparent = True
      end
      object lbMaxDirFails: TLabel
        Left = 539
        Top = 379
        Width = 163
        Height = 13
        Alignment = taRightJustify
        Caption = #1052#1072#1082#1089#1080#1084#1091#1084' '#1086#1096#1080#1073#1086#1082' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1103
        Enabled = False
        Transparent = True
      end
      object lbBridgesCheckDelay: TLabel
        Left = 552
        Top = 356
        Width = 150
        Height = 13
        Alignment = taRightJustify
        Caption = #1047#1072#1076#1077#1088#1078#1082#1072' '#1084#1077#1078#1076#1091' '#1087#1088#1086#1074#1077#1088#1082#1072#1084#1080
        Enabled = False
        Transparent = True
      end
      object lbSeconds5: TLabel
        Left = 762
        Top = 355
        Width = 21
        Height = 13
        Caption = #1089#1077#1082'.'
        Enabled = False
        Transparent = True
      end
      object lbCount4: TLabel
        Left = 762
        Top = 379
        Width = 18
        Height = 13
        Caption = #1096#1090'.'
        Enabled = False
        Transparent = True
      end
      object lbBridgesQueueSize: TLabel
        Left = 621
        Top = 402
        Width = 81
        Height = 13
        Alignment = taRightJustify
        Caption = #1056#1072#1079#1084#1077#1088' '#1086#1095#1077#1088#1077#1076#1080
        Enabled = False
        Transparent = True
      end
      object lbCount5: TLabel
        Left = 763
        Top = 402
        Width = 18
        Height = 13
        Caption = #1096#1090'.'
        Enabled = False
        Transparent = True
      end
      object sbBridgesFileReadOnly: TSpeedButton
        Left = 612
        Top = 124
        Width = 22
        Height = 22
        AllowAllUp = True
        GroupIndex = 2
        Down = True
        ImageIndex = 11
        Images = lsMain
        Flat = True
        Visible = False
        OnClick = sbBridgesFileReadOnlyClick
      end
      object sbBridgesFile: TSpeedButton
        Left = 589
        Top = 124
        Width = 22
        Height = 22
        ImageIndex = 15
        Images = lsMenus
        Flat = True
        Transparent = False
        OnClick = sbBridgesFileClick
      end
      object lbBridgesUniqueType: TLabel
        Left = 141
        Top = 403
        Width = 72
        Height = 13
        Alignment = taRightJustify
        Caption = #1059#1085#1080#1082#1072#1083#1100#1085#1086#1089#1090#1100
        Enabled = False
        Transparent = True
      end
      object edBridgesFile: TEdit
        Left = 240
        Top = 124
        Width = 348
        Height = 21
        AutoSelect = False
        Enabled = False
        MaxLength = 255
        PopupMenu = EditMenu
        TabOrder = 20
        Visible = False
        OnChange = edBridgesFileChange
        OnExit = edBridgesFileExit
        OnKeyDown = edBridgesFileKeyDown
      end
      object meBridges: TMemo
        Left = 10
        Top = 150
        Width = 770
        Height = 200
        Enabled = False
        PopupMenu = EditMenu
        ScrollBars = ssVertical
        TabOrder = 21
        WordWrap = False
        OnChange = meBridgesChange
        OnExit = meBridgesExit
        OnKeyPress = meBridgesKeyPress
      end
      object cbUseReachableAddresses: TCheckBox
        Left = 10
        Top = 8
        Width = 420
        Height = 17
        Margins.Left = 0
        Caption = #1052#1086#1081' '#1089#1077#1090#1077#1074#1086#1081' '#1101#1082#1088#1072#1085' '#1088#1072#1079#1088#1077#1096#1072#1077#1090' '#1087#1086#1076#1082#1083#1102#1095#1072#1090#1100#1089#1103' '#1090#1086#1083#1100#1082#1086' '#1082' '#1101#1090#1080#1084' '#1087#1086#1088#1090#1072#1084
        TabOrder = 0
        WordWrap = True
        OnClick = cbUseReachableAddressesClick
      end
      object edReachableAddresses: TEdit
        Left = 106
        Top = 29
        Width = 380
        Height = 21
        Enabled = False
        PopupMenu = EditMenu
        TabOrder = 1
        Text = '80,443'
        OnChange = edReachableAddressesChange
        OnExit = edReachableAddressesExit
        OnKeyDown = edReachableAddressesKeyDown
        OnKeyPress = edReachableAddressesKeyPress
      end
      object cbUseProxy: TCheckBox
        Left = 10
        Top = 55
        Width = 360
        Height = 17
        Caption = #1071' '#1080#1089#1087#1086#1083#1100#1079#1091#1102' '#1087#1088#1086#1082#1089#1080' '#1076#1083#1103' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1103' '#1082' '#1048#1085#1090#1077#1088#1085#1077#1090#1091
        TabOrder = 10
        OnClick = cbUseProxyClick
      end
      object edProxyAddress: TEdit
        Left = 153
        Top = 78
        Width = 242
        Height = 21
        Enabled = False
        MaxLength = 255
        PopupMenu = EditMenu
        TabOrder = 12
        OnChange = EditChange
      end
      object edProxyUser: TEdit
        Left = 535
        Top = 78
        Width = 96
        Height = 21
        Enabled = False
        MaxLength = 255
        PopupMenu = EditMenu
        TabOrder = 15
        OnChange = EditChange
      end
      object edProxyPassword: TEdit
        Left = 684
        Top = 78
        Width = 96
        Height = 21
        Enabled = False
        MaxLength = 255
        PasswordChar = '*'
        PopupMenu = EditMenu
        TabOrder = 16
        OnChange = EditChange
      end
      object cbxProxyType: TComboBox
        Left = 49
        Top = 78
        Width = 63
        Height = 21
        AutoDropDown = True
        Style = csDropDownList
        DoubleBuffered = False
        Enabled = False
        ItemIndex = 1
        ParentDoubleBuffered = False
        TabOrder = 11
        Text = 'SOCKS5'
        OnChange = cbxProxyTypeChange
        Items.Strings = (
          'SOCKS4'
          'SOCKS5'
          'HTTPS')
      end
      object cbUseBridges: TCheckBox
        Left = 10
        Top = 104
        Width = 313
        Height = 16
        Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1084#1086#1089#1090#1099
        TabOrder = 17
        OnClick = cbUseBridgesClick
      end
      object cbxSOCKSHost: TComboBox
        Left = 588
        Top = 29
        Width = 135
        Height = 21
        AutoDropDown = True
        Style = csDropDownList
        DoubleBuffered = False
        ItemIndex = 0
        ParentDoubleBuffered = False
        TabOrder = 3
        Text = '127.0.0.1'
        OnChange = OptionsChange
        OnDropDown = cbxProxyHostDropDown
        Items.Strings = (
          '127.0.0.1')
      end
      object edProxyPort: TEdit
        Left = 431
        Top = 78
        Width = 42
        Height = 21
        Enabled = False
        MaxLength = 5
        NumbersOnly = True
        PopupMenu = EditMenu
        TabOrder = 13
        Text = '1080'
        OnChange = EditChange
      end
      object udProxyPort: TUpDown
        Left = 473
        Top = 78
        Width = 13
        Height = 21
        Associate = edProxyPort
        Enabled = False
        Min = 1
        Max = 65535
        Position = 1080
        TabOrder = 14
        Thousands = False
        OnChanging = SpinChanging
      end
      object edSOCKSPort: TEdit
        Left = 726
        Top = 29
        Width = 42
        Height = 21
        MaxLength = 5
        NumbersOnly = True
        PopupMenu = EditMenu
        TabOrder = 4
        Text = '9050'
        OnChange = EditChange
      end
      object udSOCKSPort: TUpDown
        Left = 768
        Top = 29
        Width = 13
        Height = 21
        Associate = edSOCKSPort
        Min = 1
        Max = 65535
        Position = 9050
        TabOrder = 5
        Thousands = False
        OnChanging = SpinChanging
      end
      object cbEnableSocks: TCheckBox
        Left = 535
        Top = 31
        Width = 50
        Height = 17
        Caption = 'SOCKS'
        Checked = True
        State = cbChecked
        TabOrder = 2
        OnClick = cbEnableSocksClick
      end
      object cbxBridgesType: TComboBox
        Left = 49
        Top = 124
        Width = 126
        Height = 21
        AutoDropDown = True
        Style = csDropDownList
        DoubleBuffered = False
        Enabled = False
        ItemIndex = 0
        ParentDoubleBuffered = False
        TabOrder = 18
        Text = #1042#1089#1090#1088#1086#1077#1085#1085#1099#1077
        OnChange = cbxBridgesTypeChange
        OnCloseUp = cbxBridgesTypeCloseUp
        OnKeyDown = cbxBridgesTypeKeyDown
        Items.Strings = (
          #1042#1089#1090#1088#1086#1077#1085#1085#1099#1077
          #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100#1089#1082#1080#1077
          #1048#1079' '#1092#1072#1081#1083#1072)
      end
      object cbUsePreferredBridge: TCheckBox
        Left = 10
        Top = 425
        Width = 313
        Height = 16
        Caption = #1047#1072#1076#1072#1090#1100' '#1087#1088#1077#1076#1087#1086#1095#1080#1090#1072#1077#1084#1099#1081' '#1084#1086#1089#1090' '#1074#1088#1091#1095#1085#1091#1102
        Enabled = False
        TabOrder = 35
        OnClick = cbUsePreferredBridgeClick
      end
      object edPreferredBridge: TEdit
        Left = 55
        Top = 446
        Width = 647
        Height = 21
        Enabled = False
        MaxLength = 576
        PopupMenu = EditMenu
        TabOrder = 36
        OnChange = edPreferredBridgeChange
        OnExit = edPreferredBridgeExit
        OnKeyDown = edPreferredBridgeKeyDown
      end
      object btnFindPreferredBridge: TButton
        Left = 704
        Top = 446
        Width = 77
        Height = 22
        Caption = #1053#1072#1081#1090#1080'..'
        DoubleBuffered = True
        Enabled = False
        ParentDoubleBuffered = False
        TabOrder = 37
        OnClick = btnFindPreferredBridgeClick
      end
      object cbEnableHttp: TCheckBox
        Left = 535
        Top = 55
        Width = 50
        Height = 17
        Caption = 'HTTP'
        TabOrder = 6
        OnClick = cbEnableHttpClick
      end
      object cbxHTTPTunnelHost: TComboBox
        Left = 588
        Top = 53
        Width = 135
        Height = 21
        AutoDropDown = True
        Style = csDropDownList
        DoubleBuffered = False
        Enabled = False
        ItemIndex = 0
        ParentDoubleBuffered = False
        TabOrder = 7
        Text = '127.0.0.1'
        OnChange = OptionsChange
        OnDropDown = cbxProxyHostDropDown
        Items.Strings = (
          '127.0.0.1')
      end
      object edHTTPTunnelPort: TEdit
        Left = 726
        Top = 53
        Width = 42
        Height = 21
        Enabled = False
        MaxLength = 5
        NumbersOnly = True
        PopupMenu = EditMenu
        TabOrder = 8
        Text = '9080'
        OnChange = EditChange
      end
      object udHTTPTunnelPort: TUpDown
        Left = 768
        Top = 53
        Width = 13
        Height = 21
        Associate = edHTTPTunnelPort
        Enabled = False
        Min = 1
        Max = 65535
        Position = 9080
        TabOrder = 9
        Thousands = False
        OnChanging = SpinChanging
      end
      object cbExcludeUnsuitableBridges: TCheckBox
        Left = 352
        Top = 354
        Width = 160
        Height = 17
        Caption = #1048#1089#1082#1083#1102#1095#1072#1090#1100' '#1085#1077#1087#1086#1076#1093#1086#1076#1103#1097#1080#1077
        Checked = True
        Enabled = False
        State = cbChecked
        TabOrder = 26
        OnClick = cbExcludeUnsuitableBridgesClick
      end
      object cbUseBridgesLimit: TCheckBox
        Left = 10
        Top = 356
        Width = 300
        Height = 14
        Caption = #1054#1075#1088#1072#1085#1080#1095#1080#1090#1100' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1080#1089#1087#1086#1083#1100#1079#1091#1077#1084#1099#1093' '#1084#1086#1089#1090#1086#1074
        Checked = True
        Enabled = False
        State = cbChecked
        TabOrder = 22
        OnClick = cbUseBridgesLimitClick
      end
      object edBridgesLimit: TEdit
        Left = 80
        Top = 376
        Width = 42
        Height = 21
        HelpType = htKeyword
        HelpContext = 2
        Enabled = False
        MaxLength = 3
        NumbersOnly = True
        PopupMenu = EditMenu
        TabOrder = 23
        Text = '8'
        OnChange = edBridgesLimitChange
      end
      object udBridgesLimit: TUpDown
        Tag = 2
        Left = 122
        Top = 376
        Width = 13
        Height = 21
        Associate = edBridgesLimit
        Enabled = False
        Min = 1
        Max = 256
        Position = 8
        TabOrder = 24
        Thousands = False
        OnClick = udBridgesLimitClick
      end
      object cbxBridgesPriority: TComboBox
        Left = 215
        Top = 376
        Width = 120
        Height = 21
        AutoDropDown = True
        Style = csDropDownList
        DoubleBuffered = False
        Enabled = False
        ItemIndex = 0
        ParentDoubleBuffered = False
        TabOrder = 25
        Text = #1055#1086#1088#1103#1076#1086#1082' '#1074' '#1089#1087#1080#1089#1082#1077
        OnChange = cbxBridgesPriorityChange
        Items.Strings = (
          #1055#1086#1088#1103#1076#1086#1082' '#1074' '#1089#1087#1080#1089#1082#1077
          #1057#1082#1086#1088#1086#1089#1090#1100' '#1082#1072#1085#1072#1083#1072
          #1055#1080#1085#1075' '#1076#1086' '#1084#1086#1089#1090#1072
          #1057#1083#1091#1095#1072#1081#1085#1099#1081)
      end
      object cbCacheNewBridges: TCheckBox
        Left = 352
        Top = 380
        Width = 155
        Height = 14
        Caption = #1050#1101#1096#1080#1088#1086#1074#1072#1090#1100' '#1085#1086#1074#1099#1077
        Checked = True
        Enabled = False
        State = cbChecked
        TabOrder = 27
        OnClick = cbCacheNewBridgesClick
      end
      object edMaxDirFails: TEdit
        Left = 705
        Top = 376
        Width = 42
        Height = 21
        Enabled = False
        MaxLength = 3
        NumbersOnly = True
        PopupMenu = EditMenu
        TabOrder = 31
        Text = '3'
        OnChange = EditChange
      end
      object udMaxDirFails: TUpDown
        Left = 747
        Top = 376
        Width = 13
        Height = 21
        Associate = edMaxDirFails
        Enabled = False
        Min = 1
        Max = 256
        Position = 3
        TabOrder = 32
        Thousands = False
        OnChanging = SpinChanging
      end
      object edBridgesCheckDelay: TEdit
        Left = 705
        Top = 353
        Width = 42
        Height = 21
        Enabled = False
        MaxLength = 3
        NumbersOnly = True
        PopupMenu = EditMenu
        TabOrder = 29
        Text = '15'
        OnChange = EditChange
      end
      object udBridgesCheckDelay: TUpDown
        Left = 747
        Top = 353
        Width = 13
        Height = 21
        Associate = edBridgesCheckDelay
        Enabled = False
        Min = 5
        Max = 300
        Increment = 5
        Position = 15
        TabOrder = 30
        Thousands = False
        OnChanging = SpinChanging
      end
      object edBridgesQueueSize: TEdit
        Left = 705
        Top = 399
        Width = 42
        Height = 21
        HelpType = htKeyword
        HelpContext = 2
        Enabled = False
        MaxLength = 3
        NumbersOnly = True
        PopupMenu = EditMenu
        TabOrder = 33
        Text = '128'
        OnChange = EditChange
      end
      object udBridgesQueueSize: TUpDown
        Tag = 2
        Left = 747
        Top = 399
        Width = 13
        Height = 21
        Associate = edBridgesQueueSize
        Enabled = False
        Min = 8
        Max = 512
        Increment = 8
        Position = 128
        TabOrder = 34
        Thousands = False
        OnChanging = SpinChanging
      end
      object cbScanNewBridges: TCheckBox
        Left = 368
        Top = 401
        Width = 165
        Height = 17
        Caption = #1057#1085#1072#1095#1072#1083#1072' '#1089#1082#1072#1085#1080#1088#1086#1074#1072#1090#1100' '#1087#1086#1088#1090#1099
        Checked = True
        Enabled = False
        State = cbChecked
        TabOrder = 28
        OnClick = OptionsChange
      end
      object cbxBridgesList: TComboBox
        Left = 240
        Top = 124
        Width = 126
        Height = 21
        AutoDropDown = True
        Style = csDropDownList
        DoubleBuffered = False
        ParentDoubleBuffered = False
        TabOrder = 19
        OnChange = cbxBridgesListChange
        OnCloseUp = cbxBridgesListCloseUp
        OnKeyDown = cbxBridgesListKeyDown
      end
      object cbxBridgesUniqueType: TComboBox
        Left = 215
        Top = 400
        Width = 120
        Height = 21
        AutoDropDown = True
        Style = csDropDownList
        DoubleBuffered = False
        Enabled = False
        ItemIndex = 0
        ParentDoubleBuffered = False
        TabOrder = 38
        Text = #1053#1077' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100
        OnChange = cbxBridgesUniqueTypeChange
        Items.Strings = (
          #1053#1077' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100
          #1061#1101#1096
          'IP-'#1072#1076#1088#1077#1089
          'CIDR /24'
          'CIDR /16'
          'CIDR /8'
          #1057#1090#1088#1072#1085#1072)
      end
    end
    object tsFilter: TTabSheet
      Caption = #1060#1080#1083#1100#1090#1088
      ImageIndex = 2
      object lbFilterMode: TLabel
        Left = 52
        Top = 8
        Width = 32
        Height = 13
        Alignment = taRightJustify
        Caption = #1056#1077#1078#1080#1084
        Transparent = True
      end
      object lbFilterCount: TLabel
        Left = 700
        Top = 8
        Width = 84
        Height = 13
        Alignment = taRightJustify
        Caption = #1055#1086#1082#1072#1079#1072#1085#1086': 0 '#1080#1079' 0'
        Transparent = True
      end
      object lbFilterEntry: TLabel
        Left = 392
        Top = 8
        Width = 6
        Height = 13
        Caption = '0'
        Transparent = True
      end
      object lbFilterMiddle: TLabel
        Left = 449
        Top = 8
        Width = 6
        Height = 13
        Caption = '0'
        Transparent = True
      end
      object lbFilterExit: TLabel
        Left = 507
        Top = 8
        Width = 6
        Height = 13
        Caption = '0'
        Transparent = True
      end
      object lbFilterExclude: TLabel
        Left = 560
        Top = 8
        Width = 6
        Height = 13
        Caption = '0'
        Transparent = True
      end
      object imFilterEntry: TImage
        Left = 373
        Top = 7
        Width = 16
        Height = 16
        ParentShowHint = False
        ShowHint = True
      end
      object imFilterMiddle: TImage
        Left = 430
        Top = 7
        Width = 16
        Height = 16
        ParentShowHint = False
        ShowHint = True
      end
      object imFilterExit: TImage
        Left = 486
        Top = 7
        Width = 16
        Height = 16
        ParentShowHint = False
        ShowHint = True
      end
      object imFilterExclude: TImage
        Left = 541
        Top = 7
        Width = 16
        Height = 16
        ParentShowHint = False
        ShowHint = True
      end
      object lbFilterTotalSelected: TLabel
        Left = 280
        Top = 8
        Width = 79
        Height = 13
        Alignment = taRightJustify
        Caption = #1042#1089#1077#1075#1086' '#1074#1099#1073#1088#1072#1085#1086':'
        Transparent = True
      end
      object cbxFilterMode: TComboBox
        Left = 87
        Top = 5
        Width = 150
        Height = 21
        AutoDropDown = True
        Style = csDropDownList
        DoubleBuffered = False
        ItemIndex = 1
        ParentDoubleBuffered = False
        TabOrder = 1
        Text = #1042#1099#1073#1088#1072#1085#1085#1099#1077' '#1089#1090#1088#1072#1085#1099
        OnChange = OptionsChange
        Items.Strings = (
          #1054#1090#1082#1083#1102#1095#1077#1085#1086
          #1042#1099#1073#1088#1072#1085#1085#1099#1077' '#1089#1090#1088#1072#1085#1099
          #1048#1079#1073#1088#1072#1085#1085#1099#1077' '#1091#1079#1083#1099)
      end
      object sgFilter: TStringGrid
        Tag = 1
        Left = -1
        Top = 31
        Width = 792
        Height = 447
        ColCount = 13
        DefaultRowHeight = 16
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goRowSelect, goThumbTracking, goFixedRowClick]
        ParentShowHint = False
        PopupMenu = mnFilter
        ScrollBars = ssVertical
        ShowHint = True
        TabOrder = 0
        OnDrawCell = sgFilterDrawCell
        OnExit = sgFilterExit
        OnFixedCellClick = sgFilterFixedCellClick
        OnKeyDown = sgFilterKeyDown
        OnKeyPress = sgFilterKeyPress
        OnMouseDown = sgFilterMouseDown
        OnMouseMove = sgFilterMouseMove
        OnSelectCell = sgFilterSelectCell
        ColWidths = (
          65
          66
          66
          64
          64
          64
          64
          64
          64
          64
          64
          64
          64)
      end
    end
    object tsServer: TTabSheet
      Caption = #1057#1077#1088#1074#1077#1088
      ImageIndex = 3
      object lbORPort: TLabel
        Left = 686
        Top = 30
        Width = 37
        Height = 13
        Alignment = taRightJustify
        Caption = #1057#1077#1088#1074#1077#1088
        Enabled = False
        Transparent = True
      end
      object lbNickname: TLabel
        Left = 98
        Top = 31
        Width = 19
        Height = 13
        Alignment = taRightJustify
        Caption = #1053#1080#1082
        Enabled = False
        Transparent = True
      end
      object lbServerMode: TLabel
        Left = 44
        Top = 9
        Width = 73
        Height = 13
        Alignment = taRightJustify
        Caption = #1056#1077#1078#1080#1084' '#1088#1072#1073#1086#1090#1099
        Transparent = True
      end
      object lbRelayBandwidthRate: TLabel
        Left = 482
        Top = 30
        Width = 44
        Height = 13
        Alignment = taRightJustify
        Caption = #1057#1088#1077#1076#1085#1103#1103
        Enabled = False
        Transparent = True
      end
      object lbRelayBandwidthBurst: TLabel
        Left = 477
        Top = 54
        Width = 49
        Height = 13
        Alignment = taRightJustify
        Caption = #1052#1072#1082#1089#1080#1084#1091#1084
        Enabled = False
        Transparent = True
      end
      object lbSpeed1: TLabel
        Left = 587
        Top = 30
        Width = 22
        Height = 13
        Caption = #1050#1041'/c'
        Enabled = False
        Transparent = True
      end
      object lbSpeed2: TLabel
        Left = 587
        Top = 54
        Width = 22
        Height = 13
        Caption = #1050#1041'/c'
        Enabled = False
        Transparent = True
      end
      object lbContactInfo: TLabel
        Left = 66
        Top = 55
        Width = 51
        Height = 13
        Alignment = taRightJustify
        Caption = #1050#1086#1085#1090#1072#1082#1090#1099
        Enabled = False
        Transparent = True
      end
      object lbExitPolicy: TLabel
        Left = 26
        Top = 127
        Width = 91
        Height = 13
        Alignment = taRightJustify
        Caption = #1055#1086#1083#1080#1090#1080#1082#1072' '#1074#1099#1093#1086#1076#1072
        Enabled = False
        Transparent = True
      end
      object lbMaxMemInQueues: TLabel
        Left = 269
        Top = 31
        Width = 49
        Height = 13
        Alignment = taRightJustify
        Caption = #1052#1072#1082#1089#1080#1084#1091#1084
        Enabled = False
        Transparent = True
      end
      object lbSizeMb: TLabel
        Left = 379
        Top = 31
        Width = 14
        Height = 13
        Caption = #1052#1041
        Enabled = False
        Transparent = True
      end
      object lbBridgeType: TLabel
        Left = 67
        Top = 79
        Width = 50
        Height = 13
        Alignment = taRightJustify
        Caption = #1058#1080#1087' '#1084#1086#1089#1090#1072
        Enabled = False
        Transparent = True
      end
      object lbNumCPUs: TLabel
        Left = 261
        Top = 78
        Width = 57
        Height = 13
        Alignment = taRightJustify
        Caption = #1052#1072#1082#1089'. '#1103#1076#1077#1088
        Enabled = False
        Transparent = True
      end
      object lbTransportPort: TLabel
        Left = 670
        Top = 54
        Width = 53
        Height = 13
        Alignment = taRightJustify
        Caption = #1058#1088#1072#1085#1089#1087#1086#1088#1090
        Enabled = False
        Transparent = True
      end
      object lbTotalMyFamily: TLabel
        Left = 739
        Top = 347
        Width = 41
        Height = 13
        Alignment = taRightJustify
        Caption = #1042#1089#1077#1075#1086': 0'
        Enabled = False
        Transparent = True
      end
      object lbPorts: TLabel
        Left = 688
        Top = 8
        Width = 93
        Height = 13
        Alignment = taRightJustify
        Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1087#1086#1088#1090#1086#1074
        Transparent = True
      end
      object lbAddress: TLabel
        Left = 32
        Top = 448
        Width = 31
        Height = 13
        Alignment = taRightJustify
        Caption = #1040#1076#1088#1077#1089
        Enabled = False
        Transparent = True
      end
      object lbBridgeDistribution: TLabel
        Left = 29
        Top = 103
        Width = 88
        Height = 13
        Alignment = taRightJustify
        Caption = #1056#1072#1089#1087#1088#1086#1089#1090#1088#1072#1085#1077#1085#1080#1077
        Enabled = False
        Transparent = True
      end
      object lbMaxAdvertisedBandwidth: TLabel
        Left = 448
        Top = 78
        Width = 78
        Height = 13
        Alignment = taRightJustify
        Caption = #1056#1077#1082#1083#1072#1084#1080#1088#1091#1077#1084#1072#1103
        Enabled = False
        Transparent = True
      end
      object lbSpeed4: TLabel
        Left = 587
        Top = 78
        Width = 22
        Height = 13
        Caption = #1050#1041'/c'
        Enabled = False
        Transparent = True
      end
      object sbUPnPTest: TSpeedButton
        Left = 759
        Top = 125
        Width = 22
        Height = 22
        ImageIndex = 20
        Images = lsMain
        Flat = True
        Transparent = False
        OnClick = sbUPnPTestClick
      end
      object edNickname: TEdit
        Left = 120
        Top = 28
        Width = 117
        Height = 21
        Enabled = False
        MaxLength = 19
        PopupMenu = EditMenu
        TabOrder = 1
        Text = 'Unnamed'
        OnChange = EditChange
      end
      object cbxServerMode: TComboBox
        Left = 120
        Top = 5
        Width = 117
        Height = 21
        AutoDropDown = True
        Style = csDropDownList
        DoubleBuffered = False
        ItemIndex = 0
        ParentDoubleBuffered = False
        TabOrder = 0
        Text = #1054#1090#1082#1083#1102#1095#1077#1085#1086
        OnChange = ServerControlsChange
        Items.Strings = (
          #1054#1090#1082#1083#1102#1095#1077#1085#1086
          #1056#1077#1090#1088#1072#1085#1089#1083#1103#1090#1086#1088
          #1042#1099#1093#1086#1076#1085#1086#1081' '#1091#1079#1077#1083
          #1052#1086#1089#1090)
      end
      object cbUseRelayBandwidth: TCheckBox
        Left = 446
        Top = 6
        Width = 160
        Height = 17
        Caption = #1054#1075#1088#1072#1085#1080#1095#1080#1090#1100' '#1089#1082#1086#1088#1086#1089#1090#1100
        Enabled = False
        TabOrder = 17
        OnClick = ServerControlsChange
      end
      object edContactInfo: TEdit
        Left = 120
        Top = 52
        Width = 117
        Height = 21
        TabStop = False
        Enabled = False
        MaxLength = 255
        PopupMenu = EditMenu
        TabOrder = 2
        OnChange = EditChange
      end
      object cbxExitPolicyType: TComboBox
        Left = 120
        Top = 124
        Width = 117
        Height = 21
        AutoDropDown = True
        Style = csDropDownList
        DoubleBuffered = False
        Enabled = False
        ItemIndex = 0
        ParentDoubleBuffered = False
        TabOrder = 5
        Text = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
        OnChange = ServerControlsChange
        Items.Strings = (
          #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
          #1054#1075#1088#1072#1085#1080#1095#1077#1085#1085#1072#1103
          #1053#1072#1089#1090#1088#1072#1080#1074#1072#1077#1084#1072#1103)
      end
      object cbUseUPnP: TCheckBox
        Left = 248
        Top = 129
        Width = 478
        Height = 17
        Caption = #1055#1099#1090#1072#1090#1100#1089#1103' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1085#1072#1089#1090#1088#1086#1080#1090#1100' '#1087#1077#1088#1077#1072#1076#1088#1077#1089#1072#1094#1080#1102' '#1087#1086#1088#1090#1086#1074
        Checked = True
        Enabled = False
        State = cbChecked
        TabOrder = 29
        OnClick = ServerControlsChange
      end
      object cbUseMaxMemInQueues: TCheckBox
        Left = 248
        Top = 7
        Width = 160
        Height = 17
        Caption = #1054#1075#1088#1072#1085#1080#1095#1080#1090#1100' '#1087#1072#1084#1103#1090#1100
        Enabled = False
        TabOrder = 11
        OnClick = ServerControlsChange
      end
      object cbxBridgeType: TComboBox
        Left = 120
        Top = 76
        Width = 117
        Height = 21
        AutoDropDown = True
        Style = csDropDownList
        DoubleBuffered = False
        Enabled = False
        ParentDoubleBuffered = False
        TabOrder = 3
        OnChange = cbxBridgeTypeChange
      end
      object meExitPolicy: TMemo
        Left = 10
        Top = 148
        Width = 227
        Height = 190
        Enabled = False
        Lines.Strings = (
          'accept *:80'
          'accept *:443'
          'reject *:*')
        PopupMenu = EditMenu
        ScrollBars = ssVertical
        TabOrder = 6
        WordWrap = False
        OnChange = OptionsChange
      end
      object cbUseNumCPUs: TCheckBox
        Left = 248
        Top = 54
        Width = 160
        Height = 17
        Caption = #1054#1075#1088#1072#1085#1080#1095#1080#1090#1100' '#1087#1088#1086#1094#1077#1089#1089#1086#1088
        Enabled = False
        TabOrder = 14
        OnClick = ServerControlsChange
      end
      object cbPublishServerDescriptor: TCheckBox
        Left = 248
        Top = 153
        Width = 478
        Height = 17
        Caption = #1055#1091#1073#1083#1080#1082#1086#1074#1072#1090#1100' '#1089#1077#1088#1074#1077#1088' '#1074' '#1082#1072#1090#1072#1083#1086#1075#1077' '#1088#1077#1090#1088#1072#1085#1089#1083#1103#1090#1086#1088#1086#1074
        Checked = True
        Enabled = False
        State = cbChecked
        TabOrder = 30
        OnClick = OptionsChange
      end
      object cbDirReqStatistics: TCheckBox
        Left = 248
        Top = 201
        Width = 478
        Height = 17
        Caption = #1057#1086#1073#1080#1088#1072#1090#1100' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1091' '#1079#1072#1087#1088#1086#1089#1086#1074' '#1082#1072#1090#1072#1083#1086#1075#1072
        Checked = True
        Enabled = False
        State = cbChecked
        TabOrder = 32
        OnClick = OptionsChange
      end
      object cbHiddenServiceStatistics: TCheckBox
        Left = 248
        Top = 177
        Width = 478
        Height = 17
        Caption = 
          #1057#1086#1073#1080#1088#1072#1090#1100' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1091' '#1086' '#1089#1074#1086#1077#1081' '#1088#1086#1083#1080' '#1074' '#1082#1072#1095#1077#1089#1090#1074#1077' '#1091#1079#1083#1072' '#1089#1082#1088#1099#1090#1086#1075#1086' '#1089#1077#1088#1074#1080#1089 +
          #1072
        Checked = True
        Enabled = False
        State = cbChecked
        TabOrder = 31
        OnClick = OptionsChange
      end
      object edORPort: TEdit
        Left = 726
        Top = 27
        Width = 42
        Height = 21
        Enabled = False
        MaxLength = 5
        NumbersOnly = True
        PopupMenu = EditMenu
        TabOrder = 24
        Text = '9001'
        OnChange = EditChange
      end
      object udORPort: TUpDown
        Left = 768
        Top = 27
        Width = 13
        Height = 21
        Associate = edORPort
        Enabled = False
        Min = 1
        Max = 65535
        Position = 9001
        TabOrder = 25
        Thousands = False
        OnChanging = SpinChanging
      end
      object edTransportPort: TEdit
        Left = 726
        Top = 51
        Width = 42
        Height = 21
        Enabled = False
        MaxLength = 5
        NumbersOnly = True
        PopupMenu = EditMenu
        TabOrder = 26
        Text = '443'
        OnChange = EditChange
      end
      object udTransportPort: TUpDown
        Left = 768
        Top = 51
        Width = 13
        Height = 21
        Associate = edTransportPort
        Enabled = False
        Min = 1
        Max = 65535
        Position = 443
        TabOrder = 27
        Thousands = False
        OnChanging = SpinChanging
      end
      object edMaxMemInQueues: TEdit
        Left = 321
        Top = 28
        Width = 42
        Height = 21
        Enabled = False
        MaxLength = 5
        NumbersOnly = True
        PopupMenu = EditMenu
        TabOrder = 12
        Text = '1024'
        OnChange = EditChange
      end
      object udMaxMemInQueues: TUpDown
        Left = 363
        Top = 28
        Width = 13
        Height = 21
        Associate = edMaxMemInQueues
        Enabled = False
        Min = 256
        Max = 32768
        Increment = 256
        Position = 1024
        TabOrder = 13
        Thousands = False
        OnChanging = SpinChanging
      end
      object edNumCPUs: TEdit
        Left = 321
        Top = 75
        Width = 42
        Height = 21
        Enabled = False
        MaxLength = 3
        NumbersOnly = True
        PopupMenu = EditMenu
        TabOrder = 15
        Text = '1'
        OnChange = EditChange
      end
      object udNumCPUs: TUpDown
        Left = 363
        Top = 75
        Width = 13
        Height = 21
        Associate = edNumCPUs
        Enabled = False
        Min = 1
        Max = 128
        Position = 1
        TabOrder = 16
        Thousands = False
        OnChanging = SpinChanging
      end
      object edRelayBandwidthRate: TEdit
        Left = 529
        Top = 27
        Width = 42
        Height = 21
        Enabled = False
        MaxLength = 7
        NumbersOnly = True
        PopupMenu = EditMenu
        TabOrder = 18
        Text = '1250'
        OnChange = EditChange
      end
      object udRelayBandwidthRate: TUpDown
        Left = 571
        Top = 27
        Width = 13
        Height = 21
        Associate = edRelayBandwidthRate
        Enabled = False
        Min = 250
        Max = 1048576
        Increment = 250
        Position = 1250
        TabOrder = 19
        Thousands = False
        OnChanging = SpinChanging
      end
      object edRelayBandwidthBurst: TEdit
        Left = 529
        Top = 51
        Width = 42
        Height = 21
        Enabled = False
        MaxLength = 7
        NumbersOnly = True
        PopupMenu = EditMenu
        TabOrder = 20
        Text = '2500'
        OnChange = EditChange
      end
      object udRelayBandwidthBurst: TUpDown
        Left = 571
        Top = 51
        Width = 13
        Height = 21
        Associate = edRelayBandwidthBurst
        Enabled = False
        Min = 250
        Max = 1048576
        Increment = 250
        Position = 2500
        TabOrder = 21
        Thousands = False
        OnChanging = SpinChanging
      end
      object meMyFamily: TMemo
        Left = 248
        Top = 368
        Width = 532
        Height = 98
        DoubleBuffered = True
        Enabled = False
        ParentDoubleBuffered = False
        PopupMenu = EditMenu
        ScrollBars = ssVertical
        TabOrder = 39
        WordWrap = False
        OnChange = meMyFamilyChange
      end
      object cbDirCache: TCheckBox
        Left = 248
        Top = 105
        Width = 180
        Height = 17
        Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1082#1101#1096' '#1082#1072#1090#1072#1083#1086#1075#1072
        Checked = True
        Enabled = False
        State = cbChecked
        TabOrder = 28
        OnMouseDown = cbDirCacheMouseDown
      end
      object cbAssumeReachable: TCheckBox
        Left = 248
        Top = 225
        Width = 478
        Height = 17
        Caption = #1054#1090#1082#1083#1102#1095#1080#1090#1100' '#1087#1088#1086#1074#1077#1088#1082#1091' '#1076#1086#1089#1090#1091#1087#1085#1086#1089#1090#1080' '#1089#1077#1088#1074#1077#1088#1072
        Enabled = False
        TabOrder = 33
        OnClick = OptionsChange
      end
      object cbUseAddress: TCheckBox
        Left = 10
        Top = 423
        Width = 222
        Height = 17
        Caption = #1047#1072#1076#1072#1090#1100' '#1074#1085#1077#1096#1085#1080#1081' '#1072#1076#1088#1077#1089' '#1074#1088#1091#1095#1085#1091#1102
        Enabled = False
        TabOrder = 9
        OnClick = ServerControlsChange
      end
      object edAddress: TEdit
        Left = 67
        Top = 445
        Width = 170
        Height = 21
        Enabled = False
        MaxLength = 255
        PopupMenu = EditMenu
        TabOrder = 10
        TextHint = 'IP-'#1072#1076#1088#1077#1089' '#1080#1083#1080' '#1080#1084#1103' '#1091#1079#1083#1072
        OnChange = EditChange
      end
      object cbUseMyFamily: TCheckBox
        Left = 248
        Top = 345
        Width = 350
        Height = 17
        Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1089#1077#1084#1077#1081#1089#1090#1074#1086
        Enabled = False
        TabOrder = 38
        OnClick = ServerControlsChange
      end
      object cbxBridgeDistribution: TComboBox
        Left = 120
        Top = 100
        Width = 117
        Height = 21
        AutoDropDown = True
        Style = csDropDownList
        DoubleBuffered = False
        Enabled = False
        ItemIndex = 0
        ParentDoubleBuffered = False
        TabOrder = 4
        Text = #1051#1102#1073#1086#1077
        OnChange = OptionsChange
        Items.Strings = (
          #1051#1102#1073#1086#1077
          'https'
          'e-mail'
          'Moat'
          #1053#1077' '#1088#1072#1089#1087#1088#1086#1089#1090#1088#1072#1085#1103#1090#1100)
      end
      object edMaxAdvertisedBandwidth: TEdit
        Left = 529
        Top = 75
        Width = 42
        Height = 21
        Enabled = False
        MaxLength = 7
        NumbersOnly = True
        PopupMenu = EditMenu
        TabOrder = 22
        Text = '2000'
        OnChange = EditChange
      end
      object udMaxAdvertisedBandwidth: TUpDown
        Left = 571
        Top = 75
        Width = 13
        Height = 21
        Associate = edMaxAdvertisedBandwidth
        Enabled = False
        Min = 250
        Max = 1048576
        Increment = 250
        Position = 2000
        TabOrder = 23
        Thousands = False
        OnChanging = SpinChanging
      end
      object cbUseServerTransportOptions: TCheckBox
        Left = 10
        Top = 345
        Width = 222
        Height = 17
        Caption = #1047#1072#1076#1072#1090#1100' '#1086#1087#1094#1080#1080' '#1090#1088#1072#1085#1089#1087#1086#1088#1090#1072
        Enabled = False
        TabOrder = 7
        OnClick = ServerControlsChange
      end
      object meServerTransportOptions: TMemo
        Left = 10
        Top = 368
        Width = 227
        Height = 48
        HelpType = htKeyword
        HelpContext = 3
        Enabled = False
        PopupMenu = EditMenu
        ScrollBars = ssVertical
        TabOrder = 8
        WantReturns = False
        OnChange = meServerTransportOptionsChange
        OnExit = meServerTransportOptionsExit
      end
      object cbUseOpenDNS: TCheckBox
        Left = 248
        Top = 249
        Width = 478
        Height = 17
        Caption = #1054#1087#1088#1077#1076#1077#1083#1103#1090#1100' '#1074#1085#1077#1096#1085#1080#1081' '#1072#1076#1088#1077#1089' '#1089#1077#1088#1074#1077#1088#1072' '#1095#1077#1088#1077#1079' OpenDNS'
        Checked = True
        Enabled = False
        State = cbChecked
        TabOrder = 34
        OnClick = cbUseOpenDNSClick
      end
      object cbUseOpenDNSOnlyWhenUnknown: TCheckBox
        Left = 264
        Top = 273
        Width = 462
        Height = 17
        Caption = #1058#1086#1083#1100#1082#1086' '#1077#1089#1083#1080' TOR '#1085#1077' '#1084#1086#1078#1077#1090' '#1086#1087#1088#1077#1076#1077#1083#1080#1090#1100' '#1077#1075#1086' '#1089#1072#1084
        Checked = True
        Enabled = False
        State = cbChecked
        TabOrder = 35
        OnClick = cbUseOpenDNSOnlyWhenUnknownClick
      end
      object cbIPv6Exit: TCheckBox
        Left = 264
        Top = 320
        Width = 334
        Height = 17
        Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1074#1099#1093#1086#1076' IPv6 '#1090#1088#1072#1092#1080#1082#1072
        Enabled = False
        TabOrder = 37
        OnClick = OptionsChange
      end
      object cbListenIPv6: TCheckBox
        Left = 248
        Top = 296
        Width = 350
        Height = 17
        Caption = #1055#1088#1086#1089#1083#1091#1096#1080#1074#1072#1090#1100' IPv6-'#1072#1076#1088#1077#1089#1072
        Enabled = False
        TabOrder = 36
        OnClick = ServerControlsChange
      end
    end
    object tsHs: TTabSheet
      Caption = #1057#1082#1088#1099#1090#1099#1081' '#1089#1077#1088#1074#1080#1089
      ImageIndex = 4
      object sgHsPorts: TStringGrid
        Tag = 6
        Left = 484
        Top = 11
        Width = 296
        Height = 342
        ColCount = 3
        DefaultRowHeight = 16
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goRowSelect, goThumbTracking]
        ParentShowHint = False
        PopupMenu = mnHs
        ScrollBars = ssVertical
        ShowHint = True
        TabOrder = 1
        OnDrawCell = sgHsPortsDrawCell
        OnEnter = sgHsPortsEnter
        OnKeyDown = sgHsPortsKeyDown
        OnMouseMove = sgHsPortsMouseMove
        OnSelectCell = sgHsPortsSelectCell
      end
      object sgHs: TStringGrid
        Tag = 5
        Left = 10
        Top = 11
        Width = 464
        Height = 342
        ColCount = 7
        DefaultRowHeight = 16
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goRowSelect, goThumbTracking]
        ParentShowHint = False
        PopupMenu = mnHs
        ScrollBars = ssVertical
        ShowHint = True
        TabOrder = 0
        OnDrawCell = sgHsDrawCell
        OnEnter = sgHsEnter
        OnKeyDown = sgHsKeyDown
        OnMouseMove = sgHsMouseMove
        OnSelectCell = sgHsSelectCell
        ColWidths = (
          64
          64
          64
          64
          64
          64
          64)
      end
      object gbHsEdit: TGroupBox
        Left = 10
        Top = 357
        Width = 770
        Height = 109
        Caption = #1055#1072#1085#1077#1083#1100' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1103
        TabOrder = 2
        object lbHsSocket: TLabel
          Left = 518
          Top = 22
          Width = 36
          Height = 13
          Alignment = taRightJustify
          Caption = #1057#1077#1088#1074#1080#1089
          Enabled = False
          Transparent = True
        end
        object lbHsVirtualPort: TLabel
          Left = 605
          Top = 50
          Width = 95
          Height = 13
          Alignment = taRightJustify
          Caption = #1042#1080#1088#1090#1091#1072#1083#1100#1085#1099#1081' '#1087#1086#1088#1090
          Enabled = False
          Transparent = True
        end
        object lbHsVersion: TLabel
          Left = 316
          Top = 22
          Width = 92
          Height = 13
          Alignment = taRightJustify
          Caption = #1042#1077#1088#1089#1080#1103' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
          Enabled = False
          Transparent = True
        end
        object lbHsNumIntroductionPoints: TLabel
          Left = 344
          Top = 50
          Width = 64
          Height = 13
          Alignment = taRightJustify
          Caption = #1058#1086#1095#1077#1082' '#1074#1093#1086#1076#1072
          Enabled = False
          Transparent = True
        end
        object lbHsMaxStreams: TLabel
          Left = 28
          Top = 77
          Width = 122
          Height = 13
          Alignment = taRightJustify
          Caption = #1057#1086#1077#1076#1080#1085#1077#1085#1080#1081' '#1085#1072' '#1094#1077#1087#1086#1095#1082#1091
          Enabled = False
          Transparent = True
        end
        object lbHsName: TLabel
          Left = 12
          Top = 22
          Width = 48
          Height = 13
          Alignment = taRightJustify
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          Enabled = False
          Transparent = True
        end
        object lbHsState: TLabel
          Left = 611
          Top = 78
          Width = 54
          Height = 13
          Alignment = taRightJustify
          Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
          Enabled = False
          Transparent = True
        end
        object cbxHsAddress: TComboBox
          Left = 557
          Top = 19
          Width = 142
          Height = 21
          AutoDropDown = True
          Style = csDropDownList
          DoubleBuffered = False
          Enabled = False
          ItemIndex = 0
          ParentDoubleBuffered = False
          TabOrder = 7
          Text = '127.0.0.1'
          OnChange = cbxHsAddressChange
          OnDropDown = cbxHsAddressDropDown
          Items.Strings = (
            '127.0.0.1')
        end
        object cbxHsVersion: TComboBox
          Left = 410
          Top = 19
          Width = 54
          Height = 21
          AutoDropDown = True
          Style = csDropDownList
          DoubleBuffered = False
          Enabled = False
          ItemIndex = 0
          ParentDoubleBuffered = False
          TabOrder = 4
          Text = '3'
          OnChange = cbxHsVersionChange
          Items.Strings = (
            '3')
        end
        object cbHsMaxStreams: TCheckBox
          Left = 12
          Top = 48
          Width = 213
          Height = 17
          Caption = #1054#1075#1088#1072#1085#1080#1095#1080#1090#1100' '#1095#1080#1089#1083#1086' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1081
          Enabled = False
          TabOrder = 1
          OnClick = cbHsMaxStreamsClick
        end
        object edHsName: TEdit
          Left = 62
          Top = 19
          Width = 145
          Height = 21
          Enabled = False
          MaxLength = 25
          PopupMenu = EditMenu
          TabOrder = 0
          OnChange = edHsChange
        end
        object edHsNumIntroductionPoints: TEdit
          Left = 410
          Top = 47
          Width = 42
          Height = 21
          HelpType = htKeyword
          HelpContext = 1
          Enabled = False
          MaxLength = 2
          NumbersOnly = True
          PopupMenu = EditMenu
          TabOrder = 5
          Text = '3'
          OnChange = edHsChange
        end
        object udHsNumIntroductionPoints: TUpDown
          Tag = 1
          Left = 452
          Top = 47
          Width = 13
          Height = 21
          Associate = edHsNumIntroductionPoints
          Enabled = False
          Min = 3
          Max = 20
          Position = 3
          TabOrder = 6
          Thousands = False
          OnMouseDown = udHsMouseDown
        end
        object edHsMaxStreams: TEdit
          Left = 153
          Top = 74
          Width = 42
          Height = 21
          HelpType = htKeyword
          HelpContext = 2
          Enabled = False
          MaxLength = 5
          NumbersOnly = True
          PopupMenu = EditMenu
          TabOrder = 2
          Text = '32'
          OnChange = edHsChange
        end
        object udHsMaxStreams: TUpDown
          Tag = 2
          Left = 195
          Top = 74
          Width = 13
          Height = 21
          Associate = edHsMaxStreams
          Enabled = False
          Min = 1
          Max = 65535
          Position = 32
          TabOrder = 3
          Thousands = False
          OnMouseDown = udHsMouseDown
        end
        object edHsRealPort: TEdit
          Left = 702
          Top = 19
          Width = 42
          Height = 21
          HelpType = htKeyword
          HelpContext = 3
          Enabled = False
          MaxLength = 5
          NumbersOnly = True
          PopupMenu = EditMenu
          TabOrder = 8
          Text = '80'
          OnChange = edHsChange
        end
        object udHsRealPort: TUpDown
          Tag = 3
          Left = 744
          Top = 19
          Width = 13
          Height = 21
          Associate = edHsRealPort
          Enabled = False
          Min = 1
          Max = 65535
          Position = 80
          TabOrder = 9
          Thousands = False
          OnMouseDown = udHsMouseDown
        end
        object edHsVirtualPort: TEdit
          Left = 702
          Top = 47
          Width = 42
          Height = 21
          HelpType = htKeyword
          HelpContext = 4
          Enabled = False
          MaxLength = 5
          NumbersOnly = True
          PopupMenu = EditMenu
          TabOrder = 10
          Text = '80'
          OnChange = edHsChange
        end
        object udHsVirtualPort: TUpDown
          Tag = 4
          Left = 744
          Top = 47
          Width = 13
          Height = 21
          Associate = edHsVirtualPort
          Enabled = False
          Min = 1
          Max = 65535
          Position = 80
          TabOrder = 11
          Thousands = False
          OnMouseDown = udHsMouseDown
        end
        object cbxHsState: TComboBox
          Left = 668
          Top = 75
          Width = 89
          Height = 21
          AutoDropDown = True
          Style = csDropDownList
          DoubleBuffered = False
          Enabled = False
          ItemIndex = 0
          ParentDoubleBuffered = False
          TabOrder = 12
          Text = #1042#1082#1083#1102#1095#1077#1085#1086
          OnChange = cbxHsStateChange
          Items.Strings = (
            #1042#1082#1083#1102#1095#1077#1085#1086
            #1042#1099#1082#1083#1102#1095#1077#1085#1086)
        end
      end
    end
    object tsLists: TTabSheet
      Caption = #1057#1087#1080#1089#1082#1080
      ImageIndex = 12
      object lbTotalNodesList: TLabel
        Left = 739
        Top = 31
        Width = 41
        Height = 13
        Alignment = taRightJustify
        Caption = #1042#1089#1077#1075#1086': 0'
        Transparent = True
      end
      object lbNodesListType: TLabel
        Left = 478
        Top = 31
        Width = 36
        Height = 13
        Alignment = taRightJustify
        Caption = #1057#1087#1080#1089#1086#1082
        Transparent = True
      end
      object lbNodesListTypeCaption: TLabel
        Left = 478
        Top = 9
        Width = 197
        Height = 13
        Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1089#1087#1080#1089#1086#1082' '#1076#1083#1103' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1103
        Transparent = True
      end
      object lbVanguardLayerType: TLabel
        AlignWithMargins = True
        Left = 209
        Top = 449
        Width = 119
        Height = 13
        Alignment = taRightJustify
        Caption = #1048#1079#1084#1077#1085#1103#1090#1100' '#1091#1079#1077#1083' '#1094#1077#1087#1086#1095#1082#1080
        Transparent = True
      end
      object lbTotalFallbackDirs: TLabel
        Left = 383
        Top = 241
        Width = 85
        Height = 13
        Alignment = taRightJustify
        Caption = #1044#1086#1089#1090#1091#1087#1085#1086': 0 '#1080#1079' 0'
        Enabled = False
        Transparent = True
      end
      object lbFallbackDirsType: TLabel
        Left = 24
        Top = 241
        Width = 18
        Height = 13
        Alignment = taRightJustify
        Caption = #1058#1080#1087
        Enabled = False
        Transparent = True
      end
      object lbSeconds4: TLabel
        Left = 202
        Top = 32
        Width = 21
        Height = 13
        Caption = #1089#1077#1082'.'
        Enabled = False
        Transparent = True
      end
      object lbTotalHosts: TLabel
        Left = 427
        Top = 32
        Width = 41
        Height = 13
        Alignment = taRightJustify
        Caption = #1042#1089#1077#1075#1086': 0'
        Enabled = False
        ShowAccelChar = False
        Transparent = True
      end
      object lbTrackHostExitsExpire: TLabel
        Left = 32
        Top = 32
        Width = 109
        Height = 13
        Alignment = taRightJustify
        Caption = #1052#1077#1085#1103#1090#1100' '#1087#1086' '#1080#1089#1090#1077#1095#1077#1085#1080#1080
        Enabled = False
        Transparent = True
      end
      object cbEnableNodesList: TCheckBox
        Left = 646
        Top = 30
        Width = 72
        Height = 17
        Caption = #1042#1082#1083#1102#1095#1080#1090#1100
        TabOrder = 11
        OnClick = cbEnableNodesListClick
      end
      object meNodesList: TMemo
        Left = 478
        Top = 55
        Width = 302
        Height = 412
        Enabled = False
        PopupMenu = EditMenu
        ScrollBars = ssVertical
        TabOrder = 12
        WordWrap = False
        OnChange = meNodesListChange
        OnExit = meNodesListExit
        OnKeyPress = meNodesListKeyPress
      end
      object cbxNodesListType: TComboBox
        Left = 518
        Top = 28
        Width = 122
        Height = 21
        AutoDropDown = True
        Style = csDropDownList
        DoubleBuffered = False
        ItemIndex = 3
        ParentDoubleBuffered = False
        TabOrder = 10
        Text = #1047#1072#1087#1088#1077#1097#1105#1085#1085#1099#1077' '#1091#1079#1083#1099
        OnChange = cbxNodesListTypeChange
        OnKeyDown = cbxNodesListTypeKeyDown
        Items.Strings = (
          #1042#1093#1086#1076#1085#1099#1077' '#1091#1079#1083#1099
          #1057#1088#1077#1076#1085#1080#1077' '#1091#1079#1083#1099
          #1042#1099#1093#1086#1076#1085#1099#1077' '#1091#1079#1083#1099
          #1047#1072#1087#1088#1077#1097#1105#1085#1085#1099#1077' '#1091#1079#1083#1099)
      end
      object cbUseHiddenServiceVanguards: TCheckBox
        Left = 10
        Top = 427
        Width = 310
        Height = 17
        Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1072#1074#1072#1085#1075#1072#1088#1076#1099' '#1076#1083#1103' '#1089#1082#1088#1099#1090#1099#1093' '#1089#1077#1088#1074#1080#1089#1086#1074
        Checked = True
        State = cbChecked
        TabOrder = 8
        OnClick = cbUseHiddenServiceVanguardsClick
      end
      object cbxVanguardLayerType: TComboBox
        Left = 332
        Top = 446
        Width = 136
        Height = 21
        AutoDropDown = True
        Style = csDropDownList
        DoubleBuffered = False
        ItemIndex = 0
        ParentDoubleBuffered = False
        TabOrder = 9
        Text = #1040#1074#1090#1086#1074#1099#1073#1086#1088
        OnChange = OptionsChange
        Items.Strings = (
          #1040#1074#1090#1086#1074#1099#1073#1086#1088
          #1058#1086#1083#1100#1082#1086' '#1074#1090#1086#1088#1086#1081
          #1058#1086#1083#1100#1082#1086' '#1090#1088#1077#1090#1080#1081
          #1042#1090#1086#1088#1086#1081' '#1080' '#1090#1088#1077#1090#1080#1081)
      end
      object cbUseFallbackDirs: TCheckBox
        Left = 10
        Top = 217
        Width = 320
        Height = 17
        Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1088#1077#1079#1077#1088#1074#1085#1099#1077' '#1082#1072#1090#1072#1083#1086#1075#1080' '#1088#1077#1090#1088#1072#1085#1089#1083#1103#1090#1086#1088#1086#1074
        TabOrder = 4
        OnClick = cbUseFallbackDirsClick
      end
      object meFallbackDirs: TMemo
        Left = 10
        Top = 264
        Width = 458
        Height = 150
        Enabled = False
        PopupMenu = EditMenu
        ScrollBars = ssVertical
        TabOrder = 7
        WordWrap = False
        OnChange = meFallbackDirsChange
        OnExit = meFallbackDirsExit
        OnKeyPress = meFallbackDirsKeyPress
      end
      object cbxFallbackDirsType: TComboBox
        Left = 44
        Top = 238
        Width = 119
        Height = 21
        AutoDropDown = True
        Style = csDropDownList
        DoubleBuffered = False
        Enabled = False
        ItemIndex = 0
        ParentDoubleBuffered = False
        TabOrder = 5
        Text = #1042#1089#1090#1088#1086#1077#1085#1085#1099#1077
        OnChange = cbxFallbackDirsTypeChange
        OnKeyDown = cbxFallbackDirsTypeKeyDown
        Items.Strings = (
          #1042#1089#1090#1088#1086#1077#1085#1085#1099#1077
          #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100#1089#1082#1080#1077)
      end
      object meTrackHostExits: TMemo
        Left = 10
        Top = 55
        Width = 458
        Height = 150
        Enabled = False
        PopupMenu = EditMenu
        ScrollBars = ssVertical
        TabOrder = 3
        WordWrap = False
        OnChange = meTrackHostExitsChange
      end
      object cbUseTrackHostExits: TCheckBox
        Left = 10
        Top = 8
        Width = 320
        Height = 17
        Caption = #1057#1086#1093#1088#1072#1085#1103#1090#1100' '#1074#1099#1093#1086#1076#1085#1086#1081' '#1091#1079#1077#1083' '#1076#1083#1103' '#1091#1082#1072#1079#1072#1085#1085#1099#1093' '#1072#1076#1088#1077#1089#1086#1074
        TabOrder = 0
        OnClick = cbUseTrackHostExitsClick
      end
      object edTrackHostExitsExpire: TEdit
        Left = 145
        Top = 29
        Width = 42
        Height = 21
        Enabled = False
        MaxLength = 7
        NumbersOnly = True
        PopupMenu = EditMenu
        TabOrder = 1
        Text = '1800'
        OnChange = EditChange
      end
      object udTrackHostExitsExpire: TUpDown
        Left = 187
        Top = 29
        Width = 13
        Height = 21
        Associate = edTrackHostExitsExpire
        Enabled = False
        Min = 10
        Max = 2592000
        Increment = 60
        Position = 1800
        TabOrder = 2
        Thousands = False
        OnChanging = SpinChanging
      end
      object cbExcludeUnsuitableFallbackDirs: TCheckBox
        Left = 169
        Top = 240
        Width = 152
        Height = 17
        Caption = #1048#1089#1082#1083#1102#1095#1072#1090#1100' '#1085#1077#1087#1086#1076#1093#1086#1076#1103#1097#1080#1077
        Checked = True
        Enabled = False
        State = cbChecked
        TabOrder = 6
        OnClick = cbExcludeUnsuitableFallbackDirsClick
      end
    end
    object tsOther: TTabSheet
      Caption = #1056#1072#1079#1085#1086#1077
      ImageIndex = 5
      object gbNetworkScanner: TGroupBox
        Left = 10
        Top = 5
        Width = 355
        Height = 461
        Caption = #1057#1077#1090#1077#1074#1086#1081' '#1089#1082#1072#1085#1077#1088
        TabOrder = 0
        object lbFullScanInterval: TLabel
          Left = 113
          Top = 334
          Width = 155
          Height = 13
          Alignment = taRightJustify
          Caption = #1055#1086#1083#1085#1086#1077' '#1089#1082#1072#1085#1080#1088#1086#1074#1072#1085#1080#1077' '#1082#1072#1078#1076#1099#1077
          Transparent = True
        end
        object lbHours1: TLabel
          Left = 329
          Top = 334
          Width = 10
          Height = 13
          Caption = #1095'.'
          Transparent = True
        end
        object lbPartialScanInterval: TLabel
          Left = 96
          Top = 358
          Width = 172
          Height = 13
          Alignment = taRightJustify
          Caption = #1063#1072#1089#1090#1080#1095#1085#1086#1077' '#1089#1082#1072#1085#1080#1088#1086#1074#1072#1085#1080#1077' '#1082#1072#1078#1076#1099#1077
          Transparent = True
        end
        object lbHours2: TLabel
          Left = 329
          Top = 358
          Width = 10
          Height = 13
          Caption = #1095'.'
          Transparent = True
        end
        object lbPartialScansCounts: TLabel
          Left = 76
          Top = 382
          Width = 192
          Height = 13
          Alignment = taRightJustify
          Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1095#1072#1089#1090#1080#1095#1085#1099#1093' '#1089#1082#1072#1085#1080#1088#1086#1074#1072#1085#1080#1081
          Transparent = True
        end
        object lbScanMaxThread: TLabel
          Left = 89
          Top = 191
          Width = 179
          Height = 13
          Alignment = taRightJustify
          Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1087#1086#1090#1086#1082#1086#1074' '#1089#1082#1072#1085#1080#1088#1086#1074#1072#1085#1080#1103
          Transparent = True
        end
        object lbScanPortAttempts: TLabel
          Left = 51
          Top = 95
          Width = 217
          Height = 13
          Alignment = taRightJustify
          Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1087#1086#1087#1099#1090#1086#1082' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1103' '#1089' '#1087#1086#1088#1090#1086#1084
          Transparent = True
        end
        object lbScanPortionSize: TLabel
          Left = 77
          Top = 239
          Width = 191
          Height = 13
          Alignment = taRightJustify
          Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1089#1082#1072#1085#1080#1088#1086#1074#1072#1085#1080#1081' '#1085#1072' '#1087#1086#1088#1094#1080#1102
          Transparent = True
        end
        object lbScanPingAttempts: TLabel
          Left = 85
          Top = 143
          Width = 183
          Height = 13
          Alignment = taRightJustify
          Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1087#1086#1087#1099#1090#1086#1082' '#1080#1079#1084#1077#1088#1080#1090#1100' '#1087#1080#1085#1075
          Transparent = True
        end
        object lbScanPortTimeout: TLabel
          Left = 111
          Top = 71
          Width = 157
          Height = 13
          Alignment = taRightJustify
          Caption = #1058#1072#1081#1084#1072#1091#1090' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1103' '#1082' '#1087#1086#1088#1090#1091
          Transparent = True
        end
        object lbMiliseconds2: TLabel
          Left = 328
          Top = 70
          Width = 15
          Height = 13
          Caption = #1084#1089'.'
          Transparent = True
        end
        object lbScanPingTimeout: TLabel
          Left = 150
          Top = 119
          Width = 118
          Height = 13
          Alignment = taRightJustify
          Caption = #1058#1072#1081#1084#1072#1091#1090' '#1087#1080#1085#1075'-'#1079#1072#1087#1088#1086#1089#1086#1074
          Transparent = True
        end
        object lbMiliseconds1: TLabel
          Left = 327
          Top = 118
          Width = 15
          Height = 13
          Caption = #1084#1089'.'
          Transparent = True
        end
        object lbDelayBetweenAttempts: TLabel
          Left = 122
          Top = 167
          Width = 146
          Height = 13
          Alignment = taRightJustify
          Caption = #1047#1072#1076#1077#1088#1078#1082#1072' '#1084#1077#1078#1076#1091' '#1087#1086#1087#1099#1090#1082#1072#1084#1080
          Transparent = True
        end
        object lbMiliseconds3: TLabel
          Left = 328
          Top = 166
          Width = 15
          Height = 13
          Caption = #1084#1089'.'
          Transparent = True
        end
        object lbScanPortionTimeout: TLabel
          Left = 130
          Top = 215
          Width = 138
          Height = 13
          Alignment = taRightJustify
          Caption = #1047#1072#1076#1077#1088#1078#1082#1072' '#1084#1077#1078#1076#1091' '#1087#1086#1088#1094#1080#1103#1084#1080
          Transparent = True
        end
        object lbMiliseconds4: TLabel
          Left = 328
          Top = 214
          Width = 15
          Height = 13
          Caption = #1084#1089'.'
          Transparent = True
        end
        object lbAutoScanType: TLabel
          Left = 23
          Top = 311
          Width = 183
          Height = 13
          Alignment = taRightJustify
          Caption = #1059#1079#1083#1099' '#1076#1083#1103' '#1095#1072#1089#1090#1080#1095#1085#1086#1075#1086' '#1089#1082#1072#1085#1080#1088#1086#1074#1072#1085#1080#1103
          Transparent = True
        end
        object lbAutoSelRoutersAfterScanType: TLabel
          Left = 38
          Top = 287
          Width = 168
          Height = 13
          Alignment = taRightJustify
          Caption = #1040#1074#1090#1086#1087#1086#1076#1073#1086#1088' '#1087#1086#1089#1083#1077' '#1089#1082#1072#1085#1080#1088#1086#1074#1072#1085#1080#1103
          Transparent = True
        end
        object cbAutoScanNewNodes: TCheckBox
          Left = 14
          Top = 262
          Width = 300
          Height = 17
          Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1072#1103' '#1087#1088#1086#1074#1077#1088#1082#1072' '#1087#1080#1085#1075#1072' '#1080' '#1076#1086#1089#1090#1091#1087#1085#1086#1089#1090#1080' '#1091#1079#1083#1086#1074
          Checked = True
          State = cbChecked
          TabOrder = 18
          OnClick = cbAutoScanNewNodesClick
        end
        object cbEnableDetectAliveNodes: TCheckBox
          Left = 14
          Top = 21
          Width = 300
          Height = 17
          Caption = #1042#1082#1083#1102#1095#1080#1090#1100' '#1087#1088#1086#1074#1077#1088#1082#1091' '#1076#1086#1089#1090#1091#1087#1085#1086#1089#1090#1080' '#1091#1079#1083#1086#1074
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = cbEnableDetectAliveNodesClick
        end
        object cbEnablePingMeasure: TCheckBox
          Left = 14
          Top = 44
          Width = 300
          Height = 17
          Caption = #1042#1082#1083#1102#1095#1080#1090#1100' '#1080#1079#1084#1077#1088#1077#1085#1080#1077' '#1087#1080#1085#1075#1072
          Checked = True
          State = cbChecked
          TabOrder = 1
          OnClick = cbEnablePingMeasureClick
        end
        object edFullScanInterval: TEdit
          Left = 271
          Top = 331
          Width = 42
          Height = 21
          MaxLength = 4
          NumbersOnly = True
          ParentShowHint = False
          PopupMenu = EditMenu
          ShowHint = True
          TabOrder = 21
          Text = '72'
          OnChange = EditChange
        end
        object udFullScanInterval: TUpDown
          Left = 313
          Top = 331
          Width = 13
          Height = 21
          Associate = edFullScanInterval
          Min = 3
          Max = 720
          Position = 72
          TabOrder = 22
          Thousands = False
          OnChanging = SpinChanging
        end
        object edPartialScanInterval: TEdit
          Left = 271
          Top = 355
          Width = 42
          Height = 21
          MaxLength = 5
          NumbersOnly = True
          ParentShowHint = False
          PopupMenu = EditMenu
          ShowHint = True
          TabOrder = 23
          Text = '12'
          OnChange = EditChange
        end
        object udPartialScanInterval: TUpDown
          Left = 313
          Top = 355
          Width = 13
          Height = 21
          Associate = edPartialScanInterval
          Min = 1
          Max = 360
          Position = 12
          TabOrder = 24
          Thousands = False
          OnChanging = SpinChanging
        end
        object edPartialScansCounts: TEdit
          Left = 271
          Top = 379
          Width = 42
          Height = 21
          MaxLength = 5
          NumbersOnly = True
          ParentShowHint = False
          PopupMenu = EditMenu
          ShowHint = True
          TabOrder = 25
          Text = '6'
          OnChange = EditChange
        end
        object udPartialScansCounts: TUpDown
          Left = 313
          Top = 379
          Width = 13
          Height = 21
          Associate = edPartialScansCounts
          Min = 1
          Max = 24
          Position = 6
          TabOrder = 26
          Thousands = False
          OnChanging = SpinChanging
        end
        object edScanMaxThread: TEdit
          Left = 271
          Top = 188
          Width = 42
          Height = 21
          MaxLength = 5
          NumbersOnly = True
          ParentShowHint = False
          PopupMenu = EditMenu
          ShowHint = True
          TabOrder = 12
          Text = '512'
          OnChange = EditChange
        end
        object udScanMaxThread: TUpDown
          Left = 313
          Top = 188
          Width = 13
          Height = 21
          Associate = edScanMaxThread
          Min = 32
          Max = 65535
          Increment = 32
          Position = 512
          TabOrder = 13
          Thousands = False
          OnChanging = SpinChanging
        end
        object edScanPortAttempts: TEdit
          Left = 271
          Top = 92
          Width = 42
          Height = 21
          MaxLength = 2
          NumbersOnly = True
          ParentShowHint = False
          PopupMenu = EditMenu
          ShowHint = True
          TabOrder = 4
          Text = '3'
          OnChange = EditChange
        end
        object udScanPortAttempts: TUpDown
          Left = 313
          Top = 92
          Width = 13
          Height = 21
          Associate = edScanPortAttempts
          Min = 1
          Max = 32
          Position = 3
          TabOrder = 5
          Thousands = False
          OnChanging = SpinChanging
        end
        object edScanPortionSize: TEdit
          Left = 271
          Top = 236
          Width = 42
          Height = 21
          MaxLength = 5
          NumbersOnly = True
          ParentShowHint = False
          PopupMenu = EditMenu
          ShowHint = True
          TabOrder = 16
          Text = '64'
          OnChange = EditChange
        end
        object udScanPortionSize: TUpDown
          Left = 313
          Top = 236
          Width = 13
          Height = 21
          Associate = edScanPortionSize
          Min = 8
          Max = 65535
          Increment = 8
          Position = 64
          TabOrder = 17
          Thousands = False
          OnChanging = SpinChanging
        end
        object edScanPingAttempts: TEdit
          Left = 271
          Top = 140
          Width = 42
          Height = 21
          MaxLength = 2
          NumbersOnly = True
          ParentShowHint = False
          PopupMenu = EditMenu
          ShowHint = True
          TabOrder = 8
          Text = '4'
          OnChange = EditChange
        end
        object udScanPingAttempts: TUpDown
          Left = 313
          Top = 140
          Width = 13
          Height = 21
          Associate = edScanPingAttempts
          Min = 1
          Max = 32
          Position = 4
          TabOrder = 9
          Thousands = False
          OnChanging = SpinChanging
        end
        object edScanPortTimeout: TEdit
          Left = 271
          Top = 68
          Width = 42
          Height = 21
          MaxLength = 5
          NumbersOnly = True
          ParentShowHint = False
          PopupMenu = EditMenu
          ShowHint = True
          TabOrder = 2
          Text = '3000'
          OnChange = EditChange
        end
        object udScanPortTimeout: TUpDown
          Left = 313
          Top = 68
          Width = 13
          Height = 21
          Associate = edScanPortTimeout
          Min = 1000
          Max = 60000
          Increment = 1000
          Position = 3000
          TabOrder = 3
          Thousands = False
          OnChanging = SpinChanging
        end
        object edScanPingTimeout: TEdit
          Left = 271
          Top = 116
          Width = 42
          Height = 21
          MaxLength = 5
          NumbersOnly = True
          ParentShowHint = False
          PopupMenu = EditMenu
          ShowHint = True
          TabOrder = 6
          Text = '2000'
          OnChange = EditChange
        end
        object udScanPingTimeout: TUpDown
          Left = 313
          Top = 116
          Width = 13
          Height = 21
          Associate = edScanPingTimeout
          Min = 1000
          Max = 30000
          Increment = 1000
          Position = 2000
          TabOrder = 7
          Thousands = False
          OnChanging = SpinChanging
        end
        object edDelayBetweenAttempts: TEdit
          Left = 271
          Top = 164
          Width = 42
          Height = 21
          MaxLength = 5
          NumbersOnly = True
          ParentShowHint = False
          PopupMenu = EditMenu
          ShowHint = True
          TabOrder = 10
          Text = '1000'
          OnChange = EditChange
        end
        object udDelayBetweenAttempts: TUpDown
          Left = 313
          Top = 164
          Width = 13
          Height = 21
          Associate = edDelayBetweenAttempts
          Min = 250
          Max = 60000
          Increment = 250
          Position = 1000
          TabOrder = 11
          Thousands = False
          OnChanging = SpinChanging
        end
        object edScanPortionTimeout: TEdit
          Left = 271
          Top = 212
          Width = 42
          Height = 21
          MaxLength = 4
          NumbersOnly = True
          ParentShowHint = False
          PopupMenu = EditMenu
          ShowHint = True
          TabOrder = 14
          Text = '10'
          OnChange = EditChange
        end
        object udScanPortionTimeout: TUpDown
          Left = 313
          Top = 212
          Width = 13
          Height = 21
          Associate = edScanPortionTimeout
          Min = 1
          Max = 1000
          Position = 10
          TabOrder = 15
          Thousands = False
          OnChanging = SpinChanging
        end
        object cbxAutoScanType: TComboBox
          Left = 209
          Top = 307
          Width = 116
          Height = 21
          AutoDropDown = True
          Style = csDropDownList
          DoubleBuffered = False
          ItemIndex = 0
          ParentDoubleBuffered = False
          TabOrder = 20
          Text = #1040#1074#1090#1086#1074#1099#1073#1086#1088
          OnChange = cbxAutoScanTypeChange
          Items.Strings = (
            #1040#1074#1090#1086#1074#1099#1073#1086#1088
            #1053#1086#1074#1099#1077' '#1080' '#1073#1077#1079' '#1086#1090#1074#1077#1090#1072
            #1053#1086#1074#1099#1077' '#1080' '#1078#1080#1074#1099#1077
            #1053#1086#1074#1099#1077' '#1080' '#1084#1086#1089#1090#1099
            #1058#1086#1083#1100#1082#1086' '#1085#1086#1074#1099#1077)
        end
        object cbxAutoSelRoutersAfterScanType: TComboBox
          Left = 209
          Top = 283
          Width = 116
          Height = 21
          AutoDropDown = True
          Style = csDropDownList
          DoubleBuffered = False
          ItemIndex = 0
          ParentDoubleBuffered = False
          TabOrder = 19
          Text = #1042#1099#1082#1083#1102#1095#1077#1085
          OnChange = OptionsChange
          Items.Strings = (
            #1042#1099#1082#1083#1102#1095#1077#1085
            #1051#1102#1073#1086#1075#1086
            #1055#1086#1083#1085#1086#1075#1086
            #1063#1072#1089#1090#1080#1095#1085#1086#1075#1086
            #1053#1086#1074#1099#1093' '#1091#1079#1083#1086#1074)
        end
      end
      object gbTransports: TGroupBox
        Left = 375
        Top = 5
        Width = 405
        Height = 260
        Caption = #1055#1086#1076#1082#1083#1102#1095#1072#1077#1084#1099#1077' '#1090#1088#1072#1085#1089#1087#1086#1088#1090#1099
        TabOrder = 1
        object lbTransports: TLabel
          Left = 23
          Top = 133
          Width = 61
          Height = 13
          Alignment = taRightJustify
          Caption = #1058#1088#1072#1085#1089#1087#1086#1088#1090#1099
          Enabled = False
          Transparent = True
        end
        object lbTransportsHandler: TLabel
          AlignWithMargins = True
          Left = 22
          Top = 157
          Width = 62
          Height = 13
          Alignment = taRightJustify
          Caption = #1054#1073#1088#1072#1073#1086#1090#1095#1080#1082
          Enabled = False
          Transparent = True
        end
        object lbTransportType: TLabel
          Left = 277
          Top = 133
          Width = 18
          Height = 13
          Alignment = taRightJustify
          Caption = #1058#1080#1087
          Enabled = False
          Transparent = True
        end
        object lbTransportState: TLabel
          Left = 241
          Top = 157
          Width = 54
          Height = 13
          Alignment = taRightJustify
          Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
          Enabled = False
          Transparent = True
        end
        object sgTransports: TStringGrid
          Tag = 6
          Left = 12
          Top = 18
          Width = 381
          Height = 109
          ColCount = 6
          DefaultRowHeight = 16
          FixedCols = 0
          RowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goRowSelect, goThumbTracking]
          ParentShowHint = False
          PopupMenu = mnTransports
          ScrollBars = ssVertical
          ShowHint = True
          TabOrder = 0
          OnDrawCell = sgTransportsDrawCell
          OnKeyDown = sgTransportsKeyDown
          OnMouseMove = sgTransportsMouseMove
          OnSelectCell = sgTransportsSelectCell
        end
        object edTransports: TEdit
          Left = 87
          Top = 130
          Width = 146
          Height = 21
          HelpType = htKeyword
          HelpContext = 1
          Enabled = False
          PopupMenu = EditMenu
          TabOrder = 1
          OnChange = edTransportsChange
        end
        object edTransportsHandler: TEdit
          Left = 87
          Top = 154
          Width = 146
          Height = 21
          HelpType = htKeyword
          HelpContext = 2
          Enabled = False
          PopupMenu = EditMenu
          TabOrder = 2
          OnChange = edTransportsChange
        end
        object meHandlerParams: TMemo
          Left = 87
          Top = 178
          Width = 306
          Height = 70
          HelpType = htKeyword
          HelpContext = 3
          Enabled = False
          PopupMenu = EditMenu
          ScrollBars = ssVertical
          TabOrder = 6
          WantReturns = False
          OnChange = edTransportsChange
        end
        object cbxTransportType: TComboBox
          Left = 298
          Top = 130
          Width = 95
          Height = 21
          AutoDropDown = True
          Style = csDropDownList
          DoubleBuffered = False
          Enabled = False
          ItemIndex = 0
          ParentDoubleBuffered = False
          TabOrder = 3
          Text = #1050#1083#1080#1077#1085#1090
          OnChange = cbxTransportTypeChange
          Items.Strings = (
            #1050#1083#1080#1077#1085#1090
            #1057#1077#1088#1074#1077#1088
            #1057#1086#1074#1084#1077#1097#1105#1085#1085#1099#1081)
        end
        object cbHandlerParamsState: TCheckBox
          Tag = 1
          Left = 3
          Top = 177
          Width = 80
          Height = 17
          BiDiMode = bdRightToLeft
          Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
          Enabled = False
          ParentBiDiMode = False
          TabOrder = 5
          OnClick = cbHandlerParamsStateClick
        end
        object cbxTransportState: TComboBox
          Left = 298
          Top = 153
          Width = 95
          Height = 21
          AutoDropDown = True
          Style = csDropDownList
          DoubleBuffered = False
          Enabled = False
          ItemIndex = 0
          ParentDoubleBuffered = False
          TabOrder = 4
          Text = #1040#1074#1090#1086#1074#1099#1073#1086#1088
          OnChange = cbxTransportStateChange
          Items.Strings = (
            #1040#1074#1090#1086#1074#1099#1073#1086#1088
            #1042#1082#1083#1102#1095#1077#1085#1086
            #1042#1099#1082#1083#1102#1095#1077#1085#1086)
        end
      end
      object gbAutoSelectRouters: TGroupBox
        Left = 375
        Top = 269
        Width = 405
        Height = 197
        Caption = #1040#1074#1090#1086#1087#1086#1076#1073#1086#1088' '#1088#1086#1091#1090#1077#1088#1086#1074
        TabOrder = 2
        object lbCount1: TLabel
          Left = 145
          Top = 23
          Width = 18
          Height = 13
          Caption = #1096#1090'.'
          Transparent = True
        end
        object lbCount2: TLabel
          Left = 145
          Top = 47
          Width = 18
          Height = 13
          Caption = #1096#1090'.'
          Transparent = True
        end
        object lbCount3: TLabel
          Left = 145
          Top = 71
          Width = 18
          Height = 13
          Caption = #1096#1090'.'
          Transparent = True
        end
        object lbAutoSelPriority: TLabel
          Left = 202
          Top = 21
          Width = 55
          Height = 13
          Alignment = taRightJustify
          Caption = #1055#1088#1080#1086#1088#1080#1090#1077#1090
          Transparent = True
        end
        object lbCount6: TLabel
          Left = 145
          Top = 95
          Width = 18
          Height = 13
          Caption = #1096#1090'.'
          Transparent = True
        end
        object lbAutoSelMaxPing: TLabel
          Left = 60
          Top = 143
          Width = 24
          Height = 13
          Alignment = taRightJustify
          Caption = #1055#1080#1085#1075
          Transparent = True
        end
        object lbAutoSelMinWeight: TLabel
          Left = 67
          Top = 119
          Width = 17
          Height = 13
          Alignment = taRightJustify
          Caption = #1042#1077#1089
          Transparent = True
        end
        object lbSpeed5: TLabel
          Left = 145
          Top = 119
          Width = 23
          Height = 13
          Caption = #1052#1041'/c'
          Transparent = True
        end
        object lbMiliseconds5: TLabel
          Left = 145
          Top = 143
          Width = 15
          Height = 13
          Caption = #1084#1089'.'
          Transparent = True
        end
        object lbAutoSelUniqueType: TLabel
          Left = 185
          Top = 45
          Width = 72
          Height = 13
          Alignment = taRightJustify
          Caption = #1059#1085#1080#1082#1072#1083#1100#1085#1086#1089#1090#1100
          Transparent = True
        end
        object sbAutoSelUniqueByNodeType: TSpeedButton
          Left = 373
          Top = 42
          Width = 21
          Height = 22
          AllowAllUp = True
          GroupIndex = 3
          ImageIndex = 31
          Images = lsMenus
          Flat = True
          ParentShowHint = False
          ShowHint = True
          OnClick = OptionsChange
        end
        object edAutoSelExitCount: TEdit
          Left = 87
          Top = 68
          Width = 42
          Height = 21
          MaxLength = 5
          NumbersOnly = True
          ParentShowHint = False
          PopupMenu = EditMenu
          ShowHint = True
          TabOrder = 7
          Text = '40'
          OnChange = EditChange
        end
        object udAutoSelExitCount: TUpDown
          Left = 129
          Top = 68
          Width = 13
          Height = 21
          Associate = edAutoSelExitCount
          Min = 1
          Max = 65535
          Increment = 5
          Position = 40
          TabOrder = 8
          Thousands = False
          OnChanging = SpinChanging
        end
        object edAutoSelMiddleCount: TEdit
          Left = 87
          Top = 44
          Width = 42
          Height = 21
          MaxLength = 5
          NumbersOnly = True
          ParentShowHint = False
          PopupMenu = EditMenu
          ShowHint = True
          TabOrder = 4
          Text = '60'
          OnChange = EditChange
        end
        object udAutoSelMiddleCount: TUpDown
          Left = 129
          Top = 44
          Width = 13
          Height = 21
          Associate = edAutoSelMiddleCount
          Min = 1
          Max = 65535
          Increment = 5
          Position = 60
          TabOrder = 5
          Thousands = False
          OnChanging = SpinChanging
        end
        object edAutoSelEntryCount: TEdit
          Left = 87
          Top = 20
          Width = 42
          Height = 21
          MaxLength = 5
          NumbersOnly = True
          ParentShowHint = False
          PopupMenu = EditMenu
          ShowHint = True
          TabOrder = 1
          Text = '20'
          OnChange = EditChange
        end
        object udAutoSelEntryCount: TUpDown
          Left = 129
          Top = 20
          Width = 13
          Height = 21
          Associate = edAutoSelEntryCount
          Min = 1
          Max = 65535
          Increment = 5
          Position = 20
          TabOrder = 2
          Thousands = False
          OnChanging = SpinChanging
        end
        object cbAutoSelNodesWithPingOnly: TCheckBox
          Left = 178
          Top = 153
          Width = 222
          Height = 17
          Caption = #1058#1086#1083#1100#1082#1086' '#1086#1090#1074#1077#1095#1072#1102#1097#1080#1077' '#1085#1072' '#1087#1080#1085#1075
          Checked = True
          Enabled = False
          State = cbChecked
          TabOrder = 22
          OnClick = OptionsChange
        end
        object cbAutoSelStableOnly: TCheckBox
          Left = 178
          Top = 117
          Width = 222
          Height = 17
          Caption = #1058#1086#1083#1100#1082#1086' '#1089#1090#1072#1073#1080#1083#1100#1085#1099#1077
          TabOrder = 20
          OnClick = OptionsChange
        end
        object cbAutoSelFilterCountriesOnly: TCheckBox
          Left = 178
          Top = 99
          Width = 222
          Height = 17
          Caption = #1058#1086#1083#1100#1082#1086' '#1089#1090#1088#1072#1085#1099' '#1080#1079' '#1092#1080#1083#1100#1090#1088#1072
          Checked = True
          State = cbChecked
          TabOrder = 19
          OnClick = OptionsChange
        end
        object cbxAutoSelPriority: TComboBox
          Left = 260
          Top = 18
          Width = 134
          Height = 21
          AutoDropDown = True
          Style = csDropDownList
          DoubleBuffered = False
          ItemIndex = 0
          ParentDoubleBuffered = False
          TabOrder = 16
          Text = #1057#1073#1072#1083#1072#1085#1089#1080#1088#1086#1074#1072#1085#1085#1099#1081
          OnChange = AutoSelOptionsUpdate
          Items.Strings = (
            #1057#1073#1072#1083#1072#1085#1089#1080#1088#1086#1074#1072#1085#1085#1099#1081
            #1042#1077#1089' '#1074' '#1082#1086#1085#1089#1077#1085#1089#1091#1089#1077
            #1055#1080#1085#1075' '#1076#1086' '#1091#1079#1083#1072
            #1057#1083#1091#1095#1072#1081#1085#1099#1081)
        end
        object cbAutoSelMiddleNodesWithoutDir: TCheckBox
          Left = 178
          Top = 81
          Width = 222
          Height = 17
          Caption = #1057#1088#1077#1076#1085#1080#1077' '#1091#1079#1083#1099' '#1073#1077#1079' '#1082#1072#1090#1072#1083#1086#1075#1086#1074
          Checked = True
          State = cbChecked
          TabOrder = 18
          OnClick = OptionsChange
        end
        object edAutoSelFallbackDirCount: TEdit
          Left = 87
          Top = 92
          Width = 42
          Height = 21
          MaxLength = 5
          NumbersOnly = True
          ParentShowHint = False
          PopupMenu = EditMenu
          ShowHint = True
          TabOrder = 10
          Text = '20'
          OnChange = EditChange
        end
        object udAutoSelFallbackDirCount: TUpDown
          Left = 129
          Top = 92
          Width = 13
          Height = 21
          Associate = edAutoSelFallbackDirCount
          Min = 1
          Max = 65535
          Increment = 5
          Position = 20
          TabOrder = 11
          Thousands = False
          OnChanging = SpinChanging
        end
        object cbAutoSelFallbackDirNoLimit: TCheckBox
          Left = 178
          Top = 63
          Width = 222
          Height = 17
          Caption = #1053#1077' '#1086#1075#1088#1072#1085#1080#1095#1080#1074#1072#1090#1100' '#1087#1086#1076#1073#1086#1088' '#1082#1072#1090#1072#1083#1086#1075#1086#1074
          Checked = True
          State = cbChecked
          TabOrder = 17
          OnClick = OptionsChange
        end
        object cbAutoSelEntryEnabled: TCheckBox
          Tag = 1
          Left = 3
          Top = 22
          Width = 80
          Height = 17
          BiDiMode = bdRightToLeft
          Caption = #1042#1093#1086#1076#1085#1099#1077
          Checked = True
          ParentBiDiMode = False
          State = cbChecked
          TabOrder = 0
          OnClick = AutoSelOptionsUpdate
        end
        object cbAutoSelMiddleEnabled: TCheckBox
          Tag = 2
          Left = 3
          Top = 46
          Width = 80
          Height = 17
          BiDiMode = bdRightToLeft
          Caption = #1057#1088#1077#1076#1085#1080#1077
          Checked = True
          ParentBiDiMode = False
          State = cbChecked
          TabOrder = 3
          OnClick = AutoSelOptionsUpdate
        end
        object cbAutoSelExitEnabled: TCheckBox
          Tag = 4
          Left = 3
          Top = 70
          Width = 80
          Height = 17
          BiDiMode = bdRightToLeft
          Caption = #1042#1099#1093#1086#1076#1085#1099#1077
          Checked = True
          ParentBiDiMode = False
          State = cbChecked
          TabOrder = 6
          OnClick = AutoSelOptionsUpdate
        end
        object cbAutoSelFallbackDirEnabled: TCheckBox
          Tag = 8
          Left = 3
          Top = 94
          Width = 80
          Height = 17
          BiDiMode = bdRightToLeft
          Caption = #1050#1072#1090#1072#1083#1086#1075#1080
          Checked = True
          ParentBiDiMode = False
          State = cbChecked
          TabOrder = 9
          OnClick = AutoSelOptionsUpdate
        end
        object edAutoSelMaxPing: TEdit
          Left = 87
          Top = 140
          Width = 42
          Height = 21
          MaxLength = 5
          NumbersOnly = True
          ParentShowHint = False
          PopupMenu = EditMenu
          ShowHint = True
          TabOrder = 14
          Text = '200'
          OnChange = EditChange
        end
        object udAutoSelMaxPing: TUpDown
          Left = 129
          Top = 140
          Width = 13
          Height = 21
          Associate = edAutoSelMaxPing
          Min = 1
          Max = 60000
          Increment = 50
          Position = 200
          TabOrder = 15
          Thousands = False
          OnChanging = SpinChanging
        end
        object edAutoSelMinWeight: TEdit
          Left = 87
          Top = 116
          Width = 42
          Height = 21
          MaxLength = 5
          NumbersOnly = True
          ParentShowHint = False
          PopupMenu = EditMenu
          ShowHint = True
          TabOrder = 12
          Text = '10'
          OnChange = EditChange
        end
        object udAutoSelMinWeight: TUpDown
          Left = 129
          Top = 116
          Width = 13
          Height = 21
          Associate = edAutoSelMinWeight
          Max = 10240
          Increment = 5
          Position = 10
          TabOrder = 13
          Thousands = False
          OnChanging = SpinChanging
        end
        object cbAutoSelConfluxOnly: TCheckBox
          Left = 178
          Top = 135
          Width = 222
          Height = 17
          Caption = #1058#1086#1083#1100#1082#1086' '#1089' '#1087#1086#1076#1076#1077#1088#1078#1082#1086#1081' '#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
          TabOrder = 21
          OnClick = OptionsChange
        end
        object cbxAutoSelUniqueType: TComboBox
          Left = 260
          Top = 42
          Width = 110
          Height = 21
          AutoDropDown = True
          Style = csDropDownList
          DoubleBuffered = False
          ItemIndex = 4
          ParentDoubleBuffered = False
          TabOrder = 23
          Text = 'CIDR /16'
          OnChange = AutoSelOptionsUpdate
          Items.Strings = (
            #1053#1077' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100
            #1061#1101#1096
            'IP-'#1072#1076#1088#1077#1089
            'CIDR /24'
            'CIDR /16'
            'CIDR /8'
            #1057#1090#1088#1072#1085#1072)
        end
      end
    end
  end
  object btnApplyOptions: TButton
    Left = 642
    Top = 576
    Width = 72
    Height = 19
    Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 6
    OnClick = btnApplyOptionsClick
  end
  object btnCancelOptions: TButton
    Left = 720
    Top = 576
    Width = 72
    Height = 19
    Caption = #1054#1090#1084#1077#1085#1072
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 7
    OnClick = btnCancelOptionsClick
  end
  object tiTray: TTrayIcon
    Icons = lsTray
    PopupMenu = mnTray
    OnMouseDown = tiTrayMouseDown
    Left = 721
    Top = 336
  end
  object mnTray: TPopupMenu
    AutoHotkeys = maManual
    Images = lsMenus
    Left = 273
    Top = 1
    object miChangeCircuit: TMenuItem
      Caption = #1057#1084#1077#1085#1080#1090#1100' '#1094#1077#1087#1086#1095#1082#1091
      Enabled = False
      ImageIndex = 7
      OnClick = miChangeCircuitClick
    end
    object miDelimiter5: TMenuItem
      Caption = '-'
    end
    object miSwitchTor: TMenuItem
      Caption = #1057#1090#1072#1088#1090
      ImageIndex = 0
      OnClick = miSwitchTorClick
    end
    object miDelimiter1: TMenuItem
      Caption = '-'
    end
    object miShowStatus: TMenuItem
      Caption = #1057#1090#1072#1090#1091#1089
      ImageIndex = 36
      OnClick = miShowStatusClick
    end
    object miShowCircuits: TMenuItem
      Caption = #1062#1077#1087#1086#1095#1082#1080
      ImageIndex = 20
      OnClick = miShowCircuitsClick
    end
    object miShowRouters: TMenuItem
      Caption = #1056#1086#1091#1090#1077#1088#1099
      ImageIndex = 37
      OnClick = miShowRoutersClick
    end
    object miDelimiter15: TMenuItem
      Caption = '-'
    end
    object miShowOptions: TMenuItem
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      ImageIndex = 4
      OnClick = miShowOptionsClick
    end
    object miShowLog: TMenuItem
      Caption = #1046#1091#1088#1085#1072#1083
      ImageIndex = 5
      OnClick = miShowLogClick
    end
    object miDelimiter2: TMenuItem
      Caption = '-'
    end
    object miAbout: TMenuItem
      Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
      ImageIndex = 45
      OnClick = miAboutClick
    end
    object miExit: TMenuItem
      Caption = #1042#1099#1093#1086#1076
      ImageIndex = 6
      OnClick = miExitClick
    end
  end
  object tmUpdateIp: TTimer
    Enabled = False
    OnTimer = tmUpdateIpTimer
    Left = 672
    Top = 113
  end
  object mnLog: TPopupMenu
    AutoHotkeys = maManual
    Images = lsMenus
    OnPopup = mnLogPopup
    Left = 338
    Top = 1
    object miLogOptions: TMenuItem
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      ImageIndex = 11
      object miWriteLogFile: TMenuItem
        AutoCheck = True
        Caption = #1047#1072#1087#1080#1089#1099#1074#1072#1090#1100' '#1074' '#1092#1072#1081#1083
        Checked = True
        OnClick = miWriteLogFileClick
      end
      object miLogSeparate: TMenuItem
        Caption = #1056#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1092#1072#1081#1083#1072' '#1078#1091#1088#1085#1072#1083#1072
        object miLogSeparateNone: TMenuItem
          Caption = #1053#1077' '#1088#1072#1079#1076#1077#1083#1103#1090#1100
          RadioItem = True
          OnClick = SelectLogSeparater
        end
        object miLogSeparateMonth: TMenuItem
          Tag = 1
          Caption = #1055#1086' '#1084#1077#1089#1103#1094#1072#1084
          Checked = True
          RadioItem = True
          OnClick = SelectLogSeparater
        end
        object miLogSeparateWeek: TMenuItem
          Tag = 2
          Caption = #1055#1086' '#1085#1077#1076#1077#1083#1103#1084
          RadioItem = True
          OnClick = SelectLogSeparater
        end
        object miLogSeparateDay: TMenuItem
          Tag = 3
          Caption = #1055#1086' '#1076#1085#1103#1084
          RadioItem = True
          OnClick = SelectLogSeparater
        end
      end
      object miLogAutoDelType: TMenuItem
        Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1086#1077' '#1091#1076#1072#1083#1077#1085#1080#1077' '#1078#1091#1088#1085#1072#1083#1086#1074
        object miLogDelNever: TMenuItem
          Tag = -1
          Caption = #1053#1080#1082#1086#1075#1076#1072
          Checked = True
          RadioItem = True
          OnClick = SelectLogAutoDelInterval
        end
        object miLogDelEvery: TMenuItem
          Caption = #1055#1088#1080' '#1082#1072#1078#1076#1086#1084' '#1079#1072#1087#1091#1089#1082#1077
          RadioItem = True
          OnClick = SelectLogAutoDelInterval
        end
        object miDelimiter44: TMenuItem
          Caption = '-'
        end
        object miLogDelOlderThan: TMenuItem
          Caption = #1050#1086#1090#1086#1088#1099#1077' '#1089#1090#1072#1088#1096#1077', '#1095#1077#1084'...'
          ImageIndex = 58
        end
        object miLogDel1d: TMenuItem
          Tag = 24
          Caption = '1 '#1076#1077#1085#1100
          RadioItem = True
          OnClick = SelectLogAutoDelInterval
        end
        object miLogDel3d: TMenuItem
          Tag = 72
          Caption = '3 '#1076#1085#1103
          RadioItem = True
          OnClick = SelectLogAutoDelInterval
        end
        object miLogDel1w: TMenuItem
          Tag = 168
          Caption = '1 '#1085#1077#1076#1077#1083#1103
          RadioItem = True
          OnClick = SelectLogAutoDelInterval
        end
        object miLogDel2w: TMenuItem
          Tag = 336
          Caption = '2 '#1085#1077#1076#1077#1083#1080
          RadioItem = True
          OnClick = SelectLogAutoDelInterval
        end
        object miLogDel1m: TMenuItem
          Tag = 730
          Caption = '1 '#1084#1077#1089#1103#1094
          RadioItem = True
          OnClick = SelectLogAutoDelInterval
        end
        object miLogDel3m: TMenuItem
          Tag = 2190
          Caption = '3 '#1084#1077#1089#1103#1094#1072
          RadioItem = True
          OnClick = SelectLogAutoDelInterval
        end
        object miLogDel6m: TMenuItem
          Tag = 4380
          Caption = '6 '#1084#1077#1089#1103#1094#1077#1074
          RadioItem = True
          OnClick = SelectLogAutoDelInterval
        end
        object miLogDel1y: TMenuItem
          Tag = 8760
          Caption = '1 '#1075#1086#1076
          RadioItem = True
          OnClick = SelectLogAutoDelInterval
        end
      end
      object miDelimiter59: TMenuItem
        Caption = '-'
      end
      object miAutoClear: TMenuItem
        AutoCheck = True
        Caption = #1054#1095#1080#1097#1072#1090#1100' '#1087#1088#1080' '#1082#1072#1078#1076#1086#1084' '#1079#1072#1087#1091#1089#1082#1077
        Checked = True
        OnClick = miAutoClearClick
      end
      object miScrollBars: TMenuItem
        Caption = #1055#1086#1083#1086#1089#1072' '#1087#1088#1086#1082#1088#1091#1090#1082#1080
        object miSbVertical: TMenuItem
          Caption = #1042#1077#1088#1090#1080#1082#1072#1083#1100#1085#1072#1103
          Checked = True
          RadioItem = True
          OnClick = SelectLogScrollbar
        end
        object miSbHorizontal: TMenuItem
          Tag = 1
          Caption = #1043#1086#1088#1080#1079#1086#1085#1090#1072#1083#1100#1085#1072#1103
          RadioItem = True
          OnClick = SelectLogScrollbar
        end
        object miSbBoth: TMenuItem
          Tag = 2
          Caption = #1042#1089#1077
          RadioItem = True
          OnClick = SelectLogScrollbar
        end
        object miSbNone: TMenuItem
          Tag = 3
          Caption = #1053#1077#1090
          RadioItem = True
          OnClick = SelectLogScrollbar
        end
      end
      object miDelimiter6: TMenuItem
        Caption = '-'
      end
      object miOpenFileLog: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100' '#1092#1072#1081#1083' '#1078#1091#1088#1085#1072#1083#1072
        ImageIndex = 19
        OnClick = miOpenFileLogClick
      end
      object miOpenLogsFolder: TMenuItem
        Caption = #1055#1077#1088#1077#1081#1090#1080' '#1074' '#1082#1072#1090#1072#1083#1086#1075' '#1078#1091#1088#1085#1072#1083#1086#1074
        ImageIndex = 39
        ShortCut = 16452
        OnClick = miOpenLogsFolderClick
      end
    end
    object miDelimiter3: TMenuItem
      Caption = '-'
    end
    object miLogCopy: TMenuItem
      Tag = 2
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100
      ImageIndex = 12
      ShortCut = 16451
      OnClick = EditMenuClick
    end
    object miLogSelectAll: TMenuItem
      Tag = 4
      Caption = #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1089#1105
      ImageIndex = 16
      ShortCut = 16449
      OnClick = EditMenuClick
    end
    object miLogFind: TMenuItem
      Tag = 7
      Caption = #1053#1072#1081#1090#1080'...'
      ImageIndex = 55
      ShortCut = 16454
      OnClick = EditMenuClick
    end
    object miDelimiter4: TMenuItem
      Caption = '-'
    end
    object miLogClear: TMenuItem
      Tag = 5
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      ImageIndex = 13
      OnClick = EditMenuClick
    end
  end
  object lsFlags: TImageList
    ColorDepth = cd24Bit
    Height = 13
    Width = 20
    Left = 722
    Top = 114
  end
  object lsButtons: TImageList
    ColorDepth = cd32Bit
    Height = 20
    Width = 20
    Left = 721
    Top = 245
  end
  object lsMenus: TImageList
    ColorDepth = cd32Bit
    Left = 722
    Top = 202
  end
  object mnChangeCircuit: TPopupMenu
    AutoHotkeys = maManual
    AutoPopup = False
    Images = lsMenus
    OnPopup = mnChangeCircuitPopup
    Left = 435
    Top = 1
    object miCacheOperations: TMenuItem
      Caption = #1054#1087#1077#1088#1072#1094#1080#1080' '#1089' '#1082#1101#1096#1077#1084
      object miClearDNSCache: TMenuItem
        Caption = #1054#1095#1080#1089#1090#1080#1090#1100' DNS-'#1082#1101#1096
        OnClick = miClearDNSCacheClick
      end
      object miClearServerCache: TMenuItem
        Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1089#1077#1088#1074#1077#1088#1085#1099#1081' '#1082#1101#1096
        OnClick = miClearServerCacheClick
      end
      object miDelimiter51: TMenuItem
        Caption = '-'
      end
      object miClearBridgeCacheUnnecessary: TMenuItem
        Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1082#1101#1096' '#1086#1090' '#1085#1077#1085#1091#1078#1085#1099#1093' '#1084#1086#1089#1090#1086#1074
        OnClick = ClearBridgesCache
      end
      object miClearBridgesCacheAll: TMenuItem
        Tag = 1
        Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1082#1101#1096' '#1074#1089#1077#1093' '#1084#1086#1089#1090#1086#1074
        OnClick = ClearBridgesCache
      end
      object miDelimiter73: TMenuItem
        Caption = '-'
      end
      object miClearPingCache: TMenuItem
        Tag = 1
        Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1082#1101#1096' '#1087#1080#1085#1075'-'#1079#1072#1087#1088#1086#1089#1086#1074
        OnClick = ClearScannerCacheClick
      end
      object miClearAliveCache: TMenuItem
        Tag = 2
        Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1082#1101#1096' '#1076#1086#1089#1090#1091#1087#1085#1086#1089#1090#1080' '#1091#1079#1083#1086#1074
        OnClick = ClearScannerCacheClick
      end
      object miClearUnusedNetworkCache: TMenuItem
        Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1085#1077#1080#1089#1087#1086#1083#1100#1079#1091#1077#1084#1099#1081' '#1089#1077#1090#1077#1074#1086#1081' '#1082#1101#1096
        OnClick = miClearUnusedNetworkCacheClick
      end
      object miDelimiter60: TMenuItem
        Caption = '-'
      end
      object miResetScannerSchedule: TMenuItem
        Caption = #1057#1073#1088#1086#1089#1080#1090#1100' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1077' '#1089#1082#1072#1085#1080#1088#1086#1074#1072#1085#1080#1103' '#1091#1079#1083#1086#1074
        OnClick = miResetScannerScheduleClick
      end
    end
    object miStartScan: TMenuItem
      Caption = #1047#1072#1087#1091#1089#1090#1080#1090#1100' '#1089#1082#1072#1085#1080#1088#1086#1074#1072#1085#1080#1077
      object miScanNewNodes: TMenuItem
        Tag = 1
        Caption = #1053#1086#1074#1099#1077' '#1091#1079#1083#1099
        OnClick = StartScannerManual
      end
      object miScanNonResponsed: TMenuItem
        Tag = 2
        Caption = #1053#1077' '#1086#1090#1074#1077#1095#1072#1102#1097#1080#1077' '#1091#1079#1083#1099
        OnClick = StartScannerManual
      end
      object miScanCachedBridges: TMenuItem
        Tag = 3
        Caption = #1050#1101#1096#1080#1088#1086#1074#1072#1085#1085#1099#1077' '#1084#1086#1089#1090#1099
        OnClick = StartScannerManual
      end
      object miScanGuards: TMenuItem
        Tag = 5
        Caption = #1057#1090#1086#1088#1086#1078#1077#1074#1099#1077' '#1091#1079#1083#1099
        OnClick = StartScannerManual
      end
      object miScanAliveNodes: TMenuItem
        Tag = 6
        Caption = #1046#1080#1074#1099#1077' '#1091#1079#1083#1099
        OnClick = StartScannerManual
      end
      object miScanAll: TMenuItem
        Tag = 4
        Caption = #1042#1089#1077' '#1091#1079#1083#1099
        OnClick = StartScannerManual
      end
      object miDelimiter47: TMenuItem
        Caption = '-'
      end
      object miManualPingMeasure: TMenuItem
        AutoCheck = True
        Caption = #1048#1079#1084#1077#1088#1103#1090#1100' '#1087#1080#1085#1075
        Checked = True
        OnClick = miManualPingMeasureClick
      end
      object miManualDetectAliveNodes: TMenuItem
        AutoCheck = True
        Caption = #1055#1088#1086#1074#1077#1088#1103#1090#1100' '#1076#1086#1089#1090#1091#1087#1085#1086#1089#1090#1100
        Checked = True
        OnClick = miManualDetectAliveNodesClick
      end
      object miDelimiter61: TMenuItem
        Caption = '-'
      end
      object miStopScan: TMenuItem
        Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1082#1072#1085#1080#1088#1086#1074#1072#1085#1080#1077
        OnClick = miStopScanClick
      end
    end
    object miResetGuards: TMenuItem
      Caption = #1057#1073#1088#1086#1089#1080#1090#1100' '#1089#1090#1086#1088#1086#1078#1077#1074#1099#1077' '#1091#1079#1083#1099
      object miResetGuardsAll: TMenuItem
        Tag = 4
        Caption = #1042#1089#1077' '#1089#1090#1086#1088#1086#1078#1077#1074#1099#1077' '#1091#1079#1083#1099
        OnClick = SetResetGuards
      end
      object miDelimiter57: TMenuItem
        Caption = '-'
      end
      object miResetGuardsBridges: TMenuItem
        Tag = 1
        Caption = #1052#1086#1089#1090#1086#1074#1099#1077' '#1091#1079#1083#1099
        OnClick = SetResetGuards
      end
      object miResetGuardsRestricted: TMenuItem
        Tag = 2
        Caption = #1042#1099#1073#1088#1072#1085#1085#1099#1077' '#1074#1093#1086#1076#1085#1099#1077' '#1091#1079#1083#1099
        OnClick = SetResetGuards
      end
      object miResetGuardsDefault: TMenuItem
        Tag = 3
        Caption = #1042#1093#1086#1076#1085#1099#1077' '#1091#1079#1083#1099' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
        OnClick = SetResetGuards
      end
    end
    object miDelimiter66: TMenuItem
      Caption = '-'
    end
    object miCheckIpProxyType: TMenuItem
      Caption = #1055#1088#1086#1082#1089#1080' '#1076#1083#1103' '#1087#1088#1086#1074#1077#1088#1082#1080' IP-'#1072#1076#1088#1077#1089#1072
      object miCheckIpProxyAuto: TMenuItem
        Caption = #1042#1099#1073#1080#1088#1072#1090#1100' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080
        Checked = True
        RadioItem = True
        OnClick = SelectCheckIpProxy
      end
      object miCheckIpProxySocks: TMenuItem
        Tag = 1
        Caption = 'SOCKS-'#1087#1088#1086#1082#1089#1080
        RadioItem = True
        OnClick = SelectCheckIpProxy
      end
      object miCheckIpProxyHttp: TMenuItem
        Tag = 2
        Caption = 'HTTP-'#1087#1088#1086#1082#1089#1080
        RadioItem = True
        OnClick = SelectCheckIpProxy
      end
    end
  end
  object mnFilter: TPopupMenu
    AutoHotkeys = maManual
    AutoPopup = False
    Images = lsMenus
    OnPopup = mnFilterPopup
    Left = 306
    Top = 1
    object miStat: TMenuItem
      Caption = #1057#1090#1072#1090#1080#1089#1090#1080#1082#1072
      SubMenuImages = lsFlags
      ImageIndex = 24
      object miStatCountry: TMenuItem
        Caption = #1057#1090#1088#1072#1085#1072
        OnClick = MetricsInfo
      end
      object miDelimiter48: TMenuItem
        Caption = '-'
      end
      object miStatGuards: TMenuItem
        Caption = #1057#1090#1086#1088#1086#1078#1077#1074#1099#1077
        Hint = ' flag:guard'
        OnClick = MetricsInfo
      end
      object miStatExit: TMenuItem
        Caption = #1042#1099#1093#1086#1076#1085#1099#1077
        Hint = ' flag:exit'
        OnClick = MetricsInfo
      end
      object miDelimiter14: TMenuItem
        Caption = '-'
      end
      object miStatAggregate: TMenuItem
        Caption = #1054#1073#1097#1072#1103' '#1087#1086' '#1089#1090#1088#1072#1085#1072#1084
        OnClick = miStatAggregateClick
      end
    end
    object miDelimiter13: TMenuItem
      Caption = '-'
    end
    object miSaveTemplate: TMenuItem
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      ImageIndex = 14
      OnClick = miSaveTemplateClick
    end
    object miLoadTemplate: TMenuItem
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      ImageIndex = 15
    end
    object miDeleteTemplate: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 17
    end
    object miDelimiter19: TMenuItem
      Caption = '-'
    end
    object miFilterExtractData: TMenuItem
      Caption = #1048#1079#1074#1083#1077#1095#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 71
    end
    object miFilterOptions: TMenuItem
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      ImageIndex = 11
      object miResetFilterCountries: TMenuItem
        Caption = #1057#1073#1088#1086#1089#1080#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1089#1090#1088#1072#1085#1099
        ImageIndex = 18
        OnClick = miResetFilterCountriesClick
      end
      object miDelimiter70: TMenuItem
        Caption = '-'
      end
      object miFilterScrollTop: TMenuItem
        AutoCheck = True
        Caption = #1055#1088#1086#1082#1088#1091#1095#1080#1074#1072#1090#1100' '#1074#1074#1077#1088#1093' '#1087#1088#1080' '#1089#1086#1088#1090#1080#1088#1086#1074#1082#1077
        Checked = True
        OnClick = miFilterScrollTopClick
      end
      object miFilterSelectRow: TMenuItem
        AutoCheck = True
        Caption = #1042#1099#1076#1077#1083#1103#1090#1100' '#1074#1089#1077' '#1103#1095#1077#1081#1082#1080' '#1074' '#1089#1090#1088#1086#1082#1077
        Checked = True
        OnClick = miFilterSelectRowClick
      end
      object miDelimiter67: TMenuItem
        Caption = '-'
      end
      object miFilterHideUnused: TMenuItem
        AutoCheck = True
        Caption = #1057#1082#1088#1099#1090#1100' '#1085#1077#1080#1089#1087#1086#1083#1100#1079#1091#1077#1084#1099#1077' '#1089#1090#1088#1072#1085#1099
        Checked = True
        OnClick = miFilterHideUnusedClick
      end
      object miExcludeBridgesWhenCounting: TMenuItem
        AutoCheck = True
        Caption = #1048#1089#1082#1083#1102#1095#1080#1090#1100' '#1084#1086#1089#1090#1099' '#1087#1088#1080' '#1087#1086#1076#1089#1095#1105#1090#1077' '#1091#1079#1083#1086#1074
        OnClick = miExcludeBridgesWhenCountingClick
      end
      object miDelimiter35: TMenuItem
        Caption = '-'
      end
      object miNotLoadEmptyTplData: TMenuItem
        AutoCheck = True
        Caption = #1053#1077' '#1079#1072#1075#1088#1091#1078#1072#1090#1100' '#1087#1091#1089#1090#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1096#1072#1073#1083#1086#1085#1072
        Checked = True
        OnClick = miNotLoadEmptyTplDataClick
      end
      object miIgnoreTplLoadParamsOutsideTheFilter: TMenuItem
        AutoCheck = True
        Caption = #1048#1075#1085#1086#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1079#1072#1075#1088#1091#1079#1082#1080' '#1080#1079' '#1096#1072#1073#1083#1086#1085#1072' '#1074#1085#1077' '#1092#1080#1083#1100#1090#1088#1072
        Checked = True
        OnClick = miIgnoreTplLoadParamsOutsideTheFilterClick
      end
      object miReplaceDisabledFavoritesWithCountries: TMenuItem
        AutoCheck = True
        Caption = #1047#1072#1084#1077#1085#1103#1090#1100' '#1074#1099#1082#1083#1102#1095#1077#1085#1085#1099#1077' '#1089#1087#1080#1089#1082#1080' '#1091#1079#1083#1086#1074' '#1074#1099#1073#1088#1072#1085#1085#1099#1084#1080' '#1089#1090#1088#1072#1085#1072#1084#1080
        Checked = True
        OnClick = OptionsChange
      end
      object miDelimiter30: TMenuItem
        Caption = '-'
      end
      object miTplSave: TMenuItem
        Tag = 4
        Caption = #1057#1086#1093#1088#1072#1085#1103#1090#1100' '#1074' '#1096#1072#1073#1083#1086#1085#1077'..'
        ImageIndex = 14
        object miTplSaveCountries: TMenuItem
          Tag = 1
          AutoCheck = True
          Caption = #1042#1099#1073#1088#1072#1085#1085#1099#1077' '#1089#1090#1088#1072#1085#1099
          Checked = True
          OnClick = miTplSaveClick
        end
        object miTplSaveRouters: TMenuItem
          Tag = 2
          AutoCheck = True
          Caption = #1048#1079#1073#1088#1072#1085#1085#1099#1077' '#1091#1079#1083#1099
          Checked = True
          OnClick = miTplSaveClick
        end
        object miTplSaveExcludes: TMenuItem
          Tag = 4
          AutoCheck = True
          Caption = #1047#1072#1087#1088#1077#1097#1105#1085#1085#1099#1077' '#1091#1079#1083#1099
          Checked = True
          OnClick = miTplSaveClick
        end
        object miDelimiter31: TMenuItem
          Caption = '-'
        end
        object miTplSaveSA: TMenuItem
          Caption = #1042#1099#1073#1088#1072#1090#1100' '#1074#1089#1077
          ImageIndex = 51
          OnClick = SelectorMenuClick
        end
        object miTplSaveUA: TMenuItem
          Caption = #1057#1085#1103#1090#1100' '#1074#1089#1077
          ImageIndex = 52
          OnClick = SelectorMenuClick
        end
      end
      object miTplLoad: TMenuItem
        Tag = 5
        Caption = #1047#1072#1075#1088#1091#1078#1072#1090#1100' '#1080#1079' '#1096#1072#1073#1083#1086#1085#1072'..'
        ImageIndex = 15
        object miTplLoadCountries: TMenuItem
          Tag = 1
          AutoCheck = True
          Caption = #1042#1099#1073#1088#1072#1085#1085#1099#1077' '#1089#1090#1088#1072#1085#1099
          Checked = True
          OnClick = miTplLoadClick
        end
        object miTplLoadRouters: TMenuItem
          Tag = 2
          AutoCheck = True
          Caption = #1048#1079#1073#1088#1072#1085#1085#1099#1077' '#1091#1079#1083#1099
          Checked = True
          OnClick = miTplLoadClick
        end
        object miTplLoadExcludes: TMenuItem
          Tag = 4
          AutoCheck = True
          Caption = #1047#1072#1087#1088#1077#1097#1105#1085#1085#1099#1077' '#1091#1079#1083#1099
          Checked = True
          OnClick = miTplLoadClick
        end
        object miDelimiter32: TMenuItem
          Caption = '-'
        end
        object miTplLoadSA: TMenuItem
          Caption = #1042#1099#1073#1088#1072#1090#1100' '#1074#1089#1077
          ImageIndex = 51
          OnClick = SelectorMenuClick
        end
        object miTplLoadUA: TMenuItem
          Caption = #1057#1085#1103#1090#1100' '#1074#1089#1077
          ImageIndex = 52
          OnClick = SelectorMenuClick
        end
      end
    end
    object miDelimiter7: TMenuItem
      Caption = '-'
    end
    object miClearFilter: TMenuItem
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      ImageIndex = 13
      object miClearFilterEntry: TMenuItem
        Caption = #1042#1093#1086#1076#1085#1099#1077
        ImageIndex = 40
        OnClick = ClearFilterClick
      end
      object miClearFilterMiddle: TMenuItem
        Caption = #1057#1088#1077#1076#1085#1080#1077
        ImageIndex = 41
        OnClick = ClearFilterClick
      end
      object miClearFilterExit: TMenuItem
        Caption = #1042#1099#1093#1086#1076#1085#1099#1077
        ImageIndex = 42
        OnClick = ClearFilterClick
      end
      object miClearFilterExclude: TMenuItem
        Caption = #1047#1072#1087#1088#1077#1097#1105#1085#1085#1099#1077
        ImageIndex = 43
        OnClick = ClearFilterClick
      end
      object miDelimiter20: TMenuItem
        Caption = '-'
      end
      object miClearFilterAll: TMenuItem
        Caption = #1042#1089#1077' '#1074#1099#1073#1088#1072#1085#1085#1099#1077
        ImageIndex = 46
        OnClick = ClearFilterClick
      end
    end
  end
  object EditMenu: TPopupMenu
    AutoHotkeys = maManual
    Images = lsMenus
    OnPopup = EditMenuPopup
    Left = 370
    Top = 1
    object miGetBridges: TMenuItem
      Caption = #1055#1086#1083#1091#1095#1080#1090#1100' '#1084#1086#1089#1090#1099
      ImageIndex = 28
      object miGetBridgesSite: TMenuItem
        Caption = #1042#1077#1073'-'#1089#1072#1081#1090
        OnClick = miGetBridgesSiteClick
      end
      object miGetBridgesTelegram: TMenuItem
        Caption = #1058#1077#1083#1077#1075#1088#1072#1084'-'#1082#1072#1085#1072#1083
        OnClick = miGetBridgesTelegramClick
      end
      object miGetBridgesEmail: TMenuItem
        Caption = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1072#1103' '#1087#1086#1095#1090#1072
        OnClick = miGetBridgesEmailClick
      end
      object miDelimiter54: TMenuItem
        Caption = '-'
      end
      object miRequestObfuscatedBridges: TMenuItem
        Tag = 2
        Caption = #1054#1073#1092#1091#1089#1094#1080#1088#1091#1102#1097#1080#1077' '#1090#1088#1072#1092#1080#1082
        Checked = True
        RadioItem = True
        OnClick = SetRequestBridgesType
      end
      object miRequestVanillaBridges: TMenuItem
        Tag = 1
        Caption = #1041#1077#1079' '#1087#1086#1076#1082#1083#1102#1095#1072#1077#1084#1099#1093' '#1090#1088#1072#1085#1089#1087#1086#1088#1090#1086#1074
        RadioItem = True
        OnClick = SetRequestBridgesType
      end
      object miRequestWebTunnelBridges: TMenuItem
        Tag = 3
        Caption = #1048#1084#1080#1090#1080#1088#1091#1102#1097#1080#1077' '#1074#1077#1073'-'#1072#1082#1090#1080#1074#1085#1086#1089#1090#1100
        RadioItem = True
        OnClick = SetRequestBridgesType
      end
      object miDelimiter46: TMenuItem
        Caption = '-'
      end
      object miPreferWebTelegram: TMenuItem
        AutoCheck = True
        Caption = #1055#1088#1077#1076#1087#1086#1095#1080#1090#1072#1090#1100' '#1074#1077#1073'-'#1074#1077#1088#1089#1080#1102' '#1058#1077#1083#1077#1075#1088#1072#1084#1072
        Checked = True
        OnClick = miPreferWebTelegramClick
      end
      object miRequestIPv6Bridges: TMenuItem
        AutoCheck = True
        Caption = #1047#1072#1087#1088#1072#1096#1080#1074#1072#1090#1100' IPv6-'#1084#1086#1089#1090#1099
        OnClick = miRequestIPv6BridgesClick
      end
    end
    object miDelimiter10: TMenuItem
      Caption = '-'
    end
    object miCut: TMenuItem
      Tag = 1
      Caption = #1042#1099#1088#1077#1079#1072#1090#1100
      ImageIndex = 29
      ShortCut = 16472
      OnClick = EditMenuClick
    end
    object miCopy: TMenuItem
      Tag = 2
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100
      ImageIndex = 12
      ShortCut = 16451
      OnClick = EditMenuClick
    end
    object miPaste: TMenuItem
      Tag = 3
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100
      ImageIndex = 27
      ShortCut = 16470
      OnClick = EditMenuClick
    end
    object miDelete: TMenuItem
      Tag = 6
      Caption = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 17
      ShortCut = 46
      OnClick = EditMenuClick
    end
    object miDelimiter43: TMenuItem
      Caption = '-'
    end
    object miSelectAll: TMenuItem
      Tag = 4
      Caption = #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1089#1105
      ImageIndex = 16
      ShortCut = 16449
      OnClick = EditMenuClick
    end
    object miFind: TMenuItem
      Tag = 7
      Caption = #1053#1072#1081#1090#1080'...'
      ImageIndex = 55
      ShortCut = 16454
      OnClick = EditMenuClick
    end
    object miDelimiter11: TMenuItem
      Caption = '-'
    end
    object miBridgesFileFormat: TMenuItem
      Caption = #1060#1086#1088#1084#1072#1090' '#1092#1072#1081#1083#1072' '#1084#1086#1089#1090#1086#1074
      ImageIndex = 19
      object miBridgesFileFormatAuto: TMenuItem
        Caption = #1040#1074#1090#1086#1086#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '
        Checked = True
        RadioItem = True
        OnClick = SetBridgesFileFormat
      end
      object miBridgesFileFormatCompat: TMenuItem
        Tag = 1
        Caption = #1057#1086#1074#1084#1077'c'#1090#1080#1084#1099#1081' '#1089' torrc'
        RadioItem = True
        OnClick = SetBridgesFileFormat
      end
      object miBridgesFileFormatNormal: TMenuItem
        Tag = 2
        Caption = #1054#1073#1099#1095#1085#1099#1081
        RadioItem = True
        OnClick = SetBridgesFileFormat
      end
    end
    object miDelimiter72: TMenuItem
      Caption = '-'
    end
    object miExtractData: TMenuItem
      Caption = #1048#1079#1074#1083#1077#1095#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 71
    end
    object miSortData: TMenuItem
      Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072
      ImageIndex = 9
      object miSortDataAsc: TMenuItem
        Tag = 1
        Caption = #1055#1086' '#1074#1086#1079#1088#1072#1089#1090#1072#1085#1080#1102
        RadioItem = True
        OnClick = SortDataList
      end
      object miSortDataDesc: TMenuItem
        Tag = 2
        Caption = #1055#1086' '#1091#1073#1099#1074#1072#1085#1080#1102
        RadioItem = True
        OnClick = SortDataList
      end
      object miSortDataNone: TMenuItem
        Caption = #1054#1090#1082#1083#1102#1095#1077#1085#1072
        RadioItem = True
        OnClick = SortDataList
      end
    end
    object miDelimiter65: TMenuItem
      Caption = '-'
    end
    object miClear: TMenuItem
      Tag = 5
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      ImageIndex = 13
      ShortCut = 137
      OnClick = EditMenuClick
    end
    object miClearMenu: TMenuItem
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      ImageIndex = 13
      object miClearMenuAll: TMenuItem
        Caption = #1042#1089#1077' '#1089#1090#1088#1086#1082#1080
        ImageIndex = 3
        OnClick = miClearMenuAllClick
      end
      object miDelimiter56: TMenuItem
        Caption = '-'
      end
      object miClearMenuUnsuitable: TMenuItem
        Caption = #1053#1077#1087#1086#1076#1093#1086#1076#1103#1097#1080#1077' '#1091#1079#1083#1099
        ImageIndex = 43
        OnClick = miClearMenuUnsuitableClick
      end
      object miClearMenuNotAlive: TMenuItem
        Caption = #1053#1077' '#1086#1090#1074#1077#1095#1072#1102#1097#1080#1077' '#1085#1072' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1103
        ImageIndex = 56
        OnClick = miClearMenuNotAliveClick
      end
      object miDelimiter45: TMenuItem
        Caption = '-'
      end
      object miClearMenuNonCached: TMenuItem
        Caption = #1054#1090#1089#1091#1090#1089#1090#1074#1091#1102#1097#1080#1077' '#1074' '#1082#1101#1096#1077
        ImageIndex = 22
        OnClick = ClearAvailableCache
      end
      object miClearMenuCached: TMenuItem
        Tag = 1
        Caption = #1053#1072#1081#1076#1077#1085#1085#1099#1077' '#1074' '#1082#1101#1096#1077
        ImageIndex = 21
        OnClick = ClearAvailableCache
      end
    end
  end
  object mnCircuitInfo: TPopupMenu
    AutoHotkeys = maManual
    Images = lsMenus
    OnPopup = mnCircuitInfoPopup
    Left = 498
    Top = 1
    object miCircuitInfoUpdateIp: TMenuItem
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      ImageIndex = 18
      OnClick = miCircuitInfoUpdateIpClick
    end
    object miDelimiter55: TMenuItem
      Caption = '-'
    end
    object miCircuitInfoExtractData: TMenuItem
      Caption = #1048#1079#1074#1083#1077#1095#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 71
    end
    object miCircuitInfoAddToNodesList: TMenuItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1091#1079#1083#1086#1074
      ImageIndex = 31
    end
    object miDelimiter16: TMenuItem
      Caption = '-'
    end
    object miCircuitInfoRelayOperations: TMenuItem
      Caption = #1044#1077#1081#1089#1090#1074#1080#1103' '#1089' '#1088#1086#1091#1090#1077#1088#1072#1084#1080
      ImageIndex = 76
    end
    object miDelimiter8: TMenuItem
      Caption = '-'
    end
    object miCircuitInfoSelectTemplate: TMenuItem
      Caption = #1042#1099#1073#1088#1072#1090#1100' '#1096#1072#1073#1083#1086#1085
      ImageIndex = 26
    end
  end
  object mnServerInfo: TPopupMenu
    AutoHotkeys = maManual
    AutoPopup = False
    Images = lsMenus
    Left = 467
    Top = 1
    object miServerCopy: TMenuItem
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100
      ImageIndex = 12
      object miServerCopyIPv4: TMenuItem
        Caption = #1042#1085#1077#1096#1085#1080#1081' IPv4-'#1072#1076#1088#1077#1089
        ImageIndex = 33
        OnClick = CopyCaptionToClipboard
      end
      object miServerCopyIPv6: TMenuItem
        Caption = #1042#1085#1077#1096#1085#1080#1081' IPv6-'#1072#1076#1088#1077#1089
        ImageIndex = 34
        OnClick = CopyCaptionToClipboard
      end
      object miServerCopyFingerprint: TMenuItem
        Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
        ImageIndex = 23
        OnClick = CopyCaptionToClipboard
      end
      object miServerCopyBridgeIPv4: TMenuItem
        Caption = #1052#1086#1089#1090' IPv4'
        ImageIndex = 59
        OnClick = CopyCaptionToClipboard
      end
      object miServerCopyBridgeIPv6: TMenuItem
        Caption = #1052#1086#1089#1090' IPv6'
        ImageIndex = 60
        OnClick = CopyCaptionToClipboard
      end
    end
    object miServerInfo: TMenuItem
      Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1088#1077#1090#1088#1072#1085#1089#1083#1103#1090#1086#1088#1091
      ImageIndex = 35
      OnClick = miServerInfoClick
    end
  end
  object mnHs: TPopupMenu
    AutoHotkeys = maManual
    Images = lsMenus
    OnPopup = mnHsPopup
    Left = 403
    Top = 1
    object miHsOpenInBrowser: TMenuItem
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1074' '#1073#1088#1072#1091#1079#1077#1088#1077
      ImageIndex = 25
      OnClick = miHsOpenInBrowserClick
    end
    object miDelimiter71: TMenuItem
      Caption = '-'
    end
    object miHsOpenDir: TMenuItem
      Caption = #1050#1072#1090#1072#1083#1086#1075' '#1089#1077#1088#1074#1080#1089#1072
      ImageIndex = 39
      ShortCut = 16452
      Visible = False
      OnClick = miHsOpenDirClick
    end
    object miHsCopy: TMenuItem
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100
      ImageIndex = 12
      Visible = False
      object miHsCopyOnion: TMenuItem
        Caption = 'Onion-'#1072#1076#1088#1077#1089
        ImageIndex = 30
        OnClick = miHsCopyOnionClick
      end
    end
    object miDelimiter12: TMenuItem
      Caption = '-'
    end
    object miHsInsert: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 19
      ShortCut = 45
      OnClick = miHsInsertClick
    end
    object miHsDelete: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 17
      ShortCut = 46
      OnClick = miHsDeleteClick
    end
    object miDelimiter9: TMenuItem
      Caption = '-'
    end
    object miHsClear: TMenuItem
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      ImageIndex = 13
      ShortCut = 8238
      OnClick = miHsClearClick
    end
  end
  object mnShowNodes: TPopupMenu
    Tag = 1
    AutoHotkeys = maManual
    Images = lsMenus
    OnChange = mnShowNodesChange
    OnPopup = mnShowNodesPopup
    Left = 241
    Top = 1
    object miShowExit: TMenuItem
      Tag = 1
      AutoCheck = True
      Caption = #1042#1099#1093#1086#1076#1085#1086#1081
      Checked = True
      OnClick = SetRoutersFilter
    end
    object miShowGuard: TMenuItem
      Tag = 2
      AutoCheck = True
      Caption = #1057#1090#1086#1088#1086#1078#1077#1074#1086#1081
      Checked = True
      OnClick = SetRoutersFilter
    end
    object miShowOther: TMenuItem
      Tag = 8
      AutoCheck = True
      Caption = #1054#1073#1099#1095#1085#1099#1081
      OnClick = SetRoutersFilter
    end
    object miShowAuthority: TMenuItem
      Tag = 4
      AutoCheck = True
      Caption = #1050#1086#1088#1085#1077#1074#1086#1081
      OnClick = SetRoutersFilter
    end
    object miShowConsensus: TMenuItem
      Tag = 8192
      AutoCheck = True
      Caption = #1059#1079#1077#1083' '#1082#1086#1085#1089#1077#1085#1089#1091#1089#1072
      OnClick = SetRoutersFilter
    end
    object miShowBridge: TMenuItem
      Tag = 16
      AutoCheck = True
      Caption = #1050#1101#1096#1080#1088#1086#1074#1072#1085#1085#1099#1081' '#1084#1086#1089#1090
      OnClick = SetRoutersFilter
    end
    object miDelimiter17: TMenuItem
      Caption = '-'
    end
    object miShowFast: TMenuItem
      Tag = 32
      AutoCheck = True
      Caption = #1041#1099#1089#1090#1088#1099#1081
      Checked = True
      Enabled = False
      OnClick = SetRoutersFilter
    end
    object miShowStable: TMenuItem
      Tag = 64
      AutoCheck = True
      Caption = #1057#1090#1072#1073#1080#1083#1100#1085#1099#1081
      Checked = True
      Enabled = False
      OnClick = SetRoutersFilter
    end
    object miDelimiter18: TMenuItem
      Caption = '-'
    end
    object miShowV2Dir: TMenuItem
      Tag = 128
      AutoCheck = True
      Caption = #1042#1090#1086#1088#1072#1103' '#1074#1077#1088#1089#1080#1103' '#1082#1072#1090#1072#1083#1086#1075#1072
      Checked = True
      Enabled = False
      OnClick = SetRoutersFilter
    end
    object miShowHSDir: TMenuItem
      Tag = 256
      AutoCheck = True
      Caption = #1050#1072#1090#1072#1083#1086#1075' '#1089#1082#1088#1099#1090#1099#1093' '#1089#1077#1088#1074#1080#1089#1086#1074
      OnClick = SetRoutersFilter
    end
    object miDelimiter49: TMenuItem
      Caption = '-'
    end
    object miShowRecommend: TMenuItem
      Tag = 512
      AutoCheck = True
      Caption = #1056#1077#1082#1086#1084#1077#1085#1076#1091#1077#1084#1072#1103' '#1074#1077#1088#1089#1080#1103
      Checked = True
      OnClick = SetRoutersFilter
    end
    object miShowAlive: TMenuItem
      Tag = 2048
      AutoCheck = True
      Caption = #1046#1080#1074#1086#1081' '#1091#1079#1077#1083
      OnClick = SetRoutersFilter
    end
    object miDelimiter58: TMenuItem
      Caption = '-'
    end
    object miReverseConditions: TMenuItem
      Tag = 4096
      AutoCheck = True
      Caption = #1054#1073#1088#1072#1090#1080#1090#1100' '#1091#1089#1083#1086#1074#1080#1103' '#1092#1080#1083#1100#1090#1088#1072
      OnClick = SetRoutersFilter
    end
    object miDelimiter50: TMenuItem
      Caption = '-'
    end
    object miShowNodesUA: TMenuItem
      Caption = #1057#1085#1103#1090#1100' '#1074#1089#1077
      ImageIndex = 52
      OnClick = SelectorMenuClick
    end
  end
  object tmConsensus: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = tmConsensusTimer
    Left = 674
    Top = 291
  end
  object mnRouters: TPopupMenu
    AutoHotkeys = maManual
    AutoPopup = False
    Images = lsMenus
    OnPopup = mnRoutersPopup
    Left = 530
    Top = 1
    object miRtResetFilter: TMenuItem
      Caption = #1057#1073#1088#1086#1089' '#1092#1080#1083#1100#1090#1088#1086#1074
      ImageIndex = 18
      OnClick = miRtResetFilterClick
    end
    object miDelimiter25: TMenuItem
      Caption = '-'
    end
    object miRtExtractData: TMenuItem
      Caption = #1048#1079#1074#1083#1077#1095#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 71
    end
    object miRtAddToNodesList: TMenuItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1091#1079#1083#1086#1074
      ImageIndex = 31
    end
    object miDelimiter29: TMenuItem
      Caption = '-'
    end
    object miRtRelayOperations: TMenuItem
      Caption = #1044#1077#1081#1089#1090#1074#1080#1103' '#1089' '#1088#1086#1091#1090#1077#1088#1072#1084#1080
      ImageIndex = 76
    end
    object miDelimiter21: TMenuItem
      Caption = '-'
    end
    object miRtFilters: TMenuItem
      Tag = 2
      Caption = #1060#1080#1083#1100#1090#1088#1099
      ImageIndex = 8
      object miRtFiltersType: TMenuItem
        Tag = 1
        AutoCheck = True
        Caption = #1058#1080#1087' '#1091#1079#1083#1072
        Checked = True
        OnClick = SetRoutersFilterState
      end
      object miRtFiltersCountry: TMenuItem
        Tag = 2
        AutoCheck = True
        Caption = #1057#1090#1088#1072#1085#1072
        Checked = True
        OnClick = SetRoutersFilterState
      end
      object miRtFiltersWeight: TMenuItem
        Tag = 4
        AutoCheck = True
        Caption = #1042#1077#1089' '#1074' '#1082#1086#1085#1089#1077#1085#1089#1091#1089#1077
        Checked = True
        OnClick = SetRoutersFilterState
      end
      object miRtFiltersQuery: TMenuItem
        Tag = 8
        AutoCheck = True
        Caption = #1047#1072#1087#1088#1086#1089' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
        Checked = True
        OnClick = SetRoutersFilterState
      end
      object miDelimiter34: TMenuItem
        Caption = '-'
      end
      object miRtFilterSA: TMenuItem
        Caption = #1042#1099#1073#1088#1072#1090#1100' '#1074#1089#1077
        ImageIndex = 51
        OnClick = SelectorMenuClick
      end
      object miRtFilterUA: TMenuItem
        Caption = #1057#1085#1103#1090#1100' '#1074#1089#1077
        ImageIndex = 52
        OnClick = SelectorMenuClick
      end
    end
    object miRoutersOptions: TMenuItem
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      ImageIndex = 11
      object miRoutersScrollTop: TMenuItem
        AutoCheck = True
        Caption = #1055#1088#1086#1082#1088#1091#1095#1080#1074#1072#1090#1100' '#1074#1074#1077#1088#1093' '#1087#1088#1080' '#1089#1086#1088#1090#1080#1088#1086#1074#1082#1077
        Checked = True
        OnClick = miRoutersScrollTopClick
      end
      object miRoutersSelectRow: TMenuItem
        AutoCheck = True
        Caption = #1042#1099#1076#1077#1083#1103#1090#1100' '#1074#1089#1077' '#1103#1095#1077#1081#1082#1080' '#1074' '#1089#1090#1088#1086#1082#1077
        Checked = True
        OnClick = miRoutersSelectRowClick
      end
      object miRoutersShowFlagsHint: TMenuItem
        AutoCheck = True
        Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1087#1086#1076#1089#1082#1072#1079#1082#1080' '#1092#1083#1072#1075#1086#1074' '#1087#1088#1080' '#1085#1072#1074#1077#1076#1077#1085#1080#1080' '#1084#1099#1096#1080
        Checked = True
        OnClick = miRoutersShowFlagsHintClick
      end
      object miRoutersShowIPv6CountryFlag: TMenuItem
        AutoCheck = True
        Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' IPv6 '#1072#1076#1088#1077#1089' '#1080' '#1092#1083#1072#1075
        Checked = True
        OnClick = miRoutersShowIPv6CountryFlagClick
      end
      object miDelimiter40: TMenuItem
        Caption = '-'
      end
      object miLoadCachedRoutersOnStartup: TMenuItem
        AutoCheck = True
        Caption = #1047#1072#1075#1088#1091#1078#1072#1090#1100' '#1088#1086#1091#1090#1077#1088#1099' '#1080#1079' '#1082#1101#1096#1072' '#1087#1088#1080' '#1079#1072#1087#1091#1089#1082#1077
        Checked = True
        OnClick = miLoadCachedRoutersOnStartupClick
      end
      object miDisableSelectionUnSuitableAsBridge: TMenuItem
        AutoCheck = True
        Caption = #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1074#1099#1073#1086#1088' '#1074' '#1082#1072#1095#1077#1089#1090#1074#1077' '#1084#1086#1089#1090#1072' '#1085#1077#1087#1086#1076#1093#1086#1076#1103#1097#1080#1093' '#1091#1079#1083#1086#1074
        Checked = True
        OnClick = miDisableSelectionUnSuitableAsBridgeClick
      end
      object miDelimiter62: TMenuItem
        Caption = '-'
      end
      object miConvertNodes: TMenuItem
        Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1099#1074#1072#1090#1100' IP, CIDR '#1080' '#1082#1086#1076#1099' '#1089#1090#1088#1072#1085' '#1074' '#1093#1101#1096#1080
        object miEnableConvertNodesOnIncorrectClear: TMenuItem
          AutoCheck = True
          Caption = #1055#1088#1080' '#1086#1095#1080#1089#1090#1082#1077' '#1085#1077#1087#1088#1072#1074#1080#1083#1100#1085#1099#1093' '#1091#1079#1083#1086#1074
          Checked = True
          OnClick = miEnableConvertNodesOnIncorrectClearClick
        end
        object miEnableConvertNodesOnAddToNodesList: TMenuItem
          AutoCheck = True
          Caption = #1055#1088#1080' '#1076#1086#1073#1072#1074#1083#1077#1085#1080#1080' '#1074' '#1089#1087#1080#1089#1086#1082' '#1091#1079#1083#1086#1074
          Checked = True
          OnClick = miEnableConvertNodesOnAddToNodesListClick
        end
        object miEnableConvertNodesOnRemoveFromNodesList: TMenuItem
          AutoCheck = True
          Caption = #1055#1088#1080' '#1091#1076#1072#1083#1077#1085#1080#1080' '#1080#1079' '#1089#1087#1080#1089#1082#1072' '#1091#1079#1083#1086#1074
          Checked = True
          OnClick = miEnableConvertNodesOnRemoveFromNodesListClick
        end
        object miDelimiter63: TMenuItem
          Caption = '-'
        end
        object miConvertIpNodes: TMenuItem
          AutoCheck = True
          Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1099#1074#1072#1090#1100' IP-'#1072#1076#1088#1077#1089#1072
          Checked = True
          OnClick = miConvertIpNodesClick
        end
        object miConvertCidrNodes: TMenuItem
          AutoCheck = True
          Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1099#1074#1072#1090#1100' CIDR-'#1076#1080#1072#1087#1072#1079#1086#1085#1099
          Checked = True
          OnClick = miConvertCidrNodesClick
        end
        object miConvertCountryNodes: TMenuItem
          AutoCheck = True
          Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1099#1074#1072#1090#1100' '#1082#1086#1076#1099' '#1089#1090#1088#1072#1085
          Checked = True
          OnClick = miConvertCountryNodesClick
        end
        object miDelimiter64: TMenuItem
          Caption = '-'
        end
        object miIgnoreConvertExcludeNodes: TMenuItem
          AutoCheck = True
          Caption = #1048#1089#1082#1083#1102#1095#1080#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1079#1072#1087#1088#1077#1097#1105#1085#1085#1099#1093' '#1091#1079#1083#1086#1074
          Checked = True
          OnClick = miIgnoreConvertExcludeNodesClick
        end
        object miAvoidAddingIncorrectNodes: TMenuItem
          AutoCheck = True
          Caption = #1048#1079#1073#1077#1075#1072#1090#1100' '#1076#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1085#1077#1087#1088#1072#1074#1080#1083#1100#1085#1099#1093' '#1091#1079#1083#1086#1074
          Checked = True
          OnClick = miAvoidAddingIncorrectNodesClick
        end
      end
      object miDisableFiltersOn: TMenuItem
        Caption = #1054#1090#1082#1083#1102#1095#1072#1090#1100' '#1092#1080#1083#1100#1090#1088#1099' '#1087#1088#1080' '#1089#1086#1073#1099#1090#1080#1080
        object miDisableFiltersOnUserQuery: TMenuItem
          AutoCheck = True
          Caption = #1054#1090#1087#1088#1072#1074#1082#1072' '#1079#1072#1087#1088#1086#1089#1072' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
          Checked = True
          OnClick = miDisableFiltersOnUserQueryClick
        end
        object miDisableFiltersOnAuthorityOrBridge: TMenuItem
          AutoCheck = True
          Caption = #1042#1099#1073#1086#1088' '#1084#1086#1089#1090#1086#1074' '#1080#1083#1080' '#1082#1086#1088#1085#1077#1074#1099#1093' '#1091#1079#1083#1086#1074
          Checked = True
          OnClick = miDisableFiltersOnAuthorityOrBridgeClick
        end
      end
      object miDelimiter26: TMenuItem
        Caption = '-'
      end
      object miRtSaveDefault: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1082#1072#1082' '#1092#1080#1083#1100#1090#1088' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
        ImageIndex = 14
        OnClick = miRtSaveDefaultClick
      end
    end
    object miDelimiter23: TMenuItem
      Caption = '-'
    end
    object miClearRouters: TMenuItem
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      ImageIndex = 13
      object miClearRoutersEntry: TMenuItem
        Caption = #1042#1093#1086#1076#1085#1099#1077
        ImageIndex = 40
        OnClick = ClearRoutersClick
      end
      object miClearRoutersMiddle: TMenuItem
        Caption = #1057#1088#1077#1076#1085#1080#1077
        ImageIndex = 41
        OnClick = ClearRoutersClick
      end
      object miClearRoutersExit: TMenuItem
        Caption = #1042#1099#1093#1086#1076#1085#1099#1077
        ImageIndex = 42
        OnClick = ClearRoutersClick
      end
      object miClearRoutersExclude: TMenuItem
        Caption = #1047#1072#1087#1088#1077#1097#1105#1085#1085#1099#1077
        ImageIndex = 43
        OnClick = ClearRoutersClick
      end
      object miDelimiter22: TMenuItem
        Caption = '-'
      end
      object miClearRoutersFavorites: TMenuItem
        Caption = #1042#1089#1077' '#1080#1079#1073#1088#1072#1085#1085#1099#1077
        ImageIndex = 46
        OnClick = ClearRoutersClick
      end
      object miClearRoutersIncorrect: TMenuItem
        Caption = #1053#1077#1087#1088#1072#1074#1080#1083#1100#1085#1099#1077' '#1091#1079#1083#1099
        ImageIndex = 47
        OnClick = miClearRoutersIncorrectClick
      end
      object miClearRoutersAbsent: TMenuItem
        Caption = #1054#1090#1089#1091#1090#1089#1090#1074#1091#1102#1097#1080#1077' '#1074' '#1082#1086#1085#1089#1077#1085#1089#1091#1089#1077
        ImageIndex = 22
        OnClick = miClearRoutersAbsentClick
      end
    end
  end
  object tmCircuits: TTimer
    Enabled = False
    OnTimer = tmCircuitsTimer
    Left = 673
    Top = 158
  end
  object mnCircuits: TPopupMenu
    AutoHotkeys = maManual
    Images = lsMenus
    OnPopup = mnCircuitsPopup
    Left = 562
    Top = 1
    object miCircuitsDestroyLock: TMenuItem
      Caption = #1059#1085#1080#1095#1090#1086#1078#1080#1090#1100
      ImageIndex = 3
    end
    object miCircuitsDestroy: TMenuItem
      Caption = #1059#1085#1080#1095#1090#1086#1078#1080#1090#1100
      ImageIndex = 3
      object miDestroyCircuit: TMenuItem
        Caption = #1062#1077#1087#1086#1095#1082#1091
        ShortCut = 46
        OnClick = miDestroyCircuitClick
      end
      object miDestroyStreams: TMenuItem
        Caption = #1057#1086#1077#1076#1080#1085#1077#1085#1080#1103
        ShortCut = 8238
        OnClick = miDestroyStreamsClick
      end
      object miDelimiter36: TMenuItem
        Caption = '-'
      end
      object miDestroyExitCircuits: TMenuItem
        Caption = #1042#1089#1077' '#1074#1099#1093#1086#1076#1085#1099#1077' '#1094#1077#1087#1086#1095#1082#1080
        OnClick = miDestroyExitCircuitsClick
      end
    end
    object miDelimiter39: TMenuItem
      Caption = '-'
    end
    object miCircuitsUpdateNow: TMenuItem
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      ImageIndex = 18
      ShortCut = 116
      OnClick = miCircuitsUpdateNowClick
    end
    object miCircuitsSort: TMenuItem
      Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072
      ImageIndex = 10
      object miCircuitsSortID: TMenuItem
        Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103
        Checked = True
        RadioItem = True
        OnClick = SelectCircuitsSort
      end
      object miCircuitsSortPurpose: TMenuItem
        Tag = 1
        Caption = #1053#1072#1079#1085#1072#1095#1077#1085#1080#1077
        RadioItem = True
        OnClick = SelectCircuitsSort
      end
      object miCircuitsSortFlags: TMenuItem
        Tag = 2
        Caption = #1060#1083#1072#1075#1080
        RadioItem = True
        OnClick = SelectCircuitsSort
      end
      object miCircuitsSortParams: TMenuItem
        Tag = 3
        Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
        RadioItem = True
        Visible = False
        OnClick = SelectCircuitsSort
      end
      object miCircuitsSortDL: TMenuItem
        Tag = 4
        Caption = #1055#1086#1083#1091#1095#1077#1085#1086
        RadioItem = True
        OnClick = SelectCircuitsSort
      end
      object miCircuitsSortUL: TMenuItem
        Tag = 5
        Caption = #1054#1090#1087#1088#1072#1074#1083#1077#1085#1086
        RadioItem = True
        OnClick = SelectCircuitsSort
      end
      object miCircuitsSortStreams: TMenuItem
        Tag = 6
        Caption = #1057#1086#1077#1076#1080#1085#1077#1085#1080#1103
        RadioItem = True
        OnClick = SelectCircuitsSort
      end
    end
    object miCircuitFilter: TMenuItem
      Tag = 3
      Caption = #1060#1080#1083#1100#1090#1088#1099
      ImageIndex = 8
      object miCircOneHop: TMenuItem
        Tag = 1
        AutoCheck = True
        Caption = #1047#1072#1087#1088#1086#1089' '#1082#1072#1090#1072#1083#1086#1075#1072
        Checked = True
        OnClick = SetCircuitsFilter
      end
      object miCircInternal: TMenuItem
        Tag = 2
        AutoCheck = True
        Caption = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1090#1088#1072#1092#1080#1082
        Checked = True
        OnClick = SetCircuitsFilter
      end
      object miCircExit: TMenuItem
        Tag = 4
        AutoCheck = True
        Caption = #1042#1099#1093#1086#1076#1085#1086#1081' '#1090#1088#1072#1092#1080#1082
        Checked = True
        OnClick = SetCircuitsFilter
      end
      object miCircConfluxLinked: TMenuItem
        Tag = 65536
        AutoCheck = True
        Caption = #1057#1083#1080#1103#1085#1080#1077' '#1090#1088#1072#1092#1080#1082#1072': '#1048#1089#1087#1086#1083#1100#1079#1091#1077#1090#1089#1103
        Checked = True
        OnClick = SetCircuitsFilter
      end
      object miCircConfluxUnLinked: TMenuItem
        Tag = 131072
        AutoCheck = True
        Caption = #1057#1083#1080#1103#1085#1080#1077' '#1090#1088#1072#1092#1080#1082#1072': '#1054#1078#1080#1076#1072#1085#1080#1077
        Checked = True
        OnClick = SetCircuitsFilter
      end
      object miCircHsClientDir: TMenuItem
        Tag = 8
        AutoCheck = True
        Caption = #1050#1083#1080#1077#1085#1090': '#1047#1072#1087#1088#1086#1089' '#1082#1072#1090#1072#1083#1086#1075#1072
        Checked = True
        OnClick = SetCircuitsFilter
      end
      object miCircHsClientIntro: TMenuItem
        Tag = 16
        AutoCheck = True
        Caption = #1050#1083#1080#1077#1085#1090': '#1058#1086#1095#1082#1072' '#1074#1093#1086#1076#1072
        Checked = True
        OnClick = SetCircuitsFilter
      end
      object miCircHsClientRend: TMenuItem
        Tag = 32
        AutoCheck = True
        Caption = #1050#1083#1080#1077#1085#1090': '#1052#1077#1089#1090#1086' '#1074#1089#1090#1088#1077#1095#1080
        Checked = True
        OnClick = SetCircuitsFilter
      end
      object miCircHsServiceDir: TMenuItem
        Tag = 64
        AutoCheck = True
        Caption = #1057#1077#1088#1074#1080#1089': '#1047#1072#1087#1088#1086#1089' '#1082#1072#1090#1072#1083#1086#1075#1072
        Checked = True
        OnClick = SetCircuitsFilter
      end
      object miCircHsServiceIntro: TMenuItem
        Tag = 128
        AutoCheck = True
        Caption = #1057#1077#1088#1074#1080#1089': '#1058#1086#1095#1082#1072' '#1074#1093#1086#1076#1072
        Checked = True
        OnClick = SetCircuitsFilter
      end
      object miCircHsServiceRend: TMenuItem
        Tag = 256
        AutoCheck = True
        Caption = #1057#1077#1088#1074#1080#1089': '#1052#1077#1089#1090#1086' '#1074#1089#1090#1088#1077#1095#1080
        Checked = True
        OnClick = SetCircuitsFilter
      end
      object miCircHsVanguards: TMenuItem
        Tag = 512
        AutoCheck = True
        Caption = #1040#1074#1072#1085#1075#1072#1088#1076' '#1089#1082#1088#1099#1090#1086#1075#1086' '#1089#1077#1088#1074#1080#1089#1072
        Checked = True
        OnClick = SetCircuitsFilter
      end
      object miCircPathBiasTesting: TMenuItem
        Tag = 1024
        AutoCheck = True
        Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1079#1072#1082#1088#1099#1090#1080#1103' '#1094#1077#1087#1086#1095#1082#1080
        Checked = True
        OnClick = SetCircuitsFilter
      end
      object miCircTesting: TMenuItem
        Tag = 2048
        AutoCheck = True
        Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1076#1086#1089#1090#1091#1087#1085#1086#1089#1090#1080
        Checked = True
        OnClick = SetCircuitsFilter
      end
      object miCircCircuitPadding: TMenuItem
        Tag = 4096
        AutoCheck = True
        Caption = #1052#1072#1089#1082#1080#1088#1086#1074#1082#1072' '#1074#1088#1077#1084#1077#1085#1080' '#1079#1072#1082#1088#1099#1090#1080#1103
        Checked = True
        OnClick = SetCircuitsFilter
      end
      object miCircMeasureTimeout: TMenuItem
        Tag = 8192
        AutoCheck = True
        Caption = #1048#1079#1084#1077#1088#1077#1085#1080#1077' '#1086#1078#1080#1076#1072#1085#1080#1103
        Checked = True
        OnClick = SetCircuitsFilter
      end
      object miCircController: TMenuItem
        Tag = 32768
        AutoCheck = True
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100#1089#1082#1072#1103' '#1094#1077#1087#1086#1095#1082#1072
        Checked = True
        OnClick = SetCircuitsFilter
      end
      object miCircOther: TMenuItem
        Tag = 16384
        AutoCheck = True
        Caption = #1044#1088#1091#1075#1086#1077' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
        Checked = True
        OnClick = SetCircuitsFilter
      end
      object miDelimiter33: TMenuItem
        Caption = '-'
      end
      object miCircSA: TMenuItem
        Caption = #1042#1099#1073#1088#1072#1090#1100' '#1074#1089#1077
        ImageIndex = 51
        OnClick = SelectorMenuClick
      end
      object miCircUA: TMenuItem
        Caption = #1057#1085#1103#1090#1100' '#1074#1089#1077
        ImageIndex = 52
        OnClick = SelectorMenuClick
      end
    end
    object miDelimiter24: TMenuItem
      Caption = '-'
    end
    object miCircuitOptions: TMenuItem
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      ImageIndex = 11
      object miHideCircuitsWithoutStreams: TMenuItem
        AutoCheck = True
        Caption = #1057#1082#1088#1099#1074#1072#1090#1100' '#1094#1077#1087#1086#1095#1082#1080' '#1073#1077#1079' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1081
        OnClick = miHideCircuitsWithoutStreamsClick
      end
      object miAlwaysShowExitCircuit: TMenuItem
        AutoCheck = True
        Caption = #1042#1089#1077#1075#1076#1072' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1074#1099#1093#1086#1076#1085#1091#1102' '#1094#1077#1087#1086#1095#1082#1091
        Checked = True
        OnClick = miAlwaysShowExitCircuitClick
      end
      object miSelectExitCircuitWhenItChanges: TMenuItem
        AutoCheck = True
        Caption = #1042#1099#1076#1077#1083#1103#1090#1100' '#1074#1099#1093#1086#1076#1085#1091#1102' '#1094#1077#1087#1086#1095#1082#1091' '#1087#1088#1080' '#1077#1105' '#1080#1079#1084#1077#1085#1077#1085#1080#1080
        Checked = True
        OnClick = miSelectExitCircuitWhenItChangesClick
      end
      object miDelimiter38: TMenuItem
        Caption = '-'
      end
      object miShowCircuitsTraffic: TMenuItem
        Tag = 1
        AutoCheck = True
        Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1090#1088#1072#1092#1080#1082' '#1094#1077#1087#1086#1095#1077#1082
        Checked = True
        OnClick = ShowTrafficSelect
      end
      object miShowStreamsTraffic: TMenuItem
        Tag = 2
        AutoCheck = True
        Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1090#1088#1072#1092#1080#1082' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1081
        Checked = True
        OnClick = ShowTrafficSelect
      end
      object miShowStreamsInfo: TMenuItem
        AutoCheck = True
        Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1087#1086#1076#1088#1086#1073#1085#1086#1089#1090#1080' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1081
        Checked = True
        OnClick = miShowStreamsInfoClick
      end
      object miCircuitsShowFlagsHint: TMenuItem
        AutoCheck = True
        Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1087#1086#1076#1089#1082#1072#1079#1082#1080' '#1092#1083#1072#1075#1086#1074' '#1087#1088#1080' '#1085#1072#1074#1077#1076#1077#1085#1080#1080' '#1084#1099#1096#1080
        Checked = True
        OnClick = miCircuitsShowFlagsHintClick
      end
      object miDelimiter74: TMenuItem
        Caption = '-'
      end
      object miCircuitsShowIPv6CountryFlag: TMenuItem
        AutoCheck = True
        Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' IPv6 '#1072#1076#1088#1077#1089' '#1080' '#1092#1083#1072#1075
        Checked = True
        OnClick = miCircuitsShowIPv6CountryFlagClick
      end
      object miShowPortAlongWithIp: TMenuItem
        AutoCheck = True
        Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1087#1086#1088#1090' '#1074#1084#1077#1089#1090#1077' '#1089' IP '#1072#1076#1088#1077#1089#1086#1084' '#1088#1086#1091#1090#1077#1088#1072
        OnClick = miShowPortAlongWithIpClick
      end
      object miDelimiter41: TMenuItem
        Caption = '-'
      end
      object miCircuitsUpdateSpeed: TMenuItem
        Caption = #1057#1082#1086#1088#1086#1089#1090#1100' '#1086#1073#1085#1086#1074#1083#1077#1085#1080#1103
        object miCircuitsUpdateHigh: TMenuItem
          Tag = 500
          Caption = #1042#1099#1089#1086#1082#1072#1103
          RadioItem = True
          OnClick = SetCircuitsUpdateInterval
        end
        object miCircuitsUpdateNormal: TMenuItem
          Tag = 1000
          Caption = #1053#1086#1088#1084#1072#1083#1100#1085#1072#1103
          Checked = True
          RadioItem = True
          OnClick = SetCircuitsUpdateInterval
        end
        object miCircuitsUpdateLow: TMenuItem
          Tag = 4000
          Caption = #1053#1080#1079#1082#1072#1103
          RadioItem = True
          OnClick = SetCircuitsUpdateInterval
        end
        object miDelimiter37: TMenuItem
          Caption = '-'
        end
        object miCircuitsUpdateManual: TMenuItem
          Caption = #1054#1073#1085#1086#1074#1083#1103#1090#1100' '#1074#1088#1091#1095#1085#1091#1102
          RadioItem = True
          OnClick = SetCircuitsUpdateInterval
        end
      end
    end
  end
  object mnStreams: TPopupMenu
    AutoHotkeys = maManual
    Images = lsMenus
    OnPopup = mnStreamsPopup
    Left = 595
    Top = 1
    object miStreamsDestroyStream: TMenuItem
      Caption = #1059#1085#1080#1095#1090#1086#1078#1080#1090#1100
      ImageIndex = 3
      ShortCut = 46
      OnClick = miStreamsDestroyStreamClick
    end
    object miDelimiter27: TMenuItem
      Caption = '-'
    end
    object miStreamsOpenInBrowser: TMenuItem
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1074' '#1073#1088#1072#1091#1079#1077#1088#1077
      ImageIndex = 25
      ShortCut = 13
      OnClick = miStreamsOpenInBrowserClick
    end
    object miStreamsBindToExitNode: TMenuItem
      Caption = #1055#1088#1080#1074#1103#1079#1072#1090#1100' '#1082' '#1074#1099#1093#1086#1076#1085#1086#1084#1091' '#1091#1079#1083#1091
      ImageIndex = 21
    end
    object miDelimiter28: TMenuItem
      Caption = '-'
    end
    object miStreamsExtractData: TMenuItem
      Caption = #1048#1079#1074#1083#1077#1095#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 71
    end
    object miStreamsSort: TMenuItem
      Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072
      ImageIndex = 10
      object miStreamsSortID: TMenuItem
        Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103
        Checked = True
        RadioItem = True
        OnClick = SelectStreamsSort
      end
      object miStreamsSortTarget: TMenuItem
        Tag = 1
        Caption = #1062#1077#1083#1077#1074#1086#1081' '#1072#1076#1088#1077#1089
        RadioItem = True
        OnClick = SelectStreamsSort
      end
      object miStreamsSortTrack: TMenuItem
        Tag = 2
        Caption = #1055#1088#1080#1074#1103#1079#1082#1072' '#1082' '#1074#1099#1093#1086#1076#1085#1086#1084#1091' '#1091#1079#1083#1091
        RadioItem = True
        OnClick = SelectStreamsSort
      end
      object miStreamsSortStreams: TMenuItem
        Tag = 3
        Caption = #1057#1086#1077#1076#1080#1085#1077#1085#1080#1103
        RadioItem = True
        OnClick = SelectStreamsSort
      end
      object miStreamsSortDL: TMenuItem
        Tag = 4
        Caption = #1055#1086#1083#1091#1095#1077#1085#1086
        RadioItem = True
        OnClick = SelectStreamsSort
      end
      object miStreamsSortUL: TMenuItem
        Tag = 5
        Caption = #1054#1090#1087#1088#1072#1074#1083#1077#1085#1086
        RadioItem = True
        OnClick = SelectStreamsSort
      end
    end
  end
  object lsTray: TImageList
    ColorDepth = cd32Bit
    Height = 20
    Width = 20
    Left = 721
    Top = 291
  end
  object lsMain: TImageList
    ColorDepth = cd32Bit
    Left = 722
    Top = 158
  end
  object mnStreamsInfo: TPopupMenu
    AutoHotkeys = maManual
    Images = lsMenus
    OnPopup = mnStreamsInfoPopup
    Left = 628
    Top = 1
    object miStreamsInfoDestroyStream: TMenuItem
      Caption = #1059#1085#1080#1095#1090#1086#1078#1080#1090#1100
      ImageIndex = 3
      ShortCut = 46
      OnClick = miStreamsInfoDestroyStreamClick
    end
    object miDelimiter42: TMenuItem
      Caption = '-'
    end
    object miStreamsInfoExtractData: TMenuItem
      Caption = #1048#1079#1074#1083#1077#1095#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 71
    end
    object miStreamsInfoSort: TMenuItem
      Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072
      ImageIndex = 10
      object miStreamsInfoSortID: TMenuItem
        Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103
        Checked = True
        RadioItem = True
        OnClick = SelectStreamsInfoSort
      end
      object miStreamsInfoSortSource: TMenuItem
        Tag = 1
        Caption = #1048#1089#1090#1086#1095#1085#1080#1082
        RadioItem = True
        OnClick = SelectStreamsInfoSort
      end
      object miStreamsInfoSortDest: TMenuItem
        Tag = 2
        Caption = #1053#1072#1079#1085#1072#1095#1077#1085#1080#1077
        RadioItem = True
        OnClick = SelectStreamsInfoSort
      end
      object miStreamsInfoSortPurpose: TMenuItem
        Tag = 3
        Caption = #1062#1077#1083#1100
        RadioItem = True
        OnClick = SelectStreamsInfoSort
      end
      object miStreamsInfoSortDL: TMenuItem
        Tag = 4
        Caption = #1055#1086#1083#1091#1095#1077#1085#1086
        RadioItem = True
        OnClick = SelectStreamsInfoSort
      end
      object miStreamsInfoSortUL: TMenuItem
        Tag = 5
        Caption = #1054#1090#1087#1088#1072#1074#1083#1077#1085#1086
        RadioItem = True
        OnClick = SelectStreamsInfoSort
      end
    end
  end
  object FindDialog: TFindDialog
    OnFind = FindDialogFind
    Left = 676
    Top = 334
  end
  object tmScanner: TTimer
    Enabled = False
    OnTimer = tmScannerTimer
    Left = 674
    Top = 202
  end
  object mnTransports: TPopupMenu
    AutoHotkeys = maManual
    Images = lsMenus
    OnPopup = mnTransportsPopup
    Left = 660
    Top = 1
    object miTransportsInsert: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 19
      ShortCut = 45
      OnClick = miTransportsInsertClick
    end
    object miTransportsDelete: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 17
      ShortCut = 46
      OnClick = miTransportsDeleteClick
    end
    object miDelimiter52: TMenuItem
      Caption = '-'
    end
    object miTransportsOpenDir: TMenuItem
      Caption = #1050#1072#1090#1072#1083#1086#1075' '#1090#1088#1072#1085#1089#1087#1086#1088#1090#1086#1074
      ImageIndex = 39
      ShortCut = 16452
      OnClick = miTransportsOpenDirClick
    end
    object miTransportsReset: TMenuItem
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
      ImageIndex = 18
      OnClick = miTransportsResetClick
    end
    object miDelimiter53: TMenuItem
      Caption = '-'
    end
    object miTransportsClear: TMenuItem
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      ImageIndex = 13
      ShortCut = 8238
      OnClick = miTransportsClearClick
    end
  end
  object mnTraffic: TPopupMenu
    AutoHotkeys = maManual
    Images = lsMenus
    OnPopup = mnTrafficPopup
    Left = 693
    Top = 1
    object miTrafficPeriod: TMenuItem
      Caption = #1055#1077#1088#1080#1086#1076
      object miPeriod1m: TMenuItem
        Caption = '1 '#1084#1080#1085'.'
        RadioItem = True
        OnClick = SelectTrafficPeriod
      end
      object miPeriod5m: TMenuItem
        Tag = 1
        Caption = '5 '#1084#1080#1085'.'
        Checked = True
        RadioItem = True
        OnClick = SelectTrafficPeriod
      end
      object miPeriod15m: TMenuItem
        Tag = 2
        Caption = '15 '#1084#1080#1085'.'
        RadioItem = True
        OnClick = SelectTrafficPeriod
      end
      object miPeriod30m: TMenuItem
        Tag = 3
        Caption = '30 '#1084#1080#1085'.'
        RadioItem = True
        OnClick = SelectTrafficPeriod
      end
      object miPeriod1h: TMenuItem
        Tag = 4
        Caption = '1 '#1095'.'
        RadioItem = True
        OnClick = SelectTrafficPeriod
      end
      object miPeriod3h: TMenuItem
        Tag = 5
        Caption = '3 '#1095'.'
        RadioItem = True
        OnClick = SelectTrafficPeriod
      end
      object miPeriod6h: TMenuItem
        Tag = 6
        Caption = '6 '#1095
        RadioItem = True
        OnClick = SelectTrafficPeriod
      end
      object miPeriod12h: TMenuItem
        Tag = 7
        Caption = '12 '#1095'.'
        RadioItem = True
        OnClick = SelectTrafficPeriod
      end
      object miPeriod24h: TMenuItem
        Tag = 8
        Caption = '24 '#1095'.'
        RadioItem = True
        OnClick = SelectTrafficPeriod
      end
    end
    object miSelectGraph: TMenuItem
      Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1075#1088#1072#1092#1080#1082#1080
      object miSelectGraphDL: TMenuItem
        AutoCheck = True
        Caption = #1047#1072#1075#1088#1091#1079#1082#1072
        Checked = True
        OnClick = miSelectGraphDLClick
      end
      object miSelectGraphUL: TMenuItem
        AutoCheck = True
        Caption = #1054#1090#1087#1088#1072#1074#1082#1072
        Checked = True
        OnClick = miSelectGraphULClick
      end
    end
    object miDelimiter68: TMenuItem
      Caption = '-'
    end
    object miTotalsCounter: TMenuItem
      Caption = #1057#1095#1105#1090#1095#1080#1082' '#1090#1088#1072#1092#1080#1082#1072
      object miEnableTotalsCounter: TMenuItem
        AutoCheck = True
        Caption = #1042#1082#1083#1102#1095#1080#1090#1100' '#1087#1086#1076#1089#1095#1105#1090
        Checked = True
        OnClick = miEnableTotalsCounterClick
      end
      object miDelimiter69: TMenuItem
        Caption = '-'
      end
      object miResetTotalsCounter: TMenuItem
        Caption = #1057#1073#1088#1086#1089#1080#1090#1100' '#1089#1095#1105#1090#1095#1080#1082' '#1090#1088#1072#1092#1080#1082#1072
        ImageIndex = 18
        OnClick = miResetTotalsCounterClick
      end
    end
  end
  object tmTraffic: TTimer
    Enabled = False
    OnTimer = tmTrafficTimer
    Left = 674
    Top = 247
  end
  object OpenDialog: TOpenDialog
    Left = 677
    Top = 377
  end
end
