import 'package:flutter/material.dart';
import 'package:widgets/src/commons/icon/b2b_commerce_icons.dart';

class B2BCheckbox extends StatelessWidget {
  final ValueChanged<bool> onChanged;

  final bool value;

  final EdgeInsetsGeometry padding;

  final double size;

  const B2BCheckbox(
      {Key key,
      this.onChanged,
      this.value = false,
      this.padding = const EdgeInsets.all(0),
      this.size = 18})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged?.call(!value),
      child: Container(
        padding: padding,
        child: value ? _selected() : _notSelected(),
      ),
    );
  }

  Widget _selected() {
    return Container(
      child: Icon(
        B2BIconsV2.tick_circle,
        color: Color(0xFFFF4D4F),
        size: size,
      ),
    );
  }

  Widget _notSelected() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: Color(0xFF999999))),
    );
  }
}
