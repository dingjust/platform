import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ShareDialog {
  static void showShareDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Color.fromRGBO(245, 245, 245, 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 50,
                                child: Icon(
                                  B2BIcons.wechat,
                                  size: 40,
                                  color: Color.fromRGBO(0, 211, 12, 1),
                                ),
                              ),
                              Text('微信好友')
                            ],
                          ),
                          onPressed: () {
                            WechatServiceImpl.instance.shareWeb(
                                'https://www.nbyjy.net/',
                                WeChatScene.SESSION,
                                '分享测试',
                                '分享描述',
                                'https://g-search1.alicdn.com/img/bao/uploaded/i4/i3/4103014183/O1CN01H35VRQ1glrGidMD6U_!!0-item_pic.jpg_460x460Q90.jpg_.webp');
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
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    child: FlatButton(
                      child: Text(
                        '取消',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                )
              ],
            ));
      },
    );
  }
}
