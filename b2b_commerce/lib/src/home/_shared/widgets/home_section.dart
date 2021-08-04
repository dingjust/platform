import 'package:b2b_commerce/src/business/orders/requirement/requirement_order_form.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/home/factory/factory_page.dart';
import 'package:b2b_commerce/src/home/factory/finding_factory.dart';
import 'package:b2b_commerce/src/home/pool/requirement_pool_all.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
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

class BrandHomeEntrance extends StatelessWidget {
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
                      UmengPlugin.onEvent(
                        'factory_finding_all',
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FindingFactoryPage(),
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

class FactoryHomeEntrance extends StatelessWidget {
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
                      Provider.of<MajorCategoryState>(context, listen: false)
                          .getMajorCategories()
                          .then((categories) {
                        if (categories != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RequirementPoolAllPage(
                                  categories: categories),
                            ),
                          );
                        }
                      });
                    },
                    child: Container(
                      height: 250,
                      child: Image.asset(
                        'temp/index/home_production_requirement.jpg',
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
                      Navigator.pushNamed(
                          context, AppRoutes.ROUTE_PUBLISH_CENTER);
                    },
                    child: Container(
                      child: Image.asset(
                        'temp/index/home_publish_infos.jpg',
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
        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                // _icon('temp/index/home_order.png', '创建订单'),
                // _arrow(),
                // _icon('temp/index/home_contract.png', '签订合同'),
                // _arrow(),
                // _icon('temp/index/home_production.png', '研发生产'),
                // _arrow(),
                // _icon('temp/index/home_deliver.png', '出货对账'),
                UserBLoC.instance.currentUser.type == UserType.BRAND
                    ? HomeAssetsBtn(
                        label: '创建订单',
                        url: 'temp/index/home_order.png',
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(AppRoutes.ROUTE_OUT_ORDERS);
                        },
                      )
                    : HomeAssetsBtn(
                        label: '承接订单',
                        url: 'temp/index/home_order.png',
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(AppRoutes.ROUTE_EXTERNAL_SALE_ORDERS);
                        },
                      ),
                _arrow(),
                HomeAssetsBtn(
                  label: '签订合同',
                  url: 'temp/index/home_contract.png',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.ROUTE_MY_CONTRACT);
                  },
                ),
                _arrow(),
                HomeAssetsBtn(
                  label: '研发生产',
                  url: 'temp/index/home_production.png',
                  onTap: () {
                    Navigator.pushNamed(
                        context,
                        UserBLoC.instance.currentUser.type == UserType.BRAND
                            ? AppRoutes.ROUTE_OUT_PRODUCTION_TASK_ORDERS
                            : AppRoutes.ROUTE_PRODUCTION_TASK_ORDERS);
                  },
                ),
                _arrow(),
                HomeAssetsBtn(
                  label: '出货对账',
                  url: 'temp/index/home_deliver.png',
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(AppRoutes.ROUTE_RECONCILIATION_ORDERS);
                  },
                ),
              ],
            ),
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

///品牌按钮组
class BrandBtnsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          HomeAssetsBtn(
            url: 'temp/index/nearby_factory.png',
            label: '就近找厂',
            onTap: () async {
              List<CategoryModel> categories =
                  await Provider.of<MajorCategoryState>(context, listen: false)
                      .getMajorCategories();
              List<LabelModel> labels =
                  await Provider.of<LabelState>(context, listen: false)
                      .getLabels();
              labels = labels
                  .where((label) =>
                      label.group == 'FACTORY' || label.group == 'PLATFORM')
                  .toList();
              if (categories != null && labels != null) {
                //埋点>>>就近找厂
                UmengPlugin.onEvent('factory_finding_location');

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FactoryPage(
                      FactoryCondition(
                          starLevel: 0,
                          adeptAtCategories: [],
                          labels: [],
                          cooperationModes: []),
                      route: '就近找厂',
                      categories: categories,
                      labels: labels,
                    ),
                  ),
                );
              }
            },
          ),
          HomeAssetsBtn(
            url: 'temp/index/free_capacity.png',
            label: '空闲产能',
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.ROUTE_CAPACITY_MATCHING);
            },
          ),
          HomeAssetsBtn(
            url: 'temp/index/quote_process.png',
            label: '报价处理',
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.ROUTE_QUOTES);
            },
          ),
          HomeAssetsBtn(
            url: 'temp/index/requirement.png',
            label: '我的需求',
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.ROUTE_REQUIREMENT_ORDERS);
            },
          ),
        ],
      ),
    );
  }
}

///工厂按钮组
class FactoryBtnsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      // color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          HomeAssetsBtn(
            url: 'temp/index/material.png',
            label: '转包/裁片',
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.ROUTE_SUBCONTRACTS_POOL);
            },
          ),
          HomeAssetsBtn(
            url: 'temp/index/free_capacity.png',
            label: '空闲产能',
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.ROUTE_CAPACITY_MATCHING);
            },
          ),
          // HomeAssetsBtn(
          //   url: 'temp/index/materiel_products.png',
          //   label: '面辅料',
          //   onTap: () {
          //     Navigator.pushNamed(context, AppRoutes.ROUTE_MATERIEL_PRODUCTS);
          //   },
          // ),
          HomeAssetsBtn(
            url: 'temp/index/production_factory.png',
            label: '生产找厂',
            onTap: () {
              //埋点>>>推荐工厂
              // UmengPlugin.onEvent('factory_finding_all');

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FindingFactoryPage(),
                ),
              );
            },
          ),
          HomeAssetsBtn(
            url: 'temp/index/quote_process.png',
            label: '我的报价',
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.ROUTE_QUOTES);
            },
          ),
        ],
      ),
    );
  }
}

class HomeAssetsBtn extends StatelessWidget {
  final String url;

  final String label;

  final Function onTap;

  final String package;

  const HomeAssetsBtn(
      {Key key, this.url, this.label, this.onTap, this.package = 'assets'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) onTap.call();
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              url,
              package: package,
              fit: BoxFit.fitWidth,
              width: 50,
            ),
            Text(
              '$label',
              style: TextStyle(color: Colors.grey, fontSize: 10),
            )
          ],
        ),
      ),
    );
  }
}

///首页按钮
class HomeBtnsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24),
      color: Color(0xffF7F7F7),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // HomeAssetsBtn(
            //   url: 'temp/index/free_capacity.png',
            //   label: '空闲产能',
            //   onTap: () {
            //     Navigator.pushNamed(context, AppRoutes.ROUTE_CAPACITY_MATCHING);
            //   },
            // ),
            HomeAssetsBtn(
              url: 'img/icons/b2b-v2/main/tab_8@2x.png',
              label: '我的需求',
              onTap: () {
                Navigator.pushNamed(
                    context, AppRoutes.ROUTE_REQUIREMENT_ORDERS);
              },
            ),
            HomeAssetsBtn(
              url: 'img/icons/b2b-v2/main/tab_2@2x.png',
              label: '我的报价',
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.ROUTE_QUOTES);
              },
            ),
            HomeAssetsBtn(
              url: 'img/icons/b2b-v2/main/tab_3@2x.png',
              label: '离我最近',
              onTap: () async {
                Navigator.of(context)
                    .pushNamed(AppRoutes.ROUTE_REQUIREMENT_ORDERS_NEARBY);
              },
            ),
            HomeAssetsBtn(
              url: 'img/icons/b2b-v2/main/tab_4@2x.png',
              label: '推荐工厂',
              onTap: () {
                //埋点>>>推荐工厂
                UmengPlugin.onEvent(
                  'factory_finding_all',
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FindingFactoryPage(),
                  ),
                );
              },
            ),
          ],
        ),
        Container(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            HomeAssetsBtn(
              label: '我的订单',
              url: 'img/icons/b2b-v2/main/tab_7@2x.png',
              onTap: () {
                if (UserBLoC.instance.currentUser.type == UserType.BRAND) {
                  Navigator.of(context).pushNamed(AppRoutes.ROUTE_OUT_ORDERS);
                } else {
                  Navigator.of(context)
                      .pushNamed(AppRoutes.ROUTE_EXTERNAL_SALE_ORDERS);
                }
              },
            ),
            HomeAssetsBtn(
              label: '我的合同',
              url: 'img/icons/b2b-v2/main/tab_6@2x.png',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.ROUTE_MY_CONTRACT);
              },
            ),
            HomeAssetsBtn(
              label: '生产进度',
              url: 'img/icons/b2b-v2/main/tab_1@2x.png',
              onTap: () {
                Navigator.pushNamed(
                    context,
                    UserBLoC.instance.currentUser.type == UserType.BRAND
                        ? AppRoutes.ROUTE_OUT_PRODUCTION_TASK_ORDERS
                        : AppRoutes.ROUTE_PRODUCTION_TASK_ORDERS);
              },
            ),
            HomeAssetsBtn(
              label: '财务对账',
              url: 'img/icons/b2b-v2/main/tab_5@2x.png',
              onTap: () {
                Navigator.of(context)
                    .pushNamed(AppRoutes.ROUTE_RECONCILIATION_ORDERS);
              },
            ),
          ],
        ),
      ]),
    );
  }
}
