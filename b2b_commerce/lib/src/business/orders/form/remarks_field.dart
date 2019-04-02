import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class RemarksField extends StatefulWidget {
  RequirementOrderModel item;

  RemarksField(this.item);

  RemarksFieldState createState() => RemarksFieldState();
}

class RemarksFieldState extends State<RemarksField> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _remarksController =
        TextEditingController(text: widget.item.remarks ?? '');
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
              builder: (context) => PopupWindowPage(
                    fieldText: '订单备注',
                    text: widget.item.remarks == null
                        ? null
                        : widget.item.remarks.toString(),
                  ),
            ),
            //接收返回数据并处理
          ).then((value) {
            if (value.trim() == '') {
              widget.item.remarks = null;
            } else {
              widget.item.remarks = value;
            }
          });
        });
  }
}
