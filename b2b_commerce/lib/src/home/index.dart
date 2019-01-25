import 'package:b2b_commerce/src/business/search/apparel_product_search.dart';
import 'package:b2b_commerce/src/common/app_keys.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/home/factory/quick_reaction_factory.dart';
import 'package:b2b_commerce/src/home/requirement/requirement_publish_success.dart';
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
        leading: new IconButton(
          tooltip: '搜索',
          icon: Icon(Icons.search),
          onPressed: () => showSearch(
              context: context, delegate: ApparelProductSearchDelegate()),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.message),
            onPressed: (){},
          )
        ],
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
          ),
          RaisedButton(
            onPressed: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => QuickReactionFactoryPage()));
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        PublishRequirementSuccessDialog(
                          model: RequirementOrderModel.fromJson({
                            "code": "34938475200045",
                            "status": "PENDING_QUOTE",
                            "totalQuantity": 10,
                            "totalPrice": 300,
                            "expectedDeliveryDate": DateTime.now().toString(),
                            "creationtime": DateTime.now().toString(),
                            "remarks": "确定前请先与我厂沟通好样衣事宜，谢谢",
                            "entries": [
                              {
                                "product": {
                                  "code": "NA89852509",
                                  "name": "山本风法少女长裙复古气质秋冬款",
                                  "skuID": "NA89852509",
                                  "majorCategory": {"name": "女装-T恤"},
                                  "supercategories": [
                                    {"name": "针织"}
                                  ],
                                  "thumbnail":
                                      "https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp",
                                },
                                "basePrice": 100.00,
                                "entryNumber": 500,
                              },
                            ],
                            "attachments": [
                              {
                                'url':
                                    'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                                'mediaType': 'webp'
                              },
                              {
                                'url':
                                    'http://zb.guaihou.com/zdoc/03J012-2%20%E7%8E%AF%E5%A2%83%E6%99%AF%E8%A7%82--%E7%BB%BF%E5%8C%96%E7%A7%8D%E6%A4%8D%E8%AE%BE%E8%AE%A1.pdf',
                                'mediaType': 'pdf'
                              },
                              {
                                'url':
                                    'http://www.gzedu.gov.cn/gzsjyj/zsks/201901/4cbfd27ec7cf47ecb8867bad65a57040/files/ed312aa5e162435f928614b9c79d8fab.docx',
                                'mediaType': 'docx'
                              },
                              {
                                'url':
                                    'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                                'mediaType': 'webp'
                              },
                              {
                                'url':
                                    'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                                'mediaType': 'webp'
                              },
                              {
                                'url':
                                    'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                                'mediaType': 'webp'
                              },
                            ]
                          }),
                        ),
                    fullscreenDialog: true,
                  ));
            },
            child: Text('发布需求成功'),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.ROUTE_HOT_CATEGORY);
            },
            child: Text('热门品类'),
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
