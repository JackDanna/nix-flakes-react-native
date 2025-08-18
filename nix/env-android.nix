{ pkgs
,
}:

rec {
  androidHome = "${androidComposition.androidsdk}/libexec/android-sdk";
  androidRootSdk = "${androidComposition.androidsdk}/libexec/android-sdk";
  androidRootNdk = "${androidRootSdk}/ndk-bundle";
  aapt2Override = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${androidRootSdk}/build-tools/${buildToolsVersion}/aapt2";

  buildToolsVersion = "33.0.1";

  androidComposition = pkgs.androidenv.composeAndroidPackages {
    toolsVersion = "26.1.1";
    #platformToolsVersion = "33.0.3";
    buildToolsVersions = [ "33.0.1" ];
    includeEmulator = true;
    #emulatorVersion = "31.3.14";
    platformVersions = [ "33" ];
    includeSources = false;
    includeSystemImages = false;
    systemImageTypes = [ "google_apis_playstore" ];
    abiVersions = [ "armeabi-v7a" "arm64-v8a" ];
    cmakeVersions = [ "3.18.1" ];
    includeNDK = true;
    #ndk.version = "27.1.12297006";
    ndkVersions = ["27.1.12297006"];
    useGoogleAPIs = false;
    useGoogleTVAddOns = false;
    includeExtras = [
      "extras;google;gcm"
    ];
  };
}
