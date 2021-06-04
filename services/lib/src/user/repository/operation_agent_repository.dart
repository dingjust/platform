import 'package:dio/dio.dart';
import 'package:services/services.dart';
import 'package:services/src/api/business.dart';

///代运营服务
class OperationAgentRepository {
  /// 申请
  static Future<BaseResponse> apply() async {
    try {
      Response response =
          await http$.post(BusinessApis.operationAgentServiceApply, data: {});
      if (response.statusCode == 200 && response.data != null) {
        return BaseResponse.fromJson(response.data);
      } else
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  ///获取状态
  static Future<BaseResponse> getInfo() async {
    try {
      Response response = await http$.get(BusinessApis.operationAgentInfo);
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
