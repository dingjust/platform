import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class TotalQuantityField extends StatefulWidget {
  RequirementOrderModel item;

  TotalQuantityField(this.item);

  TotalQuantityFieldState createState() => TotalQuantityFieldState();
}

class TotalQuantityFieldState extends State<TotalQuantityField> {
  @override
  Widget build(BuildContext context) {
    FocusNode _expectedMachiningQuantityFocusNode = FocusNode();
    TextEditingController _expectedMachiningQuantityController =
        TextEditingController(
            text: widget.item.details.expectedMachiningQuantity == null
                ? ''
                : widget.item.details.expectedMachiningQuantity.toString());
    return GestureDetector(
      child: Container(
        child: ListTile(
          leading: Text(
            '加工数量',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Text(
            widget.item.details.expectedMachiningQuantity == null
                ? '填写'
                : widget.item.details.expectedMachiningQuantity.toString(),
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
        ),
      ),
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (context) {
            return AlertDialog(
              title: Text('请输入加工数量'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextFieldComponent(
                      controller: _expectedMachiningQuantityController,
                      focusNode: _expectedMachiningQuantityFocusNode,
                      autofocus: true,
                      inputType: TextInputType.number,
                      hintText: '请输入加工数量',
                      padding: EdgeInsets.all(0),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    '确定',
                    style: TextStyle(color: Color(0xffFF9516)),
                  ),
                  onPressed: () {
                    if (_expectedMachiningQuantityController.text.trim() !=
                        '') {
                      widget.item.details.expectedMachiningQuantity =
                          int.parse(_expectedMachiningQuantityController.text);
                    } else {
                      widget.item.details.expectedMachiningQuantity = null;
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
