import 'dart:ui';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class ApparelProductPricesInputPage extends StatefulWidget {
  ApparelProductModel item;
  bool enabled;

  ApparelProductPricesInputPage(this.item,{this.enabled = false});

  _ApparelProductPricesInputPageState createState() =>
      _ApparelProductPricesInputPageState();
}

class _ApparelProductPricesInputPageState
    extends State<ApparelProductPricesInputPage> {
  FocusNode _basicProductionFocusNode = FocusNode();
  TextEditingController _basicProductionController = TextEditingController();
  FocusNode _productionDaysFocusNode = FocusNode();
  TextEditingController _productionDaysController = TextEditingController();
  FocusNode _productionIncrementFocusNode = FocusNode();
  FocusNode _deliveryDaysFocusNode = FocusNode();
  TextEditingController _productionIncrementController = TextEditingController();
  TextEditingController _deliveryDaysController = TextEditingController();

  List<SteppedPriceModel> _steppedPrices = [];
  List<SteppedPriceModel> _spotSteppedPrices = [];
  Map<String,TextEditingController> _steppedQuantityControllerMap = {};
  Map<String,TextEditingController> _spotSteppedQuantityControllerMap = {};
  Map<String,TextEditingController> _steppedPriceControllerMap = {};
  Map<String,TextEditingController> _spotSteppedPriceControllerMap = {};

//  boll showSteppedPrices = false;

  bool isShowSteppedPrices = true;
  bool isShowSpotSteppedPrices = true;
  bool isShowProductionDays = true;

  bool _showFuture = false;
  bool _showSpot = false;

  void initState() {
    _productionDaysController.text = '${widget.item.productionDays ?? ''}';
    _productionIncrementController.text =
        '${widget.item.productionIncrement ?? ''}';
    _basicProductionController.text = '${widget.item.basicProduction ?? ''}';
    _deliveryDaysController.text = '${widget.item.deliveryDays ?? ''}';
    if(widget.item.productType.contains(ProductType.SPOT_GOODS ) || widget.item.productType.contains(ProductType.TAIL_GOODS)){
      _showSpot = true;
      if(widget.item.spotSteppedPrices != null && widget.item.spotSteppedPrices.isNotEmpty){
        _spotSteppedPrices = widget.item.spotSteppedPrices.map((stepped) => SteppedPriceModel.fromJson(SteppedPriceModel.toJson(stepped))).toList();
        _spotSteppedPrices.forEach((step){
          _spotSteppedQuantityControllerMap['${step.hashCode}'] = TextEditingController(text: '${step.minimumQuantity ?? ''}');
          _spotSteppedPriceControllerMap['${step.hashCode}'] = TextEditingController(text: '${step.price ?? ''}');
        });
      }
      if (_spotSteppedPrices.length <= 0) {
        var model = SteppedPriceModel();
        _spotSteppedPrices.add(model);
        _spotSteppedQuantityControllerMap['${model.hashCode}'] = TextEditingController();
        _spotSteppedPriceControllerMap['${model.hashCode}'] = TextEditingController();
      }
    }
    if(widget.item.productType == null || widget.item.productType.contains(ProductType.FUTURE_GOODS)){
      _showFuture = true;
      if (widget.item.steppedPrices != null && widget.item.steppedPrices.isNotEmpty) {
        _steppedPrices = widget.item.steppedPrices.map((stepped) => SteppedPriceModel.fromJson(SteppedPriceModel.toJson(stepped))).toList();
        _steppedPrices.forEach((step){
          _steppedQuantityControllerMap['${step.hashCode}'] = TextEditingController(text: '${step.minimumQuantity ?? ''}');
          _steppedPriceControllerMap['${step.hashCode}'] = TextEditingController(text: '${step.price ?? ''}');
        });
      }
      if (_steppedPrices.length <= 0) {
        var model = SteppedPriceModel();
        _steppedPrices.add(model);
        _steppedQuantityControllerMap['${model.hashCode}'] = TextEditingController();
        _steppedPriceControllerMap['${model.hashCode}'] = TextEditingController();
      }
    }


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.enabled ? '价格设置' : '价格明细'),
            elevation: 0.5,
            brightness: Brightness.light,
            centerTitle: true,
            actions: <Widget>[
              Offstage(
                offstage: !widget.enabled,
                child: GestureDetector(
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
                      widget.item.basicProduction = ClassHandleUtil.transInt(_basicProductionController.text);
                      widget.item.productionDays = ClassHandleUtil.transInt(_productionDaysController.text);
                      widget.item.productionIncrement = ClassHandleUtil.transInt(_productionIncrementController.text);
                      widget.item.deliveryDays = ClassHandleUtil.transInt(_deliveryDaysController.text);
                      widget.item.steppedPrices = _steppedPrices;
                      widget.item.spotSteppedPrices = _spotSteppedPrices;

                      Navigator.pop(context);
                    }),
              )
            ]),
        body: Container(
            color: Colors.grey[100],
            child: ListView(
              children: [
                Offstage(
                  offstage: !_showSpot,
                  child: Column(
                    children: <Widget>[
                      _buildSpotSteppedPrice(context),
                      _buildSpotStepeedList(),
                      _createSpotItemBtn(),
                      Divider(height: 0,),
                      // _buildDeliveryDays(context),
                      SizedBox(height: 10,child: Container(color: Colors.grey[100],),),
                    ],
                  ),
                ),
                Offstage(
                  offstage: !_showFuture,
                  child: Column(
                    children: <Widget>[
                      _buildFutureSteppedPrice(context),
                      _buildFutureStepeedList(),
                      _createFutureItemBtn(),
                      _bulidProductDays(),
                    ],
                  ),
                ),
              ],
            )));
  }

  // Widget _buildDeliveryDays(BuildContext context) {
  //   return Offstage(
  //     offstage: !isShowSpotSteppedPrices,
  //     child: Container(
  //       color: Colors.white,
  //       child: TextFieldComponent(
  //                   leadingWidth: 140,
  //                   focusNode: _deliveryDaysFocusNode,
  //                   controller: _deliveryDaysController,
  //                   textInputAction: TextInputAction.next,
  //                   leadingText: Text('发货周期（天）',
  //                       style: TextStyle(
  //                         fontSize: 16,
  //                       )),
  //                   hintText: widget.enabled ? '输入天数' : '',
  //                   inputFormatters: [
  //                     WhitelistingTextInputFormatter.digitsOnly
  //                   ],
  //                   enabled: widget.enabled,
  //                 ),
  //     ),
  //   );
  // }

  Widget _buildFutureStepeedList() {
    return Offstage(
      offstage: !isShowSteppedPrices,
      child: Column(
                  children: _steppedPrices.asMap().map((index,steppedPrice){
                    return MapEntry(index, Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Container(
                                  child: Center(child: Text('第'+ enumMap(DightEnum, index+1) +'阶梯')),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: TextField(
                                    textAlign: TextAlign.left,
                                    controller: _steppedQuantityControllerMap['${steppedPrice.hashCode}'],
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '输入数量',
                                      hintStyle: TextStyle(fontSize: 15),
                                    ),
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(fontSize: 14),
                                    //只能输入数字
                                    inputFormatters: <TextInputFormatter>[
                                      WhitelistingTextInputFormatter.digitsOnly,
                                    ],
                                    enabled: widget.enabled,
                                    onChanged: (v) {
                                      setState(() {
                                        steppedPrice.minimumQuantity = ClassHandleUtil.transInt(_steppedQuantityControllerMap['${steppedPrice.hashCode}'].text);
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Opacity(
                                opacity: _steppedPriceControllerMap['${steppedPrice.hashCode}'] == null || _steppedPriceControllerMap['${steppedPrice.hashCode}'].text == '' ? 0 : 1,
                                child: Text('￥',style: TextStyle(color: Colors.grey,),),
                              ),
                              Expanded(
                                flex: 2,
                                child: TextField(
                                  textAlign: TextAlign.left,
                                  controller: _steppedPriceControllerMap['${steppedPrice.hashCode}'],
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '输入价格',
                                    hintStyle: TextStyle(fontSize: 15),
                                  ),
                                  style: TextStyle(fontSize: 14),
                                  //只能输入数字
                                  inputFormatters: <TextInputFormatter>[
                                    DecimalInputFormat()
                                  ],
                                  enabled: widget.enabled,
                                  onChanged: (v) {
                                    setState(() {
                                      steppedPrice.price = ClassHandleUtil.removeSymbolRMBToDouble(_steppedPriceControllerMap['${steppedPrice.hashCode}'].text);
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Offstage(
                                  offstage: !widget.enabled || index == 0,
                                  child: IconButton(
                                    icon: Container(
                                      constraints: BoxConstraints.expand(
                                        width: 30.0,
                                        height: 30.0,
                                      ),
                                      decoration:
                                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                                      child: Icon(
                                        B2BIcons.close,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _steppedQuantityControllerMap.remove('${steppedPrice.hashCode}');
                                        _steppedPriceControllerMap.remove('${steppedPrice.hashCode}');
                                        _steppedPrices.remove(steppedPrice);
                                      });
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Divider(height: 0),
                          ),
                        ],
                      ),
                    ));
                  }).values.toList(),
                ),
    );
  }

  Widget _buildSpotStepeedList() {
    return Offstage(
      offstage: !isShowSpotSteppedPrices,
      child: Column(
                  children: _spotSteppedPrices.asMap().map((index,steppedPrice){
                    return MapEntry(index, Offstage(
                      offstage: !isShowSteppedPrices,
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    child: Center(child: Text('第'+ enumMap(DightEnum, index+1) +'阶梯')),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: TextField(
                                      textAlign: TextAlign.left,
                                      controller: _spotSteppedQuantityControllerMap['${steppedPrice.hashCode}'],
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '输入数量',
                                        hintStyle: TextStyle(fontSize: 15),
                                      ),
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(fontSize: 14),
                                      //只能输入数字
                                      inputFormatters: <TextInputFormatter>[
                                        WhitelistingTextInputFormatter.digitsOnly,
                                      ],
                                      enabled: widget.enabled,
                                      onChanged: (v) {
                                        setState(() {
                                          steppedPrice.minimumQuantity = ClassHandleUtil.transInt(_spotSteppedQuantityControllerMap['${steppedPrice.hashCode}'].text);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Opacity(
                                  opacity: _spotSteppedPriceControllerMap['${steppedPrice.hashCode}'] == null || _spotSteppedPriceControllerMap['${steppedPrice.hashCode}'].text == '' ? 0 : 1,
                                  child: Text('￥',style: TextStyle(color: Colors.grey,),),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    textAlign: TextAlign.left,
                                    controller: _spotSteppedPriceControllerMap['${steppedPrice.hashCode}'],
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '输入价格',
                                      hintStyle: TextStyle(fontSize: 15),
                                    ),
                                    style: TextStyle(fontSize: 14),
                                    //只能输入数字
                                    inputFormatters: <TextInputFormatter>[
                                      DecimalInputFormat()
                                    ],
                                    enabled: widget.enabled,
                                    onChanged: (v) {
                                      setState(() {
                                        steppedPrice.price = ClassHandleUtil.removeSymbolRMBToDouble(_spotSteppedPriceControllerMap['${steppedPrice.hashCode}'].text);
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Offstage(
                                    offstage: !widget.enabled || index == 0,
                                    child: IconButton(
                                      icon: Container(
                                        constraints: BoxConstraints.expand(
                                          width: 30.0,
                                          height: 30.0,
                                        ),
                                        decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(15)),
                                        child: Icon(
                                          B2BIcons.close,
                                          color: Colors.red,
                                          size: 18,
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _spotSteppedQuantityControllerMap.remove('${steppedPrice.hashCode}');
                                          _spotSteppedPriceControllerMap.remove('${steppedPrice.hashCode}');
                                          _spotSteppedPrices.remove(steppedPrice);
                                        });
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Divider(height: 0),
                            ),
                          ],
                        ),
                      ),
                    ));
                  }).values.toList(),
                ),
    );
  }

  Widget _buildFutureSteppedPrice(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                isShowSteppedPrices = !isShowSteppedPrices;
              });
            },
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '期货价',
                    style: TextStyle(fontSize: 16),
                  ),
                  isShowSteppedPrices
                      ? Icon(Icons.keyboard_arrow_down)
                      : Icon(Icons.keyboard_arrow_right),
                ],
              ),
            ),
          ),
          Offstage(
            offstage: !isShowSteppedPrices,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Divider(
                    height: 0,
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width:
                            (MediaQueryData.fromWindow(window).size.width - 50) / 3,
                        child: Container(),
                      ),
                      Container(
                        width:
                            (MediaQueryData.fromWindow(window).size.width - 50) / 3,
                        child: Text('起订量'),
                      ),
                      Container(
                        width:
                            (MediaQueryData.fromWindow(window).size.width - 50) / 3,
                        child: Text('阶梯价格'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Divider(height: 0),
                ),
              ],
            ),
          ),
          
        ],
      ),
    );
  }
  Widget _buildSpotSteppedPrice(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                isShowSpotSteppedPrices = !isShowSpotSteppedPrices;
              });
            },
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '现货/尾货价',
                    style: TextStyle(fontSize: 16),
                  ),
                  isShowSpotSteppedPrices
                      ? Icon(Icons.keyboard_arrow_down)
                      : Icon(Icons.keyboard_arrow_right),
                ],
              ),
            ),
          ),
          Offstage(
            offstage: !isShowSpotSteppedPrices,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Divider(
                    height: 0,
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width:
                            (MediaQueryData.fromWindow(window).size.width - 50) / 3,
                        child: Container(),
                      ),
                      Container(
                        width:
                            (MediaQueryData.fromWindow(window).size.width - 50) / 3,
                        child: Text('起订量'),
                      ),
                      Container(
                        width:
                            (MediaQueryData.fromWindow(window).size.width - 50) / 3,
                        child: Text('阶梯价格'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Divider(height: 0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bulidProductDays() {
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                isShowProductionDays = !isShowProductionDays;
              });
            },
            child: Container(
              margin: EdgeInsets.only(top: 10),
              color: Colors.white,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '生产天数',
                      style: TextStyle(fontSize: 16),
                    ),
                    isShowProductionDays
                        ? Icon(Icons.keyboard_arrow_down)
                        : Icon(Icons.keyboard_arrow_right),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Divider(height: 0),
          ),
          Offstage(
            offstage: !isShowProductionDays,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: <Widget>[
                  TextFieldComponent(
                    focusNode: _basicProductionFocusNode,
                    controller: _basicProductionController,
                    textInputAction: TextInputAction.next,
                    leadingText: Text('基础生产量',
                        style: TextStyle(
                          fontSize: 16,
                        )),
                    hintText: widget.enabled ? '输入数量' : '',
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    onEditingComplete: (){
                      FocusScope.of(context).requestFocus(_productionDaysFocusNode);
                    },
                    enabled: widget.enabled,
                  ),
                  TextFieldComponent(
                    focusNode: _productionDaysFocusNode,
                    controller: _productionDaysController,
                    textInputAction: TextInputAction.next,
                    leadingText: Text('生产天数',
                        style: TextStyle(
                          fontSize: 16,
                        )),
                    hintText: widget.enabled ? '输入天数' : '',
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    onEditingComplete: (){
                      FocusScope.of(context).requestFocus(_productionIncrementFocusNode);
                    },
                    enabled: widget.enabled,
                  ),
                  TextFieldComponent(
                    focusNode: _productionIncrementFocusNode,
                    controller: _productionIncrementController,
                    leadingWidth: 170,
                    leadingText: Text('生产增量（数量/1天）',
                        style: TextStyle(
                          fontSize: 16,
                        )),
                    hintText: widget.enabled ? '输入数量' : '',
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    enabled: widget.enabled,
                  ),
                ],
              ),
            ),
          ),
          Offstage(
            offstage: !isShowProductionDays,
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text('生产增量即下单多N件则生产周期延长1天。',style: TextStyle(color: Colors.grey),),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createFutureItemBtn() {
    return Offstage(
      offstage: _steppedPrices.length >= 3 || !isShowSteppedPrices || !widget.enabled,
      child: GestureDetector(
        onTap: () {
          if (_steppedPrices.length >= 0 && _steppedPrices.length < 3) {
            setState(() {
              var model = SteppedPriceModel();
              _steppedPrices.add(model);
              _steppedQuantityControllerMap['${model.hashCode}'] = TextEditingController();
              _steppedPriceControllerMap['${model.hashCode}'] = TextEditingController();
            });
          }
        },
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.add,
                size: 18,
              ),
              Text('添加'),
            ],
          ),
        ),
      ),
    );
  }
  Widget _createSpotItemBtn() {
    return Offstage(
      offstage: _spotSteppedPrices.length >= 3 || !isShowSpotSteppedPrices || !widget.enabled,
      child: GestureDetector(
        onTap: () {
          if (_spotSteppedPrices.length >= 0 && _spotSteppedPrices.length < 3) {
            setState(() {
              var model = SteppedPriceModel();
              _spotSteppedPrices.add(model);
              _spotSteppedQuantityControllerMap['${model.hashCode}'] = TextEditingController();
              _spotSteppedPriceControllerMap['${model.hashCode}'] = TextEditingController();
            });
          }
        },
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.add,
                size: 18,
              ),
              Text('添加'),
            ],
          ),
        ),
      ),
    );
  }

}
