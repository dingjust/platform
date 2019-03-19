import 'package:b2b_commerce/src/home/factory/factory.dart';
import 'package:b2b_commerce/src/home/factory/quick_reaction_factory.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class FactoryHotCategoryPage extends StatefulWidget {
  _FactoryHotCategoryPageState createState() => _FactoryHotCategoryPageState();
}

class _FactoryHotCategoryPageState extends State<FactoryHotCategoryPage> {
  //TODO:调用接口查询推荐工厂
  Map<String, dynamic> mockFactory = {
    'profilePicture': 'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
    'uid': 'BB123456',
    'name': '森马',
    'starLevel': 5,
    'describe': '20年经验专业生产牛仔服装，价低质优，本月剩余小量空闲产能，欢迎报价',
    'historyOrdersCount': 35,
    'responseQuotedTime': 50,
    'email': 'monkey.D.luffy@163.com',
    'phone': '020-12345678',
    'cooperationModes': ['FOB'],
    'developmentCapacity': true,
    'monthlyCapacityRanges': 'MCR003',
    'latheQuantity': 5,
    'contactPerson': 'luffy',
    'contactPhone': '13123456789',
    'address': '广东省广州市海珠区广州大道南',
    'contactAddress': {
      'fullname': "张三",
      'cellphone': '13123456789',
      'region': {'isocode': 'R123', 'name': '广东省'},
      'city': {'code': 'C123', 'name': '广州市'},
      'cityDistrict': {'code': 'D123', 'name': '海珠区'},
      'line1': '广州大道南',
    },
    'categories': [
      {
        'code': '1001',
        'name': '卫衣',
      },
      {
        'code': '1002',
        'name': '毛衣',
      },
    ],
    'scaleRange': 'SR005',
    'registrationDate': DateTime.now().toString(),
    'taxNumber': '41553315446687844',
    'bankOfDeposit': '中国工商银行',
    'certificate': [
      {
        'url':
            'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
        'mediaType': 'jpg',
      },
      {
        'url':
            'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
        'mediaType': 'jpg',
      },
      {
        'url':
            'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
        'mediaType': 'jpg',
      },
    ],
    'cooperativeBrands': [
      {
        'profilePicture':
            'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
        'uid': 'BB123456',
        'name': '森马',
        'starLevel': 5,
        'email': 'monkey.D.luffy@163.com',
        'phone': '020-12345678',
        'cooperationModes': ['FOB'],
        'developmentCapacity': true,
        'monthlyCapacityRanges': 'MCR003',
        'latheQuantity': 5,
        'contactPerson': 'luffy',
        'contactPhone': '13123456789',
      },
      {
        'profilePicture':
            'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
        'uid': 'BB123456',
        'name': '森马',
        'starLevel': 5,
        'email': 'monkey.D.luffy@163.com',
        'phone': '020-12345678',
        'cooperationModes': ['FOB'],
        'developmentCapacity': true,
        'monthlyCapacityRanges': 'MCR003',
        'latheQuantity': 5,
        'contactPerson': 'luffy',
        'contactPhone': '13123456789',
      },
      {
        'profilePicture':
            'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
        'uid': 'BB123456',
        'name': '森马',
        'starLevel': 5,
        'email': 'monkey.D.luffy@163.com',
        'phone': '020-12345678',
        'cooperationModes': ['FOB'],
        'developmentCapacity': true,
        'monthlyCapacityRanges': 'MCR003',
        'latheQuantity': 5,
        'contactPerson': 'luffy',
        'contactPhone': '13123456789',
      },
      {
        'profilePicture':
            'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
        'uid': 'BB123456',
        'name': '森马',
        'starLevel': 5,
        'email': 'monkey.D.luffy@163.com',
        'phone': '020-12345678',
        'cooperationModes': ['FOB'],
        'developmentCapacity': true,
        'monthlyCapacityRanges': 'MCR003',
        'latheQuantity': 5,
        'contactPerson': 'luffy',
        'contactPhone': '13123456789',
      },
      {
        'profilePicture':
            'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
        'uid': 'BB123456',
        'name': '森马',
        'starLevel': 5,
        'email': 'monkey.D.luffy@163.com',
        'phone': '020-12345678',
        'cooperationModes': ['FOB'],
        'developmentCapacity': true,
        'monthlyCapacityRanges': 'MCR003',
        'latheQuantity': 5,
        'contactPerson': 'luffy',
        'contactPhone': '13123456789',
      },
      {
        'profilePicture':
            'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
        'uid': 'BB123456',
        'name': '森马',
        'starLevel': 5,
        'email': 'monkey.D.luffy@163.com',
        'phone': '020-12345678',
        'cooperationModes': ['FOB'],
        'developmentCapacity': true,
        'monthlyCapacityRanges': 'MCR003',
        'latheQuantity': 5,
        'contactPerson': 'luffy',
        'contactPhone': '13123456789',
      },
      {
        'profilePicture':
            'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
        'uid': 'BB123456',
        'name': '森马',
        'starLevel': 5,
        'email': 'monkey.D.luffy@163.com',
        'phone': '020-12345678',
        'cooperationModes': ['FOB'],
        'developmentCapacity': true,
        'monthlyCapacityRanges': 'MCR003',
        'latheQuantity': 5,
        'contactPerson': 'luffy',
        'contactPhone': '13123456789',
      },
    ],
    'products': [
      {
        'name': '春秋薄款卫衣',
        'thumbnail':
        MediaModel(url: 'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg')
        ,
        'price': 33.3,
      },
      {
        'name': '春秋薄款卫衣',
        'thumbnail':
        MediaModel(url: 'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg')
        ,
        'price': 33.3,
      },
      {
        'name': '春秋薄款卫衣',
        'thumbnail':
        MediaModel(url: 'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg')
        ,
        'price': 33.3,
      },
      {
        'name': '春秋薄款卫衣',
        'thumbnail':
        MediaModel(url: 'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg')
        ,
        'price': 33.3,
      },
      {
        'name': '春秋薄款卫衣',
        'thumbnail':
         MediaModel(url: 'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg')
        ,
        'price': 33.3,
      },
    ]
  };
  List<FactoryModel> factories = <FactoryModel>[];

  void initState() {
    super.initState();
    //TODO 假数据，待删除
    for (int i = 0; i < 5; i++) {
      FactoryModel factoryModel = FactoryModel.fromJson(mockFactory);
      factoryModel.name = '森马${i + 1}';
      factories.add(factoryModel);
    }
  }

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
                              text: '推荐工厂',
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
