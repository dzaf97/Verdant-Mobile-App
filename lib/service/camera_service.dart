import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraService extends GetxController {
  final picker = ImagePicker();
  final imageQuality = 10;
  final gallery = ImageSource.gallery;
  final camera = ImageSource.camera;

  getImage({required ImageSource source}) async {
    var permission = await Permission.photos.status;
    if (permission.isDenied) {
      final XFile? pickImage = await picker.pickImage(
        source: source,
        imageQuality: imageQuality,
      );

      if (pickImage != null) {
        final File file = File(pickImage.path);
        return {"error": false, "image": file.path};
      } else {
        return {"error": true, "image": ""};
      }
    } else if (permission.isGranted || permission.isLimited) {
      final XFile? pickImage = await picker.pickImage(
        source: source,
        imageQuality: imageQuality,
      );

      if (pickImage != null) {
        final File file = File(pickImage.path);
        return {"error": false, "image": file.path};
      } else {
        return {"error": true, "image": ""};
      }
    } else {
      openAppSettings();
      return {"error": true, "image": ""};
    }
  }
}
