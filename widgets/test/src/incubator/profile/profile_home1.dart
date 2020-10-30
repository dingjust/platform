import 'package:flutter/material.dart';

class ProfileHomePage extends StatefulWidget {
  static const String routeName = '/contacts';

  @override
  ProfileHomePageState createState() => ProfileHomePageState();
}

class ProfileHomePageState extends State<ProfileHomePage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final double _appBarHeight = 256.0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> menus = <Widget>[
      _Menu(
        icon: Icons.shop_two,
        children: <Widget>[
          _MenuItem(
            onPressed: () {
              _scaffoldKey.currentState.showSnackBar(
                const SnackBar(
                  content: Text('TODO：打开需求订单列表页面'),
                ),
              );
            },
            title: '需求订单',
          ),
          Divider(),
          _MenuItem(
            onPressed: () {
              _scaffoldKey.currentState.showSnackBar(
                const SnackBar(
                  content: Text('TODO：打开销售订单列表页面'),
                ),
              );
            },
            title: '销售订单',
          ),
          Divider(),
          _MenuItem(
            onPressed: () {
              _scaffoldKey.currentState.showSnackBar(
                const SnackBar(
                  content: Text('TODO：打开生产订单列表页面'),
                ),
              );
            },
            title: '生产订单',
          ),
        ],
      ),
      _Menu(
        icon: Icons.settings,
        children: <Widget>[
          _MenuItem(
            onPressed: () {
              _scaffoldKey.currentState.showSnackBar(
                const SnackBar(
                  content: Text('TODO: 员工管理'),
                ),
              );
            },
            title: '员工管理',
          ),
          Divider(),
          _MenuItem(
            onPressed: () {
              _scaffoldKey.currentState.showSnackBar(
                const SnackBar(
                  content: Text('TODO：会员管理'),
                ),
              );
            },
            title: '会员管理',
          ),
          Divider(),
          _MenuItem(
            onPressed: () {
              _scaffoldKey.currentState.showSnackBar(
                const SnackBar(
                  content: Text('TODO：产品管理'),
                ),
              );
            },
            title: '产品管理',
          ),
          Divider(),
          _MenuItem(
            onPressed: () {
              _scaffoldKey.currentState.showSnackBar(
                const SnackBar(
                  content: Text('TODO：库存管理'),
                ),
              );
            },
            title: '库存管理',
          ),
          Divider(),
          _MenuItem(
            onPressed: () {
              _scaffoldKey.currentState.showSnackBar(
                const SnackBar(
                  content: Text('TODO：关于我们'),
                ),
              );
            },
            title: '关于我们',
          ),
          Divider(),
        ],
      ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: _appBarHeight,
            pinned: true,
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.create),
                tooltip: 'Edit',
                onPressed: () {
                  _scaffoldKey.currentState
                      .showSnackBar(const SnackBar(content: Text("Editing isn't supported in this screen.")));
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('湛红波'),
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
                        // gradient: LinearGradient(
                        //   begin: Alignment(0.0, -1.0),
                        //   end: Alignment(0.0, -0.4),
                        //   colors: <Color>[Color(0x60000000), Color(0x00000000)],
                        // ),
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
    );
  }
}

class _Menu extends StatelessWidget {
  const _Menu({Key key, this.icon, this.children}) : super(key: key);

  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: themeData.dividerColor))),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.subhead,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  width: 72.0,
                  child: Icon(icon, color: themeData.primaryColor)),
              Expanded(child: Column(children: children))
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  _MenuItem({Key key, this.title, this.onPressed})
      : assert(title.length > 1),
        super(key: key);

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    final List<Widget> rowChildren = <Widget>[
      Expanded(
        child: Text(title),
      )
    ];

    rowChildren.add(SizedBox(
      width: 72.0,
      child: IconButton(
        icon: Icon(Icons.chevron_right),
        color: themeData.primaryColor,
        onPressed: onPressed,
      ),
    ));

    return MergeSemantics(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: rowChildren,
      ),
    );
  }
}
