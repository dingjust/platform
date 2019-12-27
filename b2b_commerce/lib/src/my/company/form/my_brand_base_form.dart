import 'package:b2b_commerce/src/business/products/product_category.dart';
import 'package:b2b_commerce/src/common/address_picker.dart';
import 'package:b2b_commerce/src/common/screen_conditions.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class MyBrandBaseFormPage extends StatefulWidget {
  MyBrandBaseFormPage(this.brand);

  final BrandModel brand;

  @override
  State createState() => MyBrandBaseFormPageState();
}

class MyBrandBaseFormPageState extends State<MyBrandBaseFormPage> {
  List<MediaModel> medias = [];
  TextEditingController _nameController = TextEditingController();
  TextEditingController _brandController = TextEditingController();
  TextEditingController _cooperativeBrandController = TextEditingController();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _brandFocusNode = FocusNode();
  FocusNode _cooperativeBrandFocusNode = FocusNode();

  List<String> _scaleRange = [];
  List<String> _styleCodes = [];
  List<String> _ageRanges = [];
  List<String> _priceRange1s = [];
  List<String> _priceRange2s = [];
  double _fontSize = 14;

  @override
  void initState() {
    if (widget.brand.profilePicture != null) medias = [widget.brand.profilePicture];
    _nameController.text = widget.brand.name ?? '';
    _brandController.text = widget.brand.brand ?? '';
    _cooperativeBrandController.text = widget.brand.cooperativeBrand ?? '';
    if (widget.brand.scaleRange != null) {
      _scaleRange.add(widget.brand.scaleRange.toString().split('.')[1]);
    }
    _styleCodes.addAll(widget.brand.styles ?? []);
    _ageRanges.addAll(
      widget.brand.ageRanges.map((ageRange) => ageRange.toString().split('.')[1]).toList() ?? [],
    );
    _priceRange1s.addAll(
      widget.brand.priceRange1s.map((priceRange1s) => priceRange1s.toString().split('.')[1]).toList() ?? [],
    );
    _priceRange2s.addAll(
      widget.brand.priceRange2s.map((priceRange2s) => priceRange2s.toString().split('.')[1]).toList() ?? [],
    );

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('基本资料'),
        centerTitle: true,
        elevation: 0.5,
        actions: <Widget>[
          IconButton(
              icon: Text('保存', style: TextStyle(color: Color(0xffffd60c))),
              onPressed: () {
                if (medias.length > 0) {
                  widget.brand.profilePicture = medias[0];
                } else {
                  widget.brand.profilePicture = null;
                }
                widget.brand.name = _nameController.text == '' ? null : _nameController.text;
                widget.brand.brand = _brandController.text == '' ? null : _brandController.text;
                widget.brand.cooperativeBrand =
                    _cooperativeBrandController.text == '' ? null : _cooperativeBrandController.text;

                UserRepositoryImpl().brandUpdate(widget.brand).then((a) => Navigator.pop(context));
              })
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '上传图片',
                      style: TextStyle(color: Colors.black)
                    )
                  ]
                ),
              )
            ),
            EditableAttachments(
              list: medias,
              maxNum: 1,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(
                              text: '公司名称',
                              style: TextStyle(color: Colors.black)
                          ),
                          TextSpan(
                              text: '*',
                              style: TextStyle(color: Colors.red)
                          ),
                        ]
                    ),
                  ),
                  Expanded(
                    child: TextFieldComponent(
                      padding: EdgeInsets.all(0),
                      focusNode: _nameFocusNode,
                      controller: _nameController,
                      hintText: '请输入公司名称',
                      hideDivider: true,
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 0,color: Color(Constants.DIVIDER_COLOR),),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(
                              text: '品牌名称',
                              style: TextStyle(color: Colors.black)
                          ),
                          TextSpan(
                              text: '*',
                              style: TextStyle(color: Colors.red)
                          ),
                        ]
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: TextFieldComponent(
                        padding: EdgeInsets.all(0),
                        focusNode: _brandFocusNode,
                        controller: _brandController,
                        hintText: '请输入品牌名称',
                        hideDivider: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 0,color: Color(Constants.DIVIDER_COLOR),),
            GestureDetector(
              onTap: (){
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(
                                text: '联系信息',
                                style: TextStyle(color: Colors.black,fontSize: _fontSize)
                            ),
                            TextSpan(
                                text: '*',
                                style: TextStyle(color: Colors.red,fontSize: _fontSize)
                            ),
                          ]
                      ),
                    ),
                    Expanded(child: Text('已填写',textAlign: TextAlign.end,style: TextStyle(color: Colors.grey),)),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                String text = '';
                AddressPicker(cacel: () {
                  Navigator.pop(context);
                }).showAddressPicker(
                  context,
                  selectProvince: (province) {
                    text += province['name'];
                  },
                  selectCity: (city) {
                    if(city != null){
                      text += city['name'];
                    }
                  },
                  selectArea: (area) {
                    if(area != null){
                      text += area['name'];
                    }
//                    setState(() {
//                      address = text;
//                    });
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(
                                text: '企业地址',
                                style: TextStyle(color: Colors.black,fontSize: _fontSize)
                            ),
                            TextSpan(
                                text: '*',
                                style: TextStyle(color: Colors.red,fontSize: _fontSize)
                            ),
                          ]
                      ),
                    ),
                    Expanded(child: Text('已填写',textAlign: TextAlign.end,style: TextStyle(color: Colors.grey),)),
                  ],
                ),
              ),
            ),
            Divider(height: 0,color: Color(Constants.DIVIDER_COLOR),),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(
                              text: '合作品牌',
                              style: TextStyle(color: Colors.black,fontSize: _fontSize)
                          ),
                          TextSpan(
                              text: '*',
                              style: TextStyle(color: Colors.red,fontSize: _fontSize)
                          ),
                        ]
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: TextFieldComponent(
                        padding: EdgeInsets.all(0),
                        focusNode: _cooperativeBrandFocusNode,
                        controller: _cooperativeBrandController,
                        hintText: '请输入合作品牌',
                        hideDivider: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 0,color: Color(Constants.DIVIDER_COLOR),),
            InkWell(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      '产值规模',
                      style: TextStyle(

                        fontSize: 16,
                      ),
                    )),
                    Text(widget.brand.scaleRange == null ? '' : ScaleRangesLocalizedMap[widget.brand.scaleRange],style: TextStyle(color: Colors.grey),),
                    Icon(Icons.chevron_right,color: Colors.grey,),
                  ],
                ),
              ),
              onTap: () async {
                dynamic result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EnumSelectPage(
                            items: ScaleRangesEnum,
                            title: '产值规模',
                            codes: _scaleRange,
                            count: 3,
                          ),
                    ));

                if (result != null) _scaleRange = result;

                if (_scaleRange.length > 0) {
                  ScaleRanges scaleRange = ScaleRanges.values.singleWhere(
                      (scaleRange) => scaleRange.toString().split('.')[1] == _scaleRange[0],
                      orElse: () => null);

                  widget.brand.scaleRange = scaleRange;
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(height: 0,color: Color(Constants.DIVIDER_COLOR),),
            ),
            InkWell(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      '优势类目',
                      style: TextStyle(

                        fontSize: 16,
                      ),
                    )),
                    Text(
                      formatCategorySelectText(widget.brand.adeptAtCategories),style: TextStyle(color: Colors.grey)
                    ),
                    Icon(Icons.chevron_right,color: Colors.grey),
                  ],
                ),
              ),
              onTap: () async {
                List<CategoryModel> categories = await ProductRepositoryImpl().cascadedCategories();
                dynamic result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategorySelectPage(
                          categories: categories,
                          minCategorySelect: widget.brand.adeptAtCategories,
                          multiple: true,
                        ),
                  ),
                );

                if (result != null) {
                  widget.brand.adeptAtCategories = result;
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(height: 0,color: Color(Constants.DIVIDER_COLOR),),
            ),
            InkWell(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      '风格',
                      style: TextStyle(

                        fontSize: 16,
                      ),
                    )),
                    Text(
                      formatEnumSelectsText(widget.brand.styles, StyleEnum, 4),style: TextStyle(color: Colors.grey)
                    ),
                    Icon(Icons.chevron_right,color: Colors.grey),
                  ],
                ),
              ),
              onTap: () async {
                dynamic result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EnumSelectPage(
                          title: '选择风格',
                          items: StyleEnum,
                          codes: widget.brand.styles,
                          multiple: true,
                        ),
                  ),
                );

                if (result != null) {
                  widget.brand.styles = result;
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(height: 0,color: Color(Constants.DIVIDER_COLOR),),
            ),
            InkWell(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      '年龄段',
                      style: TextStyle(

                        fontSize: 16,
                      ),
                    )),
                    Text(
                      formatEnumSelectsText(_ageRanges, AgeRangesEnum, 3),style: TextStyle(color: Colors.grey)
                    ),
                    Icon(Icons.chevron_right,color: Colors.grey),
                  ],
                ),
              ),
              onTap: () async {
                dynamic result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EnumSelectPage(
                            items: AgeRangesEnum,
                            title: '年龄段',
                            codes: _ageRanges,
                            count: 3,
                            multiple: true,
                          ),
                    ));

                if (result != null) _ageRanges = result;

                if (_ageRanges.length > 0) {
                  List<AgeRanges> ageRanges = _ageRanges.map((ageRange) {
                    return AgeRanges.values.singleWhere((scaleRange) => scaleRange.toString().split('.')[1] == ageRange,
                        orElse: () => null);
                  }).toList();

                  widget.brand.ageRanges = ageRanges;
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(height: 0,color: Color(Constants.DIVIDER_COLOR),),
            ),
            InkWell(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      '春夏款价格段',
                      style: TextStyle(

                        fontSize: 16,
                      ),
                    )),
                    Text(
                      formatEnumSelectsText(_priceRange1s, PriceRangesEnum, 3),style: TextStyle(color: Colors.grey)
                    ),
                    Icon(Icons.chevron_right,color: Colors.grey),
                  ],
                ),
              ),
              onTap: () async {
                dynamic result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EnumSelectPage(
                            items: PriceRangesEnum,
                            title: '春夏款价格段',
                            codes: _priceRange1s,
                            count: 3,
                            multiple: true,
                          ),
                    ));

                if (result != null) _priceRange1s = result;

                if (_priceRange1s.length > 0) {
                  List<PriceRanges> priceRange1s = _priceRange1s.map((priceRange1s) {
                    return PriceRanges.values.singleWhere(
                        (priceRange) => priceRange.toString().split('.')[1] == priceRange1s,
                        orElse: () => null);
                  }).toList();

                  widget.brand.priceRange1s = priceRange1s;
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(height: 0,color: Color(Constants.DIVIDER_COLOR),),
            ),
            InkWell(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      '秋冬款价格段',
                      style: TextStyle(

                        fontSize: 16,
                      ),
                    )),
                    Text(
                      formatEnumSelectsText(_priceRange2s, PriceRangesEnum, 3),style: TextStyle(color: Colors.grey)
                    ),
                    Icon(Icons.chevron_right,color: Colors.grey),
                  ],
                ),
              ),
              onTap: () async {
                dynamic result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EnumSelectPage(
                            items: PriceRangesEnum,
                            title: '秋冬款价格段',
                            codes: _priceRange2s,
                            count: 3,
                            multiple: true,
                          ),
                    ));

                if (result != null) _priceRange2s = result;

                if (_priceRange2s.length > 0) {
                  List<PriceRanges> priceRange2s = _priceRange2s.map((priceRange2s) {
                    return PriceRanges.values.singleWhere(
                        (priceRange) => priceRange.toString().split('.')[1] == priceRange2s,
                        orElse: () => null);
                  }).toList();

                  widget.brand.priceRange2s = priceRange2s;
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String formatCategorySelectText(List<CategoryModel> categorys) {
    String text = '';

    if (categorys != null) {
      text = '';
      for (int i = 0; i < categorys.length; i++) {
        if (i > 1) {
          text += '...';
          break;
        }

        if (i == categorys.length - 1) {
          text += categorys[i].name;
        } else {
          text += categorys[i].name + '、';
        }
      }
    }

    return text;
  }
}
