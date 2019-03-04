import 'package:flutter/material.dart';
import 'package:models/models.dart';

class IsInvoiceField extends StatefulWidget {
  final RequirementOrderModel item;

  IsInvoiceField(this.item);

  IsInvoiceFieldState createState() => IsInvoiceFieldState();
}

class IsInvoiceFieldState extends State<IsInvoiceField> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '是否开具发票',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              widget.item.details.invoiceNeeded == null ? '选取' : widget.item.details.invoiceNeeded ? '开发票':'不开发票',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
          ),
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                  height: 300,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text('开发票'),
                        onTap: () async {
                          setState(() {
                            widget.item.details.invoiceNeeded = true;
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Text('不开发票'),
                        onTap: () async {
                          setState(() {
                            widget.item.details.invoiceNeeded = false;
                          });
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ));
            },
          );
        });
  }
}
