{
  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.jdk21
            pkgs.jdk17
            pkgs.jdk11
            pkgs.jdk8
            pkgs.gradle
            pkgs.jdt-language-server
            (pkgs.jetbrains.idea-community.override {
              # forceWayland = true;
              vmopts = "-Dawt.toolkit.name=WLToolkit";
            })
            pkgs.maven

            pkgs.moreutils # chronic for ./build.sh
          ];

          buildInputs = [
            pkgs.glfw
            pkgs.libGL

            pkgs.libpulseaudio
            pkgs.openal

            pkgs.flite
          ];

          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
            pkgs.glfw
            pkgs.libGL

            pkgs.libpulseaudio
            pkgs.openal

            pkgs.flite
          ];

          shellHook = ''
            export JAVA8_HOME=${pkgs.jdk8}
            export JAVA11_HOME=${pkgs.jdk11}
            export JAVA17_HOME=${pkgs.jdk17}
            export JAVA21_HOME=${pkgs.jdk21}
          '';
        };
      }
    );
}