import 'package:b2b_commerce/src/home/pool/requirement_quote_order_from.dart';
import 'package:b2b_commerce/src/home/pool/search/requirement_pool_search.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

List<RequirementOrderModel> orders = [
  RequirementOrderModel.fromJson({
    "code": "34938475200045",
    'totalQuotesCount': 120,
    'belongTo':{
      'brand' : '森马',
      'profilePicture' : 'http://www.pptbz.com/pptpic/UploadFiles_6909/201203/2012031220134655.jpg'
    },
    'totalQuantity': 200,
    "status": "PENDING_QUOTE",
    'details': {
      "expectedMachiningQuantity": 10,
      "maxExpectedPrice": 300,
      "expectedDeliveryDate": DateTime.now().toString(),
      'productName': '山本风法少女长裙复古气质秋冬款',
      'productSkuID': 'NA89852509',
      'pictures': [
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
      ],
      'majorCategory': {'name': '针织'},
      'category': {'name': '男装-T恤'},
      'proofingNeeded': true,
      'samplesNeeded': true,
      'invoiceNeeded': true,
      'productiveOrientations': ['广东东莞'],
      'machiningType': 'LIGHT_PROCESSING'
    },
    "creationtime": DateTime.parse('2019-03-01').toString(),
    "remarks": "交货时间 2019-01-01\n确定前请先与我厂沟通好样衣事宜，谢谢",
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
  RequirementOrderModel.fromJson({
    "code": "34938475200045",
    'totalQuotesCount': 120,
    'totalQuantity': 200,
    "status": "COMPLETED",
    'belongTo':{
      'brand' : '森马',
      'profilePicture' : 'http://www.pptbz.com/pptpic/UploadFiles_6909/201203/2012031220134655.jpg'
    },
    'details': {
      "expectedMachiningQuantity": 10,
      "maxExpectedPrice": 300,
      "expectedDeliveryDate": DateTime.now().toString(),
      'productName': '山本风法少女长裙复古气质秋冬款',
      'productSkuID': 'NA89852509',
      'pictures': [
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
      ],
      'majorCategory': {'name': '针织'},
      'category': {'name': '男装-T恤'},
      'proofingNeeded': true,
      'samplesNeeded': true,
      'invoiceNeeded': true,
      'productiveOrientations': ['广东东莞'],
      'machiningType': 'LABOR_AND_MATERIAL'
    },
    "creationtime": DateTime.parse('2019-03-01').toString(),
    "remarks": "交货时间 2019-01-01\n确定前请先与我厂沟通好样衣事宜，谢谢",
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
  RequirementOrderModel.fromJson({
    "code": "34938475200045",
    'totalQuotesCount': 120,
    'totalQuantity': 200,
    "status": "CANCELLED",
    'belongTo':{
      'brand' : '森马',
      'profilePicture' : 'http://www.pptbz.com/pptpic/UploadFiles_6909/201203/2012031220134655.jpg'
    },
    'details': {
      "expectedMachiningQuantity": 10,
      "maxExpectedPrice": 300,
      "expectedDeliveryDate": DateTime.now().toString(),
      'productName': '山本风法少女长裙复古气质秋冬款',
      'majorCategory': {'name': '针织'},
      'category': {'name': '男装-T恤'},
      'proofingNeeded': true,
      'samplesNeeded': true,
      'invoiceNeeded': true,
      'productiveOrientations': ['广东东莞'],
      'machiningType': 'LABOR_AND_MATERIAL'
    },
    "creationtime": DateTime.parse('2019-03-01').toString(),
    "remarks": "交货时间 2019-01-01\n确定前请先与我厂沟通好样衣事宜，谢谢",
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
  RequirementOrderModel.fromJson({
    "code": "34938475200045",
    'totalQuotesCount': 120,
    'totalQuantity': 200,
    "status": "CANCELLED",
    'belongTo':{
      'brand' : '森马',
      'profilePicture' : 'http://www.pptbz.com/pptpic/UploadFiles_6909/201203/2012031220134655.jpg'
    },
    'details': {
      "expectedMachiningQuantity": 10,
      "maxExpectedPrice": 300,
      "expectedDeliveryDate": DateTime.now().toString(),
      'productName': '山本风法少女长裙复古气质秋冬款',
      'productSkuID': 'NA89852509',
      'pictures': [
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
      ],
      'majorCategory': {'name': '针织'},
      'category': {'name': '男装-T恤'},
      'proofingNeeded': true,
      'samplesNeeded': true,
      'invoiceNeeded': true,
      'productiveOrientations': ['广东东莞'],
      'machiningType': 'LABOR_AND_MATERIAL'
    },
    "creationtime": DateTime.parse('2019-03-01').toString(),
    "remarks": "交货时间 2019-01-01\n确定前请先与我厂沟通好样衣事宜，谢谢",
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
];

class RequirementPoolRecommend extends StatefulWidget {
  _RequirementPoolRecommendState createState() => _RequirementPoolRecommendState();
}

class _RequirementPoolRecommendState extends State<RequirementPoolRecommend> {
  bool _isShowCategoryItem = true;
  bool _isShowProcessItem = true;
  bool _isSelectedCategory1 = false;
  bool _isSelectedCategory2 = false;
  bool _isSelectedCategory3 = false;
  bool _isSelectedProcess1 = false;
  bool _isSelectedProcess2 = false;
  bool _isSort = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          centerTitle: true,
          elevation: 0.5,
          title: Text(
            '推荐需求',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(B2BIcons.search,size: 20,),
              onPressed: () =>
                  showSearch(
                      context: context, delegate: RequirementPoolSearch()),
            ),
          ],
          bottom: _buildFilterBar(context),
        ),
        body:Container(
            child: ListView(
              children: <Widget>[
                _buildFilterCategoryItem(context),
                _buildFilterProcessItem(context),
                _buildBody(context),
              ],
            )
        )
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
        child: Column(
          children: orders.map((item) =>
              _buildRequirementOrderItem(context, item))
              .toList(),
        )
    );
  }

  Widget _buildRequirementOrderItem(BuildContext context,RequirementOrderModel model){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
        // margin: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: NetworkImage('https://gd3.alicdn.com/imgextra/i2/0/TB194socYrpK1RjSZTEXXcWAVXa_!!0-item_pic.jpg'),
                    fit: BoxFit.cover,
                  )),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      '${model.details.category.name}',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text(
                                      '${model.totalQuotesCount}件',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xffFF9516),
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(right: 5),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '￥',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),
                                    Text(
                                      '${model.details.maxExpectedPrice}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),
                                  ],
                                )
                            )
                          ],
                        )
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              '交货日期： '+DateFormatUtil.formatYMD(model.details.expectedDeliveryDate),
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                          Container(
                            height: 30,
                            width: 80,
                            child: FlatButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => RequirementQuoteOrderFrom(model: model,)),
                                );
                              },
                              color: Colors.orange,
                              child: Text(
                                '去报价',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              shape:
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 25,
                          height: 25,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                '${model.belongTo.profilePicture}'
                            ),
                            radius: 50.0,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text(
                            '${model.belongTo.brand}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text(
                              '已认证',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.deepOrange
                              ),
                            )
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(color: Colors.grey[300], width: 0.6))),
      ),
    );
  }


  Widget _buildFilterCategoryItem(BuildContext context){
    return Offstage(
        offstage: _isShowCategoryItem,
        child:Container(
          margin: EdgeInsets.only(bottom: 20),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: ListTile(
                  title: Text(
                    '针织',
                    style: TextStyle(
                        color: _isSelectedCategory1 == true ? Color.fromRGBO(255, 149, 22, 1):Colors.black
                    ),
                  ),
                  trailing: _isSelectedCategory1 == true ? Icon(Icons.check,color: Color.fromRGBO(255, 149, 22, 1),) : null,
                ),
                onTap: () {
                  setState(() {
                    _isSelectedCategory1 = !_isSelectedCategory1;
//                    _isShowCategoryItem = !_isShowCategoryItem;
                  });
                },
              ),
              Divider(
                height: 1,
              ),
              GestureDetector(
                child: ListTile(
                  title: Text(
                    '梭织',
                    style: TextStyle(
                        color: _isSelectedCategory2 == true ? Color.fromRGBO(255, 149, 22, 1):Colors.black
                    ),
                  ),
                  trailing: _isSelectedCategory2 == true ? Icon(Icons.check,color: Color.fromRGBO(255, 149, 22, 1)) : null,
                ),
                onTap: () {
                  setState(() {
                    _isSelectedCategory2 = !_isSelectedCategory2;
//                    _isShowCategoryItem = !_isShowCategoryItem;
                  });
                },
              ),
              Divider(
                height: 1,
              ),
              GestureDetector(
                child: ListTile(
                  title: Text(
                    '尼龙',
                    style: TextStyle(
                        color: _isSelectedCategory3 == true ? Color.fromRGBO(255, 149, 22, 1):Colors.black
                    ),
                  ),
                  trailing: _isSelectedCategory3 == true ? Icon(Icons.check,color: Color.fromRGBO(255, 149, 22, 1)) : null,
                ),
                onTap: () {
                  setState(() {
                    _isSelectedCategory3 = !_isSelectedCategory3;
//                    _isShowCategoryItem = !_isShowCategoryItem;
                  });
                },
              ),
              Divider(
                height: 1,
              ),
            ],
          ),
        )
    );
  }


  Widget _buildFilterProcessItem(BuildContext context){
    return Offstage(
        offstage: _isShowProcessItem,
        child:Container(
          margin: EdgeInsets.only(bottom: 20),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: ListTile(
                  title: Text(
                    '轻加工',
                    style: TextStyle(
                        color: _isSelectedProcess1 == true ? Color.fromRGBO(255, 149, 22, 1):Colors.black
                    ),
                  ),
                  trailing: _isSelectedProcess1 == true ? Icon(Icons.check,color: Color.fromRGBO(255, 149, 22, 1)) : null,
                ),
                onTap: () {
                  setState(() {
                    _isSelectedProcess1 = !_isSelectedProcess1;
//                    _isShowProcessItem = !_isShowProcessItem;
                  });
                },
              ),
              Divider(
                height: 1,
              ),
              GestureDetector(
                child: ListTile(
                  title: Text(
                    '包工包料',
                    style: TextStyle(
                        color: _isSelectedProcess2 == true ? Color.fromRGBO(255, 149, 22, 1):Colors.black
                    ),
                  ),
                  trailing: _isSelectedProcess2 == true ? Icon(Icons.check,color: Color.fromRGBO(255, 149, 22, 1)) : null,
                ),
                onTap: () {
                  setState(() {
                    _isSelectedProcess2 = !_isSelectedProcess2;
//                    _isShowProcessItem = !_isShowProcessItem;
                  });
                },
              ),
              Divider(
                height: 1,
              ),
            ],
          ),
        )
    );
  }



  Widget _buildFilterBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(35, 40),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
                height: 30,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      width: 118,
                      child: FlatButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '最新发布',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                            Icon(_isSort==true?Icons.keyboard_arrow_up:Icons.keyboard_arrow_down)
                          ],
                        ),
                        onPressed: (){
                          setState(() {
                            _isSort = !_isSort;
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 118,
                      child: FlatButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '加工方式',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                          ],
                        ),
                        onPressed: (){
                          setState(() {
                            _isShowProcessItem = !_isShowProcessItem;
                            _isShowCategoryItem = true;
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 118,
                      child: FlatButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '商品大类',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                          ],
                        ),
                        onPressed: (){
                          setState(() {
                            _isShowProcessItem = true;
                            _isShowCategoryItem = !_isShowCategoryItem;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              )),
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

}