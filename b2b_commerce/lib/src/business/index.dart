import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../common/app_image.dart';
import '../common/app_keys.dart';
import '../common/app_routes.dart';
import '_shared/widgets/site_statistics.dart';

/// 生意
class BusinessHomePage extends StatefulWidget {
  BusinessHomePage({Key key, this.userType})
      : super(key: AppKeys.businessHomePage);

  final UserType userType;

  final Map<UserType, List<Widget>> widgets = <UserType, List<Widget>>{
    UserType.BRAND: <Widget>[
      BrandSiteStatisticsSection(),
      SliverSpacing(),
      BrandMenusSection(),
    ],
    UserType.FACTORY: <Widget>[
      FactorySiteStatisticsSection(),
      SliverSpacing(),
      FactoryMenusSection()
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
        color: Colors.white,
        child: CustomScrollView(slivers: widget.widgetsByUserType),
      ),
    );
  }
}

class BrandSiteStatisticsSection extends StatelessWidget {
  final StreamController _reportsStreamController =
      StreamController<Reports>.broadcast();

  void queryReports() async {
    Reports response = await ReportsRepository().report();
    if (response != null) {
      _reportsStreamController.add(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (UserBLoC.instance.currentUser.status == UserStatus.ONLINE) {
      queryReports();
    }

    return StreamBuilder<Reports>(
      stream: _reportsStreamController.stream,
      initialData: new Reports(),
      builder: (BuildContext context, AsyncSnapshot<Reports> snapshot) {
        return SiteStatistics(<SiteStatisticsModel>[
          SiteStatisticsModel(
              label: '需求报价中', value: '${snapshot.data?.ordersCount1 ?? 0}'),
          SiteStatisticsModel(
              label: '打样待付款', value: '${snapshot.data?.ordersCount2 ?? 0}'),
          SiteStatisticsModel(
              label: '生产待付款', value: '${snapshot.data?.ordersCount4 ?? 0}'),
          SiteStatisticsModel(
              label: '正在打样', value: '${snapshot.data?.ordersCount3 ?? 0}'),
          SiteStatisticsModel(
              label: '正在生产', value: '${snapshot.data?.ordersCount6 ?? 0}'),
        ]);
      },
    );
  }
}

class BrandMenusSection extends StatelessWidget {
  Widget _buildOrderMenu() {
    return Container(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          AdvanceMenu('订单管理', <AdvanceMenuItem>[
            AdvanceMenuItem(MenuItemImage.requirementOrder, '需求订单',
                AppRoutes.ROUTE_REQUIREMENT_ORDERS),
            AdvanceMenuItem(
                MenuItemImage.priceManage, '报价管理', AppRoutes.ROUTE_QUOTES),
            AdvanceMenuItem(MenuItemImage.proofingOrder, '打样订单',
                AppRoutes.ROUTE_PROOFING_ORDERS),
            AdvanceMenuItem(MenuItemImage.purchaseOrder, '生产订单',
                AppRoutes.ROUTE_PURCHASE_ORDERS),
          ])
        ],
      ),
    );
  }

  Widget _buildCompanyMenu() {
    return Container(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          AdvanceMenu('店铺管理', <AdvanceMenuItem>[
            AdvanceMenuItem(
                MenuItemImage.productManage, '商品管理', AppRoutes.ROUTE_PRODUCTS),
            // AdvanceMenuItem(MenuItemImage.employeeManage, '员工管理',
            //     AppRoutes.ROUTE_EMPLOYEES),
            AdvanceMenuItem(MenuItemImage.supplierManage, '供应商管理',
                AppRoutes.ROUTE_SUPPLIERS),
            AdvanceMenuItem(MenuItemImage.clothesManage, '样衣借还',
                AppRoutes.ROUTE_SAMPLE_GARMENTS),
          ])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(<Widget>[
        _buildOrderMenu(),
        Container(
          height: 10,
          color: Color.fromRGBO(245, 245, 245, 1),
        ),
        _buildCompanyMenu(),
      ]),
    );
  }
}

class FactorySiteStatisticsSection extends StatelessWidget {
  final StreamController _reportsStreamController =
      StreamController<Reports>.broadcast();

  void queryReports() async {
    Reports response = await ReportsRepository().report();
    if (response != null) {
      _reportsStreamController.add(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (UserBLoC.instance.currentUser.status == UserStatus.ONLINE) {
      queryReports();
    }

    return StreamBuilder<Reports>(
      stream: _reportsStreamController.stream,
      initialData: Reports(),
      builder: (BuildContext context, AsyncSnapshot<Reports> snapshot) {
        return SiteStatistics(<SiteStatisticsModel>[
          SiteStatisticsModel(
              label: '报价中', value: '${snapshot.data?.ordersCount1 ?? 0}'),
          SiteStatisticsModel(
              label: '生产中', value: '${snapshot.data?.ordersCount7 ?? 0}'),
          SiteStatisticsModel(
              label: '已延期', value: '${snapshot.data?.ordersCount5 ?? 0}'),
        ]);
      },
    );
  }
}

class FactoryMenusSection extends StatelessWidget {
  Widget _buildOrderMenu() {
    return Container(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          AdvanceMenu('订单管理', <AdvanceMenuItem>[
            AdvanceMenuItem(
                MenuItemImage.quoteFactory, '报价管理', AppRoutes.ROUTE_QUOTES),
            AdvanceMenuItem(MenuItemImage.proofingOrder, '打样订单',
                AppRoutes.ROUTE_PROOFING_ORDERS),
            AdvanceMenuItem(MenuItemImage.purchaseOrder, '生产订单',
                AppRoutes.ROUTE_PURCHASE_ORDERS),
          ]),
        ],
      ),
    );
  }

  Widget _buildCompanyMenu() {
    return Container(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          AdvanceMenu('工厂管理', <AdvanceMenuItem>[
            AdvanceMenuItem(MenuItemImage.employeeManage, '员工管理',
                AppRoutes.ROUTE_EMPLOYEES),
            AdvanceMenuItem(
                MenuItemImage.productFactory, '产品管理', AppRoutes.ROUTE_PRODUCTS),
            AdvanceMenuItem(MenuItemImage.partnerFactory, '合作商管理',
                AppRoutes.ROUTE_SUPPLIERS),
            AdvanceMenuItem(MenuItemImage.clothesManage, '样衣管理',
                AppRoutes.ROUTE_SAMPLE_GARMENTS),
          ])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(<Widget>[
        _buildOrderMenu(),
        Container(
          height: 10,
          color: Color.fromRGBO(245, 245, 245, 1),
        ),
        _buildCompanyMenu(),
      ]),
    );
  }
}

class SliverSpacing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 10,
        color: Color.fromRGBO(245, 245, 245, 1),
      ),
    );
  }
}
