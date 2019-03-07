import 'package:b2b_commerce/src/business/orders/requirement_order_input_page.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class RemarksField extends StatefulWidget {
  RequirementOrderModel item;

  RemarksField(this.item);

  RemarksFieldState createState() => RemarksFieldState();
}

class RemarksFieldState extends State<RemarksField> {

  @override
  Widget build(BuildContext context) {
    TextEditingController _remarksController = TextEditingController(text: widget.item.remarks ?? '');
    FocusNode _remarksFocusNode = FocusNode();
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '订单备注',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              widget.item.remarks ?? '填写',
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
                builder: (context) =>
                    RequirementOrderInputPage(
                        fieldText: '订单备注', inputType: TextInputType.text)),
            //接收返回数据并处理
          ).then((value) {
            setState(() {
              widget.item.remarks = value;
            });
          });
        });
  }
}
