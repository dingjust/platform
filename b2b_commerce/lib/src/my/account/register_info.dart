import 'package:b2b_commerce/src/home/account/login.dart';
import 'package:b2b_commerce/src/my/account/reset_password.dart';
import 'package:b2b_commerce/src/my/address/region_select.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class RegisterInfoPage extends StatefulWidget {
  final String phone;
  final String password;

  const RegisterInfoPage(
      {Key key, @required this.phone, @required this.password})
      : super(key: key);

  _RegisterInfoPageState createState() => _RegisterInfoPageState();
}

class _RegisterInfoPageState extends State<RegisterInfoPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _contactPersonController = TextEditingController();
  TextEditingController _contactPhoneController = TextEditingController();
  TextEditingController _line1Controller = TextEditingController();

  bool validate = false;

  DistrictModel districtModel;

  GlobalKey _scaffoldKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    _contactPhoneController.text = widget.phone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.5,
        iconTheme: IconThemeData(color: Color.fromRGBO(36, 38, 41, 1)),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          '注册',
          style: TextStyle(color: Color.fromRGBO(36, 38, 41, 1)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 50),
            padding: const EdgeInsets.fromLTRB(10, 20.0, 10, 20),
            child: Column(
              children: <Widget>[
                InputRow(
                  label: '公司名称（店铺名）',
                  field: TextField(
                    autofocus: false,
                    onChanged: (value) {
                      formValidate();
                    },
                    controller: _nameController,
                    decoration: InputDecoration(
                        hintText: '请输入', border: InputBorder.none),
                  ),
                ),
                InputRow(
                    label: '联系人',
                    field: TextField(
                      autofocus: false,
                      onChanged: (value) {
                        formValidate();
                      },
                      controller: _contactPersonController,
                      decoration: InputDecoration(
                          hintText: '请输入', border: InputBorder.none),
                    )),
                InputRow(
                    label: '联系方式',
                    field: TextField(
                      autofocus: false,
                      onChanged: (value) {
                        formValidate();
                      },
                      controller: _contactPhoneController,
                      keyboardType: TextInputType.phone,
                      //只能输入数字
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                          hintText: '请输入', border: InputBorder.none),
                    )),
                GestureDetector(
                  onTap: _selectRegionCityAndDistrict,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 0.5,
                                color: Color.fromRGBO(200, 200, 200, 1)))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 100,
                          margin: EdgeInsets.only(right: 20),
                          child: Text(
                            '经营地址',
                            style: TextStyle(
                                color: Color.fromRGBO(36, 38, 41, 1),
                                fontSize: 18),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            districtModel != null
                                ? '${districtModel.city.region.name}  ${districtModel.city.name} ${districtModel.name}'
                                : '选择省市区',
                            style: TextStyle(
                                color: Color.fromRGBO(150, 150, 150, 1),
                                fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InputRow(
                    label: '详细地址',
                    field: TextField(
                      autofocus: false,
                      onChanged: (value) {
                        formValidate();
                      },
                      controller: _line1Controller,
                      decoration: InputDecoration(
                          hintText: '请输入', border: InputBorder.none),
                    )),
              ],
            ),
          ),
          RaisedButton(
            onPressed: validate ? onSubmit : null,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            color: Color.fromRGBO(255, 214, 12, 1),
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              '注册',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  void formValidate() {
    setState(() {
      validate = _nameController.text.trim().length > 0 &&
          _contactPersonController.text.trim().length > 0 &&
          _contactPhoneController.text.trim().length > 0 &&
          _line1Controller.text.trim().length > 0 &&
          districtModel != null;
    });
  }

  void onSubmit() async {
    AddressModel contactAddress = AddressModel();
    contactAddress
      ..cityDistrict = districtModel
      ..city = districtModel.city
      ..region = districtModel.city.region
      ..line1 = _line1Controller.text;

    CompanyRegisterDTO form = CompanyRegisterDTO();
    form
      ..name = _nameController.text
      ..contactPerson = _contactPersonController.text
      ..contactPhone = _contactPhoneController.text
      ..mobileNumber = widget.phone
      ..password = widget.password
      ..contactAddress = contactAddress;

    print(CompanyRegisterDTO.toJson(form));

    String response = await UserRepositoryImpl().register(
        type: UserTypeMap[UserBLoC.instance.currentUser.type], form: form);

    if (response != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => B2BLoginPage(
                  isLoginSuccess: true,
                )),
        ModalRoute.withName('/'),
      );
    } else {
      showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (context) {
          return AlertDialog(
            title: Text('注册失败'),
            actions: <Widget>[
              FlatButton(
                child: Text('确定'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _selectRegionCityAndDistrict() async {
    DistrictModel result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegionSelectPage(RegionRepositoryImpl()),
      ),
    );

    if (result != null) {
      setState(() {
        districtModel = result;
      });
    }
  }
}
