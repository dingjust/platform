import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'sample_product_item.dart';
import 'sample_product_form.dart';
import 'sample_product_detail.dart';

class SampleProductsPage extends StatelessWidget {
  bool isHistoryCreate;

  SampleProductsPage({this.isHistoryCreate = false});

  List<SampleProductModel> _sampleProductList = [
    SampleProductModel(
      skuID: 'SKUID001',
      name: '样衣1',
//      thumbnail:
//          'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
    ),
    SampleProductModel(
      skuID: 'SKUID002',
      name: '样衣2',
//      thumbnail:
//          'http://g.search2.alicdn.com/img/i2/107651422/O1CN0171M0es1MNJhJfITfG_!!0-saturn_solar.jpg_220x220.jpg_.webp',
    ),
    SampleProductModel(
      skuID: 'SKUID003',
      name: '样衣3',
//      thumbnail:
//          'http://g.search2.alicdn.com/img/i2/107651422/O1CN0171M0es1MNJhJfITfG_!!0-saturn_solar.jpg_220x220.jpg_.webp',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('我的样衣'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => SampleProductFormPage())),
        child: Icon(Icons.add),
      ),
      body: ListView(children: <Widget>[
        Column(
          children: _sampleProductList.map((sampleProduct) {
            return GestureDetector(
              child: SampleProductItem(
                item: sampleProduct,
              ),
              onTap: () {
                if (isHistoryCreate) {
                  Navigator.pop(context, sampleProduct);
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SampleProductDetailPage(
                                item: sampleProduct,
                              )));
                }
              },
            );
          }).toList(),
        )
      ]),
    );
  }
}
