// import 'package:dio/dio.dart';
// import 'package:services/src/message/response/message_response.dart';
// import 'package:services/src/net/http_manager.dart';

// class MessageRepository {
//   /// 根据报价单编号获取明细
//   Future<CountUnreadResponse> countUnread(String uid) async {
//     Response<Map<String, dynamic>> response;
//     try {
//       response = await http$.get(Apis.);
//     } on DioError catch (e) {
//       print(e);
//     }
//     if (response != null && response.statusCode == 200) {
//       QuoteModel model = QuoteModel.fromJson(response.data);
//       return model;
//     } else
//       return null;
//   }
// }
