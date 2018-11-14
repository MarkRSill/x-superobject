object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Form3'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    635
    299)
  PixelsPerInch = 96
  TextHeight = 13
  object btnStart: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'TJSONObject'
    TabOrder = 0
    OnClick = btnStartClick
  end
  object memLog: TMemo
    Left = 8
    Top = 39
    Width = 619
    Height = 252
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 1
  end
  object Button3: TButton
    Left = 332
    Top = 8
    Width = 75
    Height = 25
    Caption = 'DateCheck'
    TabOrder = 2
  end
  object Button4: TButton
    Left = 165
    Top = 8
    Width = 87
    Height = 25
    Caption = 'BigSuperObject'
    TabOrder = 3
    OnClick = Button4Click
  end
  object btnSuperObject: TButton
    Left = 89
    Top = 8
    Width = 70
    Height = 25
    Caption = 'SuperObject'
    TabOrder = 4
    OnClick = btnSuperObjectClick
  end
  object MemTimer: TTimer
    Interval = 5000
    OnTimer = MemTimerTimer
    Left = 551
    Top = 4
  end
end
