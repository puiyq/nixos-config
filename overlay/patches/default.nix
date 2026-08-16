_final: prev: {
  ananicy-cpp = prev.ananicy-cpp.overrideAttrs {
    patches = [
      (prev.fetchpatch2 {
        name = "fix-cstring-include.patch";
        url = "https://gitlab.com/ananicy-cpp/ananicy-cpp/-/merge_requests/43.diff";
        hash = "sha256-6J7dOunqoa8umCDW6mX28HbL/cn+aaOCcLyhgZBrVX4=";
      })
    ];
  };
}
