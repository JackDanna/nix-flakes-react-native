{ pkgs
, env-android 
}:

{
  devShells.default = pkgs.mkShell
  { 

    buildInputs = with pkgs; [

      #pkgs_23_05.nodejs_16


      # commands
      # dotnet-sdk_8
      # #nodejs_20
      gnome-terminal
      bashInteractive
      (vscode-with-extensions.override  {
        vscode = pkgs.vscode;
        vscodeExtensions = with pkgs.vscode-extensions; [

          ms-dotnettools.csdevkit
          ms-dotnettools.csharp
          #ms-dotnettools.vscode-dotnet-runtime

          jnoortheen.nix-ide
          mhutchie.git-graph
          vscode-extensions.eamodio.gitlens

          # F# intellisense
          #ionide.ionide-fsharp
          #oldPkgs.vscode-extensions.ms-dotnettools.csharp # We need to make sure we use version 2.39.32 since there is a bug otherise: https://github.com/ionide/ionide-vscode-fsharp/issues/2039


          #bradlc.vscode-tailwindcss
          #vscodevim.vim
          #streetsidesoftware.code-spell-checker
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [

          {
            name = "vscode-dotnet-runtime";
            publisher = "ms-dotnettools";
            version = "2.3.7";
            sha256 = "sha256-Pe0rgs1vDbaOO178lB5P/Z+gqmf6LALIIZB3DntkmOc=";
          }

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

      #pkgs.nodePackages.react-native-cli
      cmake

      
      # # Android SDK and tools
      # androidSdk
      
      # # Java (required for Android development)
      # jdk17
      
      # # Additional useful tools
      # adb-sync
      # scrcpy  # Screen mirroring for physical devices
      
      # # Our custom scripts
      # emulatorScript
      # avdManagerScript
      
      # # Optional: Android Studio (comment out if not needed)
      # # android-studio
    ];
    # packages = 
    # [ 
      
    # ];

    ANDROID_SDK_ROOT = "${env-android.androidRootSdk}";
    ANDROID_NDK_ROOT = "${env-android.androidRootNdk}";

    GRADLE_OPTS = "${env-android.aapt2Override}";

    shellHook = ''
      buildAndroidDebug ()
      {
        npx react-native build-android --no-packager --extra-params --parallel
      }
    '';
  };
}
