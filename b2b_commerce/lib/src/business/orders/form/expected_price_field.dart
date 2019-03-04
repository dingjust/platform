import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class ExpectedPriceField extends StatefulWidget{
  final RequirementOrderModel item;
  ExpectedPriceField(this.item);

  ExpectedPriceFieldState createState() => ExpectedPriceFieldState();
}

class ExpectedPriceFieldState extends State<ExpectedPriceField>{
  @override
  Widget build(BuildContext context) {
    FocusNode _expectedPriceFocusNode = FocusNode();
    TextEditingController _expectedPriceController = TextEditingController(text: widget.item.details?.maxExpectedPrice == null ? '':widget.item.details?.maxExpectedPrice.toString());

    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '期望价格',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
                widget.item.details?.maxExpectedPrice == null ? '填写':widget.item.details?.maxExpectedPrice.toString(),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
          ),
        ),
        onTap: () {
          showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (context) {
              return AlertDialog(
                title: Text('请输入期望价格'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      TextFieldComponent(
                        controller: _expectedPriceController,
                        focusNode: _expectedPriceFocusNode,
                        autofocus: true,
                        inputType: TextInputType.number,
                        hintText: '请输入期望价格',
                        padding: EdgeInsets.all(0),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('确定'),
                    onPressed: () {
                      setState(() {
                        if(_expectedPriceController.text.trim() != ''){
                          widget.item.details.maxExpectedPrice = double.parse(_expectedPriceController.text);
                        }else{
                          widget.item.details.maxExpectedPrice = null;
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