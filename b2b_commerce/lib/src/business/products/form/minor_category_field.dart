import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../product_category.dart';

class MinorCategoryField extends StatefulWidget {
  MinorCategoryField(this.item,{this.enabled});

  final ApparelProductModel item;
  final bool enabled;

  @override
  State<StatefulWidget> createState() => _MinorCategoryFieldState();
}

class _MinorCategoryFieldState extends State<MinorCategoryField> {
  String _minorCategoryText;
  List<CategoryModel> _minCategorySelect = [];
  List<CategoryModel> _categories;

  @override
  void initState() {
    super.initState();
    _minorCategoryText = widget.item?.category?.name;
    if (widget.item?.category != null) {
      _minCategorySelect = [widget.item?.category];
    }

    ProductRepositoryImpl().cascadedCategories().then((categories) => _categories = categories);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () async {
            if(!widget.enabled){
              return;
            }
            dynamic result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategorySelectPage(
                      minCategorySelect: _minCategorySelect,
                      categories: _categories,
                      categoryActionType: CategoryActionType.TO_POP,
                    ),
              ),
            );

            if (result != null) _minCategorySelect = result;

            if (_minCategorySelect.length > 0) {
              widget.item.category = _minCategorySelect[0];
              _minorCategoryText = _minCategorySelect[0]?.name;
            } else {
              _minorCategoryText = '';
              widget.item.category = null;
            }
          },
          child: ShowSelectTile(
            isRequired: true,
            leadingText: '产品品类',
            tralingText: _minorCategoryText,
          ),
        ),
      ],
    );
  }
}
