import 'package:b2b_commerce/src/business/orders/sale/components/input_row.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

///销售订单发货表单
class DeliveryFormPage extends StatefulWidget {
  @override
  _DeliveryFormPageState createState() => _DeliveryFormPageState();
}

class _DeliveryFormPageState extends State<DeliveryFormPage> {
  bool _showReciverInfo = true;

  TextEditingController _logisticsController = TextEditingController();
  FocusNode _logisticsNode = FocusNode();
  TextEditingController _orderCodeController = TextEditingController();
  FocusNode _orderCodeNode = FocusNode();
  bool _isOffline = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: true,
        elevation: 0.5,
        title: Text(
          '发货',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[_buildReceiverInfo(), _buildDelivererForm()],
        ),
      ),
      bottomNavigationBar: _buildBottomSheet(),
    );
  }

  ///收货人信息
  Widget _buildReceiverInfo() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '收货人信息',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showReciverInfo = !_showReciverInfo;
                  });
                },
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        '萨达',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Icon(
                        _showReciverInfo
                            ? B2BIcons.arrowOpen
                            : B2BIcons.arrowClose,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          _showReciverInfo
              ? Column(
                  children: <Widget>[
                    SaleOrderInputRow(
                      label: '收件人',
                      child: TextField(
                        enabled: false,
                        controller: TextEditingController(text: '阿达'),
                        style: TextStyle(color: Colors.grey),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '输入',
                            hintStyle: TextStyle(color: Colors.grey),
                            enabled: false),
                      ),
                    ),
                    SaleOrderInputRow(
                      label: '联系方式',
                      child: TextField(
                        enabled: false,
                        controller: TextEditingController(text: '13321321232'),
                        style: TextStyle(color: Colors.grey),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '输入',
                            hintStyle: TextStyle(color: Colors.grey),
                            enabled: false),
                      ),
                    ),
                    SaleOrderInputRow(
                      label: '收货地址',
                      child: TextField(
                        enabled: false,
                        controller:
                            TextEditingController(text: '广州市天河区啊就送i的骄傲四季度'),
                        style: TextStyle(color: Colors.grey),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '输入',
                            hintStyle: TextStyle(color: Colors.grey),
                            enabled: false),
                      ),
                    ),
                  ],
                )
              : Container()
        ],
      ),
    );
  }

  ///收货人信息
  Widget _buildDelivererForm() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '发货信息',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              SaleOrderInputRow(
                label: '物流公司',
                child: TextField(
                  controller: _logisticsController,
                  focusNode: _logisticsNode,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '请填写',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              SaleOrderInputRow(
                label: '物流单号',
                child: TextField(
                  controller: _orderCodeController,
                  focusNode: _orderCodeNode,
                  style: TextStyle(color: Colors.grey),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '请填写',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '是否线下发货',
                      style: TextStyle(fontSize: 18),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Text(
                            _isOffline ? '是' : '否',
                            style: TextStyle(fontSize: 18),
                          ),
                          Switch(
                              value: _isOffline,
                              onChanged: (val) {
                                setState(() {
                                  _isOffline = !_isOffline;
                                });
                              })
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: <Widget>[
                    Text(
                      '选择线下发货可不填快递公司和单号',
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  ///底部
  Widget _buildBottomSheet() {
    return Container(
        height: 50,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                height: double.infinity,
                child: FlatButton(
                    color: Constants.THEME_COLOR_MAIN,
                    onPressed: () {},
                    child: Text(
                      '确定',
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            )
          ],
        ));
  }
}
