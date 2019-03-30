import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../common/app_keys.dart';
import '../common/app_image.dart';
import '../common/app_routes.dart';
import '_shared/widgets/site_statistics.dart';

/// 生意
class BusinessHomePage extends StatefulWidget {
  BusinessHomePage({Key key, this.userType}) : super(key: AppKeys.businessHomePage);

  final UserType userType;

  final Map<UserType, List<Widget>> widgets = <UserType, List<Widget>>{
    UserType.BRAND: <Widget>[BrandSiteStatisticsSection(), BrandMenusSection()],
    UserType.FACTORY: <Widget>[
      FactorySiteStatisticsSection(),
      FactoryMenusSection(),
    ]
  };

  get widgetsByUserType => widgets[userType];

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
        child: ListView(children: widget.widgetsByUserType),
      ),
    );
  }
}

class BrandSiteStatisticsSection extends StatelessWidget {
  final StreamController _reportsStreamController = StreamController<Reports>.broadcast();

  void queryReports() async {
    Reports response = await ReportsRepository().report();
    if (response != null) {
      _reportsStreamController.add(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    queryReports();

    return StreamBuilder<Reports>(
      stream: _reportsStreamController.stream,
      initialData: new Reports(),
      builder: (BuildContext context, AsyncSnapshot<Reports> snapshot) {
        return SiteStatistics(<SiteStatisticsModel>[
          SiteStatisticsModel(label: '需求报价中', value: '${snapshot.data?.ordersCount1 ?? 0}'),
          SiteStatisticsModel(label: '打样待付款', value: '${snapshot.data?.ordersCount2 ?? 0}'),
          SiteStatisticsModel(label: '生产待付款', value: '${snapshot.data?.ordersCount4 ?? 0}'),
          SiteStatisticsModel(label: '正在打样', value: '${snapshot.data?.ordersCount3 ?? 0}'),
          SiteStatisticsModel(label: '正在生产', value: '${snapshot.data?.ordersCount6 ?? 0}'),
        ]);
      },
    );
  }
}

class BrandMenusSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[
          AdvanceMenu('订单管理', <AdvanceMenuItem>[
            AdvanceMenuItem(MenuItemImage.requirement_order, '需求订单', AppRoutes.ROUTE_REQUIREMENT_ORDERS),
            AdvanceMenuItem(MenuItemImage.price_manage, '报价管理', AppRoutes.ROUTE_QUOTES),
            AdvanceMenuItem(MenuItemImage.proofing_order, '打样订单', AppRoutes.ROUTE_PROOFING_ORDERS),
            AdvanceMenuItem(MenuItemImage.purchase_order, '生产订单', AppRoutes.ROUTE_PURCHASE_ORDERS),
          ])
        ],),
        Row(children: <Widget>[
          AdvanceMenu('店铺管理', <AdvanceMenuItem>[
            AdvanceMenuItem(MenuItemImage.product_manage, '商品管理', AppRoutes.ROUTE_PRODUCTS),
            AdvanceMenuItem(MenuItemImage.employee_manage, '员工管理', AppRoutes.ROUTE_EMPLOYEES),
            AdvanceMenuItem(MenuItemImage.supplier_manage, '供应商管理', AppRoutes.ROUTE_SUPPLIERS),
            AdvanceMenuItem(MenuItemImage.clothes_manage, '样衣借还', AppRoutes.ROUTE_SAMPLE_GARMENTS),
          ])
        ],)
      ],
    );
  }
}

class FactorySiteStatisticsSection extends StatelessWidget {
  final StreamController _reportsStreamController = StreamController<Reports>.broadcast();

  void queryReports() async {
    Reports response = await ReportsRepository().report();
    if (response != null) {
      _reportsStreamController.add(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    queryReports();

    return StreamBuilder<Reports>(
      stream: _reportsStreamController.stream,
      initialData: Reports(),
      builder: (BuildContext context, AsyncSnapshot<Reports> snapshot) {
        return SiteStatistics(<SiteStatisticsModel>[
          SiteStatisticsModel(label: '报价中', value: '${snapshot.data?.ordersCount1 ?? 0}'),
          SiteStatisticsModel(label: '生产中', value: '${snapshot.data?.ordersCount7 ?? 0}'),
          SiteStatisticsModel(label: '已延期', value: '${snapshot.data?.ordersCount5 ?? 0}'),
        ]);
      },
    );
  }
}

class FactoryMenusSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            AdvanceMenu('订单管理', <AdvanceMenuItem>[
              AdvanceMenuItem(MenuItemImage.quote_factory, '报价管理', AppRoutes.ROUTE_QUOTES),
              AdvanceMenuItem(MenuItemImage.proofing_order, '打样订单', AppRoutes.ROUTE_PROOFING_ORDERS),
              AdvanceMenuItem(MenuItemImage.purchase_order, '生产订单', AppRoutes.ROUTE_PURCHASE_ORDERS),
            ]),
          ],
        ),
        Row(
          children: <Widget>[
            AdvanceMenu('工厂管理', <AdvanceMenuItem>[
              // AdvanceMenuItem(MenuItemImage.member_manage, '产能管理',
              //     AppRoutes.ROUTE_MEMBERSHIPS),
              AdvanceMenuItem(MenuItemImage.employee_manage, '员工管理', AppRoutes.ROUTE_EMPLOYEES),
              AdvanceMenuItem(MenuItemImage.product_factory, '产品管理', AppRoutes.ROUTE_PRODUCTS),
              AdvanceMenuItem(MenuItemImage.partner_factory, '合作商管理', AppRoutes.ROUTE_SUPPLIERS),
              AdvanceMenuItem(MenuItemImage.clothes_manage, '样衣管理', AppRoutes.ROUTE_SAMPLE_GARMENTS),
              // AdvanceMenuItem(MenuItemImage.inventory_manage, '面辅料管理',
              //     AppRoutes.ROUTE_PRODUCT_STOCKS),
            ])
          ],
        )
      ],
    );
  }
}