import 'package:flutter/material.dart';

///枚举单选
class EnumSelect<T> extends StatefulWidget {
  //页面title
  final String title;

  ///单选值
  final T val;

  ///值Map
  final Map<T, String> localizedMap;

  ///横轴元素个数
  final int crossAxisCount;

  ///元素宽高比
  final double childAspectRatio;

  ///横轴间隔
  final double crossAxisSpacing;

  ///纵轴间隔
  final double mainAxisSpacing;

  const EnumSelect(
      {Key key,
      @required this.title,
      this.val,
      @required this.localizedMap,
      this.crossAxisCount = 3,
      this.childAspectRatio = 4.0,
      this.crossAxisSpacing = 20.0,
      this.mainAxisSpacing = 10.0})
      : super(key: key);

  @override
  _EnumSelectState createState() => _EnumSelectState();
}

class _EnumSelectState extends State<EnumSelect> {
  dynamic selectEnum;

  @override
  void initState() {
    super.initState();
    if (widget.val != null) {
      selectEnum = widget.val;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text(widget.title ?? ''),
        leading: IconButton(
            icon: Text(
              '取消',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        actions: <Widget>[
          IconButton(
            icon: Text(
              '确定',
              style: TextStyle(),
            ),
            onPressed: () {
              Navigator.of(context).pop(selectEnum);
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    List<Widget> chips = [];
    widget.localizedMap.forEach((t, val) {
      chips.add(Container(
          decoration: BoxDecoration(
              color: selectEnum == t
                  ? Color.fromRGBO(255, 214, 12, 1)
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(20)),
          child: InkWell(
            child: Center(
              child: Text(
                '$val',
                style: TextStyle(color: Colors.black),
              ),
            ),
            onTap: () {
              setState(() {
                if (selectEnum == t) {
                  selectEnum = null;
                } else {
                  selectEnum = t;
                }
              });
            },
          )));
    });

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.crossAxisCount, //横轴三个子widget
              childAspectRatio: widget.childAspectRatio, //宽高比为1时，子widget
              crossAxisSpacing: widget.crossAxisSpacing,
              mainAxisSpacing: widget.mainAxisSpacing),
          children: chips),
    );
  }
}

///枚举多选
class MultiEnumSelect<T> extends StatefulWidget {
  //页面title
  final String title;

  ///多选值
  final List<T> values;

  ///值Map
  final Map<T, String> localizedMap;

  ///横轴元素个数
  final int crossAxisCount;

  ///元素宽高比
  final double childAspectRatio;

  ///横轴间隔
  final double crossAxisSpacing;

  ///纵轴间隔
  final double mainAxisSpacing;

  const MultiEnumSelect(
      {Key key,
      @required this.title,
      this.values,
      @required this.localizedMap,
      this.crossAxisCount = 3,
      this.childAspectRatio = 4.0,
      this.crossAxisSpacing = 20.0,
      this.mainAxisSpacing = 10.0})
      : super(key: key);

  @override
  _MultiEnumSelectState createState() => _MultiEnumSelectState();
}

class _MultiEnumSelectState extends State<MultiEnumSelect> {
  List<dynamic> selectEnums;

  @override
  void initState() {
    super.initState();
    if (widget.values != null) {
      selectEnums = widget.values;
    } else {
      selectEnums = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text(widget.title ?? ''),
        leading: IconButton(
            icon: Text(
              '取消',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        actions: <Widget>[
          IconButton(
            icon: Text(
              '确定',
              style: TextStyle(),
            ),
            onPressed: () {
              Navigator.of(context).pop(selectEnums);
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    List<Widget> chips = [];
    widget.localizedMap.forEach((t, val) {
      chips.add(Container(
          decoration: BoxDecoration(
              color: selectEnums.contains(t)
                  ? Color.fromRGBO(255, 214, 12, 1)
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(20)),
          child: InkWell(
            child: Center(
              child: Text(
                '$val',
                style: TextStyle(color: Colors.black),
              ),
            ),
            onTap: () {
              setState(() {
                if (selectEnums.contains(t)) {
                  selectEnums.remove(t);
                } else {
                  selectEnums.add(t);
                }
              });
            },
          )));
    });

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.crossAxisCount, //横轴三个子widget
              childAspectRatio: widget.childAspectRatio, //宽高比为1时，子widget
              crossAxisSpacing: widget.crossAxisSpacing,
              mainAxisSpacing: widget.mainAxisSpacing),
          children: chips),
    );
  }
}
