import 'package:models/models.dart';

class PayPlanHelper {
  static getPreviewText(CompanyPayPlanModel model) {
    String str = [
      PayMoneyType.DEPOSIT,
      PayMoneyType.PHASEONE,
      PayMoneyType.PHASETWO,
      PayMoneyType.PHASETHREE
    ].map((e) => getRowStr1(model, e)).join();
    String str2 = getRowStr2(model);
    return '$str$str2';
  }

  static String getRowStr1(
      CompanyPayPlanModel form, PayMoneyType payMoneyType) {
    var item = form.payPlanItems.firstWhere(
        (element) => element.moneyType == payMoneyType,
        orElse: () => null);

    if (item == null) {
      return '';
    }

    String str1 =
        '${PayMoneyTypeLocalizedMap[payMoneyType]}：在双方${TriggerEventLocalizedMap[item.triggerEvent]}后${item.triggerDays}天以内，甲方应向乙方支付合同';
    String str2 = '总额的${(item.payPercent * 100).toStringAsFixed(0)}%' +
        (payMoneyType == PayMoneyType.DEPOSIT ? '为定金\n' : '货款\n');
    if (isLastItem(form, payMoneyType)) {
      str2 = '剩余部分款项（以上所有款项金额以双方对账金额为准）';
    }
    return '$str1$str2';
  }

  static String getRowStr2(CompanyPayPlanModel form) {
    if (![
      PayPlanType.MONTHLY_SETTLEMENT_ONE,
      PayPlanType.MONTHLY_SETTLEMENT_TWO
    ].contains(form.payPlanType)) {
      return '';
    }

    var item = form.payPlanItems.firstWhere(
        (element) =>
            (element.moneyType == PayMoneyType.MONTHLY_SETTLEMENT_ONE ||
                element.moneyType == PayMoneyType.MONTHLY_SETTLEMENT_TWO),
        orElse: () => null);

    var nextItem = form.payPlanItems.firstWhere(
        (element) =>
            (element.moneyType == PayMoneyType.MONTHLY_SETTLEMENT_TWO &&
                element.isLast),
        orElse: () => null);

    if (item == null) {
      return '';
    }

    if (nextItem != null) {
      return '${PayMoneyTypeLocalizedMap[PayMoneyType.MONTHLY_SETTLEMENT_TWO]}：' +
          '每月${getDayStr(item.monthlyEndDayNum)}前完成${TriggerEventLocalizedMap[item.triggerEvent]}' +
          '后于${MonthTypeLocalizedMap[item.monthType]}${getDayStr(item.payDayNum)}支付相应款项,' +
          '${getDayStr(nextItem.monthlyStartDayNum)}后至${getDayStr(nextItem.monthlyEndDayNum)}前完成' +
          '${TriggerEventLocalizedMap[nextItem.triggerEvent]}后于${MonthTypeLocalizedMap[nextItem.monthType]}${getDayStr(nextItem.payDayNum)}' +
          '支付相应款项（以上所有款项金额以双方对账金额为准）';
    }

    return '${PayMoneyTypeLocalizedMap[PayMoneyType.MONTHLY_SETTLEMENT_TWO]}：' +
        '每月${getDayStr(item.monthlyEndDayNum)}前完成${TriggerEventLocalizedMap[item.triggerEvent]}' +
        '后于${MonthTypeLocalizedMap[item.monthType]}${getDayStr(item.payDayNum)}支付相应款项(以上所有款项金额以双方对账金额为准)';
  }

  static String getDayStr(int i) {
    if (i == -1) {
      return '月底';
    } else {
      return '$i号';
    }
  }

  ///是否为最后一行款项
  static bool isLastItem(CompanyPayPlanModel form, PayMoneyType payMoneyType) {
    if (payMoneyType == PayMoneyType.DEPOSIT) {
      return false;
    }

    switch (form.payPlanType) {
      case PayPlanType.PHASEONE:
        return true;
        break;
      case PayPlanType.PHASETWO:
        return payMoneyType == PayMoneyType.PHASETWO;
        break;
      case PayPlanType.PHASETHREE:
        return payMoneyType == PayMoneyType.PHASETHREE;
        break;
      default:
        return false;
    }
  }
}
