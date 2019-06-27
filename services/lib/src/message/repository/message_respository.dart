 import 'package:dio/dio.dart';
import 'package:services/src/api/apis.dart';
 import 'package:services/src/message/response/message_response.dart';
 import 'package:services/src/net/http_manager.dart';
import 'package:services/src/user/bloc/user_bloc.dart';

 class MessageRepository {
   /// 获取微读消息数
   Future<CountUnreadResponse> countUnread(String uid) async {
     Response<Map<String, dynamic>> response;
     try {
       response = await http$.post(Apis.countUnreadMsg(uid));
     } on DioError catch (e) {
       print(e);
     }
     if (response != null && response.statusCode == 200) {
       CountUnreadResponse model = CountUnreadResponse.fromJson(response.data);
       return model;
     } else
       return null;
   }
 }
