import 'package:b2b_commerce/src/home/factory/factory.dart';
import 'package:b2b_commerce/src/home/product/order_product.dart';
import 'package:b2b_commerce/src/home/product/product.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ProductHotCategoryPage extends StatefulWidget {
  _ProductHotCategoryPageState createState() => _ProductHotCategoryPageState();
}

class _ProductHotCategoryPageState extends State<ProductHotCategoryPage> {
  //TODO:调用接口查询推荐款式
  List<ProductModel> recommendProducts = <ProductModel>[
//    ProductModel(
//        name: '冬季女棉服',
//        thumbnail:
//            'https://img.alicdn.com/imgextra/i4/311670094/O1CN014LCreL1CZ5iva14YN_!!0-saturn_solar.jpg_220x220.jpg_.webp',
//        minPrice: 99.0,
//        maxPrice: 500.0),
//    ProductModel(
//        name: '冬季女棉服',
//        thumbnail:
//            'https://img.alicdn.com/imgextra/i4/311670094/O1CN014LCreL1CZ5iva14YN_!!0-saturn_solar.jpg_220x220.jpg_.webp',
//        minPrice: 99.0,
//        maxPrice: 500.0),
//    ProductModel(
//        name: '冬季女棉服',
//        thumbnail:
//            'https://img.alicdn.com/imgextra/i4/311670094/O1CN014LCreL1CZ5iva14YN_!!0-saturn_solar.jpg_220x220.jpg_.webp',
//        minPrice: 99.0,
//        maxPrice: 500.0),
//    ProductModel(
//        name: '冬季女棉服',
//        thumbnail:
//            'https://img.alicdn.com/imgextra/i4/311670094/O1CN014LCreL1CZ5iva14YN_!!0-saturn_solar.jpg_220x220.jpg_.webp',
//        minPrice: 99.0,
//        maxPrice: 500.0),
//    ProductModel(
//        name: '冬季女棉服',
//        thumbnail:
//            'https://img.alicdn.com/imgextra/i4/311670094/O1CN014LCreL1CZ5iva14YN_!!0-saturn_solar.jpg_220x220.jpg_.webp',
//        minPrice: 99.0,
//        maxPrice: 500.0),
//    ProductModel(
//        name: '冬季女棉服',
//        thumbnail:
//            'https://img.alicdn.com/imgextra/i4/311670094/O1CN014LCreL1CZ5iva14YN_!!0-saturn_solar.jpg_220x220.jpg_.webp',
//        minPrice: 99.0,
//        maxPrice: 500.0),
//    ProductModel(
//        name: '冬季女棉服',
//        thumbnail:
//            'https://img.alicdn.com/imgextra/i4/311670094/O1CN014LCreL1CZ5iva14YN_!!0-saturn_solar.jpg_220x220.jpg_.webp',
//        minPrice: 99.0,
//        maxPrice: 500.0),
//    ProductModel(
//        name: '冬季女棉服',
//        thumbnail:
//            'https://img.alicdn.com/imgextra/i4/311670094/O1CN014LCreL1CZ5iva14YN_!!0-saturn_solar.jpg_220x220.jpg_.webp',
//        minPrice: 99.0,
//        maxPrice: 500.0),
  ];

  //TODO:调用接口查询热门品类

  @override
  Widget build(BuildContext context) {
    List<CategoryItem> categoriesItems = <CategoryItem>[
      CategoryItem(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => OrderByProductPage()));
        },
        imageUrl: 'http://dingjust.oss-cn-shenzhen.aliyuncs.com/T%E6%81%A4.png',
        name: 'T恤',
      ),
      CategoryItem(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => OrderByProductPage()));
        },
        imageUrl:
            'http://dingjust.oss-cn-shenzhen.aliyuncs.com/%E5%8D%8A%E6%88%AA%E8%A3%99.png',
        name: '半截裙',
      ),
      CategoryItem(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => OrderByProductPage()));
        },
        imageUrl:
            'http://dingjust.oss-cn-shenzhen.aliyuncs.com/%E5%A5%B3%E7%9A%AE%E8%A3%A4.png',
        name: '女皮裤',
      ),
      CategoryItem(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => OrderByProductPage()));
        },
        imageUrl:
            'http://dingjust.oss-cn-shenzhen.aliyuncs.com/%E6%AF%9B%E8%A1%A3.png',
        name: '毛衣',
      ),
      CategoryItem(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => OrderByProductPage()));
        },
        imageUrl:
            'http://dingjust.oss-cn-shenzhen.aliyuncs.com/%E7%89%9B%E4%BB%94%E8%A3%A4.png',
        name: '牛仔裤',
      ),
      CategoryItem(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => OrderByProductPage()));
        },
        imageUrl:
            'http://dingjust.oss-cn-shenzhen.aliyuncs.com/%E8%A1%AC%E8%A1%A3.png',
        name: '衬衣',
      ),
      CategoryItem(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => OrderByProductPage()));
        },
        imageUrl:
            'http://dingjust.oss-cn-shenzhen.aliyuncs.com/%E9%A3%8E%E8%A1%A3.png',
        name: '风衣',
      ),
      CategoryItem(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => OrderByProductPage()));
        },
        imageUrl:
            'http://dingjust.oss-cn-shenzhen.aliyuncs.com/%E5%A5%B3%E5%A5%97%E8%A3%85.png',
        name: '女套装',
      ),
    ];

    List<RecommendProductItem> recommendProductItems = recommendProducts
        .map((product) => RecommendProductItem(
              model: product,
            ))
        .toList();

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
                  return categoriesItems[index];
                }, childCount: categoriesItems.length),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 10,
                color: Color.fromRGBO(245, 245, 245, 1),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                color: Colors.white,
                child: Center(
                  child: Text(
                    '——推荐款式——',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, //Grid按两列显示
                  mainAxisSpacing: 12.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 0.7,
                ),
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return recommendProductItems[index];
                }, childCount: recommendProductItems.length),
              ),
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
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
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
