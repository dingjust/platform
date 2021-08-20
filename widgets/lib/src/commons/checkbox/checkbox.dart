import 'package:flutter/material.dart';
import 'package:widgets/src/commons/icon/b2b_commerce_icons.dart';

class B2BCheckbox extends StatelessWidget {
  final ValueChanged<bool> onChanged;

  final bool value;

  const B2BCheckbox({Key key, this.onChanged, this.value = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: value ? _selected() : _notSelected(),
    );
  }

  Widget _selected() {
    return Container(
      child: Icon(
        B2BIconsV2.tick_circle,
        color: Color(0xFFFF4D4F),
        size: 18,
      ),
    );
  }

  Widget _notSelected() {
    return Container(
      width: 17,
      height: 17,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: Color(0xFF999999))),
    );
  }
}
