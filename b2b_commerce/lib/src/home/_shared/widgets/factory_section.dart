import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/home/pool/requirement_pool_all.dart';
import 'package:b2b_commerce/src/home/pool/requirement_pool_recommend.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
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
                  _builRequirement(context)
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
            // Navigator.pushNamed(context, AppRoutes.ROUTE_CAPACITY_MATCHING);
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
            Navigator.pushNamed(context, AppRoutes.ROUTE_REQUIREMENT_ORDERS);
          },
          title: '我的发布',
        ));
  }
}

class FactoryEntranceSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<GridItem> items = <GridItem>[
      GridItem(
        title: '发布中心',
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.ROUTE_PUBLISH_CENTER);
        },
      ),
      GridItem(
        title: '推荐需求',
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
