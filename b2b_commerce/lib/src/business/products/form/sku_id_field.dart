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
      leadingText: Text('产品货号',style: TextStyle(fontSize: 16,)),
      hintText: '请输入产品货号',
    );
  }
}
