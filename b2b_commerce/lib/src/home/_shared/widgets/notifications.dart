import 'package:b2b_commerce/src/my/messages/index.dart';
import 'package:flutter/material.dart';
import 'package:services/services.dart';

class NotificationsIcon extends StatelessWidget {
  ///消息类型分组 1.订单 2.系统 3.财务
  final int msgGroup;

  const NotificationsIcon({Key key, this.msgGroup}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.notifications,
              size: 30,
            ),
            color: Colors.white,
            tooltip: '通知',
            onPressed: () {
               Navigator.push(
                 context,
                 MaterialPageRoute(
                   builder: (context) => MessagePage(),
                 ),
               );
            },
          ),
          Positioned(
              right: 3,
              top: 3,
              child: NotificationBubble(
                msgGroup: msgGroup,
              ))
        ],
      ),
    );
  }
}

class NotificationBubble extends StatelessWidget {
  ///消息类型分组 1.订单 2.系统 3.财务
  final int msgGroup;

  final double fontSize;

  final double width;

  final double height;

  const NotificationBubble({Key key, this.msgGroup,this.width:20,this.height:20,this.fontSize:12}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: getStream(),
      initialData: getNum(),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        return snapshot.data != 0
            ? Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(255, 38, 38, 1),
                ),
                child: Center(
                    child: Text(
                  snapshot.data > 99 ? '...' : '${snapshot.data}',
                  style: TextStyle(color: Colors.white, fontSize: fontSize),
                )),
              )
            : Container();
      },
    );
  }

  Stream getStream() {
    switch (msgGroup) {
      case 1:
        return notificationsPool$.orderNotificationsNumStream;
        break;
      case 2:
        return notificationsPool$.systemNotificationsNumStream;
        break;
      case 3:
        return notificationsPool$.financeNotificationsNumStream;
        break;
      default:
        return notificationsPool$.notificationsNumStream;
    }
  }

  int getNum() {
    switch (msgGroup) {
      case 1:
        return notificationsPool$.orderNotificationsNum;
        break;
      case 2:
        return notificationsPool$.systemNotificationsNum;
        break;
      case 3:
        return notificationsPool$.financeNotificationsNum;
        break;
      default:
        return notificationsPool$.notificationsNum;
    }
  }
}
