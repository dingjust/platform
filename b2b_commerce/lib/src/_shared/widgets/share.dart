import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
import 'package:services/services.dart';

class ShareDialog {
  static void showShareDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FlatButton(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      B2BImage.wechatLogo(height: 50, width: 50),
                      Text('微信好友')
                    ],
                  ),
                  onPressed: () {
                    WechatServiceImpl.instance.shareWeb(
                        'https://www.nbyjy.net/', WeChatScene.SESSION);
                  },
                ),
                FlatButton(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      B2BImage.wechatFriend(height: 50, width: 50),
                      Text('朋友圈')
                    ],
                  ),
                  onPressed: () {
                    // WechatServiceImpl.instance
                    //     .shareWeb('https://www.nbyjy.net/',WeChatScene.TIMELINE);
                  },
                )
              ],
            ));
      },
    );
  }
}
