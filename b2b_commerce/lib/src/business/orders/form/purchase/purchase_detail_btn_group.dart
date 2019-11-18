import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

import 'purchase_deliver_order_form.dart';

class PurchaseDetailBtnGroup extends StatelessWidget {
  final PurchaseOrderModel order;

  const PurchaseDetailBtnGroup({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _btnGroup(context),
    );
  }

  List<Widget> _btnGroup(BuildContext context) {
    if (order == null) {
      return [];
    }
    if (UserBLoC.instance.currentUser.type == UserType.BRAND &&
        order.status != PurchaseOrderStatus.PENDING_CONFIRM &&
        order.status != PurchaseOrderStatus.COMPLETED) {
      return [
        Expanded(
            flex: 1,
            child: FlatButton(
              onPressed: () {},
              child: Text(
                '查看发货单',
                style: TextStyle(fontSize: 15, color: Colors.red),
              ),
            )),
        Expanded(
          flex: 1,
          child: Container(
              height: double.infinity,
              child: Builder(
                builder: (BuildContext buttonContext) =>
                    FlatButton(
                      color: Color.fromRGBO(255, 214, 12, 1),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                DeliverOrderForm(
                                    purchaseOrderCode: order.code,
                                    deliveryOrder: order.deliveryOrders
                                        .isNotEmpty
                                        ? order.deliveryOrders.first
                                        : null,
                                    shippingOrder: order.deliveryOrders
                                        .isNotEmpty
                                        ? null
                                        : order.shippingOrders.last,
                                    orderEntries: order.entries)));
                      },
                      disabledColor: Colors.grey[300],
                      child: Text(
                        '收货',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
              )),
        )
      ];
    } else {
      return [];
    }
  }
}
