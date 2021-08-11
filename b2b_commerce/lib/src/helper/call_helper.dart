import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:services/services.dart';
import 'package:url_launcher/url_launcher.dart';

///通话帮助类
class CallHelper {
  static void privacyCall(String phone, {BuildContext context}) async {
    if (phone == null || phone == '') {
      throw Exception('号码不能为空');
    }
    Function cancelFunc =
        BotToast.showLoading(clickClose: true, crossPage: false);
    BaseResponse baseResponse = await CallRepository.privacyCall(phone);
    cancelFunc.call();
    if (baseResponse != null && baseResponse.code == 1) {
      //拨打绑定号码
      await launch('tel:${baseResponse.msg}');
    } else {
      //拨打原号码
      await launch('tel:$phone');
    }
  }
}
