import 'dart:math';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class ProductionGenerateUniqueCodePage extends StatefulWidget {
  final PurchaseOrderModel model;

  ProductionGenerateUniqueCodePage({@required this.model});

  _ProductionGenerateUniqueCodePageState createState() =>
      _ProductionGenerateUniqueCodePageState();
}

class _ProductionGenerateUniqueCodePageState
    extends State<ProductionGenerateUniqueCodePage> {
  TextEditingController _textEditingController = TextEditingController();

  String uniqueCode;

  TextEditingController _smsController = TextEditingController();
  TextEditingController _onlineController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('生产唯一码'),
          elevation: 0.5,
          brightness: Brightness.light,
          centerTitle: true,
        ),
        body: Container(
          color: Color.fromRGBO(245, 245, 245, 1),
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: ListView(
            children: <Widget>[
              _buildMain(context),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: GenerateUniqueCodeItem(
                  order: widget.model,
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildMain(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Column(
        children: <Widget>[
          _buildMainHeader(),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Column(
              children: <Widget>[
                Container(
                  width: 180,
                  child: FlatButton(
                    color: Colors.orange,
                    onPressed: () {
                      // _smsInvite();
                    },
                    child: Text(
                      '短信邀请',
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                ),
                Container(
                  width: 180,
                  child: FlatButton(
                    color: Colors.white,
                    onPressed: () {},
                    child: Text(
                      '线上邀请',
                      style: TextStyle(color: Colors.orange),
                    ),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.5, color: Colors.orange),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                ),
                Text(
                  '线上已注册工厂用户',
                  style: TextStyle(
                      color: Color.fromRGBO(255, 45, 45, 1), fontSize: 12),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text(
                    '把唯一码发给工厂，工厂可以使用唯一码导入您创建的生产订单，通过线上反馈生产进度。',
                    style: TextStyle(
                        color: Color.fromRGBO(100, 100, 100, 1), fontSize: 12),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMainHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FlatButton(
          color: Color.fromRGBO(255, 45, 45, 1),
          onPressed: () {
            setState(() {
              uniqueCode = 'DJKJKL${Random().nextInt(100000)}';
            });
          },
          child: Text(
            uniqueCode != null ? '重新生成' : '生成',
            style: TextStyle(color: Colors.white),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
        uniqueCode != null
            ? Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    '${uniqueCode}',
                    style: TextStyle(fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            : Container(),
        FlatButton(
          color: Colors.white,
          onPressed: () {},
          child: Text(
            '复制',
            style: TextStyle(color: Color.fromRGBO(22, 141, 255, 1)),
          ),
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 0.5, color: Color.fromRGBO(22, 141, 255, 1)),
              borderRadius: BorderRadius.all(Radius.circular(20))),
        )
      ],
    );
  }

  void _smsInvite() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('请输入对方的手机号码'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFieldComponent(
                  controller: _smsController,
                  focusNode: _focusNode,
                  autofocus: true,
                  inputType: TextInputType.number,
                  hintText: '请输入加工数量',
                  padding: EdgeInsets.all(0),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                '确定',
                style: TextStyle(color: Color(0xffFF9516)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class GenerateUniqueCodeItem extends StatelessWidget {
  const GenerateUniqueCodeItem({Key key, this.order}) : super(key: key);

  final PurchaseOrderModel order;

  // 订单渠道类型
  // static Map<RequirementOrderStatus, MaterialColor> _statusColors = {
  //   RequirementOrderStatus.PENDING_QUOTE: Colors.green,
  //   RequirementOrderStatus.COMPLETED: Colors.orange,
  //   RequirementOrderStatus.CANCELLED: Colors.red
  // };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => PurchaseOrderDetailPage(order: order),
        //   ),
        // );
      },
      child: Container(
        child: Column(
          children: <Widget>[
            _buildHeader(),
            Column(
              children: _buildEntries(),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  '工厂：' + order.belongTo.name,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              // TODO : 订单类型枚举和对应颜色
              // Text(
              //   RequirementOrderStatusLocalizedMap[order.status],
              //   style: TextStyle(color: _statusColors[order.status])
              // )
              Text(
                '生产中',
                style: TextStyle(
                    color: Color.fromRGBO(86, 194, 117, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildEntries() {
    return order.entries
        .map((entry) => Container(
              color: Color.fromRGBO(250, 250, 250, 1),
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: entry.product.thumbnail != null
                              ? NetworkImage(entry.product.thumbnail)
                              : AssetImage(
                                  'temp/picture.png',
                                  package: "assets",
                                ),
                          fit: BoxFit.cover,
                        )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      height: 90,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                entry.product.name,
                                style: TextStyle(fontSize: 15),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  '货号：' + entry.product.skuID,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromRGBO(150, 150, 150, 1)),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                '生产订单号：${order.code}',
                                style: TextStyle(
                                  color: Color.fromRGBO(150, 150, 150, 1),
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                '报价时间：${DateFormatUtil.format(order.creationTime)}',
                                style: TextStyle(
                                  color: Color.fromRGBO(150, 150, 150, 1),
                                  fontSize: 14,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }
}
