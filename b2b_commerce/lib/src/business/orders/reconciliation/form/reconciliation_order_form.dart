import 'package:b2b_commerce/src/business/orders/reconciliation/components/reconciliation_product_info.dart';
import 'package:b2b_commerce/src/business/orders/sales_production/external_sale_order/form/form_components.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'form_btns.dart';

///对账单表单页
class ReconciliationOrderForm extends StatefulWidget {
  final SalesProductionOrderModel order;

  final FastReconciliationSheetModel model;

  const ReconciliationOrderForm({Key key, this.order, this.model})
      : super(key: key);

  @override
  _ReconciliationOrderFormState createState() =>
      _ReconciliationOrderFormState();
}

class _ReconciliationOrderFormState extends State<ReconciliationOrderForm> {
  FastReconciliationSheetModel form;

  TextEditingController remarksController;
  FocusNode remarksNode;

  Map<String, Map<String, TextEditingController>> controllersMaps;
  Map<String, Map<String, FocusNode>> nodesMaps;

  List<TextEditingController> additionNameControllers;
  List<FocusNode> additionNameNodes;
  List<TextEditingController> additionValControllers;
  List<FocusNode> additionValNodes;

  List<String> colNames = ['装箱数', '入库数'];

  @override
  void initState() {
    remarksController = TextEditingController(text: form?.remarks ?? '');
    remarksNode = FocusNode();

    additionNameControllers = [];
    additionNameNodes = [];
    additionValControllers = [];
    additionValNodes = [];

    if (widget.model == null) {
      //新建
      form = generateForm();
    } else {
      form = reGenerateForm();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '创建对账单',
          style:
              TextStyle(color: Color(0xff455a64), fontWeight: FontWeight.bold),
        ),
        elevation: 0.5,
      ),
      body: Container(
          child: ListView(
        children: <Widget>[
          ..._buildEntries(),
          _buildAdditional(),
          _buildRemarks(),
          Container(height: 60),
          FormBtns(form: form),
        ],
      )),
    );
  }

  List<Widget> _buildEntries() {
    if (form.entries == null) return [];

    return form.entries
        .map(
          (e) => FormBlock(
            children: [
              ReconciliationProductInfo(product: e.product),
              ReconciliationInfoRow(title: '下单数', val: '${e.orderQuantity}'),
              ReconciliationInfoRow(
                  title: '合同时间',
                  val: '${DateFormatUtil.formatYMD(e.contractDate)}'),
              ReconciliationInfoRow(
                  title: '合同单价', val: '${e.unitContractPrice}'),
              TextButton(
                  onPressed: () {
                    addCustomCol();
                  },
                  child: Text('添加自定义列')),
              ReconciliationEditRow(
                title: '裁数',
                controller: controllersMaps[e.product.code]['裁数'],
                node: nodesMaps[e.product.code]['裁数'],
                inputType: TextInputType.number,
                formatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChaged: (val) {
                  int result = int.tryParse(val);
                  if (result != null) {
                    setState(() {
                      e.cutQuantity = result;
                    });
                  }
                },
              ),
              _buildDateSelect(e),
              ..._generateEditRows(e),
              ReconciliationEditRow(
                title: '货款金额(实际)',
                controller: controllersMaps[e.product.code]['货款金额'],
                node: nodesMaps[e.product.code]['货款金额'],
                formatters: [
                  DecimalInputFormat(),
                ],
                onChaged: (val) {
                  setState(() {
                    e.loanAmount = valParse(val);
                  });
                },
              ),
              ReconciliationEditRow(
                title: '结算金额',
                titleStyle: TextStyle(color: Colors.red),
                controller: controllersMaps[e.product.code]['结算金额'],
                node: nodesMaps[e.product.code]['结算金额'],
                formatters: [
                  DecimalInputFormat(),
                ],
                onChaged: (val) {
                  setState(() {
                    e.settlementAmount = valParse(val);
                  });
                },
              ),
            ],
          ),
        )
        .toList();
  }

  ///自定义列输入行
  List<ReconciliationEditRow> _generateEditRows(
      FastReconciliationSheetEntryModel entry) {
    return form.colNames.map((e) {
      return ReconciliationEditRow(
        title: '$e',
        controller: controllersMaps[entry.product.code][e],
        node: nodesMaps[entry.product.code][e],
        onChaged: (val) {
          ReconciliationCustomColumnModel item = entry.customColumns
              .firstWhere((element) => element.name == e, orElse: () => null);
          if (item != null) {
            // setState(() {
            item.value = val;
            // });
          }
        },
      );
    }).toList();
  }

  Widget _buildRemarks() {
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
            controller: remarksController,
            maxLength: 120,
            focusNode: remarksNode,
            onChanged: (value) {
              form.remarks = value;
            },
          ),
        ),
        Divider(),
        FormTitle('附件：'),
        Container(
          color: Colors.white,
          child: EditableAttachments(
            list: form?.medias,
            maxNum: 5,
          ),
        ),
      ],
    );
  }

  ///附加项
  Widget _buildAdditional() {
    return FormBlock(
      children: [
        FormLabel('附加项'),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(child: Text('名称')),
              Expanded(child: Text('金额'))
            ],
          ),
        ),
        ..._buildAdditionalEntries(),
        TextButton(
            onPressed: () {
              additionNameControllers.add(TextEditingController());
              additionNameNodes.add(FocusNode());
              additionValControllers.add(TextEditingController());
              additionValNodes.add(FocusNode());
              setState(() {
                form.additionalCharges
                    .add(ReconciliationAdditionalModel(remarks: ''));
              });
            },
            child: Text('添加附加项'))
      ],
    );
  }

  Widget _buildDateSelect(FastReconciliationSheetEntryModel e) {
    return Row(
      children: [
        Container(
          width: 100,
          child: Text(
            '交货日期',
          ),
        ),
        Expanded(
          child: ListTile(
            title: Text(
              e?.deliveryDate == null
                  ? '请选择交货日期'
                  : '${DateFormatUtil.formatYMD(e?.deliveryDate)}',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.right,
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: e?.deliveryDate ?? DateTime.now(),
                firstDate: DateTime(2019),
                lastDate: DateTime(2999),
              ).then((value) {
                if (value != null) {
                  setState(() {
                    e.deliveryDate = value;
                  });
                }
              });
            },
          ),
        )
      ],
    );
  }

  List<Widget> _buildAdditionalEntries() {
    List<Widget> entries = [];

    for (int i = 0; i < form.additionalCharges.length; i++) {
      entries.add(Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: TextFieldBorderComponent(
                  padding: EdgeInsets.all(0),
                  hideDivider: true,
                  isRequired: true,
                  textAlign: TextAlign.left,
                  hintText: '名称',
                  enabled: form.additionalCharges[i].isDefault == null,
                  controller: additionNameControllers[i],
                  focusNode: additionNameNodes[i],
                  onChanged: (value) {
                    form.additionalCharges[i].remarks = value;
                  },
                ),
              ),
              Container(width: 10),
              Expanded(
                child: TextFieldBorderComponent(
                  padding: EdgeInsets.all(0),
                  hideDivider: true,
                  isRequired: true,
                  textAlign: TextAlign.right,
                  hintText: '增扣款',
                  enabled: form.additionalCharges[i].isDefault == null,
                  inputType: TextInputType.numberWithOptions(
                      decimal: true, signed: true),
                  controller: additionValControllers[i],
                  focusNode: additionValNodes[i],
                  onChanged: (value) {
                    double result = double.tryParse(value);
                    setState(() {
                      if (result != null) {
                        form.additionalCharges[i].amount = result;
                      }
                    });
                  },
                ),
              ),
              Opacity(
                opacity: form.additionalCharges[i].isDefault ?? false ? 0 : 1,
                child: TextButton(
                    onPressed: () {
                      if (form.additionalCharges[i].isDefault == null ||
                          !form.additionalCharges[i].isDefault) {
                        setState(() {
                          form.additionalCharges.removeAt(i);
                          additionNameControllers.removeAt(i);
                          additionNameNodes.removeAt(i);
                          additionValControllers.removeAt(i);
                          additionValNodes.removeAt(i);
                        });
                      }
                    },
                    child: Text('删除')),
              )
            ],
          )));
    }
    return entries;
  }

  ///初始化表单数据
  FastReconciliationSheetModel generateForm() {
    if (widget.order == null) throw Exception('订单数据不能为空');
    FastReconciliationSheetModel data = FastReconciliationSheetModel(
      title: '电子对账单',
      medias: [],
      fastShippingSheets: [],
      paperSheetMedias: [],
      approvers: [],
      colNames: colNames,
      additionalCharges: [],
      salesProductionOrder: widget.order,
      belongRoleType: getRoleType(),

      // shipParty: widget.order.targetCooperator.partner,
      // receiveParty: widget.order.originCompany
    );
    controllersMaps = {};
    nodesMaps = {};
    //填充行
    data.entries = widget.order.taskOrderEntries.map((element) {
      //以产品编号为key
      Map<String, TextEditingController> controllersMap = {};
      Map<String, FocusNode> nodesMap = {};

      FastReconciliationSheetEntryModel entry =
          FastReconciliationSheetEntryModel(
        product: element.product,
        contractDate: element.deliveryDate,
        orderQuantity: element.quantity,

        // loanAmount: element.totalPrimeCost,
        unitContractPrice: element.unitPrice,
        // settlementAmount: element.totalPrimeCost
      );
      //默认字段
      controllersMap['结算金额'] = TextEditingController();
      nodesMap['结算金额'] = FocusNode();
      controllersMap['裁数'] = TextEditingController();
      nodesMap['裁数'] = FocusNode();
      controllersMap['货款金额'] = TextEditingController();
      nodesMap['货款金额'] = FocusNode();
      entry.customColumns = [];
      //自定义字段
      data.colNames.forEach((attribute) {
        controllersMap[attribute] = TextEditingController();
        nodesMap[attribute] = FocusNode();
        entry.customColumns
            .add(ReconciliationCustomColumnModel(name: attribute));
      });
      controllersMaps[element.product.code] = controllersMap;
      nodesMaps[element.product.code] = nodesMap;
      return entry;
    }).toList();

    //已支付账单添加进附加项
    for (int i = 0; i < widget.order.paymentOrders.length; i++) {
      String name = '';
      if (i == 0) {
        name = '定金';
      } else {
        name = '${i + 1}期款项';
      }
      double amount = -widget.order.paymentOrders[i].payAmount;
      additionNameControllers.add(TextEditingController(text: name));
      additionNameNodes.add(FocusNode());
      additionValControllers
          .add(TextEditingController(text: amount.toStringAsFixed(2)));
      additionValNodes.add(FocusNode());
      data.additionalCharges.add(ReconciliationAdditionalModel(
          remarks: name, amount: amount, isDefault: true));
    }

    return data;
  }

  ///初始化表单数据(更新操作)
  FastReconciliationSheetModel reGenerateForm() {
    if (widget.order == null || widget.model == null)
      throw Exception('订单数据不能为空');
    if (widget.model.colNames != null && widget.model.colNames.length > 0) {
      colNames = widget.model.colNames;
    }

    // FastReconciliationSheetModel data = FastReconciliationSheetModel(
    //   title: '电子对账单',
    //   medias: widget.model.medias ?? [],
    //   fastShippingSheets: widget.model.fastShippingSheets ?? [],
    //   paperSheetMedias: widget.model.paperSheetMedias ?? [],
    //   approvers: [],
    //   colNames: colNames,
    //   additionalCharges: widget.model.additionalCharges ?? [],
    //   salesProductionOrder: widget.order,
    //   belongRoleType: getRoleType(),
    // );
    FastReconciliationSheetModel data = widget.model;

    controllersMaps = {};
    nodesMaps = {};
    //行
    data.entries.forEach((element) {
      //以产品编号为key
      Map<String, TextEditingController> controllersMap = {};
      Map<String, FocusNode> nodesMap = {};

      //默认字段
      controllersMap['结算金额'] = TextEditingController(
          text: element.settlementAmount.toStringAsFixed(2));
      nodesMap['结算金额'] = FocusNode();
      controllersMap['裁数'] =
          TextEditingController(text: '${element.cutQuantity}');
      nodesMap['裁数'] = FocusNode();
      controllersMap['货款金额'] =
          TextEditingController(text: '${element.loanAmount}');
      nodesMap['货款金额'] = FocusNode();

      element.customColumns.forEach((col) {
        controllersMap[col.name] = TextEditingController(text: col.value);
        nodesMap[col.name] = FocusNode();
      });
      controllersMaps[element.product.code] = controllersMap;
      nodesMaps[element.product.code] = nodesMap;
    });

    data.additionalCharges.forEach((element) {
      additionNameControllers.add(TextEditingController(text: element.remarks));
      additionNameNodes.add(FocusNode());
      additionValControllers
          .add(TextEditingController(text: element.amount.toStringAsFixed(2)));
      additionValNodes.add(FocusNode());
    });

    return data;
  }

  //判断用户属于甲乙方
  AgreementRoleType getRoleType() {
    if (widget?.order?.originCompany?.uid ==
        UserBLoC.instance.currentUser.companyCode) {
      return AgreementRoleType.PARTYA;
    } else {
      return AgreementRoleType.PARTYB;
    }
  }

  void addCustomCol() {
    TextEditingController dialogText = TextEditingController();
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('请输入列名'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '注：添加自定义列后将清空数据',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
                TextField(
                  controller: dialogText,
                  decoration: InputDecoration(
                    labelText: '请输入列名',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                if (dialogText.text != null && dialogText.text != '') {
                  setState(() {
                    colNames.add(dialogText.text);
                    form = generateForm();
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  double valParse(String val) {
    double result = double.tryParse(val);
    return result ?? 0;
  }
}
