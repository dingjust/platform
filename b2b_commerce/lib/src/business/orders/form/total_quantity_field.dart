import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class TotalQuantityField extends StatefulWidget{
  RequirementOrderModel item;
  TotalQuantityField(this.item);
  
  TotalQuantityFieldState createState() => TotalQuantityFieldState();
}

class TotalQuantityFieldState extends State<TotalQuantityField>{

  @override
  Widget build(BuildContext context) {
    FocusNode _totalQuantityFocusNode = FocusNode();
    TextEditingController _totalQuantityController = TextEditingController(text: widget.item.totalQuantity == null ? '':widget.item.totalQuantity.toString());
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
              widget.item.totalQuantity == null ? '填写':widget.item.totalQuantity.toString(),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
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
                        controller: _totalQuantityController,
                        focusNode: _totalQuantityFocusNode,
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
                      setState(() {
                        if(_totalQuantityController.text.trim() != ''){
                          widget.item.totalQuantity = int.parse(_totalQuantityController.text);
                        }else{
                          widget.item.totalQuantity = null;
                        }
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