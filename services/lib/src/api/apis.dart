import 'package:core/core.dart';

/// 应用API
class Apis {
  const Apis();

  /// 获取省份列表 GET
  static get regions => () {
        return '/{baseSiteId}/regions';
      };

  /// 获取省份下的城市列表 GET
  static get citiesForRegion => (region) {
        return '/{baseSiteId}/regions/$region/cities';
      };

  /// 获取城市下的区域列表 GET
  static get districtsForCity => (city) {
        return '/{baseSiteId}/cities/$city/districts';
      };

  /// 获取品牌明细 GET
  static get brand =>
          (uid) {
        return '/{baseSiteId}/brands/$uid';
      };

  /// 获取品牌明细 GET
  static get brandUpdate =>
          (uid) {
        return '/{baseSiteId}/brands/$uid';
      };

  /// 获取工厂明细 GET
  static get factory =>
          (uid) {
        return '/{baseSiteId}/factories/$uid';
      };

  /// 更新工厂 PUT
  static get factoryUpdate =>
          (uid) {
        return '/{baseSiteId}/factories/$uid';
      };

  /// 更新工厂图文详情 PUT
  static get factoryUpdateProfiles =>
          (uid) {
        return '/{baseSiteId}/factories/$uid/profiles';
      };

  /// 图片上传
  static get upload =>
          () {
        return '/{baseSiteId}/media/file/upload';
      };

  /// 文件删除
  static get mediaDelete =>
          (id) {
        return '/{baseSiteId}/media/$id';
      };

  ///需求发布
  static get publishNewRequirement =>
          () {
        return '/{baseSiteId}/orders/requirement/new';
      };

  //公司认证
  static get applyCertification => '/{baseSiteId}/companies/certification';

  /// 全部工厂列表Z
  static get factories =>
      '/{baseSiteId}/factories?sort=sequenceNo,asc&sort=creationtime,desc';

  /// 经纬度
  static get factoriesForMap =>
      '/{baseSiteId}/factories/map?sort=sequenceNo,asc&sort=creationtime,desc';

  //邀请报价工厂列表 传入需求单号
  static get requestQuoteFactories =>
          (String code) {
        return '/{baseSiteId}/factories/requirement/$code';
      };

  /// 获取品牌的供应商列表
  static get factorySuppliers => '/{baseSiteId}/factories/getSuppliers';

  /// 获取工厂的供应商列表
  static get brandsSuppliers => '/{baseSiteId}/brands/getSuppliers';

  /// 检测版本
  static get appVersions =>
          (String name, String platform) {
        return '/{baseSiteId}/appVersions/$name/$platform';
      };

  ///问题与帮助信息
  static get guideline => '/{baseSiteId}/guideline';

  ///问题与帮助信息详情
  static get guidelineDetail =>
          (int id) {
        return '/{baseSiteId}/guideline/${id}';
      };

  static const String AMAP_TIP_API =
      'https://restapi.amap.com/v3/assistant/inputtips';

  static const String AMAP_AROUND_API =
      'https://restapi.amap.com/v3/place/around';

  ///高德地理编码
  static const String AMAP_GEOCODE = 'https://restapi.amap.com/v3/geocode/geo';

  ///分享-需求订单
  static get shareRequirement =>
          (String code) {
        return '${GlobalConfigs
            .SHARE_CONTEXT_PATH}/RequirementSharePage.html?code=$code';
      };

  ///分享-生产进度
  static get shareProductionProgress =>
          (String code) {
        return '${GlobalConfigs
            .SHARE_CONTEXT_PATH}/productionProgressShare.html?code=$code';
      };

  ///分享-工厂
  static get shareFactory =>
          (String code) {
        return '${GlobalConfigs
            .SHARE_CONTEXT_PATH}/factoryInfo.html?code=$code';
      };

  ///银行卡号查询
  static get cnBankCard =>
          (String cardNO) {
        return 'https://ccdcapi.alipay.com/validateAndCacheCardInfo.json?_input_charset=utf-8&cardNo=$cardNO&cardBinCheck=true';
      };

  ///银行LOGOAPI
  static get cnBankLOGO =>
          (String code) {
        return 'https://apimg.alipay.com/combo.png?d=cashier&t=$code';
      };

  ///未读消息统计
  static get countUnreadMsg =>
          (String uid) {
        return '/{baseSiteId}/user/$uid/unread/msg/count';
      };

  ///获取消息列表（消息盒子）
  static get getMsgList =>
          (String uid) {
        return '/{baseSiteId}/user/$uid/msg/list';
      };

  ///消息标记未读
  static get readMsg =>
          (String uid) {
        return '/{baseSiteId}/user/$uid/msg/update/to/read';
      };

  ///将所有未读消息标记为已读
  static get readAllMsg =>
          (String uid) {
        return '/{baseSiteId}/user/$uid/msg/read';
      };

  ///删除消息
  static get deleteMsg =>
          (String uid) {
        return '/{baseSiteId}/user/$uid/msg/delete';
      };

  ///产品首页items
  static get productHomePageItems => '/{baseSiteId}/products/plate/home/page';

  ///轮播图
  static get carousels =>
          (String type) {
        return '/{baseSiteId}/carousels/list/$type';
      };

  ///item详情点击量
  static get itemDetail =>
          (int pk) {
        return '/{baseSiteId}/statistics/update/$pk';
      };

  ///签署文档预览
  static get docSignaturePreview =>
          (code) {
        return '/{baseSiteId}/doc/signature/preview/$code';
      };

  ///签署文档
  static get docSignatureSign =>
          (code) {
        return '/{baseSiteId}/doc/signature/$code';
      };
}
