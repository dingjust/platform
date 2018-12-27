import 'package:flutter/material.dart';

import '../common/routes.dart';

/// 生意
class BusinessPage extends StatefulWidget {
  @override
  _BusinessPageState createState() => new _BusinessPageState();
}

class _BusinessPageState extends State<BusinessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('生意'),
      ),
      body: ListView(
        children: <Widget>[
          BusinessStatisticsSection(),
          Menu('我的待办', <MenuItem>[
            MenuItem(Icons.call, '报价管理', Routes.ROUTE_QUOTES),
            MenuItem(Icons.call, '订单事项', '/business/sales-orders'),
            MenuItem(Icons.call, '客户审核', '/business/sales-orders'),
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
            MenuItem(Icons.call, '报表查看', '/business/sales-orders'),
          ]),
        ],
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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildButtonColumn('今日销售', '561件'),
            buildButtonColumn('今日销量', '2500.00元'),
            buildButtonColumn('在架商品', '15款'),
          ],
        ),
      ),
    );
  }
}

class Menu extends StatelessWidget {
  final String title;
  final List<MenuItem> items;

  Menu(this.title, this.items);

  @override
  Widget build(BuildContext context) {
    List<MenuItem> columns = this.items.map((item) {
      return MenuItem(item.icon, item.title, item.routeTo);
    }).toList();

    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: columns,
          ),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String routeTo;

  MenuItem(this.icon, this.title, this.routeTo);

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeTo);
      },
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
