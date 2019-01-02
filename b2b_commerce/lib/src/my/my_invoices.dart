import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'invoices/invoice_title_form.dart';
import 'invoices/invoice_title_detail.dart';
import 'invoices/tax_invoices.dart';

/// 发票管理
class MyInvoicesPage extends StatelessWidget {
  final List<InvoiceTitleModel> invoiceTitles = <InvoiceTitleModel>[
    InvoiceTitleModel(
      company: "宁波衣加衣供应链管理有限公司",
      taxNumber: "55555555MA2CJBWF1P",
      address: "浙江省宁波高新区扬帆广场8、20、32号9-5-033室",
      phone: "020-83303330",
      bankOfDeposit: "中国农业银行",
      bankAccount: "39152001040014999",
      defaultTitle: true,
    ),
    InvoiceTitleModel(
      company: "宁波衣加衣供应链管理有限公司广州分公司",
      taxNumber: "66666666MA2CJBWF1P",
      address: "广东省广州市海珠区云顶同创汇C03",
      phone: "020-84474866",
      bankOfDeposit: "中国农业银行",
      bankAccount: "39152001040014000",
      defaultTitle: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<Card> cardList = <Card>[
      Card(
        margin: EdgeInsets.all(0),
        child: ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TaxInvoicesPage()));
          },
          leading: Icon(Icons.portrait),
          title: Text('我的发票'),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
    ];

    invoiceTitles.forEach((invoiceTitle) {
      ListTile tile = ListTile(
        title: Text(
          '发票抬头',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 13,
          ),
        ),
      );

      if (invoiceTitle.defaultTitle) {
        tile = ListTile(
          title: Text(
            '发票抬头',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
          trailing: Text(
            '默认抬头',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
        );
      }

      cardList.add(
        Card(
          margin: EdgeInsets.only(top: 10),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      InvoiceTitleDetailPage(invoiceTitle: invoiceTitle),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                tile,
                Container(
                  child:  ListTile(
                    title: Text(
                      invoiceTitle.company,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    '税号:' + invoiceTitle.taxNumber,
                    style: TextStyle(color: Colors.grey, fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('发票管理'),
      ),
      body: ListView(
        children: cardList,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InvoiceTitleFormPage()),
          );
        },
      ),
    );
  }
}
