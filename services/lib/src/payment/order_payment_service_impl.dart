import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/src/api/payment.dart';
import 'package:services/src/net/http_manager.dart';
import 'package:services/src/payment/order_payment_service.dart';
import 'package:services/src/payment/payment_for.dart';

class OrderPaymentServiceImpl implements OrderPaymentService {
  @override

  ///支付确认
  Future<String> paymentConfirm(OrderModel order, String type,
      {PaymentFor paymentFor = PaymentFor.DEFAULT}) async {
    Response response;

    String apiUrl;

    //按类型调用不同接口
    if (order is ProofingModel && paymentFor == PaymentFor.DEFAULT) {
      //打样单
      apiUrl = PaymentApis.proofingPaidConfirm(order.code, type);
    } else if (order is PurchaseOrderModel &&
        paymentFor == PaymentFor.DEPOSIT) {
      //生产单-定金
      apiUrl = PaymentApis.purchaseDepositPaidConfirm(order.code, type);
    } else if (order is PurchaseOrderModel &&
        paymentFor == PaymentFor.BALANCE) {
      //生产单-尾款
      apiUrl = PaymentApis.purchaseBalancePaidConfirm(order.code, type);
    } else if (order is SalesOrderModel) {
      //销售订单
      apiUrl = PaymentApis.salesOrderPayStatus(order.code);
    } else {
      return null;
    }

    try {
      response = await http$.put(apiUrl);
    } catch (e) {
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      return response.data;
    } else {
      return null;
    }
  }
}
