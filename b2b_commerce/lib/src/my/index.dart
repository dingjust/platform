import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';
import '../common/app_routes.dart';

class MyHomePage extends StatefulWidget {
  static const String ROUTE_SETTINGS = '/settings';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  final double _appBarHeight = 256.0;

  @override
  Widget build(BuildContext context) {
    final bloc = LoginBlocProvider.of(context);

    final List<Widget> menus = <Widget>[
      Menu('', <MenuItem>[
        MenuItem(Icons.account_box, '我的账户', AppRoutes.ROUTE_MY_ACCOUNT),
        MenuItem(Icons.business, '认证信息', AppRoutes.ROUTE_MY_COMPANY),
      ]),
      Menu('', <MenuItem>[
        MenuItem(Icons.location_city, '地址管理', AppRoutes.ROUTE_MY_ADDRESSES),
        MenuItem(Icons.shopping_cart, '购物车', AppRoutes.ROUTE_MY_CART),
      ]),
      Menu('', <MenuItem>[
        MenuItem(Icons.collections, '发票管理', AppRoutes.ROUTE_MY_INVOICES),
        MenuItem(Icons.collections, '我的收藏', AppRoutes.ROUTE_MY_COLLECTIONS),
      ]),
      Menu('', <MenuItem>[
        MenuItem(Icons.call, '联系客服', AppRoutes.ROUTE_MY_CLIENT_SERVICES),
      ]),
      Menu('', <MenuItem>[
        MenuItem(Icons.settings, '设置', AppRoutes.ROUTE_MY_SETTINGS),
      ]),
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
                  icon: const Icon(Icons.create),
                  tooltip: 'Edit',
                  onPressed: () {
                    // http test
                    http$
                        .get('/apparel-zh/users/13234', context: context)
                        .then((response) {});
//                    _scaffoldKey.currentState.showSnackBar(
//                      const SnackBar(
//                        content: Text('Editing isn\'t supported in this screen.'),
//                      ),
//                    );
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: StreamBuilder<UserModel>(
                    stream: bloc.stream,
                    initialData: bloc.currentUser,
                    builder: (BuildContext context,
                        AsyncSnapshot<UserModel> snapshot) {
                      return Text(
                        '${snapshot.data.name}',
                        style: TextStyle(color: Colors.white),
                      );
                    }),
                background: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Image.asset(
                      'temp/lake.jpg',
                      package: 'assets',
                      fit: BoxFit.cover,
                      height: _appBarHeight,
                    ),
                    // This gradient ensures that the toolbar icons are distinct
                    // against the background image.
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.0, -1.0),
                          end: Alignment(0.0, -0.4),
                          colors: <Color>[Color(0x60000000), Color(0x00000000)],
                        ),
                      ),
                    ),
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
}
