import 'package:flutter/material.dart';

///发货，收货单表单控件变量Mixins
class DeliverAndShippingFormMixins {
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
  }
}
