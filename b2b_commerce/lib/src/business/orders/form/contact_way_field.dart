import 'package:b2b_commerce/src/business/orders/requirement_order_contact_input.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ContactWayField extends StatefulWidget{
  RequirementOrderModel item;
  ContactWayField(this.item);

  ContactWayFieldState createState() => ContactWayFieldState();
}

class ContactWayFieldState extends State<ContactWayField>{
  formatContactWayText(){
    StringBuffer text = StringBuffer();
    if(widget.item.details?.contactPerson == null){
      text.write('填写');
    }else{
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
            leading: Wrap(
              children: <Widget>[
                Text(
                  '联系方式',
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
            trailing: Text(
              formatContactWayText(),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RequirmentOrderContactInput(widget.item)),
          );
        });
  }
}