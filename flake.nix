{
  description = "React Native via Nix Flakes";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:

      let
        pkgs = import nixpkgs {
          inherit system;

          config = {
            allowUnfree = true;
            android_sdk.accept_license = true;
            allowUnfreePredicate =
              pkg:
              builtins.elem (builtins.parseDrvName pkg.pname).name [
                "androidsdk"
              ];
          };
        };

        env-android = import ./nix/env-android.nix { inherit pkgs; };

        builds = import ./nix/builds.nix {
          inherit
            pkgs
            env-android
            ;
        };

      in
      {
        packages = {
          default = builds.debugBuild;
          android-debug-gradle = builds.android-debug-gradle;
          android-debug-react = builds.android-debug-react;
        };

        devShells.default = pkgs.mkShell {

          buildInputs = with pkgs; [

            # vscode IDE with all extensions needed
            gnome-terminal
            bashInteractive
            nixfmt
            (vscode-with-extensions.override {
              vscode = pkgs.vscode;
              vscodeExtensions =
                with pkgs.vscode-extensions;
                [
                  jnoortheen.nix-ide
                  mhutchie.git-graph
                  vscode-extensions.eamodio.gitlens
                ]
                ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [

                  {
                    name = "copilot";
                    publisher = "github";
                    version = "1.356.1733";
                    sha256 = "sha256-xbSpEEZF5vMKvkM61k03INVVTJc5/ZRcIIz49c8OSx4=";
                  }

                  {
                    name = "copilot-chat";
                    publisher = "github";
                    version = "0.30.1";
                    sha256 = "sha256-itANvwMSzFBPnU4B6erEXO/x3SNlqHygXlTE6jLc+0U=";
                  }

                  {
                    name = "vscode-office";
                    publisher = "cweijan";
                    version = "3.2.5";
                    sha256 = "sha256-TsPlzIf/ieUW/13NQ0strDQTVFvwtrO48fJSUbMu1Bc=";
                  }
                ];
            })

            (pkgs.writeShellScriptBin "iDontKnow" ''
              ${pkgs.figlet}/bin/figlet "IDontKnow"
            '')

            android-tools
            jdk17
            nodejs_20

            cmake

            # # Android SDK and tools
            # androidSdk

            # # Additional useful tools
            # adb-sync
            # scrcpy  # Screen mirroring for physical devices
          ];

          ANDROID_SDK_ROOT = "${env-android.androidRootSdk}";
          ANDROID_NDK_ROOT = "${env-android.androidRootNdk}";
          ANDROID_NDK_HOME = "${env-android.androidRootNdk}";
          NDK_ROOT = "${env-android.androidRootNdk}";

          GRADLE_OPTS = "${env-android.aapt2Override}";

          shellHook = ''
            buildAndroidDebug ()
            {
              npx react-native build-android --no-packager --extra-params --parallel
            }
          '';
        };
      }
    );
}
