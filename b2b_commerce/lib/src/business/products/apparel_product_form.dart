import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

import 'apparel_product_attributes_input.dart';
import 'apparel_product_prices_input.dart';
import 'apparel_product_privacy_select.dart';
import 'apparel_product_stock_input.dart';
import 'apparel_product_variants_input.dart';

class ApparelProductFormPage extends StatefulWidget {
  ApparelProductFormPage({this.item});

  final ApparelProductModel item;

  ApparelProductFormState createState() => ApparelProductFormState();
}

class ApparelProductFormState extends State<ApparelProductFormPage> {
  bool _postageFree = false;
  final GlobalKey _apparelProductForm = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _skuIDController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  List<File> _masterImages = [];
  List<File> _detailImages = [];

  @override
  void initState() {
    _nameController.text = widget.item?.name;
    _skuIDController.text = widget.item?.skuID;
    _brandController.text = widget.item?.brand;
    _weightController.text = widget.item?.gramWeight?.toString();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('编辑商品'),
      ),
      body: Container(
//        color: Colors.grey[200],
        child: Form(
          key: _apparelProductForm,
          autovalidate: false,
          child: ListView(
            children: <Widget>[
              Container(
                  margin:
                      EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '上传主图',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '（最多5张）',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      )
                    ],
                  )),
             AlbumsAndCameras(images: _masterImages,height: 100,width: 100,iconSize:100,),
              Container(
                margin:
                    EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Text(
                      '上传详情图',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '（最多8张）',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ),
              AlbumsAndCameras(images: _detailImages,height: 100,width: 100,iconSize:100,),
              ListTile(
                leading: Text(
                  '产品名称：',
                  style: TextStyle(fontSize: 16),
                ),
                title: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '请输入产品名称，必填',
                  ),
                  validator: (v) {
                    return v.trim().length > 0 ? null : "产品名称不能为空";
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  height: 0,
                  color: Colors.blueGrey,
                ),
              ),
              ListTile(
                leading: Text(
                  '产品货号：',
                  style: TextStyle(fontSize: 16),
                ),
                title: TextFormField(
                  controller: _skuIDController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '请输入产品货号，必填',
                  ),
                  validator: (v) {
                    return v.trim().length > 0 ? null : "产品货号不能为空";
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  height: 0,
                  color: Colors.blueGrey,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EnumSelectPage(
                            '选择大类',
                            <EnumModel>[
                              EnumModel('R001', '针织'),
                              EnumModel('R002', '其他'),
                            ],
                          ),
                    ),
                  );
                },
                child: ListTile(
                  title: Text('选择大类'),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  height: 0,
                  color: Colors.blueGrey,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EnumSelectPage(
                            '选择小类',
                            <EnumModel>[
                              EnumModel('R001', '针织'),
                              EnumModel('R002', '其他'),
                            ],
                          ),
                    ),
                  );
                },
                child: ListTile(
                  title: Text('选择小类'),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  height: 0,
                  color: Colors.blueGrey,
                ),
              ),
              ListTile(
                leading: Text(
                  '品牌：',
                  style: TextStyle(fontSize: 16),
                ),
                title: TextFormField(
                  controller: _brandController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '请输入品牌，必填',
                  ),
                  validator: (v) {
                    return v.trim().length > 0 ? null : "品牌不能为空";
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  height: 0,
                  color: Colors.blueGrey,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApparelProductPricesInputPage(),
                    ),
                  );
                },
                child: ListTile(
                  title: Text('价格'),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  height: 0,
                  color: Colors.blueGrey,
                ),
              ),
              ListTile(
                leading: Text(
                  '重量(kg)：',
                  style: TextStyle(fontSize: 16),
                ),
                title: TextFormField(
                  controller: _weightController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '请输入重量，必填',
                  ),
                  validator: (v) {
                    return v.trim().length > 0 ? null : "重量不能为空";
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  height: 0,
                  color: Colors.blueGrey,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApparelProductVariantsInputPage(),
                    ),
                  );
                },
                child: ListTile(
                  title: Text('颜色/尺码'),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  height: 0,
                  color: Colors.blueGrey,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApparelProductStockInputPage(),
                    ),
                  );
                },
                child: ListTile(
                  title: Text('库存'),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  height: 0,
                  color: Colors.blueGrey,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApparelProductAttributesInputPage(),
                    ),
                  );
                },
                child: ListTile(
                  title: Text('属性'),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  height: 0,
                  color: Colors.blueGrey,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApparelProductPrivacySelectPage(),
                    ),
                  );
                },
                child: ListTile(
                  title: Text('款式保护'),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  height: 0,
                  color: Colors.blueGrey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListTile(
                  title: Text('是否免邮'),
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  trailing: Switch(
                    value: _postageFree,
                    activeColor: Colors.pink,
                    onChanged: (bool val) {
                      setState(() {
                        _postageFree = val;
                      });
                    },
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ActionChip(
                        backgroundColor: Colors.red,
                        labelPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 22),
                        labelStyle: TextStyle(fontSize: 16),
                        label: Text('发布商品'),
                        onPressed: () {},
                      ),
                    ),
                    Expanded(
                      child: ActionChip(
                        backgroundColor: Colors.orange,
                        labelPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 22),
                        labelStyle: TextStyle(fontSize: 16),
                        label: Text('直接上架'),
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
