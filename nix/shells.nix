{ pkgs
, env-android 
}:

{
  devShells.default = pkgs.mkShell
  {
    packages = 
    [ 
      pkgs.android-tools 
      pkgs.jdk17 
      pkgs.nodejs_20

      #pkgs.nodePackages.react-native-cli
      pkgs.cmake
    ];

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
