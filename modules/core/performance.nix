{ pkgs, ... }:

{
  services = {
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };
    swapspace.enable = true;
    scx = {
      enable = true; # by default uses scx_rustland scheduler
      scheduler = "scx_rusty";
      package = pkgs.scx.rustscheds;
      extraArgs = [
        "--balanced-kworkers" # let kernel handle kworker balancing (>=6.6), avoid conflicting with scx
        "--kthreads-local" # pin per-cpu kthreads to local dsq for lower latency
      ];
    };
  };
}
