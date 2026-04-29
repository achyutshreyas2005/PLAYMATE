import 'dart:io' show Platform;

class Constants {
  // Use 10.0.2.2 for Android emulator testing against local host
  static String get baseUrl {
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return "http://127.0.0.1:8000";
    } else if (Platform.isAndroid) {
      return "http://10.0.2.2:8000";
    }
    return "http://localhost:8000"; // Web fallback
  }
}
