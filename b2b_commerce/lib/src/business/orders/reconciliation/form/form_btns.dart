import 'package:b2b_commerce/src/business/orders/sales_production/external_sale_order/form/form_components.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

typedef FormValidateFunc = bool Function();

const String DEFAULT_PROGRESS_PLAN_NAME = '默认节点方案';

///默认警告天数
const int DEFAULT_WARNING_DAY = 3;

///外接订单按钮
class FormBtns extends StatelessWidget {
  final FastReconciliationSheetModel form;

  final double height;

  final FormValidateFunc validateFunc;

  ///原来对账单（修改需要作废原来对账单）
  final int oldFormId;

  const FormBtns(
      {Key key, this.height = 55, this.validateFunc, this.form, this.oldFormId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Container(
              width: 200,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: RichText(
                  text: TextSpan(
                      text: '总额：',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black87),
                      children: [
                    TextSpan(
                        text: '￥${totalAmount().toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.red, fontSize: 20))
                  ]))),
          Expanded(
              flex: 1,
              child: Container(
                height: height,
                child: FlatButton(
                    shape: RoundedRectangleBorder(),
                    disabledColor: Colors.grey,
                    onPressed: () => onSubmit(context),
                    color: Constants.THEME_COLOR_MAIN,
                    child: Text(form.id != null ? '修改' : '创建',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ))),
              ))
        ],
      ),
    );
  }

  //总额
  double totalAmount() {
    double result = 0;
    form.entries.forEach((element) {
      result += element.settlementAmount ?? 0;
    });
    form.additionalCharges.forEach((element) {
      result += element.amount ?? 0;
    });
    return result;
  }

  ///订单行校验
  List<FormValidateItem> _validateEntry(
      FastReconciliationSheetEntryModel entry) {
    return [
      FormValidateItem((entry.cutQuantity == null || entry.cutQuantity <= 0),
          '产品${form.entries.indexOf(entry) + 1}：裁数不能为空'),
      FormValidateItem((entry.loanAmount == null),
          '产品${form.entries.indexOf(entry) + 1}：货款金额不能为空'),
      FormValidateItem((entry.deliveryDate == null),
          '产品${form.entries.indexOf(entry) + 1}：请选择交货日期'),
      FormValidateItem(
          (entry.settlementAmount == null || entry.settlementAmount <= 0),
          '产品${form.entries.indexOf(entry) + 1}：结算金额不能为少于0'),
    ];
  }

  ///表单校验
  bool validateForm() {
    List<FormValidateItem> items = [
      FormValidateItem((totalAmount() <= 0), '结算金额要求大于0'),
    ];

    //行校验
    if (form.entries != null) {
      form.entries.forEach((element) {
        items.addAll(_validateEntry(element));
      });
    }

    form.additionalCharges.forEach((element) {
      items.addAll([
        FormValidateItem((element.remarks == null || element.remarks == ''),
            '附加项${form.additionalCharges.indexOf(element) + 1}：名称不能为空'),
      ]);
    });

    FormValidateItem item =
        items.firstWhere((element) => element.result, orElse: () => null);

    if (item != null) {
      BotToast.showText(
          text: '${item.message}',
          onlyOne: true,
          crossPage: false,
          align: Alignment.center,
          clickClose: true);
      return false;
    } else {
      return true;
    }
  }

  void onSubmit(BuildContext context) async {
    if (validateForm()) {
      if (form.id == null) {
        if (oldFormId != null) {
          _onRecreate(context);
        } else {
          //新创建
          _onCreate(context);
        }
      } else {
        _onUpdate(context);
      }
    }
  }

  void _onCreate(BuildContext context) async {
    Function cancelFunc =
        BotToast.showLoading(crossPage: false, clickClose: true);

    //   OrderProgressPlanModel orderProgressPlan = await getOrderProgressPlan();
    //   //订单行设置默认节点方案
    //   form.taskOrderEntries.forEach((element) {
    //     element.progressPlan = orderProgressPlan;
    //   });

    //   LogUtil.v(form.toJson());

    BaseResponse response =
        // await OutOrderRespository.saveOutOrder(submitAudit, form);
        await ReconciliationOrderRespository.create(form);
    cancelFunc.call();
    if (response != null && response.code == 1) {
      BotToast.showText(text: '提交成功');
      // 返回
      Navigator.of(context).pop(true);
    } else if (response != null && response.code == 0) {
      BotToast.showText(text: '${response.msg}');
    } else {
      BotToast.showText(text: '操作失败');
    }
  }

  void _onUpdate(BuildContext context) async {
    Function cancelFunc =
        BotToast.showLoading(crossPage: false, clickClose: true);

    BaseResponse response = await ReconciliationOrderRespository.update(form);
    cancelFunc.call();
    if (response != null && response.code == 1) {
      BotToast.showText(text: '修改成功');
      // 返回
      Navigator.of(context).pop(true);
    } else if (response != null && response.code == 0) {
      BotToast.showText(text: '${response.msg}');
    } else {
      BotToast.showText(text: '修改失败');
    }
  }

  ///修改创建-取消原来对账单
  void _onRecreate(BuildContext context) async {
    Function cancelFunc =
        BotToast.showLoading(crossPage: false, clickClose: true);
    //先创建新的，成功后作废原来旧的
    BaseResponse response = await ReconciliationOrderRespository.create(form);
    if (response != null && response.code == 1) {
      BotToast.showText(text: '创建成功');
      //取消旧的
      BaseResponse cancelRes =
          await ReconciliationOrderRespository.cancel(oldFormId);
      cancelFunc.call();
      if (cancelRes == null || cancelRes.code == 0) {
        print('取消原有对账单shibai');
      }
      // 返回
      Navigator.of(context).pop(true);
    } else if (response != null && response.code == 0) {
      BotToast.showText(text: '${response.msg}');
    } else {
      BotToast.showText(text: '操作失败');
    }
  }
}
