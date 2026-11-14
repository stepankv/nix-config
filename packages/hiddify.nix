{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  wrapGAppsHook3,
  atk,
  cairo,
  curl,
  fontconfig,
  gdk-pixbuf,
  glib,
  gtk3,
  harfbuzz,
  libayatana-appindicator,
  libdbusmenu,
  libepoxy,
  pango,
  zstd,
}:

let
  pname = "hiddify";
  version = "5.5.5";
  appimage = fetchurl {
    url = "https://github.com/hiddify/hiddify-app/releases/download/v${version}/Hiddify-Linux-x64-AppImage.AppImage";
    hash = "sha256-0cpIwiqtOMs6UyT8uq2f3aV9dHedBnHffxTJnIXW0EE=";
  };
in
stdenv.mkDerivation {
  inherit pname version;

  src = appimageTools.extract {
    inherit pname version;
    src = appimage;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    atk
    cairo
    curl
    fontconfig
    gdk-pixbuf
    glib
    gtk3
    harfbuzz
    libayatana-appindicator
    libdbusmenu
    libepoxy
    pango
    stdenv.cc.cc.lib
  ];

  runtimeDependencies = [ (lib.getLib zstd) ];
  appendRunpaths = [ "${placeholder "out"}/lib/hiddify/lib" ];
  dontBuild = true;
  dontStrip = true;
  dontWrapGApps = true;

  desktopItems = [
    (makeDesktopItem {
      name = "hiddify";
      desktopName = "Hiddify";
      exec = "hiddify";
      icon = "hiddify";
      terminal = false;
      categories = [ "Network" ];
      keywords = [
        "vpn"
        "proxy"
      ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/hiddify" "$out/bin"
    cp -r hiddify HiddifyCli lib data "$out/lib/hiddify/"
    install -Dm644 hiddify.png "$out/share/icons/hicolor/256x256/apps/hiddify.png"

    # The upstream CLI resolves this dependency against the working directory.
    patchelf --replace-needed ./lib/hiddify-core.so hiddify-core.so \
      "$out/lib/hiddify/HiddifyCli"

    ln -s "$out/lib/hiddify/HiddifyCli" "$out/bin/HiddifyCli"

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper "$out/lib/hiddify/hiddify" "$out/bin/hiddify" \
      --unset APPIMAGE \
      --prefix PATH : /run/wrappers/bin \
      "''${gappsWrapperArgs[@]}"
  '';

  meta = {
    description = "Multi-platform proxy client with a system VPN backend";
    homepage = "https://github.com/hiddify/hiddify-app";
    license = lib.licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = "hiddify";
  };
}
