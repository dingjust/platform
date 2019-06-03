import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ShowDialogUtil{

  //操作提示弹框
  static Future<void> showAlertDialog(BuildContext context,String text,VoidCallback onPressed){
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('提示',
            style: TextStyle(
              fontSize: 16,
            ),),
          content: Text(text),
          actions: <Widget>[
            FlatButton(
              child: Text(
                '取消',
                style: TextStyle(
                    color: Colors.grey
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                '确定',
                style: TextStyle(
                    color: Colors. black
                ),
              ),
              onPressed: onPressed,
            ),
          ],
        );
      },
    );
  }

  //操作提示弹框
  static Future<void> showAlertDialog2(BuildContext context,String text,VoidCallback onCanel,VoidCallback onPressed){
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('提示',
            style: TextStyle(
              fontSize: 16,
            ),),
          content: Text(text),
          actions: <Widget>[
            FlatButton(
              child: Text(
                '取消',
                style: TextStyle(
                    color: Colors.grey
                ),
              ),
              onPressed: onCanel,
            ),
            FlatButton(
              child: Text(
                '确定',
                style: TextStyle(
                    color: Colors. black
                ),
              ),
              onPressed: onPressed,
            ),
          ],
        );
      },
    );
  }

  //提示弹框
  static Future<void> showSimapleDialog(BuildContext context,String message){
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (context) {
          return SimpleDialog(
            title: const Text('提示', style: const TextStyle(fontSize: 16)),
            children: <Widget>[SimpleDialogOption(child: Text('$message'))],
          );
        },
      );
  }

  static showSnakeBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message), duration: Duration(seconds: 1),);
    Scaffold.of(context).showSnackBar(snackBar);
  }

  // 如果弹不出请用这个
  static showSnakeBarByKey(final GlobalKey<ScaffoldState> key,
      BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message), duration: Duration(seconds: 1),);
    key.currentState.showSnackBar(snackBar);
  }

  //非空提示
  static Future<void> showValidateMsg(BuildContext context, String message) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.RESULT_DIALOG,
            failTips: '${message}',
            callbackResult: false,
            outsideDismiss: true,
          );
        });
  }
}