{
  pkgs,
  lasergraph-timecode-importer,
  ...
}: let
  lasergraphTimecodeImporter = lasergraph-timecode-importer.packages.${pkgs.system}.default;
in {
  home.packages = [
    lasergraphTimecodeImporter
  ];

  programs.fish.interactiveShellInit = ''
    ${lasergraphTimecodeImporter}/bin/lasergraph-timecode-importer completions fish | source
  '';
}
