import 'package:b2b_commerce/src/my/company/form/my_brand_base_form.dart';
import 'package:b2b_commerce/src/my/company/form/my_factory_base_form.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';
import 'package:core/core.dart';

import '../common/app_image.dart';
import '../common/app_keys.dart';
import '../common/app_routes.dart';

/// 生意
class BusinessHomePage extends StatefulWidget {
  BusinessHomePage({
    Key key,
  }) : super(key: AppKeys.businessHomePage);

  @override
  _BusinessHomePageState createState() => new _BusinessHomePageState();
}

class _BusinessHomePageState extends State<BusinessHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF7F7F7),
      child: Stack(children: [
        Positioned(
          top: 0,
          child: Image.asset(
            'img/icons/b2b-v2/workspace/bg@3x.png',
            package: 'assets',
            fit: BoxFit.cover,
            height: 210,
            width: MediaQuery.of(context).size.width,
          ),
        ),
        Positioned(
            top: 56,
            left: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 8),
                    child: Icon(B2BIconsV2.workspace),
                  ),
                  Text('工作台',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ))
                ],
              ),
            )),
        Expanded(
            child: Container(
          margin: EdgeInsets.fromLTRB(12, (56.0 + 45), 12, 0),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [_Card1(), _Card2(), _Card3(), _Card4()],
          ),
        ))
      ]),
    );
  }
}

///生产管理
class _Card1 extends StatelessWidget {
  const _Card1({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BusinessReportState>(
        builder: (context, BusinessReportState state, _) {
      if (state.updateTime == null) {
        state.getData();
      }
      return _Card(
        title: '生产管理',
        child: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 24, bottom: 28),
                child: Row(
                  children: [
                    Expanded(
                        child: _Item(
                      title: '我的需求',
                      val: '${state.requirementCount ?? 0}',
                      onTap: () => _onNavigate(
                          context, AppRoutes.ROUTE_REQUIREMENT_ORDERS),
                    )),
                    Expanded(
                        child: _Item(
                      title: '我的报价',
                      val: '${state.quoteCount ?? 0}',
                      onTap: () => _onNavigate(context, AppRoutes.ROUTE_QUOTES),
                    )),
                    Expanded(
                        child: _Item(
                      title: '订单数',
                      val: '${state.orderCount ?? 0}',
                      onTap: () => _onNavigate(
                          context, AppRoutes.ROUTE_EXTERNAL_SALE_ORDERS),
                    )),
                  ],
                ),
              ),
              _Divider(),
              Container(
                margin: EdgeInsets.symmetric(vertical: 28),
                child: Row(
                  children: [
                    Expanded(
                        child: _Item(
                      title: '合同数',
                      val: '${state.agreementCount ?? 0}',
                      onTap: () =>
                          _onNavigate(context, AppRoutes.ROUTE_MY_CONTRACT),
                    )),
                    Expanded(
                        child: _Item(
                      title: '待付款',
                      val: '${state.pendingPayCount ?? 0}',
                      onTap: () =>
                          _onNavigate(context, AppRoutes.ROUTE_OUT_ORDERS),
                    )),
                    Expanded(
                        child: _Item(
                      title: '生产中',
                      val: '${state.productionCount ?? 0}',
                      onTap: () => _onNavigate(
                          context, AppRoutes.ROUTE_PRODUCTION_TASK_ORDERS),
                    )),
                  ],
                ),
              ),
              _Divider(),
              Container(
                margin: EdgeInsets.symmetric(vertical: 28),
                child: Row(
                  children: [
                    Expanded(
                        child: _Item(
                      title: '待收货',
                      val: '0',
                    )),
                    Expanded(
                        child: _Item(
                      title: '代发货',
                      val: '0',
                    )),
                    Expanded(
                        child: _Item(
                      title: '已完成',
                      val: '0',
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _onNavigate(BuildContext context, String route) {
    Navigator.of(context).pushNamed(route);
  }
}

///店铺管理
class _Card2 extends StatelessWidget {
  const _Card2({Key key}) : super(key: key);

  static double itemHeight = 50;

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: '店铺管理',
      margin: EdgeInsets.only(top: 12),
      child: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 24, bottom: 28),
              child: Row(
                children: [
                  Expanded(
                      child: _Item(
                    height: itemHeight,
                    title: '商品管理',
                    child: B2BV2Image.goods(width: 28, height: 28),
                    onTap: () =>
                        _onNavigate(context, AppRoutes.ROUTE_SAMPLE_PRODUCTS),
                  )),
                  Expanded(
                      child: _Item(
                    height: itemHeight,
                    title: '店铺介绍',
                    child: B2BV2Image.shop(width: 28, height: 28),
                    onTap: () => _onIntroduction(context),
                  )),
                  Expanded(
                      child: _Item(
                    title: '用户管理',
                    height: itemHeight,
                    child: B2BV2Image.user(width: 28, height: 28),
                    onTap: () =>
                        _onNavigate(context, AppRoutes.ROUTE_COOPERATORS),
                  )),
                ],
              ),
            ),
            _Divider(),
            Container(
              margin: EdgeInsets.symmetric(vertical: 28),
              child: Row(
                children: [
                  Expanded(
                      child: _Item(
                    title: '店铺订单',
                    height: itemHeight,
                    child: B2BV2Image.order(width: 28, height: 28),
                    onTap: () =>
                        _onNavigate(context, AppRoutes.ROUTE_OUT_ORDERS),
                  )),
                  Expanded(
                      child: _Item(
                    title: '对账单',
                    height: itemHeight,
                    child: B2BV2Image.bill(width: 28, height: 28),
                    onTap: () => _onNavigate(
                        context, AppRoutes.ROUTE_RECONCILIATION_ORDERS),
                  )),
                  Expanded(
                      child: _Item(
                    title: '发货处理',
                    height: itemHeight,
                    child: B2BV2Image.delivery(width: 28, height: 28),
                    onTap: () => _onNavigate(
                        context, AppRoutes.ROUTE_PRODUCTION_TASK_ORDERS),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onIntroduction(BuildContext context) {
    UserBLoC bloc = UserBLoC.instance;
    // 品牌详情
    if (bloc.currentUser.type == UserType.BRAND) {
      BotToast.showLoading(
          duration: Duration(milliseconds: 500), clickClose: true);
      UserRepositoryImpl().getBrand(bloc.currentUser.companyCode).then((brand) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyBrandBaseFormPage(brand)));
      });
    }
    // 工厂详情
    if (bloc.currentUser.type == UserType.FACTORY) {
      BotToast.showLoading(
          duration: Duration(milliseconds: 500), clickClose: true);
      UserRepositoryImpl()
          .getFactory(bloc.currentUser.companyCode)
          .then((value) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyFactoryBaseFormPage(
                      value,
                    )));
      });
    }
  }

  void _onNavigate(BuildContext context, String route) {
    Navigator.of(context).pushNamed(route);
  }
}

///店铺管理
class _Card3 extends StatelessWidget {
  const _Card3({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BusinessReportState>(
        builder: (context, BusinessReportState state, _) {
      if (state.updateTime == null) {
        state.getData();
      }
      return _Card(
        title: '外发管理',
        child: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 24, bottom: 28),
                child: Row(
                  children: [
                    Expanded(
                        child: _Item(
                      title: '订单数',
                      val: '${state.requirementCount ?? 0}',
                      onTap: () =>
                          _onNavigate(context, AppRoutes.ROUTE_OUT_ORDERS),
                    )),
                    Expanded(child: _Item(title: '待发货')),
                    Expanded(
                        child: _Item(
                      title: '已完成',
                      onTap: () =>
                          _onNavigate(context, AppRoutes.ROUTE_OUT_ORDERS),
                    )),
                  ],
                ),
              ),
              _Divider(),
              Container(
                margin: EdgeInsets.symmetric(vertical: 28),
                child: Row(
                  children: [
                    Expanded(child: _Item(title: '销售额')),
                    Expanded(child: _Item(title: '销售量')),
                    Expanded(child: Container()),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _onNavigate(BuildContext context, String route) {
    Navigator.of(context).pushNamed(route);
  }
}

///外发管理
class _Card4 extends StatelessWidget {
  const _Card4({Key key}) : super(key: key);

  static double itemHeight = 50;

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: '外发管理',
      margin: EdgeInsets.only(top: 12, bottom: 27),
      child: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 24, bottom: 28),
              child: Row(
                children: [
                  Expanded(
                      child: _Item(
                    height: itemHeight,
                    title: '外发订单',
                    child: B2BV2Image.order_1(width: 28, height: 28),
                    onTap: () => _onNavigate(
                        context, AppRoutes.ROUTE_REQUIREMENT_ORDERS),
                  )),
                  Expanded(
                      child: _Item(
                    height: itemHeight,
                    title: '外发生产工单',
                    child: B2BV2Image.order_2(width: 28, height: 28),
                    onTap: () => _onNavigate(context, AppRoutes.ROUTE_QUOTES),
                  )),
                  Expanded(
                      child: _Item(
                    title: '生产工单',
                    height: itemHeight,
                    child: B2BV2Image.order_3(width: 28, height: 28),
                    onTap: () => _onNavigate(
                        context, AppRoutes.ROUTE_EXTERNAL_SALE_ORDERS),
                  )),
                ],
              ),
            ),
            _Divider(),
            Container(
              margin: EdgeInsets.symmetric(vertical: 28),
              child: Row(
                children: [
                  Expanded(
                      child: _Item(
                    title: '出货单',
                    height: itemHeight,
                    child: B2BV2Image.order_4(width: 28, height: 28),
                    onTap: () => _onNavigate(
                        context, AppRoutes.ROUTE_EXTERNAL_SALE_ORDERS),
                  )),
                  Expanded(
                    child: Container(),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onNavigate(BuildContext context, String route) {
    Navigator.of(context).pushNamed(route);
  }
}

class _Card extends StatelessWidget {
  const _Card(
      {Key key, this.child, this.title, this.margin = const EdgeInsets.all(0)})
      : super(key: key);

  final Widget child;

  final String title;

  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: _body()),
    );
  }

  List<Widget> _body() {
    if (child != null) {
      return [_Title('$title'), child];
    }
    return [_Title('$title')];
  }
}

class _Title extends StatelessWidget {
  final String val;

  final double fontSize;

  const _Title(this.val, {Key key, this.fontSize = 15}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8),
      child: Column(
        children: [
          Text(
            '$val',
            style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFFED800),
                borderRadius: BorderRadius.circular(3)),
            height: 6,
            width: fontSize * val.length + 4,
          )
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final String val;

  final Widget child;

  final String title;

  final double height;

  final VoidCallback onTap;

  const _Item(
      {Key key,
      this.val = '0',
      this.title,
      this.height = 45,
      this.onTap,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            child ??
                Text(
                  '$val',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
            Text(
              '$title',
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: Color(0xFFE7E7E7),
    );
  }
}
