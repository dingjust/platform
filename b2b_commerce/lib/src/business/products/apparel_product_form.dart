import 'package:b2b_commerce/src/business/products/form/prices_field.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'form/attributes_field.dart';
import 'form/color_size_stock_field.dart';
import 'form/minor_category_field.dart';
import 'form/normal_picture_field.dart';

class ApparelProductFormPage extends StatefulWidget {
  ApparelProductFormPage({
    Key key,
    @required this.item,
    this.isCreate = false,
    this.status = 'ALL',
    this.keyword,
  }) : super(key: const Key('__apparelProductFormPage__'));

  ApparelProductModel item;
  final bool isCreate;
  String status;
  String keyword;

  ApparelProductFormState createState() => ApparelProductFormState();
}

class ApparelProductFormState extends State<ApparelProductFormPage> {
  GlobalKey<FormState> _apparelProductForm = GlobalKey<FormState>();
  FocusNode _nameFocusNode = FocusNode();
  TextEditingController _nameController = TextEditingController();
  FocusNode _skuIDFocusNode = FocusNode();
  TextEditingController _skuIDController = TextEditingController();
  FocusNode _brandFocusNode = FocusNode();
  TextEditingController _brandController = TextEditingController();
  FocusNode _priceFocusNode = FocusNode();
  TextEditingController _priceController = TextEditingController();
  FocusNode _gramWeightFocusNode = FocusNode();
  TextEditingController _gramWeightController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.item?.name;
    _skuIDController.text = widget.item?.skuID;
    _brandController.text = widget.item?.brand;
    _priceController.text = widget.item?.price?.toString();
    _gramWeightController.text = widget.item?.gramWeight?.toString();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (widget.isCreate) {
          ShowDialogUtil.showAlertDialog(context, '是否确定退出', () {
            _clearProductData();
            Navigator.pop(context);
            Navigator.pop(context);
          });
        } else {
          Navigator.pop(context);
        }
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: Text(widget.isCreate ? '新建产品' : '编辑产品'),
          actions: <Widget>[
            IconButton(
              icon: Text(
                '确定',
                style: TextStyle(),
              ),
              onPressed: () async {
                bool isSubmit = false;
                print('${ApparelProductModel.toJson(widget.item)}');
                if (widget.item.images == null ||
                    widget.item.images.length <= 0) {
//                  isSubmit = _showValidateMsg(context, '请上传主图');
                  ShowDialogUtil.showSimapleDialog(context, '请上传主图');
                  ShowDialogUtil.showSimapleDialog(context, '请上传主图');
                } else if (widget.item.name == null) {
                  ShowDialogUtil.showSimapleDialog(context, '请输入产品名称');
                  ShowDialogUtil.showSimapleDialog(context, '请输入产品名称');
//                  isSubmit = _showValidateMsg(context, '请输入产品名称');
                } else if (widget.item.skuID == null) {
                  ShowDialogUtil.showSimapleDialog(context, '请输入产品货号');
                  ShowDialogUtil.showSimapleDialog(context, '请输入产品货号');
//                  isSubmit = _showValidateMsg(context, '请输入产品货号');
                } else if (widget.item.category == null) {
                  ShowDialogUtil.showSimapleDialog(context, '请输入产品类别');
                  ShowDialogUtil.showSimapleDialog(context, '请输入产品类别');
//                  isSubmit = _showValidateMsg(context, '请输入产品类别');
                } else {
                  isSubmit = true;
                }
                if (widget.item.attributes == null) {
                  widget.item.attributes = ApparelProductAttributesModel();
                }
                Navigator.pop(context);
                if (isSubmit) {
                  if (widget.isCreate) {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) {
                          return RequestDataLoading(
                            requestCallBack: ProductRepositoryImpl()
                                .create(widget.item)
                                .then((a) {
                              _clearProductData();
                            }),
                            outsideDismiss: false,
                            loadingText: '保存中。。。',
                            entrance: 'apparelProduct',
                            keyword: widget.keyword,
                          );
                        });
                  } else {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) {
                          return RequestDataLoading(
                            requestCallBack: ProductRepositoryImpl()
                                .update(widget.item)
                                .then((a) {
                              _clearProductData();
                            }),
                            outsideDismiss: false,
                            loadingText: '保存中。。。',
                            entrance: 'apparelProduct',
                            keyword: widget.keyword,
                          );
                        });
                  }
                }
                if (widget.keyword == null) {
                  ApparelProductBLoC.instance.clearProductsMapByStatus(widget.status);
                  ApparelProductBLoC.instance.filterByStatuses(widget.status);
                } else {
                  ApparelProductBLoC.instance.clearProductsMapByStatus(widget.status);
                  ApparelProductBLoC.instance.getData(widget.keyword);
                }
//              print(widget.item.attributes.styles[0]);
              },
            )
          ],
        ),
        body: Form(
          key: _apparelProductForm,
          child: ListView(
            children: <Widget>[
              NormalPictureField(widget.item),
//            DetailPictureField(widget.item),
              TextFieldComponent(
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                isRequired: true,
                focusNode: _nameFocusNode,
                controller: _nameController,
                leadingText: Text('产品名称',
                    style: TextStyle(
                      fontSize: 16,
                    )),
                hintText: '请输入产品名称',
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  widget.item.name = value;
                },
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(_skuIDFocusNode);
                },
              ),
              TextFieldComponent(
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                isRequired: true,
                focusNode: _skuIDFocusNode,
                controller: _skuIDController,
                leadingText: Text('产品货号',
                    style: TextStyle(
                      fontSize: 16,
                    )),
                hintText: '请输入产品货号',
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  widget.item.skuID = value;
                },
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(_brandFocusNode);
                },
              ),
              MinorCategoryField(widget.item),
              ColorSizeStockField(widget.item),
              TextFieldComponent(
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                focusNode: _brandFocusNode,
                controller: _brandController,
                leadingText: Text('品牌',
                    style: TextStyle(
                      fontSize: 16,
                    )),
                hintText: '请输入品牌',
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  widget.item.brand = value;
                },
                onEditingComplete: () {
                  if (UserBLoC.instance.currentUser.type == UserType.BRAND) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  } else if (UserBLoC.instance.currentUser.type ==
                      UserType.FACTORY) {
                    FocusScope.of(context).requestFocus(_gramWeightFocusNode);
                  }
                },
              ),
              Offstage(
                offstage: UserBLoC.instance.currentUser.type != UserType.BRAND,
                child: TextFieldComponent(
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  focusNode: _priceFocusNode,
                  controller: _priceController,
                  leadingText: Text('供货价',
                      style: TextStyle(
                        fontSize: 16,
                      )),
                  hintText: '请输入供货价（数字）',
                  textInputAction: TextInputAction.next,
                  prefix: '￥',
                  inputFormatters: [
                    DecimalInputFormat(),
                  ],
                  onChanged: (value) {
                    widget.item.price =
                        ClassHandleUtil.removeSymbolRMBToDouble(value);
                  },
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(_gramWeightFocusNode);
                  },
                ),
              ),
              Offstage(
                offstage:
                    UserBLoC.instance.currentUser.type != UserType.FACTORY,
                child: PricesField(widget.item),
              ),
              TextFieldComponent(
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                focusNode: _gramWeightFocusNode,
                controller: _gramWeightController,
//                inputType: TextInputType.number,
                leadingText: Text('重量（kg）',
                    style: TextStyle(
                      fontSize: 16,
                    )),
                hintText: '请输入重量（数字）',
                inputFormatters: [
                  DecimalInputFormat(),
                ],
                onChanged: (value) {
                  widget.item.gramWeight = double.parse(value);
                },
              ),
              AttributesField(widget.item),
//            PrivacyField(widget.item),
//            PostageFreeField(widget.item),
              /*Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ActionChip(
                        backgroundColor: Colors.red,
                        labelPadding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 22),
                        labelStyle: TextStyle(fontSize: 16),
                        label: Text('发布产品'),
                        onPressed: () {
                          // TODO:默认下架
                        },
                      ),
                    ),
                    Expanded(
                      child: ActionChip(
                        backgroundColor: Color.fromRGBO(255,214,12, 1),
                        labelPadding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 22),
                        labelStyle: TextStyle(fontSize: 16),
                        label: Text('直接上架'),
                        onPressed: () {
                          // TODO:直接上架
                        },
                      ),
                    )
                  ],
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
//        }
//        );
  }

  void _clearProductData() {
    widget.item.name = null;
    widget.item.code = null;
    widget.item.brand = null;
    widget.item.images = null;
    widget.item.category = null;
    widget.item.id = null;
    widget.item.attributes = null;
    widget.item.price = null;
    widget.item.maxPrice = null;
    widget.item.approvalStatus = null;
    widget.item.variants = null;
    widget.item.thumbnail = null;
    widget.item.thumbnails = null;
    widget.item.minPrice = null;
    widget.item.skuID = null;
    widget.item.gramWeight = null;
  }

  //非空提示
  bool _showValidateMsg(BuildContext context, String message) {
    _validateMessage(context, '${message}');
    return false;
  }

  Future<void> _validateMessage(BuildContext context, String message) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.RESULT_DIALOG,
            failTips: '${message}',
            callbackResult: false,
            outsideDismiss: true,
          );
        });
  }
}
