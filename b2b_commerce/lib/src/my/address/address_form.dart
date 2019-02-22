import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

import 'region_select.dart';

class AddressFormPage extends StatefulWidget {
  AddressFormPage({this.address}) : newlyCreated = address == null;

  final AddressModel address;
  final bool newlyCreated;

  @override
  AddressFormState createState() => AddressFormState();
}

class AddressFormState extends State<AddressFormPage> {
  bool _defaultAddress;
  GlobalKey _addressForm = GlobalKey<FormState>();
  TextEditingController _fullnameController;
  TextEditingController _cellphoneController;
  TextEditingController _line1Controller;
  String regionCityAndDistrict;

  @override
  void initState() {
    super.initState();
    _defaultAddress = widget.address?.defaultAddress ?? false;
    _fullnameController = TextEditingController(text: widget.address?.fullname);
    _cellphoneController = TextEditingController(text: widget.address?.cellphone);
    _line1Controller = TextEditingController(text: widget.address?.line1);
    regionCityAndDistrict = !widget.newlyCreated ? widget.address.regionCityAndDistrict : "请选择省市区";
  }

  _selectRegionCityAndDistrict(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegionSelectPage(RegionRepositoryImpl()),
      ),
    ) as DistrictModel;

    if (result == null) {
      return;
    }

    RegionModel regionModel = result.city.region;
    CityModel cityModel = result.city;
    DistrictModel districtModel = result;

    regionCityAndDistrict = regionModel.name + cityModel.name + districtModel.name;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = <Widget>[
      TextFormField(
        controller: _fullnameController,
        decoration: InputDecoration(
          labelText: '联系人',
          prefixIcon: Icon(Icons.person),
        ),
        validator: (v) {
          return v.trim().length > 0 ? null : "联系人不能为空";
        },
      ),
      TextFormField(
        controller: _cellphoneController,
        decoration: InputDecoration(
          labelText: '联系号码',
          prefixIcon: Icon(Icons.phone),
        ),
        validator: (v) {
          print(v);
          return v.trim().length > 0 ? null : "联系号码不能为空";
        },
        keyboardType: TextInputType.phone,
      ),
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        onTap: () {
          _selectRegionCityAndDistrict(context);
        },
        title: Text(
          '省市区',
          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
        ),
        subtitle: Text(
          regionCityAndDistrict,
          style: TextStyle(color: Colors.black),
        ),
        trailing: Icon(Icons.chevron_right),
      ),
      TextFormField(
        controller: _line1Controller,
        decoration: InputDecoration(
          labelText: '详细地址',
          hintText: '道路、门牌号、小区、楼栋号、单元室等',
        ),
      ),
      ListTile(
        title: Text('设为默认地址'),
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        trailing: Switch(
          value: _defaultAddress,
          activeColor: Colors.pink,
          onChanged: (bool val) {
            setState(() {
              _defaultAddress = val;
            });
          },
        ),
      ),
    ];

    if (widget.address != null) {
      widgets.add(
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          title: RaisedButton(
            child: Text('删除地址'),
            color: Colors.red,
            onPressed: () {},
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text("编辑地址"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.done,
            ),
            onPressed: () {
              print((_addressForm.currentState as FormState).validate());
              if ((_addressForm.currentState as FormState).validate() != null) {
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Form(
          key: _addressForm,
          autovalidate: true,
          //使用ScrollView包装一下，否则键盘弹出时会报错空间溢出
          child: new SingleChildScrollView(
            child: Column(
              children: widgets,
            ),
          ),
        ),
      ),
    );
  }
}
