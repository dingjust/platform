import 'package:b2b_commerce/src/business/orders/proofing_order_quantity_input.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';


class OfflineProductColorSizePage extends StatefulWidget {
  final ApparelProductModel product;

  Map<ColorModel, List<SizeQuantityItem>> colorSizeQuantityList;

  OfflineProductColorSizePage({this.product, this.colorSizeQuantityList});

  _OfflineProductColorSizePageState createState() => _OfflineProductColorSizePageState();
}

class _OfflineProductColorSizePageState extends State<OfflineProductColorSizePage>{

  List<ColorModel> _colorFilters = <ColorModel>[];
  List<SizeModel> _sizeFilters = <SizeModel>[];
  Map<ColorModel, List<SizeQuantityItem>> _items = Map();
  Map<ColorModel, List<SizeQuantityItem>> _newItems;
  Map<ColorModel, List<SizeQuantityItem>> sizeQuantityList;
  String result;

  String colorSizeSelectText() {
    String text = '';
    if (_colorFilters.length > 0) {
      for (int i = 0; i < _colorFilters.length; i++) {
        if (i > 1) {
          text += '...';
          break;
        }

        if (i == _colorFilters.length - 1) {
          text += _colorFilters[i].name;
        } else {
          text += _colorFilters[i].name + '、';
        }
      }
    }
    if (_colorFilters.length > 0 || _sizeFilters.length > 0) text += '/';

    if (_sizeFilters.length > 0) {
      for (int i = 0; i < _sizeFilters.length; i++) {
        if (i > 1) {
          text += '...';
          break;
        }

        if (i == _sizeFilters.length - 1) {
          text += _sizeFilters[i].name;
        } else {
          text += _sizeFilters[i].name + '、';
        }
      }
    }

    return text;
  }

  @override
  void initState() {
    if(widget.colorSizeQuantityList != null){
      sizeQuantityList = widget.colorSizeQuantityList;
      widget.colorSizeQuantityList.forEach((color, items) {
        _colorFilters.add(color);
        items.forEach((item) {
          _sizeFilters.add(item.size);
//          _totalQuantity += int.parse(item.quantityController.text == ''
//              ? '0'
//              : item.quantityController.text);
        });
      });
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('商品颜色尺码信息'),
            elevation: 0.5,
            brightness: Brightness.light,
            centerTitle: true,
            actions: <Widget>[
              GestureDetector(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Center(
                      child: Text(
                        '确定',
                        style: TextStyle(
                            color: Color.fromRGBO(255, 214, 12, 1)),
                      ),
                    ),
                  ),
                  onTap: () async {
                    //带值返回上一页
                    Navigator.of(context).pop(sizeQuantityList);
                  }
              )
            ]
        ),
        body: Container(
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                _buildProductInfo(context),
              ],
            ))
    );
  }

  Widget _buildProductInfo(BuildContext context){
    bool isCheck = false;

    return Container(
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () async {
              dynamic result;
//              await Navigator.push(
//                context,
//                MaterialPageRoute(
//                  builder: (context) => ColorSizeSelectPage(
//                    colorFilters: _colorFilters,
//                    sizeFilters: _sizeFilters,
//                  ),
//                ),
//              );

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ColorSizeSelectPage(
                          colorFilters: _colorFilters,
                          sizeFilters: _sizeFilters,
                        )),
                //接收返回数据并处理
              ).then((value) {
                setState(() {
                  result = value;

                if (result != null) {
                  _colorFilters = result[0];
                  _sizeFilters = result[1];
                }


                //选择完颜色尺码，生成数量item
                _newItems = Map.from(_items);
                _items.clear();
                _colorFilters.forEach((color) {
                  ColorModel itemColor = _newItems.keys.firstWhere(
                          (key) => key.code == color.code,
                      orElse: () => null);

                  if (itemColor != null) {
                    _items[itemColor] = _sizeFilters.map((size) {
                      SizeQuantityItem item = _newItems[itemColor].firstWhere(
                              (SizeQuantityItem) =>
                          SizeQuantityItem.size.code == size.code,
                          orElse: () => null);
                      if (item != null) {
                        return item;
                      } else {
                        return SizeQuantityItem(size: size);
                      }
                    }).toList();
                    setState(() {
                      widget.colorSizeQuantityList = _items;
                    });
                  } else {
                    _items[color] = _sizeFilters
                        .map((size) => SizeQuantityItem(size: size))
                        .toList();
                    setState(() {
                      widget.colorSizeQuantityList = _items;
                    });
                  }
                  sizeQuantityList = widget.colorSizeQuantityList;
                });
                });
              });
            },
            child: ShowSelectTile(
              leadingText: '商品色码',
              tralingText: colorSizeSelectText(),
            ),
          ),
          InkWell(
            onTap: () async {
              if (_colorFilters.length <= 0) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('请先选择颜色尺码'),
                  ),
                );
                return;
              } else {
                if (_sizeFilters.length <= 0) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('请选择尺码'),
                    ),
                  );
                  return;
                }
              }

              dynamic result;
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProofingOrderQuantityInputPage(
                          items: sizeQuantityList,
                        )
                ),
                //接收返回数据并处理
              ).then((value) {
                setState(() {
                  isCheck = true;
                  result = value;
                  if (result != null){
                    sizeQuantityList = result;
                  }
                });
              });
            },
            child: ShowSelectTile(
              leadingText: '商品数量',
              tralingText:
              isCheck == false ? '' : '已选择',
            ),
          ),
        ],
      ),
    );
  }

}