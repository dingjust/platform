import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';


class ApparelProductPricesInputPage extends StatefulWidget{
  ApparelProductModel item;

  ApparelProductPricesInputPage(this.item);
  _ApparelProductPricesInputPageState createState() => _ApparelProductPricesInputPageState();
}

class _ApparelProductPricesInputPageState extends State<ApparelProductPricesInputPage>{
  FocusNode _minPriceFocusNode = FocusNode();
  FocusNode _maxPriceFocusNode = FocusNode();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  Map<String,Object> map;

  void initState(){
    _minPriceController.text = '${widget.item.minPrice ?? ''}';
    _maxPriceController.text = '${widget.item.maxPrice ?? ''}';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('填写价格区间'),
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
                        style: TextStyle(),
                      ),
                    ),
                  ),
                  onTap: () async {
                    widget.item.minPrice = ClassHandleUtil.removeSymbolRMBToDouble(_minPriceController.text);
                    widget.item.maxPrice = ClassHandleUtil.removeSymbolRMBToDouble(_maxPriceController.text);
                    Navigator.pop(context);
                  }
              )
            ]
        ),
        body: Container(
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                _buildFactoryInfo(context),
              ],
            ))
    );
  }

  Widget _buildFactoryInfo(BuildContext context){
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            child: TextFieldComponent(
              focusNode: _minPriceFocusNode,
              controller: _minPriceController,
              autofocus: true,
              leadingText: Text('价格下限',style: TextStyle(fontSize: 16,)),
              hintText: '请输入价格下限',
              inputType: TextInputType.number,
              prefix: '￥',
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            child: TextFieldComponent(
              focusNode: _maxPriceFocusNode,
              controller: _maxPriceController,
              leadingText: Text('价格上限',style: TextStyle(fontSize: 16,)),
              hintText: '请输入价格上限',
              inputType: TextInputType.number,
              prefix: '￥',
            ),
          ),
        ],
      ),
    );
  }

}