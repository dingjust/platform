import 'package:b2b_commerce/src/home/factory/factory.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class HotCategoryPage extends StatefulWidget {
  _HotCategoryPageState createState() => _HotCategoryPageState();
}

class _HotCategoryPageState extends State<HotCategoryPage> {
  List<CategoryItem> categories = <CategoryItem>[
    CategoryItem(
      imageUrl: 'http://dingjust.oss-cn-shenzhen.aliyuncs.com/T%E6%81%A4.png',
      name: 'T恤',
    ),
    CategoryItem(
      imageUrl:
          'http://dingjust.oss-cn-shenzhen.aliyuncs.com/%E5%8D%8A%E6%88%AA%E8%A3%99.png',
      name: '半截裙',
    ),
    CategoryItem(
      imageUrl:
          'http://dingjust.oss-cn-shenzhen.aliyuncs.com/%E5%A5%B3%E7%9A%AE%E8%A3%A4.png',
      name: '女皮裤',
    ),
    CategoryItem(
      imageUrl:
          'http://dingjust.oss-cn-shenzhen.aliyuncs.com/%E6%AF%9B%E8%A1%A3.png',
      name: '毛衣',
    ),
    CategoryItem(
      imageUrl:
          'http://dingjust.oss-cn-shenzhen.aliyuncs.com/%E7%89%9B%E4%BB%94%E8%A3%A4.png',
      name: '牛仔裤',
    ),
    CategoryItem(
      imageUrl:
          'http://dingjust.oss-cn-shenzhen.aliyuncs.com/%E8%A1%AC%E8%A1%A3.png',
      name: '衬衣',
    ),
    CategoryItem(
      imageUrl:
          'http://dingjust.oss-cn-shenzhen.aliyuncs.com/%E9%A3%8E%E8%A1%A3.png',
      name: '风衣',
    ),
    CategoryItem(
      imageUrl:
          'http://dingjust.oss-cn-shenzhen.aliyuncs.com/%E5%A5%B3%E5%A5%97%E8%A3%85.png',
      name: '女套装',
    ),
  ];

  //TODO:调用接口查询推荐工厂
  List<FactoryModel> factories = <FactoryModel>[
    FactoryModel(
        historyOrdersCount: 214,
        name: '广州旭日4',
        starLevel: 4,
        describe: '20年经验专业生产牛仔服装，价低质优，本月剩余小量空闲产能，欢迎报价',
        profilePicture:
            'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
        categories: [
          CategoryModel(name: '牛仔'),
          CategoryModel(name: '衬衫'),
          CategoryModel(name: '夹克'),
        ]),
    FactoryModel(
        historyOrdersCount: 214,
        name: '广州旭日3',
        starLevel: 4,
        describe: '20年经验专业生产牛仔服装，价低质优，本月剩余小量空闲产能，欢迎报价',
        profilePicture:
            'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
        categories: [
          CategoryModel(name: '牛仔'),
          CategoryModel(name: '衬衫'),
          CategoryModel(name: '夹克'),
        ]),
    FactoryModel(
        historyOrdersCount: 214,
        name: '广州旭日2',
        starLevel: 4,
        describe: '20年经验专业生产牛仔服装，价低质优，本月剩余小量空闲产能，欢迎报价',
        profilePicture:
            'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
        categories: [
          CategoryModel(name: '牛仔'),
          CategoryModel(name: '衬衫'),
          CategoryModel(name: '夹克'),
        ]),
    FactoryModel(
        historyOrdersCount: 214,
        profilePicture:
            'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
        name: '广州旭日1',
        describe: '20年经验专业生产牛仔服装，价低质优，本月剩余小量空闲产能，欢迎报价',
        starLevel: 4,
        categories: [
          CategoryModel(name: '牛仔'),
          CategoryModel(name: '衬衫'),
          CategoryModel(name: '夹克'),
        ]),
    FactoryModel(
        historyOrdersCount: 214,
        profilePicture:
            'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
        name: '广州旭日0',
        starLevel: 4,
        describe: '20年经验专业生产牛仔服装，价低质优，本月剩余小量空闲产能，欢迎报价',
        categories: [
          CategoryModel(name: '牛仔'),
          CategoryModel(name: '衬衫'),
          CategoryModel(name: '夹克'),
        ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('热门品类'),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.grey[100]),
        child: ListView(
          children: <Widget>[_buildCategory(), _buildRecommend()],
        ),
      ),
    );
  }

  Widget _buildCategory() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
      child: Wrap(
        spacing: 17,
        runSpacing: 5,
        children: categories,
      ),
    );
  }

  Widget _buildRecommend() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
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
                            text: '工厂推荐',
                            style: TextStyle(color: Colors.black)),
                        TextSpan(text: '———')
                      ]),
                ),
              )
            ],
          ),
          Column(
            children: factories
                .map((item) => FactoryItem(
                      model: item,
                      showButton: true,
                    ))
                .toList(),
          )
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final double width;
  final double height;
  final String name;
  final String code;
  final String imageUrl;

  const CategoryItem({
    Key key,
    this.width = 85,
    this.height = 110,
    @required this.name,
    this.code,
    @required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //TODO: 分类跳转
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.network(
              imageUrl,
              width: width - 15,
              height: height - 20,
            ),
            Text(
              name,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
