import 'dart:async';

import 'package:b2b_commerce/src/my/capacity/my_capacity_form.dart';
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
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => MyCapacityFormPage()));
              },
              child: child,
            ),
        child: Icon(
          Icons.add,
          color: Colors.black87,
        ),
      ),
    );
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
        child: ListView(controller: _scrollController, children: [
          Column(
            children: myCapacityState.factoryCapacityModels
                .map((model) => MyCapacityItem(model))
                .toList(),
          ),
          ProgressIndicatorFactory.buildPaddedOpacityProgressIndicator(
            opacity: myCapacityState.loadingMore ? 1.0 : 0,
          )
        ]),
        onRefresh: () async {
          myCapacityState.clear();
        },
      ),
    );
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
                '${model.capacityRange}/天',
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
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 5),
            child: Text(
              '${widget.model?.dateStartPoint?.month}.${widget.model
                  ?.dateStartPoint?.day}～${widget.model?.dateEndPoint
                  ?.month}.${widget.model?.dateEndPoint?.day}',
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
                      this.setState(() {
                        widget.model.enabled = !widget.model.enabled;
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
                          style:
                          TextStyle(color: Color.fromRGBO(255, 214, 12, 1)),
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
                  child: OutlineButton(
                      borderSide: BorderSide(color: Colors.black26),
                      child: new Text(
                        '刷新${timeText == null || timeText == '' ? '' : '(' +
                            timeText + ')'}',
                        style:
                        TextStyle(color: Color.fromRGBO(255, 214, 12, 1)),
                      ),
                      onPressed:
                      timeText == '' || timeText == null ? yzmGet : null),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
