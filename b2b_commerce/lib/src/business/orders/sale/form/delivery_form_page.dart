import 'package:b2b_commerce/src/business/orders/sale/components/input_row.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

///销售订单发货表单
class DeliveryFormPage extends StatefulWidget {
  final String code;

  final SalesOrderModel order;

  const DeliveryFormPage(this.code, {Key key, this.order}) : super(key: key);

  @override
  _DeliveryFormPageState createState() => _DeliveryFormPageState();
}

class _DeliveryFormPageState extends State<DeliveryFormPage> {
  bool _showReciverInfo = true;

  TextEditingController _orderCodeController = TextEditingController();
  FocusNode _orderCodeNode = FocusNode();
  bool _isOffline = false;

  ///物流
  CarrierModel carrier;

  SalesOrderModel order;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SalesOrderModel>(
      builder: (BuildContext context, AsyncSnapshot<SalesOrderModel> snapshot) {
        if (snapshot.data != null) {
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
        } else {
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
      initialData: null,
      future: _getData(),
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
                        '${order.deliveryAddress.fullname}',
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
                        controller: TextEditingController(
                            text: '${order.deliveryAddress.fullname}'),
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
                        controller: TextEditingController(
                            text: '${order.deliveryAddress.cellphone}'),
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
                        controller: TextEditingController(
                            text: '${order.deliveryAddress.details}'),
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
                child: FutureBuilder<List<CarrierModel>>(
                    future: Provider.of<CarrierState>(context, listen: false)
                        .getCarriers(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<CarrierModel>> snapshot) {
                      if (snapshot.data != null) {
                        return PopupMenuButton<CarrierModel>(
                            onSelected: (val) {
                              setState(() {
                                carrier = val;
                              });
                            },
                            itemBuilder: (BuildContext context) => snapshot.data
                                .map((carrier) => PopupMenuItem<CarrierModel>(
                                      value: carrier,
                                      child: new Text(carrier.name),
                                    ))
                                .toList(),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    carrier != null
                                        ? '${carrier?.name ?? '选择物流公司'}'
                                        : '选择物流公司',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey,
                                )
                              ],
                            ));
                      } else {
                        return Container();
                      }
                    }),
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
                    onPressed: _onSubmit,
                    child: Text(
                      '确定',
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            )
          ],
        ));
  }

  ///发货`
  void _onSubmit() {
    if (!_isOffline) {
      if (_orderCodeController.text == '' || carrier == null) {
        BotToast.showText(text: '请填写物流单号并选择物流公司');
        return null;
      }
    }
    _submit();
  }

  void _submit() {
    SalesOrderRespository()
        .delivery(widget.code,
        carrierCode: carrier?.code ?? '',
        trackingID: _orderCodeController.text,
        offlineConsignment: _isOffline)
        .then((msg) {
      if (msg != null && msg.resultCode == 0) {
        Navigator.of(context).pop(true);
      } else {
        BotToast.showText(text: "发货失败");
      }
    });
  }

  /// 查询明细
  Future<SalesOrderModel> _getData() async {
    if (widget.order != null && widget.order.deliveryAddress != null) {
      order = order;
    }

    if (order == null && widget.code != null) {
      SalesOrderModel detailModel =
      await SalesOrderRespository().getSalesOrderDetail(widget.code);
      order = detailModel;
    }
    return order;
  }
}
