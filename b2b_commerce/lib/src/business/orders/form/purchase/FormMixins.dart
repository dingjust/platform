import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

import 'ColorSizeEntry.dart';

///发货，收货单表单控件变量Mixins
class DeliverAndShippingFormMixin {
  FocusNode consignorNameFocusNode;
  TextEditingController consignorNameController;

  FocusNode consignorPhoneFocusNode;
  TextEditingController consignorPhoneController;

  FocusNode trackingIDFocusNode;
  TextEditingController trackingIDController;

  FocusNode brandFocusNode;
  TextEditingController brandController;

  FocusNode skuIDFocusNode;
  TextEditingController skuIDController;

  FocusNode withdrawalQualityFocusNode;
  TextEditingController withdrawalQualityController;

  FocusNode defectiveQualityFocusNode;
  TextEditingController defectiveQualityController;

  FocusNode consigneeNameFocusNode;
  TextEditingController consigneeNameController;

  FocusNode consigneePhoneFocusNode;
  TextEditingController consigneePhoneController;

  FocusNode consigneeAddressFocusNode;
  TextEditingController consigneeAddressController;

  ///是否线下物流
  bool isOfflineConsignment;

  ///物流信息
  ConsignmentModel consignment;

  void initForm() {
    consignorNameFocusNode = FocusNode();
    consignorNameController = TextEditingController();

    consignorPhoneFocusNode = FocusNode();
    consignorPhoneController = TextEditingController();

    trackingIDFocusNode = FocusNode();
    trackingIDController = TextEditingController();

    brandFocusNode = FocusNode();
    brandController = TextEditingController();

    skuIDFocusNode = FocusNode();
    skuIDController = TextEditingController();

    withdrawalQualityFocusNode = FocusNode();
    withdrawalQualityController = TextEditingController();

    defectiveQualityFocusNode = FocusNode();
    defectiveQualityController = TextEditingController();

    consigneeNameFocusNode = FocusNode();
    consigneeNameController = TextEditingController();

    consigneePhoneFocusNode = FocusNode();
    consigneePhoneController = TextEditingController();

    consigneeAddressFocusNode = FocusNode();
    consigneeAddressController = TextEditingController();

    isOfflineConsignment = false;
  }

  void initDeliveryCreate(ShippingOrderNoteModel order) {
    consignorNameController.text = order.consignorName;
    consignorPhoneController.text = order.consignorPhone;
    if (!order.isOfflineConsignment && order.consignment != null) {
      trackingIDController.text = order.consignment.trackingID;
    }
    brandController.text = order.brand;
    skuIDController.text = order.skuID;
    withdrawalQualityController.text = order.withdrawalQuality;
    defectiveQualityController.text = order.defectiveQuality;
    consigneeNameController.text = order.consigneeName;
    consigneePhoneController.text = order.consigneePhone;
    consigneeAddressController.text = order.consigneeAddress;
    isOfflineConsignment = order.isOfflineConsignment;
    consignment = order.consignment;
  }

  void initDeliveryUpdate(DeliveryOrderNoteModel order) {
    consignorNameController.text = order.consignorName;
    consignorPhoneController.text = order.consignorPhone;
    if (!order.isOfflineConsignment && order.consignment != null) {
      trackingIDController.text = order.consignment.trackingID;
    }
    brandController.text = order.brand;
    skuIDController.text = order.skuID;
    withdrawalQualityController.text = order.withdrawalQuality;
    defectiveQualityController.text = order.defectiveQuality;
    consigneeNameController.text = order.consigneeName;
    consigneePhoneController.text = order.consigneePhone;
    consigneeAddressController.text = order.consigneeAddress;
    isOfflineConsignment = order.isOfflineConsignment;
    consignment = order.consignment;
  }

  void initShippingCreate(PurchaseOrderModel order) {
    UserModel user = UserBLoC.instance.currentUser;
    consignorNameController.text = user.name;
    consignorPhoneController.text = user.mobileNumber;
    brandController.text = order.product.brand;
    skuIDController.text = order.product.skuID;
    consigneeNameController.text = order.deliveryAddress.fullname;
    consigneePhoneController.text = order.deliveryAddress.cellphone;
    consigneeAddressController.text = order.deliveryAddress.details;
    isOfflineConsignment = true;
    consignment = order.consignment;
  }

  DeliveryOrderNoteModel getDeliveryForCreate(
      List<ColorSizeEntry> colorSizeEntries) {
    DeliveryOrderNoteModel order = DeliveryOrderNoteModel(
        consignorName: consignorNameController.text,
        consignorPhone: consignorPhoneController.text,
        brand: brandController.text,
        skuID: skuIDController.text,
        withdrawalQuality: withdrawalQualityController.text,
        defectiveQuality: defectiveQualityController.text,
        consigneeName: consigneeNameController.text,
        consigneePhone: consigneePhoneController.text,
        consigneeAddress: consigneeAddressController.text,
        isOfflineConsignment: isOfflineConsignment,
        consignment: consignment);
    if (!order.isOfflineConsignment) {
      if (order.consignment == null) {
        order.consignment = ConsignmentModel();
      }
      order.consignment.trackingID = trackingIDController.text;
    }

    List<OrderNoteEntryModel> entries = colorSizeEntries
        .where((entry) => entry.controller.text != '')
        .map((entry) =>
        OrderNoteEntryModel(
            color: entry.color,
            size: entry.size,
            quantity: int.parse(entry.controller.text)))
        .toList();

    order.entries = entries;
    return order;
  }

  DeliveryOrderNoteModel getDeliveryForUpdate(DeliveryOrderNoteModel order,
      List<ColorSizeEntry> colorSizeEntries) {
    order
      ..consignorName = consignorNameController.text
      ..brand = brandController.text
      ..skuID = skuIDController.text
      ..withdrawalQuality = withdrawalQualityController.text
      ..defectiveQuality = defectiveQualityController.text
      ..consigneeName = consigneeNameController.text
      ..consigneePhone = consigneePhoneController.text
      ..consigneeAddress = consigneeAddressController.text
      ..isOfflineConsignment = isOfflineConsignment
      ..consignorPhone = consignorPhoneController.text;
    if (!order.isOfflineConsignment) {
      if (order.consignment == null) {
        order.consignment = ConsignmentModel();
      }
      order.consignment.trackingID = trackingIDController.text;
    }

    List<DeliveryOrderNoteEntryModel> entries = [];
    colorSizeEntries
        .where((entry) => entry.controller.text != '')
        .forEach((entry) {
      DeliveryOrderNoteEntryModel model = DeliveryOrderNoteEntryModel(
          color: entry.color,
          size: entry.size,
          quantity: int.parse(entry.controller.text));
      model.id = entry.id;
      entries.add(model);
    });
    order.entries = entries;
    return order;
  }

  ShippingOrderNoteModel getShippingOrder(
      List<ColorSizeEntry> colorSizeEntries) {
    ShippingOrderNoteModel order = ShippingOrderNoteModel(
        consignorName: consignorNameController.text,
        consignorPhone: consignorPhoneController.text,
        brand: brandController.text,
        skuID: skuIDController.text,
        withdrawalQuality: withdrawalQualityController.text,
        defectiveQuality: defectiveQualityController.text,
        consigneeName: consigneeNameController.text,
        consigneePhone: consigneePhoneController.text,
        consigneeAddress: consigneeAddressController.text,
        isOfflineConsignment: isOfflineConsignment,
        consignment: consignment);

    List<OrderNoteEntryModel> entries = colorSizeEntries
        .where((entry) => entry.controller.text != '')
        .map((entry) =>
        OrderNoteEntryModel(
            color: entry.color,
            size: entry.size,
            quantity: int.parse(entry.controller.text)))
        .toList();

    order.entries = entries;
    return order;
  }
}

///对账单表单控件变量Mixins
class ReconciliationFormMixin {
  FocusNode partAFocusNode;
  TextEditingController partAController;

  FocusNode partBFocusNode;
  TextEditingController partBController;

  FocusNode brandFocusNode;
  TextEditingController brandController;

  FocusNode skuIDFocusNode;
  TextEditingController skuIDController;

  CooperationMode cooperationMethod;

  FocusNode delayDeductionFocusNode;
  TextEditingController delayDeductionController;

  FocusNode delayDeductionRemarksFocusNode;
  TextEditingController delayDeductionRemarksController;

  FocusNode qualityDeductionFocusNode;
  TextEditingController qualityDeductionController;

  FocusNode qualityDeductionRemarksFocusNode;
  TextEditingController qualityDeductionRemarksController;

  FocusNode otherDeductionFocusNode;
  TextEditingController otherDeductionController;

  FocusNode otherDeductionRemarksFocusNode;
  TextEditingController otherDeductionRemarksController;

  FocusNode otherFundsFocusNode;
  TextEditingController otherFundsController;

  FocusNode otherFundsRemarksFocusNode;
  TextEditingController otherFundsRemarksController;

  void initForm() {
    partAFocusNode = FocusNode();
    partAController = TextEditingController();

    partBFocusNode = FocusNode();
    partBController = TextEditingController();

    brandFocusNode = FocusNode();
    brandController = TextEditingController();

    skuIDFocusNode = FocusNode();
    skuIDController = TextEditingController();

    delayDeductionFocusNode = FocusNode();
    delayDeductionController = TextEditingController();

    delayDeductionRemarksFocusNode = FocusNode();
    delayDeductionRemarksController = TextEditingController();

    qualityDeductionFocusNode = FocusNode();
    qualityDeductionController = TextEditingController();

    qualityDeductionRemarksFocusNode = FocusNode();
    qualityDeductionRemarksController = TextEditingController();

    otherDeductionFocusNode = FocusNode();
    otherDeductionController = TextEditingController();

    otherDeductionRemarksFocusNode = FocusNode();
    otherDeductionRemarksController = TextEditingController();

    otherFundsFocusNode = FocusNode();
    otherFundsController = TextEditingController();

    otherFundsRemarksFocusNode = FocusNode();
    otherFundsRemarksController = TextEditingController();
  }

  void initReconciliationCreate(PurchaseOrderModel purchaseOrder) {
    partAController.text = purchaseOrder.purchaser.name;
    partBController.text = purchaseOrder.belongTo.name;
    if (purchaseOrder.deliveryOrders.isNotEmpty) {
      brandController.text = purchaseOrder.deliveryOrders.first.brand;
      skuIDController.text = purchaseOrder.deliveryOrders.first.skuID;
    }
  }

  void initReconciliationUpdate(ReconciliationOrderNoteModel order) {
    partAController.text = order.partA;
    partBController.text = order.partB;
    brandController.text = order.brand;
    skuIDController.text = order.skuID;
    delayDeductionController.text = order.delayDeduction.toString();
    delayDeductionRemarksController.text = order.delayDeductionRemarks;
    qualityDeductionController.text = order.qualityDeduction.toString();
    qualityDeductionRemarksController.text = order.qualityDeductionRemarks;
    otherDeductionController.text = order.otherDeduction.toString();
    otherDeductionRemarksController.text = order.otherDeductionRemarks;
    otherFundsController.text = order.otherFunds.toString();
    otherFundsRemarksController.text = order.otherFundsRemarks;
  }

  ReconciliationOrderNoteModel getReconciliationForCreate(
      List<ColorSizeEntry> colorSizeEntries) {
    ReconciliationOrderNoteModel order = ReconciliationOrderNoteModel(
        partA: partAController.text,
        partB: partBController.text,
        brand: brandController.text,
        skuID: skuIDController.text,
        cooperationMethod: cooperationMethod,
        delayDeductionRemarks: delayDeductionRemarksController.text,
        qualityDeductionRemarks: qualityDeductionRemarksController.text,
        otherDeductionRemarks: otherDeductionRemarksController.text,
        otherFundsRemarks: otherFundsRemarksController.text);

    order
      ..delayDeduction = getDoubleFromController(delayDeductionController)
      ..qualityDeduction = getDoubleFromController(qualityDeductionController)
      ..otherDeduction = getDoubleFromController(otherDeductionController)
      ..otherFunds = getDoubleFromController(otherFundsController);

    List<OrderNoteEntryModel> entries = colorSizeEntries
        .where((entry) => entry.controller.text != '')
        .map((entry) =>
        OrderNoteEntryModel(
            color: entry.color,
            size: entry.size,
            quantity: getIntFromController(entry.controller)))
        .toList();

    order.entries = entries;
    return order;
  }

  ReconciliationOrderNoteModel getReconciliationForUpdate(
      ReconciliationOrderNoteModel order,
      List<ColorSizeEntry> colorSizeEntries) {
    order
      ..partA = partAController.text
      ..partB = partBController.text
      ..brand = brandController.text
      ..skuID = skuIDController.text
      ..cooperationMethod = cooperationMethod
      ..delayDeductionRemarks = delayDeductionRemarksController.text
      ..qualityDeductionRemarks = qualityDeductionRemarksController.text
      ..otherDeductionRemarks = otherDeductionRemarksController.text
      ..otherFundsRemarks = otherFundsRemarksController.text
      ..delayDeduction = getDoubleFromController(delayDeductionController)
      ..qualityDeduction = getDoubleFromController(qualityDeductionController)
      ..otherDeduction = getDoubleFromController(otherDeductionController)
      ..otherFunds = getDoubleFromController(otherFundsController);

    List<DeliveryOrderNoteEntryModel> entries = [];
    colorSizeEntries
        .where((entry) => entry.controller.text != '')
        .forEach((entry) {
      DeliveryOrderNoteEntryModel model = DeliveryOrderNoteEntryModel(
          color: entry.color,
          size: entry.size,
          quantity: getIntFromController(entry.controller));
      model.id = entry.id;
      entries.add(model);
    });
    order.entries = entries;
    return order;
  }

  double getDoubleFromController(TextEditingController controller) {
    if (controller.text == '') {
      return 0;
    }
    return double.tryParse(controller.text) ?? 0;
  }

  int getIntFromController(TextEditingController controller) {
    if (controller.text == '') {
      return 0;
    }
    return int.tryParse(controller.text) ?? 0;
  }
}
