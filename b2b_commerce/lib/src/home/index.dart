import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

/// 网站主页
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('衣加衣首页'),
        leading: new IconButton(
          tooltip: '搜索',
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
      ),
      body: ListView(
        children: [
          HomeBannerSection(),
        ],
      ),
    );
  }
}

/// 首页Banner
class HomeBannerSection extends StatelessWidget {
  final List<MediaModel> items = <MediaModel>[
    MediaModel(
      'https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/lakes/images/lake.jpg',
    ),
    MediaModel(
      'https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/lakes/images/lake.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Carousel(items, 240);
  }
}
