import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class EmployeeFormPage extends StatefulWidget {
  EmployeeFormPage({Key key, @required this.item, this.newlyCreated = false})
      : super(key: const Key('__employeeFormPage__'));

  B2BCustomerModel item;
  final bool newlyCreated;

  EmployeeFormPageState createState() => EmployeeFormPageState();
}

class EmployeeFormPageState extends State<EmployeeFormPage> {
  final TextEditingController _nameController = TextEditingController();
  FocusNode _nameFocusNode = FocusNode();
  final TextEditingController _mobileNumberController = TextEditingController();
  FocusNode _mobileNumberFocusNode = FocusNode();

  B2BCustomerModel _beforeItem;
  List<EnumModel> enumModels;
  bool _enabled = true;

  @override
  void initState() {
    if (!widget.newlyCreated) _enabled = false;
    _nameController.text = widget.item?.name;
    _mobileNumberController.text = widget.item?.mobileNumber;

    enumModels = [];
    if (widget.item?.roles != null)
      enumModels.addAll(widget.item.roles
          .map((role) => EnumModel(role.uid, role.name))
          .toList());
    print(enumModels);
    // TODO: implement initState

    super.initState();
  }

  //格式选中的角色
  String formatRoleSelectsText() {
    String text = '';

    if (enumModels != null) {
      text = '';
      for (int i = 0; i < enumModels.length; i++) {
        if (i > 2) {
          text += '...';
          break;
        }

        if (i == enumModels.length - 1) {
          text += enumModels[i].name;
        } else {
          text += enumModels[i].name + '、';
        }
      }
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    _nameFocusNode.addListener((){
      if(_nameFocusNode.hasFocus){
        print(enumModels);
      }
    });

    return WillPopScope(
      onWillPop: () {
        if(_enabled){
          Navigator.pop(context, _beforeItem);
        }else{
          Navigator.pop(context);
        }
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: Text(widget.newlyCreated ? '添加员工' : '员工明细'),
          actions: <Widget>[
            IconButton(
              icon: Text(_enabled ? '确定':'编辑',style: TextStyle(color: Color(0xffFF9516)),),
              onPressed: () {
                setState(() {
                  _enabled = !_enabled;
                  FocusScope.of(context).requestFocus(_nameFocusNode);
                });
                if(_enabled){
                  _beforeItem = B2BCustomerModel(
                    name: widget.item.name,
                    mobileNumber: widget.item.mobileNumber,
                    roles: widget.item.roles,
                  );
                }

                if (widget.newlyCreated) {
                  widget.item.roles = null;
                  widget.item.name = null;
                  widget.item.mobileNumber = null;

                }
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
                leadingText: Text('姓名',style: TextStyle(fontSize: 16,)),
                hintText: '请输入姓名',
                onChanged: (value) {
                  widget.item.name = value;
                },
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(_mobileNumberFocusNode);
                },
                enabled: _enabled,
                autofocus: widget.newlyCreated,
                textInputAction: TextInputAction.next,
              ),
              TextFieldComponent(
                controller: _mobileNumberController,
                focusNode: _mobileNumberFocusNode,
                leadingText: Text('手机号码',style: TextStyle(fontSize: 16,)),
                hintText: '请输入手机号码（数字）',
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) {
                  widget.item.mobileNumber = value;
                },
                enabled: _enabled,
              ),
              InkWell(
                  onTap: () async {
                    if (_enabled) {
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
                    }
                  },
                  child: ShowSelectTile(
                    leadingText: '角色/岗位',
                    tralingText: formatRoleSelectsText(),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
