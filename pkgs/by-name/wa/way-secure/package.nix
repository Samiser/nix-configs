{
  lib,
  rustPlatform,
  fetchFromSourcehut,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "way-secure";
  version = "0.2.0-unstable-2026-08-18";

  src = fetchFromSourcehut {
    owner = "~whynothugo";
    repo = "way-secure";
    rev = "51ff3bb4f30305e698d95d8d0dfcb79982f602b6";
    hash = "sha256-fyoSNS2R+Pr8xQEUj7rkFKCfrQ95VeH+nwaLCLNNfpw=";
  };

  cargoHash = "sha256-QzPJPUQjwAtqJiCqQM8lmtdxQDOLTsZrIIpjkyKNDNI=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage way-secure.1
  '';

  meta = {
    description = "Helper to create Wayland security contexts via security-context-v1";
    homepage = "https://git.sr.ht/~whynothugo/way-secure";
    changelog = "https://git.sr.ht/~whynothugo/way-secure/tree/${finalAttrs.src.rev}/item/CHANGELOG.md";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ samiser ];
    mainProgram = "way-secure";
    platforms = lib.platforms.linux;
  };
})
