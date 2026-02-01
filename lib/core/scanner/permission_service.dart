import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestAudioPermission() async {
    if (await Permission.audio.isGranted) {
      return true;
    }

    final status = await Permission.audio.request();
    return status.isGranted;
  }
}