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

class SaleOrderListItem extends StatefulWidget {
  final SalesOrderModel model;

  const SaleOrderListItem({Key key, this.model}) : super(key: key);

  @override
  _SaleOrderListItemState createState() => _SaleOrderListItemState();
}

class _SaleOrderListItemState extends State<SaleOrderListItem> {
  bool showMore = false;

  @override
  void initState() {
    showMore = widget.model.entries.length > 3 ? false : true;
    super.initState();
  }

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
              model: widget.model,
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
                    code: widget.model.code,
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
                          ? '${widget.model?.seller?.name ?? ''}'
                          : '${widget.model?.user?.name ?? ''}',
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
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    //计算总数
    int sum = 0;
    widget.model.entries.forEach((entry) {
      sum = sum + entry.quantity;
    });
    return Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        margin: EdgeInsets.only(bottom: 5),
        // color: Colors.grey[50],
        child: Column(
          children: <Widget>[
            _buildBaseProductRow(),
            _buildEntriesRow(),
            _buildMoreBtnRow(),
            Divider(),
            _buildSumRow()
          ],
        ));
  }

  ///订单状态
  Widget _getOrderStatus() {
    if (widget.model.refunding != null && widget.model.refunding) {
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
      '${SalesOrderStatusLocalizedMap[widget.model.status]}',
      textAlign: TextAlign.end,
      style: TextStyle(
        fontSize: 18,
        color: SaleOrderConstants.STATUS_COLORS[widget.model.status],
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildBaseProductRow() {
    ApparelProductModel productModel =
        widget.model.entries.first.product.baseProductDetail;

    return Row(
      children: <Widget>[
        ImageFactory.buildThumbnailImage(productModel?.thumbnail),
        Expanded(
            child: Container(
                padding: const EdgeInsets.all(10),
                height: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            '${productModel.name}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(
                          '￥${widget.model.entries.first.basePrice}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Text(
                      '${productModel.skuID}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                )))
      ],
    );
  }

  Widget _buildEntriesRow() {
    List<Widget> entryRows = [];

    for (int i = 0; i < widget.model.entries.length; i++) {
      if (i < 3 || showMore) {
        entryRows.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                margin: EdgeInsets.only(left: 50),
                child: Text(
                  '颜色：${widget.model.entries[i].product.color.name}',
                  style: TextStyle(color: Colors.grey),
                  overflow: TextOverflow.clip,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text('尺码：${widget.model.entries[i].product.size.name}',
                  style: TextStyle(color: Colors.grey)),
            ),
            Text('x${widget.model.entries[i].quantity}')
          ],
        ));
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(children: entryRows),
    );
  }

  Widget _buildMoreBtnRow() {
    return widget.model.entries.length > 3
        ? Row(
      children: <Widget>[
        Expanded(
            child: FlatButton(
                onPressed: () {
                  setState(() {
                    showMore = !showMore;
                  });
                },
                child: Text(
                  !showMore ? '更多' : '收起',
                  style: TextStyle(color: Colors.orange),
                )))
      ],
    )
        : Container();
  }

  Widget _buildSumRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 30),
          child: Text('1种货品'),
        ),
        Container(
          margin: EdgeInsets.only(right: 5),
          child: Text('总金额：'),
        ),
        Container(
          child: Text(
            '￥${getOrderTotalPrice()}',
            style: TextStyle(color: Colors.red),
          ),
        )
      ],
    );
  }

  ///计算订单总价
  String getOrderTotalPrice() {
    double result = 0;
    widget.model.entries.forEach((entry) {
      result += entry.totalPrice;
    });
    return result.toStringAsFixed(2);
  }
}
