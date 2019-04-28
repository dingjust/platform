import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'region_select.dart';

class ContactAddressFormPage extends StatefulWidget {
  ContactAddressFormPage({this.address});

  final AddressModel address;

  @override
  ContactAddressFormPageState createState() => ContactAddressFormPageState();
}

class ContactAddressFormPageState extends State<ContactAddressFormPage> {
  TextEditingController _line1Controller;
  FocusNode _line1FocusNode = FocusNode();
  String regionCityAndDistrict;

  @override
  void initState() {
    super.initState();
    _line1Controller = TextEditingController(text: widget.address?.line1);
    if(widget.address != null && widget.address.region!=null && widget.address.city !=null && widget.address.cityDistrict != null){
      regionCityAndDistrict =  widget.address.region.name+widget.address.city.name+widget.address.cityDistrict.name ;
    }else{
      regionCityAndDistrict = '';
    }
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
        leadingText: Text('详细地址',style: TextStyle(fontSize: 16,)),
        hintText: '道路、门牌号、小区、楼栋号、单元室等',
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        dividerPadding: EdgeInsets.symmetric(),
      ),
    ];


    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text("编辑地址"),
        actions: <Widget>[
          IconButton(
            icon: Text('确定',style: TextStyle(),),
            onPressed: () async{
              Navigator.of(context).pop(widget.address);
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
