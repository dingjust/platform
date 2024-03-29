import 'dart:async';

import 'package:b2b_commerce/src/business/orders/sale/sale_order_detail_page.dart';
import 'package:b2b_commerce/src/my/my_addresses.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alipay/flutter_alipay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluwx/fluwx.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:toast/toast.dart';
import 'package:widgets/widgets.dart';

class OrderPaymentPage extends StatefulWidget {
  OrderModel order;

  PaymentFor paymentFor;

  bool isFormDetail;

  OrderPaymentPage(
      {Key key,
      this.order,
      this.paymentFor = PaymentFor.DEFAULT,
      this.isFormDetail = false})
      : super(key: key);

  @override
  _OrderPaymentPageState createState() => _OrderPaymentPageState();
}

class _OrderPaymentPageState extends State<OrderPaymentPage> {
  StreamSubscription wechatSubscription;

  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => initCheck());
    //监听微信回调
    wechatSubscription = weChatResponseEventHandler.listen((data) async {
      print('========Fluwx response ${widget.hashCode}');
      if (data.errCode == 0) {
        Future.delayed(const Duration(seconds: 1), () {
          afterPaid();
        });
      } else if (data.errCode == -1) {
        onPaymentError();
      } else {
        Navigator.of(context).pop();
      }
    });
    super.initState();
  }

  String paymentWay = "wechat";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            centerTitle: true,
            elevation: 0.5,
            title: Text(
              '选择支付方式',
              style: TextStyle(color: Colors.black),
            ),
          ),
          bottomSheet: _bubildPaySheet(),
          body: Container(
            color: Color.fromRGBO(245, 245, 245, 1),
            child: ListView(
              children: <Widget>[
                _buildDeliveryAddress(),
                _buildCompanyInfo(),
                _buildEntries(),
                _buildOrderInfo(),
                _buildPaymentWay(),
                //占位，勿删
                Container(
                  height: 80,
                )
              ],
            ),
          )),
    );
  }

  //构建收货信息UI
  Widget _buildDeliveryAddress() {
    return GestureDetector(
      onTap: () {
        selectDeliveryAddress();
      },
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: Text(
                    '收货地址',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              ],
            ),
            widget.order.deliveryAddress != null
                ? ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: Colors.black,
                    ),
                    title: Row(
                      children: <Widget>[
                        widget.order.deliveryAddress == null ||
                                widget.order.deliveryAddress.fullname == null
                            ? Container()
                            : Text(widget.order.deliveryAddress.fullname),
                        widget.order.deliveryAddress == null ||
                                widget.order.deliveryAddress.cellphone == null
                            ? Container()
                            : Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(
                                    widget.order.deliveryAddress.cellphone),
                              )
                      ],
                    ),
                    subtitle: widget.order.deliveryAddress == null ||
                            widget.order.deliveryAddress.region == null ||
                            widget.order.deliveryAddress.city == null ||
                            widget.order.deliveryAddress.cityDistrict == null ||
                            widget.order.deliveryAddress.line1 == null
                        ? Container()
                        : Text(
                            widget.order.deliveryAddress.region.name +
                                widget.order.deliveryAddress.city.name +
                                widget.order.deliveryAddress.cityDistrict.name +
                                widget.order.deliveryAddress.line1,
                            style: TextStyle(
                              color: Colors.black,
                            )),
                    trailing: Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                  )
                : Container(
                    height: 100,
                    child: Center(
                        child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 0.5, color: Colors.grey[300])),
                      child: Text('点击选择收货地址',
                          style: TextStyle(color: Colors.red, fontSize: 20)),
                    )),
                  ),
            SizedBox(
              child: Image.asset(
                'temp/common/address_under_line.png',
                package: 'assets',
                fit: BoxFit.fitWidth,
              ),
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

  Widget _buildCompanyInfo() {
    String companyName;

    ///按订单类型取字段
    if (widget.order is ProofingModel) {
      companyName = (widget.order as ProofingModel).belongTo.name;
    } else if (widget.order is PurchaseOrderModel) {
      companyName = (widget.order as PurchaseOrderModel).belongTo.name;
    } else if (widget.order is SalesOrderModel) {
      companyName = (widget.order as SalesOrderModel).seller.name;
    } else {
      return Container(
        color: Colors.white,
        child: Center(
          child: Text('暂无公司信息'),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
      color: Colors.white,
      child: Row(
        children: <Widget>[Text('${companyName}')],
      ),
    );
  }

  Widget _buildEntries() {
    var model;
    var product;

    if (widget.order is ProofingModel) {
      model = widget.order as ProofingModel;
      product = model.entries[0].product;
    } else if (widget.order is PurchaseOrderModel) {
      model = widget.order as PurchaseOrderModel;
      product = model.entries[0].product;
    } else if (widget.order is SalesOrderModel) {
      model = widget.order as SalesOrderModel;
      product = model.entries[0].product.baseProductDetail;
    } else {
      return Container(
        child: Center(
          child: Text('暂无产品信息'),
        ),
      );
    }

    //计算总数
    int sum = 0;
    model.entries.forEach((entry) {
      sum = sum + entry.quantity;
    });

    return Container(
      color: Color.fromRGBO(250, 250, 250, 1),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        children: <Widget>[
          product?.thumbnail != null
              ? Container(
            width: 80,
            height: 80,
            child: CachedNetworkImage(
                width: 100,
                height: 100,
                imageUrl: '${product.thumbnail.previewUrl()}',
                fit: BoxFit.cover,
                imageBuilder: (context, imageProvider) =>
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                placeholder: (context, url) =>
                    SpinKitRing(
                      color: Colors.black12,
                      lineWidth: 2,
                      size: 100,
                    ),
                errorWidget: (context, url, error) =>
                    SpinKitRing(
                      color: Colors.black12,
                      lineWidth: 2,
                      size: 100,
                    )),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
          )
              : Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color.fromRGBO(243, 243, 243, 1)),
            child: Icon(B2BIcons.noPicture,
                color: Color.fromRGBO(200, 200, 200, 1), size: 60),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '${product.name}',
                          style: TextStyle(fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      '货号：${product.skuID}',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 243, 243, 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "${product.category.name}   ${sum}件",
                      style: TextStyle(
                          fontSize: 15,
                          color: Color.fromRGBO(255, 133, 148, 1)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOrderInfo() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(
                      '订单号：${widget.order.code}',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              )),
          _buildInfoRow(
            '单价x数量',
            '￥${widget.order.unitPrice}x${widget.order.totalQuantity ??
                (widget.order as SalesOrderModel).quality}',
          ),
          _buildInfoRow(
            '合计总价',
            '￥${(widget.order.totalPrice ?? 0).toStringAsFixed(2)}',
          ),
          _buildDeposit(),
          _buildOtherDeduction(),
          _buildActualPay(),
          Offstage(
            offstage: widget.paymentFor != PaymentFor.DEPOSIT,
            child: Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Text(
                    '买大货需要支付30%的订金',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPaymentWay() {
    return Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            RadioListTile(
              activeColor: Colors.blue,
              title: Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '微信支付',
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(
                      B2BIcons.wechat,
                      size: 60,
                      color: Color.fromRGBO(0, 211, 12, 1),
                    ),
                  ],
                ),
              ),
              groupValue: paymentWay,
              value: "wechat",
              onChanged: (value) {
                setState(() {
                  paymentWay = value;
                });
              },
            ),
            RadioListTile(
              activeColor: Colors.blue,
              title: Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '支付宝',
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(
                      B2BIcons.aliPay,
                      size: 60,
                      color: Color.fromRGBO(0, 160, 232, 1),
                    ),
                  ],
                ),
              ),
              groupValue: paymentWay,
              value: "ali",
              onChanged: (value) {
                setState(() {
                  paymentWay = value;
                });
              },
            )
          ],
        ));
  }

  Widget _bubildPaySheet() {
    return Container(
      height: 60,
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '支付金额',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            '￥${getPayAmount().toStringAsFixed(2)}',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
          Container(
            height: double.infinity,
            width: 120,
            child: FlatButton(
              color: Color.fromRGBO(255, 214, 12, 1),
              onPressed: validate,
              disabledColor: Colors.grey[300],
              child: Text(
                '支付',
                style: TextStyle(fontSize: 18),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String val) {
    return Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '$label',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            Expanded(
              flex: 1,
              child: Text(
                '$val',
                style: TextStyle(color: Colors.grey, fontSize: 16),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
              ),
            )
          ],
        ));
  }

  Widget _buildDeposit() {
    if (widget.order is PurchaseOrderModel) {
      PurchaseOrderModel model = widget.order as PurchaseOrderModel;
      return _buildInfoRow(
          '订金(总额x30%)', '￥${model.deposit.toStringAsFixed(2)}');
    } else {
      return Container();
    }
  }

  Widget _buildOtherDeduction() {
    if (widget.order is PurchaseOrderModel &&
        (widget.order as PurchaseOrderModel).status ==
            PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE) {
      return Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('其他扣款'),
            Text(
              _getDeductionAmountText(
                  (widget.order as PurchaseOrderModel).deductionAmount),
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildActualPay() {
    return Container(
//      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '实付金额',
                style: TextStyle(fontSize: 16),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '￥${getPayAmount().toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void validate() {
    if (widget.order.deliveryAddress == null) {
      Toast.show("请选择收货地址", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    } else {
      onPay();
    }
  }

  void onPay() async {
    //先查询订单支付状态
    String orderPaymentStatus = await checkOrder(paymentWay);

    PaymentStatus paymentStatus = PaymentStatusMap[orderPaymentStatus];

    if (paymentStatus == PaymentStatus.ORDER_PAY_NOT) {
      print('1');
      mappingPayWay();
    } else if (paymentStatus == PaymentStatus.ORDER_PAY_SUCCESS) {
      print('2');
      onPaymentSucess();
    } else if (paymentStatus == PaymentStatus.ORDER_PAY_FAIL) {
      print('3');
      mappingPayWay();
    } else if (paymentStatus == PaymentStatus.ORDER_PAYING) {
      //TODO :
      print('4');
      onPaymentPaying();
    } else if (paymentStatus == PaymentStatus.ORDER_INTERFACE_FAIL) {
      print('5');
      onPaymentError();
    } else {
      print('6');
      mappingPayWay();
    }
  }

  void mappingPayWay() {
    switch (paymentWay) {
      case 'wechat':
        wechatPay();
        break;
      case 'ali':
        aliPay();
        break;
      default:
        wechatPay();
    }
  }

  void wechatPay() async {
    //检查是否安装微信
    bool result = await WechatServiceImpl.instance.isInstalled();
    if (result) {
      showDialog(
          context: context,
          barrierDismissible: true,
          child: Center(
            child: CircularProgressIndicator(),
          ));
      WechatServiceImpl.instance
          .pay(widget.order.code, paymentFor: widget.paymentFor)
          .then((result) {
        if (result == null) {
          Navigator.of(context).pop();
          onPaymentError();
        }
      });
    } else {
      showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (context) {
          return AlertDialog(
            title: Text('请安装微信APP'),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  '确定',
                  style: TextStyle(color: Colors.grey),
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

  void aliPay() async {
    AlipayResult aliResponse = await AlipayServiceImpl.instance
        .pay(widget.order.code, paymentFor: widget.paymentFor);
    //支付成功
    if (aliResponse.resultStatus != null &&
        aliResponse.resultStatus == '9000') {
      afterPaid();
    } else {
      print('no result==============');
      onPaymentError();
    }
  }

  void onPaymentError() {
    //错误
    Navigator.of(context).pop();
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('支付失败', style: TextStyle(fontSize: 16)),
          content: Text('将返回支付页面', style: TextStyle(fontSize: 16)),
          actions: <Widget>[
            FlatButton(
              child: Text('重新支付', style: TextStyle(fontSize: 16)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void onPaymentPaying() {
    //错误
    Navigator.of(context).pop();
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('支付处理中，请稍后重试', style: TextStyle(fontSize: 16)),
          actions: <Widget>[
            FlatButton(
              child: Text('返回', style: TextStyle(fontSize: 16)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void onPaymentSucess() {
    // Navigator.of(context).pop();
    //成功
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('支付成功', style: TextStyle(fontSize: 16)),
          actions: <Widget>[
            FlatButton(
              child: Text('确定', style: TextStyle(fontSize: 16)),
              onPressed: () async {
                if (widget.order is SalesOrderModel) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) =>
                              SaleOrderDetailPage(code: widget.order.code)),
                      ModalRoute.withName('/'));
                }
              },
            ),
          ],
        );
      },
    );
  }

  void initCheck() {
    // checkOrder();
    // checkDeliveryAddress();
  }

  //查询订单支付状态
  Future<String> checkOrder(String type) async {
    String confirmResult;
    try {
      //先调用确认支付接口查看是否支付过
      confirmResult = await OrderPaymentServiceImpl()
          .paymentConfirm(widget.order, type, paymentFor: widget.paymentFor);
    } catch (e) {
      print(e);
    }
    if (confirmResult != null) {
      return confirmResult;
    } else {
      return null;
    }
  }

  void selectDeliveryAddress() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              MyAddressesPage(
                isJumpSource: true,
                title: '选择地址',
              )),
      //接收返回数据并处理
    ).then((value) async {
      if (value != null) {
        setState(() {
          widget.order.deliveryAddress = value;
        });

        bool result = false;
        if (widget.order is ProofingModel) {
          //更新打样单地址
          result = await ProofingOrderRepository()
              .updateAddress(widget.order.code, widget.order);
        } else if (widget.order is PurchaseOrderModel) {
          // 采购单地址
          result = await PurchaseOrderRepository()
              .updateAddress(widget.order.code, widget.order);
        } else if (widget.order is SalesOrderModel) {
          result = await SalesOrderRespository()
              .updateAddress(widget.order.code, widget.order);
        }
        if (result) {
          BotToast.showText(text: '修改收货地址成功');
        } else {
          BotToast.showText(text: '修改收货地址失败');
        }
      }
    });
  }

  double getPayAmount() {
    double result = 0;
    switch (widget.paymentFor) {
      case PaymentFor.DEFAULT:
        result = widget.order.totalPrice;
        break;
      case PaymentFor.DEPOSIT:
        PurchaseOrderModel model = widget.order as PurchaseOrderModel;
        result = model.deposit;
        break;
      case PaymentFor.BALANCE:
        PurchaseOrderModel model = widget.order as PurchaseOrderModel;
        result = (model.balance ?? 0) + (model.deductionAmount ?? 0);
        break;
      case PaymentFor.SALES:
        result = widget.order.totalPrice;
        break;
      default:
        break;
    }
    return result;
  }

  //支付后确认订单操作，延时1秒
  void afterPaid() async {
    print('========After ${widget.hashCode}     ${this.hashCode}');

    String orderPaymentStatus = await checkOrder(paymentWay);

    PaymentStatus paymentStatus = PaymentStatusMap[orderPaymentStatus];

    if (paymentStatus == PaymentStatus.ORDER_PAY_NOT) {
      onPaymentPaying();
    } else if (paymentStatus == PaymentStatus.ORDER_PAY_SUCCESS) {
      onPaymentSucess();
    } else if (paymentStatus == PaymentStatus.ORDER_PAY_FAIL) {
      mappingPayWay();
    } else if (paymentStatus == PaymentStatus.ORDER_PAYING) {
      onPaymentPaying();
    } else {
      onPaymentError();
    }
  }

  @override
  void dispose() {
    wechatSubscription.cancel();
    super.dispose();
  }

  _getDeductionAmountText(double amount) {
    String text = '';
    if (amount != null) {
      if (amount < 0) {
        text += '-￥';
        amount = -amount;
      }
      text += amount.toString();
    }

    return text;
  }
}
