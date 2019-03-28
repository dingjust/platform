import 'dart:async';

import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../common/app_routes.dart';

/// 生意
class BusinessHomePage extends StatefulWidget {
  @override
  _BusinessHomePageState createState() => new _BusinessHomePageState();
}

class _BusinessHomePageState extends State<BusinessHomePage> {
  final StreamController _reportsStreamController =
      StreamController<Reports>.broadcast();

  Reports companyReports = Reports();

  @override
  Widget build(BuildContext context) {
    queryReports();
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
            StreamBuilder<Reports>(
                stream: _reportsStreamController.stream,
                initialData: companyReports,
                builder:
                    (BuildContext context, AsyncSnapshot<Reports> snapshot) {
                  return SiteStatisticsSectionForFactory(<SiteStatisticsModel>[
                    SiteStatisticsModel(
                        label: '报价中',
                        value: '${snapshot.data?.ordersCount1 ?? 0}'),
                    SiteStatisticsModel(
                        label: '生产中',
                        value: '${snapshot.data?.ordersCount7 ?? 0}'),
                    SiteStatisticsModel(
                        label: '已延期',
                        value: '${snapshot.data?.ordersCount5 ?? 0}'),
                  ]);
                }),
            AdvanceMenu('订单管理', <AdvanceMenuItem>[
              AdvanceMenuItem(
                  MenuItemImage.quote_factory, '报价管理', AppRoutes.ROUTE_QUOTES),
              AdvanceMenuItem(MenuItemImage.proofing_order, '打样订单',
                  AppRoutes.ROUTE_PROOFING_ORDERS),
              AdvanceMenuItem(MenuItemImage.purchase_order, '生产订单',
                  AppRoutes.ROUTE_PURCHASE_ORDERS),
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

  void queryReports() async {
    Reports response = await ReportsRepository().report();
    if (response != null) {
      companyReports = response;
      _reportsStreamController.add(companyReports);
    }
  }
}
