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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return TextFieldComponent(
      focusNode: _nameFocusNode,
      controller: _nameController,
      leadingText: Text('产品名称',style: TextStyle(fontSize: 16,)),
      hintText: '请输入产品名称',
    );
  }
}
