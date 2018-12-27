import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

import '../common/routes.dart';

/// 生意
class BusinessHomePage extends StatefulWidget {
  @override
  _BusinessHomePageState createState() => new _BusinessHomePageState();
}

class _BusinessHomePageState extends State<BusinessHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('生意'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: ListView(
          children: <Widget>[
            BusinessStatisticsSection(),
            Menu('我的待办', <MenuItem>[
              MenuItem(Icons.call, '报价管理', Routes.ROUTE_QUOTES),
              MenuItem(Icons.call, '会员审核', Routes.ROUTE_MEMBER_REQUESTS),
            ]),
            Menu('订单管理', <MenuItem>[
              MenuItem(Icons.call, '需求订单', Routes.ROUTE_REQUIREMENT_ORDERS),
              MenuItem(Icons.call, '采购订单', Routes.ROUTE_PURCHASE_ORDERS),
              MenuItem(Icons.call, '销售订单', Routes.ROUTE_SALES_ORDERS),
              MenuItem(Icons.call, '生产订单', Routes.ROUTE_PRODUCTION_ORDERS),
            ]),
            Menu('店铺管理', <MenuItem>[
              MenuItem(Icons.call, '商品管理', Routes.ROUTE_PRODUCTS),
              MenuItem(Icons.call, '库存管理', Routes.ROUTE_PRODUCT_STOCKS),
              MenuItem(Icons.call, '员工管理', Routes.ROUTE_EMPLOYEES),
              MenuItem(Icons.call, '会员管理', Routes.ROUTE_MEMBERSHIPS),
            ]),
            Menu('其他', <MenuItem>[
              MenuItem(Icons.call, '供应商管理', Routes.ROUTE_SUPPLIERS),
              MenuItem(Icons.call, '样衣管理', Routes.ROUTE_SAMPLE_GARMENTS),
              MenuItem(Icons.call, '报表管理', '/business/sales-orders'),
            ]),
          ],
        ),
      ),
    );
  }
}

/// 生意统计
class BusinessStatisticsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Column buildButtonColumn(String label, String amount) {
      Color color = Theme.of(context).primaryColor;

      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label),
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: Text(
              amount,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButtonColumn('今日销售', '561件'),
          buildButtonColumn('今日销量', '2500.00元'),
          buildButtonColumn('在架商品', '15款'),
        ],
      ),
    );
  }
}
