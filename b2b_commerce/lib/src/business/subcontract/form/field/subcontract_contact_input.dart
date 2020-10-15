import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';


class SubContractContactInput extends StatefulWidget{
  SubContractModel item;

  SubContractContactInput(this.item);
  _SubContractContactInputState createState() => _SubContractContactInputState();
}

class _SubContractContactInputState extends State<SubContractContactInput>{
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
                            color: Colors.black),
                      ),
                    ),
                  ),
                  onTap: () async {
                    widget.item.details.contactPerson = _nameController.text == '' ? null : _nameController.text;
                    widget.item.details.contactPhone = _phoneController.text == '' ? null : _phoneController.text;
                    List<String> result = [
                      widget.item.details.contactPerson,
                      widget.item.details.contactPhone
                    ];
                    Navigator.pop(context, result);
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
              leadingText: Text('联系人名',style: TextStyle(fontSize: 16,)),
              hintText: '请输入联系人名',
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            child: TextFieldComponent(
              focusNode: _phoneFocusNode,
              controller: _phoneController,
              leadingText: Text('联系电话',style: TextStyle(fontSize: 16,)),
              hintText: '请输入联系电话',
              inputType: TextInputType.phone,
            ),
          ),
        ],
      ),
    );
  }

}