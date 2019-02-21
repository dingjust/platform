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
  List<CategoryModel> _minCategorySelect = [];

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
            List<CategoryModel> categorys = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductCategorySelectPage(minCategorySelect: _minCategorySelect,)
              ),
            );

            print(_minCategorySelect.hashCode);

            if (_minCategorySelect != null) {
              _minorCategoryText = '';
              for (int i = 0; i < _minCategorySelect.length; i++) {
                if (i == 4) {
                  _minorCategoryText += '...';
                  break;
                }

                _minorCategoryText += _minCategorySelect[i]?.name;

                if (i != _minCategorySelect.length - 1) {
                  _minorCategoryText += '、';
                }
              }

            }
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
