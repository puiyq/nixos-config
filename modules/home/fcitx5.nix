{ pkgs, ... }:
{
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [ wowtype ];
      settings = {
        inputMethod = {
          GroupOrder."0" = "Default";
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "keyboard-us";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "wowtype";
        };
        globalOptions = {
          "Hotkey/TriggerKeys"."0" = "";
          "Hotkey/PrevPage"."0" = "braceleft";
          "Hotkey/NextPage"."0" = "braceright";
          Behavior.DefaultPageSize = 10;
        };
        addons = {
          classicui.globalSection.Theme = "wowtype-dark";
          imselector.sections.SwitchKey = {
            "0" = "Super+braceright";
            "1" = "Super+braceleft";
          };
          wowtype.globalSection = {
            # CandidateLayout: Horizontal | Vertical
            CandidateLayout = "Horizontal";
            PageSize = 9;
            PageKeysMinusEqual = true;
            PageKeysBracket = true;
            PageKeysCommaPeriod = false;
            PageKeysTab = false;

            Fuzzy = true;
            FuzzyZh = true;
            FuzzyCh = true;
            FuzzySh = true;
            FuzzyNL = false;
            FuzzyFH = false;
            FuzzyRL = true;
            FuzzyAn = true;
            FuzzyEn = true;
            FuzzyIn = true;
            FuzzyIan = true;
            FuzzyUan = true;
            FuzzyUn = false;
            TypoCorrection = true;

            Shuangpin = false;
            # ShuangpinScheme: Ziranma | Xiaohe | Microsoft | Sogou | ABC | Ziguang | PinyinJiajia
            ShuangpinScheme = "Ziranma";

            # ShiftToggle: Both | Left | Right | Off
            ShiftToggle = "Right";
            Traditional = false;
            # PunctuationStyle: Fullwidth | Halfwidth
            PunctuationStyle = "Fullwidth";
            # SelectKeys: Off | Semicolon | SemicolonQuote
            SelectKeys = "Off";

            DateTime = false;
            Calculator = false;
            Toolbar = true;
            ClipboardHistory = false;
            AutoSpace = false;
            AutoSpaceLetters = true;
            AutoSpaceDigits = true;

            Voice = false;
            VoiceCopy = false;
            # VoiceKey: Alt_R | Control_R | Menu | F8 | F9 | F10
            VoiceKey = "Alt_R";

            EmojiSuggest = true;
            # EmojiKey: Super+period | Control+semicolon | Control+Shift+E | empty to disable
            EmojiKey = "Control+semicolon";

            Translate = false;
            # TranslateTarget: en | ja | ko | fr | de | es | ru | pt | it | vi | th | id | ar
            TranslateTarget = "en";
            TranslateBaseUrl = "";
            TranslateModel = "";
            TranslateFormal = false;
            TranslateLocal = false;
            TranslateLocalModel = "";
            TranslateLlamaServer = "";
            TranslateIdleMinutes = 5;

            CheckUpdate = false;
            Lexicon = "";
          };
        };
      };
    };
  };
}
