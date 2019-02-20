import 'package:b2b_commerce/src/home/factory/factory.dart';
import 'package:b2b_commerce/src/home/factory/quick_reaction_factory.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ProductHotCategoryPage extends StatefulWidget {
  _ProductHotCategoryPageState createState() => _ProductHotCategoryPageState();
}

class _ProductHotCategoryPageState extends State<ProductHotCategoryPage> {
  //TODO:调用接口查询推荐款式
  List<ProductModel> recommendProducts = <ProductModel>[
    ProductModel(
        name: '冬季女棉服',
        thumbnail:
            'https://img.alicdn.com/imgextra/i2/108689489/TB2JOp7FuuSBuNjSsziXXbq8pXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
        minPrice: 99.0,
        maxPrice: 500.0),
    ProductModel(
        name: '冬季女棉服',
        thumbnail:
            'https://img.alicdn.com/imgextra/i2/108689489/TB2JOp7FuuSBuNjSsziXXbq8pXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
        minPrice: 99.0,
        maxPrice: 500.0),
    ProductModel(
        name: '冬季女棉服',
        thumbnail:
            'https://img.alicdn.com/imgextra/i2/108689489/TB2JOp7FuuSBuNjSsziXXbq8pXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
        minPrice: 99.0,
        maxPrice: 500.0),
    ProductModel(
        name: '冬季女棉服',
        thumbnail:
            'https://img.alicdn.com/imgextra/i2/108689489/TB2JOp7FuuSBuNjSsziXXbq8pXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
        minPrice: 99.0,
        maxPrice: 500.0),
    ProductModel(
        name: '冬季女棉服',
        thumbnail:
            'https://img.alicdn.com/imgextra/i2/108689489/TB2JOp7FuuSBuNjSsziXXbq8pXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
        minPrice: 99.0,
        maxPrice: 500.0),
    ProductModel(
        name: '冬季女棉服',
        thumbnail:
            'https://img.alicdn.com/imgextra/i2/108689489/TB2JOp7FuuSBuNjSsziXXbq8pXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
        minPrice: 99.0,
        maxPrice: 500.0),
    ProductModel(
        name: '冬季女棉服',
        thumbnail:
            'https://img.alicdn.com/imgextra/i2/108689489/TB2JOp7FuuSBuNjSsziXXbq8pXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
        minPrice: 99.0,
        maxPrice: 500.0),
    ProductModel(
        name: '冬季女棉服',
        thumbnail:
            'https://img.alicdn.com/imgextra/i2/108689489/TB2JOp7FuuSBuNjSsziXXbq8pXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
        minPrice: 99.0,
        maxPrice: 500.0),
    ProductModel(
        name: '冬季女棉服',
        thumbnail:
            'https://img.alicdn.com/imgextra/i2/108689489/TB2JOp7FuuSBuNjSsziXXbq8pXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
        minPrice: 99.0,
        maxPrice: 500.0),
  ];

  @override
  Widget build(BuildContext context) {
    List<CategoryItem> categories = <CategoryItem>[
      CategoryItem(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => QuickReactionFactoryPage()));
        },
        imageUrl: 'http://dingjust.oss-cn-shenzhen.aliyuncs.com/T%E6%81%A4.png',
        name: 'T恤',
      ),
      CategoryItem(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => QuickReactionFactoryPage()));
        },
        imageUrl:
            'http://dingjust.oss-cn-shenzhen.aliyuncs.com/%E5%8D%8A%E6%88%AA%E8%A3%99.png',
        name: '半截裙',
      ),
      CategoryItem(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => QuickReactionFactoryPage()));
        },
        imageUrl:
            'http://dingjust.oss-cn-shenzhen.aliyuncs.com/%E5%A5%B3%E7%9A%AE%E8%A3%A4.png',
        name: '女皮裤',
      ),
      CategoryItem(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => QuickReactionFactoryPage()));
        },
        imageUrl:
            'http://dingjust.oss-cn-shenzhen.aliyuncs.com/%E6%AF%9B%E8%A1%A3.png',
        name: '毛衣',
      ),
      CategoryItem(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => QuickReactionFactoryPage()));
        },
        imageUrl:
            'http://dingjust.oss-cn-shenzhen.aliyuncs.com/%E7%89%9B%E4%BB%94%E8%A3%A4.png',
        name: '牛仔裤',
      ),
      CategoryItem(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => QuickReactionFactoryPage()));
        },
        imageUrl:
            'http://dingjust.oss-cn-shenzhen.aliyuncs.com/%E8%A1%AC%E8%A1%A3.png',
        name: '衬衣',
      ),
      CategoryItem(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => QuickReactionFactoryPage()));
        },
        imageUrl:
            'http://dingjust.oss-cn-shenzhen.aliyuncs.com/%E9%A3%8E%E8%A1%A3.png',
        name: '风衣',
      ),
      CategoryItem(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => QuickReactionFactoryPage()));
        },
        imageUrl:
            'http://dingjust.oss-cn-shenzhen.aliyuncs.com/%E5%A5%B3%E5%A5%97%E8%A3%85.png',
        name: '女套装',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('热门品类'),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.all(10),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, //Grid按两列显示
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 0.75,
                ),
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return categories[index];
                }, childCount: categories.length),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[_buildRecommend()]),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRecommend() {
    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.only(top: 10),
      child: Container(
        color: Colors.green,
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
                              text: '推荐款式',
                              style: TextStyle(color: Colors.black)),
                          TextSpan(text: '———')
                        ]),
                  ),
                )
              ],
            ),
            Column(
              children: recommendProducts
                  .map((item) => RecommendProductItem(
                        model: item,
                      ))
                  .toList(),
            )
          ],
        ),
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
  final VoidCallback onPressed;

  const CategoryItem({
    Key key,
    this.width = 70,
    this.height = 80,
    @required this.name,
    this.code,
    @required this.imageUrl,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.network(
              imageUrl,
              width: width,
              height: height,
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

class RecommendProductItem extends StatelessWidget {
  const RecommendProductItem(
      {Key key,
      this.model,
      this.width = 150,
      this.height = 230,
      this.imageHeight = 160,
      this.showAddress = false})
      : super(key: key);

  final ProductModel model;

  final double width;

  final double height;

  final double imageHeight;

  final bool showAddress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: <Widget>[
          Container(
            width: width,
            height: imageHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(model.thumbnail),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: width - 10,
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('${model.name}'),
                  RichText(
                    text: TextSpan(
                        text: '￥',
                        style: TextStyle(color: Colors.red, fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                              text: '${model.minPrice}—${model.maxPrice}',
                              style: TextStyle(fontSize: 16)),
                        ]),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
