import 'package:flutter/material.dart';

const double _width = 25.0;
const double _height = 25.0;
const String _package = 'assets';

Image getImage(String url,
    {String package = _package,
    double width = _width,
    double height = _height}) {
  return Image.asset(url, package: package, width: width, height: height);
}

class MenuItemImage {
  static Image checkReport = getImage('temp/business/check_report.png');
  static Image addressManage = getImage('temp/business/address_manage.png');
  static Image cart = getImage('temp/business/cart.png');
  static Image certificateInfo = getImage('temp/business/certicate_info.png');
  static Image clothesManage = getImage('temp/business/clothes_manage.png');
  static Image customerAudit = getImage('temp/business/customer_audit.png');
  static Image customerService = getImage('temp/business/customer_service.png');
  static Image employeeManage = getImage('temp/business/employee_manage.png');
  static Image inventoryManage = getImage('temp/business/inventory_manage.png');
  static Image invoiceManage = getImage('temp/business/invoice_manage.png');
  static Image memberManage = getImage('temp/business/member_manage.png');
  static Image myAccount = getImage('temp/business/my_account.png');
  static Image myCollection = getImage('temp/business/my_collection.png');
  static Image orderMatter = getImage('temp/business/order_matter.png');
  static Image priceManage = getImage('temp/business/price_manage.png');
  static Image priceOrder = getImage('temp/business/price_order.png');
  static Image productManage = getImage('temp/business/product_manage.png');
  static Image purchaseOrder = getImage('temp/business/purchase_order.png');
  static Image requirementOrder =
      getImage('temp/business/requirement_order.png');
  static Image saleOrder = getImage('temp/business/sale_order.png');
  static Image proofingOrder = getImage('temp/business/proofing.png');
  static Image setting = getImage('temp/business/setting.png');
  static Image supplierManage = getImage('temp/business/supplier_manage.png');
  static Image registerBrand = getImage('temp/business/register_brand.png');
  static Image registerCustomer =
      getImage('temp/business/register_customer.png');
  static Image registerFactory = getImage('temp/business/register_factory.png');
  static Image partnerFactory =
      getImage('temp/business/partner_manage_factory.png');
  static Image productFactory =
      getImage('temp/business/product_manage_factory.png');
  static Image productionFactory =
      getImage('temp/business/production_order_factory.png');
  static Image quoteFactory =
      getImage('temp/business/quote_manage_factory.png');
  static Image freeCapacity2 = getImage('temp/index/free_capacity2.png');
  static Image externalOrder = getImage('temp/business/external_order.png');
  static Image outboundOrder = getImage('temp/business/outbound_order.png');

  ///发货
  static Image delivery = getImage('temp/business/delivery.png');

  ///对账
  static Image reconciliation = getImage('temp/business/reconciliation.png');

  ///生产工单
  static Image productionBlue = getImage('temp/business/production_blue.png');

  ///生产工单
  static Image productionOrange =
      getImage('temp/business/production_orange.png');
}

class B2BImage {
  static Image picture({double width, double height}) {
    return getImage('temp/picture.png', width: width, height: height);
  }

  static Image fastFactory({double width, double height}) {
    return getImage('temp/common/fast_factory.png',
        width: width, height: height);
  }

  static Image findFactory({double width, double height}) {
    return getImage('temp/common/find_factory.png',
        width: width, height: height);
  }

  static Image idleCapacity({double width, double height}) {
    return getImage('temp/common/idle_capacity.png',
        width: width, height: height);
  }

  static Image order({double width, double height}) {
    return getImage('temp/common/order.png', width: width, height: height);
  }

  static Image addressUnderLine({double width, double height}) {
    return getImage('temp/common/address_under_line.png',
        width: width, height: height);
  }

  static Image addressManage({double width, double height}) {
    return getImage('temp/my/address_manage.png', width: width, height: height);
  }

  static Image certificateInfo({double width, double height}) {
    return getImage('temp/my/certicate_info.png', width: width, height: height);
  }

  static Image customerService({double width, double height}) {
    return getImage('temp/my/customer_service.png',
        width: width, height: height);
  }

  static Image invoiceManage({double width, double height}) {
    return getImage('temp/my/invoice_manage.png', width: width, height: height);
  }

  static Image myAccount({double width, double height}) {
    return getImage('temp/my/my_account.png', width: width, height: height);
  }

  static Image myIntegral({double width, double height}) {
    return getImage('temp/my/my_integral.png', width: width, height: height);
  }

  static Image setting({double width, double height}) {
    return getImage('temp/my/setting.png', width: width, height: height);
  }

  static Image companyIntroduce({double width, double height}) {
    return getImage('temp/my/company_introduce.png',
        width: width, height: height);
  }

  static Image help({double width, double height}) {
    return getImage('temp/my/help.png', width: width, height: height);
  }

  static Image qrCode({double width, double height}) {
    return getImage('temp/QRCode.png', width: width, height: height);
  }

  static Image wechatLogo({double width, double height}) {
    return getImage('temp/common/icon64_wx_logo.png',
        width: width, height: height);
  }

  static Image wechatLogin({double width, double height}) {
    return getImage('temp/common/wechat_login.png',
        width: width, height: height);
  }

  static Image miniProgram({double width, double height}) {
    return getImage('temp/common/mini-program.png',
        width: width, height: height);
  }

  static Image wechatFriend({double width, double height}) {
    return getImage('temp/common/wechat_friend.png',
        width: width, height: height);
  }

  static Image qq({double width, double height}) {
    return getImage('temp/common/qq_logo.png', width: width, height: height);
  }

  static Image qqZone({double width, double height}) {
    return getImage('temp/common/qq_zone.png', width: width, height: height);
  }

  static Image shareQrCode({double width, double height}) {
    return getImage('temp/common/qr_code.png', width: width, height: height);
  }

  static Image signed({double width, double height}) {
    return getImage('temp/icon/signed.png', width: width, height: height);
  }

  static Image notSigned({double width, double height}) {
    return getImage('temp/icon/not_signed.png', width: width, height: height);
  }

  static Image paid({double width, double height}) {
    return getImage('temp/icon/paid.png', width: width, height: height);
  }

  static Image notPaid({double width, double height}) {
    return getImage('temp/icon/arrears.png', width: width, height: height);
  }

  ///全部合同
  static Image allContract({double width, double height}) {
    return getImage('temp/contract/all_contract.png',
        width: width, height: height);
  }

  ///我的合同
  static Image myContract({double width, double height}) {
    return getImage('temp/contract/my_contract.png',
        width: width, height: height);
  }

  ///我的合同
  static Image mySeal({double width, double height}) {
    return getImage('temp/contract/my_seal.png', width: width, height: height);
  }

  ///待我签署
  static Image waitMySign({double width, double height}) {
    return getImage('temp/contract/my_sign.png', width: width, height: height);
  }

  ///待他签署
  static Image waitOtherSign({double width, double height}) {
    return getImage('temp/contract/other_sign.png',
        width: width, height: height);
  }

  ///合同管理
  static Image contractManage({double width, double height}) {
    return getImage('temp/index/contract_manage.png',
        width: width, height: height);
  }

  ///空闲产能
  static Image freeCapacity({double width, double height}) {
    return getImage('temp/index/free_capacity.png',
        width: width, height: height);
  }

  ///附近工厂
  static Image nearbyFactory({double width, double height}) {
    return getImage('temp/index/nearby_factory.png',
        width: width, height: height);
  }

  ///订单协同
  static Image orderCoordination({double width, double height}) {
    return getImage('temp/index/order_coordination.png',
        width: width, height: height);
  }

  ///看款下单
  static Image productOrdering({double width, double height}) {
    return getImage('temp/index/product_ordering.png',
        width: width, height: height);
  }

  ///生产工厂
  static Image productionFactory({double width, double height}) {
    return getImage('temp/index/production_factory.png',
        width: width, height: height);
  }

  ///优选工厂
  static Image qualityFactory({double width, double height}) {
    return getImage('temp/index/quality_factory.png',
        width: width, height: height);
  }

  ///需求
  static Image requirement({double width, double height}) {
    return getImage('temp/index/requirement.png', width: width, height: height);
  }

  ///唯一码导入
  static Image uniqueImport({double width, double height}) {
    return getImage('temp/index/unique_import.png',
        width: width, height: height);
  }

  ///面料
  static Image material({double width, double height}) {
    return getImage('temp/index/material.png', width: width, height: height);
  }

  ///需求中心
  static Image requirementCenter({double width, double height}) {
    return getImage('temp/index/requirement_center.png',
        width: width, height: height);
  }

  ///空闲产能2
  static Image free_capacity2({double width, double height}) {
    return getImage('temp/index/free_capacity2.png',
        width: width, height: height);
  }

  ///看款下单-现货
  static Image products_spot({double width, double height}) {
    return getImage('img-temp/200x200/spot_goods.png',
        width: width, height: height);
  }

  ///看款下单-库存
  static Image products_tail({double width, double height}) {
    return getImage('img-temp/200x200/tail_goods.png',
        width: width, height: height);
  }

  ///看款下单-分类
  static Image products_category({double width, double height}) {
    return getImage('img-temp/200x200/category.png',
        width: width, height: height);
  }

  ///看款下单-期货
  static Image products_future({double width, double height}) {
    return getImage('img-temp/200x200/future_goods.png',
        width: width, height: height);
  }

  ///首页发布需求
  static Image requirement_publish({double width, double height}) {
    return getImage('temp/20200411161233.png', width: width, height: height);
  }

  ///首页推荐工厂
  static Image recommend_factory({double width, double height}) {
    return getImage('temp/20200411161325.png', width: width, height: height);
  }

  ///首页推荐需求
  static Image recommend_requirement({double width, double height}) {
    return getImage('temp/20200414163706.png', width: width, height: height);
  }

  ///认证失败
  static Image auth_fail({double width, double height}) {
    return getImage('temp/auth_fail.png', width: width, height: height);
  }

  ///认证成功
  static Image auth_success({double width, double height}) {
    return getImage('temp/auth_success.png', width: width, height: height);
  }

  ///钉钉Logo
  static Image dingding_logo({double width, double height}) {
    return getImage('temp/common/dingding_logo.png',
        width: width, height: height);
  }

  ///报价处理
  static Image quoteProcess({double width, double height}) {
    return getImage('temp/index/quote_process.png',
        width: width, height: height);
  }

  ///面辅料
  static Image materielProducts({double width, double height}) {
    return getImage('temp/index/materiel_products.png',
        width: width, height: height);
  }

  ///红包
  static Image luckeyMoney({double width, double height}) {
    return getImage('temp/my/lucky_money.png', width: width, height: height);
  }

  ///红包2
  static Image luckeyMoney2({double width, double height}) {
    return getImage('temp/activity/lucky_money2.png',
        width: width, height: height);
  }

  ///礼物
  static Image gifit({double width, double height}) {
    return getImage('temp/activity/gifit.png', width: width, height: height);
  }

  ///成功
  static Image success({double width, double height}) {
    return getImage('temp/success.png', width: width, height: height);
  }

  ///认证
  static Image auth({double width, double height}) {
    return getImage('temp/icon/auth.png', width: width, height: height);
  }

  ///钉钉Logo
  static Image apple({double width, double height}) {
    return getImage('temp/common/apple.png', width: width, height: height);
  }
}

class B2BV2Image {
  static Image fab({double width, double height}) {
    return getImage('img/icons/b2b-v2/navigator/fab@2x.png',
        width: width, height: height);
  }

  static Image tab_1({double width, double height}) {
    return getImage('img/icons/b2b-v2/navigator/tab_1.0@2x.png',
        width: width, height: height);
  }

  static Image tab_1_1({double width, double height}) {
    return getImage('img/icons/b2b-v2/navigator/tab_1.1@2x.png',
        width: width, height: height);
  }

  static Image tab_2({double width, double height}) {
    return getImage('img/icons/b2b-v2/navigator/tab_2.0@2x.png',
        width: width, height: height);
  }

  static Image tab_2_1({double width, double height}) {
    return getImage('img/icons/b2b-v2/navigator/tab_2.1@2x.png',
        width: width, height: height);
  }

  static Image tab_3({double width, double height}) {
    return getImage('img/icons/b2b-v2/navigator/tab_3.0@2x.png',
        width: width, height: height);
  }

  static Image tab_3_1({double width, double height}) {
    return getImage('img/icons/b2b-v2/navigator/tab_3.1@2x.png',
        width: width, height: height);
  }

  static Image tab_4({double width, double height}) {
    return getImage('img/icons/b2b-v2/navigator/tab_4.0@2x.png',
        width: width, height: height);
  }

  static Image tab_4_1({double width, double height}) {
    return getImage('img/icons/b2b-v2/navigator/tab_4.1@2x.png',
        width: width, height: height);
  }

  static Image top_1({double width, double height}) {
    return getImage('img/icons/b2b-v2/header/top_1@2x.png',
        width: width, height: height);
  }

  static Image top_2({double width, double height}) {
    return getImage('img/icons/b2b-v2/header/top_2@2x.png',
        width: width, height: height);
  }

  static Image top_3({double width, double height}) {
    return getImage('img/icons/b2b-v2/header/top_3@2x.png',
        width: width, height: height);
  }

  static Image main_1({double width, double height}) {
    return getImage('img/icons/b2b-v2/main/main_1@2x.png',
        width: width, height: height);
  }

  static Image main_2({double width, double height}) {
    return getImage('img/icons/b2b-v2/main/main_2@2x.png',
        width: width, height: height);
  }

  static Image main_3({double width, double height}) {
    return getImage('img/icons/b2b-v2/main/main_3@2x.png',
        width: width, height: height);
  }

  static Image main_4({double width, double height}) {
    return getImage('img/icons/b2b-v2/main/main_4@2x.png',
        width: width, height: height);
  }

  static Image main_5({double width, double height}) {
    return getImage('img/icons/b2b-v2/main/main_5@2x.png',
        width: width, height: height);
  }

  static Image main_6({double width, double height}) {
    return getImage('img/icons/b2b-v2/main/main_6@2x.png',
        width: width, height: height);
  }

  static Image main_7({double width, double height}) {
    return getImage('img/icons/b2b-v2/main/main_7@2x.png',
        width: width, height: height);
  }

  static Image main_8({double width, double height}) {
    return getImage('img/icons/b2b-v2/main/main_8@2x.png',
        width: width, height: height);
  }

  static Image notice({double width, double height}) {
    return getImage('img/icons/b2b-v2/notice@2x.png',
        width: width, height: height);
  }

  static Image authCompany({double width, double height}) {
    return getImage('img/icons/b2b-v2/auth_company@2x.png',
        width: width, height: height);
  }

  static Image authPerson({double width, double height}) {
    return getImage('img/icons/b2b-v2/auth_person@2x.png',
        width: width, height: height);
  }

  static Image del1({double width, double height}) {
    return getImage('img/icons/b2b-v2/search/del_1@2x.png',
        width: width, height: height);
  }

  static Image del2({double width, double height}) {
    return getImage('img/icons/b2b-v2/search/del_2@2x.png',
        width: width, height: height);
  }

  static Image location_1({double width, double height}) {
    return getImage('img/icons/b2b-v2/location/add_1@2x.png',
        width: width, height: height);
  }

  static Image location_2({double width, double height}) {
    return getImage('img/icons/b2b-v2/location/add_2@2x.png',
        width: width, height: height);
  }

  ///全部工厂
  static Image factory_1({double width, double height}) {
    return getImage('img/icons/b2b-v2/factory/factory_1@2x.png',
        width: width, height: height);
  }

  ///免费打样
  static Image factory_2({double width, double height}) {
    return getImage('img/icons/b2b-v2/factory/factory_2@2x.png',
        width: width, height: height);
  }

  ///快反工厂
  static Image factory_3({double width, double height}) {
    return getImage('img/icons/b2b-v2/factory/factory_3@2x.png',
        width: width, height: height);
  }

  ///认证工厂
  static Image factory_4({double width, double height}) {
    return getImage('img/icons/b2b-v2/factory/factory_4@2x.png',
        width: width, height: height);
  }

  ///消息
  static Image message({double width, double height}) {
    return getImage('img/icons/b2b-v2/message@2x.png',
        width: width, height: height);
  }

  ///钱
  static Image money({double width, double height}) {
    return getImage('img/icons/b2b-v2/money@2x.png',
        width: width, height: height);
  }

  ///印章
  static Image seal({double width, double height}) {
    return getImage('img/icons/b2b-v2/contract/seal@2x.png',
        width: width, height: height);
  }

  ///模板
  static Image template({double width, double height}) {
    return getImage('img/icons/b2b-v2/contract/template@2x.png',
        width: width, height: height);
  }

  ///返回
  static Image back({double width, double height}) {
    return getImage('img/icons/b2b-v2/back@2x.png',
        width: width, height: height);
  }

  ///分享-圆
  static Image share_circle({double width, double height}) {
    return getImage('img/icons/b2b-v2/share_circle@2x.png',
        width: width, height: height);
  }

  ///发货单
  static Image delivery({double width, double height}) {
    return getImage('img/icons/b2b-v2/workspace/delivery@3x.png',
        width: width, height: height);
  }

  ///对账单
  static Image bill({double width, double height}) {
    return getImage('img/icons/b2b-v2/workspace/bill@3x.png',
        width: width, height: height);
  }

  ///商品
  static Image goods({double width, double height}) {
    return getImage('img/icons/b2b-v2/workspace/goods@3x.png',
        width: width, height: height);
  }

  ///订单
  static Image order({double width, double height}) {
    return getImage('img/icons/b2b-v2/workspace/order@3x.png',
        width: width, height: height);
  }

  ///外发订单
  static Image order_1({double width, double height}) {
    return getImage('img/icons/b2b-v2/workspace/order_1@3x.png',
        width: width, height: height);
  }

  ///外发生产工单
  static Image order_2({double width, double height}) {
    return getImage('img/icons/b2b-v2/workspace/order_2@3x.png',
        width: width, height: height);
  }

  ///生产工单
  static Image order_3({double width, double height}) {
    return getImage('img/icons/b2b-v2/workspace/order_3@3x.png',
        width: width, height: height);
  }

  ///出货单
  static Image order_4({double width, double height}) {
    return getImage('img/icons/b2b-v2/workspace/order_4@3x.png',
        width: width, height: height);
  }

  ///店铺
  static Image shop({double width, double height}) {
    return getImage('img/icons/b2b-v2/workspace/shop@3x.png',
        width: width, height: height);
  }

  ///用户
  static Image user({double width, double height}) {
    return getImage('img/icons/b2b-v2/workspace/user@3x.png',
        width: width, height: height);
  }

  ///明细账目
  static Image my_account({double width, double height}) {
    return getImage('img/icons/b2b-v2/my/account@3x.png',
        width: width, height: height);
  }

  ///我的收藏
  static Image my_collect({double width, double height}) {
    return getImage('img/icons/b2b-v2/my/collect@3x.png',
        width: width, height: height);
  }

  ///地址管理
  static Image my_address({double width, double height}) {
    return getImage('img/icons/b2b-v2/my/add@3x.png',
        width: width, height: height);
  }

  ///发票管理
  static Image my_bill({double width, double height}) {
    return getImage('img/icons/b2b-v2/my/bill@3x.png',
        width: width, height: height);
  }

  ///我的消息
  static Image my_notice({double width, double height}) {
    return getImage('img/icons/b2b-v2/my/notice@3x.png',
        width: width, height: height);
  }

  ///意见反馈
  static Image my_feedback({double width, double height}) {
    return getImage('img/icons/b2b-v2/my/feedback@3x.png',
        width: width, height: height);
  }

  ///帮助中心
  static Image my_help({double width, double height}) {
    return getImage('img/icons/b2b-v2/my/help@3x.png',
        width: width, height: height);
  }

  ///联系客服
  static Image my_kefu({double width, double height}) {
    return getImage('img/icons/b2b-v2/my/kefu@3x.png',
        width: width, height: height);
  }

  ///设置
  static Image my_setting({double width, double height}) {
    return getImage('img/icons/b2b-v2/my/set@3x.png',
        width: width, height: height);
  }
}
