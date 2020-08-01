import 'package:b2b_commerce/src/business/orders/requirement_order_contact_input.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ContactWayField extends StatefulWidget {
  RequirementOrderModel item;
  ContactWayField(this.item);

  ContactWayFieldState createState() => ContactWayFieldState();
}

class ContactWayFieldState extends State<ContactWayField> {
  String formatContactWayText() {
    StringBuffer text = StringBuffer();
    if (widget.item.details?.contactPerson == null &&
        widget.item.details?.contactPhone == null) {
      text.write('填写');
    } else {
      text.write(widget.item.details?.contactPerson ?? '');
      text.write(',');
      text.write(widget.item.details?.contactPhone ?? '');
    }
    return text.toString();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
              leading: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: '联系方式',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  TextSpan(
                    text: ' *',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  )
                ]),
              ),
              trailing: widget.item.details?.contactPerson == null &&
                  widget.item.details?.contactPhone == null
                  ? Icon(
                Icons.chevron_right,
                color: Colors.black,
              )
                  : _buildText()),
        ),
        onTap: () async {
          List<String> result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RequirmentOrderContactInput(widget.item)),
          );
          setState(() {
            widget.item.details.contactPerson = result[0];
            widget.item.details.contactPhone = result[1];
          });
        });
  }

  Widget _buildText() {
    StringBuffer text = StringBuffer();
    if (widget.item.details?.contactPerson == null &&
        widget.item.details?.contactPhone == null) {
      text.write('填写');
    } else {
      text.write(widget.item.details?.contactPerson ?? '');
      text.write(',');
      text.write(widget.item.details?.contactPhone ?? '');
    }

    String val = text.toString();

    return Text(
      '$val',
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
    );
  }
}
