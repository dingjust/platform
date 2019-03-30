import 'package:flutter/material.dart';

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
}