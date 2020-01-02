import 'package:b2b_commerce/src/business/orders/proofing_order_quantity_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class ColorSizeTabForm extends StatefulWidget {
  final Map<ColorModel, List<SizeQuantityItem>> items;

  const ColorSizeTabForm({Key key, this.items}) : super(key: key);

  @override
  _ColorSizeTabFormState createState() => _ColorSizeTabFormState();
}

class _ColorSizeTabFormState extends State<ColorSizeTabForm> {
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: DefaultTabController(
      length: widget.items.length,
      child: Scaffold(
          appBar: TabBar(isScrollable: true, tabs: _buildTabs()),
          body: TabBarView(children: _buildBodys())),
    ));
  }

  ///数据初始化
  void init() {
    //尺码排序
    widget.items.forEach((color, sizes) {
      sizes.sort((o1, o2) => (o1.size.sequence - o2.size.sequence));
    });
  }

  List<Widget> _buildTabs() {
    List<Widget> result = <Widget>[];
    widget.items.forEach((color, sizes) {
      result.add(_buildTab(color));
    });
    return result;
  }

  Widget _buildTab(ColorModel color) {
    String colorCode = 'FFFFFF';
    if (color?.colorCode != null) {
      colorCode = color.colorCode.replaceAll(RegExp('#'), '');
    }

    int sum = getColorTotalNum(color);
    return Tab(
      child: Container(
        width: 60,
        height: 30,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            color.colorCode != null
                ? Positioned(
                    left: 0,
                    top: 12,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          color: Color(int.parse('0xFF${colorCode}')),
                          border:
                              Border.all(width: 0.5, color: Colors.grey[300])),
                      child: Text(''),
                    ),
                  )
                : Container(),
            Container(
              margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
              child: Text(
                '${color.name}',
                style: TextStyle(fontSize: 16),
              ),
            ),
            sum > 0
                ? Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Center(
                          child: Text(
                            getColorTotalNum(color) > 99 ? '···' : '$sum',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        )))
                : Container()
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBodys() {
    List<Widget> result = <Widget>[];

    widget.items.forEach((color, sizesItems) {
      result.add(Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: Colors.white,
        child: Column(
            children: sizesItems.map((item) => _buildEntryRow(item)).toList()),
      ));
    });
    return result;
  }

  int getColorTotalNum(ColorModel color) {
    int sum = 0;
    widget.items[color].forEach((item) {
      if (item.quantityController.text != '') {
        sum += int.parse(item.quantityController.text);
      }
    });
    return sum;
  }

  Widget _buildEntryRow(SizeQuantityItem item) {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 0.5, color: Colors.grey[300]))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '${item.size.name}',
            style: TextStyle(fontSize: 14),
          ),
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  B2BIcons.remove_rect,
                  color: Colors.grey[300],
                ),
                onPressed: () {
                  if (int.parse(item.quantityController.text) > 0) {
                    setState(() {
                      if (item.quantityController.text == '1') {
                        item.quantityController.text = '';
                      } else {
                        int i = int.parse(item.quantityController.text);
                        i--;
                        item.quantityController.text = '$i';
                      }
                    });
                  }
                },
              ),
              Container(
                width: 40,
                child: TextField(
                  controller: item.quantityController,
                  decoration:
                      InputDecoration(border: InputBorder.none, hintText: '0'),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  //只能输入数字
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (val) {
                    if (val == '0') {
                      setState(() {
                        item.quantityController.text = '';
                      });
                    }
                  },
                ),
              ),
              IconButton(
                icon: Icon(
                  B2BIcons.add_rect,
                  color: Colors.grey[300],
                ),
                onPressed: () {
                  setState(() {
                    if (item.quantityController.text == '') {
                      item.quantityController.text = '1';
                    } else {
                      int i = int.parse(item.quantityController.text);
                      i++;
                      item.quantityController.text = '$i';
                    }
                  });
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
