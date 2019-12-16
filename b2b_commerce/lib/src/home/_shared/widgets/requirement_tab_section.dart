import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
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
                      NewFactoryListView(),
                      HotFactoryListView()
                    ],
                  )),
            )));
  }
}

class NewFactoryListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RequirementTabSectionState>(
      builder: (context, RequirementTabSectionState state, _) => Container(
          child: Container(
        child: state.newFactories != null
            ? Column(
                children: state.newFactories
                    .map((requirement) => _RequirementItem(
                          model: requirement,
                        ))
                    .toList(),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      )),
    );
  }
}

class HotFactoryListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RequirementTabSectionState>(
      builder: (context, RequirementTabSectionState state, _) => Container(
          child: Container(
        child: state.hotFactories != null
            ? Column(
                children: state.hotFactories
                    .map((requirement) => _RequirementItem(
                          model: requirement,
                        ))
                    .toList(),
              )
            : Center(
                child: CircularProgressIndicator(),
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
        onPressed: () {},
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${model.details.productName}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.access_time,
                          color: Colors.grey,
                        ),
                        Text('${DateExpress2Util.express(model.creationTime)}')
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
                    Text(model.belongTo.contactAddress.city != null
                        ? '${model.belongTo.contactAddress.city.name}${model.belongTo.contactAddress.cityDistrict.name}'
                        : '')
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
                              size: 30,
                              containerSize: 40),
                          Text('${model.belongTo.name}')
                        ],
                      ),
                    ),
                    Text('121KM')
                  ],
                )
              ],
            )),
      ),
    );
  }
}
