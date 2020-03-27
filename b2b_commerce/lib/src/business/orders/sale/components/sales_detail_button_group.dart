import 'package:b2b_commerce/src/business/orders/sale/form/delivery_form_page.dart';
import 'package:b2b_commerce/src/business/orders/sale/form/return_form_page.dart';
import 'package:b2b_commerce/src/common/order_payment.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets/widgets.dart';

import '../return_page.dart';

///销售订单底部按钮
class SalesDetailButtonGroup extends StatelessWidget {
  final double height;

  final SalesOrderModel model;

  final VoidCallback callback;

  const SalesDetailButtonGroup(
      {Key key, this.height = 55, this.model, this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(width: 2, color: Colors.grey[100])),
      ),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: buildButtons(context)),
    );
  }

  List<Widget> buildButtons(BuildContext context) {
    //根据买卖方显示按钮
    UserType userType = BLoCProvider.of<UserBLoC>(context).currentUser.type;

    List<Widget> buttons = [buildTelButton(context)];

    //工厂按钮
    if (userType == UserType.FACTORY) {
      //TODO退款状态判断
      if (model.refunding != null && model.refunding) {
        buttons.add(buildSpaceBtn());
        buttons
            .add(buildBtn2(context, () => onRefundDetail(context), '查看退货详情'));
        return buttons;
      }

      switch (model.status) {
        case SalesOrderStatus.PENDING_DELIVERY:
          buttons.add(buildSpaceBtn());
          buttons.add(buildBtn2(context, () => onDelivery(context), '发货'));
          break;
        default:
      }
    }

    ///买方按钮
    else {
      //TODO退款状态判断
      if (model.refunding != null && model.refunding) {
        buttons.add(buildSpaceBtn());
        if (model.refundStatus == SalesOrderRefundStatus.PENDING_CONFIRM) {
          buttons
              .add(buildBtn2(context, () => onCancelRefund(context), '撤销退货'));
        } else if (model.refundStatus == SalesOrderRefundStatus.IN_REFUND) {
          buttons
              .add(buildBtn2(context, () => onRefundDetail(context), '查看退货详情'));
        }
        return buttons;
      }

      switch (model.status) {
        case SalesOrderStatus.PENDING_PAYMENT:
          buttons.add(buildBtn1(context, () => onClose(context), '取消订单'));
          buttons.add(buildBtn2(context, () => onPay(context), '支付'));
          break;
        case SalesOrderStatus.PENDING_DELIVERY:
          buttons.add(buildBtn1(context, () => onRefund(context), '退货'));
          buttons.add(buildRemindBtn(context));
          break;
        case SalesOrderStatus.PENDING_CONFIRM:
          buttons.add(buildBtn1(context, () => onRefund(context), '退货'));
          buttons.add(buildBtn2(context, () => onConfirm(context), '确认收货'));
          break;
        default:
      }
    }

    return buttons;
  }

  Widget buildTelButton(BuildContext context) {
    //根据买卖方
    UserType userType = BLoCProvider.of<UserBLoC>(context).currentUser.type;

    return Expanded(
      flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () async {
              var url = 'tel:';
              if (userType != UserType.FACTORY) {
                url += model.seller.contactPhone;
              } else {
                url += model.user.contactPhone;
              }

              await launch(url);
            },
            child: Container(
              height: height,
              padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
              child: Icon(
                Icons.phone,
                color: Colors.green,
              ),
            ),
          )
        ],
      ),
    );
  }

  ///样式1按钮
  Widget buildBtn1(BuildContext context, VoidCallback onPressed, String text) {
    return Expanded(
        flex: 1,
        child: Container(
          height: double.infinity,
          child: FlatButton(
              shape: RoundedRectangleBorder(),
              disabledColor: Colors.grey,
              onPressed: onPressed,
              child: Text('$text',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                  ))),
        ));
  }

  ///样式2按钮
  Widget buildBtn2(BuildContext context, VoidCallback onPressed, String text) {
    return Expanded(
        flex: 1,
        child: Container(
          height: double.infinity,
          child: FlatButton(
              color: Color.fromRGBO(255, 212, 74, 1),
              shape: RoundedRectangleBorder(),
              onPressed: onPressed,
              child: Text('$text',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ))),
        ));
  }

  ///空按钮（占位）
  Widget buildSpaceBtn() {
    return Expanded(flex: 1, child: Container());
  }

  ///提醒发货按钮
  Widget buildRemindBtn(BuildContext context) {
    //判定是否可以再次点击
    if (this.model.nextReminderDeliveryTime == null) {
      return buildEnableRemindBtn(context);
    }

    if (DateTime.now().isAfter(model.nextReminderDeliveryTime)) {
      return buildEnableRemindBtn(context);
    } else {
      return buildDisableRemindBtn(context);
    }
  }

  ///可用提醒按钮
  Widget buildEnableRemindBtn(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Container(
          height: double.infinity,
          child: FlatButton(
              color: Color.fromRGBO(255, 212, 74, 1),
              shape: RoundedRectangleBorder(),
              onPressed: () {
                remind();
              },
              child: Text('提醒发货',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ))),
        ));
  }

  ///禁用提醒按钮
  Widget buildDisableRemindBtn(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Container(
          height: double.infinity,
          child: FlatButton(
              color: Colors.grey[300],
              shape: RoundedRectangleBorder(),
              onPressed: () {
                BotToast.showText(text: '一天只能提醒一次');
              },
              child: Text('提醒发货',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ))),
        ));
  }

  ///关闭订单
  void onClose(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.CONFIRM_DIALOG,
            dialogHeight: 210,
            contentText2: '是否取消订单？',
            isNeedConfirmButton: true,
            isNeedCancelButton: true,
            confirmAction: () {
              Navigator.of(context).pop();
              cancel(context);
            },
          );
        });
  }

  ///支付
  void onPay(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => OrderPaymentPage(
                  order: model,
                  paymentFor: PaymentFor.SALES,
                )))
        .then((val) {
      if (val) {
        //成功回调刷新
        callback();
      }
    });
  }

  ///退货
  void onRefund(BuildContext context) {
    Navigator.of(context)
        .push(
            MaterialPageRoute(builder: (context) => ReturnFormPage(model.code)))
        .then((val) {
      if (val) {
        //成功回调刷新
        callback();
      }
    });
  }

  ///发货
  void onDelivery(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => DeliveryFormPage(
                  model.code,
                  order: model,
                )))
        .then((val) {
      if (val ?? false) {
        //成功回调刷新
        callback();
      }
    });
  }

  ///确认收货
  void onConfirm(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.CONFIRM_DIALOG,
            dialogHeight: 210,
            contentText2: '是否确认收货？',
            isNeedConfirmButton: true,
            isNeedCancelButton: true,
            confirmAction: () {
              Navigator.of(context).pop();
              confirm(context);
            },
          );
        });
  }

  ///提醒发货
  void onRemind() {}

  ///查看物流
  void onLogisticDetail() {}

  ///撤销申请
  void onCancelRefund(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.CONFIRM_DIALOG,
            dialogHeight: 210,
            contentText2: '是否撤销退货申请？',
            isNeedConfirmButton: true,
            isNeedCancelButton: true,
            confirmAction: () {
              Navigator.of(context).pop();
              cancelRefund(context);
            },
          );
        });
  }

  ///查看退货详情
  void onRefundDetail(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ReturnPage(model)))
        .then((val) {
      if (val ?? false) {
        //成功回调刷新
        callback();
      }
    });
  }

  void confirm(BuildContext context) async {
    BaseMsg msg = await SalesOrderRespository().confirmReceived(model.code);
    if (msg != null && msg.resultCode == 0) {
      callback();
    } else {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              failTips: '确认失败',
              callbackResult: false,
              confirmAction: () {
                Navigator.of(context).pop();
              },
            );
          });
    }
  }

  void cancel(BuildContext context) async {
    BaseMsg msg = await SalesOrderRespository().cancel(model.code);
    if (msg != null && msg.resultCode == 0) {
      callback();
    } else {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              failTips: '取消失败',
              callbackResult: false,
              confirmAction: () {
                Navigator.of(context).pop();
              },
            );
          });
    }
  }

  void cancelRefund(BuildContext context) async {
    BaseMsg msg = await SalesOrderRespository().refundCancel(model.code);
    if (msg != null && msg.resultCode == 0) {
      callback();
    } else {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              failTips: '撤销失败',
              callbackResult: false,
              confirmAction: () {
                Navigator.of(context).pop();
              },
            );
          });
    }
  }

  void remind() async {
    BaseMsg msg = await SalesOrderRespository().remind(model.code);
    if (msg != null && msg.resultCode == 0) {
      callback();
    }
  }
}
