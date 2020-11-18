import 'package:b2b_commerce/src/business/orders/sales_production/out_order/form/form_btns.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:core/core.dart';

import 'order_accept_page.dart';

///底部按钮组
class OrderDetailBtnGroup extends StatelessWidget {
  final SalesProductionOrderModel order;

  final double height;

  ///详情页刷新回调
  final VoidCallback detailCallback;

  ///列表页刷新回调
  final VoidCallback listCallback;

  ///需要列表页刷新回调
  final VoidCallback needCallbackPop;

  const OrderDetailBtnGroup({Key key,
    this.order,
    this.height = 55,
    this.detailCallback,
    this.listCallback,
    this.needCallbackPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //接单方按钮
    // if (isTarget) { TODO:接单方判断修改
    if (!isOrigin) {
      if (order.state != SalesProductionOrderState.CANCELED) {
        //外接来源订单
        if (isSaleOrder &&
            (order.auditState == AuditState.NONE ||
                order.auditState == AuditState.AUDITED_FAILED) &&
            hasOrigin) {
          return _acceptBtns(context);
        }
      }
    } else if (isOrigin) {
      //来源方
      if (order.state == SalesProductionOrderState.TO_BE_SUBMITTED) {
        return FormBtns(
          form: order,
          validateFunc: () => true,
        );
      }
      return Container(
        height: 0,
      );
    }

    //空
    return Container(
      height: 0,
    );
  }

  ///接单按钮
  Widget _acceptBtns(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                height: height,
                child: FlatButton(
                    shape: RoundedRectangleBorder(),
                    disabledColor: Colors.grey,
                    onPressed: _onRefuse,
                    child: Text('拒单',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                        ))),
              )),
          Expanded(
              flex: 1,
              child: Container(
                height: height,
                child: FlatButton(
                    shape: RoundedRectangleBorder(),
                    disabledColor: Colors.grey,
                    onPressed: () => _onAccept(context),
                    color: Constants.THEME_COLOR_MAIN,
                    child: Text('接单',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ))),
              ))
        ],
      ),
    );
  }

  ///接单
  void _onAccept(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(
        builder: (context) => OrderAcceptPage(order: order)))
        .then((value) {
      //回调刷新
      if (value && detailCallback != null) {
        detailCallback.call();
        if (needCallbackPop != null) {
          needCallbackPop.call();
        }
      }
    });
  }

  ///拒绝
  void _onRefuse() {
    BotToast.showEnhancedWidget(
        onlyOne: true,
        duration: null,
        clickClose: true,
        backgroundColor: Colors.black38,
        allowClick: false,
        toastBuilder: (cancelFunc) => AlertDialog(
          content: Container(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                        child: Text(
                          '确认拒绝订单?',
                        ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FlatButton(onPressed: cancelFunc, child: Text('否')),
                    FlatButton(
                      onPressed: () {
                        cancelFunc.call();
                        _resuse();
                      },
                      child: Text('是'),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }

  ///拒单接口
  void _resuse() async {
    Function cancelFunc =
    BotToast.showLoading(crossPage: false, clickClose: false);
    BaseResponse response =
    await ExternalSaleOrderRespository().refuse(order.id);
    cancelFunc.call();
    if (response != null && response.code == 1) {
      BotToast.showText(text: '拒单成功');
      //订单取消返回列表页面刷新
      if (listCallback != null) {
        listCallback.call();
      }
    } else if (response != null && response.code == 0) {
      BotToast.showText(text: '${response.msg}');
    } else {
      BotToast.showText(text: '操作失败');
    }
  }

  ///是否审批人
  bool get isApprover {
    if (order.approvers == null || UserBLoC.instance.currentUser == null) {
      return false;
    }

    return order.approvers.any((element) =>
    element.id == UserBLoC.instance.currentUser.id ||
        element.uid == UserBLoC.instance.currentUser.uid);
  }

  ///来源方
  bool get isOrigin {
    if (order.originCompany != null) {
      return order?.originCompany?.uid ==
          UserBLoC.instance.currentUser.companyCode;
    }
    return false;
  }

  ///是否接单方
  bool get isTarget {
    if (order.targetCooperator != null) {
      return order?.targetCooperator?.partner?.uid ==
          UserBLoC.instance.currentUser.companyCode;
    }
    return false;
  }

  ///是否创建者
  bool get isCreator {
    if (order.creator != null || UserBLoC.instance.currentUser != null) {
      return order.creator.uid == UserBLoC.instance.currentUser.uid;
    } else {
      return false;
    }
  }

  ///是否销售订单（外接订单）
  bool get isSaleOrder => order?.type == ProductionOrderType.SALES_ORDER;

  ///来源
  bool get hasOrigin =>
      order?.originCompany != null && order?.originCompany?.uid != null;
}
