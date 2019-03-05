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
          TextEditingController inputNumber = TextEditingController();
          return showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (context) {
              return AlertDialog(
                title: Text('备注'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      TextFieldComponent(
                        controller: _remarksController,
                        focusNode: _remarksFocusNode,
                        autofocus: true,
                        hintText: '请输入订单备注',
                        padding: EdgeInsets.all(0),
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('确定'),
                    onPressed: () {
                      setState(() {
                        widget.item.remarks = _remarksController.text.trim() == '' ? null: _remarksController.text.trim();
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        });
  }
}
