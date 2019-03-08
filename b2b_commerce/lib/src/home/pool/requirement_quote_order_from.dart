import 'dart:io';

import 'package:b2b_commerce/src/home/pool/quote_order_input_page.dart';
import 'package:b2b_commerce/src/home/pool/requirement_pool_all.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class RequirementQuoteOrderFrom extends StatefulWidget {
  RequirementOrderModel model;
  QuoteModel quoteModel;

  RequirementQuoteOrderFrom({@required this.model});

  _RequirementQuoteOrderFromState createState() => _RequirementQuoteOrderFromState();
}

class _RequirementQuoteOrderFromState extends State<RequirementQuoteOrderFrom> {
  double fabricPrice = 0.00;
  double accessoriesPrice = 0.00;
  double machiningPrice = 0.00;
  double otherPrice = 0.00;
  double totalPrice = 0.00;
  double proofingPrice = 0.00;
  String remarks;
  String deliveryDate;
  List<MediaModel> _normalImages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: true,
        elevation: 0.5,
        title: Text('填写报价'),
      ),
        body: Container(
            color: Color(0xffF0F0F0),
            margin: EdgeInsets.only(bottom: 70),
            child: ListView(
              children: <Widget>[
                _buildRequirementInfo(context),
                _buildQuoteInfo(context),
                _buildProofingInfo(context),
                _buildConfirmationDeliveryDate(context),
                _buildAccessory(context),
                _buildRemarks(context),
//              _buildCommitButton(context),
              ],
            )
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Container(
          width: 0,
          child: Icon(
            null,
            color: Colors.white,
          ),
        ),
        label: Container(
            width: 250,
            child:  Center(
              child: Text(
                '去报价',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RequirementPoolAll()),
          );
        },
        backgroundColor: Colors.amberAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        backgroundColor:Colors.white
    );
  }

  Widget _buildRequirementInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 15),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(13, 5, 10, 5),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://gd3.alicdn.com/imgextra/i2/0/TB194socYrpK1RjSZTEXXcWAVXa_!!0-item_pic.jpg'),
                        fit: BoxFit.cover,
                      )),
                ),
                Container(
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          widget.model.details.productName,
                          style: TextStyle(
                              fontSize: 16
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          '${widget.model.details.productSkuID}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          '${widget.model.details.majorCategory.name} ${widget.model.details.category.name} ${widget.model.totalQuantity}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xffFFBBFF),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 13),
                    child: Text(
                      '交货日期',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 17),
                  child: Text(
                    DateFormatUtil.formatYMD(
                        widget.model.details.expectedDeliveryDate),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQuoteInfo(BuildContext context){
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.fromLTRB(0,10,0,10),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                '报价明细',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Container(
            child: GestureDetector(
              child: ListTile(
                leading: Text(
                  '面料单价',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Text(
                  fabricPrice == 0.00 ? '填写' : '${fabricPrice}',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey),
                ),
              ),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuoteOrderInputPage(fieldText: '面料单价',inputType: TextInputType.number)),
                  //接收返回数据并处理
                ).then((value) {
                  setState(() {
                    fabricPrice = double.parse(value);
                    totalPrice = fabricPrice + accessoriesPrice + machiningPrice +otherPrice;
                  });
                });
              },
            )
          ),
          Divider(
            height: 1,
          ),
          Container(
              child: GestureDetector(
                child: ListTile(
                  leading: Text(
                    '辅料单价',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Text(
                    accessoriesPrice == 0.00 ? '填写' : '${accessoriesPrice}',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QuoteOrderInputPage(fieldText: '辅料单价',inputType: TextInputType.number)),
                    //接收返回数据并处理
                  ).then((value) {
                    setState(() {
                      accessoriesPrice = double.parse(value);
                      totalPrice = fabricPrice + accessoriesPrice + machiningPrice +otherPrice;
                    });
                  });
                },
              )
          ),
          Divider(
            height: 1,
          ),
          Container(
              child: GestureDetector(
                child: ListTile(
                  leading: Text(
                    '加工单价',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Text(
                    machiningPrice == 0.00 ? '填写' : '${machiningPrice}',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QuoteOrderInputPage(fieldText: '加工单价',inputType: TextInputType.number)),
                    //接收返回数据并处理
                  ).then((value) {
                    setState(() {
                      machiningPrice = double.parse(value);
                      totalPrice = fabricPrice + accessoriesPrice + machiningPrice +otherPrice;
                    });
                  });
                },
              )
          ),
          Divider(
            height: 1,
          ),
          Container(
              child: GestureDetector(
                child: ListTile(
                  leading: Text(
                    '其他',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Text(
                    otherPrice == 0.00 ? '填写' : '${otherPrice}',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QuoteOrderInputPage(fieldText: '其他',inputType: TextInputType.number)),
                    //接收返回数据并处理
                  ).then((value) {
                    setState(() {
                      otherPrice = double.parse(value);
                      totalPrice = fabricPrice + accessoriesPrice + machiningPrice +otherPrice;
                    });
                  });
                },
              )
          ),
          Divider(
            height: 1,
          ),
          Container(
              child: ListTile(
                  trailing: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                         '生产单价：',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                      ),
                      Text(
                        '￥${totalPrice}',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.red),
                      ),
                    ],
                  )
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildProofingInfo(BuildContext context){
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 5),
      child: Column(
        children: <Widget>[
          Container(
              child: GestureDetector(
                child: ListTile(
                  leading: Text(
                    '打样费',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Text(
                    proofingPrice == 0.00 ? '填写' : '${proofingPrice}',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QuoteOrderInputPage(fieldText: '打样费',inputType: TextInputType.number)),
                    //接收返回数据并处理
                  ).then((value) {
                    setState(() {
                      proofingPrice = double.parse(value);
                    });
                  });
                },
              )
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationDeliveryDate(BuildContext context){
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 5),
      child: Column(
        children: <Widget>[
          Container(
              child: GestureDetector(
                child: ListTile(
                  leading: Text(
                    '确认交货日期',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Text(
                    deliveryDate == null ? '选择' : deliveryDate,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                ),
                onTap: (){
                  _showDatePicker();
                },
              )
          ),
        ],
      ),
    );
  }

  Widget _buildAccessory(BuildContext context){
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Column(children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "附件",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10),
              child: EditableAttachments(list: _normalImages),
            )),
      ]),
    );
  }

  Widget _buildRemarks(BuildContext context) {
    return remarks == null || remarks == '' ?
    Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 5),
      child: Column(
        children: <Widget>[
          Container(
              child: GestureDetector(
                child: ListTile(
                  leading: Text(
                    '备注',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Text(
                    remarks == null ? '填写' : remarks,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            QuoteOrderInputPage(fieldText: '备注',
                                inputType: TextInputType.text)),
                    //接收返回数据并处理
                  ).then((value) {
                    setState(() {
                      remarks = value;
                    });
                  });
                },
              )
          ),
        ],
      ),
    )
        :
    GestureDetector(
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 5),
          padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
          child: Column(children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "备注",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    remarks,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )),

          ]
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    QuoteOrderInputPage(
                        fieldText: '备注', inputType: TextInputType.text)),
            //接收返回数据并处理
          ).then((value) {
            setState(() {
              remarks = value;
            });
          });
        }
    );
  }

  Widget _buildCommitButton(BuildContext context) {
    return Container(
        height: 50,
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: RaisedButton(
          color: Colors.amberAccent,
          child: Text(
            '提交报价',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          onPressed: () {
//            widget.quoteModel.unitPriceOfFabric = fabricPrice;
//            widget.quoteModel.unitPriceOfExcipients = accessoriesPrice;
//            widget.quoteModel.unitPriceOfProcessing = machiningPrice;
//            widget.quoteModel.costOfSamples = proofingPrice;
//            widget.quoteModel.costOfOther = otherPrice;
//            widget.quoteModel.totalPrice = totalPrice;
//            widget.quoteModel.expectedDeliveryDate = DateTime.parse(deliveryDate);
//            widget.quoteModel.requirementOrderCode = widget.model.code;
//            widget.quoteModel.remarks = remarks;
//            widget.quoteModel.attachments = _normalImages;

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RequirementPoolAll()),
            );
          },
        )
    );
  }


  //打开日期选择器
  void _showDatePicker() {
    _selectDate(context);
  }

  //生成日期选择器
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: new DateTime(1990),
        lastDate: new DateTime(2999));

    if (_picked != null) {
      print(_picked);
      setState(() {
        deliveryDate = DateFormatUtil.formatYMD(_picked);
      });
    }
  }

}