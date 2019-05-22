//import 'dart:io';
//
//import 'package:path_provider/path_provider.dart';
//import 'package:permission_handler/permission_handler.dart';
//
//import '../config/configs.dart';
//
//class LocalPath {
//  static getLocalPath() async {
//    Directory appDir;
//    if (Platform.isIOS) {
//      appDir = await getApplicationDocumentsDirectory();
//    } else {
//      appDir = await getExternalStorageDirectory();
//    }
//    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
//    if (permission != PermissionStatus.granted) {
//      Map<PermissionGroup, PermissionStatus> permissions =
//          await PermissionHandler().requestPermissions([PermissionGroup.storage]);
//      if (permissions[PermissionGroup.storage] != PermissionStatus.granted) {
//        return null;
//      }
//    }
//    String appDocPath = appDir.path + "/" + GlobalConfigs.APP_NAME;
//    Directory appPath = Directory(appDocPath);
//    await appPath.create(recursive: true);
//    return appPath;
//  }
//}
