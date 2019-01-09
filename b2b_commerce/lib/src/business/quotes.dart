import 'package:flutter/material.dart';
import 'package:models/models.dart';

class QuotesPage extends StatefulWidget {
  QuotesState createState() => QuotesState();
}

class QuotesState extends State<QuotesPage>{
  //格式日期
  String formatDate(DateTime date) {
    String year = date.year.toString();
    String month = date.month.toString();
    String day = date.day.toString();

    if (date.month < 10) {
      month = '0' + month;
    }
    if (date.day < 10) {
      day = '0' + day;
    }
    return year + '-' + month + '-' + day;
  }

  List<String> states = <String>[
//    'SELLER_SUBMITTED',
//    'BUYER_APPROVED',
//    'BUYER_REJECTED',
//    'ALL',
    '待处理',
    '通过',
    '拒绝',
    '全部',
  ];

  List<QuoteModel> get _quoteList {
    return <QuoteModel>[
      QuoteModel(
        code: '39492523423',
        state: 'SELLER_SUBMITTED',
        totalPrice: 54,
        totalQuantity: 554,
        belongTo: FactoryModel(name: '广州旭日'),
        creationTime: DateTime.parse('2019-01-03'),
        quoteEntry: QuoteEntryModel(
          product: ApparelProductModel(
            name: '山本风少女长裙复古气质秋冬流行新款',
            skuID: 'NA89852631',
            thumbnail:
                'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
          ),
        ),
      ),
      QuoteModel(
        code: '467627245245',
        state: 'BUYER_APPROVED',
        totalPrice: 78,
        totalQuantity: 500,
        belongTo: FactoryModel(name: '广州旭日'),
        creationTime: DateTime.parse('2019-01-06'),
        quoteEntry: QuoteEntryModel(
          product: ApparelProductModel(
            name: '法式复古裙egg针织毛衣',
            skuID: 'NA32523552',
            thumbnail:
                'http://img.alicdn.com/bao/uploaded/O1CN017h2qoE1X6KmcjQRml_!!595412874.jpg_80x80.jpg',
          ),
        ),
      ),
      QuoteModel(
        code: '2764246272',
        state: 'BUYER_REJECTED',
        totalPrice: 66,
        totalQuantity: 444,
        belongTo: FactoryModel(name: '广州旭日'),
        creationTime: DateTime.parse('2019-01-09'),
        quoteEntry: QuoteEntryModel(
          product: ApparelProductModel(
            name: '法式复古裙egg矮个子针织毛衣',
            skuID: 'NA89852631',
            thumbnail:
                'http://g.search2.alicdn.com/img/i2/107651422/O1CN0171M0es1MNJhJfITfG_!!0-saturn_solar.jpg_220x220.jpg_.webp',
          ),
        ),
      ),
    ];
  }

  List<Tab> get _tabList {
    return states.map((state) {
      return Tab(text: state);
    }).toList();
  }

  List<Card> get cards {
    return _quoteList.map((quote) {
      return Card(
        margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(right: 30),
                      child: Text("工厂：" + quote.belongTo.name),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Text('报价：'),
                          Text(
                            quote.totalPrice.toString(),
                            style: TextStyle(color: Colors.red),
                          ),
                          Text('元'),
                        ],
                      ),
                    ),
                    Text(
                      '待处理', //quote.state
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.grey[50],
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('报价单号：' + quote.code),
                          ),
                          Text('报价时间：' + formatDate(quote.creationTime)),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Image.network(
                              quote.quoteEntry.product.thumbnail,
                              width: 90,
                              height: 90,
                              fit: BoxFit.fill,
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Flexible(
                                      child: Text(
                                        quote.quoteEntry.product.name,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Column(
                                      children: <Widget>[
                                        Text(
                                          '货号：' +
                                              quote.quoteEntry.product.skuID,
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(''),
                                      ],
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                    )),
                                    Text(
                                      quote.totalQuantity.toString() + '件',
                                      style: TextStyle(
                                          color: Colors.orange, fontSize: 20),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '需求订单号：' + '459802454625245',
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 70,right: 20),
                            child: ActionChip(
                              backgroundColor: Colors.red,
                              labelPadding: EdgeInsets.symmetric(vertical: 2,horizontal: 13),
                              labelStyle: TextStyle(fontSize: 18),
                              label: Text('拒绝报价'),
                              onPressed: () {},
                            ),
                          ),
                          ActionChip(
                            backgroundColor: Colors.orange,
                            labelPadding: EdgeInsets.symmetric(vertical: 1,horizontal: 13),
                            labelStyle: TextStyle(fontSize: 18),
                            label: Text('确认报价'),
                            onPressed: () {},
                          ),
                        ],
                      ) ,
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('报价管理'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: null,
          ),
        ],
      ),
      body: DefaultTabController(
        length: states.length,
        child: Scaffold(
          appBar: TabBar(
            unselectedLabelColor: Colors.black26,
            labelColor: Colors.black38,
            tabs: _tabList,
            labelStyle: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
//            isScrollable: true,
          ),
          body: TabBarView(
            children:states.map((state) {
              return Container(
                child: ListView(
                  children: cards,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
