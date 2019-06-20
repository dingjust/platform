import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ShareDialog {
  static void showShareDialog(BuildContext context,
      {@required String url,
        @required String title,
        @required String description,
        @required String imageUrl}) {
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
                    child: ListView(
                      scrollDirection: Axis.horizontal,
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
                                '$url',
                                WeChatScene.SESSION,
                                '$title',
                                '$description',
                                '$imageUrl');
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
                            WechatServiceImpl.instance.shareWeb(
                                '$url',
                                WeChatScene.TIMELINE,
                                '$title',
                                '$description',
                                '$imageUrl');
                          },
                        ),
                        FlatButton(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              B2BImage.qq(height: 50, width: 50),
                              Text('发送给好友')
                            ],
                          ),
                          onPressed: () {
                            QQService.instance.share('$url',
                                imageUrl: '$imageUrl',
                                summary: '$description',
                                title: '$title');
                          },
                        ),
                        FlatButton(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              B2BImage.qqZone(height: 50, width: 50),
                              Text('分享到空间')
                            ],
                          ),
                          onPressed: () {
                            QQService.instance.shareQQzone('$url',
                                imageUrl: '$imageUrl',
                                summary: '$description',
                                title: '$title');
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
