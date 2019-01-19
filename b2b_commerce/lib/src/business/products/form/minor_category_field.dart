import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class MinorCategoryField extends StatefulWidget {
  MinorCategoryField(this.item);

  final ApparelProductModel item;

  @override
  State<StatefulWidget> createState() => _MinorCategoryFieldState();
}

class _MinorCategoryFieldState extends State<MinorCategoryField> {
  String _minorCategoryText;

  @override
  void initState() {
    super.initState();
    _minorCategoryText = widget.item?.minorCategory?.name;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: () async {
        EnumModel category = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EnumSelectPage(
                  title: '选择分类',
                  items: <EnumModel>[
                    EnumModel('R001', '男装'),
                    EnumModel('R002', '女装'),
                  ],
                ),
          ),
        );

        _minorCategoryText = category?.name;
      },
      child: ShowSelectTile(
        leadingText: '选择分类',
        tralingText: _minorCategoryText,
        tralingTextColor: Colors.orange,
      ),
    );
  }
}
