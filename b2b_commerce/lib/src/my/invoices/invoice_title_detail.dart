import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'invoice_title_form.dart';

class InvoiceTitleDetailPage extends StatelessWidget {
  final InvoiceTitleModel invoiceTitle;

  InvoiceTitleDetailPage({this.invoiceTitle});

  @override
  Widget build(BuildContext context) {
    String _operation;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('发票抬头'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: ()async{
              await showMenu(
                context: context,
                position: RelativeRect.fromLTRB(1000, 80,0,0),
                items: <PopupMenuItem<String>>[
                  PopupMenuItem(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InvoiceTitleFormPage(
                              invoiceTitle: invoiceTitle,
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text('修改'),
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    child: GestureDetector(
                      onTap: () {
                        print('delete');
                        Navigator.pop(context);
                      },
                      child: ListTile(
                        title: Text('删除'),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ],
      ),
      body: Card(
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
          )),
    );
  }
}
