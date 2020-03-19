import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class PurchaseUpdateDeductionAmountDialog extends StatefulWidget{
  PurchaseOrderModel purchaseOrderModel;

  PurchaseUpdateDeductionAmountDialog({@required this.purchaseOrderModel});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _PurchaseUpdateDeductionAmountDialogState();
  }
}

class _PurchaseUpdateDeductionAmountDialogState extends State<PurchaseUpdateDeductionAmountDialog>{
  final TextStyle _titleStyle = TextStyle(color: Colors.black,fontSize: 16,);
  final TextStyle _valueStyle = TextStyle(color: Colors.grey,fontSize: 16,);
  TextEditingController _deductionAmountController = TextEditingController();
  FocusNode _deductionAmountFocusNode = FocusNode();
  //实付金额
  double _payAmount = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _payAmount = (widget.purchaseOrderModel.balance ?? 0.00) +
        (widget.purchaseOrderModel.deductionAmount ?? 0);
    if (widget.purchaseOrderModel.deductionAmount != null &&
        widget.purchaseOrderModel.deductionAmount < 0) {
      _deductionAmountController.text =
          widget.purchaseOrderModel.deductionAmount.toString().substring(1);
    } else {
      _deductionAmountController.text =
          widget.purchaseOrderModel.deductionAmount?.toString();
    }
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
              height: 350.0,
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(10, 10, 0, 5),
                                  child: Icon(
                                    Icons.edit,
                                    size: 30,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
//                          GestureDetector(
//                            child: Container(
//                              margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
//                              child: Text(
//                                '无需付款直接跳过 >>',
//                                style: TextStyle(
//                                  color: Colors.grey,
//                                ),
//                              ),
//                            ),
//                            onTap: widget.jumpAction,
//                          ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
//                        margin:
//                        EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                          padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                                alignment: Alignment.centerRight,
                                child: Row(
                                  children: <Widget>[
                                    Text('订单总额：',style: _titleStyle,),
                                    Text('￥${(widget.purchaseOrderModel
                                        .totalPrice ?? 0.00).toStringAsFixed(
                                        2)}', style: _valueStyle,),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                                alignment: Alignment.centerRight,
                                child: Row(
                                  children: <Widget>[
                                    Text('已付定金：',style: _titleStyle,),
                                    Text(
                                      '￥${(widget.purchaseOrderModel.deposit ??
                                          0.00).toStringAsFixed(2)}',
                                      style: _valueStyle,),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                                alignment: Alignment.centerRight,
                                child: Row(
                                  children: <Widget>[
                                    Text('应付尾款：',style: _titleStyle,),
                                    Text(
                                      '￥${(widget.purchaseOrderModel.balance ??
                                          0.00).toStringAsFixed(2)}',
                                      style: _valueStyle,),
                                  ],
                                ),
                              ),
                              Divider(),
                              Container(
                                alignment: Alignment.centerRight,
                                child: TextFieldComponent(
                                  textAlign: TextAlign.left,
                                  focusNode: _deductionAmountFocusNode,
                                  controller: _deductionAmountController,
                                  autofocus: true,
                                  hintText: '其他扣款',
                                  hideDivider: true,
                                  enabled: true,
                                  prefix: '￥',
                                  inputFormatters: [
                                    DecimalInputFormat(),
                                  ],
                                  leadingText: Text(
                                    '其他扣款：',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  onChanged: (v){
                                    if(v == '' || double.parse(v) == 0){
                                      setState(() {
                                        _payAmount =
                                            widget.purchaseOrderModel.balance ??
                                                0;
                                      });
                                    }else{
                                      setState(() {
                                        if (double.parse(v) ==
                                            widget.purchaseOrderModel.balance) {
                                          _payAmount = 0;
                                        } else {
                                          _payAmount =
                                              (widget.purchaseOrderModel
                                                  .balance ?? 0) -
                                                  double.parse(v);
                                        }
                                      });
                                    }
                                  },
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 15,bottom: 20),
                                child: Row(
                                  children: <Widget>[
                                    Text('注：如无扣款不用填写',style: TextStyle(color: Colors.red),),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                                alignment: Alignment.centerRight,
                                child: Row(
                                  children: <Widget>[
                                    Text('实付金额：',style: TextStyle(fontSize: 20),),
                                    Text('￥${_payAmount?.toStringAsFixed(2)}',
                                      style: TextStyle(fontSize: 20,color: Colors.grey,),),
                                  ],
                                ),
                              ),
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
                                    child: Text('确定'),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    onPressed: () {
                                      String text = '0';
                                      if (_deductionAmountController.text !=
                                          '') {
                                        text = '-' +
                                            _deductionAmountController.text;
                                      }
                                      Navigator.pop(context, text);

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
                                top: BorderSide(color: Colors.grey, width: 0.5))),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
