{
  lib,
  stdenvNoCC,
  unzip,
}:
stdenvNoCC.mkDerivation {
  pname = "pp-nikkei-journal";
  version = "1.0.0";

  src = ./PPNikkeiJournal.zip;

  sourceRoot = ".";

  postInstall = ''
    install -Dm444 *.ttf -t $out/share/fonts/truetype
  '';

  nativeBuildInputs = [unzip];

  meta = {
    description = "PP Nikkei is a tribute to Japanese immigration to America through typography, honoring the stories of Japanese immigrants and their descendants.";
    homepage = "https://pangrampangram.com/products/nikkei-journal";
    license = lib.licenses.unfreeRedistributable;
    platforms = lib.platforms.linux;
    maintainers = [lib.maintainers.skyrina];
  };
}
