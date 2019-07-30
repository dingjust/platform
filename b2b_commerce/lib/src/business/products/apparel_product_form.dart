import 'package:b2b_commerce/src/business/products/form/prices_field.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'form/attributes_field.dart';
import 'form/color_size_stock_field.dart';
import 'form/detail_picture_field.dart';
import 'form/minor_category_field.dart';
import 'form/normal_picture_field.dart';

class ApparelProductFormPage extends StatefulWidget {
  ApparelProductFormPage({
    Key key,
    @required this.item,
    this.isCreate = false,
    this.status = 'ALL',
    this.keyword,
    this.enabled = false,
  }) : super(key: const Key('__apparelProductFormPage__'));

  ApparelProductModel item;
  final bool isCreate;
  final String status;
  final String keyword;
  final bool enabled;

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

  bool _enabled = false;
  ApparelProductModel _product = ApparelProductModel();

  @override
  void initState() {
    _enabled = widget.enabled;
    _product
      ..id = widget.item.id
      ..name = widget.item.name
      ..code = widget.item.code
      ..attributes = widget.item.attributes
      ..category = widget.item.category
      ..approvalStatus = widget.item.approvalStatus
      ..thumbnail = widget.item.thumbnail
      ..variants = widget.item.variants
      ..maxPrice = widget.item.maxPrice
      ..minPrice = widget.item.minPrice
      ..price = widget.item.price
      ..belongTo = widget.item.belongTo
      ..gramWeight = widget.item.gramWeight
      ..skuID = widget.item.skuID
      ..thumbnails = widget.item.thumbnails
      ..images = widget.item.images
      ..details = widget.item.details
      ..brand = widget.item.brand
      ..proofingFee = widget.item.proofingFee
      ..steppedPrices = widget.item.steppedPrices
      ..basicProduction = widget.item.basicProduction
      ..productionDays = widget.item.productionDays
      ..productionIncrement = widget.item.productionIncrement
      ..salesVolume = widget.item.salesVolume;
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
        if (_enabled) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return CustomizeDialog(
                  dialogType: DialogType.CONFIRM_DIALOG,
                  contentText2:
                      widget.isCreate ? '正在创建产品，是否确认退出' : '正在编辑产品，是否确认退出',
                  isNeedConfirmButton: true,
                  isNeedCancelButton: true,
                  confirmButtonText: '退出',
                  cancelButtonText: '再看看',
                  dialogHeight: 180,
                  confirmAction: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                );
              }).then((_) {
//            Navigator.of(context).pop();
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
          title: Text(widget.isCreate ? '新建产品' : _enabled ? '编辑产品' : '产品明细'),
          actions: <Widget>[
            Offstage(
              offstage: _enabled || widget.item.approvalStatus == ArticleApprovalStatus.approved,
              child: IconButton(
                icon: Text('编辑'),
                onPressed: () {
                  setState(() {
                    _enabled = true;
                  });
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: !_enabled
            ? null
            : Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                height: 50,
                child: RaisedButton(
                  color: Color.fromRGBO(255, 214, 12, 1),
                  child: Text(
                    '确定',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  onPressed: onPublish,
                ),
              ),
        body: ListView(
          children: <Widget>[
            NormalPictureField(
              _product,
              enabled: _enabled,
            ),
            DetailPictureField(
              _product,
              enabled: _enabled,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(
                height: 0,
                color: Color(Constants.DIVIDER_COLOR),
              ),
            ),
            TextFieldComponent(
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              isRequired: true,
              focusNode: _nameFocusNode,
              controller: _nameController,
              leadingText: Text('产品标题',
                  style: TextStyle(
                    fontSize: 16,
                  )),
              hintText: !_enabled ? '' : '请填写产品标题',
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                _product.name = value;
              },
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(_skuIDFocusNode);
              },
              enabled: _enabled,
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
              hintText: !_enabled ? '' : '请填写产品货号',
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                _product.skuID = value;
              },
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(_brandFocusNode);
              },
              enabled: _enabled,
            ),
            MinorCategoryField(
              _product,
              enabled: _enabled,
            ),
            ColorSizeStockField(
              _product,
              enabled: _enabled,
            ),
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
              hintText: !_enabled ? '' : '请填写品牌',
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                _product.brand = value;
              },
              onEditingComplete: () {
                if (UserBLoC.instance.currentUser.type == UserType.BRAND) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                } else if (UserBLoC.instance.currentUser.type ==
                    UserType.FACTORY) {
                  FocusScope.of(context).requestFocus(_gramWeightFocusNode);
                }
              },
              enabled: _enabled,
            ),
            Offstage(
              offstage: UserBLoC.instance.currentUser.type != UserType.BRAND,
              child: TextFieldComponent(
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                isRequired: true,
                focusNode: _priceFocusNode,
                controller: _priceController,
                leadingText: Text('供货价',
                    style: TextStyle(
                      fontSize: 16,
                    )),
                hintText: !_enabled ? '' : '请填写供货价（数字）',
                textInputAction: TextInputAction.next,
                prefix: '￥',
                inputFormatters: [
                  DecimalInputFormat(),
                ],
                onChanged: (value) {
                  _product.price =
                      ClassHandleUtil.removeSymbolRMBToDouble(value);
                },
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(_gramWeightFocusNode);
                },
                enabled: _enabled,
              ),
            ),
            Offstage(
              offstage: UserBLoC.instance.currentUser.type != UserType.FACTORY,
              child: PricesField(
                _product,
                enabled: _enabled,
              ),
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
              hintText: !_enabled ? '' : '请填写重量（数字）',
              inputFormatters: [
                DecimalInputFormat(),
              ],
              onChanged: (value) {
                _product.gramWeight = double.parse(value);
              },
              enabled: _enabled,
            ),
            AttributesField(
              _product,
              enabled: _enabled,
            ),
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
    );
//        }
//        );
  }

  onPublish() {
    print(_product.details);
    if (_product.images == null || _product.images.isEmpty) {
      _showValidateMsg(context, '请上传主图');
      return;
    } else if (_product.name == null) {
      _showValidateMsg(context, '请填写产品标题');
      return;
    } else if (_product.skuID == null) {
      _showValidateMsg(context, '请填写产品货号');
      return;
    } else if (_product.category == null) {
      _showValidateMsg(context, '请选择产品类别');
      return;
    }
    if (_product.variants == null || _product.variants.isEmpty) {
      _showValidateMsg(context, '请选择颜色尺码');
      return;
    }
    if (UserBLoC.instance.currentUser.type == UserType.BRAND &&
        _product.price == null) {
      _showValidateMsg(context, '请填写产品价格');
      return;
    }
    if (_product.attributes == null) {
      _product.attributes = ApparelProductAttributesModel();
    }
    if (_product.steppedPrices == null) {
      _product.steppedPrices = [];
    }
    Navigator.pop(context);
    if (widget.isCreate) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return RequestDataLoading(
              requestCallBack: ProductRepositoryImpl().create(_product),
              outsideDismiss: false,
              loadingText: '保存中。。。',
              entrance: 'apparelProduct',
              keyword: widget.keyword,
            );
          }).then((value){
            print(value);
            ApparelProductBLoC.instance.clearProductsMapByStatus(widget.status);
            ApparelProductBLoC.instance.getDatas(status: widget.status);
      });
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return RequestDataLoading(
              requestCallBack: ProductRepositoryImpl().update(_product),
              outsideDismiss: false,
              loadingText: '保存中。。。',
              entrance: 'apparelProduct',
              keyword: widget.keyword,
            );
          }).then((value){
            print(value);
            ApparelProductBLoC.instance.clearProductsMapByStatus(widget.status);
            ApparelProductBLoC.instance.getDatas(status: widget.status);
      });
    }
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
