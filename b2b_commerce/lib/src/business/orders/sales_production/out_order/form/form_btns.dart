import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

typedef FormValidateFunc = bool Function();

///外发订单按钮
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
          Expanded(
              flex: 1,
              child: Container(
                height: height,
                child: FlatButton(
                    shape: RoundedRectangleBorder(),
                    disabledColor: Colors.grey,
                    onPressed: () => onSubmit(true, context),
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

  void onSubmit(bool submitAudit, BuildContext context) async {
    if (validateFunc != null && validateFunc()) {
      Function cancelFunc =
          BotToast.showLoading(crossPage: false, clickClose: false);
      BaseResponse response =
          await OutOrderRespository.saveOutOrder(submitAudit, form);
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
}
