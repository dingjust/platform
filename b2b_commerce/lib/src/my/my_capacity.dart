import 'dart:async';

import 'package:b2b_commerce/src/home/account/login.dart';
import 'package:b2b_commerce/src/my/capacity/my_capacity_form.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class MyCapacityPage extends StatefulWidget {
  _MyCapacityPageState createState() => _MyCapacityPageState();
}

class _MyCapacityPageState extends State<MyCapacityPage> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) => checkLoginStatus());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('空闲产能'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: Container(
        child: MyCapacityListPage(),
      ),
      floatingActionButton: Consumer<MyCapacityState>(
        builder: (context, MyCapacityState myCapacityState, child) =>
            FloatingActionButton(
              onPressed: () => onAdd(myCapacityState),
              child: child,
            ),
        child: Icon(
          Icons.add,
          color: Colors.black87,
        ),
      ),
    );
  }

  void onAdd(MyCapacityState myCapacityState) {
    if (myCapacityState.factoryCapacityModels.length > 2) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.CONFIRM_DIALOG,
              failTips: '取消失败',
              title: '你已开启3条产能',
              contentText1: '普通用户最多智能开启3条产能，成为会员可以同时发布多条产能，并且每条产能可以发布更多品类',
              isNeedConfirmButton: true,
              isNeedCancelButton: true,
              dialogHeight: 200,
              dialogWidth: 350,
              confirmButtonText: '成为会员',
              cancelButtonText: '以后再说',
              confirmAction: () {
                //TODO:跳转到会员
              },
              cancelAction: () {
                Navigator.of(context).pop();
              },
            );
          });
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => MyCapacityFormPage()));
    }
  }

  ///检测用户登录状态
  void checkLoginStatus() {
    if (UserBLoC.instance.currentUser.status == UserStatus.OFFLINE) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => B2BLoginPage()),
          ModalRoute.withName('/'));
    }
  }
}

class MyCapacityListPage extends StatefulWidget {
  _MyCapacityListPageState createState() => _MyCapacityListPageState();
}

class _MyCapacityListPageState extends State<MyCapacityListPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyCapacityState>(
      builder: (context, MyCapacityState myCapacityState, _) =>
          Container(
            child: myCapacityState.factoryCapacityModels != null
                ? MyCapacitieslist(myCapacityState: myCapacityState)
                : Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }
}

class MyCapacitieslist extends StatelessWidget {
  final MyCapacityState myCapacityState;

  MyCapacitieslist({Key key, this.myCapacityState}) : super(key: key);

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    //监听加载更多
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        myCapacityState.loadMore();
      }
    });

    return Container(
      child: RefreshIndicator(
        child: ListView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Column(
                children: myCapacityState.factoryCapacityModels
                    .map((model) => MyCapacityItem(model))
                    .toList(),
              ),
              ProgressIndicatorFactory.buildPaddedOpacityProgressIndicator(
                opacity: myCapacityState.loadingMore ? 1.0 : 0,
              ),
              _buildEnd()
            ]),
        onRefresh: () async {
          myCapacityState.clear();
        },
      ),
    );
  }

  Widget _buildEnd() {
    return myCapacityState.isEnd()
        ? Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text('已经到底了')],
      ),
    )
        : Container();
  }
}

class MyCapacityItem extends StatefulWidget {
  final FactoryCapacityModel model;

  MyCapacityItem(this.model);

  _MyCapacityItemState createState() => _MyCapacityItemState();
}

class _MyCapacityItemState extends State<MyCapacityItem> {
  Timer countDownTimer;
  String timeText;

  @override
  void dispose() {
    if (countDownTimer != null && countDownTimer.isActive) {
      countDownTimer.cancel();
      countDownTimer = null;
    }
    super.dispose();
  }

  yzmGet() async {
    if (countDownTimer != null && countDownTimer.isActive) {
      countDownTimer.cancel();
      countDownTimer = null;
    }
    countDownTimer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        if (4 - t.tick > 0) {
          //60-t.tick代表剩余秒数，如果大于0，设置yzmText为剩余秒数，否则重置yzmText，关闭countTimer
          timeText = "${4 - t.tick}";
        } else {
          timeText = '';
          countDownTimer.cancel();
          countDownTimer = null;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHead(),
          _buildBody(),
          _buildBodyButton(),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
    );
  }

  Widget _buildHead() {
    return Container(
      child: Text(
        '${widget.model.title ?? ''}',
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(child: _buildBodyLeft()),
          _buildBodyRight(),
        ],
      ),
    );
  }

  Widget _buildBodyLeft() {
    return Container(
      margin: EdgeInsets.only(right: 30),
      child: Column(
        children: widget.model.categoryCapacities
            .map((categoryCapacity) => _buildBodyLeftRow(categoryCapacity))
            .toList(),
      ),
    );
  }

  Widget _buildBodyLeftRow(FactoryCategoryCapacityModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.only(bottom: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
                child: Text(
                  '${model.category.name}',
                )),
          ),
          Container(
              child: Text(
                '${model.capacityRange}件/天',
                style: TextStyle(
                  color: Colors.red,
                ),
              )),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
    );
  }

  Widget _buildBodyRight() {
    String dateStr = '';
    if (widget.model.longTerm ?? false) {
      dateStr = '长期有效';
    } else {
      dateStr =
      '${widget.model?.dateStartPoint?.month}.${widget.model?.dateStartPoint
          ?.day}~${widget.model?.dateEndPoint?.month}.${widget.model
          ?.dateEndPoint?.day}';
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 5),
            child: Text(
              dateStr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 5),
            child: Text(
              '空闲日期',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.remove_red_eye,
                        color: Colors.black54,
                      ),
                    ),
                    Container(
                      child: Text('：${widget.model.showTimes}次'),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.touch_app,
                        color: Colors.black54,
                      ),
                    ),
                    Container(
                      child: Text('：${widget.model.clickTimes}次'),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBodyButton() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  child: Text('${widget.model.enabled ? '已开启' : '已关闭'}'),
                ),
                Container(
                  child: Switch(
                    value: widget.model.enabled,
                    activeColor: Color.fromRGBO(255, 214, 12, 1), // 激活时原点颜色
                    onChanged: (bool val) {
                      //TODO:调用激活接口
                      CapacityRepository()
                          .switchStatus(
                          widget.model.code, !widget.model.enabled)
                          .then((value) {
                        if (value) {
                          setState(() {
                            widget.model.enabled = !widget.model.enabled;
                          });
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: 10),
                      child: OutlineButton(
                          borderSide: BorderSide(color: Colors.black26),
                          child: new Text(
                            '编辑',
                            style: TextStyle(
                                color: Color.fromRGBO(255, 214, 12, 1)),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MyCapacityFormPage(
                                          model: widget.model,
                                        )));
                          })),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Consumer<MyCapacityState>(
                      builder: (context, MyCapacityState myCapacityState, _) =>
                          OutlineButton(
                            borderSide: BorderSide(color: Colors.black26),
                            child: Text(
                              '刷新(${widget.model.remainRefreshTimes})',
                              style:
                              TextStyle(color: Color.fromRGBO(255, 214, 12, 1)),
                            ),
                            onPressed: () => onRefresh(myCapacityState),
                          ),
                    ),
                  )
                ]),
          ),
        ],
      ),
    );
  }

  onRefresh(MyCapacityState myCapacityState) async {
    CapacityRepository().refresh(widget.model.code).then((value) {
      if (value) {
        myCapacityState.clear();
      }
    });
  }
}
