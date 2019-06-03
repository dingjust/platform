import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

import 'invoices/invoice_title_detail.dart';
import 'invoices/invoice_title_form.dart';
import 'invoices/tax_invoices.dart';

/// 发票管理
class MyInvoicesPage extends StatefulWidget {
  List<InvoiceTitleModel> invoiceTitles = <InvoiceTitleModel>[];

  _MyInvoicesPageState createState() => _MyInvoicesPageState();
}

class _MyInvoicesPageState extends State<MyInvoicesPage> {
  Future _invoiceTitlesFuture;

  @override
  void initState() {
    _invoiceTitlesFuture = _getInvoiceTitlesData();
    super.initState();
  }

  _getInvoiceTitlesData() {
    return InvoiceTitleRepositoryImpl().list();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('发票管理'),
      ),
      body: FutureBuilder<List<InvoiceTitleModel>>(
          future: _invoiceTitlesFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 200),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.data.length <= 0) {
              return Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 200),
                      child: Image.asset(
                        'temp/logo2.png',
                        package: 'assets',
                        width: 80,
                        height: 80,
                      ),
                    ),
                    Container(
                        child: Text(
                          '请添加发票抬头',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        )),
                  ],
                ),
              );
            }
            if (snapshot.hasData) {
              return ListView(
                children: snapshot.data.map((invoiceTitle) {
                  return Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                        child: Container(
                          color: Colors.grey[Constants.SIZEDBOX_COLOR],
                        ),
                      ),
                      InvoiceTitleItem(
                        invoiceTitle,
                        onItemTap: () => _onItemTap(invoiceTitle),
                        onLongItemTap: () => _onLongItemTap(invoiceTitle),
                      ),
                    ],
                  );
                }).toList(),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          InvoiceTitleModel invoiceTitleModel = InvoiceTitleModel();
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InvoiceTitleFormPage(
                      isCreate: true,
                      invoiceTitle: invoiceTitleModel,
                    )),
          ).then((_) {
            setState(() {
              _invoiceTitlesFuture = _getInvoiceTitlesData();
            });
          });
        },
      ),
    );
  }

  void _onItemTap(InvoiceTitleModel invoiceTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            InvoiceTitleDetailPage(invoiceTitle: invoiceTitle),
      ),
    );
  }

  void _onLongItemTap(InvoiceTitleModel invoiceTitle) {
    ShowDialogUtil.showChoseDiglog(context, '是否确定删除该发票抬头', (){
      Navigator.pop(context);
      InvoiceTitleRepositoryImpl().delete(invoiceTitle.id).then((result) {
        ShowDialogUtil.showResultMsg(context,'删除发票抬头成功','删除发票抬头失败',result);
      }).then((_){
        setState(() {
          _invoiceTitlesFuture = _getInvoiceTitlesData();
        });
      });
    });
  }
}

class InvoiceTitleItem extends StatelessWidget {
  final InvoiceTitleModel invoiceTitle;
  final VoidCallback onItemTap;
  final VoidCallback onLongItemTap;

  InvoiceTitleItem(
    this.invoiceTitle, {
    this.onItemTap,
    this.onLongItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onItemTap,
      onLongPress: onLongItemTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '发票抬头',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                Offstage(
                  offstage: !invoiceTitle.defaultTitle,
                  child: Text(
                    '默认抬头',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                children: <Widget>[
                  Text(
                    invoiceTitle.company,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Text(
                  '税号：${invoiceTitle.taxNumber}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
