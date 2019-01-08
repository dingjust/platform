import 'dart:io';

import 'package:b2b_commerce/src/my/account/register.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterFactoryPage extends StatefulWidget {
  _RegisterFactoryPageState createState() => _RegisterFactoryPageState();
}

class _RegisterFactoryPageState extends State<RegisterFactoryPage> {
  GlobalKey _formKey = new GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressDetailController = TextEditingController();
  TextEditingController _contactPersonController = TextEditingController();
  TextEditingController _contactPhoneController = TextEditingController();
  TextEditingController _brandController = TextEditingController();
  TextEditingController _cooperativeBrandController = TextEditingController();

  File _certificateImage;

  //开发能力
  bool _developmentCapacity = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('工厂注册'),
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
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                      child: Row(
                        children: <Widget>[
                          Text('认证信息'),
                          Container(
                            margin: EdgeInsets.fromLTRB(15.0, 10, 15.0, 10.0),
                            width: 70.0,
                            height: 70.0,
                            child: _certificateImage == null
                                ? IconButton(
                                    onPressed: getCertificateImage,
                                    icon: Icon(Icons.add_photo_alternate),
                                    iconSize: 60.0,
                                    color: Colors.grey[500],
                                  )
                                : GestureDetector(
                                    onTap: getCertificateImage,
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                        image: FileImage(_certificateImage),
                                        fit: BoxFit.cover,
                                      )),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                        onTap: () {},
                        child: ListTile(
                          trailing: Icon(Icons.chevron_right),
                          leading: const Text('产值规模'),
                        )),
                    InkWell(
                        onTap: () {},
                        child: ListTile(
                          trailing: Icon(Icons.chevron_right),
                          leading: const Text('月产能'),
                        )),
                    InkWell(
                        onTap: () {},
                        child: ListTile(
                          trailing: Icon(Icons.chevron_right),
                          leading: const Text('优势品类'),
                        )),
                    InkWell(
                        onTap: () {},
                        child: ListTile(
                          trailing: Icon(Icons.chevron_right),
                          leading: const Text('合作方式'),
                        )),
                    InkWell(
                        onTap: () {},
                        child: ListTile(
                          trailing: Switch(
                            value: _developmentCapacity,
                            onChanged: (v) {
                              setState(() {
                                _developmentCapacity = v;
                              });
                            },
                          ),
                          leading: const Text('优势品类'),
                        )),
                    RegisterInput(
                      controller: _cooperativeBrandController,
                      labelText: '合作品牌',
                      remind: '请填写合作品牌',
                    ),
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

  Future getCertificateImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _certificateImage = image;
    });
  }
}
