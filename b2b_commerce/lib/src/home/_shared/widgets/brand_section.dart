import 'package:b2b_commerce/src/business/orders/requirement/requirement_order_form.dart';
import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/home/factory/factory_page.dart';
import 'package:b2b_commerce/src/home/factory/finding_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_umplus/flutter_umplus.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

/// 品牌 - 首页Tab部分1
class BrandEntranceSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<GridItem> items = <GridItem>[
      GridItem(
        title: '发布需求',
        subTitle: '轻松找厂',
        icon: B2BImage.requirement_publish(width: 75, height: 75),
        authorizations: [Authorization.REQUIREMENT_ORDER_PUBLISH],
        onPressed: () async {
          // RequirementOrderModel requirementOrderModel = RequirementOrderModel(
          //     details: RequirementInfoModel(), attachments: []);
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
                  builder: (context, RequirementOrderFormState state, _) =>
                      RequirementOrderForm(
                    formState: state,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      GridItem(
        title: '推荐工厂',
        subTitle: '精品推选',
        icon: B2BImage.recommend_factory(width: 75, height: 75),
        onPressed: () async {
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
      ),
    ];

    return EasyGrid(items: items);
  }

  void _jumpToFastFactory(BuildContext context) async {
    List<CategoryModel> categories =
        await Provider.of<MajorCategoryState>(context).getMajorCategories();
    List<LabelModel> labels =
        await Provider.of<LabelState>(context).getLabels();
    List<LabelModel> conditionLabels =
        labels.where((label) => label.name == '快反工厂').toList();
    labels = labels
        .where((label) => label.group == 'FACTORY' || label.group == 'PLATFORM')
        .toList();
    labels.add(LabelModel(name: '已认证', id: 000000));
    if (categories != null && labels != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FactoryPage(
            FactoryCondition(
                starLevel: 0,
                adeptAtCategories: [],
                labels: conditionLabels,
                cooperationModes: []),
            route: '快反工厂',
            categories: categories,
            labels: labels,
          ),
        ),
      );
    }
  }
}

/// 品牌 - 首页Tab部分2
class BrandButtonsSection extends StatelessWidget {
  const BrandButtonsSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      color: Colors.white,
      child: Container(
          // color: Colors.white,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildProductionFactory(context),
                  _buildFreeCapacity(context),
                  _buildProductOrdering(context),
                  _buildNearbyFactory(context),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // _buildQualityFactory(context),
                  // _buildRequirementCenter(context),
                  _buildQuoteProcess(context),
                  _buildContractManage(context),
                  _buildOrderCoordination(context),
                  _builRequirement(context)
                ],
              ),
            ],
          )),
    );
  }

  Widget _buildProductionFactory(BuildContext context) {
    return Expanded(
        flex: 1,
        child: ImageNumButton(
          image: B2BImage.productionFactory(),
          onPressed: () async {
            List<CategoryModel> categories =
            await Provider.of<MajorCategoryState>(context)
                .getMajorCategories();
            List<LabelModel> labels =
            await Provider.of<LabelState>(context).getLabels();
            labels = labels
                .where((label) =>
            label.group == 'FACTORY' || label.group == 'PLATFORM')
                .toList();
            if (categories != null && labels != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FactoryPage(
                        FactoryCondition(
                            starLevel: 0,
                            adeptAtCategories: [],
                            labels: [],
                            cooperationModes: []),
                        route: '生产找厂',
                        categories: categories,
                        labels: labels,
                      ),
                ),
              );
            }
          },
          title: '生产找厂',
        ));
  }

  Widget _buildFreeCapacity(BuildContext context) {
    return Expanded(
      flex: 1,
      child: ImageNumButton(
        image: B2BImage.freeCapacity(),
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.ROUTE_CAPACITY_MATCHING);
        },
        title: '空闲产能',
      ),
    );
  }

  Widget _buildProductOrdering(BuildContext context) {
    return Expanded(
      flex: 1,
      child: ImageNumButton(
        image: B2BImage.materielProducts(),
        onPressed: () {
          // Navigator.pushNamed(context, AppRoutes.ROUTE_ORDER_PRODUCTS_INDEX);
          Navigator.pushNamed(context, AppRoutes.ROUTE_MATERIEL_PRODUCTS);
        },
        title: '面辅料',
      ),
    );
  }

  Widget _buildNearbyFactory(BuildContext context) {
    return Expanded(
      flex: 1,
      child: ImageNumButton(
        image: B2BImage.nearbyFactory(),
        onPressed: () async {
          List<CategoryModel> categories =
          await Provider.of<MajorCategoryState>(context)
              .getMajorCategories();
          List<LabelModel> labels =
          await Provider.of<LabelState>(context).getLabels();
          labels = labels
              .where((label) =>
          label.group == 'FACTORY' || label.group == 'PLATFORM')
              .toList();
          if (categories != null && labels != null) {
            //埋点>>>就近找厂
            FlutterUmplus.event(
              "factory_finding_location",
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    FactoryPage(
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
        title: '就近找厂',
      ),
    );
  }

  Widget _buildQualityFactory(BuildContext context) {
    return Expanded(
      flex: 1,
      child: ImageNumButton(
        image: B2BImage.qualityFactory(),
        onPressed: () async {
          List<CategoryModel> categories =
          await Provider.of<MajorCategoryState>(context)
              .getMajorCategories();
          List<LabelModel> labels =
          await Provider.of<LabelState>(context).getLabels();
          List<LabelModel> conditionLabels =
          labels.where((label) => label.name == '优选工厂').toList();
          labels = labels
              .where((label) =>
          label.group == 'FACTORY' || label.group == 'PLATFORM')
              .toList();
          labels.add(LabelModel(name: '已认证', id: 1000000));

          //埋点>>>优选工厂
          FlutterUmplus.event(
            "factory_finding_optimization",
          );

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FactoryPage(
                FactoryCondition(
                    starLevel: 0,
                    adeptAtCategories: [],
                    labels: conditionLabels,
                    cooperationModes: []),
                route: '优选工厂',
                categories: categories,
                labels: labels,
              ),
            ),
          );
        },
        title: '优选工厂',
      ),
    );
  }

  Widget _buildContractManage(BuildContext context) {
    return Expanded(
      flex: 1,
      child: ImageNumButton(
        image: B2BImage.contractManage(),
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.ROUTE_MY_CONTRACT);
        },
        title: '合同管理',
        // number: 2,
        // showNum: true,
      ),
    );
  }

  Widget _buildOrderCoordination(BuildContext context) {
    return Expanded(
      flex: 1,
      child: ImageNumButton(
        image: B2BImage.orderCoordination(),
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.ROUTE_ORDER_COORDINATION);
        },
        title: '订单协同',
      ),
    );
  }

  Widget _builRequirement(BuildContext context) {
    return Expanded(
      flex: 1,
      child: ImageNumButton(
        image: B2BImage.requirement(),
        onPressed: () {
          // Navigator.pushNamed(context, AppRoutes.ROUTE_FABRIC_PUBLISH);
          Navigator.pushNamed(context, AppRoutes.ROUTE_REQUIREMENT_ORDERS);
        },
        title: '我的需求',
      ),
    );
  }

  ///报价处理
  Widget _buildQuoteProcess(BuildContext context) {
    return Expanded(
      flex: 1,
      child: ImageNumButton(
        image: B2BImage.quoteProcess(),
        imagePadding: EdgeInsets.all(10),
        onPressed: () async {
          Navigator.of(context).pushNamed(AppRoutes.ROUTE_QUOTES);
        },
        title: '报价处理',
      ),
    );
  }

///需求中心
// Widget _buildRequirementCenter(BuildContext context) {
//   return Expanded(
//     flex: 1,
//     child: ImageNumButton(
//       image: B2BImage.requirementCenter(),
//       imagePadding: EdgeInsets.all(10),
//       onPressed: () async {
//         Provider.of<MajorCategoryState>(context)
//             .getMajorCategories()
//             .then((categories) {
//           if (categories != null) {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) =>
//                     RequirementPoolAllPage(categories: categories),
//               ),
//             );
//           }
//         });
//       },
//       title: '需求中心',
//     ),
//   );
// }
}
