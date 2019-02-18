import 'package:b2b_commerce/src/common/app_image.dart';
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
      // appBar: AppBar(
      //   title: Text('生意'),
      //   actions: <Widget>[
      //     IconButton(
      //       icon: Icon(Icons.search),
      //       onPressed: () => showSearch(context: context, delegate: ApparelProductSearchDelegate()),
      //     ),
      //     IconButton(
      //       icon: Icon(Icons.message),
      //       onPressed: () {},
      //     )
      //   ],
      // ),
      body: Container(
        color: Colors.grey[200],
        child: ListView(
          children: <Widget>[
            SiteStatisticsSection(<SiteStatisticsModel>[
              SiteStatisticsModel('今日销售', '561件'),
              SiteStatisticsModel('今日销量', '2500.00元'),
              SiteStatisticsModel('在架商品', '15款')
            ]),
            AdvanceMenu('我的待办', <AdvanceMenuItem>[
              AdvanceMenuItem(
                  MenuItemImage.price_manage, '报价管理', AppRoutes.ROUTE_QUOTES),
              AdvanceMenuItem(MenuItemImage.customer_audit, '会员审核',
                  AppRoutes.ROUTE_MEMBER_REQUESTS),
            ]),
            AdvanceMenu('订单管理', <AdvanceMenuItem>[
              AdvanceMenuItem(MenuItemImage.requirement_order, '需求订单',
                  AppRoutes.ROUTE_REQUIREMENT_ORDERS),
              AdvanceMenuItem(MenuItemImage.purchase_order, '采购订单',
                  AppRoutes.ROUTE_PURCHASE_ORDERS),
              AdvanceMenuItem(MenuItemImage.sale_order, '销售订单',
                  AppRoutes.ROUTE_SALES_ORDERS),
            ]),
            AdvanceMenu('店铺管理', <AdvanceMenuItem>[
              AdvanceMenuItem(MenuItemImage.product_manage, '商品管理',
                  AppRoutes.ROUTE_PRODUCTS),
              AdvanceMenuItem(MenuItemImage.inventory_manage, '库存管理',
                  AppRoutes.ROUTE_PRODUCT_STOCKS),
              AdvanceMenuItem(MenuItemImage.employee_manage, '员工管理',
                  AppRoutes.ROUTE_EMPLOYEES),
              AdvanceMenuItem(MenuItemImage.member_manage, '会员管理',
                  AppRoutes.ROUTE_MEMBERSHIPS),
            ]),
            AdvanceMenu('其他', <AdvanceMenuItem>[
              AdvanceMenuItem(MenuItemImage.supplier_manage, '供应商管理',
                  AppRoutes.ROUTE_SUPPLIERS),
              AdvanceMenuItem(MenuItemImage.clothes_manage, '样衣管理',
                  AppRoutes.ROUTE_SAMPLE_GARMENTS),
              AdvanceMenuItem(
                  MenuItemImage.check_report, '报表查看', '/business/sales-orders'),
              AdvanceMenuItem(
                  MenuItemImage.check_report, '运费管理', AppRoutes.ROUTE_DELIVERY),
            ]),
          ],
        ),
      ),
    );
  }
}
