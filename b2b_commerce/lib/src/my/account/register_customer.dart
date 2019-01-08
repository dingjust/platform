import 'package:b2b_commerce/src/my/account/register.dart';
import 'package:flutter/material.dart';

class RegisterCustomerPage extends StatefulWidget {
  _RegisterCustomerPageState createState() => _RegisterCustomerPageState();
}

class _RegisterCustomerPageState extends State<RegisterCustomerPage> {
  GlobalKey _formKey = new GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressDetailController = TextEditingController();
  TextEditingController _contactPersonController = TextEditingController();
  TextEditingController _contactPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('采购商注册'),
        ),
        backgroundColor: Colors.grey[100],
        body: Form(
          key: _formKey,
          autovalidate: true,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 20),
            children: <Widget>[
              Card(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Column(
                  children: <Widget>[
                    RegisterInput(
                      controller: _contactPersonController,
                      labelText: '联系人',
                      remind: '请填写联系人',
                    ),
                    RegisterInput(
                      controller: _contactPhoneController,
                      labelText: '联系电话',
                      remind: '请填写联系人电话',
                    ),
                    RegisterInput(
                      controller: _nameController,
                      labelText: '公司名称',
                      remind: '请填写公司名称',
                    ),
                    InkWell(
                        onTap: () {},
                        child: ListTile(
                          trailing: Icon(Icons.chevron_right),
                          leading: const Text('经营地址'),
                        )),
                    RegisterInput(
                      controller: _addressDetailController,
                      labelText: '详细地址',
                      remind: '请填写详细地址',
                    ),
                    InkWell(
                        onTap: () {},
                        child: ListTile(
                          trailing: Icon(Icons.chevron_right),
                          leading: const Text('采购需求'),
                        )),
                  ],
                ),
              ),
              RaisedButton(
                onPressed: () {},
                color: Colors.blue,
                child: Text(
                  '提交审核',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ));
  }
}
