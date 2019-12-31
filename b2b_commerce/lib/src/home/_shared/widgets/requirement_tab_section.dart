import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/_shared/widgets/nodata_show.dart';
import 'package:b2b_commerce/src/business/orders/requirement_order_detail.dart';
import 'package:b2b_commerce/src/helper/certification_status.dart';
import 'package:b2b_commerce/src/my/company/form/my_brand_base_form.dart';
import 'package:b2b_commerce/src/my/company/form/my_factory_base_form.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

class RequirementTabSection extends StatefulWidget {
  @override
  _RequirementTabSectionState createState() => _RequirementTabSectionState();
}

class _RequirementTabSectionState extends State<RequirementTabSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 700,
        child: DefaultTabController(
            length: 2,
            child: ChangeNotifierProvider<RequirementTabSectionState>(
              builder: (context) => RequirementTabSectionState(),
              child: Scaffold(
                  appBar: TabBar(
                    tabs: [
                      Tab(
                        child: Text('最新需求'),
                      ),
                      Tab(
                        child: Text('附近需求'),
                      )
                    ],
                    indicatorSize: TabBarIndicatorSize.label,
                  ),
                  body: TabBarView(
                    children: <Widget>[
                      NewRequirementsListView(),
                      NearbyRequirementsListView()
                    ],
                  )),
            )));
  }
}

class NewRequirementsListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<RequirementTabSectionState, AmapState>(
      builder: (context, RequirementTabSectionState state, AmapState amapState,
          _) =>
          Container(
              child: Container(
                  child: state.getNewRequirements(
                      amapState.longitude, amapState.latitude) !=
                      null &&
                      amapState.getAMapLocation() != null
                      ? Column(
                    children: state
                        .getNewRequirements(
                        amapState.longitude, amapState.latitude)
                        .map((requirement) =>
                        _RequirementItem(
                          model: requirement,
                        ))
                        .toList(),
                  )
                      : Column(
                    children: <Widget>[NoDataShow()],
                  ))),
    );
  }
}

class NearbyRequirementsListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<RequirementTabSectionState, AmapState>(
      builder:
          (context, RequirementTabSectionState state, AmapState amapState, _) =>
          Container(
              child: Container(
                child: state.getNearbyRequirements(
                    amapState.longitude, amapState.latitude) !=
                    null &&
                    amapState.getAMapLocation() != null
            ? Column(
                  children: state
                      .getNearbyRequirements(
                      amapState.longitude, amapState.latitude)
                    .map((requirement) => _RequirementItem(
                          model: requirement,
                        ))
                    .toList(),
              )
                    : Column(
                  children: <Widget>[NoDataShow()],
              ),
      )),
    );
  }
}

class _RequirementItem extends StatelessWidget {
  final RequirementOrderModel model;

  final double height;

  const _RequirementItem({Key key, this.model, this.height = 120})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[300], width: 0.6),
        ),
      ),
      child: FlatButton(
        onPressed: () {
          Provider.of<CertificationStatusHelper>(context).oncheckProfile(
              context: context, onJump: () => jumpToDetailPage(context));
        },
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${model.details.productName ?? ''}',
                        style: TextStyle(fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.access_time,
                          color: Colors.grey,
                          size: 20,
                        ),
                        Text(
                          '${DateExpress2Util.express(model.creationTime)}',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        )
                      ],
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: <Widget>[
                          Text('${model.details.category.name}'),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                                '${model.details.expectedMachiningQuantity}件'),
                          )
                        ],
                      ),
                    ),
                    Text(
                      model.belongTo.contactAddress.city != null
                          ? '${model.belongTo.contactAddress.city.name}${model
                          .belongTo.contactAddress.cityDistrict.name}'
                          : '',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: <Widget>[
                          ImageFactory.buildThumbnailImage(
                              model.belongTo.profilePicture,
                              size: 15,
                              containerSize: 25),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text('${model.belongTo.name}'),
                          )
                        ],
                      ),
                    ),
                    Text(
                      '${generateDistanceStr(model.distance)}',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }

  void jumpToDetailPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RequirementOrderDetailPage(model.code)));
  }

  void jumpToCompanyIntroduction(BuildContext context) {
    UserBLoC bloc = UserBLoC.instance;
    // 品牌详情
    if (bloc.currentUser.type == UserType.BRAND) {
      UserRepositoryImpl().getBrand(bloc.currentUser.companyCode).then((brand) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyBrandBaseFormPage(brand)));
      });
    }
    // 工厂详情
    if (bloc.currentUser.type == UserType.FACTORY) {
      UserRepositoryImpl()
          .getFactory(bloc.currentUser.companyCode)
          .then((factory) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MyFactoryBaseFormPage(
                  factory,
                ),
          ),
        );
      });
    }
  }

  String generateDistanceStr(double distance) {
    if (distance == null) {
      return '';
    }
    if (distance < 1000) {
      return '${distance}KM';
    } else {
      return '${(distance / 1000).toStringAsFixed(2)}KM';
    }
  }
}
