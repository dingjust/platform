import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

import 'invoices/invoice_title_detail.dart';
import 'invoices/invoice_title_form.dart';
import 'invoices/tax_invoices.dart';

/// 发票管理
class MyInvoicesPage extends StatelessWidget {
  List<InvoiceTitleModel> invoiceTitles = <InvoiceTitleModel>[
//    InvoiceTitleModel(
//      company: "宁波衣加衣供应链管理有限公司",
//      taxNumber: "55555555MA2CJBWF1P",
//      address: "浙江省宁波高新区扬帆广场8、20、32号9-5-033室",
//      phone: "020-83303330",
//      bankOfDeposit: "中国农业银行",
//      bankAccount: "39152001040014999",
//      defaultTitle: true,
//    ),
//    InvoiceTitleModel(
//      company: "宁波衣加衣供应链管理有限公司广州分公司",
//      taxNumber: "66666666MA2CJBWF1P",
//      address: "广东省广州市海珠区云顶同创汇C03",
//      phone: "020-84474866",
//      bankOfDeposit: "中国农业银行",
//      bankAccount: "39152001040014000",
//      defaultTitle: false,
//    ),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('发票管理'),
      ),
      body: FutureBuilder(
        future: InvoiceTitleRepositoryImpl().list(),
        builder: (context,snapshot){
          if (!snapshot.hasData) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 200),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if(snapshot.hasData){
            return ListView(
              children:  buildInvoiceTitleList(snapshot.data ?? [], context),
            );
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          InvoiceTitleModel invoiceTitleModel = InvoiceTitleModel();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InvoiceTitleFormPage(isCreate: true,invoiceTitle: invoiceTitleModel,)),
          );
        },
      ),
    );
  }

  List<Widget> buildInvoiceTitleList(List<InvoiceTitleModel> invoiceTitles, BuildContext context) {
    List<Widget> widgetList = [];

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

      widgetList.add(
        Card(
          elevation: 0,
          margin: EdgeInsets.only(top: 10),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InvoiceTitleDetailPage(invoiceTitle: invoiceTitle),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                tile,
                Container(
                  child: ListTile(
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

    return widgetList;
  }
}
