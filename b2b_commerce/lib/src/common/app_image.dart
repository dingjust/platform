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
}
