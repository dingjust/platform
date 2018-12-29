import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class EmployeeFormPage extends StatelessWidget {
  EmployeeFormPage(this.item) : newlyCreated = item == null;

  final B2BCustomerModel item;
  final bool newlyCreated;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: !newlyCreated ? Text('员工明细') : Text('添加员工'),
      ),
      body: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: !newlyCreated ? ReadonlyEmployeeForm(item) : EditableEmployeeForm(item),
      ),
    );
  }
}

class ReadonlyEmployeeForm extends StatelessWidget {
  ReadonlyEmployeeForm(this.item);

  final B2BCustomerModel item;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: const Text('姓名'),
          trailing: Text('${item.name}'),
        ),
        Divider(),
        ListTile(
          title: const Text('手机号码'),
          trailing: Text('${item.mobileNumber}'),
        ),
        Divider(),
        ListTile(
          title: const Text('角色/岗位'),
          trailing: Text('TODO'),
        ),
        Divider(),
      ],
    );
  }
}

class EditableEmployeeForm extends StatelessWidget {
  EditableEmployeeForm(this.item);

  final B2BCustomerModel item;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: '姓名',
              hintText: '请输入姓名',
              prefixIcon: Icon(Icons.person),
            ),
          ),
        ),
        ListTile(
          title: TextField(
            controller: _mobileNumberController,
            decoration: InputDecoration(
              labelText: '手机号码',
              hintText: '请输入手机号码',
              prefixIcon: Icon(Icons.phone),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EnumSelectPage(
                      '选择角色/岗位',
                      <EnumModel>[
                        EnumModel('R001', '超级管理员'),
                        EnumModel('R002', '会计'),
                      ],
                    ),
              ),
            );
          },
          child: ListTile(
            title: Text('角色/岗位'),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
      ],
    );
  }
}
