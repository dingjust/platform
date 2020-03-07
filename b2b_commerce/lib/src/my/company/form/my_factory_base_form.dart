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
  FactoryModel _factory;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _cooperativeBrandController = TextEditingController();
  TextEditingController _coverageAreaController = TextEditingController();
  TextEditingController _productionLineQuantityController =
  TextEditingController();
  TextEditingController _factoryBuildingsQuantityController =
  TextEditingController();
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
    _factory = FactoryModel.fromJson(FactoryModel.toJson(widget.factory));
    _nameController.text = _factory.name ?? '';
    _cooperativeBrandController.text = _factory.cooperativeBrand ?? '';
    _coverageAreaController.text = _factory.coverageArea ?? '';
    _factoryBuildingsQuantityController.text =
    _factory.factoryBuildingsQuantity == null
        ? ''
        : _factory.factoryBuildingsQuantity.toString();
    _productionLineQuantityController.text =
    _factory.productionLineQuantity == null
        ? ''
        : _factory.productionLineQuantity.toString();
    if (_factory.scaleRange != null) {
      _scaleRange.add(_factory.scaleRange.toString().split('.')[1]);
    }
    if (_factory.monthlyCapacityRange != null) {
      _monthlyCapacityRanges
          .add(_factory.monthlyCapacityRange.toString().split('.')[1]);
    }
    if (_factory.populationScale != null) {
      _populationScale.add(_factory.populationScale.toString().split('.')[1]);
    }
    if (_factory.cooperationModes != null) {
      _cooperationModes.addAll(
        _factory.cooperationModes
            .map((cooperationMode) => cooperationMode.toString().split('.')[1]),
      );
    }
    if (_factory.profilePicture != null) {
      _medias = [_factory.profilePicture];
    }

    if (_factory.qualityLevels == null) {
      _factory.qualityLevels = [];
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
                if (ObjectUtil.isEmptyList(_medias)) {
                  ShowDialogUtil.showValidateMsg(context, '请上传企业logo');
                  return;
                }
                if (ObjectUtil.isEmptyString(_factory.name)) {
                  ShowDialogUtil.showValidateMsg(context, '请填写公司名称');
                  return;
                }
                if (ObjectUtil.isEmptyString(_factory.duties) ||
                    ObjectUtil.isEmptyString(_factory.contactPerson) ||
                    ObjectUtil.isEmptyString(_factory.contactPhone)) {
                  ShowDialogUtil.showValidateMsg(context, '请完善联系信息');
                  return;
                }
                if (_factory.contactAddress == null ||
                    _factory.contactAddress.region?.isocode == null) {
                  ShowDialogUtil.showValidateMsg(context, '请填写企业地址');
                  return;
                }
                if (_factory.populationScale == null) {
                  ShowDialogUtil.showValidateMsg(context, '请选择工厂规模');
                  return;
                }
                if (_factory.cooperationModes == null) {
                  ShowDialogUtil.showValidateMsg(context, '请选择合作方式');
                  return;
                }
//                if(_factory.contactAddress == null){
//                  ShowDialogUtil.showValidateMsg(context, '请填写企业地址');
//                  return;
//                }
                _factory.contactAddress.id = null;
                if (ObjectUtil.isEmptyList(_factory.categories)) {
                  ShowDialogUtil.showValidateMsg(context, '请选择生产大类');
                  return;
                }
                if (ObjectUtil.isEmptyList(_factory.adeptAtCategories)) {
                  ShowDialogUtil.showValidateMsg(context, '请选择优势类目');
                  return;
                }
                if (ObjectUtil.isEmptyList(_factory.cuttingDepartment) &&
                    ObjectUtil.isEmptyList(_factory.productionWorkshop) &&
                    ObjectUtil.isEmptyList(_factory.lastDepartment)) {
                  ShowDialogUtil.showValidateMsg(context, '请选择设备');
                  return;
                }
                if (ObjectUtil.isEmptyList(_factory.qualityLevels)) {
                  ShowDialogUtil.showValidateMsg(context, '请选择质量等级');
                  return;
                }
                if (_medias.length > 0) {
                  _factory.profilePicture = _medias[0];
                } else {
                  _factory.profilePicture = null;
                }
                _factory.name =
                _nameController.text == '' ? null : _nameController.text;
                _factory.cooperativeBrand =
                _cooperativeBrandController.text == ''
                    ? null
                    : _cooperativeBrandController.text;

                UserRepositoryImpl().factoryUpdate(_factory).then((a) {
                  UserBLoC.instance.refreshUser().then((v) {
                    print('+++++++++++++++++++++');
                  });
                  Navigator.pop(context, true);
                });
              })
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: ListView(
          children: <Widget>[

            _buildProfilePicture(),
            _buildName(),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
            _buildContactInfo(context),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
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
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MyBrandContactFormPage(
                      company: _factory,
                    )));
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
                    text: '联系信息',
                    style: TextStyle(color: Colors.black, fontSize: _fontSize)),
                TextSpan(
                    text: '*',
                    style: TextStyle(color: Colors.red, fontSize: _fontSize)),
              ]),
            ),
            Expanded(
                child: Text(
                  _buildContactText(),
                  textAlign: TextAlign.end,
                  style: TextStyle(color: Colors.grey, fontSize: _fontSize),
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
                text: TextSpan(children: [
                  TextSpan(
                      text: '企业地址',
                      style:
                      TextStyle(color: Colors.black, fontSize: _fontSize)),
                  TextSpan(
                      text: '*',
                      style: TextStyle(color: Colors.red, fontSize: _fontSize)),
                ]),
              ),
              Container(
                width: MediaQueryData.fromWindow(window).size.width - 130,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${_factory.contactAddress != null && _factory.contactAddress.details != null ? _factory.contactAddress.details : ''}',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),
              Icon(
                (Icons.chevron_right),
                color: Colors.grey,
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContactAddressFormPage(company: _factory),
            ),
          );
        });
  }

  Widget _buildProfilePicture() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: '企业logo',
                      style:
                      TextStyle(color: Colors.black, fontSize: _fontSize)),
                  TextSpan(
                      text: '*',
                      style: TextStyle(color: Colors.red, fontSize: _fontSize)),

                ]),
              ),
              Text('（长按编辑）',style: TextStyle(color: Colors.grey),),
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            child: EditableAttachments(
              list: _medias,
              imageHeight: 80,
              imageWidth: 80,
              maxNum: 1,
              ratioX: 1,
              ratioY: 1,
              isCut: true,
              circleShape: true,
              loogPressDelete: false,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildName() {
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
              TextSpan(
                  text: '公司名称',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: _fontSize,
                  )),
              TextSpan(
                  text: '*',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: _fontSize,
                  )),
            ]),
          ),
          Expanded(
            child: TextFieldComponent(
              padding: EdgeInsets.all(0),
              focusNode: _nameFocusNode,
              controller: _nameController,
              hintText: '请输入公司名称',
              hideDivider: true,
              onChanged: (v) {
                _factory.name =
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
                  text: TextSpan(children: [
                    TextSpan(
                        text: '月均产能',
                        style: TextStyle(
                            color: Colors.black, fontSize: _fontSize)),
                  ]),
                ),
              ),
              Text(
                _factory.monthlyCapacityRange == null
                    ? ''
                    : MonthlyCapacityRangesLocalizedMap[
                _factory.monthlyCapacityRange],
                style: TextStyle(color: Colors.grey),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        onTap: _onMonthlySelect);
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
                  text: TextSpan(children: [
                    TextSpan(
                        text: '产值规模',
                        style: TextStyle(
                            color: Colors.black, fontSize: _fontSize)),
                  ]),
                ),
              ),
              Text(
                _factory.scaleRange == null
                    ? ''
                    : ScaleRangesLocalizedMap[_factory.scaleRange],
                style: TextStyle(color: Colors.grey),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        onTap: _onScaleSelect);
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
                text: TextSpan(children: [
                  TextSpan(
                      text: '工厂规模',
                      style:
                      TextStyle(color: Colors.black, fontSize: _fontSize)),
                  TextSpan(
                      text: '*',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: _fontSize,
                      )),
                ]),
              ),
            ),
            Text(
              _factory.populationScale == null
                  ? ''
                  : PopulationScaleLocalizedMap[_factory.populationScale],
              style: TextStyle(color: Colors.grey),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
      onTap: _onPopulationSelect,
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
                text: TextSpan(children: [
                  TextSpan(
                      text: '合作方式',
                      style:
                      TextStyle(color: Colors.black, fontSize: _fontSize)),
                  TextSpan(
                      text: '*',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: _fontSize,
                      )),
                ]),
              ),
            ),
            Text(
              formatCooperationModesSelectText(_factory.cooperationModes),
              style: TextStyle(color: Colors.grey),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
      onTap: _onCooperationSelect,
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
                  text: TextSpan(children: [
                    TextSpan(
                        text: '生产大类',
                        style: TextStyle(
                            color: Colors.black, fontSize: _fontSize)),
                    TextSpan(
                        text: '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: _fontSize,
                        )),
                  ]),
                ),
              ),
              Text(
                formatCategorySelectText(_factory.categories, 5),
                style: TextStyle(color: Colors.grey),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        onTap: _onMajorCategorySelect);
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
                text: TextSpan(children: [
                  TextSpan(
                      text: '优势类目',
                      style:
                      TextStyle(color: Colors.black, fontSize: _fontSize)),
                  TextSpan(
                      text: '*',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: _fontSize,
                      )),
                ]),
              ),
            ),
            Text(
              formatCategorySelectText(_factory.adeptAtCategories, 2),
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
            builder: (context) =>
                CategorySelectPage(
                  categories: categories,
                  minCategorySelect: _factory.adeptAtCategories,
                  multiple: true,
                ),
          ),
        );

        if (result != null) {
          _factory.adeptAtCategories = result;
        }
      },
    );
  }

  Container _buildCooperativeBrand() {
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
              TextSpan(
                  text: '合作品牌',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: _fontSize,
                  )),
            ]),
          ),
          Expanded(
            child: TextFieldComponent(
              padding: EdgeInsets.all(0),
              focusNode: _cooperativeBrandFocusNode,
              controller: _cooperativeBrandController,
              hintText: '请输入合作品牌',
              hideDivider: true,
              onChanged: (v) {
                _factory.cooperativeBrand =
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
                  text: TextSpan(children: [
                    TextSpan(
                        text: '我的标签',
                        style: TextStyle(
                            color: Colors.black, fontSize: _fontSize)),
                  ]),
                ),
              ),
              Text(
                formatLabelsSelectText(_factory.labels),
                style: TextStyle(color: Colors.grey),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        onTap: _onLabelSelect);
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
                  text: TextSpan(children: [
                    TextSpan(
                        text: '生产模式',
                        style: TextStyle(
                            color: Colors.black, fontSize: _fontSize)),
                  ]),
                ),
              ),
              Text(
                enumMap(ProductionModesEnum, _factory.productionMode),
                style: TextStyle(color: Colors.grey),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        onTap: _productionModeSelect);
  }

  EquipmentPage _buildEquipment() => EquipmentPage(_factory);

  Container _buildDesign() {
    return Container(
      color: Colors.white,
      child: ListTile(
          leading: Wrap(
            children: <Widget>[
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: '设计',
                      style:
                      TextStyle(color: Colors.black, fontSize: _fontSize)),
                ]),
              ),
            ],
          ),
          trailing: Container(
            width: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(_factory.design == 'SUPPORTED' ? '支持' : '不支持',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    )),
                Switch(
                  value: _factory.design == 'SUPPORTED',
                  onChanged: (value) {
                    setState(() {
                      if (value) {
                        _factory.design = 'SUPPORTED';
                      } else {
                        _factory.design = 'NOT_SUPPORTED';
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
                text: TextSpan(children: [
                  TextSpan(
                      text: '打板',
                      style:
                      TextStyle(color: Colors.black, fontSize: _fontSize)),
                ]),
              ),
            ],
          ),
          trailing: Container(
            width: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(_factory.pattern == 'SUPPORTED' ? '支持' : '不支持',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    )),
                Switch(
                  value: _factory.pattern == 'SUPPORTED',
                  onChanged: (value) {
                    setState(() {
                      if (value) {
                        _factory.pattern = 'SUPPORTED';
                      } else {
                        _factory.pattern = 'NOT_SUPPORTED';
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
                text: TextSpan(children: [
                  TextSpan(
                      text: '免费打样',
                      style:
                      TextStyle(color: Colors.black, fontSize: _fontSize)),
                ]),
              ),
            ],
          ),
          trailing: Container(
            width: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(_factory.freeProofing == 'SUPPORTED' ? '支持' : '不支持',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    )),
                Switch(
                  value: _factory.freeProofing == 'SUPPORTED',
                  onChanged: (value) {
                    setState(() {
                      if (value) {
                        _factory.freeProofing = 'SUPPORTED';
                      } else {
                        _factory.freeProofing = 'NOT_SUPPORTED';
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
          _factory.coverageArea = _coverageAreaController.text == ''
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
          _factory.productionLineQuantity =
              ClassHandleUtil.transInt(_productionLineQuantityController.text);
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
          _factory.factoryBuildingsQuantity = ClassHandleUtil.transInt(
              _factoryBuildingsQuantityController.text);
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
                text: TextSpan(children: [
                  TextSpan(
                      text: '质量等级',
                      style:
                      TextStyle(color: Colors.black, fontSize: _fontSize)),
                  TextSpan(
                      text: '*',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: _fontSize,
                      )),
                ]),
              ),
            ),
            Text(
              formatEnumSelectsText(
                  _factory.qualityLevels, FactoryQualityLevelsEnum, 2),
              style: TextStyle(color: Colors.grey),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
      onTap: _qualitySelect,
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
        if (labels[i].group != 'FACTORY') {
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

  String _buildContactText() {
    String text = '未填写';
    if (!ObjectUtil.isEmptyString(_factory.duties) &&
        !ObjectUtil.isEmptyString(_factory.contactPerson) &&
        !ObjectUtil.isEmptyString(_factory.contactPhone)) {
      text = '已填写';
    }
    return text;
  }

  void _onPopulationSelect() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return EnumSelectPage(
          items: PopulationScaleEnum,
          title: '工厂规模',
          codes: _populationScale,
          count: 3,
        );
      },
    ).then((result) {
      if (result != null) _populationScale = result;

      if (_populationScale.length > 0) {
        PopulationScale populationScale = PopulationScale.values.singleWhere(
                (populationScale) =>
            populationScale.toString().split('.')[1] == _populationScale[0],
            orElse: () => null);

        setState(() {
          _factory.populationScale = populationScale;
        });
      }
    });
  }

  void _onCooperationSelect() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return EnumSelectPage(
          items: CooperationModesEnum,
          title: '合作方式',
          codes: _cooperationModes,
          multiple: true,
          count: 4,
        );
      },
    ).then((result) {
      if (result != null) _cooperationModes = result;

      if (_cooperationModes.length > 0) {
        List<CooperationModes> cooperationModes = _cooperationModes.map((mode) {
          return CooperationModes.values.singleWhere(
                  (cooperationMode) =>
              cooperationMode.toString().split('.')[1] == mode,
              orElse: () => null);
        }).toList();

        setState(() {
          _factory.cooperationModes = cooperationModes;
        });
      }
    });
  }

  void _onMajorCategorySelect() async {
    List<CategoryModel> categorys =
    await ProductRepositoryImpl().majorCategories();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return EnumSelectPage(
          title: '生产大类',
          items: categorys,
          models: _factory.categories,
          multiple: true,
        );
      },
    ).then((result) {
      setState(() {
        if (result != null) {
          _factory.categories = result;
        }
      });
    });
  }

  void _qualitySelect() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return EnumSelectPage(
          title: '质量等级',
          items: FactoryQualityLevelsEnum,
          codes: _factory.qualityLevels,
          count: 3,
          multiple: true,
        );
      },
    ).then((result) {
      setState(() {
        if (result != null) {
          _factory.qualityLevels = result;
        }
      });
    });
  }

  void _onMonthlySelect() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return EnumSelectPage(
          items: MonthlyCapacityRangesEnum,
          title: '月均产能',
          codes: _monthlyCapacityRanges,
          count: 3,
        );
      },
    ).then((result) {
      setState(() {
        if (result != null) _monthlyCapacityRanges = result;

        if (_monthlyCapacityRanges.length > 0) {
          MonthlyCapacityRange monthlyCapacityRanges =
          MonthlyCapacityRange.values.singleWhere(
                  (monthlyCapacityRanges) =>
              monthlyCapacityRanges.toString().split('.')[1] ==
                  _monthlyCapacityRanges[0],
              orElse: () => null);

          _factory.monthlyCapacityRange = monthlyCapacityRanges;
        }
      });
    });
  }

  void _onScaleSelect() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return EnumSelectPage(
          items: ScaleRangesEnum,
          title: '产值规模',
          codes: _scaleRange,
          count: 3,
        );
      },
    ).then((result) {
      setState(() {
        if (result != null) _scaleRange = result;

        if (_scaleRange.length > 0) {
          ScaleRanges scaleRange = ScaleRanges.values.singleWhere(
                  (scaleRange) =>
              scaleRange.toString().split('.')[1] == _scaleRange[0],
              orElse: () => null);

          _factory.scaleRange = scaleRange;
        }
      });
    });
  }

  void _productionModeSelect() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleEnumSelectPage(
          items: ProductionModesEnum,
          title: '生产模式',
          code: _factory.productionMode,
          count: 3,
        );
      },
    ).then((result) {
      setState(() {
        if (result != null) {
          _factory.productionMode = result;
        }
      });
    });
  }

  void _onLabelSelect() async {
    List<LabelModel> labels = await UserRepositoryImpl().labels();
    labels.removeWhere((label) => label.group != 'FACTORY');
    if (_factory.labels == null) _factory.labels = [];

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return EnumSelectPage(
          title: '选择标签',
          items: labels,
          models: _factory.labels,
          multiple: true,
        );
      },
    ).then((result) {
      setState(() {
        if (result != null) {
          _factory.labels = result;
        }
      });
    });
  }
}

class EquipmentPage extends StatefulWidget {
  EquipmentPage(this.item, {this.enabled = true});

  final FactoryModel item;
  final bool enabled;

  @override
  State<StatefulWidget> createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage> {
  List<Attribute> _attributes = [
    Attribute('cuttingDepartment', '裁剪部', CuttingDepartmentsEnum,
        multiple: true),
    Attribute(
      'productionWorkshop',
      '生产车间',
      ProductionWorkshopsEnum,
      multiple: true,
    ),
    Attribute('lastDepartment', '尾部', LastDepartmentsEnum, multiple: true),
  ];

  @override
  void initState() {
    if (widget.item.cuttingDepartment != null) {
      _attributes[0].valueSelects = widget.item.cuttingDepartment;
    }
    if (widget.item.productionWorkshop != null) {
      _attributes[1].valueSelects = widget.item.productionWorkshop;
    }
    if (widget.item.lastDepartment != null) {
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
              onTap: () async {
                Map<String, dynamic> result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PositioningRollPage(
                          crossAxisCount: 3,
                          attributes: _attributes,
                          title: '选择设备',
                          enabled: widget.enabled,
                        ),
                  ),
                );
                print(result);
                if (result != null) {
                  _attributes[0].valueSelects = result['cuttingDepartment'];
                  _attributes[1].valueSelects = result['productionWorkshop'];
                  _attributes[2].valueSelects = result['lastDepartment'];
                  widget.item.cuttingDepartment = result['cuttingDepartment'];
                  widget.item.productionWorkshop = result['productionWorkshop'];
                  widget.item.lastDepartment = result['lastDepartment'];
                }
              },
              child: _buildAttributesInfo()
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
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 17,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 80,
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: '设备',
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                    TextSpan(
                        text: '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        )),
                  ]),
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
              Icon(
                Icons.chevron_right,
                color: Colors.grey,
              )
            ],
          ),
        ),
      ],
    );
  }

  String _attributesSelectText() {
    String text = '';
    if (ClassHandleUtil.isNotEmpty(_attributes[0].valueSelects)) {
      text += _attributes[0].name;
      text += '--';
      for (int i = 0; i < _attributes[0].valueSelects.length; i++) {
        if (i == _attributes[0].valueSelects.length - 1) {
          text +=
              enumMap(CuttingDepartmentsEnum, _attributes[0].valueSelects[i]);
          text += '\n';
          break;
        }
        text += enumMap(CuttingDepartmentsEnum, _attributes[0].valueSelects[i]);
        text += '、';
      }
    }
    if (ClassHandleUtil.isNotEmpty(_attributes[1].valueSelects)) {
      text += _attributes[1].name;
      text += '--';
      for (int i = 0; i < _attributes[1].valueSelects.length; i++) {
        if (i == _attributes[1].valueSelects.length - 1) {
          text +=
              enumMap(ProductionWorkshopsEnum, _attributes[1].valueSelects[i]);
          text += '\n';
          break;
        }
        text +=
            enumMap(ProductionWorkshopsEnum, _attributes[1].valueSelects[i]);
        text += '、';
      }
    }
    if (ClassHandleUtil.isNotEmpty(_attributes[2].valueSelects)) {
      text += _attributes[2].name;
      text += '--';
      for (int i = 0; i < _attributes[2].valueSelects.length; i++) {
        if (i == _attributes[2].valueSelects.length - 1) {
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
