import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:services/services.dart';
import 'package:http_parser/http_parser.dart';

///印章
class SealRepository {
  ///创建印章
  static Future<BaseResponse> create(ByteData data, String name) async {
    BaseResponse baseResponse;
    Response response;

    try {
      //上传图片

      MultipartFile multipartFile = await MultipartFile.fromBytes(
          data.buffer.asInt8List(),
          filename: "file",
          contentType: MediaType.parse('image/png'));
      FormData formData = FormData.fromMap({
        "file": multipartFile,
      });
      Response<Map<String, dynamic>> uploadResponse = await http$.post(
        Apis.upload(),
        data: formData,
      );

      if (uploadResponse == null ||
          uploadResponse.statusCode != 200 ||
          uploadResponse?.data['id'] == null) {
        return null;
      }

      response = await http$.post(
        UserApis.sealSave,
        data: {
          'name': name,
          'media': {'id': uploadResponse.data['id']}
        },
      );
    } on Exception catch (e) {
      print(e);
      return null;
    }

    if (response != null && response.statusCode == 200) {
      baseResponse = BaseResponse.fromJson(response.data);
    }

    return baseResponse;
  }
}
