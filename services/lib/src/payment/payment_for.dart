enum PaymentFor {
  ///默认-打样单
  DEFAULT,

  ///生产单-定金
  DEPOSIT,

  ///生产单-尾款
  BALANCE
}

const PaymentForEnumMap = <PaymentFor, dynamic>{
  PaymentFor.DEFAULT: 'DEFAULT',
  PaymentFor.DEPOSIT: 'DEPOSIT',
  PaymentFor.BALANCE: 'BALANCE',
};

enum PaymentStatus {
  ///未支付
  ORDER_PAY_NOT,

  ///支付成功
  ORDER_PAY_SUCCESS,

  ///支付失败
  ORDER_PAY_FAIL,

  ///支付处理中
  ORDER_PAYING,

  ///支付接口调用失败
  ORDER_INTERFACE_FAIL
}

//
const PaymentStatusMap = {
  PaymentStatus.ORDER_PAY_NOT: "ORDER_PAY_NOT",
  PaymentStatus.ORDER_PAY_SUCCESS: "ORDER_PAY_SUCCESS",
  PaymentStatus.ORDER_PAY_FAIL: "ORDER_PAY_FAIL",
  PaymentStatus.ORDER_PAYING: "ORDER_PAYING",
  PaymentStatus.ORDER_INTERFACE_FAIL: "ORDER_INTERFACE_FAIL",
};
