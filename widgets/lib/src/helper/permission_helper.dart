import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Map<Permission, String> PERMISSION_VALUE_MAP = {
    Permission.camera: '相机',
    Permission.mediaLibrary: '图库',
    Permission.photos: '图库',
    Permission.storage: '照片及文件',
    Permission.accessMediaLocation: '存储',
  };

  static Future<bool> check(Permission val) async {
    PermissionStatus status = await val.status;
    if (status == PermissionStatus.undetermined) {
      PermissionStatus requestResult = await val.request();
      if (requestResult == PermissionStatus.granted) {
        return true;
      } else {
        showOpeningSettingDialog(val);
        return false;
      }
    } else if (status == PermissionStatus.granted) {
      return true;
    } else {
      showOpeningSettingDialog(val);
      return false;
    }
  }

  static void showOpeningSettingDialog(Permission val) {
    BotToast.showCustomNotification(
      onlyOne: true,
      duration: null,
      crossPage: false,
      // clickClose: true,
      toastBuilder: (cancelFunc) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        // title: const Text('温馨提示'),
        content: Text('您未允许钉单获取${getPermissVlue(val)}权限，请在系统设置中开启'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              cancelFunc.call();
            },
            child: const Text(
              '暂不',
              style: TextStyle(color: Colors.lightBlue),
            ),
          ),
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

  ///获取权限名称
  static String getPermissVlue(Permission val) {
    if (PERMISSION_VALUE_MAP[val] != null) {
      return PERMISSION_VALUE_MAP[val];
    } else {
      return '';
    }
  }
}
