import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

import 'products/sample_product_borrow_history_item.dart';
import 'products/sample_product_history_form.dart';
import 'products/sample_product_lend_history_item.dart';
import 'products/sample_products.dart';
import 'search/apparel_product_search.dart';

class SampleGarmentsPage extends StatefulWidget {
  SampleGarmentsPageState createState() => SampleGarmentsPageState();
}

class SampleGarmentsPageState extends State<SampleGarmentsPage> {
  LendBorrowType _type = LendBorrowType.BORROW;

  @override
  Widget build(BuildContext context) {
    List<EnumModel> states = <EnumModel>[
      EnumModel('ALL', '全部'),
      EnumModel('NO_RETURN', '未还'),
      EnumModel('RETURNED', '已还'),
    ];

    List<SampleBorrowReturnHistoryModel> _sampleBorrowHistoryList =
        <SampleBorrowReturnHistoryModel>[
      SampleBorrowReturnHistoryModel(
        sampleProduct: SampleProductModel(
          name: '样衣1',
          skuID: 'NA893151351',
//          thumbnail:
//              'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
        ),
        type: LendBorrowType.BORROW,
        state: SampleProductReturnState.NO_RETURN,
        creationDate: DateTime.parse('2019-02-11'),
        expectedReturnDate: DateTime.parse('2019-03-01'),
//        returnedDate: DateTime.parse('2019-03-18'),
        relatedParty: '老刘',
        quantity: 10,
        contactWay: 'weixin',
      ),
      SampleBorrowReturnHistoryModel(
        sampleProduct: SampleProductModel(
          name: '样衣2',
          skuID: 'NA893151352',
//          thumbnail:
//              'http://img.alicdn.com/bao/uploaded/O1CN017h2qoE1X6KmcjQRml_!!595412874.jpg_80x80.jpg',
        ),
        type: LendBorrowType.BORROW,
        state: SampleProductReturnState.RETURNED,
        creationDate: DateTime.parse('2019-02-11'),
        expectedReturnDate: DateTime.parse('2019-03-01'),
        returnedDate: DateTime.parse('2019-03-18'),
        relatedParty: '老刘',
        quantity: 10,
        contactWay: 'weixin',
      ),
      SampleBorrowReturnHistoryModel(
        sampleProduct: SampleProductModel(
          name: '样衣3',
          skuID: 'NA893151353',
//          thumbnail:
//              'http://g.search2.alicdn.com/img/i2/107651422/O1CN0171M0es1MNJhJfITfG_!!0-saturn_solar.jpg_220x220.jpg_.webp',
        ),
        type: LendBorrowType.BORROW,
        state: SampleProductReturnState.RETURNED,
        creationDate: DateTime.parse('2019-02-11'),
        expectedReturnDate: DateTime.parse('2019-03-01'),
        returnedDate: DateTime.parse('2019-03-18'),
        relatedParty: '老刘',
        quantity: 10,
        contactWay: 'weixin',
      ),
    ];

    List<SampleBorrowReturnHistoryModel> _sampleLendHistoryList =
        <SampleBorrowReturnHistoryModel>[
      SampleBorrowReturnHistoryModel(
        sampleProduct: SampleProductModel(
          name: '样衣1',
          skuID: 'NA893151351',
//          thumbnail:
//              'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
        ),
        type: LendBorrowType.LEND,
        state: SampleProductReturnState.NO_RETURN,
        creationDate: DateTime.parse('2019-02-11'),
        expectedReturnDate: DateTime.parse('2019-03-01'),
//        returnedDate: DateTime.parse('2019-03-18'),
        relatedParty: '老刘',
        quantity: 10,
        contactWay: 'weixin',
      ),
      SampleBorrowReturnHistoryModel(
        sampleProduct: SampleProductModel(
          name: '样衣2',
          skuID: 'NA893151352',
//          thumbnail:
//              'http://img.alicdn.com/bao/uploaded/O1CN017h2qoE1X6KmcjQRml_!!595412874.jpg_80x80.jpg',
        ),
        type: LendBorrowType.LEND,
        state: SampleProductReturnState.RETURNED,
        creationDate: DateTime.parse('2019-02-11'),
        expectedReturnDate: DateTime.parse('2019-03-01'),
        returnedDate: DateTime.parse('2019-03-18'),
        relatedParty: '老刘',
        quantity: 10,
        contactWay: 'weixin',
      ),
      SampleBorrowReturnHistoryModel(
        sampleProduct: SampleProductModel(
          name: '样衣3',
          skuID: 'NA893151353',
//          thumbnail:
//              'http://g.search2.alicdn.com/img/i2/107651422/O1CN0171M0es1MNJhJfITfG_!!0-saturn_solar.jpg_220x220.jpg_.webp',
        ),
        type: LendBorrowType.LEND,
        state: SampleProductReturnState.RETURNED,
        creationDate: DateTime.parse('2019-02-11'),
        expectedReturnDate: DateTime.parse('2019-03-01'),
        returnedDate: DateTime.parse('2019-03-18'),
        relatedParty: '老刘',
        quantity: 10,
        contactWay: 'weixin',
      ),
    ];

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.5,
        title: Text(_type == LendBorrowType.BORROW ? '样衣借出' : '样衣借入'),
        actions: <Widget>[
          IconButton(
            icon: Icon(B2BIcons.search,size: 20,),
            onPressed: () => showSearch(
                  context: context,
                  delegate: ApparelProductSearchDelegate(),
                ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SampleProductHistoryFormPage())),
      ),
      body: DefaultTabController(
        length: states.length,
        child: Scaffold(
          appBar: TabBar(
            tabs: states.map((state) {
              return Tab(
                text: state.name,
              );
            }).toList(),
          ),
          body: TabBarView(
            children: states.map((state) {
              return ListView(
                children: <Widget>[
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SampleProductsPage())),
                    child: Card(
                      elevation: 0,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 5),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  '我的样衣',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Icon(Icons.chevron_right, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_type == LendBorrowType.BORROW) {
                          _type = LendBorrowType.LEND;
                        } else {
                          _type = LendBorrowType.BORROW;
                        }
                      });
                    },
                    child: Card(
                      elevation: 0,
                      margin: EdgeInsets.only(bottom: 5),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 5),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  _type == LendBorrowType.BORROW
                                      ? '借入样衣'
                                      : '借出样衣',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Text(
                                '3',
                                style: TextStyle(color: Color.fromRGBO(255,214,12, 1)),
                              ),
                              Icon(Icons.chevron_right, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: _type == LendBorrowType.BORROW
                        ? _sampleBorrowHistoryList
                            .map((borrowHistory) =>
                                SampleProductBorrowHistoryItem(
                                  item: borrowHistory,
                                ))
                            .toList()
                        : _sampleLendHistoryList
                            .map((lendHistory) => SampleProductLendHistoryItem(
                                  item: lendHistory,
                                ))
                            .toList(),
                  )
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
