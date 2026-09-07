let
  lockFile = builtins.fromJSON (builtins.readFile ./flake.lock);
  flakeCompatNode = lockFile.nodes.${lockFile.nodes.root.inputs.flake-compat};
  flakeCompat = fetchTarball {
    inherit (flakeCompatNode.locked) url;
    sha256 = flakeCompatNode.locked.narHash;
  };

  flake = import flakeCompat {
    src = ./.;
    copySourceTreeToStore = false;
  };
in
flake.defaultNix
