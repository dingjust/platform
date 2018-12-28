import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class MyCompanyFormPage extends StatefulWidget {
  _MyCompanyFormPageState createState() => _MyCompanyFormPageState();
}

class _MyCompanyFormPageState extends State<MyCompanyFormPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _telPhoneController = TextEditingController();
  TextEditingController _brandController = TextEditingController();
  TextEditingController _cooBrandController = TextEditingController();
  TextEditingController _companyNameController = TextEditingController();

  GlobalKey _formKey = new GlobalKey<FormState>();

  DateTime _registerDate = DateTime.now();
  File _headImage;
  List<File> _papersImages = [];

  @override
  Widget build(BuildContext context) {
    //上传图片行
    List<Widget> _papersWidgetList = _papersImages
        .map((file) => Container(
              width: 60.0,
              height: 60.0,
              child: Image.file(file),
            ))
        .toList();
    _papersWidgetList.add(Container(
      child: IconButton(
        onPressed: getPapersImage,
        icon: Icon(Icons.add_photo_alternate),
        iconSize: 60.0,
        color: Colors.grey[500],
      ),
    ));
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              tooltip: '确定',
              onPressed: () {},
            ),
          ],
        ),
        backgroundColor: Colors.grey[100],
        body: Form(
          key: _formKey,
          autovalidate: true,
          child: ListView(
            padding: EdgeInsets.fromLTRB(0, 10.0, 0, 20.0),
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 20),
                  child: Column(
                    children: <Widget>[
                      Text(
                        '基本信息',
                        style: TextStyle(fontSize: 18.0),
                      )
                    ],
                  )),
              Card(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text('上传头像'),
                              Container(
                                margin:
                                    EdgeInsets.fromLTRB(10.0, 10, 10.0, 10.0),
                                width: 70.0,
                                height: 70.0,
                                child: _headImage == null
                                    ? IconButton(
                                        onPressed: getHeadImage,
                                        icon: Icon(Icons.add_photo_alternate),
                                        iconSize: 60.0,
                                        color: Colors.grey[500],
                                      )
                                    : GestureDetector(
                                        onTap: getHeadImage,
                                        child: Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: FileImage(_headImage),
                                                fit: BoxFit.cover,
                                              )),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                          TextFormField(
                              autofocus: false,
                              controller: _nameController,
                              decoration: InputDecoration(
                                  labelText: '联系人',
                                  hintText: '请输入',
                                  border: InputBorder.none),
                              // 校验用户名
                              validator: (v) {
                                return v.trim().length > 0 ? null : '用户名不能为空';
                              }),
                          TextFormField(
                              autofocus: false,
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  labelText: '联系人手机',
                                  hintText: '请输入',
                                  border: InputBorder.none),
                              // 校验用户名
                              validator: (v) {
                                return v.trim().length > 0 ? null : '手机号不能为空';
                              }),
                          TextFormField(
                            autofocus: false,
                            controller: _telPhoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                labelText: '座机号码',
                                hintText: '请输入',
                                border: InputBorder.none),
                          ),
                          TextFormField(
                            autofocus: false,
                            controller: _brandController,
                            decoration: InputDecoration(
                                labelText: '品牌',
                                hintText: '请输入',
                                border: InputBorder.none),
                          ),
                          TextFormField(
                            autofocus: false,
                            controller: _cooBrandController,
                            decoration: InputDecoration(
                                labelText: '合作品牌',
                                hintText: '请输入',
                                border: InputBorder.none),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                        onTap: () {},
                        child: ListTile(
                          trailing: Icon(Icons.chevron_right),
                          leading: const Text('经营地址'),
                        )),
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
                          leading: const Text('风格'),
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
                          leading: const Text('年龄段'),
                        )),
                    InkWell(
                        onTap: () {},
                        child: ListTile(
                          trailing: Icon(Icons.chevron_right),
                          leading: const Text('价格段(春夏)'),
                        )),
                    InkWell(
                        onTap: () {},
                        child: ListTile(
                          trailing: Icon(Icons.chevron_right),
                          leading: const Text('价格段(秋冬)'),
                        )),
                  ],
                ),
              ),
              Container(
                  padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 20),
                  child: Column(
                    children: <Widget>[
                      Text(
                        '认证信息',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Text(
                        '认证信息改动需要提交给平台审核',
                        style: TextStyle(fontSize: 12.0, color: Colors.red),
                      )
                    ],
                  )),
              Card(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            autofocus: false,
                            controller: _companyNameController,
                            decoration: InputDecoration(
                                labelText: '公司名称',
                                hintText: '请输入',
                                border: InputBorder.none),
                          ),
                        ],
                      ),
                    ),
                    RegisterDateWell(
                      title: DateFormat('yMd').format(_registerDate),
                      selectedDate: _registerDate,
                      selectDate: (DateTime date) {
                        setState(() {
                          _registerDate = date;
                        });
                      },
                    ),
                    InkWell(
                        onTap: () {},
                        child: ListTile(
                          trailing: Icon(Icons.chevron_right),
                          leading: const Text('税号'),
                        )),
                    InkWell(
                        onTap: () {},
                        child: ListTile(
                          trailing: Icon(Icons.chevron_right),
                          leading: const Text('开户行'),
                        )),
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 20.0, 20.0, 0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  '认证证件',
                                  style: TextStyle(fontSize: 15.0),
                                ),
                                Text(
                                  '(营业执照)',
                                  style: TextStyle(fontSize: 12.0),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Wrap(
                                spacing: 5.0,
                                runSpacing: 5.0,
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: _papersWidgetList),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Future getHeadImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _headImage = image;
    });
  }

  Future getPapersImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _papersImages.add(image);
    });
  }
}

class InputRow extends StatelessWidget {
  InputRow(this.child);

  Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      decoration: BoxDecoration(
          // 下滑线浅灰色，宽度1像素
          border:
              Border(bottom: BorderSide(color: Colors.grey[300], width: 1.0))),
    );
  }
}

class RegisterDateWell extends StatelessWidget {
  const RegisterDateWell(
      {Key key, this.title, this.selectedDate, this.selectDate})
      : super(key: key);

  final String title;
  final DateTime selectedDate;
  final ValueChanged<DateTime> selectDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          _selectDate(context);
        },
        child: ListTile(
          trailing: Icon(Icons.chevron_right),
          leading: const Text('注册时间'),
          title: Text(title),
        ));
  }
}
