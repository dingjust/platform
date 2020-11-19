import 'package:b2b_commerce/src/_shared/payplan/payplan_select_page.dart';
import 'package:b2b_commerce/src/_shared/widgets/employee_select.dart';
import 'package:b2b_commerce/src/business/cooperator/cooperators_page.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'form_btns.dart';
import 'form_components.dart';

///外发订单表单页
class OutOrderForm extends StatefulWidget {
  @override
  _OutOrderFormState createState() => _OutOrderFormState();
}

class _OutOrderFormState extends State<OutOrderForm> {
  SalesProductionOrderModel form;

  @override
  void initState() {
    UserModel currentUser = UserBLoC.instance.currentUser;
    form = SalesProductionOrderModel(
        sendAuditNeeded: false,
        attachments: [],
        merchandiser:
            B2BCustomerModel(id: currentUser.id, name: currentUser.name));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              '创建外发订单',
              style: TextStyle(
                  color: Color(0xff455a64), fontWeight: FontWeight.bold),
            ),
            elevation: 0.5,
          ),
          body: Container(
            child: ListView(
              children: <Widget>[
                _buildOutTypeRadio(),
                FormCooperatorsSelect(
                  onCooperatorSelect: onCooperatorSelect,
                  value: form.targetCooperator,
                ),
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
                FormPayPlanSelect(
                  onPayPlanSelect: onPayPlanSelect,
                  value: form.payPlan,
                ),
                _buildPersonnel(),
                _buildRemarks(),
                Container(
                  height: 60,
                ),
              ],
            ),
          ),
          bottomNavigationBar: FormBtns(
            form: form,
            validateFunc: validateForm,
          ),
        ),
        onWillPop: onPop);
  }

  ///管理方式选择行
  Widget _buildOutTypeRadio() {
    return FormBlock(
      children: [
        FormLabel(
          '订单管理方式',
          suffix: IconButton(
              icon: Icon(
                Icons.help,
                color: Color(0xffff1744),
              ),
              onPressed: showCooperatorModeHelp),
        ),
        Row(children: [
          Container(),
          for (ManagementMode val in ManagementMode.values) _typeRadio(val)
        ])
      ],
    );
  }

  ///管理方式单选项
  Widget _typeRadio(ManagementMode val) {
    return Expanded(
      child: Row(
        children: [
          Radio(
            value: val,
            groupValue: form.managementMode,
            onChanged: (ManagementMode value) {
              setState(() {
                form.managementMode = value;
              });
            },
          ),
          Text('${ManagementModeLocalizedMap[val]}'),
        ],
      ),
    );
  }

  ///人员设置
  Widget _buildPersonnel() {
    return FormBlock(
      children: [
        FormLabel('人员设置'),
        FormTitle('跟单员：'),
        ListTile(
          title: Text(
            '${form?.merchandiser?.name ?? '无'}',
            style: TextStyle(color: Colors.grey),
          ),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
        Divider(),
        FormTitle('审核：'),
        Container(
          child: Row(
            children: [
              Checkbox(
                  value: form.sendAuditNeeded,
                  onChanged: (val) {
                    setState(() {
                      form.sendAuditNeeded = val;
                    });
                  }),
              Text('需要审核'),
            ],
          ),
        ),
        _buildApproversRow()
      ],
    );
  }

  Widget _buildApproversRow() {
    String title = '请选择审核人员';

    if (form.sendApprovers != null && form.sendApprovers.isNotEmpty) {
      title = form.sendApprovers.map((e) => e.name).toString();
    }

    return form.sendAuditNeeded
        ? ListTile(
            title: Text(
              '$title',
              style: TextStyle(color: Colors.grey),
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: onSelectApprovers,
          )
        : Container();
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
          child: EditableAttachments(
            list: form.attachments,
            maxNum: 5,
          ),
        ),
      ],
    );
  }

  ///选择审核人员
  void onSelectApprovers() async {
    List<B2BCustomerModel> b2bCusomers =
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EmployeeSelectPage(
              multi: true,
              max: 5,
              selected:
              form.sendApprovers != null ? form.sendApprovers : [],
            )));
    setState(() {
      form.sendApprovers = b2bCusomers;
    });
  }

  ///合作商选择
  void onCooperatorSelect() async {
    List<CooperatorModel> cooperators = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CooperatorsPage(
                  selectedData: form.targetCooperator != null
                      ? [form.targetCooperator]
                      : [],
                  selectingMode: true,
                  categories: [CooperatorCategory.SUPPLIER],
                  max: 1,
                )));
    if (cooperators != null) {
      setState(() {
        if (cooperators.isNotEmpty) {
          form.targetCooperator = cooperators.first;
        } else {
          form.targetCooperator = null;
        }
      });
    }
  }

  ///财务选择
  void onPayPlanSelect() async {
    CompanyPayPlanModel returnResult =
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            PayPlanSelectPage(
              selectedModel: form.payPlan,
            )));
    if (returnResult != null) {
      setState(() {
        form.payPlan = returnResult;
      });
    }
  }

  ///订单管理方式帮助提示弹窗
  void showCooperatorModeHelp() {
    const TextStyle textStyle =
    TextStyle(color: Color(0xffff1744), fontSize: 16);

    const TextStyle mainTextStyle = TextStyle(color: Colors.black54);

    BotToast.showEnhancedWidget(
        onlyOne: true,
        duration: null,
        clickClose: true,
        backgroundColor: Colors.black38,
        allowClick: false,
        toastBuilder: (cancelFunc) =>
            AlertDialog(
              content: Container(
                height: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text('订单管理方式'),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                              text: TextSpan(
                                  text: '协同订单：',
                                  style: textStyle,
                                  children: [
                                    TextSpan(
                                        text:
                                        '是由甲乙双方共同配合完成的订单管理方式，订单需要双方确认，“生产进度”，“发货”，等由乙方完成，任何一方的缺席订单无法顺利完成。',
                                        style: mainTextStyle)
                                  ])),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                              text: TextSpan(
                                  text: '自管订单：',
                                  style: textStyle,
                                  children: [
                                    TextSpan(
                                        text:
                                        '是有甲乙任何一方单方面完成订单的所有流程，不需要双方共同参与，此类订单适合自我单方面管理订单。',
                                        style: mainTextStyle)
                                  ])),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ));
  }

  ///订单行校验
  List<FormValidateItem> _validateEntry(ProductionTaskOrderModel entry) {
    return [
      FormValidateItem(
          (entry.unitPrice == null || entry.unitPrice <= 0), '请填写发单价格'),
      FormValidateItem((entry.shippingAddress == null), '请选择发货地址'),
      FormValidateItem((entry.deliveryDate == null), '请选择交货日期'),
      FormValidateItem((entry.progressPlan == null), '节点方案不能为空'),
      FormValidateItem((entry.quantity < 1), '数量不能少于1'),
    ];
  }

  ///表单校验
  bool validateForm() {
    List<FormValidateItem> items = [
      FormValidateItem(form.managementMode == null, '请选择管理方式'),
      FormValidateItem(
          (form.taskOrderEntries == null || form.taskOrderEntries.isEmpty),
          '请选择工单'),
      FormValidateItem((form.targetCooperator == null), '请选择合作商'),
      FormValidateItem(form.cooperationMode == null, '请选择合作方式'),
      FormValidateItem(form.invoiceNeeded == null, '请选择是否开票'),
      FormValidateItem(
          ((form.invoiceNeeded ?? false) && form.invoiceTaxPoint == 0),
          '请选择税点'),
      FormValidateItem(form.freightPayer == null, '请选择运费承担方'),
      FormValidateItem(form.payPlan == null, '请选择账务方案'),
      FormValidateItem(form.merchandiser == null, '跟单员不能为空'),
      FormValidateItem(
          form.sendAuditNeeded &&
              (form.sendApprovers == null || form.sendApprovers.isEmpty),
          '请选择审核人'),
    ];

    //行校验
    if (form.taskOrderEntries != null) {
      form.taskOrderEntries.forEach((element) {
        items.addAll(_validateEntry(element));
      });
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
}
