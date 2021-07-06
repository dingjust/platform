import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/home/factory/factory_page.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

/// 品牌 - 首页Tab部分1
// class BrandEntranceSection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final List<GridItem> items = <GridItem>[
//       GridItem(
//         title: '发布需求',
//         subTitle: '轻松找厂',
//         icon: B2BImage.requirement_publish(width: 75, height: 75),
//         authorizations: [Authorization.REQUIREMENT_ORDER_PUBLISH],
//         onPressed: () async {
//           // RequirementOrderModel requirementOrderModel = RequirementOrderModel(
//           //     details: RequirementInfoModel(), attachments: []);
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => MultiProvider(
//                 providers: [
//                   ChangeNotifierProvider(
//                     create: (_) => RequirementOrderFormState(),
//                   ),
//                 ],
//                 child: Consumer(
//                   builder: (context, RequirementOrderFormState state, _) =>
//                       RequirementOrderForm(
//                     formState: state,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//       GridItem(
//         title: '推荐工厂',
//         subTitle: '精品推选',
//         icon: B2BImage.recommend_factory(width: 75, height: 75),
//         onPressed: () async {
//           //埋点>>>推荐工厂
//           FlutterUmplus.event(
//             "factory_finding_all",
//           );

//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => FindingFactoryPage(
//                 FactoryCondition(
//                     starLevel: 0,
//                     adeptAtCategories: [],
//                     labels: [],
//                     cooperationModes: []),
//                 route: '推荐工厂',
//               ),
//             ),
//           );
//         },
//       ),
//     ];

//     return EasyGrid(items: items);
//   }

//   void _jumpToFastFactory(BuildContext context) async {
//     List<CategoryModel> categories =
//         await Provider.of<MajorCategoryState>(context).getMajorCategories();
//     List<LabelModel> labels =
//         await Provider.of<LabelState>(context).getLabels();
//     List<LabelModel> conditionLabels =
//         labels.where((label) => label.name == '快反工厂').toList();
//     labels = labels
//         .where((label) => label.group == 'FACTORY' || label.group == 'PLATFORM')
//         .toList();
//     labels.add(LabelModel(name: '已认证', id: 000000));
//     if (categories != null && labels != null) {
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) => FactoryPage(
//             FactoryCondition(
//                 starLevel: 0,
//                 adeptAtCategories: [],
//                 labels: conditionLabels,
//                 cooperationModes: []),
//             route: '快反工厂',
//             categories: categories,
//             labels: labels,
//           ),
//         ),
//       );
//     }
//   }
// }

/// 品牌 - 首页Tab部分2
class BrandButtonsSection extends StatelessWidget {
  const BrandButtonsSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[],
      ),
    );
  }

  ///生产找厂
  Widget _buildProductionFactory(BuildContext context) {
    return Expanded(
        flex: 1,
        child: ImageNumButton(
          image: B2BImage.productionFactory(),
          onPressed: () async {
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FactoryPage(
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
