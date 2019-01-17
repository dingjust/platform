import 'package:b2b_commerce/src/common/app_enums.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class MembershipForm extends StatelessWidget {
  MembershipForm(this.item) : newlyCreated = item == null;

  final bool newlyCreated;
  final MembershipModel item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: !newlyCreated ? Text('会员明细') : Text('添加会员'),
      ),
      body: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: !newlyCreated ? ReadonlyMembershipForm(item) : EditableMembershipForm(item),
      ),
    );
  }
}

class ReadonlyMembershipForm extends StatelessWidget {
  ReadonlyMembershipForm(this.item);

  final MembershipModel item;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: const Text('姓名'),
          trailing: Text('${item.customer.name}'),
        ),
        Divider(),
        ListTile(
          title: const Text('手机号码'),
          trailing: Text('${item.customer.mobileNumber}'),
        ),
        Divider(),
        ListTile(
          title: const Text('会员等级'),
          trailing: Text(AppEnums.MemberRatings[item.level].name),
        ),
        Divider(),
      ],
    );
  }
}

class EditableMembershipForm extends StatelessWidget {
  EditableMembershipForm(this.item);

  final MembershipModel item;

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
                builder: (context) => EnumSelectPage(title:'选择会员等级', items:AppEnums.MemberRatingList),
              ),
            );
          },
          child: ListTile(
            title: Text('会员等级'),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
      ],
    );
  }
}
