import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';
import '../product_category.dart';

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
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () async {
            EnumModel category = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductCategorySelectPage()
              ),
            );

            _minorCategoryText = category?.name;
          },
          child: ShowSelectTile(
            leadingText: '选择分类',
            tralingText: _minorCategoryText,
            tralingTextColor: Colors.orange,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Divider(height: 0, color: Colors.grey[400]),
        ),
      ],
    );
  }
}
