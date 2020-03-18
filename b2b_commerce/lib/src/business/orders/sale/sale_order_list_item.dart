import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/business/orders/sale/sale_order_constants.dart';
import 'package:b2b_commerce/src/business/orders/sale/sale_order_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'form/return_form_page.dart';

class SaleOrderListItem extends StatelessWidget {
  final PurchaseOrderModel model;

  const SaleOrderListItem({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BLoCProvider.of<UserBLoC>(context);
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        padding: const EdgeInsets.fromLTRB(0, 0, 5, 10),
        child: Column(
          children: <Widget>[
            _buildHeader(context),
            _buildContent(context),
            // bloc.isBrandUser?
            _buildBrandButton(context)
            // : _buildFactoryButton(context),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onTap: () async {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => SaleOrderDetailPage(code: model.code)),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '广东贸易有限公司',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey[300],
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${PurchaseOrderStatusLocalizedMap[model.status]}',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 18,
                        color: SaleOrderConstants.STATUS_COLORS[model.status],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Text(
                    '2022夏季裙装特供款',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Text(
                '￥15,000.0',
                textAlign: TextAlign.end,
                style: const TextStyle(fontSize: 16),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    //计算总数
    int sum = 0;
    model.entries.forEach((entry) {
      sum = sum + entry.quantity;
    });
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      margin: EdgeInsets.only(bottom: 5),
      color: Colors.grey[50],
      child: Row(
        children: <Widget>[
          ImageFactory.buildThumbnailImage(model.product?.thumbnail),
          Expanded(
              child: Container(
                  padding: const EdgeInsets.all(10),
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child:
                            model.product == null || model.product.name == null
                                ? Container()
                                : Text(
                                    '${model.product.name}',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            '货号：${model.product == null || model.product.skuID == null ? '' : model.product.skuID}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ),
                      model.product == null || model.product.category == null
                          ? Container()
                          : Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(255, 243, 243, 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "${model?.product?.category?.name ?? ''}  $sum件",
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: const Color.fromRGBO(255, 133, 148, 1),
                                ),
                              ),
                            )
                    ],
                  )))
        ],
      ),
    );
  }

  ///品牌按钮
  Widget _buildBrandButton(BuildContext context) {
    //TODO：按钮控制
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 30,
              child: OutlineButton(
                  child: Text(
                    '关闭订单',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  onPressed: () => onClose(context)),
            ),
          ),
          Expanded(
            child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: 30,
                child: FlatButton(
                    color: Colors.orangeAccent,
                    child: Text(
                      '支付',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      // PurchaseOrderModel order = model;
                      // //将支付金额置为定金
                      // order.totalPrice = order.deposit;
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => OrderPaymentPage(
                      //           order: order,
                      //           paymentFor: PaymentFor.DEPOSIT,
                      //         )));

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ReturnFormPage()));
                    })),
          ),
        ],
      ),
    );
  }

  ///工厂按钮
  Widget _buildFactoryButton(BuildContext context) {}

  void onClose(BuildContext context) async {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text(
            '提示',
            style: const TextStyle(fontSize: 16),
          ),
          content: Text('是否要取消订单？'),
          actions: <Widget>[
            FlatButton(
              child: Text(
                '取消',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                '确定',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) {
                      return RequestDataLoading(
                        requestCallBack: PurchaseOrderRepository()
                            .purchaseOrderCancelling(model.code),
                        outsideDismiss: false,
                        loadingText: '正在取消。。。',
                        entrance: 'purchaseOrders',
                      );
                    });
              },
            ),
          ],
        );
      },
    );
  }
}
