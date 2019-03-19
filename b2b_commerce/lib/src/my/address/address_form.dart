import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'region_select.dart';

class AddressFormPage extends StatefulWidget {
  AddressFormPage({this.address,this.newlyCreated = false});

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
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _cellphoneFocusNode = FocusNode();
  FocusNode _line1FocusNode = FocusNode();
  String regionCityAndDistrict;

  @override
  void initState() {
    super.initState();
    if(widget.address.defaultAddress == null) widget.address.defaultAddress = false;
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

    widget.address.cityDistrict = result;
    widget.address.city = result.city;
    widget.address.region = result.city.region;

    regionCityAndDistrict = widget.address.region.name + widget.address.city.name + widget.address.cityDistrict.name;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = <Widget>[
      TextFieldComponent(
        focusNode: _nameFocusNode,
        controller: _fullnameController,
        leadingText: '联系人',
        hintText: '请输入联系人',
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      ),
      TextFieldComponent(
        focusNode: _cellphoneFocusNode,
        controller: _cellphoneController,
        leadingText: '联系号码',
        hintText: '请输入联系号码',
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
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
      TextFieldComponent(
        focusNode: _line1FocusNode,
        controller: _line1Controller,
        leadingText: '详细地址',
        hintText: '道路、门牌号、小区、楼栋号、单元室等',
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      ),
      ListTile(
        title: Text('设为默认地址'),
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        trailing: Switch(
          value: widget.address.defaultAddress,
          activeColor: Color.fromRGBO(255, 214, 12, 1),
          onChanged: (bool val) {
            setState(() {
              widget.address.defaultAddress = val;
            });
          },
        ),
      ),
    ];

    if (!widget.newlyCreated) {
      widgets.add(
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          title: RaisedButton(
            child: Text('删除地址',style: TextStyle(color: Colors.white),),
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
            icon: Text('确定',style: TextStyle(color: Color.fromRGBO(255, 214, 12, 1),),),
            onPressed: () async{
              if(_fullnameController.text == '' && _cellphoneController.text == ''){
                showDialog(
                    context: (context),
                    builder: (context) => AlertDialog(
                      content: Text('联系人和联系电话不可为空'),
                    ));
                return;
              }
              if(widget.address.region == null){
                showDialog(
                    context: (context),
                    builder: (context) => AlertDialog(
                      content: Text('省市区不可为空'),
                    ));
                return;
              }
              if(_line1Controller.text == ''){
                showDialog(
                    context: (context),
                    builder: (context) => AlertDialog(
                      content: Text('详细地址不可为空'),
                    ));
                return;
              }
              widget.address.fullname = _fullnameController.text;
              widget.address.cellphone = _cellphoneController.text;
              widget.address.line1 = _line1Controller.text;

              if(widget.newlyCreated){
                await AddressRepositoryImpl().create(widget.address).then((a)=>Navigator.pop(context));
              }else{
                await AddressRepositoryImpl().update(widget.address).then((a)=>Navigator.pop(context));
              }

              AddressBLoC.instance.filterByStatuses('');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: new SingleChildScrollView(
          child: Column(
            children: widgets,
          ),
        ),
      ),
    );
  }
}
