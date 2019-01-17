import 'dart:io';

import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

import 'apparel_product_attributes_input.dart';
import 'apparel_product_prices_input.dart';
import 'apparel_product_privacy_select.dart';
import 'apparel_product_stock_input.dart';
import 'apparel_product_variants_input.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ApparelProductFormPage extends StatefulWidget {
  ApparelProductFormPage({this.item});

  final ApparelProductModel item;

  ApparelProductFormState createState() => ApparelProductFormState();
}

class ApparelProductFormState extends State<ApparelProductFormPage> {
  bool _postageFree = false;
  final GlobalKey _apparelProductForm = GlobalKey<FormState>();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _skuIDFocusNode = FocusNode();
  FocusNode _brandFocusNode = FocusNode();
  FocusNode _weightFocusNode = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _skuIDController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  List<File> _masterImages = [];
  List<File> _detailImages = [];

  String _minorCategoryText;

  Future<List<File>> _cachedImage(List<String> urls,List<File> files) async {
    var cacheManager = await CacheManager.getInstance();
    urls.forEach((url)async{
      var file = await cacheManager.getFile(url);
      files.add(file);
      print(files);
    });

//    CacheManager.inBetweenCleans = new Duration(days: 7);
    print(files);
    return files;
  }

  @override
  void initState(){
    _nameController.text = widget.item?.name;
    _skuIDController.text = widget.item?.skuID;
    _brandController.text = widget.item?.brand;
    _weightController.text = widget.item?.gramWeight?.toString();
    _minorCategoryText = widget.item?.minorCategory?.name;

    if(widget.item?.picture != null){
      _cachedImage(widget.item?.picture,<File>[]).then((files){
//        print(files);
        files.forEach((file){
          setState(() {
            _masterImages.add(file);
          });
        });
      });
    }
    if(widget.item?.detail != null){
      _cachedImage(widget.item?.detail,<File>[]).then((files){
        files.forEach((file){
          setState(() {
            _detailImages.add(file);
          });
        });
      });
    }


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
              AlbumsAndCameras(
                images: _masterImages,
                height: 100,
                width: 100,
                iconSize: 100,
                count: 5,
              ),
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
              AlbumsAndCameras(
                images: _detailImages,
                height: 100,
                width: 100,
                iconSize: 100,
                count: 8,
              ),
              TextFieldComponent(
                focusNode: _nameFocusNode,
                controller: _nameController,
                leadingText: '商品名称',
                hintText: '请输入商品名称，必填',
              ),
              TextFieldComponent(
                focusNode: _skuIDFocusNode,
                controller: _skuIDController,
                leadingText: '商品货号',
                hintText: '请输入商品货号，必填',
              ),
              InkWell(
                onTap: () async {
                EnumModel category = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EnumSelectPage(
                            title:'选择分类',
                            items:<EnumModel>[
                              EnumModel('R001', '男装'),
                              EnumModel('R002', '女装'),
                            ],
                          ),
                    ),
                  );

                 _minorCategoryText = category.name;
                },
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text('选择分类',style: TextStyle(fontSize: 16),),),
                      _minorCategoryText != null ? Text(_minorCategoryText,style: TextStyle(color: Colors.orange ),) : Text(''),
                      Icon(Icons.chevron_right,color: Colors.grey[600],)
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  height: 0,
                  color: Colors.grey[400],
                ),
              ),
              TextFieldComponent(
                focusNode: _brandFocusNode,
                controller: _brandController,
                leadingText: '品牌',
                hintText: '请输入品牌，必填',
              ),
              InkWell(
                onTap: ()async {
                  Map<String,double> priceMap = Map();
                  priceMap['price'] = widget.item?.price;
                  priceMap['suggestedPrice'] = widget.item?.suggestedPrice;
                  priceMap['price1'] = widget.item?.price1;
                  priceMap['price2'] = widget.item?.price2;
                  priceMap['price3'] = widget.item?.price3;

                  Map<String,double> result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApparelProductPricesInputPage(priceMap: priceMap,),
                    ),
                  );

                  if (result != null && result.length > 0) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(result.toString()),
                      ),
                    );
                  }
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
                  color: Colors.grey[400],
                ),
              ),
              TextFieldComponent(
                focusNode: _weightFocusNode,
                controller: _weightController,
                inputType: TextInputType.number,
                leadingText: '重量',
                hintText: '请输入重量，必填',
              ),
              InkWell(
                onTap: () async {
                  dynamic result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApparelProductVariantsInputPage(),
                    ),
                  );

                  if (result != null && result.length > 0) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(result.toString()),
                      ),
                    );
                  }
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
                  color: Colors.grey[400],
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
                  color: Colors.grey[400],
                ),
              ),
              InkWell(
                onTap: () {
//                  print(widget.item.attributes.styles);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApparelProductAttributesInputPage(item: widget.item,),
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
                  color: Colors.grey[400],
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
                  color: Colors.grey[400],
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
                        labelPadding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 22),
                        labelStyle: TextStyle(fontSize: 16),
                        label: Text('发布商品'),
                        onPressed: () {
                          print(_masterImages);
                        },
                      ),
                    ),
                    Expanded(
                      child: ActionChip(
                        backgroundColor: Colors.orange,
                        labelPadding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 22),
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
