{
  lib,
  fetchurl,
  gitUpdater,
  libarchive,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "omniwm";
  version = "0.6.0";

  src = fetchurl {
    url = "https://github.com/BarutSRB/OmniWM/releases/download/v${finalAttrs.version}/OmniWM-v${finalAttrs.version}.zip";
    hash = "sha256-XGGSvvtU7m9Ffe7t9ob5LAIzNhEPNZPGBjd9he2NRi4=";
  };

  dontUnpack = true;

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ libarchive ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    bsdtar -xf $src -C $out/Applications

    mkdir -p $out/bin
    ln -s $out/Applications/OmniWM.app/Contents/MacOS/OmniWM $out/bin/OmniWM
    ln -s $out/Applications/OmniWM.app/Contents/MacOS/omniwmctl $out/bin/omniwmctl

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {
    url = "https://github.com/BarutSRB/OmniWM.git";
    rev-prefix = "v";
  };

  meta = {
    description = "Tiling window manager for macOS inspired by Niri and Hyprland";
    homepage = "https://github.com/BarutSRB/OmniWM";
    license = lib.licenses.gpl2Only;
    mainProgram = "OmniWM";
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
