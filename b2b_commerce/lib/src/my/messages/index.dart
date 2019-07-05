import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/_shared/widgets/tab_factory.dart';
import 'package:b2b_commerce/src/home/_shared/widgets/notifications.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'message_item.dart';

const statuses = <EnumModel>[
  EnumModel('1', '订单'),
  EnumModel('2', '系统'),
  EnumModel('3', '账务'),
];

class MessagePage extends StatefulWidget {
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey _globalKey = GlobalKey<_MessagePageState>();
  var controller;
  bool isShowNotRead = true;
  String status = '1';

  @override
  void initState() {
    controller = TabController(
      length: statuses.length,
      vsync: this, //动画效果的异步处理，默认格式
    )..addListener((){
      switch (controller.index) {
        case 0:
          setState(() {
            status = statuses[0].code;
          });
          break;
        case 1:
          setState(() {
            status = statuses[1].code;
          });
          break;
        case 2:
          setState(() {
            status = statuses[2].code;
          });
          break;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<NotifyBloC>(
      key: _globalKey,
      bloc: NotifyBloC.instance,
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          centerTitle: true,
          elevation: 0.5,
          title: Text(
            '消息管理',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            Container(
              width: 60,
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
              child: PopupMenuButton<String>(
                onSelected: (v) => onMenuSelect(v),
                icon: Icon(
                  Icons.more_vert,
                ),
                offset: Offset(0, 50),
                itemBuilder: (BuildContext context) => _buildPopupMenu(),
              ),
            )
          ],
        ),
          body: Scaffold(
            backgroundColor: Colors.white,
            appBar: TabBar(
                controller: controller,
                unselectedLabelColor: Colors.black26,
                labelColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
              tabs: <Widget>[
                Tab(
                  child: Container(
                    width: 60,
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: <Widget>[
                        Center(
                          child: Container(
                            child: Text(
                              '订单',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: NotificationBubble(
                            fontSize: 11,
                            width: 20,
                            height: 16,
                            msgGroup: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    width: 60,
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: <Widget>[
                         Center(
                           child: Container(
                              child: Text(
                                '系统',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                              ),
                        ),
                         ),
                         Container(
                           margin: EdgeInsets.only(top: 5),
                           child: NotificationBubble(
                              fontSize: 11,
                              width: 20,
                              height: 16,
                              msgGroup: 2,
                            ),
                         ),
                      ],
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    width: 60,
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: <Widget>[
                        Center(
                          child: Container(
                            child: Text(
                              '账务',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: NotificationBubble(
                            fontSize: 11,
                            width: 20,
                            height: 20,
                            msgGroup: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            body: TabBarView(
              controller: controller,
              children: statuses.map(
                    (status) => MessagePageList(status: status),
              ).toList(),
            ),
          )
      ),
    );
  }

  List<PopupMenuItem<String>> _buildPopupMenu() {
    return <PopupMenuItem<String>>[
      PopupMenuItem<String>(
        value: 'read',
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 5),
              child: Icon(Icons.speaker_notes),
            ),
            Text('全部设为已读')
          ],
        ),
      ),
      PopupMenuItem<String>(
        value: '${isShowNotRead? 'notRead':'showRead'}',
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 5),
              child: isShowNotRead?Icon(Icons.fiber_new):Icon(Icons.message),
            ),
            Text('${isShowNotRead? '只看未读消息': '查看全部消息'}')
          ],
        ),
      ),
    ];
  }

  onMenuSelect(String value) async {
    switch (value) {
      case 'read':
        break;
      case 'notRead':
        showNotRead();
        break;
      case 'showRead':
        showRead();
        break;
      default:
        break;
    }
  }

  showNotRead(){
    setState(() {
      isShowNotRead = !isShowNotRead;
    });
    NotifyBloC.instance.setReadStatus(isShowNotRead);
    NotifyBloC.instance.getData(status);
  }

  showRead(){
    setState(() {
      isShowNotRead = !isShowNotRead;
    });
    NotifyBloC.instance.setReadStatus(true);
    NotifyBloC.instance.getData(status);
  }

}

class MessagePageList extends StatefulWidget {
  MessagePageList({Key key, @required this.status,})
      : super(key: key);

  final EnumModel status;

  @override
  _MessagePageListState createState() => _MessagePageListState();
}

class _MessagePageListState extends State<MessagePageList>
    with AutomaticKeepAliveClientMixin {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    var bloc = BLoCProvider.of<NotifyBloC>(context);

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMoreByStatuses(widget.status.code);
      }
    });

    // 监听滚动事件，打印滚动位置
    scrollController.addListener(() {
      if (scrollController.offset < 500) {
        bloc.hideToTopBtn();
      } else if (scrollController.offset >= 500) {
        bloc.showToTopBtn();
      }
    });

    // 状态管理触发的返回顶部
    bloc.returnToTopStream.listen((data) {
      //返回到顶部时执行动画
      if (data) {
        scrollController.animateTo(
          .0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.ease,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<NotifyBloC>(context);
    return Container(
      decoration: BoxDecoration(color: Colors.grey[100]),
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: RefreshIndicator(
        onRefresh: () async {
          await bloc.refreshData(widget.status.code);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          children: <Widget>[
            StreamBuilder<MessageData>(
              stream: bloc.stream.where((messageList) =>
              messageList.status == widget.status.code),
              // initialData: null,
              builder: (BuildContext context,
                  AsyncSnapshot<MessageData> snapshot) {
                if (snapshot.data == null) {
                  bloc.getData(widget.status.code);
                  return ProgressIndicatorFactory
                      .buildPaddedProgressIndicator();
                }
                if (snapshot.data.data.length <= 0) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 200),
                        child: Image.asset(
                          'temp/logo2.png',
                          package: 'assets',
                          width: 80,
                          height: 80,
                        ),
                      ),
                      Container(
                          child: Text(
                            AppBLoC.instance.getConnectivityResult ==
                                ConnectivityResult.none
                                ? '网络链接不可用请重试'
                                : '没有相关消息数据',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          )),
                    ],
                  );
                }
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.data.map((model) {
                      return MessageItemPage(
                        model: model,
                      );
                    }).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
              },
            ),
            StreamBuilder<bool>(
              stream: bloc.bottomStream,
              initialData: false,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return ScrolledToEndTips(
                  hasContent: snapshot.data,
                  scrollController: scrollController,
                );
              },
            ),
            StreamBuilder<bool>(
              stream: bloc.loadingStream,
              initialData: false,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return ProgressIndicatorFactory
                    .buildPaddedOpacityProgressIndicator(
                  opacity: snapshot.data ? 1.0 : 0,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
