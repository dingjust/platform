import 'package:b2b_commerce/src/business/products/form/attributes_field.dart';
import 'package:b2b_commerce/src/business/products/form/colors_sizes_field.dart';
import 'package:b2b_commerce/src/business/products/form/detail_picture_field.dart';
import 'package:b2b_commerce/src/business/products/form/fabricCompositions_field.dart';
import 'package:b2b_commerce/src/business/products/form/minor_category_field.dart';
import 'package:b2b_commerce/src/business/products/form/normal_picture_field.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ApparelProductBrandFormPage extends StatefulWidget {
  ApparelProductBrandFormPage({
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

  _ApparelProductBrandFormState createState() =>
      _ApparelProductBrandFormState();
}

class _ApparelProductBrandFormState extends State<ApparelProductBrandFormPage> {
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
      ..attributes = widget.item.attributes ??
          ApparelProductAttributesModel(
              styles: [],
              popularElements: [],
              decorativePatterns: [],
              fabricCompositions: [])
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
      ..colorSizes = widget.item.colorSizes ?? []
      ..salesVolume = widget.item.salesVolume;

    _nameController.text = widget.item?.name;
    _skuIDController.text = widget.item?.skuID;
    _brandController.text = widget.item?.brand;
    // _priceController.text = widget.item?.price?.toString();
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
          title: Text(widget.isCreate ? '新建产品' : '编辑产品'),
          actions: <Widget>[],
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
            Container(
              color: Colors.white,
              child: TextFieldComponent(
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
                onChanged: (value) {
                  _product.name = value;
                },
                enabled: _enabled,
              ),
            ),
            Container(
              color: Colors.white,
              child: TextFieldComponent(
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
                onChanged: (value) {
                  _product.skuID = value;
                },
                enabled: _enabled,
              ),
            ),
            Container(
              color: Colors.white,
              child: MinorCategoryField(
                _product,
                enabled: _enabled,
              ),
            ),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(15),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  // print('=============qweqwe');
                  List<ColorSizeModel> colors =
                      await Provider.of<ColorState>(context, listen: false)
                          .getPartColors();
                  List<ColorSizeEntryModel> sizes =
                      await Provider.of<SizeState>(context, listen: false)
                          .getPartSizes();
                  dynamic result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ColorsSizesField(_product,
                              colors: colors, sizes: sizes)));
                  if (result != null) {
                    setState(() {
                      _product.colorSizes = result.colorSizes;
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: '颜色/尺码',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              )),
                          TextSpan(
                              text: ' *',
                              style: TextStyle(
                                color: Colors.red,
                              )),
                        ]),
                      ),
                    ),
                    Text(colorSizeSelectText(_product.colorSizes),
                        style: TextStyle(
                          color: Colors.grey,
                        )),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.blueGrey,
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(15),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  print('wqwqe');
                  dynamic result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FabricCompositionsField(
                                  _product.attributes.fabricCompositions,
                                  enabled: true)));
                  if (result != null) {
                    setState(() {
                      _product.attributes.fabricCompositions = result;
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: '面料成分',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              )),
                        ]),
                      ),
                    ),
                    Text(
                      '${fabricSelectText()}',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.blueGrey,
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
            Container(
              color: Colors.white,
              child: TextFieldComponent(
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
                onChanged: (value) {
                  _product.brand = value;
                },
//                onEditingComplete: () {
//                  if (UserBLoC.instance.currentUser.type == UserType.BRAND) {
//                    FocusScope.of(context).requestFocus(_priceFocusNode);
//                  } else if (UserBLoC.instance.currentUser.type ==
//                      UserType.FACTORY) {
//                    FocusScope.of(context).requestFocus(_gramWeightFocusNode);
//                  }
//                },
                enabled: _enabled,
              ),
            ),
            Container(
              color: Colors.white,
              child: TextFieldComponent(
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
            ),
            Container(
              color: Colors.white,
              child: AttributesField(
                _product,
                enabled: _enabled,
              ),
            ),
          ],
        ),
      ),
    );
//        }
//        );
  }

  onPublish() {
    if (_product.images == null || _product.images.isEmpty) {
      _showValidateMsg(context, '请上传主图');
      return;
    } else if (_product.name == null) {
      _showValidateMsg(context, '请填写产品标题');
      return;
    } else if (_product.skuID == null) {
      _showValidateMsg(context, '请填写产品货号');
      return;
    } else if (_product?.category?.id == null) {
      _showValidateMsg(context, '请选择产品类别');
      return;
    }
    if (_product.colorSizes == null || _product.colorSizes.isEmpty) {
      _showValidateMsg(context, '请选择颜色尺码');
      return;
    }
//    if (_product.attributes.fabricCompositions == null || _product.attributes.fabricCompositions.isEmpty) {
//      _showValidateMsg(context, '请选择面料成分');
//      return;
//    }
    if (_product.attributes == null) {
      _product.attributes = ApparelProductAttributesModel();
    }
    if (_product.steppedPrices == null) {
      _product.steppedPrices = [];
    }
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
          }).then((value) {
        if (value) {
          Navigator.pop(context, value);
        } else {
          BotToast.showText(text: '系统错误，创建产品失败');
        }
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
          }).then((value) {
        print(value);
        if (value) {
          Navigator.pop(context, value);
        } else {
          BotToast.showText(text: '系统错误，更新产品失败');
        }
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

  //格式化选中的颜色尺码
  String colorSizeSelectText(List<ColorSizeModel> colorsSizes) {
    String text = '';
    List<ColorSizeEntryModel> sizes;
    if (colorsSizes != null && colorsSizes.length > 0) {
      sizes = colorsSizes[0].sizes;
      for (int i = 0; i < colorsSizes.length; i++) {
        if (i > 1) {
          text += '...';
          break;
        }

        if (i == colorsSizes.length - 1) {
          text += colorsSizes[i].colorName;
        } else {
          text += colorsSizes[i].colorName + '、';
        }
      }
    }
    if (colorsSizes.length > 0 || (sizes != null && sizes.length > 0))
      text += '/';

    if (sizes != null && sizes.length > 0) {
      for (int i = 0; i < sizes.length; i++) {
        if (i > 1) {
          text += '...';
          break;
        }

        if (i == sizes.length - 1) {
          text += sizes[i].name;
        } else {
          text += sizes[i].name + '、';
        }
      }
    }

     return text;
//    return Text(text,
//        style: TextStyle(
//          color: Colors.grey,
//        ));
  }

  //格式化选中的面料成分
  String fabricSelectText() {
    String text = '';
    if (_product.attributes.fabricCompositions != null) {
      var names = enumCodesToNames(
          _product.attributes.fabricCompositions, FabricCompositionEnum);
      if (names.length > 2) {
        text = names.sublist(0, 2).join('、');
        text += '...';
      } else {
        text = names.join('、');
      }
    }
    return text;
  }
}
