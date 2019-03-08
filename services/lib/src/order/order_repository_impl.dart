import 'package:models/models.dart';
import 'order_repository.dart';
import 'package:dio/dio.dart';
import 'package:services/services.dart';
import 'dart:convert';

class OrderRepositoryImpl extends OrderRepository{
  Future<String> publishNewRequirement(RequirementOrderModel form) async{
//    print(RequirementOrderModel.toJson(form));
    Map<String,dynamic> jsonMap=RequirementOrderModel.toJson(form);
    json.encode(jsonMap);

//    FormData formData = FormData.from(RequirementOrderModel.toJson(form));
//    print(formData);

    Response response = await http$.post(OrderApis.requirementOrderNew,data: jsonMap);
    return response.data;
  }

}
