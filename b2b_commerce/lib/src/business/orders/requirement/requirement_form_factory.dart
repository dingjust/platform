import 'dart:ui';

import 'package:b2b_commerce/src/_shared/widgets/address_cascader.dart';
import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';
import 'package:b2b_commerce/src/_shared/widgets/quantity_select.dart';
import 'package:b2b_commerce/src/business/orders/form/pictures_field.dart';
import 'package:b2b_commerce/src/business/orders/widget/form_divider.dart';
import 'package:b2b_commerce/src/business/orders/widget/form_row.dart';
import 'package:b2b_commerce/src/business/services/text_field_border_component_V2.dart';
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

class RequirementFormFactory extends StatefulWidget {
  RequirementFormFactory({
    this.formState,
  });

  final RequirementOrderFormStateV2 formState;

  _RequirementFormFactoryState createState() => _RequirementFormFactoryState();
}

class _RequirementFormFactoryState extends State<RequirementFormFactory>
    with RequirementFormMixin {
  GlobalKey _scaffoldKey = GlobalKey();

  bool isPhoneSame = false;

  final TextStyle titleTextStyle =
      const TextStyle(color: Color(0xff000000), fontSize: 14);

  @override
  void initState() {
    //埋点>>>需求发布页面进入
    // UmengPlugin.onEvent('requirement_publish_page');

    super.initForm();
    super.initCreate(widget.formState.model);
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) => getLocation());

    widget.formState.model.orderType = RequirementOrderType.FINDING_FACTORY;

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
        appBar: AppBarFactory.buildDefaultAppBar('需求发布-找工厂'),
        body: Container(
          color: Color(0xFFF7F7F7),
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: ListView(
            children: <Widget>[
              _buildCard1(),
              _buildCard2(),
              _buildCard3(),
              _buildCard4(),
              _buildCard5(),
              _buildCard6(),
              _buildCard7(),
              _buildCard8(),
              _buildSubBtn()
            ],
          ),
        ),
      ),
    );
  }

  ///有效期限
  Widget _buildEffectiveDays() {
    return Wrap(
      spacing: 20,
      alignment: WrapAlignment.end,
      children: EffectiveDaysEnum.map((val) => Container(
            width: val.name.length > 3 ? 80 : 56,
            child: ChoiceChip(
                label: Container(
                  child: Center(
                      child: Text('${val.name}',
                          style: TextStyle(
                              color: Color(0xff000000), fontSize: 12))),
                ),
                backgroundColor: Color(0xffE7E7E7),
                selectedColor: Color(0xFFFED800),
                selected:
                    widget.formState.model.details.effectiveDays.toString() ==
                        val.code,
                onSelected: (bool selected) {
                  setState(() {
                    widget.formState.model.details.effectiveDays =
                        int.parse(val.code);
                  });
                }),
          )).toList(),
    );
  }

  Widget _buildProductiveOrientations() {
    return FormSelectRow(
      title: '要求地区',
      val:
          '${formatAreaSelectsText(widget.formState.model.details.productiveDistricts, 3)}',
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => AddressCascaderPage(
                      selected: widget
                              .formState.model.details?.productiveDistricts
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
    );
  }

  Widget _buildInvoiceNeeded() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [true, false]
          .map((val) => Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: ChoiceChip(
                    label: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Center(
                          child: Text(val ? '是' : '否',
                              style: TextStyle(
                                  color: Color(0xff000000), fontSize: 12))),
                    ),
                    backgroundColor: Color(0xffE7E7E7),
                    selectedColor: Color(0xFFFED800),
                    selected:
                        widget.formState.model.details.invoiceNeeded == val,
                    onSelected: (bool selected) {
                      setState(() {
                        widget.formState.model.details.invoiceNeeded = val;
                      });
                    }),
              ))
          .toList(),
    );
  }

  Widget _buildProofingNeeded() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [true, false]
            .map((val) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: ChoiceChip(
                      label: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Center(
                            child: Text(val ? '是' : '否',
                                style: TextStyle(
                                    color: Color(0xff000000), fontSize: 12))),
                      ),
                      backgroundColor: Color(0xffE7E7E7),
                      selectedColor: Color(0xFFFED800),
                      selected:
                          widget.formState.model.details.proofingNeeded == val,
                      onSelected: (bool selected) {
                        setState(() {
                          widget.formState.model.details.proofingNeeded = val;
                        });
                      }),
                ))
            .toList());
  }

  Widget _buildMachiningType() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: MachiningType.values
          .map((type) => Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: ChoiceChip(
                    label: Container(
                      child: Center(
                          child: Text(MachiningTypeLocalizedMap[type],
                              style: TextStyle(
                                  color: Color(0xff000000), fontSize: 12))),
                    ),
                    backgroundColor: Color(0xffE7E7E7),
                    selectedColor: Color(0xFFFED800),
                    selected:
                        widget.formState.model.details.machiningType == type,
                    onSelected: (bool selected) {
                      setState(() {
                        widget.formState.model.details.machiningType = type;
                      });
                    }),
              ))
          .toList(),
    );
  }

  ///期望价格
  Widget _buildExceptedPrice() {
    return Row(
      children: [
        Expanded(
          child: TextFieldBorderComponentV2(
            padding: EdgeInsets.all(0),
            hideDivider: true,
            isRequired: true,
            textAlign: TextAlign.left,
            prefix: '￥',
            inputFormatters: [
              DecimalInputFormat(),
            ],
            hintText: '请输入期望价格',
            controller: super.maxExpectedPriceController,
            focusNode: super.maxExpectedPriceFocusNode,
            enabled: widget.formState.model.details.maxExpectedPrice != -1,
            style: TextStyle(color: Color(0xFF222222), fontSize: 14),
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
        Container(
          margin: EdgeInsets.only(right: 4),
          child: B2BCheckbox(
            value: widget.formState.model.details.maxExpectedPrice == -1,
            onChanged: (value) {
              setState(() {
                if (widget.formState.model.details.maxExpectedPrice != -1) {
                  widget.formState.model.details.maxExpectedPrice = -1;
                } else {
                  widget.formState.model.details.maxExpectedPrice =
                      ClassHandleUtil.removeSymbolRMBToDouble(
                          super.maxExpectedPriceController.text);
                }
              });
            },
          ),
        ),
        Text('面议', style: TextStyle(fontSize: 15, color: Color(0xFF222222)))
      ],
    );
  }

  Widget _buildCard1() {
    return Container(
      margin: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          _buildTitleName(),
          FormDivider(),
          _buildRemarks(),
        ],
      ),
    );
  }

  Widget _buildTitleName() {
    return FormRow(
      title: '标题',
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: TextFieldBorderComponentV2(
        padding: EdgeInsets.all(0),
        hideDivider: true,
        isRequired: true,
        textAlign: TextAlign.left,
        hintText: '标题',
        style: TextStyle(color: Color(0xFF222222), fontSize: 14),
        controller: super.productNameController,
        focusNode: super.productNameFocusNode,
        onChanged: (v) {
          widget.formState.model.details.productName =
              super.productNameController.text;
        },
      ),
    );
  }

  Container _buildRemarks() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 14),
      child:
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Container(
          width: 80,
          padding: EdgeInsets.only(top: 15),
          child: Text(
            '需求描述',
            style: titleTextStyle,
          ),
        ),
        Expanded(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextFieldComponent(
            padding: EdgeInsets.symmetric(vertical: 0),
            dividerPadding: EdgeInsets.only(),
            focusNode: remarksFocusNode,
            hintText: '需求描述...',
            style: TextStyle(color: Color(0xFF222222), fontSize: 14),
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
        ))
      ]),
    );
  }

  Widget _buildCard2() {
    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              '添加图片',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 8),
            child: Text(
              '补充图片，可令工厂更快了解需求',
              style: TextStyle(color: Color(0xFF999999), fontSize: 12),
            ),
          ),
          PicturesField(
            model: widget.formState.model,
            description: '（补充图片可令工厂更快了解需求）',
          ),
        ],
      ),
    );
  }

  Widget _buildCard3() {
    DateTime now = DateTime.now();
    now = now.add(Duration(days: 1));
    return Container(
      margin: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormSelectRow(
              title: '面料类型',
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              onTap: _onSelectMajorCategory,
              val: widget.formState.model.details.majorCategory?.name),
          FormDivider(),
          FormSelectRow(
              title: '商品品类',
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              onTap: _onselectCategory,
              val: widget.formState.model.details.category != null
                  ? '${widget?.formState?.model?.details?.category?.parent
                  ?.name}-${widget.formState.model.details.category?.name}'
                  : null),
          FormDivider(),
          FormSelectRow(
              title: '质量等级',
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              onTap: _onselectMarket,
              val: marketStr()),
          FormDivider(),
          FormSelectRow(
            title: '交货日期',
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            val: DateFormatUtil.formatYMD(
                widget.formState.model.details?.expectedDeliveryDate),
            onTap: () {
              showDatePicker(
                context: context,
                initialDate:
                widget.formState.model.details?.expectedDeliveryDate ?? now,
                firstDate: DateTime(2019),
                lastDate: DateTime(2999),
              ).then((value) {
                setState(() {
                  if (value != null) {
                    widget.formState.model.details?.expectedDeliveryDate =
                        value;
                  }
                });
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCard4() {
    return Container(
      margin: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        FormRow(
            title: '期望价格',
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: _buildExceptedPrice()),
        FormDivider(),
        FormRow(
          title: '加工数量',
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: TextFieldBorderComponentV2(
            padding: EdgeInsets.all(0),
            hideDivider: true,
            isRequired: true,
            textAlign: TextAlign.left,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            inputType: TextInputType.number,
            hintText: '请输入加工数量',
            style: TextStyle(color: Color(0xFF222222), fontSize: 14),
            controller: super.expectedMachiningQuantityController,
            focusNode: super.expectedMachiningQuantityNode,
            onChanged: (v) {
              widget.formState.model.details.expectedMachiningQuantity =
                  ClassHandleUtil.transInt(
                      super.expectedMachiningQuantityController.text);
            },
          ),
        )
      ]),
    );
  }

  Widget _buildCard5() {
    return Container(
      margin: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        FormRow(
            title: '加工类型',
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: _buildMachiningType()),
        FormDivider(),
        FormRow(
          title: '是否打样',
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: _buildProofingNeeded(),
        ),
        FormDivider(),
        FormRow(
          title: '订单尺码',
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: _buildSizeType(),
        ),
        FormDivider(),
        FormRow(
          title: '订单颜色',
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: _buildColorType(),
        ),
        FormDivider(),
        FormRow(
          title: '是否开票',
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: _buildInvoiceNeeded(),
        ),
        FormDivider(),
        FormRow(
          title: '有效期限',
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Padding(
            padding: EdgeInsets.only(right: 10),
            child: _buildEffectiveDays(),
          ),
        ),
      ]),
    );
  }

  Widget _buildCard6() {
    return Container(
      margin: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildLocation(),
        FormDivider(),
        _buildProductiveOrientations(),
        FormDivider(),
        _buildPayInfo()
      ]),
    );
  }

  Widget _buildCard7() {
    return Container(
      margin: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        FormRow(
          title: '联系电话',
          padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
          child: TextFieldBorderComponentV2(
            padding: EdgeInsets.all(0),
            hideDivider: true,
            isRequired: true,
            textAlign: TextAlign.left,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            inputType: TextInputType.number,
            hintText: '输入手机号',
            style: TextStyle(color: Color(0xFF222222), fontSize: 14),
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
        FormDivider(),
        Container(
          padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Text(
            '钉单将通过隐私电话服务保障您的信息安全',
            style: TextStyle(color: Color(0xFF999999), fontSize: 12),
          ),
        )
      ]),
    );
  }

  Widget _buildCard8() {
    return Container(
      margin: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        FormRow(
            title: '微信号',
            padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
            child: _buildWechat()),
        FormDivider(),
        Container(
          padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Text(
            '平台客服可以联系你匹配工厂',
            style: TextStyle(color: Color(0xFF999999), fontSize: 12),
          ),
        )
      ]),
    );
  }

  Widget _buildPayInfo() {
    return FormSelectRow(
      title: '支付条件',
      val: getPayStr(),
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
            builder: (context) =>
                RequirementPayForm(
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
    );
  }

  Widget _buildLocation() {
    return FormSelectRow(
      title: '所在地区',
      val: '${widget.formState.model.details?.address ?? ''}',
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      onTap: () async {
        Tip tip = await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AmapSearchPage()));
        List<String> locationArray = tip.location.split(',');
        //设置定位信息
        setState(() {
          widget.formState.model.details
            ..latitude = double.parse(locationArray[1])
            ..longitude = double.parse(locationArray[0])
            ..address = tip.address;
        });
      },
    );
  }

  Widget _buildWechat() {
    return Row(
      children: [
        Expanded(
          child: TextFieldBorderComponentV2(
            padding: EdgeInsets.all(0),
            hideDivider: true,
            isRequired: true,
            textAlign: TextAlign.left,
            hintText: '输入微信号',
            style: TextStyle(color: Color(0xFF222222), fontSize: 14),
            controller: super.wechatController,
            focusNode: super.wechatFocusNode,
            onChanged: (v) {
              widget.formState.model.details.contactWeChatNo = v;
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 4),
          child: B2BCheckbox(
            value: isPhoneSame,
            onChanged: (value) {
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
        ),
        Text('与手机同号', style: TextStyle(fontSize: 14, color: Color(0xFF222222)))
      ],
    );
  }

  Widget _buildSubBtn() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 18),

      // height: 50,
      child: FlatButton(
          color: Color.fromRGBO(255, 214, 12, 1),
          padding: EdgeInsets.symmetric(vertical: 13),
          child: Text(
            '确认发布',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 16,
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
  Widget _buildSizeType() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [OrderSizeType.FREE_SIZE, OrderSizeType.MULTIPLE_SIZE]
          .map((type) =>
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: ChoiceChip(
                label: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Center(
                      child: Text('${OrderSizeTypeLocalizedMap[type]}',
                          style: TextStyle(
                              color: Color(0xff000000), fontSize: 12))),
                ),
                backgroundColor: Color(0xffE7E7E7),
                selectedColor: Color(0xFFFED800),
                selected: widget.formState.model.details.sizeType == type,
                onSelected: (bool selected) {
                  setState(() {
                    widget.formState.model.details.sizeType = type;
                  });
                }),
          ))
          .toList(),
    );
  }

  ///订单颜色类型
  Widget _buildColorType() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [OrderColorType.SINGLE_COLOR, OrderColorType.MULTIPLE_COLOR]
          .map((type) =>
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: ChoiceChip(
                label: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Center(
                      child: Text('${OrderColorTypeLocalizedMap[type]}',
                          style: TextStyle(
                              color: Color(0xff000000), fontSize: 12))),
                ),
                backgroundColor: Color(0xffE7E7E7),
                selectedColor: Color(0xFFFED800),
                selected: widget.formState.model.details.colorType == type,
                onSelected: (bool selected) {
                  setState(() {
                    widget.formState.model.details.colorType = type;
                  });
                }),
          ))
          .toList(),
    );
  }

  String getPayStr() {
    if (widget.formState.model.details.payPlan == null) {
      return '选择';
    } else {
      return PayPlanTypeLocalizedMap[
      widget.formState.model.details.payPlan.payPlanType];
    }
  }

  ///选择面料类型
  void _onSelectMajorCategory() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQueryData
                .fromWindow(window)
                .size
                .height / 2,
            child: Consumer(
              builder: (context, MajorCategoryState categoryState, _) =>
                  FutureBuilder(
                    future: categoryState.getMajorCategories(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<CategoryModel>> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return SingleMajorCategorySelect(
                          categories: snapshot.data,
                          categorySelect:
                          widget.formState.model.details.majorCategory,
                          onItemTap: (categoryModel) {
                            setState(() {
                              widget.formState.model.details.majorCategory =
                                  categoryModel;
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
  }

  ///选择商品类型
  void _onselectCategory() {
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
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return SingleCategorySelect(
                        categories: snapshot.data,
                        categorySelect: widget.formState.model.details.category,
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
  }

  ///选择质量等级
  void _onselectMarket() {
    Navigator.of(context)
        .push(MaterialPageRoute(
        builder: (context) =>
            SalesMarketSelectPage(
              values: widget.formState.model.details.salesMarket,
                )))
        .then((values) {
      if (values != null) {
        setState(() {
          widget.formState.model.details.salesMarket = values;
        });
      }
    });
  }

  // void getLocation() async {
  //   AmapState state = Provider.of<AmapState>(context, listen: false);

  //   Widget _dialog = CustomizeDialog(
  //     dialogType: DialogType.CONFIRM_DIALOG,
  //     contentText2: '钉单正在请求定位权限,请设置',
  //     isNeedConfirmButton: true,
  //     isNeedCancelButton: true,
  //     confirmButtonText: '去设置',
  //     cancelButtonText: '选择城市',
  //     dialogHeight: 180,
  //     confirmAction: () {
  //       state.openAppSetting().then((val) {
  //         Navigator.of(context).pop(val);
  //       });
  //     },
  //     cancelAction: () async {
  //       Navigator.of(context).pop();
  //       Tip tip = await Navigator.of(context)
  //           .push(MaterialPageRoute(builder: (context) => AmapSearchPage()));
  //       List<String> locationArray = tip.location.split(',');
  //       //设置定位信息
  //       state.setAMapLocation(
  //           // aOIName: tip.district.,
  //           longitude: double.parse(locationArray[0]),
  //           latitude: double.parse(locationArray[1]));
  //     },
  //   );

  //   AMapLocation aMapLocation = Provider.of<AmapState>(context, listen: false)
  //       .getAMapLocation(context: context, openDialog: _dialog);

  //   setState(() {
  //     widget.formState.model.details
  //       ..latitude = aMapLocation.latitude
  //       ..longitude = aMapLocation.longitude
  //       ..address = aMapLocation.formattedAddress
  //       ..provinceStr = aMapLocation.province
  //       ..cityStr = aMapLocation.city
  //       ..districtStr = aMapLocation.district;
  //   });
  // }

  ///质量等级值
  String marketStr() {
    return formatEnumSelectsText(
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
        customText: '');
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

    // if (widget.formState.model.details.payPlan == null ||
    //     widget.formState.model.details.payPlan?.payPlanType == null) {
    //   ShowDialogUtil.showValidateMsg(context, '请选择支付条件');
    //   throw Exception('请选择支付条件');
    // }

    if (widget.formState.model.details.category == null) {
      ShowDialogUtil.showValidateMsg(context, '请选择商品品类');
      throw Exception('请选择商品品类');
    }

    if (widget.formState.model.details.majorCategory == null) {
      ShowDialogUtil.showValidateMsg(context, '请选择面料类型');
      throw Exception('请选择面料类型');
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
        // UmengPlugin.onEvent('requirement_publish_success');
        //根据code查询明
        RequirementOrderModel model = await RequirementOrderRepository()
            .getRequirementOrderDetail(response.msg);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) =>
                  PublishRequirementSuccessDialog(
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
