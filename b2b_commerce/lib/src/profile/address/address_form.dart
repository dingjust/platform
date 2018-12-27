import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'region_select.dart';

class AddressFormPage extends StatefulWidget {
  final AddressModel address;

  AddressFormPage(this.address);

  @override
  AddressFormState createState() => AddressFormState();
}

class AddressFormState extends State<AddressFormPage> {
  bool _isDefault = false;
  GlobalKey _addressForm = new GlobalKey<FormState>();
  TextEditingController _fullnameController = new TextEditingController();
  TextEditingController _cellphoneController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _isDefault = widget.address?.defaultAddress ?? false;
  }

  @override
  Widget build(BuildContext context) {
    String province = null;
    if (widget?.address != null) {
      province = widget.address.region.name +
          widget.address.city.name +
          widget.address.cityDistrict.name;
    } else {
      province = "请选择省市区";
    }

    List<Widget> widgets = <Widget>[
      TextFormField(
        initialValue: widget.address?.fullname,
        //controller: _fullnameController,
        decoration: InputDecoration(
          labelText: "联系人",
          icon: Icon(Icons.person),
        ),
//        validator: (v){
//          return v.trim().length >0 ? null : "联系人不能为空";
//        },
      ),
      TextFormField(
        initialValue: widget.address?.cellphone,
        //controller: _cellphoneController,
        decoration: InputDecoration(
          labelText: "联系号码",
          icon: Icon(Icons.phone),
        ),
//        validator: (v){
//          print(v);
//          return v.trim().length >0 ? null : "联系人不能为空";
//        },
      ),
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegionSelectPage()),
          );
        },
        title: Text(
          "省市区",
          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
        ),
        subtitle: Text(
          province,
          style: TextStyle(color: Colors.black),
        ),
        trailing: Icon(Icons.chevron_right),
      ),
      TextFormField(
        initialValue: widget.address?.line1,
        decoration: InputDecoration(
          labelText: "详细地址",
          hintText: "道路、门牌号、小区、楼栋号、单元室等",
        ),
      ),
      ListTile(
        title: Text("设为默认地址"),
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        trailing: Switch(
            value: _isDefault,
            activeColor: Colors.pink,
            onChanged: (bool val) {
              setState(() {
                _isDefault = val;
              });
            }),
      ),
    ];

    if (widget.address != null) {
      widgets.add(
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          title: RaisedButton(
            child: Text("删除地址"),
            color: Colors.red,
            onPressed: () {},
          ),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("编辑地址"),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.done,
                color: Colors.white,
              ),
              onPressed: () {
                print((_addressForm.currentState as FormState).validate());
                if((_addressForm.currentState as FormState).validate() != null){
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
        ));
  }
}
