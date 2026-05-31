// Build-time configuration for API endpoints.
//
// CI/CD (build-apk.sh) overwrites this file with production values before
// building the release APK.  On local development the defaults below keep
// everything pointing at localhost / emulator.
class BuildConfig {
  static const String apiHost = '';
  static const String apiPort = '';
  static const String baseUrl = '';
}
