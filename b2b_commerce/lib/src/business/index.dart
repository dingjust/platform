import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

import '../common/app_routes.dart';

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
        title: Text('工作'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: Container(
        color: Color.fromRGBO(245, 245, 245, 1),
        child: ListView(
          children: <Widget>[
            SiteStatisticsSection(<SiteStatisticsModel>[
              SiteStatisticsModel(label: '今日销售', value: '561', unit: '件'),
              SiteStatisticsModel(label: '今日销量', value: '2500', unit: '元'),
              SiteStatisticsModel(label: '在架商品', value: '15', unit: '款'),
            ]),
            AdvanceMenu('订单管理', <AdvanceMenuItem>[
              AdvanceMenuItem(MenuItemImage.requirement_order, '需求订单',
                  AppRoutes.ROUTE_REQUIREMENT_ORDERS),
              AdvanceMenuItem(
                  MenuItemImage.price_manage, '报价管理', AppRoutes.ROUTE_QUOTES),
              AdvanceMenuItem(MenuItemImage.proofing_order, '打样订单',
                  AppRoutes.ROUTE_PROOFING_ORDERS),
              AdvanceMenuItem(MenuItemImage.purchase_order, '生产订单',
                  AppRoutes.ROUTE_PURCHASE_ORDERS),
            ]),
            AdvanceMenu('店铺管理', <AdvanceMenuItem>[
              AdvanceMenuItem(MenuItemImage.product_manage, '商品管理',
                  AppRoutes.ROUTE_PRODUCTS),
              AdvanceMenuItem(MenuItemImage.employee_manage, '员工管理',
                  AppRoutes.ROUTE_EMPLOYEES),
              AdvanceMenuItem(MenuItemImage.supplier_manage, '供应商管理',
                  AppRoutes.ROUTE_SUPPLIERS),
              AdvanceMenuItem(MenuItemImage.clothes_manage, '样衣借还',
                  AppRoutes.ROUTE_SAMPLE_GARMENTS),
            ]),
          ],
        ),
      ),
    );
  }
}
