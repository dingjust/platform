import 'package:models/models.dart';

abstract class OrderPaymentService {
  ///确认支付结果
  Future<String> paymentConfirm(OrderModel order,String type);
}
