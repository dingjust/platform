import 'package:b2b_commerce/src/business/orders/purchase_order_detail.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class ProductionItem extends StatelessWidget {
  const ProductionItem({Key key, this.order}) : super(key: key);

  final PurchaseOrderModel order;

  // 订单渠道类型
  // static Map<RequirementOrderStatus, MaterialColor> _statusColors = {
  //   RequirementOrderStatus.PENDING_QUOTE: Colors.green,
  //   RequirementOrderStatus.COMPLETED: Colors.orange,
  //   RequirementOrderStatus.CANCELLED: Colors.red
  // };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PurchaseOrderDetailPage(order: order),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          children: <Widget>[
            _buildHeader(),
            Column(
              children: _buildEntries(),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  '采购订单号：' + order.code,
                  style: TextStyle(fontSize: 14),
                ),
              ),
              // TODO : 订单类型枚举和对应颜色
              // Text(
              //   RequirementOrderStatusLocalizedMap[order.status],
              //   style: TextStyle(color: _statusColors[order.status])
              // )
              Text(
                '线上订单',
                style: TextStyle(color: Colors.green, fontSize: 14),
              )
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildEntries() {
    return order.entries
        .map((entry) => Container(
              color: Colors.grey[100],
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: entry.product.thumbnail != null
                              ? NetworkImage(entry.product.thumbnail)
                              : AssetImage(
                                  'temp/picture.png',
                                  package: "assets",
                                ),
                          fit: BoxFit.cover,
                        )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            entry.product.name,
                            style: TextStyle(fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              '货号：' + entry.product.skuID,
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                '共${order.totalQuantity}件商品   合计: ￥${order.totalPrice}',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    child: ProductionCircleStep(
                      size: 25,
                      currentPhase: order.currentPhase,
                    ),
                  )
                ],
              ),
            ))
        .toList();
  }
}
