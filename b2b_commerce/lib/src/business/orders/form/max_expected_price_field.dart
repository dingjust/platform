import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class MaxExpectedPriceField extends StatefulWidget{
  final RequirementOrderModel item;
  MaxExpectedPriceField(this.item);

  MaxExpectedPriceFieldState createState() => MaxExpectedPriceFieldState();
}

class MaxExpectedPriceFieldState extends State<MaxExpectedPriceField>{
  @override
  Widget build(BuildContext context) {
    FocusNode _maxExpectedPriceFocusNode = FocusNode();
    TextEditingController _maxExpectedPriceController = TextEditingController(text: widget.item.details?.maxExpectedPrice == null ? '':widget.item.details?.maxExpectedPrice.toString());

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
            trailing: Text('${widget.item.details?.maxExpectedPrice ?? '填写'}',
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
                        controller: _maxExpectedPriceController,
                        focusNode: _maxExpectedPriceFocusNode,
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
                        if(_maxExpectedPriceController.text.trim() != ''){
                          widget.item.details.maxExpectedPrice = double.parse(_maxExpectedPriceController.text);
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