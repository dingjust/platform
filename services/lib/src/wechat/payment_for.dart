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
