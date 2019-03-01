import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class EmployeeFormPage extends StatefulWidget {
  EmployeeFormPage(this.item, {this.newlyCreated = false});

  final B2BCustomerModel item;
  final bool newlyCreated;

  EmployeeFormPageState createState() => EmployeeFormPageState();
}

class EmployeeFormPageState extends State<EmployeeFormPage> {
  final TextEditingController _nameController = TextEditingController();
  FocusNode _nameFocusNode = FocusNode();
  final TextEditingController _mobileNumberController = TextEditingController();
  FocusNode _mobileNumberFocusNode = FocusNode();

  List<EnumModel> enumModels = [];

  @override
  void initState() {
    if (widget.item?.roles != null)
      enumModels = widget.item.roles
          .map((role) => EnumModel(role.uid, role.name))
          .toList();
    // TODO: implement initState
    super.initState();
  }

  //格式选中的角色
  String formatRoleSelectsText() {
    String text = '';

    if (widget.item.roles != null) {
      text = '';
      for (int i = 0; i < widget.item.roles.length; i++) {
        if (i > 2) {
          text += '...';
          break;
        }

        if (i == widget.item.roles.length - 1) {
          text += widget.item.roles[i].name;
        } else {
          text += widget.item.roles[i].name + '、';
        }
      }
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('添加员工'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done, color: Color(0xffFF9516)),
            onPressed: () {
              print(widget.item.roles);
              print(widget.item.name);
              print(widget.item.mobileNumber);
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: ListView(
          children: <Widget>[
            TextFieldComponent(
              controller: _nameController,
              focusNode: _nameFocusNode,
              leadingText: '姓名',
              hintText: '请输入姓名',
            ),
            TextFieldComponent(
              controller: _mobileNumberController,
              focusNode: _mobileNumberFocusNode,
              leadingText: '手机号码',
              hintText: '请输入手机号码',
              inputType: TextInputType.number,
            ),
            InkWell(
                onTap: () async {
                  dynamic result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EnumSelectPage(
                            title: '选择角色/岗位',
                            items: <EnumModel>[
                              EnumModel('R001', '超级管理员'),
                              EnumModel('R002', '会计'),
                            ],
                            models: enumModels,
                            multiple: true,
                          ),
                    ),
                  );
                  if (result != null) enumModels = result;

                  widget.item.roles = enumModels
                      .map((model) =>
                          RoleModel(uid: model.code, name: model.name))
                      .toList();
                  print(widget.item.name);
                },
                child: ShowSelectTile(
                  leadingText: '角色/岗位',
                  tralingText: formatRoleSelectsText(),
                  tralingTextColor: Color(0xffFF9516),
                )),
          ],
        ),
      ),
    );
  }
}
