import 'package:b2b_commerce/src/common/app_keys.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../common/app_routes.dart';

class MyHomePage extends StatelessWidget {
  static const String ROUTE_SETTINGS = '/settings';
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final double _appBarHeight = 200.0;

  MyHomePage() :super(key: AppKeys.myHomePage);

  @override
  Widget build(BuildContext context) {
    final UserBLoC bloc = BLoCProvider.of<UserBLoC>(context);

    final List<Widget> menus = <Widget>[
      Menu('', <MenuItem>[
        MenuItem(Icons.account_box, '我的账户', AppRoutes.ROUTE_MY_ACCOUNT),
        MenuItem(Icons.business, '认证信息', AppRoutes.ROUTE_MY_COMPANY),
      ]),
      Menu('', <MenuItem>[
        MenuItem(Icons.pin_drop, '地址管理', AppRoutes.ROUTE_MY_ADDRESSES),
        MenuItem(Icons.collections, '发票管理', AppRoutes.ROUTE_MY_INVOICES),
//        MenuItem(Icons.shopping_cart, '购物车', AppRoutes.ROUTE_MY_CART),
      ]),
//      Menu('', <MenuItem>[
//
////        MenuItem(Icons.collections, '我的收藏', AppRoutes.ROUTE_MY_COLLECTIONS),
//      ]),
      Menu('', <MenuItem>[
        MenuItem(Icons.call, '联系客服', AppRoutes.ROUTE_MY_CLIENT_SERVICES),
        MenuItem(Icons.settings, '设置', AppRoutes.ROUTE_MY_SETTINGS),
      ]),
//      Menu('', <MenuItem>[
//
//      ]),
    ];

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: Colors.grey[200],
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: _appBarHeight,
              pinned: true,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.menu),
                  tooltip: 'Edit',
                  onPressed: () {
                    // http test
                    http$.get('/apparel-zh/users/13234', context: context).then((response) {});
//                    _scaffoldKey.currentState.showSnackBar(
//                      const SnackBar(
//                        content: Text('Editing isn\'t supported in this screen.'),
//                      ),
//                    );
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                key: const Key('__myHomeSpaceBar__'),
                title: StreamBuilder<UserModel>(
                  stream: bloc.stream,
                  initialData: bloc.currentUser,
                  builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
                    debugPrint('${snapshot.data.userType}');
                    return Container(
                      child: Column(
                        children: <Widget>[
                          Text(
                            '${snapshot.data.name}',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    );
                  },
                ),
                background: Stack(
//                  fit: StackFit.expand,
                  children: <Widget>[
                    _buildTopBackgroud(context),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(menus),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBackgroud(BuildContext context) {
    return Container(
//      constraints: BoxConstraints.expand(width: 300.0, height: 300.0,),
      child: Row(
        children: <Widget>[
          _buildPortrait(context),
          _buildInfomation(context),
        ],
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [ Color.fromRGBO(255, 80, 1, 1),Color.fromRGBO(255, 140, 0, 1)]),
      ),
    );
  }

  Widget _buildPortrait(BuildContext context){
    return Container(
      margin: EdgeInsets.fromLTRB(20, 20, 10, 10),
      child: Container(
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                'http://img.jf258.com/uploads/2015-05-14/030643325.jpg'
            ),
            radius: 40.0,
          ),
          decoration: BoxDecoration(
            border: new Border.all(
                color: Colors.white,
                width: 0.5
            ),
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.circular((50.0)),
          )
      ),
    );
  }

  Widget _buildInfomation(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 85),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 210,
              child: Row(
                children: <Widget>[
                  Container(
                      child:Text(
                        "欧阳娜娜",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      )
                  ),
                  Container(
                    padding: EdgeInsets.all(3),
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      '采购员',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Text(
                '定制加（深圳）科技有限公司',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white
                ),
              ),
            )
          ],
      ),
    );
  }

}