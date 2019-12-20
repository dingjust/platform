import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/home/factory/factory_item.dart';
import 'package:b2b_commerce/src/my/my_factory.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

class FactoryTabSection extends StatefulWidget {
  @override
  _FactoryTabSectionState createState() => _FactoryTabSectionState();
}

class _FactoryTabSectionState extends State<FactoryTabSection> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 700,
        child: ChangeNotifierProvider<FactoryTabSectionState>(
          builder: (context) => FactoryTabSectionState(),
          child: Scaffold(
              appBar: TabBar(
                onTap: (v){
                  print(v);
                },
                controller: _tabController,
                tabs: [
                  Tab(
                    child: Text('最新工厂'),
                  ),
                  Tab(
                    child: Text('热门工厂'),
                  )
                ],
                indicatorSize: TabBarIndicatorSize.label,
              ),
              body: TabBarView(
                physics: AlwaysScrollableScrollPhysics(),
                controller: _tabController,
                children: <Widget>[
                  NewFactoryListView(),
                  HotFactoryListView()
                ],
              )),
        ));
  }
}

class NewFactoryListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<FactoryTabSectionState>(
      builder: (context, FactoryTabSectionState state, _) => Container(
          child: Container(
        child: state.newFactories != null
            ? Column(
                children: state.newFactories
                    .map((factory) => _FactoryItem(
                          model: factory,
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
    return Consumer<FactoryTabSectionState>(
      builder: (context, FactoryTabSectionState state, _) => Container(
          child: Container(
        child: state.hotFactories != null
            ? Column(
                children: state.hotFactories
                    .map((factory) => _FactoryItem(
                          model: factory,
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

class _FactoryItem extends StatelessWidget {
  final FactoryModel model;

  final double height;

  const _FactoryItem({Key key, this.model, this.height = 120})
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  MyFactoryPage(
                    factoryUid: model.uid,
                    isFactoryDetail: true,
                  ),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ImageFactory.buildThumbnailImage(model.profilePicture,
                  size: 60, containerSize: 80),
              Expanded(
                flex: 1,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: Text(
                                  '${model.name}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          PopulationScaleText(model: model),
                          Expanded(
                            flex: 1,
                            child: CertifiedTagsAndLabelsText(model: model),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Opacity(
                            opacity: model.populationScale != null ? 1.0 : 0,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 0.5, color: Colors.grey[500])),
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              child: Center(
                                  child: Text(
                                '${PopulationScaleLocalizedMap[model.populationScale]}',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              )),
                            ),
                          ),
                          Opacity(
                            opacity: model.contactAddress.region.name != null
                                ? 1.0
                                : 0,
                            child: Text(
                              '${model.contactAddress.region.name ?? ''}${model.contactAddress.city.name ?? ''}',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: <Widget>[
                      //     Opacity(
                      //       opacity: model.contactAddress.region.name != null
                      //           ? 1.0
                      //           : 0,
                      //       child: Text(
                      //         '${model.contactAddress.region.name ?? ''}${model.contactAddress.city.name ?? ''}',
                      //         style: TextStyle(color: Colors.grey),
                      //       ),
                      //     )
                      //   ],
                      // )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
