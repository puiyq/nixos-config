{
  programs = {
    thunderbird = {
      enable = true;
      profiles = {
        default = {
          isDefault = true;
          settings = {
            "intl.locale.requested" = "zh-CN";
            "general.useragent.locale" = "zh-CN";
            "mail.html_compose" = false;
            "mail.identity.default.compose_html" = false;
          };
        };
      };
    };
  };

  accounts.email.accounts = {
    outlook = {
      primary = true;
      flavor = "outlook.office365.com";
      realName = "Yong Qing PUI";
      address = "104395234@students.swinburne.edu.my";
      thunderbird = {
        enable = true;
        settings = id: {
          "mail.server.server_${id}.authMethod" = 10; # OAuth2
          "mail.smtpserver.smtp_${id}.authMethod" = 10; # OAuth2
          "mail.server.server_${id}.socketType" = 3; # SSL/TLS
        };
      };
    };

    gmail = {
      flavor = "gmail.com";
      realName = "Pui Yong Qing";
      address = "puiyongqing@gmail.com";
      thunderbird.enable = true;
    };
  };
}
