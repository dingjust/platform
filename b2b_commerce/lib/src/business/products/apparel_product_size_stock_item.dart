import 'package:b2b_commerce/src/home/product/product_color_size_select.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class SizeStockItem {
  SizeModel size;
  int available;
  int maxPreOrder;
  TextEditingController availableController;
  TextEditingController maxPreOrderController;
  SizeSelectEntry selectEntry;

  SizeStockItem(
      {this.size, this.available = 0, this.maxPreOrder = 0, this.selectEntry}) {
    this.availableController = new TextEditingController(
        text: this.available == 0 ? null : this.available.toString());
    this.maxPreOrderController = new TextEditingController(
        text: this.maxPreOrder == 0 ? null : this.maxPreOrder.toString());
  }
}
