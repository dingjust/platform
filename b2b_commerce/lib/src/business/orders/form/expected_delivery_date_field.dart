import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ExpectedDeliveryDateField extends StatefulWidget {
  final RequirementOrderModel item;
  ExpectedDeliveryDateField(this.item);

  ExpectedDeliveryDateFieldState createState() =>
      ExpectedDeliveryDateFieldState();
}

class ExpectedDeliveryDateFieldState extends State<ExpectedDeliveryDateField> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    now = now.add(Duration(days: 1));

    return GestureDetector(
        child: ListTile(
            leading: Wrap(
              children: <Widget>[
                Text(
                  '交货日期',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black
                  ),
                ),
                Text(
                    ' *',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.red)
                ),
              ],
            ),
            trailing: Container(
                width: 150,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                      widget.item.details?.expectedDeliveryDate == null ? '选取' :
                          DateFormatUtil.formatYMD(widget.item.details?.expectedDeliveryDate),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                      overflow: TextOverflow.ellipsis),
                ))),
        onTap: () {
          showDatePicker(
            context: context,
            initialDate: widget.item.details?.expectedDeliveryDate ?? now,
            firstDate: DateTime(2019),
            lastDate: DateTime(2999),
          ).then((value) {
            setState(() {
              if(value != null){
                widget.item.details?.expectedDeliveryDate = value;
              }

            });
          });
        });
  }
}
