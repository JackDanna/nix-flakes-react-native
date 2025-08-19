{
  pkgs,
  env-android,
}:
let
  name = "example-build-0.0.1";
  src = ../Temp;

  buildInputs = with pkgs; [
    gradle
    jdk17
    nodejs_20
    #nodePackages.react-native-cli
    # cmake  # Removed - causes CMake auto-configuration which fails for React Native projects
  ];

  mkWithWarning = msg: args@{ ... }: pkgs.lib.warn msg (pkgs.stdenv.mkDerivation args);

  notFunctionalWarning = "This build is not functional because gradle.";
  mkWithWarningNotFunctional = args@{ ... }: mkWithWarning "${notFunctionalWarning}" args;

in
{
  debugBuild = mkWithWarningNotFunctional {
    inherit name;
    inherit src;
    inherit buildInputs;

    # Disable automatic CMake configuration
    dontUseCmakeConfigure = true;
    dontUseNinjaBuild = true;
    dontUseNinjaInstall = true;

    configurePhase = ''
      export ANDROID_HOME="${env-android.androidHome}"
      export ANDROID_SDK_ROOT="${env-android.androidRootSdk}"
      export ANDROID_NDK_ROOT="${env-android.androidRootNdk}"

      # Make gradlew executable
      chmod +x android/gradlew
    '';

    buildPhase = ''
      cd android
      # Use system gradle instead of wrapper to avoid network download
      gradle assembleDebug --offline --no-daemon
    '';

    installPhase = ''
      mkdir -p $out
      cp android/app/build/outputs/apk/debug/app-debug.apk $out/
    '';
  };

  # {{{ TODO
  # To get a bit further, you can modify `gradle-wrapper.properties` to include
  # a local gradle .zip. This avoids java erroring out when attempting to download this gradle version
  # }}}
  android-debug-react = mkWithWarningNotFunctional {
    inherit name;
    inherit src;
    inherit buildInputs;

    buildPhase = ''
      HOME_GRADLE_TMP="$(mktemp -d)"
      export GRADLE_USER_HOME="$HOME_GRADLE_TMP"

      export ANDROID_SDK_ROOT="${env-android.androidRootSdk}"
      export ANDROID_NDK_ROOT="${env-android.androidRootNdk}"

      react-native build-android --no-packager --mode debug --extra-params "--parallel --no-daemon --no-build-cache ${env-android.aapt2Override}"
    '';

    installPhase = ''
      mkdir -p $out
      mv $src/android/app/build/outputs/apk/debug/app-debug.apk $out
    '';
  };

  # {{{ TODO
  # This one is close, but only if `node_modules` is commited to the repository
  # Next step is figuring out how to pull in the gradle plugins
  # }}}
  android-debug-gradle = mkWithWarningNotFunctional {
    inherit name;
    inherit src;
    inherit buildInputs;

    configurePhase = ''
      mkdir -p $out/gradle-home
      mkdir $out/build-dir
      cp -r $src/* $out/build-dir
    '';

    buildPhase = ''
      HOME_GRADLE_TMP="$(mktemp -d)"
      export GRADLE_USER_HOME="$HOME_GRADLE_TMP"
      export ANDROID_HOME="${env-android.androidHome}"

      cd $out/build-dir/android
      gradle build --offline --project-cache-dir $GRADLE_USER_HOME --no-daemon --no-build-cache --parallel "${env-android.aapt2Override}"
    '';

    installPhase = ''
      mv $src/android/app/build/outputs/apk/debug/app-debug.apk $out
    '';
  };
}
