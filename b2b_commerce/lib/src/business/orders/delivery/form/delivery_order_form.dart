import 'package:b2b_commerce/src/business/cooperator/cooperators_page.dart';
import 'package:b2b_commerce/src/business/orders/sales_production/out_order/form/form_components.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:core/core.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

///出货单表单
class DeliveryOrderForm extends StatefulWidget {
  @override
  _DeliveryOrderFormState createState() => _DeliveryOrderFormState();
}

class _DeliveryOrderFormState extends State<DeliveryOrderForm> {
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
              '创建出货单',
              style: TextStyle(
                  color: Color(0xff455a64), fontWeight: FontWeight.bold),
            ),
            elevation: 0.5,
          ),
          body: Container(
            child: ListView(
              children: <Widget>[
                FormCooperatorsSelect(
                  onCooperatorSelect: onCooperatorSelect,
                  value: form.targetCooperator,
                ),
                _buildRemarks(),
                Container(
                  height: 60,
                ),
              ],
            ),
          ),
          bottomNavigationBar: _btn(),
        ),
        onWillPop: onPop);
  }

  Widget _buildRemarks() {
    TextEditingController textEditingController =
        TextEditingController(text: form?.remarks ?? '');
    FocusNode focusNode = FocusNode();

    return FormBlock(
      children: [
        FormLabel('单据'),
        Container(
          color: Colors.white,
          child: EditableAttachments(
            list: form.attachments,
            maxNum: 20,
          ),
        ),
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
            maxLength: 250,
            focusNode: focusNode,
            onChanged: (value) {
              form.remarks = value;
            },
          ),
        ),
        Divider(),
      ],
    );
  }

  ///合作商选择
  void onCooperatorSelect() async {
    List<CooperatorModel> cooperators = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CooperatorsPage(
                  selectedData: form.targetCooperator != null
                      ? [form.targetCooperator]
                      : [],
                  selectingMode: true,
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

  Widget _btn({double height = 55}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                height: height,
                child: FlatButton(
                    shape: RoundedRectangleBorder(),
                    disabledColor: Colors.grey,
                    onPressed: _onSubmit,
                    color: Constants.THEME_COLOR_MAIN,
                    child: Text('提交',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ))),
              ))
        ],
      ),
    );
  }

  void _onSubmit() {}

  ///表单校验
  bool validateForm() {
    List<FormValidateItem> items = [
      FormValidateItem(form.managementMode == null, '请选择管理方式'),
    ];

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
