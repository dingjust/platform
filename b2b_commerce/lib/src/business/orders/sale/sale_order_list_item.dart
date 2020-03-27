import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/business/orders/sale/sale_order_constants.dart';
import 'package:b2b_commerce/src/business/orders/sale/sale_order_detail_page.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'components/sales_list_button_group.dart';

class SaleOrderListItem extends StatelessWidget {
  final SalesOrderModel model;

  const SaleOrderListItem({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext itemContext) {
    final bloc = BLoCProvider.of<UserBLoC>(itemContext);
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        padding: const EdgeInsets.fromLTRB(0, 0, 5, 10),
        child: Column(
          children: <Widget>[
            _buildHeader(itemContext),
            _buildContent(itemContext),
            SalesListButtonGroup(
              model: model,
              callback: () {
                //回调刷新State
                Provider.of<SaleOrdersState>(itemContext).clear();
              },
            )
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onTap: () async {
        Navigator.of(itemContext).push(
          MaterialPageRoute(
              builder: (context) =>
                  SaleOrderDetailPage(
                    code: model.code,
                    callback: () {
                      //回调刷新State
                      Provider.of<SaleOrdersState>(itemContext).clear();
                    },
                  )),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    //根据显示买卖方
    UserType userType = BLoCProvider
        .of<UserBLoC>(context)
        .currentUser
        .type;

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
                      userType != UserType.FACTORY
                          ? '${model?.seller?.name ?? ''}'
                          : '${model?.user?.name ?? ''}',
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
                      child: _getOrderStatus()),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                '￥${getOrderTotalPrice()}',
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
    ApparelProductModel productModel =
        model.entries.first.product.baseProductDetail;

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
          ImageFactory.buildThumbnailImage(productModel?.thumbnail),
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
                        child: productModel == null || productModel.name == null
                            ? Container()
                            : Text(
                          '${productModel.name}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
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
                            '货号：${productModel.skuID}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ),
                      productModel == null || productModel.category == null
                          ? Container()
                          : Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 243, 243, 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "${productModel?.category?.name ?? ''}  $sum件",
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

  ///订单状态
  Widget _getOrderStatus() {
    if (model.refunding != null && model.refunding) {
      return Text(
        '退款/售后',
        textAlign: TextAlign.end,
        style: TextStyle(
          fontSize: 18,
          color: Colors.purple,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return Text(
      '${SalesOrderStatusLocalizedMap[model.status]}',
      textAlign: TextAlign.end,
      style: TextStyle(
        fontSize: 18,
        color: SaleOrderConstants.STATUS_COLORS[model.status],
        fontWeight: FontWeight.w500,
      ),
    );
  }

  ///计算订单总价
  String getOrderTotalPrice() {
    double result = 0;
    model.entries.forEach((entry) {
      result += entry.totalPrice;
    });
    return result.toStringAsFixed(2);
  }
}
