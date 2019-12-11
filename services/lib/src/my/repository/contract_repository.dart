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

  Future<ContractTempResponse> getContractTempList(
      dynamic data, Map<String, dynamic> parames) async {
    ContractTempResponse contractTempResponse;
    Response response;
    try {
      response = await http$.post(UserApis.tempList,
          data: data, queryParameters: parames);
    } on DioError catch (e) {
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      contractTempResponse = ContractTempResponse.fromJson(response.data);
    }

    return contractTempResponse;
  }

  Future<List<ContractTemplateModel>> getContractTemplateList(
      dynamic data, Map<String, dynamic> parames) async {
    ContractTempResponse contractTempResponse;
    Response response;
    try {
      response = await http$.post(UserApis.tempList,
          data: data, queryParameters: parames);
    } on DioError catch (e) {
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      contractTempResponse = ContractTempResponse.fromJson(response.data);
    }

    return contractTempResponse.content;
  }

  Future<List<SealModel>> getSealList(
      dynamic data, Map<String, dynamic> parames) async {
    SealResponse sealResponse;
    Response response;
    try {
      response = await http$.post(UserApis.sealList,
          data: data, queryParameters: parames);
    } on DioError catch (e) {
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      sealResponse = SealResponse.fromJson(response.data);
    }

    return sealResponse.content;
  }

  ///创建合同
  Future<Certification> SignaContract(Map data) async {
    Response response;
    try {
      response = await http$.post(UserApis.saveContract,
          data: data);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return Certification.fromJson(response.data);
    } else {
      return null;
    }
  }

  ///开启合同
  Future<Certification> flowContract(String code,String sealCode) async {
    Response response;
    try {
      response = await http$.get(UserApis.flowContract(code,sealCode));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return Certification.fromJson(response.data);
    } else {
      return null;
    }
  }

  //查看合同
  Future<ContractCallbackModel> getContract(String code) async {
    Response response;
    try {
      response = await http$.get(UserApis.getContract(code));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return ContractCallbackModel.fromJson(response.data);
    } else {
      return null;
    }
  }

  //个人认证
  Future<Certification> personalAuthentication(Map data) async {
    Response response;
    try {
      response = await http$.post(UserApis.personalAuthentication,data: data);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return Certification.fromJson(response.data);
    } else {
      return null;
    }
  }

  //企业认证
  Future<Certification> enterpriseAuthentication(Map data) async {
    Response response;
    try {
      response = await http$.post(UserApis.enterpriseAuthentication,data: data);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return Certification.fromJson(response.data);
    } else {
      return null;
    }
  }

  //认证状态
  Future<CertificationState> getAuthenticationState() async {
    Response response;
    try {
      response = await http$.get(UserApis.getAuthenticationState);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return CertificationState.fromJson(response.data);
    } else {
      return null;
    }
  }

  //个人认证信息
  Future<CertificationInfo> getAuthenticationInfo() async {
    Response response;
    try {
      response = await http$.get(UserApis.getAuthenticationInfo);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return CertificationInfo.fromJson(response.data);
    } else {
      return null;
    }
  }

  //企业认证信息
  Future<CertificationInfo> getAuthenticationInfoEnterprise() async {
    Response response;
    try {
      response = await http$.get(UserApis.getAuthenticationEnterprise);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return CertificationInfo.fromJson(response.data);
    } else {
      return null;
    }
  }

  //获取合同PDF文件
  Future<String> getContractPdf(String code) async {
    Response response;
    try {
      response = await http$.get(UserApis.downContract(code));
    } on DioError catch (e) {
      print(e);
    }
    print(response.data);
    if (response != null && response.statusCode == 200) {
      return response.data['data'].toString();
    } else {
      return null;
    }
  }

  //APP下载PDF
  Future downContractPdf(String code) async {
    Response response;
    try {
      response = await http$.get(UserApis.downContractInApp(code));
    } on DioError catch (e) {
      print(e);
    }
    print(response.data);
    if (response != null && response.statusCode == 200) {
      return response.data;
    } else {
      return null;
    }
  }

  //获取合同PDF的model
  Future<SearchResultModel> getContractPdfMedia(String code) async {
    Response response;
    try {
      response = await http$.get(UserApis.getContractPdfMedia(code));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return SearchResultModel.fromJson(response.data);
    } else {
      return null;
    }
  }

  //撤销合同
  Future<SearchResultModel> revokeContract(String code) async {
    Response response;
    try {
      response = await http$.get(UserApis.revokeContract(code));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return SearchResultModel.fromJson(response.data);
    } else {
      return null;
    }
  }

  //拒签合同
  Future<SearchResultModel> rejectContract(String code) async {
    Response response;
    try {
      response = await http$.get(UserApis.rejectContract(code));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return SearchResultModel.fromJson(response.data);
    } else {
      return null;
    }
  }

  Future<CertificationContractCount> getContractCount() async {
    Response response;
    try {
      response = await http$.post(UserApis.getContractCount,data: {});
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return CertificationContractCount.fromJson(response.data);
    } else {
      return null;
    }
  }

  ///合同订单验证
  Future<SearchResultModel> validateContractOrders(
      {dynamic data, Map<String, dynamic> parames}) async {
    if(data == null){
      data = {};
    }
    if(parames == null){
      parames = {};
    }

    Response response;
    try {
      response = await http$.post(UserApis.contractOrdersValidate,
          data: data, queryParameters: parames);
    } on DioError catch (e) {
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      return SearchResultModel.fromJson(response.data);
    } else {
      return null;
    }
  }

}
