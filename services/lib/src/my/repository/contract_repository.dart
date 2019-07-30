import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/my/response/my_response.dart';

class ContractRepository {
  //获取生产订单列表
  Future<ContractResponse> getContractList(
      dynamic data, Map<String, dynamic> parames) async {
    ContractResponse contractResponse;
    Response response;
    try {
      response = await http$.post(UserApis.contractList,
          data: data, queryParameters: parames);
    } on DioError catch (e) {
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      contractResponse = ContractResponse.fromJson(response.data);
    }

    return contractResponse;
  }

  //个人认证
  Future<Certification> personalCertification() async {
    Certification certification;
    Response response;
    try {
      response = await http$.post(UserApis.personalCertification);
    } on DioError catch (e) {
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      certification = Certification.fromJson(response.data);
    }

    return certification;
  }

  //企业认证
  Future<Certification> enterpriseCertification() async {
    Certification certification;
    Response response;
    try {
      response = await http$.post(UserApis.enterpriseCertification);
    } on DioError catch (e) {
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      certification = Certification.fromJson(response.data);
    }

    return certification;
  }

}
