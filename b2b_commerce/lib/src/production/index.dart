import 'package:b2b_commerce/src/home/factory/factory.dart';
import 'package:b2b_commerce/src/home/home_section.dart';
import 'package:b2b_commerce/src/production/production.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ProductionPage extends StatefulWidget {
  _ProductionPageState createState() => _ProductionPageState();
}

class _ProductionPageState extends State<ProductionPage> {
  GlobalKey _productionOrderBlocProviderKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<ProductionBLoC>(
        key: _productionOrderBlocProviderKey,
        bloc: ProductionBLoC.instance,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.5,
            title: HomeSearchInputBox(),
            brightness: Brightness.dark,
            actions: <Widget>[
              IconButton(
                padding: EdgeInsets.only(right: 20),
                icon: const Icon(B2BIcons.message),
                color: Colors.orange,
                tooltip: 'message',
                onPressed: () {},
              ),
            ],
          ),
          body: Scaffold(
            appBar: AppBar(
              elevation: 0.5,
              bottom: ProductionFilterBar(
                leading: IconButton(
                  icon: Icon(Icons.category),
                  onPressed: (){},
                ),
                entries: <FilterConditionEntry>[
                  FilterConditionEntry(
                      label: '综合', value: 'comprehensive', checked: true),
                  FilterConditionEntry(label: '星级', value: 'starLevel'),
                ],
                action: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {},
                ),
                streamController:
                    QuickReactionFactoryBLoC.instance.conditionController,
              ),
            ),
            body: ProductionListView(),
          ),
          floatingActionButton: SpeedDial(
            // animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(size: 22.0),
            // this is ignored if animatedIcon is non null
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '添加',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  '线下订单',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                )
              ],
            ),
            visible: true,
            curve: Curves.bounceIn,
            // overlayColor: Colors.black,
            overlayOpacity: 0.5,
            onOpen: () => print('OPENING DIAL'),
            onClose: () => print('DIAL CLOSED'),
            tooltip: 'Speed Dial',
            heroTag: 'speed-dial-hero-tag',
            // backgroundColor: Colors.orange,
            foregroundColor: Colors.black,
            elevation: 8.0,
            shape: CircleBorder(),
            children: [
              SpeedDialChild(
                child: Center(
                  child: Text(
                    '唯一码',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                backgroundColor: Colors.blue,
                onTap: () => print('SECOND CHILD'),
              ),
              SpeedDialChild(
                  child: Center(
                    child: Text(
                      '创建',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  backgroundColor: Colors.red,
                  onTap: () => print('FIRST CHILD')),
            ],
          ),
        ));
  }
}

class ProductionListView extends StatelessWidget {
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<ProductionBLoC>(context);

    return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        color: Colors.grey[200],
        child: RefreshIndicator(
          onRefresh: () async {
            return await bloc.refreshData();
          },
          child: ListView(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: RichText(
                      text: TextSpan(
                          text: '———',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                          children: <TextSpan>[
                            TextSpan(
                                text: '正在生产',
                                style: TextStyle(color: Colors.black)),
                            TextSpan(text: '———')
                          ]),
                    ),
                  )
                ],
              ),
              StreamBuilder<List<PurchaseOrderModel>>(
                  stream: bloc.stream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<PurchaseOrderModel>> snapshot) {
                    if (snapshot.data == null) {
                      bloc.getData();
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 200),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (snapshot.hasData) {
                      return Column(
                        children: snapshot.data.map((order) {
                          return ProductionItem(
                            order: order,
                          );
                        }).toList(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                  }),
              _buildRecommend(bloc)
            ],
          ),
        ));
  }

  Widget _buildRecommend(ProductionBLoC bloc) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: <Widget>[
          Container(
            width: 380,
            height: 150,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(
                      'http://dingjust.oss-cn-shenzhen.aliyuncs.com/%E5%BE%AE%E4%BF%A1%E5%9B%BE%E7%89%87_20190126151855.jpg'),
                  fit: BoxFit.cover,
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: RichText(
                  text: TextSpan(
                      text: '———',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                      children: <TextSpan>[
                        TextSpan(
                            text: '工厂推荐',
                            style: TextStyle(color: Colors.black)),
                        TextSpan(text: '———')
                      ]),
                ),
              )
            ],
          ),
          StreamBuilder<List<FactoryModel>>(
              stream: bloc.factoryStream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<FactoryModel>> snapshot) {
                if (snapshot.data == null) {
                  bloc.getRecommendFactories();
                  return Container();
                }
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.map((item) {
                      return FactoryItem(
                        model: item,
                      );
                    }).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
              })
        ],
      ),
    );
  }
}
