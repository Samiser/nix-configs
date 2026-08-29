{
  lib,
  rustPlatform,
  fetchFromSourcehut,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "way-secure";
  version = "0.2.0";

  src = fetchFromSourcehut {
    owner = "~whynothugo";
    repo = "way-secure";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ppbCl7NGa8nW6k4zRP3dubOr5LwCuECjbSExDstxQ5o=";
  };

  cargoHash = "sha256-AE+pqQaqQp9C55IL1NOAP7pSZ2Pkg46g1x5oup+IBHw=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage way-secure.1
  '';

  meta = {
    description = "Helper to create Wayland security contexts via security-context-v1";
    homepage = "https://git.sr.ht/~whynothugo/way-secure";
    changelog = "https://git.sr.ht/~whynothugo/way-secure/tree/v${finalAttrs.version}/item/CHANGELOG.md";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ samiser ];
    mainProgram = "way-secure";
    platforms = lib.platforms.linux;
  };
})
