import 'package:b2b_commerce/src/common/address_picker.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';


class OfflineContactsInput extends StatefulWidget{
  AddressModel model;
  OfflineContactsInput({this.model});
  _OfflineContactsInputState createState() => _OfflineContactsInputState();
}

class _OfflineContactsInputState extends State<OfflineContactsInput>{
  FocusNode _lineFocusNode = FocusNode();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  final TextEditingController _lineController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  AddressModel addressModel = new AddressModel();
  String address;

  @override
  void initState() {
    addressModel = widget.model;
    if(addressModel != null){
      if(addressModel.region != null && addressModel.region.name != null && addressModel.region.name != ''
      && addressModel.city != null && addressModel.city.name != null && addressModel.city.name != ''
          && addressModel.cityDistrict != null && addressModel.cityDistrict.name != null &&
          addressModel.cityDistrict.name != ''){
        address = addressModel.region.name + addressModel.city.name +
            addressModel.cityDistrict.name;
      }

      _lineController.text = addressModel.line1;
      _nameController.text = addressModel.fullname;
      _phoneController.text = addressModel.cellphone;

    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('联系方式'),
            elevation: 0.5,
            brightness: Brightness.light,
            centerTitle: true,
            actions: <Widget>[
              GestureDetector(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Center(
                      child: Text(
                        '确定',
                        style: TextStyle(
                            color: Colors.black),
                      ),
                    ),
                  ),
                  onTap: () async {
                    //带值返回上一页
                    Navigator.of(context).pop(addressModel);
                  }
              )
            ]
        ),
        body: Container(
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                _buildFactoryInfo(context),
              ],
            ))
    );
  }

  Widget _buildFactoryInfo(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          GestureDetector(
              child: Container(
                padding: EdgeInsets.fromLTRB(15, 20, 5, 0),
                child: ListTile(
                    leading: Text(
                      '送货地址',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: address == null ||
                        address == ''
                        ? Icon(Icons.keyboard_arrow_right)
                        :
                    Container(
                      width: 150,
                      child: Text(
                        addressModel.region.name + addressModel.city.name +
                            addressModel.cityDistrict.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey
                        ),
                      ),
                    )
                ),
              ),
              onTap: () {
                address = '';
                setState(() {
                  address = address;
                });
                AddressPicker(cacel: () {
                  Navigator.pop(context);
                }).showAddressPicker(
                  context,
                  selectProvince: (province) {
                    address += province['name'];
                    addressModel.region = RegionModel.fromJson(province);
                  },
                  selectCity: (city) {
                    address += city['name'];
                    addressModel.city = CityModel.fromJson(city);
                  },
                  selectArea: (area) {
                    address += area['name'];
                    addressModel.cityDistrict = DistrictModel.fromJson(area);
                    setState(() {
                      address = address;
                    });
                  },
                );
              }),
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            child: TextFieldComponent(
              focusNode: _lineFocusNode,
              controller: _lineController,
              leadingText: '详细地址',
              hintText: addressModel == null || addressModel.line1 == null|| addressModel.line1 == ''
                  ? '请输入详细地址'
                  : addressModel.line1,
              onChanged: (value) {
                setState(() {
                  addressModel.line1 = value;
                });
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            child: TextFieldComponent(
              focusNode: _nameFocusNode,
              controller: _nameController,
              leadingText: '联系人名',
              hintText: addressModel == null || addressModel.fullname == null ?'请输入联系人名':addressModel.fullname,
              onChanged: (value) {
                setState(() {
                  addressModel.fullname = value;
                });
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            child: TextFieldComponent(
              focusNode: _phoneFocusNode,
              controller: _phoneController,
              leadingText: '联系电话',
              hintText: addressModel == null || addressModel.cellphone == null ?'请输入联系电话':addressModel.cellphone,
              inputType: TextInputType.phone,
              onChanged: (value) {
                setState(() {
                  addressModel.cellphone = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

}