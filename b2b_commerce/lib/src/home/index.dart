import 'package:b2b_commerce/src/common/app_keys.dart';
import 'package:b2b_commerce/src/home/quick_reaction_factory.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

/// 网站主页
class HomePage extends StatefulWidget {
  HomePage() : super(key: AppKeys.homePage);

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
          RaisedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => QuickReactionFactoryPage()));
            },
            child: Text('快反工厂'),
          )
        ],
      ),
    );
  }
}

/// 首页Banner
class HomeBannerSection extends StatelessWidget {
  final List<MediaModel> items = <MediaModel>[
    MediaModel(
      'http://pixdaus.com/files/items/pics/8/28/76828_bc2803f807a3f05873b3f0c105995173_large.jpg',
    ),
    MediaModel(
      'http://pixdaus.com/files/items/pics/8/28/76828_bc2803f807a3f05873b3f0c105995173_large.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Carousel(items, 240);
  }
}
