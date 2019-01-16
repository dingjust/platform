import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'products/sample_product_item.dart';
import 'products/sample_product_inventorys.dart';
import 'products/sample_product_borroweds.dart';

class SampleGarmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('');
    /*List<EnumModel> states = <EnumModel>[
      EnumModel('ALL', '全部'),
      EnumModel('NO_RETURN', '未还'),
      EnumModel('RETURNED', '已还'),
      EnumModel('ABNORMAL', '异常'),
    ];

    List<SampleProductModel> _sampleProductList = <SampleProductModel>[
      SampleProductModel(
        name: '样衣1',
        skuID: 'NA893151351',
        state: SampleProductReturnState.NO_RETURN,
        lendDate: DateTime.parse('2019-01-10'),
        expectedReturnDate: DateTime.parse('2019-01-16'),
        lendQuantity: 20,
        thumbnail:
            'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
        debtor: '老刘',
      ),
      SampleProductModel(
        name: '样衣2',
        skuID: 'NA893151352',
        state: SampleProductReturnState.RETURNED,
        returnedDate: DateTime.parse('2019-01-15'),
        lendDate: DateTime.parse('2019-01-11'),
        expectedReturnDate: DateTime.parse('2019-01-17'),
        lendQuantity: 22,
        thumbnail:
            'http://img.alicdn.com/bao/uploaded/O1CN017h2qoE1X6KmcjQRml_!!595412874.jpg_80x80.jpg',
        debtor: '老流',
      ),
      SampleProductModel(
        name: '样衣3',
        skuID: 'NA893151353',
        state: SampleProductReturnState.ABNORMAL,
        lendDate: DateTime.parse('2019-01-12'),
        expectedReturnDate: DateTime.parse('2019-01-18'),
        lendQuantity: 24,
        thumbnail:
            'http://g.search2.alicdn.com/img/i2/107651422/O1CN0171M0es1MNJhJfITfG_!!0-saturn_solar.jpg_220x220.jpg_.webp',
        debtor: '老六',
      ),
    ];

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('样衣管理'),
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
                    margin: EdgeInsets.symmetric(vertical: 15),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SampleProductInventorysPage())),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    '样衣库存',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Icon(Icons.chevron_right, color: Colors.grey),
                              ],
                            ),
                          ),
                          Divider(height: 30),
                          GestureDetector(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    '我借来的',
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
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SampleProductBorrowedsPage())),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: _sampleProductList.map((sampleProduct) {
                      return SampleProductItem(item: sampleProduct);
                    }).toList(),
                  )
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );*/
  }
}
