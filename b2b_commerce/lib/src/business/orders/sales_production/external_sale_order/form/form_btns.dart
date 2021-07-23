import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:common_utils/common_utils.dart';
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
  final SalesProductionOrderModel form;

  final double height;

  final FormValidateFunc validateFunc;

  const FormBtns({Key key, this.height = 55, this.validateFunc, this.form})
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
          // Expanded(
          //     flex: 1,
          //     child: Container(
          //       height: height,
          //       child: FlatButton(
          //           shape: RoundedRectangleBorder(),
          //           disabledColor: Colors.grey,
          //           onPressed: () => onSubmit(false, context),
          //           child: Text('保存',
          //               style: TextStyle(
          //                 fontSize: 14,
          //                 color: Colors.red,
          //               ))),
          //     )),
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
                    onPressed: () => onSubmit(true, context),
                    color: Constants.THEME_COLOR_MAIN,
                    child: Text(form.id == null ? '创建' : '修改',
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
    form.taskOrderEntries
        .where((element) => element.unitPrice != null && element.unitPrice > 0)
        .forEach((element) {
      int amount = 0;
      element.colorSizeEntries.forEach((entry) {
        amount += entry.quantity;
      });
      result += amount * element?.unitPrice ?? 0;
    });
    return result;
  }

  void onSubmit(bool submitAudit, BuildContext context) async {
    if (validateFunc != null && validateFunc()) {
      Function cancelFunc =
          BotToast.showLoading(crossPage: false, clickClose: true);

      OrderProgressPlanModel orderProgressPlan = await getOrderProgressPlan();
      //订单行设置默认节点方案
      form.taskOrderEntries.forEach((element) {
        element.progressPlan = orderProgressPlan;
      });

      LogUtil.v(form.toJson());

      BaseResponse response =
          // await OutOrderRespository.saveOutOrder(submitAudit, form);
          await ExternalSaleOrderRespository.save(submitAudit, form);
      cancelFunc.call();
      if (response != null && response.code == 1) {
        BotToast.showText(text: '提交成功');
        //跳转到
        Navigator.of(context).pushReplacementNamed(
            AppRoutes.ROUTE_EXTERNAL_SALE_ORDERS_DETAIL,
            arguments: {'id': response.data, 'title': '外发订单明细'});
      } else if (response != null && response.code == 0) {
        BotToast.showText(text: '${response.msg}');
      } else {
        BotToast.showText(text: '操作失败');
      }
    }
  }

  ///获取节点方案
  Future<OrderProgressPlanModel> getOrderProgressPlan() async {
    OrderProgressPlanModel orderProgressPlan;
    //获取节点方案
    OrderProgressPlanResponse orderProgressPlanResponse =
    await OrderProgressPlanRepository.orderProgressPlans();
    //默认节点方案
    OrderProgressPlanModel defaultPlan = orderProgressPlanResponse?.content
        ?.firstWhere((element) => element.name == DEFAULT_PROGRESS_PLAN_NAME,
        orElse: () => null);

    if (defaultPlan == null) {
      //没有则创建
      ProgressPhaseResponse progressPhaseResponse =
      await OrderProgressPlanRepository.progressPhase();
      if (progressPhaseResponse == null) {
        BotToast.showText(text: '获取节点信息失败，请重试');
        throw Exception('获取节点信息失败');
      }
      const phase_name_strs = ['裁剪', '车缝', '后整', '验货'];
      //节点数组
      List<ProgressPhaseModel> phases = progressPhaseResponse.content
          .where((phase) => phase_name_strs.contains(phase.name))
          .toList();
      phases.sort((phase1, phase2) => phase1.sequence - phase2.sequence);

      List<ProductionProgressModel> productionProgresses = phases
          .map((e) => ProductionProgressModel(
              progressPhase: e,
              sequence: e.sequence,
              warningDays: DEFAULT_WARNING_DAY))
          .toList();

      OrderProgressPlanModel orderProgressPlanModel = OrderProgressPlanModel(
          name: DEFAULT_PROGRESS_PLAN_NAME,
          productionProgresses: productionProgresses,
          remarks: '默认生成');
      orderProgressPlan = orderProgressPlanModel;
      //保存默认节点方案
      BaseResponse result =
          await OrderProgressPlanRepository.create(orderProgressPlan);
    } else {
      //移除方案id
      defaultPlan.id = null;
      orderProgressPlan = defaultPlan;
    }
    return orderProgressPlan;
  }
}
