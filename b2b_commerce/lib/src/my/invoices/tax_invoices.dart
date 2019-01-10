import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'tax_invoice_detail.dart';

class TaxInvoicesPage extends StatelessWidget {
  List<TaxInvoiceModel> taxInvoices = <TaxInvoiceModel>[
    TaxInvoiceModel(
      buyer: '宁波衣加衣供应链管理有限公司',
      seller: '广州昊超电子商务有限公司',
      type: InvoiceType.ELECTRONIC,
      amount: 198.94,
      billingDate: DateTime.parse('2018-12-31'),
      serialCode: '5001534134',
    ),
    TaxInvoiceModel(
      buyer: '宁波衣加衣供应链管理有限公司',
      seller: '广州昊超电子商务有限公司',
      type: InvoiceType.PAPER,
      amount: 398.94,
      billingDate: DateTime.parse('2019-01-01'),
      serialCode: '1626436326',
    ),
    TaxInvoiceModel(
      buyer: '宁波衣加衣供应链管理有限公司',
      seller: '广州昊超电子商务有限公司',
      type: InvoiceType.ELECTRONIC,
      amount: 598.94,
      billingDate: DateTime.parse('2019-01-01'),
      serialCode: '772262355',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<Card> cards = taxInvoices.map((taxInvoice) {
      return Card(
        elevation: 0,
        margin: EdgeInsets.symmetric(
          horizontal: 0,
          vertical: 8,
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaxInvoiceDetailPage(
                      taxInvoice: taxInvoice,
                    ),
              ),
            );
          },
          child: Column(
            children: <Widget>[
              /*ListTile(
                title: Text(
                  taxInvoice.seller,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ),*/
              ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text('购方名称'),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text('发票金额'),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text('开票时间'),
                    ),
                  ],
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        taxInvoice.buyer,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(taxInvoice.amount.toString()),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        taxInvoice.billingDate.toString().substring(0, 10),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('我的发票'),
        centerTitle: true,
      ),
      body: ListView(
        children: cards,
      ),
    );
  }
}
