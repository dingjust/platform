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

    return GestureDetector(
        child: Container(
          child: ListTile(
              leading: RichText(
                text: TextSpan(
                    text: '交货时间',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' *',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.red)
                      ),
                    ]),
              ),
              trailing: Container(
                  width: 150,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        DateFormatUtil.formatYMD(
                                widget.item.details?.expectedDeliveryDate) ??
                            '选取',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                        overflow: TextOverflow.ellipsis),
                  ))),
        ),
        onTap: () {
          showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2999),
          ).then((value) {
            setState(() {
              widget.item.details?.expectedDeliveryDate = value;
            });
          });
        });
  }
}
