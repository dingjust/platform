import 'dart:convert';
import 'dart:ui';

import 'package:b2b_commerce/b2b_commerce.dart';
import 'package:b2b_commerce/src/_shared/widgets/address_cascader.dart';
import 'package:b2b_commerce/src/business/orders/form/contact_way_field.dart';
import 'package:b2b_commerce/src/business/orders/form/expected_delivery_date_field.dart';
import 'package:b2b_commerce/src/business/orders/form/pictures_field.dart';
import 'package:b2b_commerce/src/business/orders/requirement/requirement_order_select_publish_target_form.dart';
import 'package:b2b_commerce/src/home/requirement/requirement_publish_success.dart';
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

class RequirementOrderForm extends StatefulWidget {
  RequirementOrderForm({
    this.formState,
  });

  final RequirementOrderFormState formState;

  _RequirementOrderFormState createState() => _RequirementOrderFormState();
}

class _RequirementOrderFormState extends State<RequirementOrderForm>
    with RequirementFormMixin {
  GlobalKey _scaffoldKey = GlobalKey();
  List<String> _factoryUids = [];

  @override
  void initState() {
    //埋点>>>需求发布页面进入
    UmengPlugin.onEvent('requirement_publish_page');

    if (widget.formState.factoryUid != null) {
      _factoryUids.add(widget.formState.factoryUid);
    }
    super.initForm();
    super.initCreate(widget.formState.model);
    super.initState();

    //设置默认联系人
    if (widget.formState?.model?.details != null) {
      if (widget.formState?.model?.details?.contactPhone == null ||
          widget.formState?.model?.details?.contactPhone == "") {
        widget.formState.model.details.contactPhone =
            UserBLoC.instance.currentUser.mobileNumber;
        widget.formState.model.details.contactPerson =
            UserBLoC.instance.currentUser?.name;
      }
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
          title: Text('需求发布'),
          actions: <Widget>[],
        ),
        bottomNavigationBar: Container(
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
        ),
        body: Container(
          color: Colors.grey[100],
          child: ListView(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: PicturesField(
                  model: widget.formState.model,
                ),
              ),
              _buildTitleName(),
              _buildMajorCategory(),
              _buildCategory(),
              _buildExceptedPrice(),
              _buildMachiningQuantity(),
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: ExpectedDeliveryDateField(widget.formState.model),
              ),
              Container(
                color: Colors.white,
                child: ContactWayField(widget.formState.model),
              ),
              _buildQualityLevel(),
              _buildMachiningType(),
              _buildProductiveOrientations(),
              _buildPopulationScale(),
              _buildProductionMode(),
              _buildSizeType(),
              _buildColorType(),
              _buildProofingNeeded(),
              _buildInvoiceNeeded(),
              _buildPublishModes(context),
              _buildEffectiveDays(),
              _buildRemarks(),
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
            hintText: '填写备注',
            autofocus: false,
            inputType: TextInputType.text,
            textAlign: TextAlign.left,
            hideDivider: true,
            maxLines: null,
            maxLength: 120,
            controller: remarksController,
            onChanged: (v) {
              widget.formState.model.remarks = remarksController.text;
            },
          ),
        )
      ]),
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

  Container _buildPublishModes(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    width: 100,
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: '发布方式',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ]),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    childAspectRatio: 5,
                    padding: EdgeInsets.zero,
                    children:
                        List.generate(PublishingModesEnum.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.formState.model.details.publishingMode =
                                PublishingModesEnum[index].code;
                          });
                        },
                        child: Row(
                          children: <Widget>[
                            Radio(
                                value: PublishingModesEnum[index].code,
                                groupValue: widget
                                    .formState.model.details.publishingMode,
                                onChanged: (v) {
                                  setState(() {
                                    widget.formState.model.details
                                            .publishingMode =
                                        PublishingModesEnum[index].code;
                                  });
                                }),
                            Expanded(
                              child: Text(
                                PublishingModesEnum[index].name,
                                softWrap: false,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 70,
                  margin: EdgeInsets.only(
                    right: 40,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                          context: (context),
                          builder: (context) {
                            return MessageDialog(
                              title: Text(
                                '如何选择发布方式',
                                style: TextStyle(fontSize: 18),
                              ),
                              message: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: '公开发布：',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.red),
                                  ),
                                  TextSpan(
                                      text:
                                          '可邀请工厂进行报价，需求发布后所有工厂都能看见，也可以对需求进行报价。',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black)),
                                  TextSpan(text: '\n\n'),
                                  TextSpan(
                                    text: '私密发布：',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.red),
                                  ),
                                  TextSpan(
                                      text: '需求发布后只能被已选择的工厂看见，且只有被选择的工厂才能进行报价。',
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
                        size: 20,
                      ),
                    ),
                  ),
                ),
                _buildPublishWay()
              ],
            ),
          ],
        ));
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

  ///工厂规模
  Widget _buildPopulationScale() {
    return GestureDetector(
      onTap: _onPopulationSelect,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: '工厂规模',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ]),
              ),
            ),
            Expanded(
              child: Text(
                widget.formState.model.details.populationScale == null
                    ? '选择工厂规模'
                    : PopulationScaleLocalizedMap[
                        widget.formState.model.details.populationScale],
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  ///生产模式
  Widget _buildProductionMode() {
    return GestureDetector(
      onTap: _onProductionModeSelect,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          children: <Widget>[
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: '生产模式',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ]),
            ),
            Expanded(
              child: Text(
                widget.formState.model.details.productionMode == null
                    ? '选择生产模式'
                    : ProductionModeLocalizedMap[
                        widget.formState.model.details.productionMode],
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
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
              PopupMenuButton<EnumModel>(
                onCanceled: () {},
                onSelected: (val) {
                  print(val);
                  setState(() {});
                },
                itemBuilder: (BuildContext context) => FactoryQualityLevelsEnum
                    .map((saleMarket) => PopupMenuItem<EnumModel>(
                          enabled: false,
                          value: saleMarket,
                          child: StatefulBuilder(builder: (context, state) {
                            return CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(saleMarket.name),
                              onChanged: (v) {
                                setState(() {
                                  state(() {
                                    if (v) {
                                      widget.formState.model.details.salesMarket
                                          .add(saleMarket.code);
                                    } else {
                                      widget.formState.model.details.salesMarket
                                          .remove(saleMarket.code);
                                    }
                                  });
                                });
                              },
                              activeColor: Colors.orange,
                              value: widget.formState.model.details.salesMarket
                                  .contains(saleMarket.code),
                            );
                          }),
                        )).toList(),
                child: Text(
//                            '选择质量等级',
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
                  text: '加工数量',
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
                      if (value.contains('.')) {
                        int index = value.indexOf('.');
                        if (value.length > index + 3) {
                          setState(() {
                            super.maxExpectedPriceController.text =
                                value.substring(0, index + 3);
                          });
                        }
                      }
                      widget.formState.model.details.maxExpectedPrice =
                          ClassHandleUtil.removeSymbolRMBToDouble(
                              super.maxExpectedPriceController.text);
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
                text: '品        类',
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
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: '标        题',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: ' * ',
                style: TextStyle(fontSize: 16, color: Colors.red),
              )
            ]),
          ),
          Expanded(
            flex: 1,
            child: TextFieldBorderComponent(
              padding: EdgeInsets.all(0),
              hideDivider: true,
              isRequired: true,
              textAlign: TextAlign.left,
              hintText: '填写',
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

  Widget _buildPublishWay() {
    return Expanded(
      flex: 3,
      child: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          childAspectRatio: 5,
          padding: EdgeInsets.zero,
          children: [
            AuthorizationDector(
              authorizations: [Authorization.REQUIREMENT_ORDER_RECOMMENDED],
              show: false,
              message: '需要邀请报价权限',
              child: Opacity(
                opacity:
                    widget.formState.model.details.publishingMode == 'PUBLIC'
                        ? 1
                        : 0,
                child: GestureDetector(
                  onTap: () async {
                    dynamic result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                RequirementOrderSelectPublishTargetForm(
                                  formState: widget.formState,
                                )));
                    if (result != null) {
                      setState(() {
                        _factoryUids = result;
                      });
                    }
                  },
                  child: Row(
                    children: <Widget>[
                      RichText(
                        text:
                            TextSpan(style: TextStyle(fontSize: 13), children: [
                          TextSpan(
                            text: '已邀请报价',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: '${_factoryUids?.length?.toString() ?? 0}',
                            style: TextStyle(color: Colors.red),
                          ),
                        ]),
                      ),
                      Container(
                          width: 10,
                          child: Icon(
                            Icons.chevron_right,
                            size: 20,
                            textDirection: TextDirection.ltr,
                          )),
                    ],
                  ),
                ),
              ),
            ),
            AuthorizationDector(
              authorizations: [Authorization.REQUIREMENT_ORDER_RECOMMENDED],
              show: false,
              message: '需要邀请报价权限',
              child: Opacity(
                opacity:
                    widget.formState.model.details.publishingMode == 'PRIVATE'
                        ? 1
                        : 0,
                child: GestureDetector(
                  onTap: () async {
                    dynamic result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                RequirementOrderSelectPublishTargetForm(
                                  formState: widget.formState,
                                )));
                    if (result != null) {
                      setState(() {
                        _factoryUids = result;
                      });
                    }
                  },
                  child: Row(
                    children: <Widget>[
                      RichText(
                        text:
                            TextSpan(style: TextStyle(fontSize: 13), children: [
                          TextSpan(
                            text: '已指定工厂',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: '${_factoryUids?.length?.toString() ?? 0}',
                            style: TextStyle(color: Colors.red),
                          ),
                        ]),
                      ),
                      Container(
                          width: 10,
                          child: Icon(
                            Icons.chevron_right,
                            size: 20,
                            textDirection: TextDirection.ltr,
                          )),
                    ],
                  ),
                ),
              ),
            )
          ]),
    );
  }

  /// 发布
  void onPublish() async {
    if (widget.formState.model.details.productName == null) {
      ShowDialogUtil.showValidateMsg(context, '请填写标题');
      return;
    }
    if (widget.formState.model.details.maxExpectedPrice == null) {
      ShowDialogUtil.showValidateMsg(context, '请填写期望价格');
      return;
    }
    if (widget.formState.model.details.expectedMachiningQuantity == null) {
      ShowDialogUtil.showValidateMsg(context, '请填写加工数量');
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
    if (widget.formState.model.details.effectiveDays == -1) {
      //后台的'长期有效'值是null
      widget.formState.model.details.effectiveDays = null;
    }
    ShowDialogUtil.showChoseDiglog(context, '是否确认发布', () {
      //埋点>>>需求发布2填写并发布
      UmengPlugin.onEvent('requirement_publish_finsh');

    // BotToast.showCustomText(
    //     onlyOne: true,
    //     duration: null,
    //     clickClose: false,
    //     crossPage: false,
    //     backgroundColor: Colors.black38,
    //     toastBuilder: (cancelFunc) =>
    //         AlertDialog(
    //           content: Container(
    //             height: 100,
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: <Widget>[
    //                 Container(
    //                   margin: EdgeInsets.only(bottom: 10),
    //                   child: Text('是否确认发布需求？'),
    //                 ),
    //                 Row(
    //                   children: [
    //                     Expanded(
    //                         child: FlatButton(
    //                             onPressed: cancelFunc, child: Text('否'))),
    //                     Expanded(
    //                         child: FlatButton(
    //                             onPressed: () => _onPublish(),
    //                             child: Text('是',
    //                                 style: TextStyle(
    //                                   color: Colors.blue,
    //                                 ))))
    //                   ],
    //                 )
    //               ],
    //             ),
    //           ),
    //         ));


      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return RequestDataLoading(
              requestCallBack: RequirementOrderRepository()
                  .publishNewRequirement(widget.formState.model, null, false,
                      factories: _factoryUids.join(',')),
              outsideDismiss: false,
              loadingText: '正在保存。。。',
              entrance: '',
            );
          }).then((code) async {
        if (code != null && code != '') {
          //埋点>>>需求发布成功
          UmengPlugin.onEvent('requirement_publish_success');
          widget.formState.model.code = code;
          //根据code查询明
          RequirementOrderModel model = await RequirementOrderRepository()
              .getRequirementOrderDetail(code);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => PublishRequirementSuccessDialog(
                  model: model,
                ),
              ),
              ModalRoute.withName('/'));
        }
      });
    });
//      String code = await RequirementOrderRepository().publishNewRequirement(widget.formState.model,null,false);
//      if (code != null && code != '') {
//        widget.formState.model.code = code;
//        //根据code查询明
//        RequirementOrderModel model = await RequirementOrderRepository()
//            .getRequirementOrderDetail(code);
//        Navigator.of(context).pushAndRemoveUntil(
//            MaterialPageRoute(
//              builder: (context) => PublishRequirementSuccessDialog(
//                model: model,
//              ),
//            ),
//            ModalRoute.withName('/'));
//      }
//      String code =
//      await RequirementOrderRepository().updateRequirement(widget.order);
//      if (code != null) {
//        Navigator.of(context).pushAndRemoveUntil(
//            MaterialPageRoute(
//              builder: (context) => RequirementOrderDetailPage(code),
//            ),
//            ModalRoute.withName('/'));
//      } else {
//        showDialog<void>(
//          context: context,
//          builder: (context) {
//            return AlertDialog(
//              title: Text('更新失败'),
//            );
//          },
//        );
//      }
  }

  
    void _onPublish(){

    }


  //格式选中的地区（多选）
  String formatAreaSelectsText(List<DistrictModel> selects, int count) {
    String text = '';
    if (selects == null || selects.length == 0) {
      return '选择要求地区';
    }

    // if (widget.formState.model.details.productiveOrientations.indexWhere(
    //       (region) => region.isocode == Constants.WHOLE_COUNTRY_ISOCODE,
    //     ) >
    //     -1) {
    //   return '全国';
    // }

    // for (int i = 0; i < selects.length; i++) {
    //   if (i > count - 1) {
    //     text += '...';
    //     break;
    //   }

    //   if (i == selects.length - 1) {
    //     text += selects[i].name;
    //   } else {
    //     text += selects[i].name + '、';
    //   }
    // }

    text = selects.map((e) => e.name).join('、');

    return text;
  }

  void _onPopulationSelect() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleEnumSelectV2Page(
          items: [
            PopulationScale.N05,
            PopulationScale.N06,
            PopulationScale.N07,
            PopulationScale.N02,
            PopulationScale.N03,
            PopulationScale.N04
          ],
          localizedMap: PopulationScaleLocalizedMap,
          title: '选择工厂规模',
          value: widget.formState.model.details.populationScale,
          count: 3,
        );
      },
    ).then((result) {
      if (result != null) {
        setState(() {
          if (result == false) {
            widget.formState.model.details.populationScale = null;
          } else {
            widget.formState.model.details.populationScale = result;
          }
        });
      }
    });
  }

  void _onProductionModeSelect() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleEnumSelectV2Page(
          items: ProductionMode.values,
          localizedMap: ProductionModeLocalizedMap,
          title: '选择生产模式',
          value: widget.formState.model.details.productionMode,
          count: 3,
        );
      },
    ).then((result) {
      if (result != null) {
        setState(() {
          if (result == false) {
            widget.formState.model.details.productionMode = null;
          } else {
            widget.formState.model.details.productionMode = result;
          }
        });
      }
    });
  }
}
