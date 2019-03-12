import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';


class RequirmentOrderContactInput extends StatefulWidget{
  RequirementOrderModel item;

  RequirmentOrderContactInput(this.item);
  _RequirmentOrderContactInputState createState() => _RequirmentOrderContactInputState();
}

class _RequirmentOrderContactInputState extends State<RequirmentOrderContactInput>{
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  Map<String,Object> map;

  void initState(){
    _nameController.text = widget.item.details.contactPerson;
    _phoneController.text = widget.item.details.contactPhone;
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('输入联系方式信息'),
            elevation: 0.5,
            brightness: Brightness.light,
            centerTitle: true,
            actions: <Widget>[
              GestureDetector(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Center(
                      child: Text(
                        '确定',
                        style: TextStyle(
                            color: Color.fromRGBO(255, 149, 22, 1)),
                      ),
                    ),
                  ),
                  onTap: () async {
                    widget.item.details.contactPerson = _nameController.text == '' ? null : _nameController.text;
                    widget.item.details.contactPhone = _phoneController.text == '' ? null : _phoneController.text;
                    Navigator.pop(context);
                  }
              )
            ]
        ),
        body: Container(
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                _buildFactoryInfo(context),
              ],
            ))
    );
  }

  Widget _buildFactoryInfo(BuildContext context){
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            child: TextFieldComponent(
              focusNode: _nameFocusNode,
              controller: _nameController,
              autofocus: true,
              leadingText: '联系人名',
              hintText: '请输入联系人名',
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            child: TextFieldComponent(
              focusNode: _phoneFocusNode,
              controller: _phoneController,
              leadingText: '联系电话',
              hintText: '请输入联系电话',
              inputType: TextInputType.phone,
            ),
          ),
        ],
      ),
    );
  }

}