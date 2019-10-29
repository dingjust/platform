
import 'dart:async';

import 'package:b2b_commerce/src/my/capacity/my_capacity_from.dart';
import 'package:flutter/material.dart';

class MyCapacityPage extends StatefulWidget{
  _MyCapacityPageState createState() => _MyCapacityPageState();
}


class _MyCapacityPageState extends State<MyCapacityPage>{
  
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
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.black87,
        ),
        onPressed: () {
          Navigator.push(context,MaterialPageRoute(builder: (context) =>MyCapacityFromPage()));
        },
        backgroundColor: Color.fromRGBO(255, 214, 12, 1),
      ),
    );
  }

}

class MyCapacityListPage extends StatefulWidget{
  _MyCapacityListPageState createState() => _MyCapacityListPageState();
}

class _MyCapacityListPageState extends State<MyCapacityListPage>{

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          MyCapacityItemPage(),
          MyCapacityItemPage(),
          MyCapacityItemPage(),
        ],
      ),
    );
  }

}

class MyCapacityItemPage extends StatefulWidget{
  _MyCapacityItemPageState createState() => _MyCapacityItemPageState();
}

class _MyCapacityItemPageState extends State<MyCapacityItemPage>{
  bool isClose = false;
  Timer countDownTimer;
  String timeText;

  @override
  void dispose() {
    if(countDownTimer!= null && countDownTimer.isActive){
      countDownTimer.cancel();
      countDownTimer = null;
    }
    super.dispose();

  }

   yzmGet() async {
     if(countDownTimer!= null && countDownTimer.isActive){
       countDownTimer.cancel();
       countDownTimer = null;
     }
    countDownTimer = Timer.periodic(Duration(seconds: 1), (t){
      setState(() {
        if(4-t.tick>0){//60-t.tick代表剩余秒数，如果大于0，设置yzmText为剩余秒数，否则重置yzmText，关闭countTimer
          timeText = "${4-t.tick}";
        }else{
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
      margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
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

  Widget _buildHead(){
    return Container(
      child: Text(
        '本厂长期加工女装，羽绒服，棉服，价格便宜出货快',
      ),
    );
  }

  Widget _buildBody(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(child: _buildBodyLeft()),
          _buildBodyRight(),
        ],
      ),
    );
  }

  Widget _buildBodyLeft(){
    return Container(
      margin: EdgeInsets.only(right: 30),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            margin: EdgeInsets.only(bottom: 5),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                      child: Text(
                        '男装——衬衫',
                      )
                  ),
                ),
                Container(
                    child: Text(
                      '2000/天',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    )
                ),
              ],
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            margin: EdgeInsets.only(bottom: 5),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                      child: Text(
                        '男装——衬衫',
                      )
                  ),
                ),
                Container(
                    child: Text(
                      '2000/天',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    )
                ),
              ],
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            margin: EdgeInsets.only(bottom: 5),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                      child: Text(
                        '男装——衬衫',
                      )
                  ),
                ),
                Container(
                    child: Text(
                      '2000/天',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    )
                ),
              ],
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyRight(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 5),
            child: Text(
              '7.10～11.31',
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
                  child: Text(
                    '：2000次'
                  ),
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
                  child: Text(
                      '：1400次'
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyButton(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  child: Text(
                    '${isClose?'已开启':'已关闭'}'
                  ),
                ),
                Container(
                  child: Switch(
                    value: isClose,
                    activeColor: Color.fromRGBO(255, 214, 12, 1),     // 激活时原点颜色
                    onChanged: (bool val) {
                      this.setState(() {
                        isClose = !isClose;
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
                            color: Color.fromRGBO(255, 214, 12, 1)
                        ),
                      ),
                      onPressed: timeText == '' || timeText == null ? yzmGet : null
                  )
                ),
                Container(
                    margin: EdgeInsets.only(left: 10),
                    child: OutlineButton(
                        borderSide: BorderSide(color: Colors.black26),
                        child: new Text(
                          '刷新${timeText==null||timeText==''?'':'('+timeText+')'}',
                          style: TextStyle(
                              color: Color.fromRGBO(255, 214, 12, 1)
                          ),
                        ),
                        onPressed: timeText == '' || timeText == null ? yzmGet : null
                    ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}