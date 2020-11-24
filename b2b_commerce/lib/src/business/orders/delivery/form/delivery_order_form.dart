import 'package:b2b_commerce/src/business/cooperator/cooperators_page.dart';
import 'package:b2b_commerce/src/business/orders/sales_production/out_order/form/form_components.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

///出货单表单
class DeliveryOrderForm extends StatefulWidget {
  @override
  _DeliveryOrderFormState createState() => _DeliveryOrderFormState();
}

class _DeliveryOrderFormState extends State<DeliveryOrderForm> {
  FastShippingSheetModel form;

  TextEditingController remarksController;
  TextEditingController titleController;

  FocusNode remarksNode;
  FocusNode titleNode;

  @override
  void initState() {
    form = FastShippingSheetModel(
      medias: [],
    );
    remarksController = TextEditingController(text: form?.remarks ?? '');
    titleController = TextEditingController(text: form?.title ?? '');

    remarksNode = FocusNode();
    titleNode = FocusNode();

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
                  value: form.cooperator,
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
    return FormBlock(
      children: [
        FormLabel('标题'),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextFieldBorderComponent(
            padding: EdgeInsets.all(0),
            hideDivider: true,
            isRequired: true,
            textAlign: TextAlign.left,
            hintText: '请输入标题',
            controller: titleController,
            focusNode: titleNode,
            onChanged: (value) {
              form.title = value;
            },
          ),
        ),
        Divider(),
        FormLabel('单据'),
        Container(
          color: Colors.white,
          child: EditableAttachments(
            list: form.medias,
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
            hintText: '请输入备注',
            controller: remarksController,
            maxLength: 250,
            focusNode: remarksNode,
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
                  selectedData:
                      form.cooperator != null ? [form.cooperator] : [],
                  selectingMode: true,
                  max: 1,
                )));
    if (cooperators != null) {
      setState(() {
        if (cooperators.isNotEmpty) {
          form.cooperator = cooperators.first;
        } else {
          form.cooperator = null;
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

  void _onSubmit() async {
    if (validateForm()) {
      Function cancelFunc =
      BotToast.showLoading(crossPage: false, clickClose: true);
      BaseResponse response = await DeliveryOrderRespository.crerate(form);
      cancelFunc.call();
      if (response != null && response.code == 1) {
        BotToast.showText(text: '提交成功');
        //跳转到
        Navigator.of(context).pushReplacementNamed(
            AppRoutes.ROUTE_DELIVERY_ORDER_DETAIL,
            arguments: {'id': response.data, 'needRefresh': true});
      } else if (response != null && response.code == 0) {
        BotToast.showText(text: '${response.msg}');
      } else {
        BotToast.showText(text: '操作失败');
      }
    }
  }

  ///表单校验
  bool validateForm() {
    List<FormValidateItem> items = [
      FormValidateItem((form.title == null || form.title == ''), '请填写标题'),
      FormValidateItem((form.medias.isEmpty), '请上传单据'),
      FormValidateItem((form.cooperator == null), '请选择合作商'),
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
