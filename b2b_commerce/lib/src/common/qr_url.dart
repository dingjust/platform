class QrUrl {
  ///渠道码注册
  static get channelRegister => (code) {
        return 'https://ht.nbyjy.net/app/page/register?channelCode=$code';
      };

  ///订单唯一码导入
  static get orderUniqueCode => (code) {
        return 'https://ht.nbyjy.net/app/page/business/orders/import?code=$code';
      };

  ///对账单详情
  static get reconciliationOrder => (id) {
        return 'https://ht.nbyjy.net/app/page/business/orders/reconciliation_orders/detail?id=$id';
      };

  ///订单唯一码口令
  static get orderUniqueCodeLink => (code) {
        return '钉单【快速导入订单】⇤$code⇥复制这段文字打开钉单APP就能导入订单![]~(￣▽￣)~*';
      };
}
