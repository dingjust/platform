import 'package:b2b_commerce/src/business/orders/requirement/requirement_order_form.dart';
import 'package:b2b_commerce/src/business/orders/requirement_order_from.dart';
import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/home/pool/requirement_pool_all.dart';
import 'package:b2b_commerce/src/home/pool/requirement_pool_recommend.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class FactoryButtonsSection extends StatelessWidget {
  const FactoryButtonsSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      color: Colors.white,
      child: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildRequirementCenter(context),
                  _buildMaterial(context),
                  _buildContractManage(context),
                  _buildOrderCoordination(context),
                  _builRequirement(context),
                  _buildPublishRequirement(context),
                ],
              ),
            ],
          )),
    );
  }

  Widget _buildRequirementCenter(BuildContext context) {
    return Expanded(
      flex: 1,
      child: ImageNumButton(
        image: B2BImage.requirementCenter(),
        imagePadding: EdgeInsets.all(10),
        onPressed: () async {
          Provider.of<MajorCategoryState>(context)
              .getMajorCategories()
              .then((categories) {
            if (categories != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      RequirementPoolAllPage(categories: categories),
                ),
              );
            }
          });
        },
        title: '需求中心',
      ),
    );
  }

  Widget _buildMaterial(BuildContext context) {
    return Expanded(
        flex: 1,
        child: ImageNumButton(
          image: B2BImage.material(),
          imagePadding: EdgeInsets.all(10),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.ROUTE_SUBCONTRACTS_POOL);
          },
          title: '转包/裁片',
        ));
  }

  Widget _buildContractManage(BuildContext context) {
    return Expanded(
        flex: 1,
        child: ImageNumButton(
          image: B2BImage.contractManage(),
          imagePadding: EdgeInsets.all(10),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.ROUTE_MY_CONTRACT);
          },
          title: '合同管理',
          // number: 2,
          // showNum: true,
        ));
  }

  Widget _buildOrderCoordination(BuildContext context) {
    return Expanded(
        flex: 1,
        child: ImageNumButton(
          image: B2BImage.orderCoordination(),
          imagePadding: EdgeInsets.all(10),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.ROUTE_ORDER_COORDINATION);
          },
          title: '订单协同',
        ));
  }

  Widget _builRequirement(BuildContext context) {
    return Expanded(
        flex: 1,
        child: ImageNumButton(
          image: B2BImage.requirement(),
          imagePadding: EdgeInsets.all(10),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.ROUTE_SUBCONTRACTS_MINE);
          },
          title: '我的发布',
        ));
  }
  Widget _buildPublishRequirement(BuildContext context) {
    return Expanded(
        flex: 1,
        child: ImageNumButton(
          image: B2BImage.requirement(),
          imagePadding: EdgeInsets.all(10),
          onPressed: () {
//            Navigator.pushNamed(context, AppRoutes.ROUTE_SUBCONTRACTS_MINE);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      builder: (_) => RequirementOrderFormState(),
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
          title: '发布需求',
        ));
  }
}

class FactoryEntranceSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<GridItem> items = <GridItem>[
      GridItem(
        title: '发布中心',
        subTitle: '裁片外发',
        icon: B2BImage.requirement_publish(width: 75, height: 75),
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.ROUTE_PUBLISH_CENTER);
        },
      ),
      GridItem(
        title: '推荐需求',
        subTitle: '精准匹配',
        icon: B2BImage.recommend_requirement(width: 65, height: 65),
        onPressed: () async {
          Provider.of<MajorCategoryState>(context)
              .getMajorCategories()
              .then((categories) {
            if (categories != null) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      RequirementPoolRecommend(
                        categories: categories,
                      )));
            }
          });
        },
      ),

    ];

    return EasyGrid(items: items);
  }
}

class FactoryReportSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '衣报送',
            style: TextStyle(
                color: Constants.THEME_COLOR_MAIN, fontWeight: FontWeight.bold),
          ),
          Text('接单工厂 556'),
          Text('正在报价 216'),
          Text('今日成交 12'),
        ],
      ),
    );
  }
}
