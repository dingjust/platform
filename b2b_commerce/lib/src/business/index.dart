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
                buildChild(context, MenuItemImage.saleOrder, '面料需求',
                    AppRoutes.ROUTE_FABRIC_REQUIREMENT,
                    authorizations: [Authorization.PURCHASE_ORDER]),
                buildChild(context, MenuItemImage.externalOrder, '外接订单',
                    AppRoutes.ROUTE_EXTERNAL_SALE_ORDERS,
                    authorizations: [Authorization.PURCHASE_ORDER]),
                buildChild(
                  context,
                  MenuItemImage.reconciliation,
                  '对账单',
                  AppRoutes.ROUTE_RECONCILIATION_ORDERS,
                )
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
                buildChild(
                    context,
                    MenuItemImage.productFactory,
                    '产品管理',
                    UserBLoC.instance.currentUser.type == UserType.FACTORY
                        ? AppRoutes.ROUTE_PRODUCTS
                        : AppRoutes.ROUTE_PRODUCTS_BRAND,
                    authorizations: [Authorization.PRODUCT]),
                //  buildChild(context, MenuItemImage.employeeManage, '员工管理',
                //      AppRoutes.ROUTE_EMPLOYEES),
                buildChild(context, MenuItemImage.partnerFactory, '合作商管理',
                    AppRoutes.ROUTE_COOPERATORS,
                    authorizations: [Authorization.COMPANY_COOPERATOR]),
                buildChild(context, MenuItemImage.clothesManage, '样衣借还',
                    AppRoutes.ROUTE_SAMPLE_GARMENTS,
                    authorizations: [Authorization.PRODUCT_SAMPLEPRODUCT]),
              ],
            )
          ],
        ));
  }

  Widget _buildOutOrderMenu(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                '外发管理',
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
                buildChild(context, MenuItemImage.outboundOrder, '外发订单',
                    AppRoutes.ROUTE_OUT_ORDERS),
              ],
            )
          ],
        ));
  }

  Widget _buildProductionOrderMenu(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                '生产管理',
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
                buildChild(context, MenuItemImage.productFactory, '生产工单',
                    AppRoutes.ROUTE_PRODUCTION_TASK_ORDERS),
                buildChild(context, MenuItemImage.delivery, '出货单',
                    AppRoutes.ROUTE_DELIVERY_ORDERS),
              ],
            ),
          ],
        ));
  }

  Widget buildChild(
      BuildContext context, Image image, String title, String routeTo,
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
        Container(
          height: 10,
          color: Color.fromRGBO(245, 245, 245, 1),
        ),
        _buildOutOrderMenu(context),
        Container(
          height: 10,
          color: Color.fromRGBO(245, 245, 245, 1),
        ),
        _buildProductionOrderMenu(context)
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
                buildChild(context, MenuItemImage.requirementOrder, '需求订单',
                    AppRoutes.ROUTE_REQUIREMENT_ORDERS,
                    authorizations: [Authorization.REQUIREMENT_ORDER]),
                buildChild(context, MenuItemImage.priceManage, '我的报价',
                    AppRoutes.ROUTE_MY_QUOTES,
                    authorizations: [Authorization.QUOTE_ORDER]),
                buildChild(context, MenuItemImage.priceManage, '报价处理',
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
                buildChild(context, MenuItemImage.saleOrder, '面料需求',
                    AppRoutes.ROUTE_FABRIC_REQUIREMENT,
                    authorizations: [Authorization.PURCHASE_ORDER]),
                buildChild(context, MenuItemImage.externalOrder, '外接订单',
                    AppRoutes.ROUTE_EXTERNAL_SALE_ORDERS,
                    authorizations: [Authorization.PURCHASE_ORDER]),
                buildChild(context, MenuItemImage.reconciliation, '对账单',
                    AppRoutes.ROUTE_RECONCILIATION_ORDERS),
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
                    AppRoutes.ROUTE_COOPERATORS,
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

  Widget _buildOutOrderMenu(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                '外发管理',
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
                buildChild(context, MenuItemImage.outboundOrder, '外发订单',
                    AppRoutes.ROUTE_OUT_ORDERS),
              ],
            )
          ],
        ));
  }

  Widget _buildProductionOrderMenu(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                '生产管理',
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
                buildChild(context, MenuItemImage.productFactory, '生产工单',
                    AppRoutes.ROUTE_PRODUCTION_TASK_ORDERS),
                buildChild(context, MenuItemImage.delivery, '出货单',
                    AppRoutes.ROUTE_DELIVERY_ORDERS),
              ],
            )
          ],
        ));
  }

  Widget buildChild(
      BuildContext context, Image image, String title, String routeTo,
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
        Container(
          height: 10,
          color: Color.fromRGBO(245, 245, 245, 1),
        ),
        _buildOutOrderMenu(context),
        Container(
          height: 10,
          color: Color.fromRGBO(245, 245, 245, 1),
        ),
        _buildProductionOrderMenu(context)
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
