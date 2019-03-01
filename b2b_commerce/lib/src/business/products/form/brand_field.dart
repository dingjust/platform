import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class BrandField extends StatefulWidget {
  BrandField(this.item);

  final ApparelProductModel item;

  @override
  State<StatefulWidget> createState() => _BrandFieldState();
}

class _BrandFieldState extends State<BrandField> {
  FocusNode _brandFocusNode = FocusNode();
  final TextEditingController _brandController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _brandController.text = widget.item?.brand;
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      focusNode: _brandFocusNode,
      controller: _brandController,
      leadingText: '品牌',
      hintText: '请输入品牌',
    );
  }
}
