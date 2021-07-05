import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Utility {
  static Future<PermissionStatus> checkPermission(Permission permission) async {
    final PermissionStatus _permissionStatus = await permission.status;
    if (!_permissionStatus.isGranted && !_permissionStatus.isDenied) {
      debugPrint('Permission granted');
    } else if (_permissionStatus.isLimited) {
      debugPrint('Permission limited');
    } else if (_permissionStatus.isPermanentlyDenied) {
      debugPrint('Permission permanently denied');
    } else if (_permissionStatus.isRestricted) {
      debugPrint('Permission restricted');
    }
    return _permissionStatus;
  }

  static Future<PermissionStatus?> requestPermission(Permission permission) async {
    final PermissionStatus _permissionStatus = await permission.status;
    if (!_permissionStatus.isGranted) {
      debugPrint('Permission granted');
      final Map<Permission, PermissionStatus> permissionStatus = await [permission].request();
      return permissionStatus[permission];
    }
    return _permissionStatus;
  }
}
