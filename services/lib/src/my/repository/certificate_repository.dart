import 'package:dio/dio.dart';

import '../../../services.dart';

///认证
class CertificateRepository {
  ///详情
  static Future<BaseResponse> get(String code) async {
    Response response;
    try {
      response = await http$.get(
        UserApis.getCompanyCertificateInfo(code),
      );
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      BaseResponse baseResponse = BaseResponse.fromJson(response.data);
      return baseResponse;
    }
    return null;
  }
}
