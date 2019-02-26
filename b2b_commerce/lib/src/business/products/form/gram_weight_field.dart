import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class GramWeightField extends StatefulWidget {
  GramWeightField(this.item);

  final ApparelProductModel item;

  @override
  State<StatefulWidget> createState() => _GramWeightFieldState();
}

class _GramWeightFieldState extends State<GramWeightField> {
  FocusNode _gramWeightFocusNode = FocusNode();
  final TextEditingController _gramWeightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _gramWeightController.text = widget.item?.gramWeight?.toString();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      focusNode: _gramWeightFocusNode,
      controller: _gramWeightController,
      inputType: TextInputType.number,
      leadingText: '重量',
      hintText: '请输入重量',
    );
  }
}
