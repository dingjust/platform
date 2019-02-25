import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class NameField extends StatefulWidget {
  NameField(this.item);

  final ApparelProductModel item;

  @override
  State<StatefulWidget> createState() => _NameFieldState();
}

class _NameFieldState extends State<NameField> {
  FocusNode _nameFocusNode = FocusNode();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.item?.name;
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      focusNode: _nameFocusNode,
      controller: _nameController,
      leadingText: '商品名称',
      hintText: '请输入商品名称',
    );
  }
}
