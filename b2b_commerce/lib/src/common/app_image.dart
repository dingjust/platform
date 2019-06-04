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
}
