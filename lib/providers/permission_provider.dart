import 'package:permission_handler/permission_handler.dart';

class PermissionProvider {
  static Future<bool> checkImagePickerPermission() async {
    var statusCamera = await Permission.camera.status;
    var statusPhoto = await Permission.photos.status;
    if (!statusCamera.isGranted || !statusPhoto.isGranted) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
        Permission.photos,
      ].request();
      if (statuses[Permission.camera] == PermissionStatus.granted &&
          statuses[Permission.photos] == PermissionStatus.granted) {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }
}
