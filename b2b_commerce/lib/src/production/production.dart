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
        // Navigator.pushNamed(context, AppRoutes.ROUTE_REQUIREMENT_ORDERS_DETAIL);
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => RequirementOrderDetailPage(order: order)));
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
            _buildStep()
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
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text('采购订单号：' + order.code),
              ),
              // 订单类型
              // Text(
              //   RequirementOrderStatusLocalizedMap[order.status],
              //   style: TextStyle(color: _statusColors[order.status])
              // )
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
                                    TextStyle(color: Colors.red, fontSize: 14),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ))
        .toList();
  }

  Widget _buildStep() {
    //TODO 查询订单生产进度
    final List<OrderStatusModel> _statusList = [
      OrderStatusModel.fromJson({
        'code': 'WAIT_FOR_PROCESSING',
        'name': '待处理',
        'sort': 1,
      }),
      OrderStatusModel.fromJson({
        'code': 'PENDING_APPROVAL',
        'name': '待确认',
        'sort': 2,
      }),
      OrderStatusModel.fromJson({
        'code': 'IN_PRODUCTION',
        'name': '生产中',
        'sort': 3,
      }),
      OrderStatusModel.fromJson({
        'code': 'OUT_OF_STORE',
        'name': '已出库',
        'sort': 4,
      }),
      OrderStatusModel.fromJson({
        'code': 'COMPLETED',
        'name': '已完成',
        'sort': 5,
      }),
    ];

    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: StatusStep(
              width: 300,
              list: _statusList,
              currentStatus: PurchaseOrderStatusLocalizedMap[order.status],
              isScroll: false,
            ),
          )
        ],
      ),
    );
  }
}
