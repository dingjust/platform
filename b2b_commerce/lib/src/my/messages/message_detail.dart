import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class MessageDetailPage extends StatefulWidget {
  NotifyModel model;
  MessageDetailPage({this.model});

  _MessageDetailPageState createState() => _MessageDetailPageState();
}

class _MessageDetailPageState extends State<MessageDetailPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          centerTitle: true,
          elevation: 0.5,
          title: Text(
            '${widget.model.groupCode == 2 ? '系统消息' : '账务消息'}',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              _buildHead(),
//            _buildOrderDetail(),
            ],
          ),
        ),
        backgroundColor: Colors.white,
      ),
      onWillPop: (){
        NotifyBloC.instance.refreshData(widget.model.groupCode.toString());
        Navigator.pop(context);
        return Future.value(false);
      },
    );
  }

  Widget _buildHead(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: Column(
        children: <Widget>[
          _buildMessageType(),
          Divider(
            height: 1,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              '${widget.model.body}'
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageType(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Text(
                '${widget.model.title}',
                style: TextStyle(
                  color: Colors.black
                ),
              ),
            ),
          ),
          Container(
            child: Text(
              '${DateFormatUtil.formatYMD(widget.model.creationtime)}',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetail(){
    return Container(
      color: Colors.black12,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: 80,
            height: 80,
            child: CachedNetworkImage(
                imageUrl: 'https://img.alicdn.com/imgextra/i2/266923241/O1CN01THbnwK1ZoQBayYsh7_!!266923241.jpg',
                fit: BoxFit.cover,
                placeholder: (context, url) =>  SpinKitRing(
                  color: Colors.black12,
                  lineWidth:2,
                  size: 30.0,
                ),
                errorWidget: (context, url, error) => SpinKitRing(
                  color: Colors.black12,
                  lineWidth:2,
                  size: 30,
                )
            ),
          ),
          Expanded(
              child: Container(
                  padding: const EdgeInsets.all(10),
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child:  Text(
                          '女士T恤',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            '货号：SKU123123',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 243, 243, 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "针织  66件",
                          style: const TextStyle(
                            fontSize: 15,
                            color: const Color.fromRGBO(255, 133, 148, 1),
                          ),
                        ),
                      )
                    ],
                  )
              )
          ),
          Container(
            child: Icon(
              Icons.keyboard_arrow_right,
            ),
          ),
        ],
      ),
    );
  }

}
