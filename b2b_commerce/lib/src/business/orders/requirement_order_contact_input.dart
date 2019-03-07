import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';


class RequirmentOrderContactInput extends StatefulWidget{
  _RequirmentOrderContactInputState createState() => _RequirmentOrderContactInputState();
}

class _RequirmentOrderContactInputState extends State<RequirmentOrderContactInput>{
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  Map<String,Object> map;
  String contactName;
  String contactPhone;

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
                    //带值返回上一页
                    Navigator.of(context).pop(contactName + ',' + contactPhone);
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
              leadingText: '联系人名',
              hintText: '请输入联系人名',
                  onChanged: (value){
                    contactName = value;
                  },
            ),
//            decoration: new BoxDecoration(
//              border: new Border.all(width: 1.0, color: Colors.black26),
//              borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
//            ),
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
                  onChanged: (value){
                    contactPhone = value;
                  },
            ),
//            decoration: new BoxDecoration(
//              border: new Border.all(width: 1.0, color: Colors.black26),
//              borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
//            ),
          ),
        ],
      ),
    );
  }

}