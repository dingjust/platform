import 'package:b2b_commerce/src/business/orders/proofing_order_detail.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class OrderPaymentPage extends StatefulWidget {
  final OrderModel order;

  const OrderPaymentPage({Key key, this.order}) : super(key: key);

  @override
  _OrderPaymentPageState createState() => _OrderPaymentPageState();
}

class _OrderPaymentPageState extends State<OrderPaymentPage> {
  void initState() {
    //监听微信回调
    fluwx.responseFromPayment.listen((WeChatPaymentResponse data) async {
      if (data.errCode == 0) {
        //成功，调用确认支付接口
        String confirmResult =
            await WechatServiceImpl.instance.paymentConfirm(widget.order);

        if (confirmResult == null) {
          onPaymentError();
        } else {
          onPaymentSucess();
        }
      } else if (data.errCode == -1) {
        onPaymentError();
      } else {
        // onPaymentError();
        Navigator.of(context).pop();
      }
      print("==================${data.errCode}");
    });
    super.initState();
  }

  String paymentWay = "wechat";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          centerTitle: true,
          elevation: 0.5,
          title: Text(
            '确认订单内容',
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
        ));
  }

  //构建收货信息UI
  Widget _buildDeliveryAddress() {
    return Container(
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
          ListTile(
            leading: Icon(
              B2BIcons.location,
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
                        child: Text(widget.order.deliveryAddress.cellphone),
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
    );
  }

  Widget _buildCompanyInfo() {
    var model;

    if (widget.order is ProofingModel) {
      model = widget.order as ProofingModel;
    } else if (widget.order is PurchaseOrderModel) {
      model = widget.order as PurchaseOrderModel;
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
        children: <Widget>[Text('${model.belongTo.name}')],
      ),
    );
  }

  Widget _buildEntries() {
    var model;

    if (widget.order is ProofingModel) {
      model = widget.order as ProofingModel;
    } else if (widget.order is PurchaseOrderModel) {
      model = widget.order as PurchaseOrderModel;
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
          model.product?.thumbnail != null
              ? Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        image: NetworkImage(
                            '${GlobalConfigs.IMAGE_BASIC_URL}${model.product.thumbnail.url}'),
                        fit: BoxFit.cover,
                      )),
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
                  Text(
                    model.entries[0].product.name,
                    style: TextStyle(fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      '货号：${model.entries[0].product.skuID}',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 243, 243, 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "${model.entries[0].product.name}   ${model.entries[0].product.category.name}   ${sum}件",
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
            child: Text(
              '生产订单号：${widget.order.code}',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
          Text(
            '订单生产时间：${DateFormatUtil.format(widget.order.creationTime)}',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          )
        ],
      ),
    );
  }

  Widget _buildPaymentWay() {
    return Container(
        margin: EdgeInsets.only(top: 100),
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
                    Text('微信支付'),
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
                paymentWay = value;
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
            '￥${widget.order.totalPrice}',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
          Container(
            height: double.infinity,
            width: 120,
            child: FlatButton(
              color: Color.fromRGBO(255, 214, 12, 1),
              onPressed: onPay,
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

  void onPay() async {
    //检查是否安装微信
    bool result = await WechatServiceImpl.instance.isWeChatInstalled();

    if (result) {
      showDialog(
          context: context,
          barrierDismissible: false,
          child: Center(
            child: CircularProgressIndicator(),
          ));
      WechatServiceImpl.instance.pay(widget.order.code);
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

  void onPaymentError() {
    //错误
    // Navigator.of(context).pop();
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

  void onPaymentSucess() {
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
                ///打样订单
                if (widget.order is ProofingModel) {
                  //查询明细
                  ProofingModel detailModel = await ProofingOrderRepository()
                      .proofingDetail(widget.order.code);

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => ProofingOrderDetailPage(
                                model: detailModel,
                              )),
                      ModalRoute.withName('/'));

                  ///TODO:生产单
                }
              },
            ),
          ],
        );
      },
    );
  }
}
