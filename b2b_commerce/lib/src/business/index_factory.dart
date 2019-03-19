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
        title: Text('统计'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: Container(
        color: Color.fromRGBO(245, 245, 245, 1),
        child: ListView(
          children: <Widget>[
            SiteStatisticsSectionForFactory(<SiteStatisticsModel>[
              SiteStatisticsModel(label: '延期订单', value: '5'),
              SiteStatisticsModel(label: '待出库订单', value: '5'),
              SiteStatisticsModel(label: '待收款订单', value: '6'),
              SiteStatisticsModel(label: '正在报价', value: '5'),
              SiteStatisticsModel(label: '本月产能', value: '5000'),
            ]),
            AdvanceMenu('订单管理', <AdvanceMenuItem>[
              AdvanceMenuItem(
                  MenuItemImage.quote_factory, '报价管理', AppRoutes.ROUTE_QUOTES),
              AdvanceMenuItem(MenuItemImage.production_factory, '生产订单',
                  AppRoutes.ROUTE_PURCHASE_ORDERS),
              // AdvanceMenuItem(MenuItemImage.proofing_order, '发料单',
              //     AppRoutes.ROUTE_PROOFING_ORDERS),
            ]),
            AdvanceMenu('工厂管理', <AdvanceMenuItem>[
              // AdvanceMenuItem(MenuItemImage.member_manage, '产能管理',
              //     AppRoutes.ROUTE_MEMBERSHIPS),
              AdvanceMenuItem(MenuItemImage.employee_manage, '员工管理',
                  AppRoutes.ROUTE_EMPLOYEES),
              AdvanceMenuItem(MenuItemImage.product_factory, '产品管理',
                  AppRoutes.ROUTE_PRODUCTS),
              AdvanceMenuItem(MenuItemImage.partner_factory, '合作商管理',
                  AppRoutes.ROUTE_SUPPLIERS),
              AdvanceMenuItem(MenuItemImage.clothes_manage, '样衣管理',
                  AppRoutes.ROUTE_SAMPLE_GARMENTS),
              // AdvanceMenuItem(MenuItemImage.inventory_manage, '面辅料管理',
              //     AppRoutes.ROUTE_PRODUCT_STOCKS),
            ]),
          ],
        ),
      ),
    );
  }
}
