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
  AddressModel _address;

  @override
  void initState() {
    _address = AddressModel(
      fullname: widget.model?.fullname,
      cellphone: widget.model?.cellphone,
      region: widget.model?.region,
      city: widget.model?.city,
      cityDistrict: widget.model?.cityDistrict,
      line1: widget.model?.line1,
      defaultAddress: widget.model?.defaultAddress,
    );
    _lineController.text =  widget.model.line1 ?? '';
    _nameController.text =  widget.model.fullname ?? '';
    _phoneController.text =  widget.model.cellphone ?? '';
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
                      ),
                    ),
                  ),
                  onTap: () async {
                    _address.fullname = _nameController.text == '' ? null : _nameController.text;
                    _address.cellphone = _phoneController.text == '' ? null : _phoneController.text;
                    _address.line1 = _lineController.text == '' ? null : _lineController.text;

                    //带值返回上一页
                    Navigator.of(context).pop(_address);
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
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            child: TextFieldComponent(
              focusNode: _nameFocusNode,
              controller: _nameController,
              leadingText: '联系人名',
              hintText: _address.fullname ?? '请输入联系人名',
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            child: TextFieldComponent(
              focusNode: _phoneFocusNode,
              controller: _phoneController,
              leadingText: '联系电话',
              hintText: _address.cellphone ?? '请输入联系电话',
              inputType: TextInputType.phone,
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                InkWell(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Text('省市区',style: TextStyle(fontSize: 16,),),),
                        Text(_address.region != null ? _address.regionCityAndDistrict : '选取',style: TextStyle(color: Colors.grey,),),
                        Icon(Icons.chevron_right,color: Colors.grey,),
                      ],
                    ),
                  ),
                  onTap: (){
                    AddressPicker(cacel: () {
                      Navigator.pop(context);
                    }).showAddressPicker(
                      context,
                      selectProvince: (province) {
                        _address.region = RegionModel.fromJson(province);
                      },
                      selectCity: (city) {
                        _address.city = CityModel.fromJson(city);
                      },
                      selectArea: (area) {
                        setState(() {
                          _address.cityDistrict = DistrictModel.fromJson(area);
                        });
                      },
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Divider(height: 0,color: Colors.grey,),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            child: TextFieldComponent(
                focusNode: _lineFocusNode,
                controller: _lineController,
                leadingText: '详细地址',
                hintText: _address.line1 ?? '请输入详细地址'
            ),
          ),
        ],
      ),
    );
  }

}