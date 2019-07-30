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
  FocusNode _proofingFeeFocusNode = FocusNode();
  final TextEditingController _proofingFeeController = TextEditingController();
  FocusNode _basicProductionFocusNode = FocusNode();
  final TextEditingController _basicProductionController =
      TextEditingController();
  FocusNode _productionDaysFocusNode = FocusNode();
  final TextEditingController _productionDaysController =
      TextEditingController();
  FocusNode _productionIncrementFocusNode = FocusNode();
  final TextEditingController _productionIncrementController =
      TextEditingController();
  Map<String, Object> map;

  List<SteppedPriceModel> models = [];
  List<FocusNode> quantityFocusNodes = [];
  List<FocusNode> priceFocusNodes = [];
  List<TextEditingController> quantityControllers = [];
  List<TextEditingController> priceControllers = [];
  Map<SteppedPriceModel,TextEditingController> priceMap = Map();

//  boll showSteppedPrices = false;

  bool isShowSteppedPrices = true;
  bool isShowProductionDays = true;

  void initState() {
    _proofingFeeController.text = '${widget.item.proofingFee ?? ''}';
    _productionDaysController.text = '${widget.item.productionDays ?? ''}';
    _productionIncrementController.text =
        '${widget.item.productionIncrement ?? ''}';
    _basicProductionController.text = '${widget.item.basicProduction ?? ''}';
    if (widget.item.steppedPrices != null &&
        widget.item.steppedPrices.isNotEmpty) {
      models.addAll(widget.item.steppedPrices);
    }
    if (models.length <= 0) {
      models.add(SteppedPriceModel());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    quantityControllers.clear();
//    priceControllers.clear();
    for(var model in models){
      quantityFocusNodes.add(FocusNode());
      priceFocusNodes.add(FocusNode());
      quantityControllers.add(TextEditingController(text: model.minimumQuantity == null ? '' : model.minimumQuantity.toString()));
      if(!priceMap.containsKey(model)){
        TextEditingController controller = TextEditingController(text: model.price == null ? '' : model.price.toString());
        priceMap.putIfAbsent(model, ()=>controller);
      }
    }
    priceControllers = priceMap.values.toList();

    List<Widget> widgets = [];
    widgets.add(_buildFactoryInfo(context));
    for (int i = 0; i < models.length; i++) {
      widgets.add(_buildItem(context,models[i], i + 1, quantityFocusNodes[i],
          priceFocusNodes[i], quantityControllers[i], priceControllers[i]));
    }
    widgets.add(createItemBtn());
    widgets.add(_bulidProductDays());

    return Scaffold(
        appBar: AppBar(
            title: Text('价格设置'),
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
//                      if(_proofingFeeController.text == '' || _basicProductionController.text == '' || _productionDaysController.text == '' || _productionIncrementController.text == ''){
//                        ShowDialogUtil.showValidateMsg(context, '价格设置资料未完善');
//                        return;
//                      }
//
//                      for (var model in models) {
//                        if(model.minimumQuantity == null || model.price == null){
//                          ShowDialogUtil.showValidateMsg(context, '价格设置资料未完善');
//                          return;
//                        }
//                      }
                      widget.item.proofingFee = ClassHandleUtil.removeSymbolRMBToDouble(_proofingFeeController.text);
                      widget.item.basicProduction = ClassHandleUtil.transInt(_basicProductionController.text);
                      widget.item.productionDays = ClassHandleUtil.transInt(_productionDaysController.text);
                      widget.item.productionIncrement = ClassHandleUtil.transInt(_productionIncrementController.text);

                      for(int i=0;i<models.length;i++){
                        if(models[i].minimumQuantity == null && models[i].price != null){
                          ShowDialogUtil.showValidateMsg(context, '请完善阶梯起订量');
                          return;
                        }
                        if(models[i].price == null && models[i].minimumQuantity == null){
                          models.remove(models[i]);
                        }
                      }

                      if(models.length >1){
                        for(int i=0;i<models.length;i++){
                          if(i == models.length - 1){
                            break;
                          }

                          if(models[i + 1].minimumQuantity != null && models[i].minimumQuantity != null){
                            if(models[i + 1].minimumQuantity <= models[i].minimumQuantity){
                              ShowDialogUtil.showValidateMsg(context, '第'+ enumMap(DightEnum, i+2) + '阶梯的起订量不可小于或等于' + '第'+ enumMap(DightEnum, i+1)+'阶梯的起订量');
                              return;
                            }
                          }

                        }
                      }

                      widget.item.steppedPrices = models;

                      Navigator.pop(context);
                    }),
              )
            ]),
        body: Container(
            color: Colors.grey[100],
            child: ListView(
              children: widgets,
            )));
  }

  Widget _buildFactoryInfo(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: TextFieldComponent(
              focusNode: _proofingFeeFocusNode,
              controller: _proofingFeeController,
              leadingText: Text('打样费',
                  style: TextStyle(
                    fontSize: 16,
                  )),
              hintText: widget.enabled ? '请输入单件打样价格' : '',
              prefix: '￥',
              inputFormatters: [
                DecimalInputFormat(),
              ],
              enabled: widget.enabled,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: GestureDetector(
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
                      '大货价',
                      style: TextStyle(fontSize: 16),
                    ),
                    isShowSteppedPrices
                        ? Icon(Icons.keyboard_arrow_down)
                        : Icon(Icons.keyboard_arrow_right),
                  ],
                ),
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
                    leadingWidth: 135,
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

  Widget _buildItem(
      BuildContext context,
      SteppedPriceModel model,
      int seq,
      FocusNode quantityFocusNode,
      FocusNode priceFocusNode,
      TextEditingController quantityController,
      TextEditingController priceController) {
    if(seq > 1){
      quantityFocusNode.addListener((){

        if(!quantityFocusNode.hasFocus && models[seq-1].minimumQuantity != null && models[seq-2].minimumQuantity != null){
          if(models[seq-1].minimumQuantity <= models[seq-2].minimumQuantity){
            quantityController.clear();
            models[seq-1].minimumQuantity = null;
//            ShowDialogUtil.showSnakeBarByKey(_scaffoldKey,context, '第'+ enumMap(DightEnum, seq) + '阶梯的起订量不可小于或等于' + '第'+ enumMap(DightEnum, seq - 1)+'阶梯的起订量');
            ShowDialogUtil.showValidateMsg(context, '第'+ enumMap(DightEnum, seq) + '阶梯的起订量不可小于或等于' + '第'+ enumMap(DightEnum, seq - 1)+'阶梯的起订量');
//              return;
          }
        }
      });
    }

    return Offstage(
      offstage: !isShowSteppedPrices,
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: (MediaQueryData.fromWindow(window).size.width - 50) / 3,
                  child: Center(child: Text('第'+ enumMap(DightEnum, seq) +'阶梯')),
                ),
                Container(
                  width: (MediaQueryData.fromWindow(window).size.width - 50) / 3,
                  child: Center(
                    child: TextFieldComponent(
                      textAlign: TextAlign.left,
                      focusNode: quantityFocusNode,
                      controller: quantityController,
                      hintText: widget.enabled ? '输入数量' : '',
                      hideDivider: true,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      onChanged: (v) {
                        model.minimumQuantity = ClassHandleUtil.transInt(quantityController.text);
                      },
                      enabled: widget.enabled,
                    ),
                  ),
                ),
                Container(
                  width: (MediaQueryData.fromWindow(window).size.width - 50) / 3,
                  child: TextFieldComponent(
                    textAlign: TextAlign.left,
                    focusNode: priceFocusNode,
                    controller: priceController,
                    hintText: widget.enabled ? '输入价格' : '',
                    prefix: '￥',
                    inputFormatters: [DecimalInputFormat()],
                    hideDivider: true,
                    onChanged: (v) {
                      model.price = ClassHandleUtil.removeSymbolRMBToDouble(priceController.text);
                    },
                    enabled: widget.enabled,
                  ),
                ),
                Offstage(
                  offstage: !widget.enabled || seq == 1,
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
                        models.remove(model);
                        quantityControllers.remove(quantityController);
                        priceMap.remove(model);
                      });
                    },
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
    );
  }

  Widget createItemBtn() {
    return Offstage(
      offstage: models.length >= 3 || !isShowSteppedPrices || !widget.enabled,
      child: GestureDetector(
        onTap: () {
          if (models.length >= 0 && models.length < 3) {
            setState(() {
              models.add(SteppedPriceModel());
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
