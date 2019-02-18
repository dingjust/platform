import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'products/sample_product_borrow_history_item.dart';
import 'search/apparel_product_search.dart';
import 'products/sample_product_borrowed_history.dart';
import 'products/sample_products.dart';
import 'products/sample_product_history_form.dart';
import 'products/sample_product_lend_history_item.dart';

class SampleGarmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<EnumModel> states = <EnumModel>[
      EnumModel('ALL', '全部'),
      EnumModel('NO_RETURN', '未还'),
      EnumModel('RETURNED', '已还'),
    ];

    List<SampleBorrowReturnHistoryModel> _sampleHistoryList = <SampleBorrowReturnHistoryModel>[
      SampleBorrowReturnHistoryModel(
        sampleProduct: SampleProductModel(
          name: '样衣1',
          skuID: 'NA893151351',
          thumbnail:
          'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
        ),
        type: LendBorrowType.BORROW,
        state: SampleProductReturnState.NO_RETURN,
        creationDate:DateTime.parse('2019-02-11'),
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
          thumbnail:
          'http://img.alicdn.com/bao/uploaded/O1CN017h2qoE1X6KmcjQRml_!!595412874.jpg_80x80.jpg',
        ),
        type: LendBorrowType.BORROW,
        state: SampleProductReturnState.RETURNED,
        creationDate:DateTime.parse('2019-02-11'),
        expectedReturnDate: DateTime.parse('2019-03-01'),
        returnedDate: DateTime.parse('2019-03-18'),
        relatedParty: '老刘',
        quantity: 10,
        contactWay: 'weixin',
      ),
      SampleBorrowReturnHistoryModel(
        sampleProduct:  SampleProductModel(
          name: '样衣3',
          skuID: 'NA893151353',
          thumbnail:
          'http://g.search2.alicdn.com/img/i2/107651422/O1CN0171M0es1MNJhJfITfG_!!0-saturn_solar.jpg_220x220.jpg_.webp',
        ),
        type: LendBorrowType.LEND,
        state: SampleProductReturnState.RETURNED,
        creationDate:DateTime.parse('2019-02-11'),
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
        title: Text('样衣借还'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => showSearch(
              context: context,
              delegate: ApparelProductSearchDelegate(),
            ),
          ),
          IconButton(
            icon: Text('我的样衣'),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => SampleProductsPage()));
            },
          )
        ],
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
                  Card(
                    elevation: 0,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 15,right: 5),
                      child: GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical:15.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  '新建记录',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Icon(Icons.chevron_right, color: Colors.grey),
                            ],
                          ),
                        ),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SampleProductHistoryFormPage())),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    margin: EdgeInsets.only(bottom: 5),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15,right: 5),
                      child: GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical:15.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  '借入样衣',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Text(
                                '2',
                                style: TextStyle(color: Colors.orange),
                              ),
                              Icon(Icons.chevron_right, color: Colors.grey),
                            ],
                          ),
                        ),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SampleProductBorrowedHistoryPage())),
                      ),
                    ),
                  ),
                  Column(
                    children: _sampleHistoryList.map((sampleHistory) {
                      return SampleProductBorrowHistoryItem(item: sampleHistory);
                    }).toList(),
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
