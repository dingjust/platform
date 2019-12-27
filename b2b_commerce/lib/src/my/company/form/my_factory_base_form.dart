import 'dart:ui';

import 'package:b2b_commerce/src/business/products/product_category.dart';
import 'package:b2b_commerce/src/my/address/contact_address_form.dart';
import 'package:b2b_commerce/src/my/company/form/my_brand_contact_form.dart';
import 'package:common_utils/common_utils.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class MyFactoryBaseFormPage extends StatefulWidget {
  MyFactoryBaseFormPage(this.factory, {this.medias});

  final FactoryModel factory;
  List<MediaModel> medias;

  @override
  State createState() => MyFactoryBaseFormPageState();
}

class MyFactoryBaseFormPageState extends State<MyFactoryBaseFormPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _cooperativeBrandController = TextEditingController();
  TextEditingController _coverageAreaController = TextEditingController();
  TextEditingController _productionLineQuantityController = TextEditingController();
  TextEditingController _factoryBuildingsQuantityController = TextEditingController();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _cooperativeBrandFocusNode = FocusNode();
  FocusNode _coverageAreaFocusNode = FocusNode();
  FocusNode _productionLineQuantityFocusNode = FocusNode();
  FocusNode _factoryBuildingsQuantityFocusNode = FocusNode();

  List<MediaModel> _medias = [];
  List<String> _scaleRange = [];
  List<String> _monthlyCapacityRanges = [];
  List<String> _populationScale = [];
  List<String> _cooperationModes = [];
  double _fontSize = 16;

  @override
  void initState() {
    _nameController.text = widget.factory.name ?? '';
    _cooperativeBrandController.text = widget.factory.cooperativeBrand ?? '';
    _coverageAreaController.text = widget.factory.coverageArea ?? '';
    _factoryBuildingsQuantityController.text = widget.factory.factoryBuildingsQuantity == null ? '' : widget.factory.factoryBuildingsQuantity.toString();
    _productionLineQuantityController.text = widget.factory.productionLineQuantity == null ? '' : widget.factory.productionLineQuantity.toString();
    if (widget.factory.scaleRange != null) {
      _scaleRange.add(widget.factory.scaleRange.toString().split('.')[1]);
    }
    if (widget.factory.monthlyCapacityRange != null) {
      _monthlyCapacityRanges
          .add(widget.factory.monthlyCapacityRange.toString().split('.')[1]);
    }
    if (widget.factory.populationScale != null) {
      _populationScale
          .add(widget.factory.populationScale.toString().split('.')[1]);
    }
    if (widget.factory.cooperationModes != null) {
      _cooperationModes.addAll(
        widget.factory.cooperationModes
            .map((cooperationMode) => cooperationMode.toString().split('.')[1]),
      );
    }
    if (widget.factory.profilePicture != null) {
      _medias = [widget.factory.profilePicture];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text('基本资料'),
        actions: <Widget>[
          IconButton(
              icon: Text('保存', style: TextStyle(color: Color(0xffffd60c))),
              onPressed: () {
                if (ObjectUtil.isEmptyString(widget.factory.name)) {
                  ShowDialogUtil.showValidateMsg(context, '请填写公司名称');
                  return;
                }
                if(ObjectUtil.isEmptyString(widget.factory.duties)||
                    ObjectUtil.isEmptyString(widget.factory.contactPerson) ||
                    ObjectUtil.isEmptyString(widget.factory.contactPhone)){
                  ShowDialogUtil.showValidateMsg(context, '请完善联系信息');
                  return;
                }
                if(widget.factory.contactAddress == null){
                  ShowDialogUtil.showValidateMsg(context, '请填写企业地址');
                  return;
                }
                widget.factory.contactAddress.id = null;
                if(ObjectUtil.isEmptyList(widget.factory.adeptAtCategories)){
                  ShowDialogUtil.showValidateMsg(context, '请选择优势品类');
                  return;
                }
                if (_medias.length > 0) {
                  widget.factory.profilePicture = _medias[0];
                } else {
                  widget.factory.profilePicture = null;
                }
                widget.factory.name = _nameController.text == '' ? null : _nameController.text;
                widget.factory.cooperativeBrand =
                _cooperativeBrandController.text == '' ? null : _cooperativeBrandController.text;

                UserRepositoryImpl().factoryUpdate(widget.factory).then((a) => Navigator.pop(context));
              })
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child:RichText(
                text: TextSpan(
                    children: [
                      TextSpan(
                          text: '上传企业logo',
                          style: TextStyle(color: Colors.black,fontSize: _fontSize)
                      ),
                      TextSpan(
                          text: '(长按编辑)',
                          style: TextStyle(color: Colors.grey,fontSize: 14,)
                      ),
                    ]
                ),
              ),
            ),
            _buildProfilePicture(),
            _buildName(),
            Divider(height: 0,color: Color(Constants.DIVIDER_COLOR),),
            _buildContactInfo(context),
            Divider(height: 0,color: Color(Constants.DIVIDER_COLOR),),
            _buildContactAddress(context),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
            _buildPopulationScale(context),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
            _buildCooperationModes(context),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
            _buildCategories(context),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
            _buildAdeptAtCategories(context),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
            _buildEquipment(),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
            _buildInkFactoryQuantityLevel(context),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
            _buildCooperativeBrand(),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
            _buildMonthlyCapacityRange(context),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
            _buildScaleRange(context),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
            _buildProductionMode(context),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
            _buildProductionLineQuantity(),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
            _buildFactoryBuildingsQuantity(),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
            _buildDesign(),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
            _buildPattern(),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
            _buildFreeProofing(),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
            _buildCoverageArea(),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
            _buildLabels(context),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildContactInfo(BuildContext context) {
    return GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyBrandContactFormPage(company: widget.factory,)));
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
                  Expanded(child: Text(_buildContactText(),textAlign: TextAlign.end,style: TextStyle(color: Colors.grey),)),
                  Icon((Icons.chevron_right),color: Colors.grey,),
                ],
              ),
            ),
          );
  }

  Widget _buildContactAddress(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(15),
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
              Container(
                width: MediaQueryData.fromWindow(window).size.width - 130,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${widget.factory.contactAddress != null && widget.factory.contactAddress.details != null ? widget.factory.contactAddress.details : ''}',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),
              Icon((Icons.chevron_right),color: Colors.grey,),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContactAddressFormPage(
                  address: widget.factory.contactAddress,
                  company: widget.factory),
            ),
          );
        }
    );
  }

  EditableAttachments _buildProfilePicture() {
    return EditableAttachments(
            list: _medias,
            maxNum: 1,
            ratioX: 1,
            ratioY: 1,
            isCut: true,
            circleShape: true,
          );
  }

  Container _buildName() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5,),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          RichText(
            text: TextSpan(
                children: [
                  TextSpan(
                      text: '公司名称',
                      style: TextStyle(color: Colors.black,fontSize: _fontSize,)
                  ),
                  TextSpan(
                      text: '*',
                      style: TextStyle(color: Colors.red,fontSize: _fontSize,)
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
              onChanged: (v) {
                widget.factory.name =
                _nameController.text == '' ? null : _nameController.text;
              },
            ),
          ),
        ],
      ),
    );
  }

  InkWell _buildMonthlyCapacityRange(BuildContext context) {
    return InkWell(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                  text: '月均产能',
                                  style: TextStyle(color: Colors.black,fontSize: _fontSize)
                              ),
                            ]
                        ),
                      ),),
                  Text(
                    widget.factory.monthlyCapacityRange == null
                        ? ''
                        : MonthlyCapacityRangesLocalizedMap[
                            widget.factory.monthlyCapacityRange],
                    style: TextStyle(color: Colors.grey),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            onTap: () async {
              dynamic result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EnumSelectPage(
                          items: MonthlyCapacityRangesEnum,
                          title: '月均产能',
                          codes: _monthlyCapacityRanges,
                          count: 3,
                        ),
                  ));

              if (result != null) _monthlyCapacityRanges = result;

              if (_monthlyCapacityRanges.length > 0) {
                MonthlyCapacityRange monthlyCapacityRanges =
                    MonthlyCapacityRange.values.singleWhere(
                        (monthlyCapacityRanges) =>
                            monthlyCapacityRanges.toString().split('.')[1] ==
                            _monthlyCapacityRanges[0],
                        orElse: () => null);

                widget.factory.monthlyCapacityRange = monthlyCapacityRanges;
              }
            },
          );
  }

  InkWell _buildScaleRange(BuildContext context) {
    return InkWell(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                  text: '产值规模',
                                  style: TextStyle(color: Colors.black,fontSize: _fontSize)
                              ),
                            ]
                        ),
                      ),),
                  Text(
                    widget.factory.scaleRange == null
                        ? ''
                        : ScaleRangesLocalizedMap[widget.factory.scaleRange],
                    style: TextStyle(color: Colors.grey),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
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
                    (scaleRange) =>
                        scaleRange.toString().split('.')[1] == _scaleRange[0],
                    orElse: () => null);

                widget.factory.scaleRange = scaleRange;
              }
            },
          );
  }

  InkWell _buildPopulationScale(BuildContext context) {
    return InkWell(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                  text: '工厂规模',
                                  style: TextStyle(color: Colors.black,fontSize: _fontSize)
                              ),
                              TextSpan(
                                  text: '*',
                                  style: TextStyle(color: Colors.red,fontSize: _fontSize,)
                              ),
                            ]
                        ),
                      ),),
                  Text(
                    widget.factory.populationScale == null
                        ? ''
                        : PopulationScaleLocalizedMap[
                            widget.factory.populationScale],
                    style: TextStyle(color: Colors.grey),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            onTap: () async {
              dynamic result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EnumSelectPage(
                          items: PopulationScaleEnum,
                          title: '工厂规模',
                          codes: _populationScale,
                          count: 3,
                        ),
                  ));

              if (result != null) _scaleRange = result;

              if (_scaleRange.length > 0) {
                PopulationScale populationScale = PopulationScale.values
                    .singleWhere(
                        (populationScale) =>
                            populationScale.toString().split('.')[1] ==
                            _populationScale[0],
                        orElse: () => null);

                widget.factory.populationScale = populationScale;
              }
            },
          );
  }

  InkWell _buildCooperationModes(BuildContext context) {
    return InkWell(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                  text: '合作方式',
                                  style: TextStyle(color: Colors.black,fontSize: _fontSize)
                              ),
                              TextSpan(
                                  text: '*',
                                  style: TextStyle(color: Colors.red,fontSize: _fontSize,)
                              ),
                            ]
                        ),
                      ),),
                  Text(
                    formatCooperationModesSelectText(
                        widget.factory.cooperationModes),
                    style: TextStyle(color: Colors.grey),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            onTap: () async {
              dynamic result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EnumSelectPage(
                          items: CooperationModesEnum,
                          title: '合作方式',
                          codes: _cooperationModes,
                          multiple: true,
                          count: 4,
                        ),
                  ));

              if (result != null) _cooperationModes = result;

              if (_cooperationModes.length > 0) {
                List<CooperationModes> cooperationModes =
                    _cooperationModes.map((mode) {
                  return CooperationModes.values.singleWhere(
                      (cooperationMode) =>
                          cooperationMode.toString().split('.')[1] == mode,
                      orElse: () => null);
                }).toList();

                widget.factory.cooperationModes = cooperationModes;
              }
            },
          );
  }

  InkWell _buildCategories(BuildContext context) {
    return InkWell(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                  text: '生产大类',
                                  style: TextStyle(color: Colors.black,fontSize: _fontSize)
                              ),
                              TextSpan(
                                  text: '*',
                                  style: TextStyle(color: Colors.red,fontSize: _fontSize,)
                              ),
                            ]
                        ),
                      ),),
                  Text(
                    formatCategorySelectText(widget.factory.categories, 5),
                    style: TextStyle(color: Colors.grey),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            onTap: () async {
              List<CategoryModel> categorys =
                  await ProductRepositoryImpl().majorCategories();

              dynamic result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EnumSelectPage(
                        title: '生产大类',
                        items: categorys,
                        models: widget.factory.categories,
                        multiple: true,
                      ),
                ),
              );

              if (result != null) {
                widget.factory.categories = result;
              }
            },
          );
  }

  InkWell _buildAdeptAtCategories(BuildContext context) {
    return InkWell(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                  text: '优势类目',
                                  style: TextStyle(color: Colors.black,fontSize: _fontSize)
                              ),
                              TextSpan(
                                  text: '*',
                                  style: TextStyle(color: Colors.red,fontSize: _fontSize,)
                              ),
                            ]
                        ),
                      ),),
                  Text(
                    formatCategorySelectText(
                        widget.factory.adeptAtCategories, 2),
                    style: TextStyle(color: Colors.grey),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            onTap: () async {
              List<CategoryModel> categories =
                  await ProductRepositoryImpl().cascadedCategories();
              dynamic result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategorySelectPage(
                        categories: categories,
                        minCategorySelect: widget.factory.adeptAtCategories,
                        multiple: true,
                      ),
                ),
              );

              if (result != null) {
                widget.factory.adeptAtCategories = result;
              }
            },
          );
  }

  Container _buildCooperativeBrand() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5,),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          RichText(
            text: TextSpan(
                children: [
                  TextSpan(
                      text: '合作品牌',
                      style: TextStyle(color: Colors.black,fontSize: _fontSize,)
                  ),
                ]
            ),
          ),
          Expanded(
            child: TextFieldComponent(
              padding: EdgeInsets.all(0),
              focusNode: _cooperativeBrandFocusNode,
              controller: _cooperativeBrandController,
              hintText: '请输入合作品牌',
              hideDivider: true,
              onChanged: (v) {
                widget.factory.cooperativeBrand =
                _cooperativeBrandController.text == ''
                    ? null
                    : _cooperativeBrandController.text;
              },
            ),
          ),
        ],
      ),
    );
  }

  InkWell _buildLabels(BuildContext context) {
    return InkWell(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                  text: '我的标签',
                                  style: TextStyle(color: Colors.black,fontSize: _fontSize)
                              ),
                            ]
                        ),
                      ),),
                  Text(
                    formatLabelsSelectText(widget.factory.labels),
                    style: TextStyle(color: Colors.grey),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            onTap: () async {
              List<LabelModel> labels = await UserRepositoryImpl().labels();
              labels.removeWhere((label) => label.group != 'FACTORY');
              if (widget.factory.labels == null) widget.factory.labels = [];
              dynamic result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EnumSelectPage(
                        title: '选择标签',
                        items: labels,
                        models: widget.factory.labels,
                        multiple: true,
                      ),
                ),
              );

              if (result != null) {
                widget.factory.labels = result;
              }
            },
          );
  }

  InkWell _buildProductionMode(BuildContext context) {
    return InkWell(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                  text: '生产模式',
                                  style: TextStyle(color: Colors.black,fontSize: _fontSize)
                              ),
                            ]
                        ),
                      ),),
                  Text(
                    enumMap(ProductionModesEnum, widget.factory.productionMode),
                    style: TextStyle(color: Colors.grey),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            onTap: () async {
              dynamic result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SingleEnumSelectPage(
                      items: ProductionModesEnum,
                      title: '生产模式',
                      code:  widget.factory.productionMode,
                      count: 3,
                    ),
                  ));

                if(result != null){
                  widget.factory.productionMode = result;
                }

            },
          );
  }

  EquipmentPage _buildEquipment() => EquipmentPage(widget.factory);

  Container _buildDesign() {
    return Container(
            color: Colors.white,
            child: ListTile(
                leading: Wrap(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(
                                text: '设计',
                                style: TextStyle(color: Colors.black,fontSize: _fontSize)
                            ),
                          ]
                      ),
                    ),
                  ],
                ),
                trailing: Container(
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(widget.factory.design == 'SUPPORTED' ? '支持' : '不支持',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          )),
                      Switch(
                        value: widget.factory.design == 'SUPPORTED',
                        onChanged: (value) {
                          setState(() {
                            if(value){
                             widget.factory.design = 'SUPPORTED';
                            }else{
                              widget.factory.design = 'NOT_SUPPORTED';
                            }
                          });
                        },
                      )
                    ],
                  ),
                )),
          );
  }

  Container _buildPattern() {
    return Container(
            color: Colors.white,
            child: ListTile(
                leading: Wrap(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(
                                text: '打板',
                                style: TextStyle(color: Colors.black,fontSize: _fontSize)
                            ),
                          ]
                      ),
                    ),
                  ],
                ),
                trailing: Container(
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(widget.factory.pattern == 'SUPPORTED' ? '支持' : '不支持',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          )),
                      Switch(
                        value: widget.factory.pattern == 'SUPPORTED',
                        onChanged: (value) {
                          setState(() {
                            if(value){
                             widget.factory.pattern = 'SUPPORTED';
                            }else{
                              widget.factory.pattern = 'NOT_SUPPORTED';
                            }
                          });
                        },
                      )
                    ],
                  ),
                )),
          );
  }

  Container _buildFreeProofing() {
    return Container(
            color: Colors.white,
            child: ListTile(
                leading: Wrap(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(
                                text: '免费打样',
                                style: TextStyle(color: Colors.black,fontSize: _fontSize)
                            ),
                          ]
                      ),
                    ),
                  ],
                ),
                trailing: Container(
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(widget.factory.freeProofing == 'SUPPORTED' ? '支持' : '不支持',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          )),
                      Switch(
                        value: widget.factory.freeProofing == 'SUPPORTED',
                        onChanged: (value) {
                          setState(() {
                            if(value){
                             widget.factory.freeProofing = 'SUPPORTED';
                            }else{
                              widget.factory.freeProofing = 'NOT_SUPPORTED';
                            }
                          });
                        },
                      )
                    ],
                  ),
                )),
          );
  }

  Container _buildCoverageArea() {
    return Container(
            color: Colors.white,
            child: TextFieldComponent(
              focusNode: _coverageAreaFocusNode,
              leadingText: Text('覆盖范围',
                  style: TextStyle(
                    fontSize: _fontSize,
                  )),
              controller: _coverageAreaController,
              dividerPadding: EdgeInsets.all(0),
              onChanged: (v) {
                widget.factory.coverageArea =
                _coverageAreaController.text == ''
                    ? null
                    : _coverageAreaController.text;
              },
            ),
          );
  }

  Container _buildProductionLineQuantity() {
    return Container(
      color: Colors.white,
      child: TextFieldComponent(
        focusNode: _productionLineQuantityFocusNode,
        leadingText: Text('产线',
            style: TextStyle(
              fontSize: _fontSize,
            )),
        controller: _productionLineQuantityController,
        dividerPadding: EdgeInsets.all(0),
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly,
        ],
        onChanged: (v) {
          widget.factory.productionLineQuantity = ClassHandleUtil.transInt(_productionLineQuantityController.text);
        },
      ),
    );
  }

  Container _buildFactoryBuildingsQuantity() {
    return Container(
      color: Colors.white,
      child: TextFieldComponent(
        focusNode: _factoryBuildingsQuantityFocusNode,
        leadingText: Text('产房面积',
            style: TextStyle(
              fontSize: _fontSize,
            )),
        controller: _factoryBuildingsQuantityController,
        dividerPadding: EdgeInsets.all(0),
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly,
        ],
        onChanged: (v) {
          widget.factory.factoryBuildingsQuantity = ClassHandleUtil.transInt(_factoryBuildingsQuantityController.text);
        },
      ),
    );
  }

  InkWell _buildInkFactoryQuantityLevel(BuildContext context) {
    return InkWell(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                  text: '质量等级',
                                  style: TextStyle(color: Colors.black,fontSize: _fontSize)
                              ),
                              TextSpan(
                                  text: '*',
                                  style: TextStyle(color: Colors.red,fontSize: _fontSize,)
                              ),
                            ]
                        ),
                      ),),
                  Text(
                    enumMap(FactoryQualityLevelsEnum, widget.factory.qualityLevel),
                    style: TextStyle(color: Colors.grey),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            onTap: () async {
              dynamic result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SingleEnumSelectPage(
                      items: FactoryQualityLevelsEnum,
                      title: '质量等级',
                      code:  widget.factory.qualityLevel,
                      count: 3,
                    ),
                  ));

              if(result != null){
                widget.factory.qualityLevel = result;
              }

            },
          );
  }

  String formatCategorySelectText(List<CategoryModel> categorys, int count) {
    String text = '';

    if (categorys != null) {
      text = '';
      for (int i = 0; i < categorys.length; i++) {
        if (i > count - 1) {
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

  String formatLabelsSelectText(List<LabelModel> labels) {
    String text = '';

    if (labels != null) {
      text = '';
      for (int i = 0; i < labels.length; i++) {
        if(labels[i].group != 'FACTORY'){
          continue;
        }
        if (i > 1) {
          text += '...';
          break;
        }

        if (i == labels.length - 1) {
          text += labels[i].name;
        } else {
          text += labels[i].name + '、';
        }
      }
    }

    return text;
  }

  //格式化合作方式
  String formatCooperationModesSelectText(
      List<CooperationModes> cooperationModes) {
    String text = '';

    if (cooperationModes != null) {
      text = '';
      for (int i = 0; i < cooperationModes.length; i++) {
        if (i > 2) {
          text += '...';
          break;
        }

        if (i == cooperationModes.length - 1) {
          text += CooperationModesLocalizedMap[cooperationModes[i]];
        } else {
          text += CooperationModesLocalizedMap[cooperationModes[i]] + '、';
        }
      }
    }

    return text;
  }

  String _buildContactText(){
    String text = '未填写';
    if(!ObjectUtil.isEmptyString(widget.factory.duties) &&
        !ObjectUtil.isEmptyString(widget.factory.contactPerson) &&
        !ObjectUtil.isEmptyString(widget.factory.contactPhone)){
      text = '已填写';
    }
    return text;
  }

}


class EquipmentPage extends StatefulWidget {
  EquipmentPage(this.item,{this.enabled = true});

  final FactoryModel item;
  final bool enabled;

  @override
  State<StatefulWidget> createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage> {
  List<Attribute> _attributes = [
    Attribute('cuttingDepartment', '裁剪部', CuttingDepartmentsEnum,multiple: true),
    Attribute('productionWorkshop', '生产车间', ProductionWorkshopsEnum,multiple: true,),
    Attribute('lastDepartment', '尾部', LastDepartmentsEnum,multiple: true),
  ];

  @override
  void initState() {
    if(widget.item.cuttingDepartment != null){
      _attributes[0].valueSelects = widget.item.cuttingDepartment;
    }
    if(widget.item.productionWorkshop != null){
      _attributes[1].valueSelects = widget.item.productionWorkshop;
    }
    if(widget.item.lastDepartment != null){
      _attributes[2].valueSelects = widget.item.lastDepartment;
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () async{
              Map<String,dynamic> result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PositioningRollPage(
                    crossAxisCount: 3,
                    attributes: _attributes,
                    title: '选择设备',
                    enabled: widget.enabled,
                  ),
                ),
              );
              print(result);
              if(result != null){
                _attributes[0].valueSelects = result['cuttingDepartment'];
                _attributes[1].valueSelects = result['productionWorkshop'];
                _attributes[2].valueSelects = result['lastDepartment'];
                widget.item.cuttingDepartment = result['cuttingDepartment'];
                widget.item.productionWorkshop = result['productionWorkshop'];
                widget.item.lastDepartment = result['lastDepartment'];
              }

            },
            child:_buildAttributesInfo()
//            ListTile(
//              title: Text('设备'),
//              trailing: Icon(Icons.chevron_right),
//            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributesInfo() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 17,),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 80,
                child: RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(
                            text: '设备',
                            style: TextStyle(color: Colors.black,fontSize: 16)
                        ),
                        TextSpan(
                            text: '*',
                            style: TextStyle(color: Colors.red,fontSize: 16,)
                        ),
                      ]
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    _attributesSelectText(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Icon(Icons.chevron_right,color: Colors.grey,)
            ],
          ),
        ),
      ],
    );
  }

  String _attributesSelectText(){
    String text = '';
    if(ClassHandleUtil.isNotEmpty(_attributes[0].valueSelects)){
      text += _attributes[0].name;
      text += '--';
      for(int i=0;i<_attributes[0].valueSelects.length;i++){
        if(i == _attributes[0].valueSelects.length-1){
          text += enumMap(CuttingDepartmentsEnum, _attributes[0].valueSelects[i]);
          text += '\n';
          break;
        }
        text += enumMap(CuttingDepartmentsEnum, _attributes[0].valueSelects[i]);
        text += '、';
      }
    }
    if(ClassHandleUtil.isNotEmpty(_attributes[1].valueSelects)){
      text += _attributes[1].name;
      text += '--';
      for(int i=0;i<_attributes[1].valueSelects.length;i++){
        if(i == _attributes[1].valueSelects.length-1){
          text += enumMap(ProductionWorkshopsEnum, _attributes[1].valueSelects[i]);
          text += '\n';
          break;
        }
        text += enumMap(ProductionWorkshopsEnum, _attributes[1].valueSelects[i]);
        text += '、';
      }
    }
    if(ClassHandleUtil.isNotEmpty(_attributes[2].valueSelects)){
      text += _attributes[2].name;
      text += '--';
      for(int i=0;i<_attributes[2].valueSelects.length;i++){
        if(i == _attributes[2].valueSelects.length-1){
          text += enumMap(LastDepartmentsEnum, _attributes[2].valueSelects[i]);
          text += '\n';
          break;
        }
        text += enumMap(LastDepartmentsEnum, _attributes[2].valueSelects[i]);
        text += '、';
      }
    }


    return text;
  }

}