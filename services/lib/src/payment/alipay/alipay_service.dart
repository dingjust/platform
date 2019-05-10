import 'package:services/src/payment/payment_for.dart';

abstract class AlipayService {
  ///调起支付宝支付
  Future<dynamic> pay(String orderCode, {PaymentFor paymentFor});
}
