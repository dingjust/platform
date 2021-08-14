import 'package:dio/dio.dart';
import 'package:services/services.dart';
import 'package:services/src/api/business.dart';

///托管服务
class DelegationServiceRepository {
  /// 申请
  static Future<BaseResponse> apply(
      String phoneNumber, String wechatNumber) async {
    try {
      Response response = await http$.post(BusinessApis.delegationApply,
          data: {'wechatNumber': wechatNumber, 'phoneNumber': phoneNumber});
      if (response.statusCode == 200 && response.data != null) {
        return BaseResponse.fromJson(response.data);
      } else
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
