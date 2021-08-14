import 'package:dio/dio.dart';

import '../../../services.dart';

///通话
class CallRepository {
  ///通过隐私保护通话
  static Future<BaseResponse> privacyCall(String phone) async {
    Response response;
    try {
      response = await http$.get(Apis.privacyCall(phone));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return BaseResponse.fromJson(response.data);
    } else {
      return null;
    }
  }
}
