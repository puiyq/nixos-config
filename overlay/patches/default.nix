final: prev: {
  python3Packages = prev.python3Packages.overrideScope (
    final': prev': {
      sphinxcontrib-newsfeed = prev'.sphinxcontrib-newsfeed.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or [ ]) ++ [ ./fix-for-sphinx-9.1.patch ];
      });
    }
  );
}
