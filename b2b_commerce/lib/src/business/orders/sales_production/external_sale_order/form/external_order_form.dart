import 'package:b2b_commerce/src/_shared/payplan/form/simple_payplan_form.dart';
import 'package:b2b_commerce/src/_shared/payplan/payplan_select_page.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'external_order_form_state.dart';
import 'form_btns.dart';
import 'form_components.dart';

///外接订单表单页
class ExternalOrderForm extends StatefulWidget {
  final SalesProductionOrderModel model;

  const ExternalOrderForm({Key key, this.model}) : super(key: key);

  @override
  _ExternalOrderFormState createState() => _ExternalOrderFormState();
}

class _ExternalOrderFormState extends State<ExternalOrderForm> {
  SalesProductionOrderModel form;
  ExternalOrderFormState externalOrderFormState;
  UserModel currentUser = UserBLoC.instance.currentUser;

  @override
  void initState() {
    initForm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: ChangeNotifierProvider<ExternalOrderFormState>(
          create: (context) => externalOrderFormState,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                '${widget.model != null ? '修改' : '创建'}外接订单',
                style: TextStyle(
                    color: Color(0xff455a64), fontWeight: FontWeight.bold),
              ),
              elevation: 0.5,
            ),
            body: Container(
              child: ListView(
                children: <Widget>[
                  // FormCooperatorsSelect(
                  //   onCooperatorSelect: onCooperatorSelect,
                  //   // value: form.targetCooperator,
                  //   value: form.originCooperator,
                  // ),
                  FormProduction(
                    onEntriesChange: (entries) {
                      setState(() {
                        form.taskOrderEntries = entries;
                      });
                    },
                    entries: form.taskOrderEntries,
                  ),
                  FormRadios(
                    form: form,
                    updateForm: (val) {
                      setState(() {
                        form = val;
                      });
                    },
                  ),
                  FormPayInfo(
                      form: form,
                      updateForm: (val) {
                        // setState(() {
                        form = val;
                        // });
                      }),
                  SimplePayPlanForm(
                      form: form.payPlan,
                      onChange: (val) {
                        setState(() {
                          form.payPlan = val;
                        });
                      }),
                  _buildRemarks(),
                  Container(
                    height: 60,
                  ),
                  FormBtns(
                    form: form,
                    validateFunc: validateForm,
                  )
                ],
              ),
            ),
          ),
        ),
        onWillPop: onPop);
  }

  Widget _buildRemarks() {
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
            maxLength: 120,
            focusNode: focusNode,
            onChanged: (value) {
              form.remarks = value;
            },
          ),
        ),
        Divider(),
        FormTitle('附件：'),
        Container(
          color: Colors.white,
          child: EditableAttachmentsV2(
            list: form.attachments,
          ),
          // EditableAttachments(
          //   list: form.attachments,
          //   maxNum: 5,
          // ),
        ),
      ],
    );
  }

  ///初始化表单
  void initForm() {
    if (widget.model != null) {
      //更新
      //拷贝对象操作
      form = SalesProductionOrderModel.fromJson(widget.model.toJson());
      externalOrderFormState =
          ExternalOrderFormState(entries: form.taskOrderEntries);
      //构造State里的FormEntries
      externalOrderFormState.formEntries = form.taskOrderEntries.map((e) {
        Map controllerMap = {};
        Map nodeMap = {};
        e.colorSizeEntries.forEach((element) {
          if (controllerMap[element.color.code] == null) {
            controllerMap[element.color.code] = {};
          }
          controllerMap[element.color.code][element.size.code] =
              TextEditingController(
                  text: '${element.quantity != 0 ? element.quantity : ''}');

          if (nodeMap[element.color.code] == null) {
            nodeMap[element.color.code] = {};
          }
          nodeMap[element.color.code][element.size.code] = FocusNode();
        });
        return ExternalOrderFormEntry(
            entry: e, controllerMap: controllerMap, nodeMap: nodeMap);
      }).toList();
      //附件空处理
      if (form.attachments == null) {
        form.attachments = [];
      }
    } else {
      externalOrderFormState = ExternalOrderFormState(entries: []);
      form = SalesProductionOrderModel(
          sendAuditNeeded: false,
          managementMode: ManagementMode.COLLABORATION,
          serviceFeePercent: 0,
          taskOrderEntries: [],
          attachments: [],
          payOnline: true,
          offLine: true,
          name: '',
          type: ProductionOrderType.SALES_ORDER,
          paymentAccount:
              OrderPaymentAccountData(type: OrderPaymentAccountType.BANK),
          payPlan: CompanyPayPlanModel(
              isHaveDeposit: true,
              payPlanType: PayPlanType.PHASEONE,
              payPlanItems: [
                AbstractPayPlanItemModel(
                    moneyType: PayMoneyType.DEPOSIT,
                    triggerEvent: TriggerEvent.CONTRACT_SIGNED,
                    triggerDays: 5,
                    payPercent: 0.3),
                AbstractPayPlanItemModel(
                  moneyType: PayMoneyType.PHASEONE,
                  triggerEvent: TriggerEvent.RECONCILIATION_CONFIRMED,
                  triggerDays: 5,
                )
              ]),
          productionLeader:
              B2BCustomerModel(id: currentUser.id, name: currentUser.name),
          merchandiser:
              B2BCustomerModel(id: currentUser.id, name: currentUser.name));
    }
  }

  // ///合作商选择
  // void onCooperatorSelect() async {
  //   List<CooperatorModel> cooperators = await Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => CooperatorsPage(
  //                 selectedData: form.targetCooperator != null
  //                     ? [form.targetCooperator]
  //                     : [],
  //                 selectingMode: true,
  //                 categories: [CooperatorCategory.SUPPLIER],
  //                 max: 1,
  //               )));
  //   if (cooperators != null) {
  //     setState(() {
  //       if (cooperators.isNotEmpty) {
  //         // form.targetCooperator = cooperators.first;
  //         form.originCooperator = cooperators.first;
  //       } else {
  //         // form.targetCooperator = null;
  //         form.originCooperator = null;
  //       }
  //     });
  //   }
  // }

  ///财务选择
  void onPayPlanSelect() async {
    CompanyPayPlanModel returnResult =
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PayPlanSelectPage(
                  selectedModel: form.payPlan,
                )));
    if (returnResult != null) {
      setState(() {
        form.payPlan = returnResult;
      });
    }
  }

  ///订单行校验
  List<FormValidateItem> _validateEntry(ProductionTaskOrderModel entry) {
    return [
      FormValidateItem((entry.unitPrice == null || entry.unitPrice <= 0),
          '产品${form.taskOrderEntries.indexOf(entry) + 1}：请填写发单价格'),
      FormValidateItem((entry.shippingAddress == null),
          '产品${form.taskOrderEntries.indexOf(entry) + 1}：请选择发货地址'),
      FormValidateItem((entry.deliveryDate == null),
          '产品${form.taskOrderEntries.indexOf(entry) + 1}：请选择交货日期'),
      // FormValidateItem((entry.progressPlan == null),
      //     '产品${form.taskOrderEntries.indexOf(entry) + 1}：节点方案不能为空'),
      FormValidateItem((entryTotal(entry) < 1),
          '产品${form.taskOrderEntries.indexOf(entry) + 1}：数量不能少于1'),
    ];
  }

  ///表单校验
  bool validateForm() {
    List<FormValidateItem> items = [
      FormValidateItem(
          (form.taskOrderEntries == null || form.taskOrderEntries.isEmpty),
          '请选择产品'),
      FormValidateItem(form.cooperationMode == null, '请选择合作方式'),
      FormValidateItem(form.invoiceNeeded == null, '请选择是否开票'),
      FormValidateItem(
          ((form.invoiceNeeded ?? false) && form.invoiceTaxPoint == 0),
          '请选择税点'),
      FormValidateItem(form.freightPayer == null, '请选择运费承担方'),
      FormValidateItem(form.payPlan == null, '请选择账务方案'),
    ];

    //行校验
    if (form.taskOrderEntries != null) {
      form.taskOrderEntries.forEach((element) {
        items.addAll(_validateEntry(element));
      });
    }

    //代运营判断费用
    if ((form.id == null && currentUser.agent) ||
        (form.id != null && form.agentOrder)) {
      items.add(FormValidateItem(
          (form.serviceFeePercent == null || form.serviceFeePercent == 0),
          '请填写服务费用比例'));
    }
    FormValidateItem item =
        items.firstWhere((element) => element.result, orElse: () => null);

    if (item != null) {
      BotToast.showText(
          text: '${item.message}',
          onlyOne: true,
          crossPage: false,
          clickClose: true);
      return false;
    } else {
      return true;
    }
  }

  ///计算行产品总数
  int entryTotal(ProductionTaskOrderModel entry) {
    int result = 0;
    entry.colorSizeEntries.forEach((element) {
      result += element.quantity;
    });
    return result;
  }

  ///定金项
  AbstractPayPlanItemModel get depositItem {
    return form.payPlan.payPlanItems.firstWhere(
            (element) => element.moneyType == PayMoneyType.DEPOSIT,
        orElse: () => null);
  }

  ///尾款项
  AbstractPayPlanItemModel get tailItem {
    return form.payPlan.payPlanItems.firstWhere(
            (element) => element.moneyType == PayMoneyType.PHASEONE,
        orElse: () => null);
  }

  ///页面回退回调
  Future<bool> onPop() async {
    return true;
    // if (callBackPop) {
    //   Navigator.of(context).pop(true);
    //   return false;
    // } else {
    //   return true;
    // }
  }

  @override
  void dispose() {
    externalOrderFormState = null;
    super.dispose();
  }
}
