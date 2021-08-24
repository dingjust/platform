import 'dart:ui';

import 'package:amap_location/amap_location.dart';
import 'package:b2b_commerce/src/_shared/widgets/address_cascader.dart';
import 'package:b2b_commerce/src/_shared/widgets/quantity_select.dart';
import 'package:b2b_commerce/src/business/orders/form/expected_delivery_date_field.dart';
import 'package:b2b_commerce/src/business/orders/form/pictures_field.dart';
import 'package:b2b_commerce/src/home/requirement/requirement_publish_success.dart';
import 'package:b2b_commerce/src/my/address/amap_search_page.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'RequirementFormMixins.dart';
import 'requirement_pay_form.dart';

class RequirementFormProduct extends StatefulWidget {
  RequirementFormProduct({
    this.formState,
  });

  final RequirementOrderFormStateV2 formState;

  _RequirementFormProductState createState() => _RequirementFormProductState();
}

class _RequirementFormProductState extends State<RequirementFormProduct>
    with RequirementFormMixin {
  GlobalKey _scaffoldKey = GlobalKey();

  bool isPhoneSame = false;

  //看款下单类型
  ProductType type;

  @override
  void initState() {
    //埋点>>>需求发布页面进入
    UmengPlugin.onEvent('requirement_publish_page');

    super.initForm();
    super.initCreate(widget.formState.model);
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => getLocation());

    widget.formState.model.orderType = RequirementOrderType.LOOK_STYLE;

    //设置默认联系人
    if (widget.formState?.model?.details != null) {
      if (widget.formState?.model?.details?.contactPhone == null ||
          widget.formState?.model?.details?.contactPhone == "") {
        widget.formState.model.details.contactPhone =
            UserBLoC.instance.currentUser.mobileNumber;
        widget.formState.model.details.contactPerson =
            UserBLoC.instance.currentUser.name;
        contactController.text =
            '${UserBLoC.instance.currentUser.mobileNumber}';
      }
    }

    if (widget.formState.product != null &&
        widget.formState.product.spotSteppedPrices != null &&
        widget.formState.product.spotSteppedPrices.isNotEmpty) {
      widget.formState.model.details.maxExpectedPrice = widget
          .formState.product.spotSteppedPrices.first.minimumQuantity
          .toDouble();
    }

    if (widget.formState?.product?.productType?.length == 1) {
      type = widget.formState.product.productType.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        ShowDialogUtil.showChoseDiglog(context, '正在创建订单，是否确认退出', () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
        return Future.value(false);
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: Text('看款下单'),
          actions: <Widget>[],
        ),
        body: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              _buildTypeRadio(),
              _buildTitleName(),
              _buildRemarks(),
              Container(
                color: Colors.white,
                child: PicturesField(
                  model: widget.formState.model,
                  description: '（补充图片可令工厂更快了解需求）',
                ),
              ),
              _buildExceptedPrice(),
              _buildMachiningQuantity(),
              // _buildMajorCategory(),
              _buildCategory(),
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: ExpectedDeliveryDateField(widget.formState.model),
              ),
              _buildQualityLevel(),
              _buildMachiningType(),
              _buildProductiveOrientations(),
              _buildPayInfo(),
              _buildProofingNeeded(),
              _buildSizeType(),
              _buildColorType(),
              _buildInvoiceNeeded(),
              _buildEffectiveDays(),
              _buildLocation(),
              _buildContactPhone(),
              _buildInfo('钉单将通过隐私电话服务保障您的信息安全'),
              _buildWechat(),
              _buildIsSame(),
              _buildSubBtn()
            ],
          ),
        ),
      ),
    );
  }

  Container _buildRemarks() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(children: <Widget>[
        Container(
          color: Colors.grey[100],
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextFieldComponent(
            padding: EdgeInsets.symmetric(vertical: 5),
            dividerPadding: EdgeInsets.only(),
            focusNode: remarksFocusNode,
            hintText: '需求描述...',
            autofocus: false,
            inputType: TextInputType.text,
            textAlign: TextAlign.left,
            hideDivider: true,
            maxLines: null,
            maxLength: 200,
            controller: remarksController,
            onChanged: (v) {
              widget.formState.model.remarks = remarksController.text;
            },
          ),
        )
      ]),
    );
  }

  Widget _buildTypeRadio() {
    List<ProductType> types =
        widget.formState.product?.productType ?? [ProductType.SPOT_GOODS];

    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 10),
          child: RichText(
            text: TextSpan(children: [
              TextSpan(
                text: '下单类型',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: ' *',
                style: TextStyle(fontSize: 16, color: Colors.red),
              )
            ]),
          ),
        ),
        Expanded(
            child: Row(
          children: types
              .map((value) => Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Radio(
                          groupValue: type,
                          value: value,
                          onChanged: (val) {
                            setState(() {
                              type = val;
                              //现货或库存固定价格
                              if ([
                                ProductType.SPOT_GOODS,
                                ProductType.TAIL_GOODS
                              ].contains(type)) {
                                widget.formState.model.details
                                    .maxExpectedPrice = widget.formState.product
                                        ?.spotSteppedPrices?.first?.price ??
                                    0;
                              }
                            });
                          },
                        ),
                        Text('${ProductTypeLocalizedMap[value]}'),
                      ],
                    ),
                  ))
              .toList(),
        ))
      ],
    );
  }

  ///有效期限
  Container _buildEffectiveDays() {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: '有效期限',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ]),
              ),
            ),
            Expanded(
              flex: 3,
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 3,
                crossAxisSpacing: 0,
                mainAxisSpacing: 20,
                childAspectRatio: 4,
                padding: EdgeInsets.zero,
                children: List.generate(EffectiveDaysEnum.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.formState.model.details.effectiveDays =
                            int.parse(EffectiveDaysEnum[index].code);
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        Radio(
                            value: EffectiveDaysEnum[index].code,
                            groupValue: widget
                                .formState.model.details.effectiveDays
                                .toString(),
                            onChanged: (v) {
                              setState(() {
                                widget.formState.model.details.effectiveDays =
                                    int.parse(EffectiveDaysEnum[index].code);
                              });
                            }),
                        Expanded(
                            child: Text(
                          EffectiveDaysEnum[index].name,
                          softWrap: false,
                          overflow: TextOverflow.visible,
                        )),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ));
  }

  Container _buildProductiveOrientations() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        children: <Widget>[
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: '要求地区',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: ' *',
                style: TextStyle(fontSize: 16, color: Colors.red),
              )
            ]),
          ),
          Expanded(
            child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => AddressCascaderPage(
                                selected: widget.formState.model.details
                                        ?.productiveDistricts
                                        ?.map((e) => DistrictModel.toJson(e))
                                        .toList() ??
                                    [],
                                multi: true,
                              )))
                      .then((values) {
                    if (values != null) {
                      setState(() {
                        widget.formState.model.details.productiveDistricts =
                            (values as List)
                                .map((e) => DistrictModel.fromJson(e))
                                .toList();
                      });
                    }
                  });
                },
                child: Text(
                  formatAreaSelectsText(
                      widget.formState.model.details.productiveDistricts, 3),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                )),
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Container _buildInvoiceNeeded() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: '是否开票',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ]),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ChoiceChip(
                    label: Container(
                      height: 20,
                      width: 60,
                      child: Center(child: Text('是')),
                    ),
                    backgroundColor: Colors.grey[100],
                    selectedColor: Color.fromRGBO(255, 214, 12, 1),
                    selected: widget.formState.model.details.invoiceNeeded,
                    onSelected: (bool selected) {
                      setState(() {
                        widget.formState.model.details.invoiceNeeded = true;
                      });
                    },
                  ),
                  ChoiceChip(
                    label: Container(
                      height: 20,
                      width: 60,
                      child: Center(child: Text('否')),
                    ),
                    backgroundColor: Colors.grey[100],
                    selectedColor: Color.fromRGBO(255, 214, 12, 1),
                    selected: !widget.formState.model.details.invoiceNeeded,
                    onSelected: (bool selected) {
                      setState(() {
                        widget.formState.model.details.invoiceNeeded = false;
                      });
                    },
                  ),
                ]),
          ),
        ],
      ),
    );
  }

  Container _buildProofingNeeded() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: '是否打样',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ]),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ChoiceChip(
                    label: Container(
                      height: 20,
                      width: 60,
                      child: Center(child: Text('是')),
                    ),
                    backgroundColor: Colors.grey[100],
                    selectedColor: Color.fromRGBO(255, 214, 12, 1),
                    selected: widget.formState.model.details.proofingNeeded,
                    onSelected: (bool selected) {
                      setState(() {
                        widget.formState.model.details.proofingNeeded = true;
                      });
                    },
                  ),
                  ChoiceChip(
                    label: Container(
                      height: 20,
                      width: 60,
                      child: Center(child: Text('否')),
                    ),
                    backgroundColor: Colors.grey[100],
                    selectedColor: Color.fromRGBO(255, 214, 12, 1),
                    selected: !widget.formState.model.details.proofingNeeded,
                    onSelected: (bool selected) {
                      setState(() {
                        widget.formState.model.details.proofingNeeded = false;
                      });
                    },
                  ),
                ]),
          ),
        ],
      ),
    );
  }

  Container _buildMachiningType() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: '加工类型',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                TextSpan(
                  text: ' *',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                )
              ]),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: MachiningType.values
                  .map((type) => ChoiceChip(
                      label: Container(
                        height: 20,
                        width: 60,
                        child: Center(
                            child: Text(MachiningTypeLocalizedMap[type])),
                      ),
                      backgroundColor: Colors.grey[100],
                      selectedColor: Color.fromRGBO(255, 214, 12, 1),
                      selected:
                          widget.formState.model.details.machiningType == type,
                      onSelected: (bool selected) {
                        setState(() {
                          widget.formState.model.details.machiningType = type;
                        });
                      }))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildQualityLevel() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: '质量等级',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: ' *',
                style: TextStyle(fontSize: 16, color: Colors.red),
              )
            ]),
          ),
          Row(
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => SalesMarketSelectPage(
                                values:
                                    widget.formState.model.details.salesMarket,
                              )))
                      .then((values) {
                    if (values != null) {
                      setState(() {
                        widget.formState.model.details.salesMarket = values;
                      });
                    }
                  });
                },
                child: Text(
                  // 选择质量等级
                  formatEnumSelectsText(
                      widget.formState.model.details.salesMarket,
                      [
                        EnumModel('A_CHAIN', '一线大牌'),
                        // EnumModel('REGIONAL_CHAIN', '区域品牌'),
                        EnumModel('STALL_WHOLESALE', '档口精品'),
                        EnumModel('ELECTRONIC_COMMERCE_QUALITY', '电商品质'),
                        EnumModel('WHOLESALE_TRADE', '外贸批发'),
                        EnumModel('LEVEL01', '二线品牌'),
                        EnumModel('LEVEL02', '三线品牌'),
                        EnumModel('LEVEL03', '三线以下'),
                        EnumModel('LEVEL04', '档口跑量'),
                        EnumModel('LEVEL05', '电商高品质'),
                        EnumModel('LEVEL06', '电商跑量'),
                        EnumModel('LEVEL07', '跨境电商'),
                      ],
                      2,
                      customText: '选择质量等级'),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _buildMachiningQuantity() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: '数量',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                TextSpan(
                  text: ' *',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                )
              ]),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextFieldBorderComponent(
              padding: EdgeInsets.all(0),
              hideDivider: true,
              isRequired: true,
              textAlign: TextAlign.left,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              inputType: TextInputType.number,
              hintText: '填写',
              controller: super.expectedMachiningQuantityController,
              focusNode: super.expectedMachiningQuantityNode,
              onChanged: (v) {
                widget.formState.model.details.expectedMachiningQuantity =
                    ClassHandleUtil.transInt(
                        super.expectedMachiningQuantityController.text);
              },
            ),
          ),
        ],
      ),
    );
  }

  Container _buildExceptedPrice() {
    if (type != ProductType.FUTURE_GOODS) {
      return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('价格', style: TextStyle(fontSize: 16, color: Colors.black)),
              Text(
                '￥${widget.formState.product?.spotSteppedPrices?.first
                    ?.minimumQuantity ?? 0}',
                style: TextStyle(color: Colors.red, fontSize: 20),
              )
            ],
          ));
    }

    //期货
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: '期望价格',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      TextSpan(
                        text: ' *',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      )
                    ]),
                  ),
                ),
                Radio(
                    value: widget.formState.model.details.maxExpectedPrice,
                    groupValue: -1,
                    onChanged: (v) {
                      setState(() {
                        widget.formState.model.details.maxExpectedPrice = -1;
                      });
                    }),
                Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.formState.model.details.maxExpectedPrice = -1;
                        });
                      },
                      child: Text(
                        '面议',
                        softWrap: false,
                        overflow: TextOverflow.visible,
                      ),
                    )),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: widget.formState.model.details.maxExpectedPrice == -1
                ? Container(
              padding: const EdgeInsets.all(13.0),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                color: Colors.grey[50],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Center(
                      child: Text(
                        '面议',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      )),
                  InkWell(
                    child: Icon(
                      Icons.cancel,
                      size: 20,
                    ),
                    onTap: () {
                      setState(() {
                        widget.formState.model.details.maxExpectedPrice =
                        null;
                      });
                    },
                  ),
                ],
              ),
            )
                : TextFieldBorderComponent(
              padding: EdgeInsets.all(0),
              hideDivider: true,
              isRequired: true,
              textAlign: TextAlign.left,
              prefix: '￥',
              inputFormatters: [
                DecimalInputFormat(),
              ],
              // inputType: TextInputType.number,
              hintText: '填写',
              controller: super.maxExpectedPriceController,
              focusNode: super.maxExpectedPriceFocusNode,
              onChanged: (value) {
                setState(() {
                  if (value.contains('.')) {
                    int index = value.indexOf('.');
                    if (value.length > index + 3) {
                      super.maxExpectedPriceController.text =
                          value.substring(0, index + 3);
                    }
                  }
                  widget.formState.model.details.maxExpectedPrice =
                      ClassHandleUtil.removeSymbolRMBToDouble(
                          super.maxExpectedPriceController.text);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Container _buildCategory() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        children: <Widget>[
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: '商品品类',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: ' *',
                style: TextStyle(fontSize: 16, color: Colors.red),
              )
            ]),
          ),
          Expanded(
            child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Consumer(
                          builder: (context, CategoryState categoryState, _) =>
                              FutureBuilder(
                            future: categoryState.getCascadedCategories(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<CategoryModel>> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                return SingleCategorySelect(
                                  categories: snapshot.data,
                                  categorySelect:
                                      widget.formState.model.details.category,
                                  onItemTap: (categoryModel) {
                                    setState(() {
                                      widget.formState.model.details.category =
                                          categoryModel;
                                      Navigator.of(context).pop();
                                    });
                                  },
                                );
                              }
                            },
                          ),
                        );
                      });
                },
                child: Text(
                  '${widget.formState.model.details.category != null ? widget.formState.model.details.category.parent?.name + '-' + widget.formState.model.details.category?.name : '选择品类'}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.end,
                )),
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Container _buildMajorCategory() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        children: <Widget>[
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: '面料类型',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: ' *',
                style: TextStyle(fontSize: 16, color: Colors.red),
              )
            ]),
          ),
          Expanded(
            child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height:
                              MediaQueryData.fromWindow(window).size.height / 2,
                          child: Consumer(
                            builder: (context, MajorCategoryState categoryState,
                                    _) =>
                                FutureBuilder(
                              future: categoryState.getMajorCategories(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<CategoryModel>> snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  return SingleMajorCategorySelect(
                                    categories: snapshot.data,
                                    categorySelect: widget
                                        .formState.model.details.majorCategory,
                                    onItemTap: (categoryModel) {
                                      setState(() {
                                        widget.formState.model.details
                                            .majorCategory = categoryModel;
                                        Navigator.pop(context);
                                      });
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      });
                },
                child: Text(
                  '${widget.formState.model.details.majorCategory?.name ?? '选择面料类型'}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.end,
                )),
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Container _buildTitleName() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: TextFieldBorderComponent(
              padding: EdgeInsets.all(0),
              hideDivider: true,
              isRequired: true,
              textAlign: TextAlign.left,
              hintText: '标题',
              controller: super.productNameController,
              focusNode: super.productNameFocusNode,
              onChanged: (v) {
                widget.formState.model.details.productName =
                    super.productNameController.text;
              },
            ),
          ),
        ],
      ),
    );
  }

  Container _buildContactPhone() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        children: <Widget>[
          Icon(Icons.phone),
          Container(
            width: 100,
            margin: EdgeInsets.only(left: 10),
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: '联系电话',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                TextSpan(
                  text: ' *',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                )
              ]),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextFieldBorderComponent(
              padding: EdgeInsets.all(0),
              hideDivider: true,
              isRequired: true,
              textAlign: TextAlign.left,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              inputType: TextInputType.number,
              hintText: '输入手机号',
              controller: super.contactController,
              focusNode: super.contactPhoneFocusNode,
              onChanged: (v) {
                setState(() {
                  widget.formState.model.details.contactPhone = v;
                  if (isPhoneSame) {
                    widget.formState.model.details.contactWeChatNo = v;
                    wechatController.text = v;
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Container _buildPayInfo() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        children: <Widget>[
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: '支付条件',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              // TextSpan(
              //   text: ' *',
              //   style: TextStyle(fontSize: 16, color: Colors.red),
              // )
            ]),
          ),
          Expanded(
            child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => RequirementPayForm(
                                form: widget.formState.model.details.payPlan,
                              )))
                      .then((value) {
                    if (value != null) {
                      setState(() {
                        widget.formState.model.details.payPlan = value;
                      });
                    }
                  });
                },
                child: Text(
                  getPayStr(),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.end,
                )),
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Container _buildLocation() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        children: <Widget>[
          Container(
            width: 30,
            child: Icon(Icons.location_on),
          ),
          Expanded(
            child: GestureDetector(
                onTap: () async {
                  Tip tip = await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AmapSearchPage()));
                  List<String> locationArray = tip.location.split(',');
                  //设置定位信息
                  setState(() {
                    widget.formState.model.details
                      ..latitude = double.parse(locationArray[1])
                      ..longitude = double.parse(locationArray[0])
                      ..address = tip.address;
                  });
                },
                child: Text(
                  '${widget.formState.model.details?.address ?? '所在位置'}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.end,
                )),
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Container _buildWechat() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        children: <Widget>[
          Icon(B2BIcons.wechat, color: Colors.green),
          Container(
            width: 100,
            margin: EdgeInsets.only(left: 10),
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: '微信号',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ]),
            ),
          ),
          Expanded(
            flex: 1,
            child: TextFieldBorderComponent(
              padding: EdgeInsets.all(0),
              hideDivider: true,
              isRequired: true,
              textAlign: TextAlign.left,
              hintText: '输入微信号',
              controller: super.wechatController,
              focusNode: super.wechatFocusNode,
              onChanged: (v) {
                widget.formState.model.details.contactWeChatNo = v;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubBtn() {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      height: 50,
      child: RaisedButton(
          color: Color.fromRGBO(255, 214, 12, 1),
          child: Text(
            '确认发布',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
          onPressed: () async {
            onPublish();
          }),
    );
  }

  ///订单尺码类型
  Container _buildSizeType() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: '订单尺码',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ]),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [OrderSizeType.FREE_SIZE, OrderSizeType.MULTIPLE_SIZE]
                  .map((type) => ChoiceChip(
                      label: Container(
                        height: 20,
                        width: 60,
                        child: Center(
                            child: Text('${OrderSizeTypeLocalizedMap[type]}')),
                      ),
                      backgroundColor: Colors.grey[100],
                      selectedColor: Color.fromRGBO(255, 214, 12, 1),
                      selected: widget.formState.model.details.sizeType == type,
                      onSelected: (bool selected) {
                        setState(() {
                          widget.formState.model.details.sizeType = type;
                        });
                      }))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  ///订单颜色类型
  Container _buildColorType() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: '订单颜色',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ]),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OrderColorType.SINGLE_COLOR,
                OrderColorType.MULTIPLE_COLOR
              ]
                  .map((type) => ChoiceChip(
                      label: Container(
                        height: 20,
                        width: 60,
                        child: Center(
                            child: Text('${OrderColorTypeLocalizedMap[type]}')),
                      ),
                      backgroundColor: Colors.grey[100],
                      selectedColor: Color.fromRGBO(255, 214, 12, 1),
                      selected:
                          widget.formState.model.details.colorType == type,
                      onSelected: (bool selected) {
                        setState(() {
                          widget.formState.model.details.colorType = type;
                        });
                      }))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(String val) {
    return Padding(
        padding: EdgeInsets.only(right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('$val', style: TextStyle(fontSize: 12, color: Colors.grey))
          ],
        ));
  }

  Widget _buildIsSame() {
    return Padding(
        padding: EdgeInsets.only(right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('平台客服可以联系工厂',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            Checkbox(
              value: isPhoneSame,
              onChanged: (bool value) {
                setState(() {
                  isPhoneSame = value;
                  if (value) {
                    widget.formState.model.details.contactWeChatNo =
                        widget.formState.model.details.contactPhone;
                    wechatController.text =
                        widget.formState.model.details.contactPhone;
                  }
                });
              },
            ),
            Text('与手机同号'),
          ],
        ));
  }

  String getPayStr() {
    if (widget.formState.model.details.payPlan == null) {
      return '选择';
    } else {
      return PayPlanTypeLocalizedMap[
          widget.formState.model.details.payPlan.payPlanType];
    }
  }

  void getLocation() async {
    AmapState state = Provider.of<AmapState>(context, listen: false);

    Widget _dialog = CustomizeDialog(
      dialogType: DialogType.CONFIRM_DIALOG,
      contentText2: '钉单正在请求定位权限,请设置',
      isNeedConfirmButton: true,
      isNeedCancelButton: true,
      confirmButtonText: '去设置',
      cancelButtonText: '选择城市',
      dialogHeight: 180,
      confirmAction: () {
        state.openAppSetting().then((val) {
          Navigator.of(context).pop(val);
        });
      },
      cancelAction: () async {
        Navigator.of(context).pop();
        Tip tip = await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AmapSearchPage()));
        List<String> locationArray = tip.location.split(',');
        //设置定位信息
        state.setAMapLocation(
            // aOIName: tip.district.,
            longitude: double.parse(locationArray[0]),
            latitude: double.parse(locationArray[1]));
      },
    );

    AMapLocation aMapLocation = Provider.of<AmapState>(context, listen: false)
        .getAMapLocation(context: context, openDialog: _dialog);

    setState(() {
      widget.formState.model.details
        ..latitude = aMapLocation.latitude
        ..longitude = aMapLocation.longitude
        ..address = aMapLocation.formattedAddress
        ..provinceStr = aMapLocation.province
        ..cityStr = aMapLocation.city
        ..districtStr = aMapLocation.district;
    });
  }

  /// 发布
  void onPublish() async {
    if (widget.formState.model.details.productName == null) {
      ShowDialogUtil.showValidateMsg(context, '请填写标题');
      return;
    }

    if (widget.formState.model.remarks == null) {
      ShowDialogUtil.showValidateMsg(context, '请填写描述');
      return;
    }

    if (widget.formState.model.details.maxExpectedPrice == null) {
      ShowDialogUtil.showValidateMsg(context, '请填写期望价格');
      return;
    }
    if (widget.formState.model.details.expectedMachiningQuantity == null) {
      ShowDialogUtil.showValidateMsg(context, '请填写数量');
      return;
    }
    if (widget.formState.model.details.expectedDeliveryDate == null) {
      ShowDialogUtil.showValidateMsg(context, '请选取交货日期');
      return;
    } else if (widget.formState.model.details.expectedDeliveryDate
        .isBefore(DateTime.now())) {
      ShowDialogUtil.showValidateMsg(context, '交货时间不可比当前时间小');
      return;
    }
    if (widget.formState.model.details.contactPerson == null ||
        widget.formState.model.details.contactPerson == '' ||
        widget.formState.model.details.contactPhone == null ||
        widget.formState.model.details.contactPhone == '') {
      ShowDialogUtil.showValidateMsg(context, '请完善联系方式');
      return;
    }
    if (widget.formState.model.details.machiningType == null) {
      ShowDialogUtil.showValidateMsg(context, '请选择加工类型');
      return;
    }
    if (widget.formState.model.details.salesMarket == null ||
        widget.formState.model.details.salesMarket.length == 0) {
      ShowDialogUtil.showValidateMsg(context, '请选择质量等级');
      return;
    }

    // if (widget.formState.model.details.payPlan == null ||
    //     widget.formState.model.details.payPlan?.payPlanType == null) {
    //   ShowDialogUtil.showValidateMsg(context, '请选择支付条件');
    //   throw Exception('请选择支付条件');
    // }

    if (widget.formState.model.details.category == null) {
      ShowDialogUtil.showValidateMsg(context, '请选择商品品类');
      throw Exception('请选择商品品类');
    }

    // if (widget.formState.model.details.majorCategory == null) {
    //   ShowDialogUtil.showValidateMsg(context, '请选择面料类型');
    //   throw Exception('请选择面料类型');
    // }

    if (type == null) {
      ShowDialogUtil.showValidateMsg(context, '请选择下单类型');
      throw Exception('请选择下单类型');
    }

    if (widget.formState.model.details.effectiveDays == -1) {
      //后台的'长期有效'值是null
      widget.formState.model.details.effectiveDays = null;
    }

    // DialogHelper.showConfirm(
    //     title: '确定发布需求?', content: '', confirm: () async {});

    ShowDialogUtil.showChoseDiglog(context,
        '温馨提示：钉单平台无法保护您在电话、微信沟通和线下交易的可靠性及资金安全。请务必使用钉单平台的线上需求发布、钉单确认、合同签订、线上支付、对账单等系列功能，获得平台监督与仲裁服务。',
        () async {
      Function cancelFunc =
          BotToast.showLoading(clickClose: true, crossPage: false);
      BaseResponse response =
          await RequirementOrderRepository.newByType(widget.formState.model);
      Navigator.of(context).pop();
      cancelFunc.call();

      if (response != null && response.code == 1) {
        BotToast.showText(text: '创建成功');
        //埋点>>>需求发布成功
        UmengPlugin.onEvent('requirement_publish_success');
        //根据code查询明
        RequirementOrderModel model = await RequirementOrderRepository()
            .getRequirementOrderDetail(response.msg);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => PublishRequirementSuccessDialog(
                model: model,
              ),
            ),
            ModalRoute.withName('/'));
      } else if (response.code == 0) {
        BotToast.showText(text: '${response.msg}');
      } else {
        Navigator.of(context).pop();
      }
    }, height: 300, confirmButtonText: '我已知晓');
  }

  //格式选中的地区（多选）
  String formatAreaSelectsText(List<DistrictModel> selects, int count) {
    String text = '';
    if (selects == null || selects.length == 0) {
      return '选择要求地区';
    }
    text = selects.map((e) => e.name).join('、');

    return text;
  }
}
