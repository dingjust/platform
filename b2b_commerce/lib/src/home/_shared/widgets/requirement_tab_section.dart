import 'package:b2b_commerce/src/_shared/widgets/nodata_show.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/helper/certification_status.dart';
import 'package:b2b_commerce/src/home/_shared/widgets/distance_text.dart';
import 'package:b2b_commerce/src/my/company/form/my_brand_base_form.dart';
import 'package:b2b_commerce/src/my/company/form/my_factory_base_form.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

import 'orientations_text.dart';

class RequirementTabSection extends StatefulWidget {
  @override
  _RequirementTabSectionState createState() => _RequirementTabSectionState();
}

class _RequirementTabSectionState extends State<RequirementTabSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 670,
        child: DefaultTabController(
            length: 2,
            child: ChangeNotifierProvider<RequirementTabSectionState>(
              create: (context) => RequirementTabSectionState(),
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
      builder:
          (context, RequirementTabSectionState state, AmapState amapState, _) =>
              Container(
                  child: Container(
                      child: state.getNewRequirements() != null
                          ? Column(
                              children: state
                                  .getNewRequirements()
                                  .map((requirement) => RequirementItem(
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
                null
            ? Column(
                children: state
                    .getNearbyRequirements(
                        amapState.longitude, amapState.latitude)
                    .map((requirement) => RequirementItem(
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

class RequirementItem extends StatelessWidget {
  final RequirementOrderModel model;

  final double height;

  const RequirementItem({Key key, this.model, this.height = 120})
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
          Provider.of<CertificationStatusHelper>(context, listen: false)
              .oncheckProfile(
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
                        '${model.details.productName ?? '无标题'}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Text(
                              '${model.details.expectedMachiningQuantity}件',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          Text(
                            '${model.details.category.name}',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    DistanceText(
                      val: model.distance,
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: OrientationsText(
                        regions: model.details.productiveOrientations ?? [],
                      ),
                    ),
                    // Text(
                    //   model?.belongTo?.contactAddress?.city != null
                    //       ? '${model.belongTo.contactAddress.city.name}${model.belongTo.contactAddress.cityDistrict.name}'
                    //       : '',
                    //   style: TextStyle(
                    //       color: Color.fromRGBO(97, 95, 95, 1), fontSize: 14),
                    // )
                    // Expanded(
                    //   flex: 1,
                    //   child: Text(
                    //     '${model.belongTo.name}',
                    //     style: TextStyle(color: Color.fromRGBO(97, 95, 95, 1)),
                    //   ),
                    // ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.access_time,
                          color: Colors.grey,
                          size: 20,
                        ),
                        Text(
                          '${DateExpress2Util.express(model.creationTime)}',
                          style: TextStyle(
                              color: Color.fromRGBO(97, 95, 95, 1),
                              fontSize: 14),
                        )
                      ],
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }

  void jumpToDetailPage(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.ROUTE_REQUIREMENT,
        arguments: {'code': model.code});
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
