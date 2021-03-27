import 'package:b2b_commerce/src/business/orders/requirement/requirement_order_form.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/home/factory/finding_factory.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_umplus/flutter_umplus.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

class HomeReportSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeSectionState>(
        builder: (context, HomeSectionState state, _) => Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '衣报送',
                style: TextStyle(
                    color: Constants.THEME_COLOR_MAIN,
                    fontWeight: FontWeight.bold),
              ),
              Text('需求 ${state.requirementOrder ?? 0}'),
              Text('报价 ${state.quoteOrder ?? 0}'),
              Text('今日成交 12'),
            ],
          ),
        ));
  }
}

class HomeEntrance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 5),
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MultiProvider(
                            providers: [
                              ChangeNotifierProvider(
                                create: (_) => RequirementOrderFormState(),
                              ),
                            ],
                            child: Consumer(
                              builder: (context,
                                      RequirementOrderFormState state, _) =>
                                  RequirementOrderForm(
                                formState: state,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 250,
                      child: Image.asset(
                        'temp/index/index_requirement.jpg',
                        package: 'assets',
                        fit: BoxFit.cover,
                      ),
                    ))),
            Container(
              width: 5,
            ),
            Expanded(
                child: Container(
              height: 250,
              child: Column(
                children: [
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      //埋点>>>推荐工厂
                      FlutterUmplus.event(
                        "factory_finding_all",
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FindingFactoryPage(
                            FactoryCondition(
                                starLevel: 0,
                                adeptAtCategories: [],
                                labels: [],
                                cooperationModes: []),
                            route: '推荐工厂',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      child: Image.asset(
                        'temp/index/index_factory.jpg',
                        package: 'assets',
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
                  Container(
                    height: 5,
                  ),
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, AppRoutes.ROUTE_ORDER_PRODUCTS);
                    },
                    child: Container(
                      child: Image.asset(
                        'temp/index/index_products.jpg',
                        package: 'assets',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ))
                ],
              ),
            ))
          ],
        ));
  }
}

class ServiceFlow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 5),
              child: Text('服务流程'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _icon('temp/index/home_publish.png', '发布需求'),
                _arrow(),
                _icon('temp/index/home_factory.png', '匹配工厂'),
                _arrow(),
                _icon('temp/index/home_communite.png', '沟通方案'),
                _arrow(),
                _icon('temp/index/home_order.png', '创建订单'),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _icon('temp/index/home_contract.png', '签订合同'),
                  _arrow(),
                  _icon('temp/index/home_production.png', '研发生产'),
                  _arrow(),
                  _icon('temp/index/home_deliver.png', '出货对账'),
                  _arrow(),
                  _icon('temp/index/home_protect.png', '享受保障'),
                ],
              ),
            )
          ],
        ));
  }

  Widget _icon(String url, String label) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            url,
            package: 'assets',
            fit: BoxFit.fitWidth,
            width: 50,
          ),
          Text(
            '$label',
            style: TextStyle(color: Colors.grey, fontSize: 10),
          )
        ],
      ),
    );
  }

  Widget _arrow() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Image.asset(
        'temp/index/arrow.png',
        package: 'assets',
        width: 20,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
