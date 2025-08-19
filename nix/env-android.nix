{
  pkgs,
}:

rec {
  androidHome = "${androidComposition.androidsdk}/libexec/android-sdk";
  androidRootSdk = "${androidComposition.androidsdk}/libexec/android-sdk";
  androidRootNdk = "${androidRootSdk}/ndk-bundle";
  aapt2Override = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${androidRootSdk}/build-tools/${buildToolsVersion}/aapt2";

  buildToolsVersion = "36.0.0";

  androidComposition = pkgs.androidenv.composeAndroidPackages {
    toolsVersion = "26.1.1";
    #platformToolsVersion = "33.0.3";
    buildToolsVersions = [
      "33.0.1"
      "35.0.0"
      "36.0.0"
    ];
    includeEmulator = true;
    #emulatorVersion = "31.3.14";
    platformVersions = [
      "33"
      "35"
      "36"
    ];
    includeSources = false;
    includeSystemImages = false;
    systemImageTypes = [ "google_apis_playstore" ];
    abiVersions = [
      "armeabi-v7a"
      "arm64-v8a"
    ];
    cmakeVersions = [
      "3.18.1"
      "3.22.1"
    ];
    includeNDK = true;
    ndkVersions = [ "27.1.12297006" ];
    useGoogleAPIs = false;
    useGoogleTVAddOns = false;
    includeExtras = [
      "extras;google;gcm"
    ];
  };
}
