import 'package:flutter/material.dart';

/// 枚举选择器(Model类型)
class SingleEnumSelectPage extends StatefulWidget {
  SingleEnumSelectPage({
    this.title,
    this.items,
    this.code,
    this.count = 4,
  });

  //页面title
  final String? title;

  //全部枚举的集合
  final List<dynamic>? items;

  //被选中的枚举的code
  String? code;

  //一行显示多少个
  final int count;

  SingleEnumSelectPageState createState() => SingleEnumSelectPageState();
}

class SingleEnumSelectPageState extends State<SingleEnumSelectPage> {
  String? _code;

  @override
  void initState() {
    _code = widget.code;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> _items = widget.items!.map((item) {
      return Container(
          decoration: BoxDecoration(
              color: _code == item.code
                  ? Color.fromRGBO(255, 214, 12, 1)
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(20)),
          child: InkWell(
            child: Center(
              child: Text(
                '${item.name}',
                style: TextStyle(color: Colors.black),
              ),
            ),
            onTap: () {
              setState(() {
                if (_code == item.code) {
                  _code = null;
                } else {
                  _code = item.code;
                }
              });
            },
          ));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text(widget.title!),
        leading: IconButton(
            icon: Text(
              '取消',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[
          IconButton(
            icon: Text(
              '确定',
              style: TextStyle(),
            ),
            onPressed: () {
              Navigator.pop(context, _code);
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, //横轴三个子widget
                childAspectRatio: 3.0, //宽高比为1时，子widget
                crossAxisSpacing: 20,
                mainAxisSpacing: 15),
            children: _items as List<Widget>),
      ),
    );
  }
}

///枚举选择器(枚举类型)
///说明:返回false值则为置空,null不处理
// ignore: must_be_immutable
class SingleEnumSelectV2Page extends StatefulWidget {
  SingleEnumSelectV2Page({
    this.title = '',
    required this.items,
    required this.value,
    this.count = 4,
    required this.localizedMap,
  });

  ///页面title
  final String title;

  //枚举集合
  final List<dynamic> items;

  ///枚举显示值
  final Map<dynamic, String> localizedMap;

  //被选中值
  dynamic value;

  //一行显示多少个
  final int count;

  SingleEnumSelectV2PageState createState() => SingleEnumSelectV2PageState();
}

class SingleEnumSelectV2PageState extends State<SingleEnumSelectV2Page> {
  dynamic _value;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> _items = widget.items.map((item) {
      return Container(
          decoration: BoxDecoration(
              color: _value == item
                  ? Color.fromRGBO(255, 214, 12, 1)
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(20)),
          child: InkWell(
            child: Center(
              child: Text(
                '${widget.localizedMap[item]}',
                style: TextStyle(color: Colors.black),
              ),
            ),
            onTap: () {
              setState(() {
                if (_value == item) {
                  _value = null;
                } else {
                  _value = item;
                }
              });
            },
          ));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text(widget.title),
        leading: IconButton(
            icon: Text(
              '取消',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[
          IconButton(
            icon: Text(
              '确定',
              style: TextStyle(),
            ),
            onPressed: () {
              if (_value == null) {
                Navigator.pop(context, false);
              } else {
                Navigator.pop(context, _value);
              }
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, //横轴三个子widget
                childAspectRatio: 3.0, //宽高比为1时，子widget
                crossAxisSpacing: 20,
                mainAxisSpacing: 15),
            children: _items as List<Widget>),
      ),
    );
  }
}
