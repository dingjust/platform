import 'package:flutter/material.dart';
import 'package:models/models.dart';

///发货，收货单表单控件变量Mixins
class RequirementFormMixin {
  FocusNode productNameFocusNode;
  TextEditingController productNameController;

  FocusNode maxExpectedPriceFocusNode;
  TextEditingController maxExpectedPriceController;

  FocusNode expectedMachiningQuantityNode;
  TextEditingController expectedMachiningQuantityController;

//  FocusNode contactPersonFocusNode;
//  TextEditingController contactPersonController;
//
//  FocusNode contactPhoneFocusNode;
//  TextEditingController contactPhoneController;

  FocusNode remarksFocusNode;
  TextEditingController remarksController;

  FocusNode contactPhoneFocusNode;
  TextEditingController contactController;

  FocusNode wechatFocusNode;
  TextEditingController wechatController;

  void initForm() {
    productNameFocusNode = FocusNode();
    productNameController = TextEditingController();

    maxExpectedPriceFocusNode = FocusNode();
    maxExpectedPriceController = TextEditingController();

    expectedMachiningQuantityNode = FocusNode();
    expectedMachiningQuantityController = TextEditingController();

    remarksFocusNode = FocusNode();
    remarksController = TextEditingController();

    contactPhoneFocusNode = FocusNode();
    contactController = TextEditingController();

    wechatFocusNode = FocusNode();
    wechatController = TextEditingController();
  }

  void initCreate(RequirementOrderModel order) {
    productNameController.text = order.details.productName;
    if (order.details.maxExpectedPrice != -1) {
      maxExpectedPriceController.text =
          order.details.maxExpectedPrice?.toString();
    }
    expectedMachiningQuantityController.text =
        order.details.expectedMachiningQuantity?.toString();
    remarksController.text = order.remarks;
    if (order.details.productiveDistricts == null) {
      order.details.productiveDistricts = [];
    }

    contactController.text = order?.details?.contactPhone ?? '';
    wechatController.text = order?.details?.contactWeChatNo ?? '';
  }
}
