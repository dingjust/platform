import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget _buildBanner(BuildContext context) {
    return SizedBox(
      height: 120.0,
      child: Card(
        // 阴影大小-默认2.0
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            // 横轴起始侧对齐
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Text('湛红波'),
              ),
              Divider(),
              Text('定制加（深圳）科技有限公司'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenus(BuildContext context) {
    Widget _buildMenu(Icon icon, String title) {
      return GestureDetector(
        onTap: null, // TODO: clickable
        child: Column(
          children: <Widget>[
            ListTile(
              leading: icon,
              title: Text(title),
              trailing: const Icon(Icons.chevron_right),
            ),
            Divider(),
          ],
        ),
      );
    }

    return Column(
      children: <Widget>[
        _buildMenu(Icon(Icons.supervised_user_circle), '用户'),
        _buildMenu(Icon(Icons.shopping_basket), '产品'),
        _buildMenu(Icon(Icons.shopping_cart), '订单'),
        _buildMenu(Icon(Icons.menu), '价格'),
        _buildMenu(Icon(Icons.menu), '营销'),
        _buildMenu(Icon(Icons.shop), '基础贸易'),
        _buildMenu(Icon(Icons.menu), '国际化'),
        _buildMenu(Icon(Icons.settings), '系统'),
        _buildMenu(Icon(Icons.settings), '设置'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          _buildBanner(context),
          _buildMenus(context),
        ],
      ),
    );
  }
}
