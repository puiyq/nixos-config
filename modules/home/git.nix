{
  pkgs,
  lib,
  config,
  ...
}:
let
  gitUsername = "Pui Yong Qing";
  gitEmail = "puiyongqing@gmail.com";
  publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIB7iZgUYCqE5xxaSQBxQK1UT1JZb17J0zmT1U891Df6 puiyq@nixos";
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
      settings = {
        user = {
          email = gitEmail;
          name = gitUsername;
        };
        ui = {
          editor = "nvim";
          default-command = [ "log" ];
          diff-editor = ":builtin";
        };
        signing = {
          behavior = "own";
          backend = "ssh";
          backends.ssh.allowed-signers = "${config.home.homeDirectory}/.ssh/allowed-signers";
          key = publicKey;
        };
        git.sign-on-push = true;
      };
    };
    git = {
      enable = true;
      package = pkgs.gitMinimal; # .override { sendEmailSupport = true; };

      settings = {
        user = {
          name = gitUsername;
          email = gitEmail;
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
          smtpuser = gitEmail;
        };
      };

      signing = {
        format = "ssh";
        key = publicKey;
        signByDefault = true;
        signer = lib.getExe' pkgs.openssh "ssh-keygen";
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

  home.file.".ssh/allowed-signers".text = ''
    "${gitUsername} <${gitEmail}>" ${publicKey}
  '';
}
