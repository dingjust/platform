import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/business/cooperator/cooperator_item.dart';
import 'package:b2b_commerce/src/business/products/sample/sample_products.dart';
import 'package:b2b_commerce/src/my/my_addresses.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'external_order_form_state.dart';

class FormTitle extends StatelessWidget {
  final String title;

  final bool require;

  final String remarks;

  const FormTitle(
    this.title, {
    this.require = false,
    Key key,
    this.remarks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          require
              ? Text(
                  '*',
                  style: TextStyle(color: Color(0xffff1744)),
                )
              : Container(),
          Text('$title'),
          Text(
            '${remarks ?? ''}',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          )
        ],
      ),
    );
  }
}

class FormLabel extends StatelessWidget {
  final String label;

  final Widget suffix;

  const FormLabel(
    this.label, {
    Key key,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label',
          style:
              TextStyle(color: Color(0xff455a64), fontWeight: FontWeight.bold),
        ),
        suffix ?? Container()
      ],
    );
  }
}

class FormBlock extends StatelessWidget {
  final List<Widget> children;

  const FormBlock({Key key, @required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: children,
      ),
    );
  }
}

///合作商
class FormCooperatorsSelect extends StatelessWidget {
  final GestureTapCallback onCooperatorSelect;

  final CooperatorModel value;

  const FormCooperatorsSelect({Key key, this.onCooperatorSelect, this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBlock(
      children: [
        FormLabel('合作对象'),
        GestureDetector(
          onTap: onCooperatorSelect,
          child: Row(
            children: [
              Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey[300], width: 0.5)),
                      child: value != null
                          ? CooperatorItem(
                              model: value,
                              onItemTap: (val) => onCooperatorSelect(),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: Text(
                                '点击选择合作商',
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ))),
              Icon(Icons.keyboard_arrow_right)
            ],
          ),
        )
      ],
    );
  }
}

///生产详情
class FormProduction extends StatelessWidget {
  final List<ProductionTaskOrderModel> entries;

  final ValueChanged<List<ProductionTaskOrderModel>> onEntriesChange;

  const FormProduction({Key key, this.entries, this.onEntriesChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBlock(
      children: [
        FormLabel('生产详情'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 10,
            ),
            Text('外发产品数：'),
            Expanded(
                child: Text(
              '${entries?.length ?? 0}',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            )),
            MaterialButton(
                onPressed: () => selectProducts(context),
                child: Text(
                  '选择产品',
                ),
                color: Constants.THEME_COLOR_MAIN,
                textColor: Colors.white),
          ],
        ),
        Divider(),
        for (ProductionTaskOrderModel entry in entries ?? [])
          _FormEntryItem(
            entry: entry,
            updateEntry: updateEntry,
          )
      ],
    );
  }

  void selectProducts(BuildContext context) async {
    List<SampleProductModel> products = await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => SampleProductsPage(
                selectedData: entries
                        .map((e) => e.product as SampleProductModel)
                        .toList() ??
                    [],
                selectingMode: true)));
    if (products != null) {
      List<ProductionTaskOrderModel> entries = generateEntries(products);
      ExternalOrderFormState state =
          Provider.of<ExternalOrderFormState>(context);
      if (state != null) {
        state.updateEntries(entries);
      }
      //回调
      onEntriesChange.call(entries);
    }
  }

  ///生成当前订单行（包含已有）
  List<ProductionTaskOrderModel> generateEntries(
      List<SampleProductModel> products) {
    return products.map((product) {
      //是否已存在
      ProductionTaskOrderModel entry = this.entries.firstWhere(
          (element) => element.product.code == product.code,
          orElse: () => null);
      if (entry == null) {
        //初始化
        entry = ProductionTaskOrderModel(
            product: product,
            colorSizeEntries: product.variants
                .map((e) => ColorSizeEntryV2Model(
                    color: e.color, size: e.size, quantity: 0))
                .toList());
      }
      return entry;
    }).toList();
  }

  void updateEntry(ProductionTaskOrderModel entry) {
    onEntriesChange.call(entries);
  }
}

///订单行
class _FormEntryItem extends StatelessWidget {
  final ProductionTaskOrderModel entry;

  final ValueChanged<ProductionTaskOrderModel> updateEntry;

  const _FormEntryItem({Key key, this.entry, this.updateEntry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    if (entry.unitPrice != null && entry.unitPrice != 0) {
      textEditingController.text = entry.unitPrice.toString();
    }
    FocusNode focusNode = FocusNode();

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          _buildProductRow(),
          Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: ColorSizeEntryInputTable(
                data: entry.colorSizeEntries,
                compareFunction: Provider.of<SizeState>(context).compare,
                controllerMap: Provider.of<ExternalOrderFormState>(context)
                    .getControllerMapByCode(entry.product.code),
                nodeMap: Provider.of<ExternalOrderFormState>(context)
                    .getNodeMapByCode(entry.product.code),
                onChanged: (values) {
                  entry.colorSizeEntries = values;
                  if (updateEntry != null) {
                    updateEntry.call(entry);
                  }
                },
              )),
          FormTitle(
            '发单价格',
            require: true,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextFieldBorderComponent(
              padding: EdgeInsets.all(0),
              hideDivider: true,
              isRequired: true,
              textAlign: TextAlign.left,
              prefix: '￥',
              inputFormatters: [
                DecimalInputFormat(),
              ],
              hintText: '填写发单价格',
              controller: textEditingController,
              focusNode: focusNode,
              onChanged: (value) {
                entry.unitPrice = double.parse(value);
              },
            ),
          ),
          Divider(),
          FormTitle(
            '交货日期',
            require: true,
          ),
          ListTile(
            title: Text(
              entry?.deliveryDate == null
                  ? '请选择交货日期'
                  : '${DateFormatUtil.formatYMD(entry?.deliveryDate)}',
              style: TextStyle(color: Colors.grey),
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => onDateSelect(context),
          ),
          Divider(),
          FormTitle(
            '送货地址',
            require: true,
          ),
          AddressInfoBlock(
            model: entry?.shippingAddress,
            onTap: () => onAddressSelect(context),
          ),
          Container(height: 15, color: Colors.grey[50]),
        ],
      ),
    );
  }

  Widget _buildProductRow({double height = 80.0}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Hero(
            tag: 'productHero${entry.product.code}',
            child: ImageFactory.buildThumbnailImage(entry?.product?.thumbnail,
                containerSize: height),
          ),
          Expanded(
            child: Container(
              height: height,
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.product.name,
                    style: TextStyle(fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      '货号：${entry.product.skuID}',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 243, 243, 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "品类：${entry.product.category.name}",
                      style: TextStyle(
                          fontSize: 15,
                          color: Color.fromRGBO(255, 133, 148, 1)),
                    ),
                  )
                ],
              ),
            ),
          ),
          RichText(
              text: TextSpan(
                  text: '订单数：${entryQuatity()}',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                  children: [])),
        ],
      ),
    );
  }

  void onDateSelect(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: entry?.deliveryDate ?? DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2999),
    ).then((value) {
      if (value != null) {
        entry.deliveryDate = value;
        if (updateEntry != null) {
          updateEntry.call(entry);
        }
      }
    });
  }

  void onAddressSelect(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyAddressesPage(
                  isJumpSource: true,
                  title: '选择地址',
                ))).then((value) {
      if (value != null) {
        entry.shippingAddress = value;
        if (updateEntry != null) {
          updateEntry.call(entry);
        }
      }
    });
  }

  ///订单数
  String entryQuatity() {
    int result = 0;
    entry.colorSizeEntries.forEach((element) {
      result += element.quantity;
    });
    return result.toString();
  }
}

///单选
class FormRadios extends StatelessWidget {
  final SalesProductionOrderModel form;

  final ValueChanged<SalesProductionOrderModel> updateForm;

  const FormRadios({Key key, this.form, this.updateForm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBlock(
      children: [
        FormLabel('订单详情'),
        Row(children: [
          FormTitle('合作方式：'),
          for (CooperationMode val in CooperationMode.values)
            _cooperationModeRadios(val)
        ]),
        Divider(),
        Row(children: [
          FormTitle('是否开票：'),
          Expanded(
              child: Row(
            children: [
              Radio(
                value: false,
                groupValue: form.invoiceNeeded,
                onChanged: (val) {
                  form.invoiceNeeded = val;
                  _update();
                },
              ),
              Text('不开发票'),
            ],
          )),
          Expanded(
              child: Row(
            children: [
              Radio(
                value: true,
                groupValue: form.invoiceNeeded,
                onChanged: (val) {
                  form.invoiceNeeded = val;
                  _update();
                },
              ),
              Text('开发票'),
            ],
          ))
        ]),
        form.invoiceNeeded ?? false
            ? Row(
                children: [
                  FormTitle('税率：'),
                  for (double val in [0.03, 0.06, 0.13]) _taxPointsRadios(val)
                ],
              )
            : Container(),
        Divider(),
        Row(children: [
          FormTitle('运费承担：'),
          for (AgreementRoleType val in AgreementRoleType.values)
            _freightRadios(val)
        ]),
      ],
    );
  }

  ///合作方式单选项
  Widget _cooperationModeRadios(CooperationMode val) {
    return Expanded(
      child: Row(
        children: [
          Radio(
            value: val,
            groupValue: form.cooperationMode,
            onChanged: (CooperationMode value) {
              form.cooperationMode = value;
              _update();
            },
          ),
          Text('${CooperationModeLocalizedMap[val]}'),
        ],
      ),
    );
  }

  ///税点单选项
  Widget _taxPointsRadios(double val) {
    return Expanded(
      child: Row(
        children: [
          Radio(
            value: val,
            groupValue: form.invoiceTaxPoint,
            onChanged: (double value) {
              form.invoiceTaxPoint = value;
              _update();
            },
          ),
          Text('${val * 100}%'),
        ],
      ),
    );
  }

  ///运费单选项
  Widget _freightRadios(AgreementRoleType val) {
    return Expanded(
      child: Row(
        children: [
          Radio(
            value: val,
            groupValue: form.freightPayer,
            onChanged: (AgreementRoleType value) {
              form.freightPayer = value;
              _update();
            },
          ),
          Text('${AgreementRoleTypeLocalizedMap[val]}'),
        ],
      ),
    );
  }

  void _update() {
    if (updateForm != null) {
      updateForm.call(form);
    }
  }
}

///账务选择
class FormPayPlanSelect extends StatelessWidget {
  final GestureTapCallback onPayPlanSelect;

  final CompanyPayPlanModel value;

  const FormPayPlanSelect({Key key, @required this.onPayPlanSelect, this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBlock(
      children: [
        FormLabel('财务设置'),
        GestureDetector(
          onTap: () {
            if (onPayPlanSelect != null) {
              onPayPlanSelect.call();
            }
          },
          child: Row(
            children: [
              Expanded(
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey[300], width: 0.5)),
                      child: value != null
                          ? _buildItem()
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: Text(
                                '点击选择财务方案',
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ))),
              Icon(Icons.keyboard_arrow_right)
            ],
          ),
        )
      ],
    );
  }

  Widget _buildItem() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text('${value.name}',
                    textAlign: TextAlign.start,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '${getSubTitle()}',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  '${value.previewText}',
                  overflow: TextOverflow.visible,
                  style: TextStyle(color: Colors.grey),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  String getSubTitle() {
    return '${value.isHaveDeposit ? '有' : '无'}定金+${PayPlanTypeLocalizedMap[value.payPlanType]}';
  }
}

///备注及附件
class FormRemarks extends StatelessWidget {
  final SalesProductionOrderModel form;

  const FormRemarks({
    Key key,
    @required this.form,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController =
        TextEditingController(text: form?.remarks ?? '');
    FocusNode focusNode = FocusNode();

    return FormBlock(
      children: [
        FormLabel('附件及备注'),
        FormTitle('备注：'),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextFieldBorderComponent(
            padding: EdgeInsets.all(0),
            hideDivider: true,
            isRequired: true,
            textAlign: TextAlign.left,
            hintText: '请输入内容',
            controller: textEditingController,
            maxLength: 150,
            focusNode: focusNode,
            onChanged: (value) {
              form.remarks = value;
            },
          ),
        ),
        Container(
          color: Colors.white,
          child: EditableAttachments(
            list: form.attachments,
            maxNum: 5,
          ),
        ),
      ],
    );
  }
}

///支付信息
class FormPayInfo extends StatefulWidget {
  final SalesProductionOrderModel form;

  final ValueChanged<SalesProductionOrderModel> updateForm;

  const FormPayInfo({Key key, this.form, this.updateForm}) : super(key: key);

  @override
  _FormPayInfoState createState() => _FormPayInfoState();
}

class _FormPayInfoState extends State<FormPayInfo> {
  SalesProductionOrderModel form;

  TextEditingController payNameController;
  FocusNode payNameNode;

  TextEditingController payNoController;
  FocusNode payNoNode;

  TextEditingController payProvController;
  FocusNode payProvNode;

  @override
  void initState() {
    form = widget.form;
    payNameController = TextEditingController(text: form.paymentAccount.name);
    payNameNode = FocusNode();
    payNoController = TextEditingController(text: form.paymentAccount.no);
    payNoNode = FocusNode();
    payProvController =
        TextEditingController(text: form.paymentAccount.serviceProvider);
    payProvNode = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormBlock(
      children: [
        FormLabel('支付信息'),
        Row(children: [
          FormTitle('支付类型：'),
          Expanded(
              child: Row(
            children: [
              Radio(
                value: false,
                groupValue: form.payOnline,
                onChanged: (val) {
                  setState(() {
                    form.payOnline = val;
                  });
                  _update();
                },
              ),
              Text('线下支付'),
            ],
          )),
          Expanded(
              child: Row(
            children: [
              Radio(
                value: true,
                groupValue: form.payOnline,
                onChanged: (val) {
                  setState(() {
                    form.payOnline = val;
                  });
                  _update();
                },
              ),
              Text('线上支付'),
            ],
          )),
        ]),
        ...form.payOnline ? _bankInfo(context) : []
      ],
    );
  }

  ///银行卡信息
  List<Widget> _bankInfo(BuildContext context) {
    if (form.payOnline != null && form.payOnline) {
      return [
        FormTitle('收款人姓名（银行卡)：'),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextFieldBorderComponent(
            padding: EdgeInsets.all(0),
            hideDivider: true,
            isRequired: true,
            textAlign: TextAlign.left,
            hintText: '收款人姓名',
            controller: payNameController,
            focusNode: payNameNode,
            onChanged: (value) {
              form.paymentAccount.name = value;
              _update();
            },
          ),
        ),
        Divider(),
        FormTitle('开户行（银行卡)：'),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextFieldBorderComponent(
            padding: EdgeInsets.all(0),
            hideDivider: true,
            isRequired: true,
            textAlign: TextAlign.left,
            hintText: '请输入开户行',
            controller: payProvController,
            focusNode: payProvNode,
            onChanged: (value) {
              form.paymentAccount.serviceProvider = value;
              _update();
            },
          ),
        ),
        Divider(),
        FormTitle('卡号（银行卡)：'),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextFieldBorderComponent(
            padding: EdgeInsets.all(0),
            hideDivider: true,
            isRequired: true,
            textAlign: TextAlign.left,
            hintText: '请输入卡号',
            controller: payNoController,
            focusNode: payNoNode,
            onChanged: (value) {
              form.paymentAccount.no = value;
              _update();
            },
          ),
        ),
      ];
    }
    return [];
  }

  void _update() {
    if (widget.updateForm != null) {
      widget.updateForm.call(form);
    }
  }
}

class FormValidateItem {
  final bool result;
  final String message;

  FormValidateItem(this.result, this.message);
}
