import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'alipay_response.g.dart';

@JsonSerializable()
class AlipayResponse {
  AlipayResponse({this.resultStatus, this.result, this.memo});

  String resultStatus;

  Result result;

  String memo;

  factory AlipayResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$AlipayResponseFromJson(json);

  static Map<String, dynamic> toJson(AlipayResponse model) =>
      model == null ? null : _$AlipayResponseToJson(model);

  static AlipayResponse generate(Map payResponse) {
    AlipayResponse alipayResponse = AlipayResponse();
    alipayResponse.memo = payResponse['memo'];
    alipayResponse.resultStatus = payResponse['resultStatus'];
    alipayResponse.result = Result.fromJson(json.decode(payResponse['result']));
    return alipayResponse;
  }
}

@JsonSerializable()
class Result {
  ///商户网站唯一订单号
  String out_trade_no;

  ///该交易在支付宝系统中的交易流水号。最长64位。
  String trade_no;

  ///支付宝分配给开发者的应用Id
  String app_id;

  ///该笔订单的资金总额，单位为RMB-Yuan
  String total_amount;

  ///收款支付宝账号对应的支付宝唯一用户号。以2088开头的纯16位数字
  String seller_id;

  ///	处理结果的描述，信息来自于code返回结果的描述
  String msg;

  ///编码格式
  String charset;

  ///时间
  String timestamp;

  ///结果码
  String code;

  Result(
      {this.out_trade_no,
      this.trade_no,
      this.app_id,
      this.total_amount,
      this.seller_id,
      this.msg,
      this.charset,
      this.timestamp,
      this.code});

  factory Result.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ResultFromJson(json);

  static Map<String, dynamic> toJson(Result result) =>
      result == null ? null : _$ResultToJson(result);
}
