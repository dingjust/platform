import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:core/core.dart';

class OrderPaymentInfo extends StatelessWidget {
  final SalesProductionOrderModel order;

  const OrderPaymentInfo({Key, key, this.order}) : super(key: key);

  final TextStyle infoTextStyle = const TextStyle(color: Colors.grey);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '订单付款信息',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            buildRow('支付方式', payOnline ? '线上支付' : '线下支付'),
            ..._buildOnlineRows()
          ],
        ));
  }

  ///线上支付信息
  List<Widget> _buildOnlineRows() {
    if (order.paymentAccount == null) {
      return [];
    }

    return [
      buildRow('收款人姓名', '${order.paymentAccount.name}'),
      buildRow('收款开户行', '${order.paymentAccount.serviceProvider}'),
      buildRow('收款卡号', '${order.paymentAccount.no}'),
      ...buildPayRows()
    ];
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
          Text(
            '$val',
            style: valStryle,
          )
        ],
      ),
    );
  }

  List<Widget> buildPayRows() {
    List<Widget> widgets = [];
    order.paymentOrders.forEach((element) {
      widgets.addAll(buildPayRow(element));
    });
    return widgets;
  }

  List<Widget> buildPayRow(CmtPayOrderData data) {
    return [
      Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
                text: TextSpan(
                    text: data.batch == 1 ? '定金' : '尾款',
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                    children: [
                  TextSpan(
                      text: '(${CmtPaymentStateLocalizedMap[data.state]})',
                      style: TextStyle(
                          color: data.state == CmtPaymentState.PAID
                              ? Colors.green
                              : Colors.red))
                ])),
            Text(
              '￥${data.payAmount}',
              style: TextStyle(
                  color: Color.fromRGBO(255, 102, 102, 1), fontSize: 18),
            )
          ],
        ),
      ),
      ...data.state == CmtPaymentState.PAID
          ? [
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
                      style: infoTextStyle,
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
                      style: infoTextStyle,
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
                      style: infoTextStyle,
                    )
                  ],
                ),
              ),
            ]
          : []
    ];
  }

  bool get payOnline {
    if (order.payOnline != null && order.payOnline) {
      return true;
    }
    return false;
  }
}
