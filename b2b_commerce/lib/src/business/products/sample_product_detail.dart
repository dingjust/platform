import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'sample_product_form.dart';
import 'sample_product_item.dart';
import 'sample_product_history_item.dart';

class SampleProductDetailPage extends StatelessWidget {
  SampleProductModel item;
  SampleProductDetailPage({this.item});

  List<SampleBorrowReturnHistoryModel> _sampleBorrowHistoryList =
  <SampleBorrowReturnHistoryModel>[
    SampleBorrowReturnHistoryModel(
      sampleProduct: SampleProductModel(
        name: '样衣1',
        skuID: 'NA893151351',
        thumbnail:
        'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
      ),
      type: LendBorrowType.BORROW,
      state: SampleProductReturnState.NO_RETURN,
      creationDate: DateTime.parse('2019-02-11'),
      expectedReturnDate: DateTime.parse('2019-03-01'),
//        returnedDate: DateTime.parse('2019-03-18'),
      relatedParty: '老刘',
      quantity: 10,
      contactWay: 'weixin',
      remake: '',
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
      creationDate: DateTime.parse('2019-02-11'),
      expectedReturnDate: DateTime.parse('2019-03-01'),
      returnedDate: DateTime.parse('2019-03-18'),
      relatedParty: '老刘',
      quantity: 10,
      contactWay: 'weixin',
      remake: '',
    ),
    SampleBorrowReturnHistoryModel(
      sampleProduct: SampleProductModel(
        name: '样衣3',
        skuID: 'NA893151353',
        thumbnail:
        'http://g.search2.alicdn.com/img/i2/107651422/O1CN0171M0es1MNJhJfITfG_!!0-saturn_solar.jpg_220x220.jpg_.webp',
      ),
      type: LendBorrowType.BORROW,
      state: SampleProductReturnState.RETURNED,
      creationDate: DateTime.parse('2019-02-11'),
      expectedReturnDate: DateTime.parse('2019-03-01'),
      returnedDate: DateTime.parse('2019-03-18'),
      relatedParty: '老刘',
      quantity: 10,
      contactWay: 'weixin',
      remake: '',
    ),
    SampleBorrowReturnHistoryModel(
      sampleProduct: SampleProductModel(
        name: '样衣3',
        skuID: 'NA893151353',
        thumbnail:
        'http://g.search2.alicdn.com/img/i2/107651422/O1CN0171M0es1MNJhJfITfG_!!0-saturn_solar.jpg_220x220.jpg_.webp',
      ),
      type: LendBorrowType.BORROW,
      state: SampleProductReturnState.RETURNED,
      creationDate: DateTime.parse('2019-02-11'),
      expectedReturnDate: DateTime.parse('2019-03-01'),
      returnedDate: DateTime.parse('2019-03-18'),
      relatedParty: '老刘',
      quantity: 10,
      contactWay: 'weixin',
      remake: '',
    ),
    SampleBorrowReturnHistoryModel(
      sampleProduct: SampleProductModel(
        name: '样衣3',
        skuID: 'NA893151353',
        thumbnail:
        'http://g.search2.alicdn.com/img/i2/107651422/O1CN0171M0es1MNJhJfITfG_!!0-saturn_solar.jpg_220x220.jpg_.webp',
      ),
      type: LendBorrowType.BORROW,
      state: SampleProductReturnState.RETURNED,
      creationDate: DateTime.parse('2019-02-11'),
      expectedReturnDate: DateTime.parse('2019-03-01'),
      returnedDate: DateTime.parse('2019-03-18'),
      relatedParty: '老刘',
      quantity: 10,
      contactWay: 'weixin',
      remake: '',
    ),
    SampleBorrowReturnHistoryModel(
      sampleProduct: SampleProductModel(
        name: '样衣3',
        skuID: 'NA893151353',
        thumbnail:
        'http://g.search2.alicdn.com/img/i2/107651422/O1CN0171M0es1MNJhJfITfG_!!0-saturn_solar.jpg_220x220.jpg_.webp',
      ),
      type: LendBorrowType.BORROW,
      state: SampleProductReturnState.RETURNED,
      creationDate: DateTime.parse('2019-02-11'),
      expectedReturnDate: DateTime.parse('2019-03-01'),
      returnedDate: DateTime.parse('2019-03-18'),
      relatedParty: '老刘',
      quantity: 10,
      contactWay: 'weixin',
      remake: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('样衣详情'),
        actions: <Widget>[
          IconButton(
            icon: Text('编辑'),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SampleProductFormPage(
                          item: item,
                        ))),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          SampleProductItem(item: item,),
          SizedBox(height: 20,),
          Center(
            child: Text(
              '历史借还',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
          Column(
            children: _sampleBorrowHistoryList.map((sampleHistory){
              return SampleProductHistoryItemPage(item: sampleHistory);
            }).toList(),
          )
        ],
      ),
    );
  }
}
