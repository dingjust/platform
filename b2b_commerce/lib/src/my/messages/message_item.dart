import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'message_detail.dart';

class MessageItemPage extends StatelessWidget {
  NotifyModel model;

  MessageItemPage({this.model});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        NotificationsPool.instance.read(model.code);
        if(model.groupCode != 1) {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => MessageDetailPage(model: model,)
            ),
          );
        } else {
          print('=====');
          jpush$.onOpenMessage(model);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: <Widget>[
            _buildHead(context),
            _buildItem(),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget _buildHead(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          model.read == null || model.read ? Container() : _buildRedDot(),
          Expanded(
            child: Container(
              child: Text(
                '${model.title}',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          Container(
            child: Text(
              '${DateFormatUtil.formatYMD(model.creationtime)}',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNoPic(){
    if (model.groupCode == 2) {
      return Container(
        margin: EdgeInsets.fromLTRB(10, 15, 5, 0),
        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
        width: 80,
        height: 80,
        child: Image.asset(
          'temp/system_msg.png',
          package: 'assets',
        ),
      );
    } else if (model.groupCode == 3) {
      return Container(
        margin: EdgeInsets.fromLTRB(10, 15, 5, 0),
        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
        width: 80,
        height: 80,
        child: Image.asset(
          'temp/money_msg.png',
          package: 'assets',
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.fromLTRB(10, 15, 5, 0),
        padding: EdgeInsets.fromLTRB(5, 10, 15, 10),
        child: Center(
          child: Icon(
            B2BIcons.noPicture,
            color: Color.fromRGBO(200, 200, 200, 1),
            size: 60,
          ),
        ),
        width: 80,
        height: 80,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Color.fromRGBO(243, 243, 243, 1)),
      );
    }
  }

  Widget _buildItem(){
    return Container(
      child: Row(
        children: <Widget>[
          model.images == null || model.images.length <= 0 ?
          _buildNoPic()
           :
          Container(
            width: 80,
            height: 80,
            child: Image.network(
                '${model.images[0].thumbnailUrl()}',
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color.fromRGBO(243, 243, 243, 1)),
          ),

          //  Container(
          //     width: 60,
          //     height: 60,
          //     child: Image.network(
          //       model.coverImgUrl,
          //     ),
          //   ),
          Expanded(
            child: Container(
              child: Text(
                '${model.body}',
                softWrap: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRedDot(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.red,
      ),
    );
  }

}