import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';
import 'package:models/models.dart';

class ApparelProductPricesInputPage extends StatefulWidget {
  List prices;

  ApparelProductPricesInputPage({this.prices});

  ApparelProductPricesInputPageState createState() =>
      ApparelProductPricesInputPageState();
}

class ApparelProductPricesInputPageState
    extends State<ApparelProductPricesInputPage> {
  GlobalKey _priceForm = GlobalKey<FormState>();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _suggestedPriceController = TextEditingController();
  TextEditingController _price1Controller = TextEditingController();
  TextEditingController _price2Controller = TextEditingController();
  TextEditingController _price3Controller = TextEditingController();
  FocusNode _priceFocusNode = FocusNode();
  FocusNode _suggestedFocusNode = FocusNode();
  FocusNode _price1FocusNode = FocusNode();
  FocusNode _price2FocusNode = FocusNode();
  FocusNode _price3FocusNode = FocusNode();

  List<Widget> _staircasePriceInputs = <Widget>[];

  @override
  void initState() {
    _priceController.text = widget.prices[0]['price']?.toString();
    _suggestedPriceController.text =
        widget.prices[0]['suggestedPrice']?.toString();
    _price1Controller.text = widget.prices[0]['price1']?.toString();
    _price2Controller.text = widget.prices[0]['price2']?.toString();
    _price3Controller.text = widget.prices[0]['price3']?.toString();

    if(widget.prices != null && widget.prices[1] != null) {
      widget.prices[1].forEach((staircasePrice) {
        _staircasePriceInputs.add(StaircasePricesInput(staircasePrice: staircasePrice));
      });
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('商品价格'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.done,
            ),
            onPressed: () {
              if (_priceController.text.length <= 0) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text('供货价不能为空'),
                        ));
              } else {
                List<Object> results = <Object>[];
                Map<String, double> map = Map();
                map['price'] = double.parse(_priceController.text);
                map['suggestedPrice'] =
                    _suggestedPriceController.text.length > 0
                        ? double.parse(_suggestedPriceController.text)
                        : 0;
                map['price1'] = _price1Controller.text.length > 0
                    ? double.parse(_price1Controller.text)
                    : 0;
                map['price2'] = _price2Controller.text.length > 0
                    ? double.parse(_price2Controller.text)
                    : 0;
                map['price3'] = _price3Controller.text.length > 0
                    ? double.parse(_price3Controller.text)
                    : 0;

                results.add(map);
                results.add(_staircasePriceInputs);

                Navigator.pop(context, results);
              }
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
                leadingWidth: 80,
                controller: _priceController,
                focusNode: _priceFocusNode,
              ),
              TextFieldComponent(
                leadingText: '建议零售价',
                hintText: '请输入建议零售价',
                inputType: TextInputType.number,
                leadingWidth: 80,
                controller: _suggestedPriceController,
                focusNode: _suggestedFocusNode,
              ),
              Container(
//                padding: const EdgeInsets.only(top: 10),
                child: Card(
                    elevation: 0,
                    margin: EdgeInsets.symmetric(horizontal: 0),
                    child: Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Column(
                        children: <Widget>[
                          Text(
                            '会员价',
                            style: TextStyle(fontSize: 14),
                          ),
                          TextFieldComponent(
                            leadingText: '会员价（A）',
                            hintText: '请输入会员价（A）',
                            inputType: TextInputType.number,
                            leadingWidth: 80,
                            controller: _price1Controller,
                            focusNode: _price1FocusNode,
                          ),
                          TextFieldComponent(
                            leadingText: '会员价（B）',
                            hintText: '请输入会员价（B）',
                            inputType: TextInputType.number,
                            leadingWidth: 80,
                            controller: _price2Controller,
                            focusNode: _price2FocusNode,
                          ),
                          TextFieldComponent(
                            leadingText: '会员价（C）',
                            hintText: '请输入会员价（C）',
                            inputType: TextInputType.number,
                            leadingWidth: 80,
                            controller: _price3Controller,
                            focusNode: _price3FocusNode,
                          ),
                        ],
                      ),
                    )),
              ),
              Container(
//                padding: const EdgeInsets.all(8.0),
                child: Card(
                    margin: EdgeInsets.all(0),
                    child: Container(
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Column(
                        children: _staircasePriceList(),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _staircasePriceList() {
    List<Widget> list = <Widget>[
      Text(
        '阶梯价',
        style: TextStyle(fontSize: 14),
      ),
    ];

    //阶梯价行数据

    if(_staircasePriceInputs.length <= 0){
      _staircasePriceInputs.add(StaircasePricesInput());
    }

    list.addAll(_staircasePriceInputs);

    list.add(Container(
      width: 500,
      child: RaisedButton.icon(
        label: Text(''),
        icon: Icon(Icons.add),
        onPressed: () {
          setState(() {
            _staircasePriceInputs.add(StaircasePricesInput());
          });
        },
      ),
    ));

    return list;
  }
}

class StaircasePricesInput extends StatefulWidget {
  StaircasePriceModel staircasePrice;

  StaircasePricesInput({
    this.staircasePrice,
  });

  StaircasePricesInputState createState() => StaircasePricesInputState();
}

class StaircasePricesInputState extends State<StaircasePricesInput> {
  TextEditingController priceController;
  TextEditingController minQuantityController;

  @override
  void initState() {
    minQuantityController = TextEditingController(
        text: widget.staircasePrice?.minQuantity?.toString());
    priceController =
        TextEditingController(text: widget.staircasePrice?.price?.toString());

    // TODO: implement initState
    super.initState();
  }

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
                  TextField(
                    controller: minQuantityController,
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
                  TextField(
                    controller: priceController,
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
