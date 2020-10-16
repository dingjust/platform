import 'package:b2b_commerce/src/business/subcontract/form/field/subcontract_contact_input.dart';
import 'package:b2b_commerce/src/business/subcontract/form/field/subcontract_delivery_date_field.dart';
import 'package:b2b_commerce/src/business/subcontract/subcontract_mine.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class SubContractSecondForm extends StatefulWidget {
  SubContractSecondForm({
    this.formState,
  });

  final SubContractFormState formState;

  _SubContractSecondFormState createState() =>
      _SubContractSecondFormState();
}

class _SubContractSecondFormState extends State<SubContractSecondForm> {
  GlobalKey _scaffoldKey = GlobalKey();
  FocusNode _titleFocusNode = FocusNode();
  TextEditingController _titleController = TextEditingController();
  FocusNode _maxExpectedPriceFocusNode = FocusNode();
  TextEditingController _maxExpectedPriceController = TextEditingController();
  FocusNode _subContractQuantityFocusNode = FocusNode();
  TextEditingController _subContractQuantityController = TextEditingController();
  FocusNode _remarksFocusNode = FocusNode();
  TextEditingController _remarksController = TextEditingController();
  List<MediaModel> _pictures = [];

  @override
  void initState() {
    super.initState();
    if(widget.formState.model.details.pictures != null){
      _pictures.addAll(widget.formState.model.details.pictures);
    }
    _titleController.text = widget.formState.model.details.title;
    _maxExpectedPriceController.text =
        widget.formState.model.details.maxExpectedPrice?.toString();
    _subContractQuantityController.text =
        widget.formState.model.details.subContractQuantity?.toString();
    _remarksController.text = widget.formState.model.remarks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('发布转包(2/2)'),
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
                      '${widget.formState.model.details.majorCategory
                      .name}     '
                      '${widget.formState.model.details.category.parent != null
                      ? widget.formState.model.details.category.parent.name +
                      '-'
                      : ''}'
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
                      controller: _titleController,
                      focusNode: _titleFocusNode,
                      onChanged: (v) {
                        widget.formState.model.details.title =
                            _titleController.text;
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
                      hintText: '填写',
                      controller: _maxExpectedPriceController,
                      focusNode: _maxExpectedPriceFocusNode,
                      onChanged: (v) {
                        widget.formState.model.details.maxExpectedPrice =
                            ClassHandleUtil.removeSymbolRMBToDouble(
                                _maxExpectedPriceController.text);
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
                          text: '转包数量',
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
                      controller: _subContractQuantityController,
                      focusNode: _subContractQuantityFocusNode,
                      onChanged: (v) {
                        widget.formState.model.details.subContractQuantity =
                            ClassHandleUtil.transInt(
                                _subContractQuantityController.text);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: SubContractDeliveryDateField(widget.formState.model),
            ),
            Container(
              color: Colors.white,
              child: GestureDetector(
                  child: Container(
                    child: ListTile(
                      leading: Wrap(
                        children: <Widget>[
                          Text(
                            '联系方式',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black
                            ),
                          ),
                          Text(
                              ' *',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red)
                          ),
                        ],
                      ),
                      trailing: widget.formState.model.details?.contactPerson ==
                          null &&
                          widget.formState.model.details?.contactPhone == null ?
                      Icon(Icons.chevron_right, color: Colors.black,) :
                      Text(
                        formatContactWayText(),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                  onTap: () async{
                    List<String> result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SubContractContactInput(widget.formState.model)),
                    );
                    setState(() {
                      widget.formState.model.details.contactPerson = result[0];
                      widget.formState.model.details.contactPhone = result[1];
                    });
                  }),
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
                        itemBuilder: (BuildContext context) =>
                            FactoryQualityLevelsEnum.map(
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
                                                      widget.formState.model
                                                          .details
                                                          .salesMarket
                                                          .add(saleMarket.code);
                                                    } else {
                                                      widget.formState.model
                                                          .details
                                                          .salesMarket
                                                          .remove(
                                                          saleMarket.code);
                                                    }
                                                  });
                                                });
                                              },
                                              activeColor: Colors.orange,
                                              value: widget.formState.model
                                                  .details
                                                  .salesMarket
                                                  .contains(saleMarket.code),
                                            );
                                          }),
                                    )).toList(),
                        child: Text(
//                            '选择质量等级',
                          formatEnumSelectsText(
                              widget.formState.model.details.salesMarket,
                              FactoryQualityLevelsEnum,
                              2,
                              customText: '选择质量等级'),
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
                      children: CooperationModesEnum
                          .map((type) =>
                          ChoiceChip(
                              label: Container(
                                height: 20,
                                width: 60,
                                child: Center(child: Text(type.name)),
                              ),
                              backgroundColor: Colors.grey[100],
                              selectedColor: Color.fromRGBO(255, 214, 12, 1),
                              selected:
                              widget.formState.model.details.machiningType ==
                                  type.code,
                              onSelected: (bool selected) {
                                setState(() {
                                  widget.formState.model.details.machiningType =
                                      type.code;
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
                            selected: widget.formState.model.details
                                .invoiceNeeded,
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
                            selected: !widget.formState.model.details
                                .invoiceNeeded,
                            onSelected: (bool selected) {
                              setState(() {
                                widget.formState.model.details.invoiceNeeded =
                                false;
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
                                widget.formState.model.details
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
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Row(
                children: <Widget>[
                  Text(
                    '参考图片',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '（若无图片可不上传）',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  )
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: EditableAttachments(
                list: _pictures,
                maxNum: 5,
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(children: <Widget>[
                Container(
                  color: Colors.white,
                  child: TextFieldComponent(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    dividerPadding: EdgeInsets.only(),
                    focusNode: _remarksFocusNode,
                    hintText: '填写备注',
                    autofocus: false,
                    inputType: TextInputType.text,
                    textAlign: TextAlign.left,
                    hideDivider: true,
                    maxLines: null,
                    maxLength: 120,
                    controller: _remarksController,
                    onChanged: (v) {
                      widget.formState.model.remarks = _remarksController.text;
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

  //格式化联系方式
  formatContactWayText() {
    StringBuffer text = StringBuffer();
    if (widget.formState.model.details?.contactPerson == null &&
        widget.formState.model.details?.contactPhone == null) {
      text.write('填写');
    } else {
      text.write(widget.formState.model.details?.contactPerson ?? '');
      text.write(',');
      text.write(widget.formState.model.details?.contactPhone ?? '');
    }
    return text.toString();
  }

  /// 发布
  void onPublish() async {
    print(SubContractModel.toJson(widget.formState.model));
    if (widget.formState.model.details.title == null) {
      ShowDialogUtil.showValidateMsg(context, '请填写标题');
      return;
    }
    if (widget.formState.model.details.maxExpectedPrice == null) {
      ShowDialogUtil.showValidateMsg(context, '请填写期望价格');
      return;
    }
    if (widget.formState.model.details.subContractQuantity ==
        null) {
      ShowDialogUtil.showValidateMsg(context, '请填写转包数量');
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
    if (_pictures != null){
      widget.formState.model.details.pictures = _pictures;
    }
    ShowDialogUtil.showChoseDiglog(context, '是否确认发布', () {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return RequestDataLoading(
              requestCallBack: SubContractRepositoryImpl().createSubContract(widget.formState.model),
              outsideDismiss: false,
              loadingText: '正在保存。。。',
              entrance: '',
            );
          }).then((code) async {
        if (code != null && code != '') {
          print('${code}------------=========');
          widget.formState.model.code = code;
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SubContractMinePage()), ModalRoute.withName('/'));
          //根据code查询明
//          RequirementOrderModel model = await RequirementOrderRepository()
//              .getRequirementOrderDetail(code);
//          Navigator.of(context).pushAndRemoveUntil(
//              MaterialPageRoute(
//                builder: (context) => PublishRequirementSuccessDialog(
//                  model: model,
//                ),
//              ),
//              ModalRoute.withName('/'));
        }
      });
    });
  }
}
