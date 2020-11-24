import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/src/api/order.dart';
import 'package:services/src/common/response.dart';
import 'package:services/src/net/http_manager.dart';

///出货单
class DeliveryOrderRespository {
  /// 创建快速发货单
  static Future<BaseResponse> crerate(FastShippingSheetModel model) async {
    try {
      Response<Map<String, dynamic>> response = await http$.post(
        OrderApis.deliveryOrderCreate,
        data: model.toJson(),
      );
      if (response.statusCode == 200 && response.data != null) {
        return BaseResponse.fromJson(response.data);
      } else
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// 快速发货单-详情
  static Future<FastShippingSheetModel> getDetail(int id) async {
    try {
      Response<Map<String, dynamic>> response = await http$.get(
        OrderApis.deliveryOrderDetail(id),
      );
      if (response.statusCode == 200 && response.data != null) {
        if (response.data['code'] == 1) {
          return FastShippingSheetModel.fromJson(response.data['data']);
        }
      }
    } catch (e) {
      print(e);
      return null;
    }

    return null;
  }
}
