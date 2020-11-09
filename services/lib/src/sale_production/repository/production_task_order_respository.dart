import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/src/api/sale_production.dart';
import 'package:services/src/net/http_manager.dart';

/// 生产工单
class ProductionTaskOrderRespository {

  /// 获取生产工单明细
  Future<SalesProductionOrderModel> getOrderDetail(int id) async {
    Response<Map<String, dynamic>> response =
        await http$.get(SaleProductionApis.productionTaskOrderDetail(id));

    if (response.statusCode == 200 && response.data['code'] == 1) {
      SalesProductionOrderModel model =
          SalesProductionOrderModel.fromJson(response.data['data']);
      return model;
    } else
      return null;
  }

}
