import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluwx/fluwx.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'qrcode_payment_page.dart';

///统一订单支付页面V2(2021年5月31日14:07:44)
class OrderPaymentPageV2 extends StatefulWidget {
  final CmtPayOrderData order;

  const OrderPaymentPageV2(this.order, {Key key}) : super(key: key);

  @override
  _OrderPaymentPageV2State createState() => _OrderPaymentPageV2State();
}

class _OrderPaymentPageV2State extends State<OrderPaymentPageV2> {
  String payWay;

  StreamSubscription wechatSubscription;

  @override
  void initState() {
    payWay = 'WECHAT_PAY_APP';
    //监听微信回调
    wechatSubscription = weChatResponseEventHandler.listen((data) async {
      print('[Fluwx]支付回调：${data.isSuccessful}');
      if (data.isSuccessful) {
        onPaymentSuccess();
      } else {
        onPaymentError();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              brightness: Brightness.light,
              centerTitle: true,
              elevation: 0.5,
              title: Text(
                '订单支付',
                style: TextStyle(color: Colors.black),
              ),
            ),
            bottomSheet: _bubildPaySheet(),
            body: Container(
              color: Color.fromRGBO(245, 245, 245, 1),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: <Widget>[
                  _buildAmountRow(),
                  _PayTypeSelect(
                    groupValue: payWay,
                    onChanged: (val) {
                      setState(() {
                        payWay = val;
                      });
                    },
                  ),
                  Container(
                    height: 80,
                  )
                ],
              ),
            )),
        onWillPop: null);
  }

  Widget _buildAmountRow() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '￥',
            style: TextStyle(color: Colors.red, fontSize: 20),
          ),
          Text(
            '${widget.order.payAmount?.toStringAsFixed(2)}',
            style: TextStyle(
                color: Colors.red, fontSize: 30, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget _bubildPaySheet() {
    return GestureDetector(
      onTap: validate,
      child: Container(
        height: 35,
        margin: EdgeInsets.fromLTRB(20, 0, 20, 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.orange[400],
                  Color(0xffffd60c),
                ])),
        child: Center(
          child: Text(
            '微信支付￥${widget.order.payAmount?.toStringAsFixed(2)}',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  void validate() {
    wechatPay();
  }

  ///微信支付
  void wechatPay() async {
    //检查是否安装微信
    bool result = await WechatServiceImpl.instance.isInstalled();
    if (result) {
      Function cancelFunc = BotToast.showLoading(
        crossPage: false,
        clickClose: true,
      );
      try {
        if (widget.order != null) {
          BaseResponse orderPayResponse =
              await OrderPaymentServiceImpl.orderPaySign(
                  widget.order.originCode, widget.order.batch,
                  method: payWay);
          if (orderPayResponse != null) {
            if (orderPayResponse.code == 1) {
              WechatPrepayModel prepayModel =
                  WechatPrepayModel.fromJson(orderPayResponse.data);
              if (payWay == 'WECHAT_PAY_APP') {
                //APP支付
                bool result =
                    await WechatServiceImpl.instance.payBySign(prepayModel);
                if (result) {
                  cancelFunc.call();
                }
              } else if (payWay == 'WECHAT_PAY_NATIVE') {
                // 二维码支付
                String qrcodeUrl = orderPayResponse.data['qrcodeUrl'];
                if (qrcodeUrl != null && qrcodeUrl != '') {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => QRCodePaymentPage(
                            url: qrcodeUrl,
                            order: widget.order.originCode,
                          )));
                }
                showErrorText(title: '支付失败', content: '获取二维码失败');
              }
            } else {
              showErrorText(title: '支付失败', content: '${orderPayResponse.msg}');
            }
          } else {
            showErrorText(title: '支付失败', content: '获取订单信息失败,请重新支付');
          }
        }
      } catch (e) {
        print(e);
        BotToast.showText(text: '未知错误');
      }
      cancelFunc.call();
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

  ///支付错误
  void onPaymentError() {
    BotToast.showCustomText(
      onlyOne: true,
      duration: null,
      wrapToastAnimation: (controller, cancel, child) => Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              cancel();
            },
            child: AnimatedBuilder(
              builder: (_, child) => Opacity(
                opacity: controller.value,
                child: child,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.black26),
                child: SizedBox.expand(),
              ),
              animation: controller,
            ),
          ),
          CustomOffsetAnimation(
            controller: controller,
            child: child,
          )
        ],
      ),
      toastBuilder: (cancelFunc) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        title: const Text('支付失败'),
        content: const Text('返回支付页面'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              cancelFunc();
              Navigator.of(context).pop();
            },
            child: const Text(
              '确定',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  ///支付成功
  void onPaymentSuccess() {
    BotToast.showCustomText(
      onlyOne: true,
      duration: null,
      wrapToastAnimation: (controller, cancel, child) => Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              cancel();
            },
            child: AnimatedBuilder(
              builder: (_, child) => Opacity(
                opacity: controller.value,
                child: child,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.black26),
                child: SizedBox.expand(),
              ),
              animation: controller,
            ),
          ),
          CustomOffsetAnimation(
            controller: controller,
            child: child,
          )
        ],
      ),
      toastBuilder: (cancelFunc) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        title: const Text('支付成功'),
        // content: const Text('返回支付页面'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              cancelFunc();
              //TODO:订单详情
              Navigator.of(context).pop(true);
            },
            child: const Text(
              '确定',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  ///错误信息
  void showErrorText({String title = '', String content = ''}) {
    BotToast.showCustomText(
      onlyOne: true,
      duration: null,
      wrapToastAnimation: (controller, cancel, child) => Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              cancel();
            },
            child: AnimatedBuilder(
              builder: (_, child) => Opacity(
                opacity: controller.value,
                child: child,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.black26),
                child: SizedBox.expand(),
              ),
              animation: controller,
            ),
          ),
          CustomOffsetAnimation(
            controller: controller,
            child: child,
          )
        ],
      ),
      toastBuilder: (cancelFunc) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        title: Text('$title'),
        content: Text('$content'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              cancelFunc();
            },
            child: const Text(
              '确定',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    wechatSubscription.cancel();
    super.dispose();
  }
}

///支付方式
class _PayTypeSelect extends StatelessWidget {
  final String groupValue;

  final ValueChanged<String> onChanged;

  const _PayTypeSelect({Key, key, this.groupValue, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Text('选择支付方式',
                    style: TextStyle(
                      color: Colors.grey,
                    )),
              ],
            ),
          ),
          _PayTypeSelectItem(
            label: '微信支付',
            val: 'WECHAT_PAY_APP',
            groupValue: groupValue,
            onChanged: onChanged,
          ),
          _PayTypeSelectItem(
            label: '微信二维码支付',
            val: 'WECHAT_PAY_NATIVE',
            groupValue: groupValue,
            onChanged: onChanged,
          )
        ],
      ),
    );
  }
}

class _PayTypeSelectItem extends StatelessWidget {
  final String label;

  final String val;

  final String groupValue;

  final Widget icon;

  final ValueChanged<String> onChanged;

  const _PayTypeSelectItem({Key key,
    this.label,
    this.val,
    this.groupValue,
    this.icon = const Icon(
      B2BIcons.wechat,
      size: 30,
      color: Color.fromRGBO(0, 211, 12, 1),
    ),
    this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: () {
              onChanged?.call(val);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      icon,
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          '$label',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
                Icon(
                  val == groupValue
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: Colors.orange,
                )
              ],
            ),
          ),
        ));
  }
}
