import 'dart:async';

import 'package:b2b_commerce/src/_shared/widgets/authorization_dector.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

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
  Widget _buildOrderMenu(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                '订单管理',
                style: TextStyle(fontSize: 16),
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              crossAxisCount: 4,
              mainAxisSpacing: 20.0,
              crossAxisSpacing: 4.0,
              childAspectRatio: (1.3),
              children: <Widget>[
                buildChild(context, MenuItemImage.requirementOrder, '需求订单',
                    AppRoutes.ROUTE_REQUIREMENT_ORDERS,
                    authorizations: [Authorization.REQUIREMENT_ORDER]),
                buildChild(context, MenuItemImage.priceManage, '报价管理',
                    AppRoutes.ROUTE_QUOTES,
                    authorizations: [Authorization.QUOTE_ORDER]),
                buildChild(context, MenuItemImage.proofingOrder, '打样订单',
                    AppRoutes.ROUTE_PROOFING_ORDERS,
                    authorizations: [Authorization.PROOFING_ORDER]),
                buildChild(context, MenuItemImage.purchaseOrder, '生产订单',
                    AppRoutes.ROUTE_PURCHASE_ORDERS,
                    authorizations: [Authorization.PURCHASE_ORDER]),
                buildChild(context, MenuItemImage.saleOrder, '销售订单',
                    AppRoutes.ROUTE_SALE_ORDERS,
                    authorizations: [Authorization.PURCHASE_ORDER]),
              ],
            )
          ],
        ));
  }

  Widget _buildCompanyMenu(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                '店铺管理',
                style: TextStyle(fontSize: 16),
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              crossAxisCount: 4,
              mainAxisSpacing: 20.0,
              crossAxisSpacing: 4.0,
              childAspectRatio: (1.3),
              children: <Widget>[
                buildChild(context, MenuItemImage.productFactory, '产品管理',
                    AppRoutes.ROUTE_PRODUCTS,
                    authorizations: [Authorization.PRODUCT]),
                //  buildChild(context, MenuItemImage.employeeManage, '员工管理',
                //      AppRoutes.ROUTE_EMPLOYEES),
                buildChild(context, MenuItemImage.partnerFactory, '合作商管理',
                    AppRoutes.ROUTE_SUPPLIERS,
                    authorizations: [Authorization.COMPANY_COOPERATOR]),
                buildChild(context, MenuItemImage.clothesManage, '样衣借还',
                    AppRoutes.ROUTE_SAMPLE_GARMENTS,
                    authorizations: [Authorization.PRODUCT_SAMPLEPRODUCT]),
              ],
            )
          ],
        ));
  }

  Widget buildChild(BuildContext context, Image image, String title,
      String routeTo,
      {List<Authorization> authorizations}) {
    if (authorizations != null) {
      return AuthorizationDector(
        show: false,
        opacity: 0.3,
        authorizations: authorizations,
        child: GestureDetector(
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  image,
                  Container(
                    margin: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Color.fromRGBO(100, 100, 100, 1),
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, routeTo);
            }),
      );
    } else {
      return GestureDetector(
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                image,
                Container(
                  margin: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Color.fromRGBO(100, 100, 100, 1),
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, routeTo);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(<Widget>[
        _buildOrderMenu(context),
        Container(
          height: 10,
          color: Color.fromRGBO(245, 245, 245, 1),
        ),
        _buildCompanyMenu(context),
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
              label: '生产中', value: '${snapshot.data?.ordersCount6 ?? 0}'),
          SiteStatisticsModel(
              label: '已延期', value: '${snapshot.data?.ordersCount5 ?? 0}'),
        ]);
      },
    );
  }
}

class FactoryMenusSection extends StatelessWidget {
  Widget _buildOrderMenu(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                '订单管理',
                style: TextStyle(fontSize: 16),
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              crossAxisCount: 4,
              mainAxisSpacing: 20.0,
              crossAxisSpacing: 4.0,
              childAspectRatio: (1.3),
              children: <Widget>[
                buildChild(context, MenuItemImage.priceManage, '报价管理',
                    AppRoutes.ROUTE_QUOTES,
                    authorizations: [Authorization.QUOTE_ORDER]),
                buildChild(context, MenuItemImage.proofingOrder, '打样订单',
                    AppRoutes.ROUTE_PROOFING_ORDERS,
                    authorizations: [Authorization.PROOFING_ORDER]),
                buildChild(context, MenuItemImage.purchaseOrder, '生产订单',
                    AppRoutes.ROUTE_PURCHASE_ORDERS,
                    authorizations: [Authorization.PURCHASE_ORDER]),
                buildChild(context, MenuItemImage.saleOrder, '销售订单',
                    AppRoutes.ROUTE_SALE_ORDERS,
                    authorizations: [Authorization.PURCHASE_ORDER]),
              ],
            )
          ],
        ));
  }

  Widget _buildCompanyMenu(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                '店铺管理',
                style: TextStyle(fontSize: 16),
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              crossAxisCount: 4,
              mainAxisSpacing: 20.0,
              crossAxisSpacing: 4.0,
              childAspectRatio: (1.3),
              children: <Widget>[
                buildChild(context, MenuItemImage.productFactory, '产品管理',
                    AppRoutes.ROUTE_PRODUCTS,
                    authorizations: [Authorization.PRODUCT]),
                // buildChild(context, MenuItemImage.employeeManage, '员工管理',
                //     AppRoutes.ROUTE_EMPLOYEES),
                buildChild(context, MenuItemImage.partnerFactory, '合作商管理',
                    AppRoutes.ROUTE_SUPPLIERS,
                    authorizations: [Authorization.COMPANY_COOPERATOR]),
                buildChild(context, MenuItemImage.clothesManage, '样衣借还',
                    AppRoutes.ROUTE_SAMPLE_GARMENTS,
                    authorizations: [Authorization.PRODUCT_SAMPLEPRODUCT]),
                buildChild(
                    context,
                    B2BImage.free_capacity2(height: 25, width: 25),
                    '空闲产能',
                    AppRoutes.ROUTE_MY_CAPACITY,
                    authorizations: [Authorization.FACTORY_CAPACITY]),
              ],
            )
          ],
        ));
  }

  Widget buildChild(BuildContext context, Image image, String title,
      String routeTo,
      {List<Authorization> authorizations}) {
    if (authorizations != null) {
      return AuthorizationDector(
        authorizations: authorizations,
        show: false,
        opacity: 0.3,
        child: GestureDetector(
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  image,
                  Container(
                    margin: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Color.fromRGBO(100, 100, 100, 1),
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, routeTo);
            }),
      );
    } else {
      return GestureDetector(
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                image,
                Container(
                  margin: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Color.fromRGBO(100, 100, 100, 1),
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, routeTo);
          });
    }
  }

//  Widget _buildOrderMenu() {
//    return Container(
//      color: Colors.white,
//      child: Row(
//        children: <Widget>[
//          AdvanceMenu('订单管理', <AdvanceMenuItem>[
//            AdvanceMenuItem(
//                MenuItemImage.quoteFactory, '报价管理', AppRoutes.ROUTE_QUOTES),
//            AdvanceMenuItem(MenuItemImage.proofingOrder, '打样订单',
//                AppRoutes.ROUTE_PROOFING_ORDERS),
//            AdvanceMenuItem(MenuItemImage.purchaseOrder, '生产订单',
//                AppRoutes.ROUTE_PURCHASE_ORDERS),
//          ]),
//        ],
//      ),
//    );
//  }
//
//  Widget _buildCompanyMenu() {
//    return Container(
//      color: Colors.white,
//      child: Row(
//        children: <Widget>[
//          AdvanceMenu('工厂管理', <AdvanceMenuItem>[
//            // AdvanceMenuItem(MenuItemImage.employeeManage, '员工管理',
//            //     AppRoutes.ROUTE_EMPLOYEES),
//            AdvanceMenuItem(
//                MenuItemImage.productFactory, '产品管理', AppRoutes.ROUTE_PRODUCTS),
//            AdvanceMenuItem(MenuItemImage.partnerFactory, '合作商管理',
//                AppRoutes.ROUTE_SUPPLIERS),
//            AdvanceMenuItem(MenuItemImage.clothesManage, '样衣借还',
//                AppRoutes.ROUTE_SAMPLE_GARMENTS),
//          ])
//        ],
//      ),
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(<Widget>[
        _buildOrderMenu(context),
        Container(
          height: 10,
          color: Color.fromRGBO(245, 245, 245, 1),
        ),
        _buildCompanyMenu(context),
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
