import 'package:flutter/material.dart';
import 'package:models/models.dart';

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