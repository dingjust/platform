import 'package:flutter/material.dart';
import 'package:models/models.dart';

class TaxInvoiceDetailPage extends StatelessWidget {
  TaxInvoiceModel taxInvoice;

  TaxInvoiceDetailPage({this.taxInvoice});

  @override
  Widget build(BuildContext context) {
    String type;
    if (this.taxInvoice.type == InvoiceType.ELECTRONIC) {
      type = '电子发票';
    }else if(this.taxInvoice.type == InvoiceType.PAPER){
      type = '纸质发票';
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('发票详情'),
        ),
        body: ListView(
          children: <Widget>[
            Card(
              margin: EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                children: <Widget>[
                  Center(
                    child: ListTile(
                      contentPadding: EdgeInsets.only(left: 150),
                      title: Text(type),
                    ),
                  ),
                  ListTile(
                    title: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child:  Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(right: 20),
                                child: Text(
                                  '销方名称',
                                  style: TextStyle(
                                      color: Colors.grey[600]
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Text(this.taxInvoice.seller),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child:   Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(right: 20),
                                child: Text(
                                  '购方名称',
                                  style: TextStyle(
                                      color: Colors.grey[600]
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Text(this.taxInvoice.buyer),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child:   Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(right: 20),
                                child: Text(
                                  '发票金额',
                                  style: TextStyle(
                                      color: Colors.grey[600]
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Text(this.taxInvoice.amount.toString()),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child:   Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(right: 20),
                                child: Text(
                                  '开票日期',
                                  style: TextStyle(
                                      color: Colors.grey[600]
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Text(this.taxInvoice.billingDate.toString().substring(0,10)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child:   Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(right: 20),
                                child: Text(
                                  '发票代码',
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Text(this.taxInvoice.serialCode),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ),
                ],
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 0,vertical: 20),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text('查看发票'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  ListTile(
                    title: Text('发送到邮箱'),
                    trailing: Icon(Icons.chevron_right),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
