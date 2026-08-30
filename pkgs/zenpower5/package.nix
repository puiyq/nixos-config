{
  clangStdenv,
  lib,
  fetchFromGitHub,
  kernel,
  llvmPackages,
}:

clangStdenv.mkDerivation {
  pname = "zenpower5";
  version = "0.5.0-main";

  src = fetchFromGitHub {
    owner = "Artanejp";
    repo = "zenpower5";
    rev = "746c9af";
    hash = "sha256-Gecm9JGoYEOWZiVoBVmIj5zMB5izOT2x35+nEy+XXE8=";
  };

  hardeningDisable = [
    "pic"
    "format"
  ];
  nativeBuildInputs = kernel.moduleBuildDependencies ++ [ llvmPackages.bintools ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "-Wimplicit-fallthrough=3" "-Wimplicit-fallthrough"
  '';

  buildPhase = ''
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build \
      LLVM=1 \
      M=$PWD \
      KCFLAGS="-Wno-unused-command-line-argument" \
      modules
  '';

  installPhase = ''
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build \
      M=$PWD \
      LLVM=1 \
      INSTALL_MOD_PATH=${placeholder "out"} \
      INSTALL_MOD_DIR=kernel/drivers/hwmon \
      modules_install
  '';

  meta = {
    description = "Linux kernel driver for AMD Zen CPU monitoring (Zen 1-5): temperature, voltage, current, and power via SVI2/RAPL. Multi-file architecture with Zen 5 (Strix Halo) support.";
    homepage = "https://github.com/mattkeenan/zenpower5";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
