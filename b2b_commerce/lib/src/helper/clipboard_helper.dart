import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

///粘贴板
class ClipboardHelper {
  String text;

  GlobalKey<NavigatorState> navigatorKey;

  void setNavigatorKey(GlobalKey<NavigatorState> key) {
    navigatorKey = key;
  }

  void setText(String val) {
    text = val;
  }

  ///获取粘贴板字符
  Future<String> getClipboardText({BuildContext context}) async {
    ClipboardData data;
    try {
      for (int i = 0; i < 3; i++) {
        //3次重试
        data = await Clipboard.getData(Clipboard.kTextPlain);
        if (data != null) {
          break;
        }
      }
    } catch (e) {
      print('[钉单]粘贴板读取错误');
    }
    if (data != null) {
      String newVal = data.text;
      if (text != newVal) {
        handleClipboardChange(newVal, context: context);
      }
      text = newVal;
    }
    return text;
  }

  ///处理粘贴板字符值改变
  void handleClipboardChange(String val,
      {BuildContext context, GlobalKey<NavigatorState> navigatorKey}) {
    //校验是否钉单开头
    val = val.trim();
    if (val.startsWith('钉单')) {
      //操作类型
      String type = val.substring(val.indexOf('【') + 1, val.indexOf('】'));
      switch (type) {
        case '快速导入订单':
          handleOrderImport(val, context: context);
      }
    }
  }

  ///处理订单导入
  void handleOrderImport(String val, {BuildContext context}) async {
    //获取编码值
    String code = val.substring(val.indexOf('⇤') + 1, val.indexOf('⇥'));
    if (code != null && code.isNotEmpty) {
      //获取订单
      BaseResponse baseResponse =
          await ExternalSaleOrderRespository().qrCodePreview(code);

      if (baseResponse != null) {
        //订单没导入
        if (baseResponse.code == 1) {
          SalesProductionOrderModel model =
              SalesProductionOrderModel.fromJson(baseResponse.data);
          showOrderImportDialog(model, code, context: context);
        } else if (baseResponse.code == 0 && baseResponse.msg != null) {
          //订单已导入
          // showOrderDetailDialog(baseResponse.msg);
        }
      }
    }
  }

  ///订单导入弹窗
  void showOrderImportDialog(SalesProductionOrderModel order, String code,
      {BuildContext context,
      VoidCallback cancel,
      VoidCallback confirm,
      VoidCallback backgroundReturn}) {
    BotToast.showAnimationWidget(
        clickClose: false,
        allowClick: false,
        onlyOne: true,
        crossPage: true,
        backButtonBehavior: BackButtonBehavior.none,
        wrapToastAnimation: (controller, cancel, child) => Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    cancel();
                    backgroundReturn?.call();
                  },
                  child: AnimatedBuilder(
                    builder: (_, child) => Opacity(
                      opacity: controller.value,
                      child: child,
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.black26),
                      child: SizedBox.expand(),
                    ),
                    animation: controller,
                  ),
                ),
                _CustomOffsetAnimation(
                  controller: controller,
                  child: child,
                )
              ],
            ),
        toastBuilder: (cancelFunc) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              title: const Text('订单导入'),
              content: Container(
                height: 280,
                child: Column(
                  children: [
                    _Row(
                      title: '订单号：',
                      val: '${order.code}',
                    ),
                    _Row(
                      title: '合作商：',
                      val: '${order?.originCooperator?.name ?? ''}',
                    ),
                    _Row(
                      title: '合作方式：',
                      val:
                          '${CooperationModeLocalizedMap[order?.cooperationMode]}',
                    ),
                    _Row(
                      title: '是否开票：',
                      val: order.invoiceNeeded ? '开发票' : '不开发票',
                    ),
                    _Row(
                      title: '订单总数量：',
                      val: '${order.totalQuantity}',
                    ),
                    _Row(
                      title: '订单总金额：',
                      val: '${order.totalAmount.toStringAsFixed(2)}',
                    ),
                    TextButton(
                        onPressed: () {
                          if (navigatorKey != null) {
                            cancelFunc.call();
                            navigatorKey.currentState.pushNamed(
                                AppRoutes.ROUTE_ORDER_IMPORT,
                                arguments: {'code': code});
                          }
                          ;
                        },
                        child: Text('查看详情'))
                  ],
                ),
              ),
        ),
        animationDuration: Duration(milliseconds: 300));
  }

  ///订单详情弹窗
  void showOrderDetailDialog(String code,
      {BuildContext context,
        VoidCallback cancel,
        VoidCallback confirm,
        VoidCallback backgroundReturn}) {
    BotToast.showAnimationWidget(
        clickClose: false,
        allowClick: false,
        onlyOne: true,
        crossPage: true,
        backButtonBehavior: BackButtonBehavior.none,
        wrapToastAnimation: (controller, cancel, child) =>
            Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    cancel();
                    backgroundReturn?.call();
                  },
                  child: AnimatedBuilder(
                    builder: (_, child) =>
                        Opacity(
                          opacity: controller.value,
                          child: child,
                        ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.black26),
                      child: SizedBox.expand(),
                    ),
                    animation: controller,
                  ),
                ),
                _CustomOffsetAnimation(
                  controller: controller,
                  child: child,
                )
              ],
            ),
        toastBuilder: (cancelFunc) =>
            AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              title: const Text('检测到订单'),
              content: Container(
                height: 280,
                child: Column(
                  children: [
                    _Row(
                      title: '订单号：',
                      val: '$code',
                    ),
                    TextButton(
                        onPressed: () async {
                          if (navigatorKey != null) {
                            cancelFunc.call();

                            int id = await queryIdFromList(code);
                            if (id != null) {
                              navigatorKey.currentState.pushNamed(
                                  AppRoutes.ROUTE_EXTERNAL_SALE_ORDERS_DETAIL,
                                  arguments: {'code': code});
                            }
                          }
                        },
                        child: Text('查看详情'))
                  ],
                ),
              ),
            ),
        animationDuration: Duration(milliseconds: 300));
  }

  Future<int> queryIdFromList(String code) async {
    Response<Map<String, dynamic>> response;

    try {
      response = await http$.post('/{baseSiteId}/out/order/search', data: {
        'name': code
      }, queryParameters: {
        'size': 10,
      });
    } on DioError catch (e) {
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      try {
        List<dynamic> content = response.data['content'];
        var result = content.firstWhere((element) => element['code'] == code,
            orElse: () => null);
        if (result != null) {
          print('=====================${result['id']}');
          return result['id'];
        }
      } catch (e) {
        print(e);
      }
    }
    return null;
  }
}

class _Row extends StatelessWidget {
  final String title;

  final String val;

  final TextStyle style;

  const _Row(
      {Key key,
      this.title,
      this.val,
      this.style = const TextStyle(fontSize: 12)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.grey[300], width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title',
            style: style,
          ),
          Expanded(
            child: Text(
              '$val',
              style: style,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}

class _CustomOffsetAnimation extends StatefulWidget {
  final AnimationController controller;
  final Widget child;

  const _CustomOffsetAnimation({Key key, this.controller, this.child})
      : super(key: key);

  @override
  __CustomOffsetAnimationState createState() => __CustomOffsetAnimationState();
}

class __CustomOffsetAnimationState extends State<_CustomOffsetAnimation> {
  Tween<Offset> tweenOffset;
  Tween<double> tweenScale;

  Animation<double> animation;

  @override
  void initState() {
    tweenOffset = Tween<Offset>(
      begin: const Offset(0.0, 0.8),
      end: Offset.zero,
    );
    tweenScale = Tween<double>(begin: 0.3, end: 1.0);
    animation =
        CurvedAnimation(parent: widget.controller, curve: Curves.decelerate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      child: widget.child,
      animation: widget.controller,
      builder: (BuildContext context, Widget child) {
        return FractionalTranslation(
            translation: tweenOffset.evaluate(animation),
            child: ClipRect(
              child: Transform.scale(
                scale: tweenScale.evaluate(animation),
                child: Opacity(
                  child: child,
                  opacity: animation.value,
                ),
              ),
            ));
      },
    );
  }
}
