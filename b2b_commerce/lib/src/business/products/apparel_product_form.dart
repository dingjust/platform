import 'package:b2b_commerce/src/business/products/apparel_product_prices_input.dart';
import 'package:b2b_commerce/src/business/products/form/colors_sizes_field.dart';
import 'package:b2b_commerce/src/business/products/form/fabricCompositions_field.dart';
import 'package:b2b_commerce/src/business/products/form/stocks_field.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'form/attributes_field.dart';
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
  }) : super(key: const Key('__apparelProductFormPage__'));

  ApparelProductModel item;
  final bool isCreate;
  final String status;
  final String keyword;

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

  ApparelProductModel _product = ApparelProductModel();

  @override
  void initState() {
    print(widget.item.productType);
    _product
      ..id = widget.item.id
      ..name = widget.item.name
      ..code = widget.item.code
      ..attributes = widget.item.attributes ??
          ApparelProductAttributesModel(fabricCompositions: [])
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
      ..steppedPrices = widget.item.steppedPrices
      ..spotSteppedPrices = widget.item.spotSteppedPrices
      ..deliveryDays = widget.item.deliveryDays
      ..basicProduction = widget.item.basicProduction
      ..productionDays = widget.item.productionDays
      ..productionIncrement = widget.item.productionIncrement
      ..productType = widget.item.productType ?? [ProductType.FUTURE_GOODS]
      ..colorSizes = widget.item.colorSizes ?? []
      ..salesVolume = widget.item.salesVolume;
    if (_product.attributes.fabricCompositions == null) {
      _product.attributes.fabricCompositions = [];
    }
    _nameController.text = widget.item?.name;
    _skuIDController.text = widget.item?.skuID;
    _brandController.text = widget.item?.brand;
    // _priceController.text = widget.item?.price?.toString();
    _gramWeightController.text = widget.item?.gramWeight?.toString();
    // TODO: implement initState
    super.initState();
  }

  //判断产品类型是否可选
  bool isCanSelect(ProductType type) {
    bool result = true;
    switch (type) {
      case ProductType.DEFAULT_GOODS:
        break;
      case ProductType.SPOT_GOODS:
        if (_product.productType.contains(ProductType.TAIL_GOODS)) {
          result = false;
        }
        break;
      case ProductType.FUTURE_GOODS:
        if (_product.productType.contains(ProductType.TAIL_GOODS)) {
          result = false;
        }
        break;
      case ProductType.TAIL_GOODS:
        if (_product.productType.contains(ProductType.SPOT_GOODS) ||
            _product.productType.contains(ProductType.FUTURE_GOODS)) {
          result = false;
        }
        break;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
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

        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: Text(widget.isCreate ? '新建产品' : '编辑产品'),
          actions: <Widget>[],
        ),
        bottomNavigationBar: Container(
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
              enabled: true,
            ),
            DetailPictureField(
              _product,
              enabled: true,
            ),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
            _buildProductType(context),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
            Container(
              color: Colors.white,
              child: TextFieldComponent(
                dividerPadding: EdgeInsets.all(0),
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
                hintText: '请填写产品标题',
                onChanged: (value) {
                  _product.name = value;
                },
              ),
            ),
            Container(
              color: Colors.white,
              child: TextFieldComponent(
                dividerPadding: EdgeInsets.all(0),
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
                hintText: '请填写产品货号',
                onChanged: (value) {
                  _product.skuID = value;
                },
              ),
            ),
            Container(
              color: Colors.white,
              child: MinorCategoryField(
                _product,
                enabled: true,
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
                  List<ColorSizeModel> colors =
                  await Provider.of<ColorState>(context).getPartColors();
                  List<ColorSizeEntryModel> sizes =
                  await Provider.of<SizeState>(context).getPartSizes();
                  ApparelProductModel result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ColorsSizesField(
                                _product,
                                colors: colors,
                                sizes: sizes,
                              )));
                  setState(() {
                    print(ApparelProductModel.toJson(_product));
                    _product.colorSizes = result.colorSizes;
                  });
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
                    colorSizeSelectText(_product.colorSizes),
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
            Offstage(
              offstage:
              !(_product.productType.contains(ProductType.SPOT_GOODS) ||
                  _product.productType.contains(ProductType.TAIL_GOODS)),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(15),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async{
                    dynamic result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                StocksField(_product, enabled: true)));

                    if(result != null){
                      setState(() {
                        _product.colorSizes = result;
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
                                text: '库存设置',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                )),
                          ]),
                        ),
                      ),
                      Text(
                        '库存总数量：${_colorTotalNum()}',
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
//                              TextSpan(
//                                  text: '*',
//                                  style: TextStyle(color: Colors.red,fontSize: 16,)
//                              ),
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
                dividerPadding: EdgeInsets.all(0),
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
                hintText: '请填写品牌',
                onChanged: (value) {
                  _product.brand = value;
                },
              ),
            ),
            Container(
              color: Colors.white,
              child: Container(
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ApparelProductPricesInputPage(
                                  _product,
                                  enabled: true,
                                )));
                  },
                  child: ShowSelectTile(
                    leadingText: '价格设置',
                    isRequired: true,
                  ),
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
                dividerPadding: EdgeInsets.all(0),
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
                hintText: '请填写重量（数字）',
                inputFormatters: [
                  DecimalInputFormat(),
                ],
                onChanged: (value) {
                  _product.gramWeight = double.parse(value);
                },
              ),
            ),
            Container(
              color: Colors.white,
              child: AttributesField(
                _product,
                enabled: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildProductType(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: '产品类型',
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
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: (context),
                        builder: (context) {
                          return MessageDialog(
                            title: Text(
                              '如何选择产品类型',
                              style: TextStyle(fontSize: 18),
                            ),
                            message: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: '注：库存尾货不能和现货、期货同时选择',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black)),
                              ]),
                            ),
                            onCloseEvent: () {
                              Navigator.pop(context);
                            },
                            negativeText: '我知道了',
                          );
                        });
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 0),
                    child: Icon(
                      Icons.help,
                      color: Colors.red,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
              children: ProductType.values
                  .where((v) => v != ProductType.DEFAULT_GOODS)
                  .map((type) {
                return GestureDetector(
                  onTap: () {
                    if (!isCanSelect(type)) {
                      return;
                    }
                    setState(() {
                      if (!_product.productType.contains(type)) {
                        _product.productType.add(type);
                      } else {
                        _product.productType.remove(type);
                      }
                    });
                  },
                  child: Row(
                    children: <Widget>[
                      Checkbox(
                        onChanged: (v) {
                          if (!isCanSelect(type)) {
                            return;
                          }
                          print(type);
                          print(_product.productType);
                          print(type == _product.productType);
                          setState(() {
                            if (v) {
                              _product.productType.add(type);
                            } else {
                              _product.productType.remove(type);
                            }
                          });
                        },
                        activeColor: Colors.orange,
                        value: _product.productType.contains(type),
                      ),
                      Text(
                        ProductTypeLocalizedMap[type],
                        softWrap: false,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                            color: isCanSelect(type) ? Colors.black : Colors
                                .grey),
                      )
                    ],
                  ),
                );
              }).toList())
        ],
      ),
    );
  }

  onPublish() {
    if (_product.images == null || _product.images.isEmpty) {
      _showValidateMsg(context, '请上传主图');
      return;
    }
    if (_product.productType == null || _product.productType.isEmpty) {
      _showValidateMsg(context, '选择产品类型');
      return;
    }
    if (_product.name == null) {
      _showValidateMsg(context, '请填写产品标题');
      return;
    }
    if (_product.skuID == null) {
      _showValidateMsg(context, '请填写产品货号');
      return;
    }
    if (_product?.category?.id == null) {
      _showValidateMsg(context, '请选择产品类别');
      return;
    }
    if (_product.colorSizes == null || _product.colorSizes.isEmpty) {
      _showValidateMsg(context, '请选择颜色尺码');
      return;
    }
    if (_product.productType.contains(ProductType.SPOT_GOODS) ||
        _product.productType.contains(ProductType.TAIL_GOODS)) {
      for (int i = 0; i < _product.spotSteppedPrices.length; i++) {
        if (_product.spotSteppedPrices[i].price == null &&
            _product.spotSteppedPrices[i].minimumQuantity == null) {
          _product.spotSteppedPrices.remove(_product.spotSteppedPrices[i]);
        } else if (_product.spotSteppedPrices[i].price != null &&
            _product.spotSteppedPrices[i].minimumQuantity != null) {} else {
          ShowDialogUtil.showValidateMsg(context, '请完善期货阶梯起订量和价格');
          return;
        }
      }
      if (_product.spotSteppedPrices == null ||
          _product.spotSteppedPrices.isEmpty) {
        _showValidateMsg(context, '请填写现货/尾货阶梯价');
        return;
      }
      // if(_product.deliveryDays == null){
      //   _showValidateMsg(context, '请填写现货/尾货发货周期');
      //   return;
      // }

      if (_product.spotSteppedPrices.length > 1) {
        for (int i = 0; i < _product.spotSteppedPrices.length; i++) {
          if (i == _product.spotSteppedPrices.length - 1) {
            break;
          }

          if (_product.spotSteppedPrices[i + 1].minimumQuantity != null &&
              _product.spotSteppedPrices[i].minimumQuantity != null) {
            if (_product.spotSteppedPrices[i + 1].minimumQuantity <=
                _product.spotSteppedPrices[i].minimumQuantity) {
              ShowDialogUtil.showValidateMsg(
                  context,
                  '现货/尾货第' +
                      enumMap(DightEnum, i + 2) +
                      '阶梯的起订量不可小于或等于' +
                      '第' +
                      enumMap(DightEnum, i + 1) +
                      '阶梯的起订量');
              return;
            }
          }
        }
      }
    }
    if (_product.productType.contains(ProductType.FUTURE_GOODS)) {
      if (_product.steppedPrices == null || _product.steppedPrices.isEmpty) {
        _showValidateMsg(context, '请填写期货阶梯价');
        return;
      }
      for (int i = 0; i < _product.steppedPrices.length; i++) {
        if (_product.steppedPrices[i].price == null &&
            _product.steppedPrices[i].minimumQuantity == null) {
          _product.steppedPrices.remove(_product.steppedPrices[i]);
        } else if (_product.steppedPrices[i].price != null &&
            _product.steppedPrices[i].minimumQuantity != null) {} else {
          ShowDialogUtil.showValidateMsg(context, '请完善期货阶梯起订量和价格');
          return;
        }
      }
      if (_product.basicProduction == null ||
          _product.productionIncrement == null ||
          _product.productionDays == null) {
        _showValidateMsg(context, '请填写期货生产天数');
        return;
      }

      for (int i = 0; i < _product.steppedPrices.length; i++) {
        if (_product.steppedPrices[i].price == null &&
            _product.steppedPrices[i].minimumQuantity == null) {
          _product.steppedPrices.remove(_product.steppedPrices[i]);
        } else if (_product.steppedPrices[i].price != null &&
            _product.steppedPrices[i].minimumQuantity != null) {} else {
          ShowDialogUtil.showValidateMsg(context, '请完善期货阶梯起订量和价格');
          return;
        }
      }

      if (_product.steppedPrices.length > 1) {
        for (int i = 0; i < _product.steppedPrices.length; i++) {
          if (i == _product.steppedPrices.length - 1) {
            break;
          }

          if (_product.steppedPrices[i + 1].minimumQuantity != null &&
              _product.steppedPrices[i].minimumQuantity != null) {
            if (_product.steppedPrices[i + 1].minimumQuantity <=
                _product.steppedPrices[i].minimumQuantity) {
              ShowDialogUtil.showValidateMsg(
                  context,
                  '期货第' +
                      enumMap(DightEnum, i + 2) +
                      '阶梯的起订量不可小于或等于' +
                      '第' +
                      enumMap(DightEnum, i + 1) +
                      '阶梯的起订量');
              return;
            }
          }
        }
      }
    }

//    if (_product.attributes.fabricCompositions == null || _product.attributes.fabricCompositions.isEmpty) {
//      _showValidateMsg(context, '请选择面料成分');
//      return;
//    }
//    if (UserBLoC.instance.currentUser.type == UserType.BRAND &&
//        _product.price == null) {
//      _showValidateMsg(context, '请填写产品价格');
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
          ApparelProductBLoC.instance.clearProductsMapByStatus(widget.status);
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
        print('${value}-==============');
        if (value) {
          Navigator.of(context).pop(value);
          ApparelProductBLoC.instance.clearProductsMap();
          ApparelProductBLoC.instance.getDatas();
        } else {
          BotToast.showText(text: '系统错误，更新产品失败');
        }
      });
    }
  }

  int _colorTotalNum() {
    int result = 0;
    _product.colorSizes.forEach((colorSize) {
      colorSize.sizes.forEach((size) {
        result += size.quality ?? 0;
      });
    });
    return result;
  }

  //格式化选中的颜色尺码
  Widget colorSizeSelectText(List<ColorSizeModel> colorsSizes) {
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

    // return text;
    return Text(text,
        style: TextStyle(
          color: Colors.grey,
        ));
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
