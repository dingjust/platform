import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class ContactWayField extends StatefulWidget{
  RequirementOrderModel item;
  ContactWayField(this.item);

  ContactWayFieldState createState() => ContactWayFieldState();
}

class ContactWayFieldState extends State<ContactWayField>{
  formatContactWayText(){
    StringBuffer text = StringBuffer();
    if(widget.item.contactPerson == null && widget.item.contactPhone == null){
      text.write('填写');
    }else{
      text.write(widget.item.contactPerson ?? '');
      text.write(',');
      text.write(widget.item.contactPhone ?? '');
    }
    return text.toString();
  }

  @override
  Widget build(BuildContext context) {
    FocusNode _contactPersonFocusNode = FocusNode();
    TextEditingController _contactPersonController = TextEditingController(text: widget.item.contactPerson ?? '');
    FocusNode _contactPhoneFocusNode = FocusNode();
    TextEditingController _contactPhoneController = TextEditingController(text: widget.item.contactPhone ?? '');

    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '联系方式',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
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
          showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (context) {
              return AlertDialog(
                title: Text('请输入联系方式'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      TextFieldComponent(
                        controller: _contactPersonController,
                        focusNode: _contactPersonFocusNode,
                        autofocus: true,
                        hintText: '请输入联系人',
                        padding: EdgeInsets.all(0),
                      ),
                      SizedBox(height: 10,),
                      TextFieldComponent(
                        controller: _contactPhoneController,
                        focusNode: _contactPhoneFocusNode,
                        inputType: TextInputType.number,
                        hintText: '请输入手机号码',
                        padding: EdgeInsets.all(0),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('确定'),
                    onPressed: () {
                      widget.item.contactPerson = _contactPersonController.text.trim() == '' ? null: _contactPersonController.text.trim();
                      widget.item.contactPhone = _contactPhoneController.text.trim() == '' ? null: _contactPhoneController.text.trim();
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