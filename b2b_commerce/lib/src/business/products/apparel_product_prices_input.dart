import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class ApparelProductPricesInputPage extends StatefulWidget {
  ApparelProductPricesInputPageState createState() =>
      ApparelProductPricesInputPageState();
}

class ApparelProductPricesInputPageState extends State<ApparelProductPricesInputPage> {
  GlobalKey _priceForm = GlobalKey<FormState>();
  TextEditingController _priceController;
  TextEditingController _suggestedPriceController;
  TextEditingController _price1Controller;
  TextEditingController _price2Controller;
  TextEditingController _price3Controller;
  FocusNode _priceFocusNode = FocusNode();
  FocusNode _suggestedFocusNode = FocusNode();
  FocusNode _price1FocusNode = FocusNode();
  FocusNode _price2FocusNode = FocusNode();
  FocusNode _price3FocusNode = FocusNode();

  @override
  void initState() {
    _priceController = TextEditingController();
    _suggestedPriceController = TextEditingController();
    _price1Controller = TextEditingController();
    _price2Controller = TextEditingController();
    _price3Controller = TextEditingController();


    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('商品价格'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.done,
            ),
            onPressed: () async{
              print(_priceController.text);
//              if(_priceController.text.length >0 ){
//                showDialog(context: context,builder: (context) => AlertDialog(
//                  title: Text('产品名称不能为空'),
//                ));
//              }

              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Container(
//        color: Colors.grey[200],
        child: Form(
          key: _priceForm,
          autovalidate: false,
          child: ListView(
            children: <Widget>[
              TextFieldComponent(
                leadingText: '供货价',
                hintText: '请输入供货价，必填',
                inputType: TextInputType.number,
                leadingWidth: 85,
                controller: _priceController,
                focusNode: _priceFocusNode,
              ),
              TextFieldComponent(
                leadingText: '建议零售价',
                hintText: '请输入建议零售价，必填',
                inputType: TextInputType.number,
                leadingWidth: 85,
                controller: _suggestedPriceController,
                focusNode: _suggestedFocusNode,
              ),
              TextFieldComponent(
                leadingText: '会员价（A）',
                hintText: '请输入会员价（A），必填',
                inputType: TextInputType.number,
                leadingWidth: 85,
                controller: _price1Controller,
                focusNode: _price1FocusNode,
              ),
              TextFieldComponent(
                leadingText: '会员价（B）',
                hintText: '请输入会员价（B），必填',
                inputType: TextInputType.number,
                leadingWidth: 85,
                controller: _price2Controller,
                focusNode: _price2FocusNode,
              ),
              TextFieldComponent(
                leadingText: '会员价（C）',
                hintText: '请输入会员价（C），必填',
                inputType: TextInputType.number,
                leadingWidth: 85,
                controller: _price3Controller,
                focusNode: _price3FocusNode,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Text('阶梯价'),
                      StaircasePricesInput(),
                      StaircasePricesInput(),
                      StaircasePricesInput(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StaircasePricesInput extends StatelessWidget {
  StaircasePricesInput();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: Column(
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '起订量',
                    ),
                  ),
                  Divider(
                    height: 0,
                    color: Colors.grey[400],
                  ),
                ],
              )),
              Text('以上，价格：'),
              Expanded(
                  child: Column(
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '价格',
                    ),
                  ),
                  Divider(
                    height: 0,
                    color: Colors.grey[400],
                  ),
                ],
              )),
            ],
          ),
        ],
      ),
    );
  }
}
