import 'package:b2b_commerce/src/business/orders/sales_production/out_order/form/form_components.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class FormSumbitBtn extends StatelessWidget {
  final CooperatorModel form;

  const FormSumbitBtn({Key key, this.form}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(icon: Text('保存'), onPressed: () => onSumbit(context)),
    );
  }

  onSumbit(BuildContext context) async {
    if (validateForm()) {
      Function cancelFunc =
          BotToast.showLoading(crossPage: false, clickClose: false);
      BaseResponse response =
          await CooperatorRepositoryImpl().appendCooperator(form);
      cancelFunc.call();
      if (response != null && response.code == 1) {
        BotToast.showText(text: '添加成功！');
        Navigator.of(context).pop(true);
      } else if (response != null && response.code == 0) {
        BotToast.showText(text: '${response.msg}');
      } else {
        BotToast.showText(text: '操作失败！');
      }
    }
  }

  bool validateForm() {
    List<FormValidateItem> validateItems = [
      FormValidateItem(
          (form.name == null || form.name.trim() == ''), '请填写或选择合作商！'),
      FormValidateItem(
          (form.contactPerson == null || form.contactPerson.trim() == ''),
          '请填写联系人！'),
      FormValidateItem(
          (form.contactPhone == null || form.contactPhone.trim() == ''),
          '请填写联系方式！'),
      FormValidateItem((form.category == null), '请选择身份类型！'),
      FormValidateItem(
          (form.address == null ||
              form.address.city == null ||
              form.address.cityDistrict == null ||
              form.address.region == null ||
              form.address.line1 == null ||
              form.address.line1.trim() == ''),
          '请完善所在区域信息！')
    ];

    FormValidateItem item = validateItems
        .firstWhere((element) => element.result, orElse: () => null);

    if (item == null) {
      return true;
    } else {
      BotToast.showText(
          text: '${item.message}',
          onlyOne: true,
          crossPage: false,
          clickClose: true);
      return false;
    }
  }
}
