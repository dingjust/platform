import 'package:flutter/material.dart';
import 'package:models/models.dart';

class SizeStockItem {
  SizeModel size;
  int available;
  int maxPreOrder;
  TextEditingController availableController;
  TextEditingController maxPreOrderController;

  SizeStockItem({
    this.size,
    this.available = 0,
    this.maxPreOrder = 0,
  }) {
    this.availableController = new TextEditingController(
        text: this.available == 0 ? null : this.available.toString());
    this.maxPreOrderController = new TextEditingController(
        text: this.maxPreOrder == 0 ? null : this.maxPreOrder.toString());
  }
}