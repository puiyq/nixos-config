{ inputs, ... }:
{
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  programs.zen-browser = {
    enable = true;
    policies = {
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
    };
    profiles.default = rec {
      id = 0;
      name = "default";
      isDefault = true;
      spacesForce = true;
      spaces = {
        "Nix" = {
          id = "14eb76db-104f-454c-9e0f-af7d44df3d71";
          position = 1000;
        };
        "Study" = {
          id = "4df34601-33e0-4f86-adeb-22fb93e208a1";
          position = 2000;
        };
      };
      pinsForce = true;
      pins = {
        # Essential
        "GitHub Dashboard" = {
          id = "4bfd0d63-6619-455b-b30d-c8a84e0100b5";
          url = "https://github.com/dashboard";
          position = 101;
          isEssential = true;
        };
        "Google Gemini" = {
          id = "99e6ac93-17a7-407a-8977-3aa02b3121ba";
          url = "https://gemini.google.com/app";
          position = 102;
          isEssential = true;
        };
        "Claude" = {
          id = "9c97e38c-df8c-4614-a904-1fc44b78bfa5";
          url = "https://claude.ai/new";
          position = 103;
          isEssential = true;
        };
        "ChatGPT" = {
          id = "4adb3e31-2d3f-4eb1-b9b3-52680ddc284a";
          url = "https://chatgpt.com/";
          position = 104;
          isEssential = true;
        };

        # Nix
        "Repo" = {
          id = "9b9bf744-5cbc-416a-a74a-4484a611c73c";
          workspace = spaces.Nix.id;
          isGroup = true;
          editedTitle = true;
          position = 1000;
        };
        "Documentations" = {
          id = "c80daccc-4fdd-42b1-bb35-3420016077b9";
          workspace = spaces.Nix.id;
          isGroup = true;
          isFolderCollapsed = false;
          editedTitle = true;
          position = 1100;
        };

        ## Repo
        "Nixpkgs" = {
          id = "afae4bab-9c44-4e90-b64a-bb2b7b95893b";
          workspace = spaces.Nix.id;
          folderParentId = pins.Repo.id;
          url = "https://github.com/Nixos/nixpkgs/?channel=unstable&";
          position = 1001;
        };
        "Nix Community" = {
          id = "5e3706d8-3ea1-4423-9e03-26067590c1c3";
          workspace = spaces.Nix.id;
          folderParentId = pins.Repo.id;
          url = "https://github.com/nix-community";
          position = 1002;
        };

        ## Documentations
        "Officials" = {
          id = "ac9b2389-0cad-4678-b54a-8067d79d86e8";
          workspace = spaces.Nix.id;
          isGroup = true;
          isFolderCollapsed = false;
          folderParentId = pins.Documentations.id;
          editedTitle = true;
          position = 1101;
        };
        "Community" = {
          id = "ca8c9113-f37e-42be-949a-4d6b1d2dfa93";
          workspace = spaces.Nix.id;
          isGroup = true;
          isFolderCollapsed = false;
          folderParentId = pins.Documentations.id;
          editedTitle = true;
          position = 1120;
        };

        ### Officials
        "Nix Packages" = {
          id = "f8dd784e-11d7-430a-8f57-7b05ecdb4c77";
          workspace = spaces.Nix.id;
          folderParentId = pins.Officials.id;
          url = "https://search.nixos.org/packages";
          position = 1110;
        };
        "Nixpkgs Manual" = {
          id = "fae1d855-0505-49ad-982f-43b72e501aa7";
          workspace = spaces.Nix.id;
          folderParentId = pins.Officials.id;
          url = "https://nixos.org/manual/nixpkgs/unstable/";
          position = 1111;
        };
        "Nix Wiki" = {
          id = "da1f78f3-08f0-4913-b93d-678739ae5e0c";
          workspace = spaces.Nix.id;
          folderParentId = pins.Officials.id;
          url = "https://wiki.nixos.org/wiki/NixOS_Wiki";
          position = 1112;
        };

        ### Community
        "Home Manager" = {
          id = "acff1096-255b-4f2f-8320-5f481d9571c2";
          workspace = spaces.Nix.id;
          folderParentId = pins.Community.id;
          url = "https://nix-community.github.io/home-manager/options.xhtml";
          position = 1121;
        };
        "NVF" = {
          id = "55c5fbd8-6313-49c5-8d35-d9c6e800fc8d";
          workspace = spaces.Nix.id;
          folderParentId = pins.Community.id;
          url = "https://nvf.notashelf.dev/options.html";
          position = 1122;
        };

        # Study
        "Homepage" = {
          id = "0fed1b53-6324-4ca5-a244-a3684abc6ee7";
          workspace = spaces.Study.id;
          url = "https://www.swinburne.edu.my/";
          position = 2001;
        };
        "Canvas" = {
          id = "d00998eb-4c31-479a-8dd2-1368ce8914dc";
          workspace = spaces.Study.id;
          url = "https://swinburnesarawak.instructure.com/";
          position = 2002;
        };
        "Student Portal" = {
          id = "6afb421d-c180-487f-a424-b644c31517db";
          workspace = spaces.Study.id;
          url = "https://sisportal-100380.campusnexus.cloud/CMCPortal/Secure/links/Dashboard1.aspx";
          position = 2003;
        };
      };
    };
  };
}
