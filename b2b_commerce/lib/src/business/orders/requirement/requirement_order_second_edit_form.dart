import 'dart:async';

import 'package:b2b_commerce/src/business/orders/form/contact_way_field.dart';
import 'package:b2b_commerce/src/business/orders/form/expected_delivery_date_field.dart';
import 'package:b2b_commerce/src/business/orders/form/pictures_field.dart';
import 'package:b2b_commerce/src/business/orders/requirement/requirement_order_first_edit_form.dart';
import 'package:b2b_commerce/src/business/orders/requirement_order_detail.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'RequirementFormMixins.dart';

class RequirementOrderSecondEditForm extends StatefulWidget {
  RequirementOrderSecondEditForm({
    this.formState,
  });

  final RequirementOrderFormState formState;

  _RequirementOrderSecondEditFormState createState() =>
      _RequirementOrderSecondEditFormState();
}

class _RequirementOrderSecondEditFormState extends State<RequirementOrderSecondEditForm>
    with RequirementFormMixin {
  GlobalKey _scaffoldKey = GlobalKey();
  List<String> _factoryUids = [];
  double _fontSize = 16;

  @override
  void initState() {
    super.initForm();
    super.initCreate(widget.formState.editModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        ShowDialogUtil.showChoseDiglog(context, '正在编辑需求订单，是否退出', (){
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
          title: Text('需求编辑'),
          actions: <Widget>[
          ],
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          height: 50,
          child: RaisedButton(
              color: Color.fromRGBO(255, 214, 12, 1),
              child: Text(
                '保存',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              onPressed: () async {
                _onSave();
              }),
        ),
        body: Container(
          color: Colors.grey[100],
          child: ListView(
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RequirementOrderFirstEditForm(formState: widget.formState,)));
                },
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                      '已选：'
                      '${widget.formState.editModel.details.majorCategory?.name}     '
                      '${widget.formState.editModel.details.category?.parent != null ? widget.formState.editModel.details.category.parent.name + '-' : ''}'
                      '${widget.formState.editModel.details.category?.name}',
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                ),
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
                          widget.formState.editModel.details.productName =
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
                      child:  RichText(
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
                        hintText: '填写',
                        controller: super.maxExpectedPriceController,
                        focusNode: super.maxExpectedPriceFocusNode,
                        onChanged: (v) {
                          widget.formState.editModel.details.maxExpectedPrice =
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
                      child:  RichText(
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
                        hintText: '填写',
                        controller: super.expectedMachiningQuantityController,
                        focusNode: super.expectedMachiningQuantityNode,
                        onChanged: (v) {
                          widget.formState.editModel.details.expectedMachiningQuantity =
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
                child: ExpectedDeliveryDateField(widget.formState.editModel),
              ),
              Container(
                color: Colors.white,
                child: ContactWayField(widget.formState.editModel),
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
//                            setState(() {
//                              if (consignment?.carrierDetails !=
//                                  null) {
//                                consignment.carrierDetails = val;
//                              } else {
//                                consignment = ConsignmentModel();
//                                consignment.carrierDetails = val;
//                              }
//                            });
                          },
                          itemBuilder: (BuildContext context) =>
                              FactoryQualityLevelsEnum.map(
                                  (saleMarket) => PopupMenuItem<EnumModel>(
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
                                                    widget.formState.editModel.details
                                                        .salesMarket
                                                        .add(saleMarket.code);
                                                  } else {
                                                    widget.formState.editModel.details
                                                        .salesMarket
                                                        .remove(saleMarket.code);
                                                  }
                                                });
                                              });
                                            },
                                            activeColor: Colors.orange,
                                            value: widget.formState.editModel.details
                                                .salesMarket
                                                .contains(saleMarket.code),
                                          );
                                        }),
                                      )).toList(),
                          child: Text(
//                            '选择质量等级',
                            formatEnumSelectsText(
                                widget.formState.editModel.details.salesMarket,
                                FactoryQualityLevelsEnum,
                                2,
                                customText: '选择质量等级'),
                            style: TextStyle(color: Colors.grey,fontSize: 16),
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
                              child: Center(child: Text(MachiningTypeLocalizedMap[type])),
                            ),
                            backgroundColor: Colors.grey[100],
                            selectedColor: Color.fromRGBO(255, 214, 12, 1),
                            selected:
                            widget.formState.editModel.details.machiningType ==
                                type,
                            onSelected: (bool selected) {
                              setState(() {
                                widget.formState.editModel.details.machiningType =
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
                              selected: widget.formState.editModel.details.proofingNeeded,
                              onSelected: (bool selected) {
                                setState(() {
                                  widget.formState.editModel.details.proofingNeeded = true;
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
//                                color: widget.formState?.model?.details?.proofingNeeded == null ? true : !widget.formState.editModel.details.proofingNeeded ? Color.fromRGBO(255, 214, 12, 1) : Colors.grey[100],
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
                              selected: !widget.formState.editModel.details.proofingNeeded,
                              onSelected: (bool selected) {
                                setState(() {
                                  widget.formState.editModel.details.proofingNeeded = false;
                                });
                              },
                            ),
                          ]
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
                              selected: widget.formState.editModel.details.invoiceNeeded,
                              onSelected: (bool selected) {
                                setState(() {
                                  widget.formState.editModel.details.invoiceNeeded = true;
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
                              selected: !widget.formState.editModel.details.invoiceNeeded,
                              onSelected: (bool selected) {
                                setState(() {
                                  widget.formState.editModel.details.invoiceNeeded = false;
                                });
                              },
                            ),
                          ]
                      ),
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
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: '发布方式',
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
                              crossAxisCount: 2,
                              childAspectRatio: 5,
                              padding: EdgeInsets.zero,
                              children: List.generate(PublishingModesEnum.length,
                                      (index) {
                                    return GestureDetector(
                                      onTap: null,
                                      child: Row(
                                        children: <Widget>[
                                          Radio(
                                              value: PublishingModesEnum[index].code,
                                              groupValue: widget.formState.editModel
                                                  .details.publishingMode,
                                              onChanged: (v) {
//                                                setState(() {
//                                                  widget.formState.editModel.details
//                                                      .publishingMode =
//                                                      PublishingModesEnum[index].code;
//                                                });
                                              }),
                                          Expanded(
                                            child: Text(
                                              PublishingModesEnum[index].name,
                                              softWrap: false,
                                              overflow: TextOverflow.visible,
                                              style: TextStyle(color: Colors.grey),
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
                            margin: EdgeInsets.only(right: 40,),
                            child: GestureDetector(
                              onTap: (){
                                showDialog(context: (context),builder: (context){
                                  return MessageDialog(
                                    title: Text('如何选择发布方式',style: TextStyle(fontSize: 18),),
                                    message: RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text: '公开发布：',
                                          style: TextStyle(fontSize: 16, color: Colors.red),
                                        ),
                                        TextSpan(
                                            text: '可邀请工厂进行报价，需求发布后所有工厂都能看见，也可以对需求进行报价。',
                                            style: TextStyle(fontSize: 16,color: Colors.black)
                                        ),
                                        TextSpan(
                                            text: '\n\n'
                                        ),
                                        TextSpan(
                                          text: '私密发布：',
                                          style: TextStyle(fontSize: 16, color: Colors.red),
                                        ),
                                        TextSpan(
                                            text: '需求发布后只能被已选择的工厂看见，且只有被选择的工厂才能进行报价。',
                                            style: TextStyle(fontSize: 16,color: Colors.black)
                                        ),
                                      ]),
                                    ),
                                    onCloseEvent: (){
                                      Navigator.pop(context);
                                    },
                                    negativeText: '我知道了',
                                  );
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 0),
                                child: Icon(Icons.help,color: Colors.red,size: 20,),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container()
//                            GridView.count(
//                                physics: NeverScrollableScrollPhysics(),
//                                shrinkWrap: true,
//                                crossAxisCount: 2,
//                                childAspectRatio: 5,
//                                padding: EdgeInsets.zero,
//                                children: [
//                                  Opacity(
//                                    opacity: widget.formState.editModel.details.publishingMode == 'PUBLIC' ? 1 : 0,
//                                    child: GestureDetector(
//                                      onTap: ()async{
//                                        dynamic result = await Navigator.push(context, MaterialPageRoute(builder: (context) => RequirementOrderSelectPublishTargetForm(formState: widget.formState,)));
//                                        if(result != null){
//                                          _factoryUids = result;
//                                        }
//                                      },
//                                      child: Row(
//                                        children: <Widget>[
//                                          RichText(text: TextSpan(
//                                              style:TextStyle(fontSize: 13),
//                                              children: [
//                                                TextSpan(text: '已邀请报价',style: TextStyle(color: Colors.black),),
//                                                TextSpan(text: '${_factoryUids?.length?.toString() ?? 0}',style: TextStyle(color: Colors.red),),
//                                              ]
//                                          ),),
//                                          Container(
//                                              width: 10,
//                                              child: Icon(
//                                                Icons.chevron_right,
//                                                size: 20,
//                                                textDirection: TextDirection.ltr,
//                                              )),
//                                        ],
//                                      ),
//                                    ),
//                                  ),
//                                  Opacity(
//                                    opacity: widget.formState.editModel.details.publishingMode == 'PRIVATE' ? 1 : 0,
//                                    child: GestureDetector(
//                                      onTap: ()async{
//                                        dynamic result = await Navigator.push(context, MaterialPageRoute(builder: (context) => RequirementOrderSelectPublishTargetForm(formState: widget.formState,)));
//                                        if(result != null){
//                                          _factoryUids = result;
//                                        }
//                                      },
//                                      child: Row(
//                                        children: <Widget>[
//                                          RichText(text: TextSpan(
//                                              style:TextStyle(fontSize: 13),
//                                              children: [
//                                                TextSpan(text: '已指定工厂',style: TextStyle(color: Colors.black),),
//                                                TextSpan(text: '${_factoryUids?.length?.toString() ?? 0}',style: TextStyle(color: Colors.red),),
//                                              ]
//                                          ),),
//                                          Container(
//                                              width: 10,
//                                              child: Icon(
//                                                Icons.chevron_right,
//                                                size: 20,
//                                                textDirection: TextDirection.ltr,
//                                              )),
//                                        ],
//                                      ),
//                                    ),
//                                  ),
//                                ]
//                            ),
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
                        child:
                        GridView.count(
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
                              onTap: (){
                                setState(() {
                                  widget.formState.editModel.details
                                      .effectiveDays =
                                      int.parse(
                                          EffectiveDaysEnum[index].code);
                                });
                              },
                              child: Row(
                                children: <Widget>[
                                  Radio(
                                      value: EffectiveDaysEnum[index].code,
                                      groupValue: widget
                                          .formState.editModel.details.effectiveDays
                                          .toString(),
                                      onChanged: (v) {
                                        setState(() {
                                          widget.formState.editModel.details
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
                  model: widget.formState.editModel,
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
                        widget.formState.editModel.remarks = remarksController.text;
                      },
                    ),
                  )
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 发布
  void _onSave() async {
    print(widget.formState.editModel.details.productName);
    print(productNameController.text);
    widget.formState.editModel.details.productName = productNameController.text;
    widget.formState.editModel.details.maxExpectedPrice =
        ClassHandleUtil.removeSymbolRMBToDouble(
            super.maxExpectedPriceController.text);
    widget.formState.editModel.details.expectedMachiningQuantity =
        ClassHandleUtil.transInt(
            super.expectedMachiningQuantityController.text);
    widget.formState.editModel.remarks = remarksController.text;
    if (widget.formState.editModel.details.productName == null) {
      ShowDialogUtil.showValidateMsg(context, '请填写标题');
      return;
    }
    if (widget.formState.editModel.details.maxExpectedPrice == null) {
      ShowDialogUtil.showValidateMsg(context, '请填写期望价格');
      return;
    }
    if (widget.formState.editModel.details.expectedMachiningQuantity ==
        null) {
      ShowDialogUtil.showValidateMsg(context, '请填写加工数量');
      return;
    }
    if (widget.formState.editModel.details.expectedDeliveryDate == null) {
      ShowDialogUtil.showValidateMsg(context, '请选取交货日期');
      return;
    } else if (widget.formState.editModel.details.expectedDeliveryDate
        .isBefore(DateTime.now())) {
      ShowDialogUtil.showValidateMsg(context, '交货时间不可比当前时间小');
      return;
    }
    if (widget.formState.editModel.details.contactPerson == null ||
        widget.formState.editModel.details.contactPerson == '' ||
        widget.formState.editModel.details.contactPhone == null ||
        widget.formState.editModel.details.contactPhone == '') {
      ShowDialogUtil.showValidateMsg(context, '请完善联系方式');
      return;
    }
    if(widget.formState.editModel.details.machiningType == null){
      ShowDialogUtil.showValidateMsg(context, '请选择加工类型');
      return;
    }
    if(widget.formState.editModel.details.salesMarket == null || widget.formState.editModel.details.salesMarket.length == 0){
      ShowDialogUtil.showValidateMsg(context, '请选择质量等级');
      return;
    }
    if(widget.formState.editModel.details.effectiveDays == -1){
      //后台的'长期有效'值是null
      widget.formState.editModel.details.effectiveDays = null;
    }
    ShowDialogUtil.showChoseDiglog(context, '是否确认保存', (){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return RequestDataLoading(
              requestCallBack: RequirementOrderRepository().updateRequirement(widget.formState.editModel),
              outsideDismiss: false,
              loadingText: '正在保存。。。',
              entrance: '',
            );
          }).then((code)async {
        if (code != null && code != '') {
          widget.formState.editModel.code = code;
          //根据code查询明
          RequirementOrderModel model = await RequirementOrderRepository()
              .getRequirementOrderDetail(code);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => RequirementOrderDetailPage(
                  model.code,
                ),
              ),
              ModalRoute.withName(AppRoutes.ROUTE_REQUIREMENT_ORDERS));
        }
      });
    });


//      String code = await RequirementOrderRepository().publishNewRequirement(widget.formState.editModel,null,false);
//      if (code != null && code != '') {
//        widget.formState.editModel.code = code;
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
