import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'sample_product_form.dart';
import 'sample_product_item.dart';

class SampleProductDetailPage extends StatelessWidget {
  SampleProductModel item;
  SampleProductDetailPage({this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
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
//          Column(
////            children: _sampleBorrowHistoryList.map((sampleHistory){
////              return SampleProductHistoryItem(item: sampleHistory,isSampleProductHistory: true,);
////            }).toList(),
////          )
        ],
      ),
    );
  }
}
