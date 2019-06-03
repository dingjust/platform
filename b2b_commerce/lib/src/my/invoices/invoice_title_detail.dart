import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'invoice_title_form.dart';

class InvoiceTitleDetailPage extends StatefulWidget {
  final InvoiceTitleModel invoiceTitle;

  InvoiceTitleDetailPage({this.invoiceTitle});

  _InvoiceTitleDetailPageState createState() => _InvoiceTitleDetailPageState();
}

class _InvoiceTitleDetailPageState extends State<InvoiceTitleDetailPage>{

  Future _invoiceTitleDetailFuture;

  @override
  void initState(){
    _invoiceTitleDetailFuture = _getInvoiceTitleDetailData();
    super.initState();
  }

  _getInvoiceTitleDetailData(){
    return InvoiceTitleRepositoryImpl().detail(widget.invoiceTitle.id);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('发票抬头'),
        actions: <Widget>[
          IconButton(
            icon: Text('编辑'),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InvoiceTitleFormPage(
                    invoiceTitle: widget.invoiceTitle,
                  ),
                ),
              ).then((_){
                setState(() {
                  _invoiceTitleDetailFuture = _getInvoiceTitleDetailData();
                });
              });
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _invoiceTitleDetailFuture,
        builder:(context,snapshot) {
          if (!snapshot.hasData) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 200),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if(snapshot.hasData){
            return buildDetail(snapshot.data);
          }
        }
      ),
    );
  }

  Card buildDetail(InvoiceTitleModel invoiceTitle) {
    return Card(
            margin: EdgeInsets.all(0),
            child: Container(
              padding: EdgeInsets.fromLTRB(30, 40, 5, 30),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            invoiceTitle.company,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: 20),
                          child: Text(
                            '税        号',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Text(invoiceTitle.taxNumber),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: 20),
                          child: Text(
                            '单位地址',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(invoiceTitle.address),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: 20),
                          child: Text(
                            '电话号码',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(invoiceTitle.phone),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: 20),
                          child: Text(
                            '开户银行',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(invoiceTitle.bankOfDeposit),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: 20),
                          child: Text(
                            '银行账号',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(invoiceTitle.bankAccount),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }
}
