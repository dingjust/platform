import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

import '../common/app_routes.dart';
import 'search/apparel_product_search.dart';

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
            onPressed: () => showSearch(context: context, delegate: ApparelProductSearchDelegate()),
          ),
          IconButton(
            icon: Icon(Icons.message),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: ListView(
          children: <Widget>[
            SiteStatisticsSection(<SiteStatisticsModel>[
              SiteStatisticsModel('今日销售', '561件'),
              SiteStatisticsModel('今日销量', '2500.00元'),
              SiteStatisticsModel('在架商品', '15款')
            ]),
            Menu('我的待办', <MenuItem>[
              MenuItem(Icons.call, '报价管理', AppRoutes.ROUTE_QUOTES),
              MenuItem(Icons.call, '会员审核', AppRoutes.ROUTE_MEMBER_REQUESTS),
            ]),
            Menu('订单管理', <MenuItem>[
              MenuItem(Icons.call, '需求订单', AppRoutes.ROUTE_REQUIREMENT_ORDERS),
              MenuItem(Icons.call, '采购订单', AppRoutes.ROUTE_PURCHASE_ORDERS),
              MenuItem(Icons.call, '销售订单', AppRoutes.ROUTE_SALES_ORDERS),
              MenuItem(Icons.call, '生产订单', AppRoutes.ROUTE_PRODUCTION_ORDERS),
            ]),
            Menu('店铺管理', <MenuItem>[
              MenuItem(Icons.call, '商品管理', AppRoutes.ROUTE_PRODUCTS),
              MenuItem(Icons.call, '库存管理', AppRoutes.ROUTE_PRODUCT_STOCKS),
              MenuItem(Icons.call, '员工管理', AppRoutes.ROUTE_EMPLOYEES),
              MenuItem(Icons.call, '会员管理', AppRoutes.ROUTE_MEMBERSHIPS),
            ]),
            Menu('其他', <MenuItem>[
              MenuItem(Icons.call, '供应商管理', AppRoutes.ROUTE_SUPPLIERS),
              MenuItem(Icons.call, '样衣管理', AppRoutes.ROUTE_SAMPLE_GARMENTS),
              MenuItem(Icons.call, '报表管理', '/business/sales-orders'),
            ]),
          ],
        ),
      ),
    );
  }
}
