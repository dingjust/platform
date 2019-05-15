// import 'package:json_annotation/json_annotation.dart';

// part 'error_response.g.dart';

// @JsonSerializable()
// class AlipayResponse {
//   AlipayResponse();

//   factory AlipayResponse.fromJson(Map<String, dynamic> json) =>
//       _$AlipayResponseFromJson(json);

//   static Map<String, dynamic> toJson(AlipayResponse model) =>
//       _$AlipayResponseToJson(model);


// }

// @JsonSerializable()
// class Result {

//   ///商户网站唯一订单号	
//   String out_trade_no;

//   ///该交易在支付宝系统中的交易流水号。最长64位。	
//   String trade_no;

//   ///支付宝分配给开发者的应用Id
//   String app_id;

//   ///该笔订单的资金总额，单位为RMB-Yuan
//   String total_amount;

//   ///收款支付宝账号对应的支付宝唯一用户号。以2088开头的纯16位数字
//   String seller_id;

//   ///	处理结果的描述，信息来自于code返回结果的描述
//   String msg;

//   ///编码格式
//   String charset;

//   ///时间
//   String timestamp;

//   ///结果码	
//   String code;

  

//   Result({});

//   factory Error.fromJson(Map<String, dynamic> json) => _$ErrorFromJson(json);

//   static Map<String, dynamic> toJson(Error error) => _$ErrorToJson(error);
// }
