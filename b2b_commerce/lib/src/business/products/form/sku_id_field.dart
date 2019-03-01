import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class SkuIDField extends StatefulWidget {
  SkuIDField(this.item);

  final ApparelProductModel item;

  @override
  State<StatefulWidget> createState() => _SkuIDFieldState();
}

class _SkuIDFieldState extends State<SkuIDField> {
  FocusNode _skuIDFocusNode = FocusNode();
  final TextEditingController _skuIDController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _skuIDController.text = widget.item?.skuID;
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      focusNode: _skuIDFocusNode,
      controller: _skuIDController,
      leadingText: '商品货号',
      hintText: '请输入商品货号',
    );
  }
}
