import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/home/factory/factory_list.dart';
import 'package:b2b_commerce/src/home/product/order_product.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

/// 品牌 - 首页Tab部分1
class BrandFirstMenuSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<GridItem> items = <GridItem>[
      GridItem(
          title: '快反工厂',
          onPressed: () async {
            _jumpToFastFactory(context);
          },
          icon: B2BImage.fastFactory(width: 60, height: 80)),
      GridItem(
          title: '看款下单',
          onPressed: () async {
//            showDialog(
//                context: context,
//                barrierDismissible: false,
//                builder: (_) {
//                  return RequestDataLoading(
//                    requestCallBack: ProductRepositoryImpl()
//                        .cascadedCategories(),
//                    outsideDismiss: false,
//                    loadingText: '加载中。。。',
//                    entrance: '',
//                  );
//                }
//            ).then((value){
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductsPage(),
              ),
            );
//            });
          },
          icon: B2BImage.order(width: 60, height: 80)),
    ];

    return EasyGrid(items: items);
  }

  void _jumpToFastFactory(BuildContext context) async {
    List<CategoryModel> categories =
        await ProductRepositoryImpl().majorCategories();
    List<LabelModel> labels = await UserRepositoryImpl().labels();
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
class BrandSecondMenuSection extends StatelessWidget {
  const BrandSecondMenuSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      color: Colors.white,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildProductionFactory(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProductionFactory(BuildContext context) {
    return ImageNumButton(
      width: 55,
      height: 80,
      image: B2BImage.productionFactory(),
      onPressed: () {},
      title: '生产找厂',
    );
  }

  Widget _buildFreeCapacity(BuildContext context) {
    return ImageNumButton(
      width: 55,
      height: 80,
      image: B2BImage.freeCapacity(),
      onPressed: () {},
      title: '空闲产能',
    );
  }

  Widget _buildProductOrdering(BuildContext context) {
    return ImageNumButton(
      width: 55,
      height: 80,
      image: B2BImage.productOrdering(),
      onPressed: () {},
      title: '看款下单',
    );
  }

  Widget _buildNearbyFactory(BuildContext context) {
    return ImageNumButton(
      width: 55,
      height: 80,
      image: B2BImage.nearbyFactory(),
      onPressed: () {},
      title: '就近找厂',
    );
  }

  Widget _buildQualityFactory(BuildContext context) {
    return ImageNumButton(
      width: 55,
      height: 80,
      image: B2BImage.qualityFactory(),
      onPressed: () {},
      title: '优选工厂',
    );
  }

  Widget _buildContractManage(BuildContext context) {
    return ImageNumButton(
      width: 55,
      height: 80,
      image: B2BImage.contractManage(),
      onPressed: () {},
      title: '合同管理',
    );
  }

  // Widget _buildContractManage(BuildContext context) {
  //   return ImageNumButton(
  //     width: 55,
  //     height: 80,
  //     image: B2BImage.contractManage(),
  //     onPressed: () {},
  //     title: '合同管理',
  //   );
  // }

  void _jumpToQualityFactory(BuildContext context) async {
    List<CategoryModel> categories =
        await ProductRepositoryImpl().majorCategories();
    List<LabelModel> labels = await UserRepositoryImpl().labels();
    List<LabelModel> conditionLabels =
        labels.where((label) => label.name == '优选工厂').toList();
    labels = labels
        .where((label) => label.group == 'FACTORY' || label.group == 'PLATFORM')
        .toList();
    labels.add(LabelModel(name: '已认证', id: 1000000));
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
  }
}
