import 'package:b2b_commerce/src/business/orders/form/contact_way_field.dart';
import 'package:b2b_commerce/src/business/orders/form/expected_delivery_date_field.dart';
import 'package:b2b_commerce/src/business/orders/form/pictures_field.dart';
import 'package:b2b_commerce/src/business/orders/requirement/requirement_order_select_publish_target_form.dart';
import 'package:b2b_commerce/src/home/requirement/requirement_publish_success.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'RequirementFormMixins.dart';

class RequirementOrderSecondForm extends StatefulWidget {
  RequirementOrderSecondForm({
    this.formState,
  });

  final RequirementOrderFormState formState;

  _RequirementOrderSecondFormState createState() =>
      _RequirementOrderSecondFormState();
}

class _RequirementOrderSecondFormState extends State<RequirementOrderSecondForm>
    with RequirementFormMixin {
  GlobalKey _scaffoldKey = GlobalKey();
  List<String> _factoryUids = [];

  @override
  void initState() {
    if (widget.formState.factoryUid != null) {
      _factoryUids.add(widget.formState.factoryUid);
    }
    super.initForm();
    super.initCreate(widget.formState.model);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('需求发布(2/2)'),
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
              padding: const EdgeInsets.all(15.0),
              child: Text(
                  '已选：'
                  '${widget.formState.model.details.majorCategory.name}     '
                  '${widget.formState.model.details.category.parent != null ? widget.formState.model.details.category.parent.name + '-' : ''}'
                  '${widget.formState.model.details.category.name}',
                  style: TextStyle(color: Colors.grey, fontSize: 16)),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: '标       题',
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
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
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
                  Expanded(
                    flex: 2,
                    child: TextFieldBorderComponent(
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
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                      ],
                      inputType: TextInputType.number,
                      hintText: '填写',
                      controller: super.expectedMachiningQuantityController,
                      focusNode: super.expectedMachiningQuantityNode,
                      onChanged: (v) {
                        widget.formState.model.details
                            .expectedMachiningQuantity =
                            ClassHandleUtil.transInt(
                                super.expectedMachiningQuantityController.text);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: ExpectedDeliveryDateField(widget.formState.model),
            ),
            Container(
              color: Colors.white,
              child: ContactWayField(widget.formState.model),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: '销售市场',
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
                        itemBuilder: (BuildContext context) =>
                            SalesMarketsEnum.map(
                                    (saleMarket) =>
                                    PopupMenuItem<EnumModel>(
                                      enabled: false,
                                      value: saleMarket,
                                      child: StatefulBuilder(
                                          builder: (context, state) {
                                        return CheckboxListTile(
                                          controlAffinity:
                                          ListTileControlAffinity.leading,
                                          title: Text(saleMarket.name),
                                          onChanged: (v) {
                                            setState(() {
                                              state(() {
                                                if (v) {
                                                  widget.formState.model.details
                                                      .salesMarket
                                                      .add(saleMarket.code);
                                                } else {
                                                  widget.formState.model.details
                                                      .salesMarket
                                                      .remove(saleMarket.code);
                                                }
                                              });
                                            });
                                          },
                                          activeColor: Colors.orange,
                                          value: widget.formState.model.details
                                              .salesMarket
                                              .contains(saleMarket.code),
                                        );
                                      }),
                                    )).toList(),
                        child: Text(
//                            '选择销售市场',
                          formatEnumSelectsText(
                              widget.formState.model.details.salesMarket,
                              SalesMarketsEnum,
                              2,
                              customText: '选择销售市场'),
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                ],
              ),
            ),
            Container(
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
                                    child:
                                    Text(MachiningTypeLocalizedMap[type])),
                              ),
                              backgroundColor: Colors.grey[100],
                              selectedColor: Color.fromRGBO(255, 214, 12, 1),
                          selected: widget
                              .formState.model.details.machiningType ==
                              type,
                              onSelected: (bool selected) {
                                setState(() {
                                  widget.formState.model.details.machiningType =
                                      type;
                                });
                              }))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            Container(
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
                            selected:
                            widget.formState.model.details.proofingNeeded,
                            onSelected: (bool selected) {
                              setState(() {
                                widget.formState.model.details.proofingNeeded =
                                true;
                              });
                            },
                          ),
//                          GestureDetector(
//                            onTap: (){
//                              setState(() {
//                                widget.formState?.model?.details?.proofingNeeded = true;
//                              });
//                            },
//                            child: Container(
//                              width: 80,
//                              height: 30,
//                              decoration: ShapeDecoration(
//                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),),
//                                color: widget.formState?.model?.details?.proofingNeeded ?? false ? Color.fromRGBO(255, 214, 12, 1) : Colors.grey[100],
//                              ),
//                              child: Center(child: Text('是')),
//                            ),
//                          ),
//                          GestureDetector(
//                            onTap: (){
//                              setState(() {
//                                widget.formState?.model?.details?.proofingNeeded = false;
//                              });
//                            },
//                            child: Container(
//                              width: 80,
//                              height: 30,
//                              decoration: ShapeDecoration(
//                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),),
//                                color: widget.formState?.model?.details?.proofingNeeded == null ? true : !widget.formState.model.details.proofingNeeded ? Color.fromRGBO(255, 214, 12, 1) : Colors.grey[100],
//                              ),
//                              child: Center(child: Text('否')),
//                            ),
//                          ),
                          ChoiceChip(
                            label: Container(
                              height: 20,
                              width: 60,
                              child: Center(child: Text('否')),
                            ),
                            backgroundColor: Colors.grey[100],
                            selectedColor: Color.fromRGBO(255, 214, 12, 1),
                            selected:
                            !widget.formState.model.details.proofingNeeded,
                            onSelected: (bool selected) {
                              setState(() {
                                widget.formState.model.details.proofingNeeded =
                                false;
                              });
                            },
                          ),
                        ]),
                  ),
                ],
              ),
            ),
            Container(
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
                            selected:
                            widget.formState.model.details.invoiceNeeded,
                            onSelected: (bool selected) {
                              setState(() {
                                widget.formState.model.details.invoiceNeeded =
                                true;
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
                            selected:
                            !widget.formState.model.details.invoiceNeeded,
                            onSelected: (bool selected) {
                              setState(() {
                                widget.formState.model.details.invoiceNeeded =
                                false;
                              });
                            },
                          ),
                        ]),
                  ),
                ],
              ),
            ),
            Container(
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
                            child: Text(
                              '发布方式',
                              style: TextStyle(fontSize: 16),
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
                            children: List.generate(PublishingModesEnum.length,
                                    (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        widget.formState.model.details
                                            .publishingMode =
                                            PublishingModesEnum[index].code;
                                      });
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Radio(
                                            value: PublishingModesEnum[index]
                                                .code,
                                            groupValue: widget.formState.model
                                                .details.publishingMode,
                                            onChanged: (v) {
                                              setState(() {
                                                widget.formState.model.details
                                                    .publishingMode =
                                                    PublishingModesEnum[index]
                                                        .code;
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
                                                fontSize: 16,
                                                color: Colors.red),
                                          ),
                                          TextSpan(
                                              text:
                                              '可邀请工厂进行报价，需求发布后所有工厂都能看见，也可以对需求进行报价。',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black)),
                                          TextSpan(text: '\n\n'),
                                          TextSpan(
                                            text: '私密发布：',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.red),
                                          ),
                                          TextSpan(
                                              text:
                                              '需求发布后只能被已选择的工厂看见，且只有被选择的工厂才能进行报价。',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black)),
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
                        Expanded(
                          flex: 3,
                          child: GridView.count(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              childAspectRatio: 5,
                              padding: EdgeInsets.zero,
                              children: [
                                Opacity(
                                  opacity: widget.formState.model.details
                                      .publishingMode ==
                                      'PUBLIC'
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
                                        _factoryUids = result;
                                      }
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        RichText(
                                          text: TextSpan(
                                              style: TextStyle(fontSize: 13),
                                              children: [
                                                TextSpan(
                                                  text: '已邀请报价',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                TextSpan(
                                                  text:
                                                  '${_factoryUids?.length
                                                      ?.toString() ?? 0}',
                                                  style: TextStyle(
                                                      color: Colors.red),
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
                                Opacity(
                                  opacity: widget.formState.model.details
                                      .publishingMode ==
                                      'PRIVATE'
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
                                        _factoryUids = result;
                                      }
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        RichText(
                                          text: TextSpan(
                                              style: TextStyle(fontSize: 13),
                                              children: [
                                                TextSpan(
                                                  text: '已指定工厂',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                TextSpan(
                                                  text:
                                                  '${_factoryUids?.length
                                                      ?.toString() ?? 0}',
                                                  style: TextStyle(
                                                      color: Colors.red),
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
                              ]),
                        ),
                      ],
                    ),
                  ],
                )),
            Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text(
                        '有效期限',
                        style: TextStyle(fontSize: 16),
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
                        children:
                            List.generate(EffectiveDaysEnum.length, (index) {
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
                                        widget.formState.model.details
                                            .effectiveDays =
                                            int.parse(
                                                EffectiveDaysEnum[index].code);
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
                )),
            Container(
              color: Colors.white,
              child: PicturesField(
                model: widget.formState.model,
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(children: <Widget>[
//                Align(
//                  alignment: Alignment.centerLeft,
//                  child: Text(
//                    "订单备注",
//                    style: TextStyle(
//                      fontSize: 16,
//                    ),
//                  ),
//                ),
                Container(
                  color: Colors.white,
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
            ),
          ],
        ),
      ),
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
      ShowDialogUtil.showValidateMsg(context, '请选择销售市场');
      return;
    }
    if (widget.formState.model.details.effectiveDays == -1) {
      //后台的'长期有效'值是null
      widget.formState.model.details.effectiveDays = null;
    }
    ShowDialogUtil.showChoseDiglog(context, '是否确认发布', () {
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
}
