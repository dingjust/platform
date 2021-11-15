import 'package:b2b_commerce/src/_shared/widgets/info/info_widgets.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class OrderPaymentInfo extends StatelessWidget {
  final SalesProductionOrderModel order;

  const OrderPaymentInfo({Key, key, this.order}) : super(key: key);

  final TextStyle infoTextStyle =
      const TextStyle(color: Color(0xFF999999), fontSize: 12);

  final TextStyle valTextStyle =
      const TextStyle(color: Color(0xFFAA6E15), fontSize: 12);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 14),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            InfoRow(
              label: '支付方式',
              val: payOnline ? '线上支付' : '线下支付',
              textAlign: TextAlign.right,
            ),
            InfoDivider(
              height: 16,
            ),
            ...payOnline ? _buildOnlineRows() : []
          ],
        ));
  }

  ///线上支付信息
  List<Widget> _buildOnlineRows() {
    //付款方不显示收款人信息
    if (order.paymentAccount == null ||
        UserBLoC.instance.currentUser.companyCode ==
            order?.originCompany?.uid) {
      return [...buildPayRows()];
    }

    return [
      InfoRow(
        label: '收款人姓名',
        val: '${order.paymentAccount?.name ?? ''}',
        textAlign: TextAlign.right,
      ),
      InfoDivider(
        height: 16,
      ),
      InfoRow(
        label: '收款开户行',
        val: '${order.paymentAccount?.serviceProvider ?? ''}',
        textAlign: TextAlign.right,
      ),
      InfoDivider(
        height: 16,
      ),
      InfoRow(
        label: '收款卡号',
        val: '${order.paymentAccount?.no ?? ''}',
        textAlign: TextAlign.right,
      ),
      InfoDivider(
        height: 16,
      ),
      buildServiceFree(),
      ...buildPayRows()
    ];
  }

  ///代运营服务费用
  Widget buildServiceFree() {
    if (order.agentOrder) {
      return InfoRow(
        label: '代运营服务费用比例',
        val:
            '${order.paymentAccount?.no ?? ''}${(order.serviceFeePercent * 100).toStringAsFixed(2)}%',
        textAlign: TextAlign.right,
      );
    }
    return Container();
  }

  Widget buildRow(String title, String val,
      {TextStyle valStryle = const TextStyle()}) {
    if (val == null || val == '') {
      return Container();
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.grey[300], width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$title'),
          Expanded(
              child: Text(
            '$val',
            style: valStryle,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
          ))
        ],
      ),
    );
  }

  List<Widget> buildPayRows() {
    List<Widget> widgets = [];
    if (order.paymentOrders != null) {
      for (int i = 0; i < order.paymentOrders.length; i++) {
        widgets.addAll(buildPayRow(order.paymentOrders[i]));
        if (i != order.paymentOrders.length - 1) {
          widgets.add(InfoDivider(height: 16));
        }
      }
    }
    return widgets;
  }

  List<Widget> buildPayRow(CmtPayOrderData data) {
    String label = '';
    TextStyle style = TextStyle(fontSize: 14, color: Color(0xFF222222));
    if (data.state == CmtPaymentState.PAID) {
      label = '已付';
    } else {
      label = '待付';
      style = TextStyle(fontSize: 14, color: Color(0xFFFF4D4F));
    }
    if (data.batch == 1 && (order?.payPlan?.isHaveDeposit ?? false)) {
      label = label + '定金';
    } else {
      label = label + '尾款';
    }

    return [
      InfoRow(
        label: label,
        val: '￥${data.totalAmount}',
        textAlign: TextAlign.right,
        style: style,
      ),
      data.state == CmtPaymentState.PAID
          ? Container(
        padding: EdgeInsets.all(6),
        color: Color(0xFFFFFBED),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '支付方式',
                    style: infoTextStyle,
                  ),
                  Text(
                    '${PaymentMethodLocalizedMap[data.payType]}',
                    style: valTextStyle,
                  )
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '交易编号',
                    style: infoTextStyle,
                  ),
                  Text(
                    '${data.outOrderNo}',
                    style: valTextStyle,
                  )
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '支付时间',
                    style: infoTextStyle,
                  ),
                  Text(
                    '${DateFormatUtil.formatYMDHMS(data.paySuccessTime)}',
                    style: valTextStyle,
                  )
                ],
              ),
            ),
          ],
        ),
      )
          : Container(),
    ];
  }

  bool get payOnline {
    if (order.payOnline != null && order.payOnline) {
      return true;
    }
    return false;
  }
}
