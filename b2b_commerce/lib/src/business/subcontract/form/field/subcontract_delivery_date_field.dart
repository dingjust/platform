import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class SubContractDeliveryDateField extends StatefulWidget {
  final SubContractModel item;
  SubContractDeliveryDateField(this.item);

  SubContractDeliveryDateFieldState createState() =>
      SubContractDeliveryDateFieldState();
}

class SubContractDeliveryDateFieldState extends State<SubContractDeliveryDateField> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    now = now.add(Duration(days: 1));

    return GestureDetector(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: '交货日期',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  TextSpan(
                    text: ' *',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  )
                ]),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
//                  width: 152,
                  height: 43,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
//                    border: Border.all(color: Colors.black45),
                    borderRadius: BorderRadius.circular(4),

                  ),
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          widget.item.details?.expectedDeliveryDate == null ? '选取' :
                          DateFormatUtil.formatYMD(widget.item.details?.expectedDeliveryDate),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                          overflow: TextOverflow.ellipsis),
                    ),
                  )),
            )
          ],
        ),
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
