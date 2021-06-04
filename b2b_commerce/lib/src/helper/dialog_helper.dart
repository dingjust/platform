import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

///弹窗帮助类
class DialogHelper {
  static showError({String title, String content}) {
    BotToast.showCustomText(
      onlyOne: true,
      duration: null,
      clickClose: true,
      crossPage: true,
      backgroundColor: Colors.black38,
      toastBuilder: (cancelFunc) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        title: title != null ? Text('$title') : Container(),
        content: Text('$content'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              cancelFunc();
            },
            child: const Text(
              '确定',
            ),
          ),
        ],
      ),
    );
  }

  static showConfirm(
      {String title,
      String content,
      VoidCallback cancel,
      VoidCallback confirm}) {
    BotToast.showCustomText(
      onlyOne: true,
      duration: null,
      clickClose: true,
      crossPage: true,
      backgroundColor: Colors.black38,
      toastBuilder: (cancelFunc) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        title: title != null ? Text('$title') : Container(),
        content: Text('$content'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              cancelFunc();
              if (cancel != null) {
                cancel.call();
              }
            },
            child: const Text(
              '取消',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          FlatButton(
            onPressed: () {
              cancelFunc();
              if (confirm != null) confirm();
            },
            child: const Text(
              '确定',
            ),
          ),
        ],
      ),
    );
  }
}
