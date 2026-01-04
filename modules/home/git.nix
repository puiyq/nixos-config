{
  pkgs,
  lib,
  ...
}:
let
  gitUsername = "Pui Yong Qing";
  gitEmail = "puiyongqing@gmail.com";
in
{
  programs = {
    delta = {
      enable = true;
      enableGitIntegration = true;
      enableJujutsuIntegration = true;
      options = {
        line-numbers = true;
        navigate = true;
        hyperlinks = true;
      };
    };
    jujutsu = {
      enable = true;
      package = pkgs.jujutsu_git;
      settings = {
        user = {
          email = "${gitEmail}";
          name = "${gitUsername}";
        };
        ui = {
          editor = "zeditor";
          default-command = [ "log" ];
          diff-editor = ":builtin";
          show-cryptographic-signatures = true;
        };
        signing = {
          behavior = "own";
          backend = "gpg";
          key = "CCDCA20D4A5F54D004F088A8272D4F26832F8EF8";
        };
        git.sign-on-push = true;
      };
    };
    git = {
      enable = true;
      package = pkgs.gitMinimal; # .override { sendEmailSupport = true; };

      settings = {
        user = {
          name = "${gitUsername}";
          email = "${gitEmail}";
        };
        credential.helper = "libsecret"; # For store gmail app password
        # FOSS-friendly settings
        push.default = "simple"; # Match modern push behavior
        init.defaultBranch = "main"; # Set default new branches to 'main'
        log.decorate = "full"; # Show branch/tag info in git log
        log.date = "iso"; # ISO 8601 date format
        # Conflict resolution style for readable diffs
        merge.conflictStyle = "diff3";
        diff.colorMoved = "default";
        sendemail = {
          smtpserver = "smtp.gmail.com";
          smtpserverport = "587";
          smtpencryption = "tls";
          smtpuser = "${gitEmail}";
        };
      };

      signing = {
        format = "openpgp";
        key = "CCDCA20D4A5F54D004F088A8272D4F26832F8EF8";
        signByDefault = true;
        signer = lib.getExe pkgs.gnupg;
      };
      ignores = [
        ".direnv"
        ".venv"
        "target"
        "result"
        ".Trash-1000"
      ];
    };
  };
}
