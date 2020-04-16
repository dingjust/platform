import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/_shared/widgets/nodata_show.dart';
import 'package:b2b_commerce/src/helper/certification_status.dart';
import 'package:b2b_commerce/src/home/_shared/widgets/factory_widget.dart';
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

class _FactoryTabSectionState extends State<FactoryTabSection>
    with TickerProviderStateMixin {
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
                onTap: (v) {
                  print(v);
                },
                controller: _tabController,
                tabs: [
                  Tab(
                    child: Text('热门工厂'),
                  ),
                  Tab(
                    child: Text('最新工厂'),
                  ),
                ],
                indicatorSize: TabBarIndicatorSize.label,
              ),
              body: TabBarView(
                physics: AlwaysScrollableScrollPhysics(),
                controller: _tabController,
                children: <Widget>[
                  HotFactoryListView(),
                  NewFactoryListView(),
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
            : Column(
          children: <Widget>[NoDataShow()],
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
            : Column(
          children: <Widget>[NoDataShow()],
              ),
      )),
    );
  }
}

class _FactoryItem extends StatelessWidget {
  final FactoryModel model;

  final double height;

  const _FactoryItem({Key key, this.model, this.height = 130})
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
              children: <Widget>[
                _buildMainRow(),
                Container(
                  height: 10,
                ),
                _buildEndRow()
              ],
            )),
      ),
    );
  }

  Widget _buildMainRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 10),
          child: ImageFactory.buildThumbnailImage(model.profilePicture,
              size: 50, containerSize: 70),
        ),
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
                      child: Text(
                        '${model.name}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ApprovedTag(
                      model: model,
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '加工方式：',
                      style: TextStyle(color: Colors.black87),
                    ),
                    Expanded(child: Text('${getCooperationModesStr(model)}'))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '星 级：',
                      style: TextStyle(color: Colors.black87),
                    ),
                    Expanded(
                      child: StarLevelAndOrdersCountText(model: model),
                    )
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildEndRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '主营品类：',
          style: TextStyle(color: Colors.black87),
        ),
        Expanded(
            child:
            //     CategoriesText(
            //   model: model,
            // )
            Text(
              '${getCategoryStr(model)}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey),
            )),
        Opacity(
          opacity: model?.contactAddress?.region?.name != null ? 1.0 : 0,
          child: Text(
            '${model?.contactAddress?.region?.name ?? ''}${model?.contactAddress
                ?.city?.name ?? ''}',
            style: TextStyle(color: Colors.grey),
          ),
        )
      ],
    );
  }

  void jumpToDetailPage(BuildContext context) {
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
  }

  String getCooperationModesStr(FactoryModel model) {
    String result = '';
    model.cooperationModes.forEach((mode) {
      result = '$result ${CooperationModesLocalizedMap[mode]}';
    });
    return result;
  }

  String getCategoryStr(FactoryModel model) {
    String result = '';
    model.adeptAtCategories.forEach((category) {
      result = '$result ${category.name}';
    });
    return result;
  }
}
