import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

/// 质量等级选择器
class QualitySelector extends StatefulWidget {
  final List<String> values;

  final ValueChanged<List<String>> onChange;

  const QualitySelector({Key key, this.values, this.onChange})
      : super(key: key);

  QualitySelectorState createState() => QualitySelectorState();
}

class QualitySelectorState extends State<QualitySelector> {
  List<String> values1;
  List<String> values2;
  List<String> values3;

  List<EnumModel> _enum1 = [
    EnumModel('A_CHAIN', '一线品牌'),
    EnumModel('LEVEL01', '二线品牌'),
    EnumModel('STALL_WHOLESALE', '档口精品'),
  ];

  List<EnumModel> _enum2 = [
    EnumModel('LEVEL05', '电商高品质'),
    EnumModel('LEVEL02', '三线品牌'),
  ];

  List<EnumModel> _enum3 = [
    EnumModel('LEVEL03', '三线以下'),
    EnumModel('LEVEL04', '档口跑量'),
    EnumModel('LEVEL06', '电商跑量'),
    EnumModel('LEVEL07', '跨境电商'),
    EnumModel('WHOLESALE_TRADE', '外贸批发'),
  ];

  @override
  void initState() {
    values1 = [];
    values2 = [];
    values3 = [];
    if (widget.values != null) {
      widget.values.forEach((element) {
        if (_enum1.indexWhere((item) => item.code == element) > -1) {
          values1.add(element);
        }
        if (_enum2.indexWhere((item) => item.code == element) > -1) {
          values2.add(element);
        }
        if (_enum3.indexWhere((item) => item.code == element) > -1) {
          values3.add(element);
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('选择质量等级'),
        leading: IconButton(
            icon: Text(
              '取消',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            onPressed: () {}),
        actions: <Widget>[
          IconButton(
            icon: Text(
              '确定',
              style: TextStyle(),
            ),
            onPressed: () {
              List<String> result = [...values1, ...values2, ...values3];
              widget.onChange(result);
              Navigator.of(context).pop(result);
            },
          ),
        ],
      ),
      body: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: CustomScrollView(
            slivers: [
              _Divider('高端品质'),
              _buildGrid1(),
              _Divider('中端品质'),
              _buildGrid2(),
              _Divider('低端品质'),
              _buildGrid3(),
            ],
          )),
    );
  }

  ///高端品质
  Widget _buildGrid1() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, //横轴三个子widget
          childAspectRatio: 3.0, //宽高比为1时，子widget
          crossAxisSpacing: 20,
          mainAxisSpacing: 15),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          EnumModel item = _enum1[index];
          return _CheckBox(
            selected: values1.contains(item.code),
            model: item,
            disable: values3.isNotEmpty,
            onTap: () {
              setState(() {
                if (values1.contains(item.code)) {
                  values1.remove(item.code);
                } else {
                  values1.add(item.code);
                }
              });
            },
          );
        },
        childCount: _enum1.length,
      ),
    );
  }

  ///中端品质
  Widget _buildGrid2() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, //横轴三个子widget
          childAspectRatio: 3.0, //宽高比为1时，子widget
          crossAxisSpacing: 20,
          mainAxisSpacing: 15),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          EnumModel item = _enum2[index];
          return _CheckBox(
            selected: values2.contains(item.code),
            model: item,
            onTap: () {
              setState(() {
                if (values2.contains(item.code)) {
                  values2.remove(item.code);
                } else {
                  values2.add(item.code);
                }
              });
            },
          );
        },
        childCount: _enum2.length,
      ),
    );
  }

  ///低端品质
  Widget _buildGrid3() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, //横轴三个子widget
          childAspectRatio: 3.0, //宽高比为1时，子widget
          crossAxisSpacing: 20,
          mainAxisSpacing: 15),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          EnumModel item = _enum3[index];
          return _CheckBox(
            selected: values3.contains(item.code),
            model: item,
            disable: values1.isNotEmpty,
            onTap: () {
              setState(() {
                if (values3.contains(item.code)) {
                  values3.remove(item.code);
                } else {
                  values3.add(item.code);
                }
              });
            },
          );
        },
        childCount: _enum3.length,
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final String title;

  const _Divider(this.title);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        '$title',
        style: TextStyle(color: Colors.grey),
      ),
    ));
  }
}

class _CheckBox extends StatelessWidget {
  final bool selected;

  final bool disable;

  final EnumModel model;

  final VoidCallback onTap;

  final Color color;

  const _CheckBox(
      {Key key,
      this.selected = false,
      this.disable = false,
      this.color = Constants.THEME_COLOR_MAIN,
      this.model,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //禁用状态
    if (disable) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 14,
              width: 14,
              margin: EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(width: 0.5, color: Colors.grey)),
            ),
            Text(
              '${model.name}',
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 14,
              width: 14,
              margin: EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                  color: selected ? color : Colors.white,
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(
                      width: 0.5, color: selected ? color : Colors.grey)),
              child: selected
                  ? Center(
                      child: Icon(
                        Icons.done,
                        size: 12,
                        color: Colors.white,
                      ),
                    )
                  : Container(),
            ),
            Text(
              '${model.name}',
              style: TextStyle(color: selected ? color : Colors.black87),
            )
          ],
        ),
      ),
    );
  }
}
