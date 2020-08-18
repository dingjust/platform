import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Map<Permission, String> PERMISSION_VALUE_MAP = {
    Permission.camera: '相机',
    Permission.mediaLibrary: '图库',
    Permission.photos: '图库',
    Permission.storage: '存储',
    Permission.accessMediaLocation: '存储',
  };

  static check() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.mediaLibrary,
      Permission.photos,
      Permission.storage,
      Permission.accessMediaLocation,
    ].request();

    print('============权限请求如下============');
    bool flag = false;
    String permissionStr = '';
    statuses.forEach((permission, status) {
      if (status == PermissionStatus.permanentlyDenied ||
          status == PermissionStatus.restricted ||
          status == PermissionStatus.denied) {
        flag = true;
        permissionStr = permissionStr + ' ' + getPermissVlue(permission);
      }
      print('${permission}:${status}');
    });

    //是否有被禁止的权限
    if (flag) {
      BotToast.showCustomText(
        onlyOne: true,
        duration: null,
        crossPage: false,
        clickClose: true,
        toastBuilder: (cancelFunc) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          // title: const Text('温馨提示'),
          content: Text('钉单正在请求:$permissionStr权限，请前往设置避免影响正常使用'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                openAppSettings();
              },
              child: const Text(
                '去设置',
                style: TextStyle(color: Colors.lightBlue),
              ),
            ),
          ],
        ),
      );
    }

    print('========================');
  }

  ///获取权限名称
  static String getPermissVlue(Permission val) {
    if (PERMISSION_VALUE_MAP[val] != null) {
      return PERMISSION_VALUE_MAP[val];
    } else {
      return '';
    }
  }
}
