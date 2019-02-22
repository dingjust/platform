import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'tax_invoice_detail.dart';
import 'package:core/core.dart';

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
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                          '购方名称',style: TextStyle(fontSize: 17),
                      ),
                    ),
                    Text(taxInvoice.buyer,),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                          '发票金额',style: TextStyle(fontSize: 17),
                      ),
                    ),
                    Text(taxInvoice.amount.toString(),),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                          '开票时间',style: TextStyle(fontSize: 17),
                      ),
                    ),
                    Text(DateFormatUtil.formatYMD(taxInvoice.billingDate),),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text('我的发票'),
        centerTitle: true,
      ),
      body: ListView(
        children: cards,
      ),
    );
  }
}
