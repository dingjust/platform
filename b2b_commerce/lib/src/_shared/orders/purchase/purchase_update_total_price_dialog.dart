import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';
import 'package:core/core.dart';

class PurchaseUpdateTotalPriceDialog extends StatefulWidget{
  PurchaseOrderModel purchaseOrderModel;

  PurchaseUpdateTotalPriceDialog({@required this.purchaseOrderModel});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _PurchaseUpdateTotalPriceDialogState();
  }
}

class _PurchaseUpdateTotalPriceDialogState extends State<PurchaseUpdateTotalPriceDialog>{
  final TextStyle _titleStyle = TextStyle(color: Colors.black,fontSize: 16,);
  final TextStyle _valueStyle = TextStyle(color: Colors.grey,fontSize: 16,);
  TextEditingController _totalPriceController = TextEditingController();
  FocusNode _totalPriceFocusNode = FocusNode();
  //定金
  double _depositAmount = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _totalPriceController.text = widget.purchaseOrderModel.totalPrice?.toString();
    _depositAmount = widget.purchaseOrderModel.deposit;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: null,
      child: Material(
          type: MaterialType.transparency,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom),
            child: Center(
              child: SizedBox(
                width: 300.0,
                height: 280.0,
                child: Container(
                  decoration: ShapeDecoration(
                    color: Color(0xffffffff),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 30,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 10, 0, 5),
                                child: Icon(
                                  Icons.edit,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 0),
                            padding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 5),
//                        alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: TextFieldComponent(
                                    textAlign: TextAlign.left,
                                    focusNode: _totalPriceFocusNode,
                                    controller: _totalPriceController,
                                    autofocus: true,
                                    hideDivider: true,
//                                    enabled: false,
                                    prefix: '￥',
                                    leadingText: Text(
                                      '订单总额：',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    onChanged: (v){
                                      if(v == '' || double.parse(v) == 0){
                                        setState(() {
                                          _depositAmount = widget.purchaseOrderModel.deposit;
                                        });
                                      }else{
                                        setState(() {
                                          _depositAmount = double.parse(v) * 0.3;
                                        });
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    children: <Widget>[
                                      Container(child: Text('定金：',style: _titleStyle,),width: 85,),
                                      Text('￥${(_depositAmount ?? 0.00).toStringAsFixed(2)}',style: _valueStyle,),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _showDatePicker(
                                        widget.purchaseOrderModel.expectedDeliveryDate, 5);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    child: Row(
//                                mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            '交货日期：',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          width: 85,
                                        ),
                                        Expanded(
                                          child: widget.purchaseOrderModel.expectedDeliveryDate ==
                                              null
                                              ? Text(
                                            '请选择日期',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          )
                                              : Text(
                                              DateFormatUtil.formatYMD(widget
                                                  .purchaseOrderModel.expectedDeliveryDate),
                                              style: TextStyle(
                                                color: Colors.grey,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
//                            Container(
//                              alignment: Alignment.centerRight,
//                              child: TextFieldComponent(
//                                textAlign: TextAlign.left,
//                                focusNode: widget.focusNode2,
//                                controller: widget.inputController2,
//                                autofocus: false,
//                                inputType: TextInputType.number,
//                                hideDivider: true,
//                                isInputBorder: true,
//                                prefix: '￥',
//                                leadingText: Text(
//                                  '        单价：',
//                                  style: TextStyle(fontSize: 16),
//                                ),
//                              ),
//                            ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: Container(
                                    child: FlatButton(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 55),
                                        child: Text('取消'),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        })),
                              ),
                              Center(
                                child: Container(
                                  child: FlatButton(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 55),
                                      child: Text('确定'
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      onPressed: () {
                                        Navigator.of(context).pop(
                                            _totalPriceController.text +
                                                ',' +
                                                widget.purchaseOrderModel.expectedDeliveryDate?.toString() ?? 'null');
                                      }),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              color: Colors.grey, width: 0.5))),
                                ),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      color: Colors.grey, width: 0.5))),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }

  //打开日期选择器
  void _showDatePicker(DateTime date, int index) {
    _selectDate(context, date, index);
  }

  //生成日期选择器
  Future<Null> _selectDate(BuildContext context, DateTime date,
      int index) async {
    DateTime nowTime = DateTime.now();
    DateTime dateTime =
    date == null ? nowTime : date.compareTo(nowTime) < 0 ? nowTime : date;
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: nowTime,
        lastDate: DateTime(2999));

    setState(() {
        widget.purchaseOrderModel.expectedDeliveryDate = _picked ?? date;
    });
  }
}
