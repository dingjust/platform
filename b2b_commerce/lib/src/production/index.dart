import 'package:b2b_commerce/src/home/account/login.dart';
import 'package:b2b_commerce/src/home/pool/requirement_pool_all.dart';
import 'package:b2b_commerce/src/my/my_help.dart';
import 'package:b2b_commerce/src/production/production.dart';
import 'package:b2b_commerce/src/production/production_filter.dart';
import 'package:b2b_commerce/src/production/production_offline_order_from.dart';
import 'package:b2b_commerce/src/production/production_unique_code.dart';
import 'package:b2b_commerce/src/production/search_input.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

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
            elevation: 0,
            title: ProductionSearchInputBox(),
            brightness: Brightness.light,
            automaticallyImplyLeading: false,
            actions: <Widget>[
//              IconButton(
//                padding: EdgeInsets.only(right: 20),
//                icon: const Icon(B2BIcons.message),
//                color: Color.fromRGBO(255,214,12, 1),
//                tooltip: 'message',
//                onPressed: () {
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                      builder: (context) => MyClientServicesPage(),
//                    ),
//                  );
//                },
//              ),
            ],
          ),
          body: Scaffold(
            appBar: AppBar(
              title: ProductionFilterBar(
                leading: IconButton(
                  icon: Icon(null),
                  onPressed: () {},
                ),
                entries: <FilterConditionEntry>[
                  FilterConditionEntry(
                      label: '当前生产', value: 'producting', checked: true),
                  FilterConditionEntry(
                    label: '延期预警',
                    value: 'delayWarning',
//                    onRemind: true,
//                    remindNum: ''
                  ),
//                FilterConditionEntry(
//                  label: '已完成',
//                  value: 'complete',
//                )
                ],
                action: Container(),
                streamController: ProductionBLoC.instance.conditionController,
              ),
            ),
            endDrawer: Drawer(
              child: GestureDetector(
                child: ProductionFilterPage(
                  bloc: ProductionBLoC.instance,
                ),
                onTap: () {},
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
              children: <Widget>[
                Text(
                  '线下订单',
                  style: TextStyle(color: Colors.black, fontSize: 12),
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
            // backgroundColor: Color.fromRGBO(255,214,12, 1),
            foregroundColor: Colors.black,
            elevation: 8.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            children: [
              SpeedDialChild(
                child: Center(
                  child: Text(
                    '唯一码',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                backgroundColor: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductionUniqueCodePage(),
                    ),
                  );
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              SpeedDialChild(
                child: Center(
                  child: Text(
                    '创建',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                backgroundColor: Colors.red,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductionOfflineOrder(),
                    ),
                  );
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ],
          ),
        ));
  }
}

class ProductionListView extends StatelessWidget {
  ScrollController _scrollController = new ScrollController();

  ///当前选中条件
  FilterConditionEntry currentCondition = FilterConditionEntry(
      label: '当前生产', value: 'comprehensive', checked: true);

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<ProductionBLoC>(context);

    //监听筛选条件更改
    bloc.conditionStream.listen((condition) {
      this.currentCondition = condition;
      //清空数据
      bloc.clear();
    });

    return Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        color: Color.fromRGBO(242, 242, 242, 1),
        child: RefreshIndicator(
          onRefresh: () async {
            return await bloc.refreshData();
          },
          child: ListView(
            children: <Widget>[
              StreamBuilder<List<PurchaseOrderModel>>(
                  stream: bloc.stream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<PurchaseOrderModel>> snapshot) {
                    if (snapshot.data == null) {
                      if (UserBLoC.instance.currentUser.status ==
                          UserStatus.ONLINE) {
                        bloc.getData();
                        return ProgressIndicatorFactory
                            .buildPaddedProgressIndicator();
                      } else {
                        return LoginRemind();
                      }
                    }
                    if (snapshot.data.length <= 0) {
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 200),
                            child: Image.asset(
                              'temp/logo2.png',
                              package: 'assets',
                              width: 80,
                              height: 80,
                            ),
                          ),
                          Container(child: Text('您尚无在生产中的订单')),
                          Container(child: Text('点击右下角添加订单')),
                          Container(
                            child: FlatButton(
                              color: Color.fromRGBO(255, 214, 12, 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MyHelpPage()));
                              },
                              child: Text('如何创建订单？'),
                            ),
                          )
                        ],
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
              // _buildRecommend(bloc)
            ],
          ),
        ));
  }

//  Widget _buildRecommend(ProductionBLoC bloc) {
//    return Container(
//      color: Colors.white,
//      margin: EdgeInsets.only(top: 10),
//      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
//      child: Column(
//        children: <Widget>[
//          Container(
//            width: 380,
//            height: 150,
//            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
//            decoration: BoxDecoration(
//                borderRadius: BorderRadius.circular(10),
//                image: DecorationImage(
//                  image: NetworkImage(
//                      'http://dingjust.oss-cn-shenzhen.aliyuncs.com/%E5%BE%AE%E4%BF%A1%E5%9B%BE%E7%89%87_20190126151855.jpg'),
//                  fit: BoxFit.cover,
//                )),
//          ),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Center(
//                child: RichText(
//                  text: TextSpan(
//                      text: '———',
//                      style: TextStyle(fontSize: 25, color: Colors.grey),
//                      children: <TextSpan>[
//                        TextSpan(
//                            text: '推荐工厂',
//                            style:
//                                TextStyle(fontSize: 25, color: Colors.black)),
//                        TextSpan(text: '———')
//                      ]),
//                ),
//              )
//            ],
//          ),
//          StreamBuilder<List<FactoryModel>>(
//              stream: bloc.factoryStream,
//              builder: (BuildContext context,
//                  AsyncSnapshot<List<FactoryModel>> snapshot) {
//                if (snapshot.data == null) {
//                  bloc.getRecommendFactories();
//                  return Container();
//                }
//                if (snapshot.hasData) {
//                  return Column(
//                    children: snapshot.data.map((item) {
//                      return FactoryItem(
//                        model: item,
//                      );
//                    }).toList(),
//                  );
//                } else if (snapshot.hasError) {
//                  return Text('${snapshot.error}');
//                }
//              })
//        ],
//      ),
//    );
//  }
}

class LoginRemind extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(40, 200, 40, 0),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: <Widget>[
          Text('登录后，您将能随时查看订单生产进度，无需天天打电话询问。'),
          Container(
            width: 200,
            child: FlatButton(
              color: Color.fromRGBO(255, 214, 12, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              onPressed: () {
                Navigator.of(context).push(
                    (MaterialPageRoute(builder: (context) => B2BLoginPage())));
              },
              child: Text('登录'),
            ),
          )
        ],
      ),
    );
  }
}
