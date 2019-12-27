import 'dart:ui';

import 'package:b2b_commerce/src/common/address_picker.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class MyBrandAddressFormPage extends StatefulWidget {
  AddressModel addressModel;

  MyBrandAddressFormPage({
    this.addressModel,
  });

  _MyBrandAddressFormPageState createState() => _MyBrandAddressFormPageState();
}

class _MyBrandAddressFormPageState extends State<MyBrandAddressFormPage> {
  AddressModel _addressModel;

  TextEditingController _line1Controller = TextEditingController();

  FocusNode _line1FocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.addressModel != null) {
      _addressModel = AddressModel(
        region: widget.addressModel.region,
        city: widget.addressModel.city,
        cityDistrict: widget.addressModel.cityDistrict,
        line1: widget.addressModel.line1,
      );
    } else {
      _addressModel = AddressModel();
    }
    _line1Controller.text = _addressModel.line1 ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('企业地址'),
        centerTitle: true,
        elevation: 0.5,
        actions: <Widget>[
          IconButton(
              icon: Text('保存', style: TextStyle(color: Color(0xffffd60c))),
              onPressed: () {
                _addressModel.line1 = _line1Controller.text;
                Navigator.pop(context, _addressModel);
              }),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            _buildContactAddress(context),
            Divider(
              height: 0,
            ),
            _buildLine1(context),
            Divider(
              height: 0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLine1(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 5,
      ),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          RichText(
            text: TextSpan(children: [
              TextSpan(text: '详细地址', style: TextStyle(color: Colors.black)),
              TextSpan(text: '*', style: TextStyle(color: Colors.red)),
            ]),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: TextFieldComponent(
                padding: EdgeInsets.all(0),
                focusNode: _line1FocusNode,
                controller: _line1Controller,
                hintText: '请输入详细地址',
                hideDivider: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactAddress(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AddressPicker(cacel: () {
          Navigator.pop(context);
        }).showAddressPicker(
          context,
          selectProvince: (province) {
            _addressModel.region =
                RegionModel(isocode: province['code'], name: province['name']);
          },
          selectCity: (city) {
            _addressModel.city =
                CityModel(code: city['code'], name: city['name']);
          },
          selectArea: (area) {
            _addressModel.cityDistrict =
                DistrictModel(code: area['code'], name: area['name']);
            setState(() {});
          },
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: '省/市/区',
                    style: TextStyle(color: Colors.black, fontSize: 14)),
                TextSpan(
                    text: '*',
                    style: TextStyle(color: Colors.red, fontSize: 14)),
              ]),
            ),
            Expanded(
                child: Text(
              '${_addressModel?.region?.name}${_addressModel?.city?.name}${_addressModel?.cityDistrict?.name}',
              textAlign: TextAlign.end,
              style: TextStyle(color: Colors.grey),
            )),
            Icon(
              (Icons.chevron_right),
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
