import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ProductFilterBar extends StatelessWidget {
  final VoidCallback openSelector;

  final VoidCallback openEndDrawer;

  const ProductFilterBar({Key key, this.openSelector, this.openEndDrawer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    PlateProductState state = Provider.of<PlateProductState>(context);

    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 0.5, color: Colors.grey[300]))),
      child: Row(
        children: <Widget>[
          _FilterItem(
            title: '销量',
            value: 'salesVolume',
          ),
          _FilterItem(
            title: '上新',
            value: '2',
          ),
          _FilterItem(
            title: '价格',
            value: 'steppedPrice',
          ),
          Expanded(
              child: Material(
            color: Colors.white,
            child: Ink(
              child: InkWell(
                  onTap: openSelector,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          generateCategoriesStr(state),
                          style: TextStyle(color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Icon(
                        Icons.category,
                        size: 16,
                        color: Colors.grey,
                      )
                    ],
                  )),
            ),
          )),
          Expanded(
              child: Material(
            color: Colors.white,
            child: Ink(
              child: InkWell(
                  onTap: openEndDrawer,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '筛选',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Icon(
                        Icons.menu,
                        size: 16,
                        color: Colors.grey,
                      )
                    ],
                  )),
            ),
          )),
        ],
      ),
    );
  }

  String generateCategoriesStr(PlateProductState state) {
    if (state.condition.categories.isEmpty) {
      return '分类';
    } else {
      String result = '';
      state.condition.categories.forEach((category) {
        result = '$result ${category.name}';
      });
      return result;
    }
  }
}

class _FilterItem extends StatelessWidget {
  final String title;

  final String value;

  final VoidCallback onTap;

  const _FilterItem({Key key, this.title, this.value, this.onTap})
      : super(key: key);

  static const Color activeColor = Colors.orange;

  static const Color color = Colors.grey;

  @override
  Widget build(BuildContext context) {
    PlateProductState state = Provider.of<PlateProductState>(context);

    return Expanded(
        child: Material(
      color: Colors.white,
      child: Ink(
        child: InkWell(
          onTap: () {
            state.condition.sortCondition = value;
            if (state.condition.sort == 'desc') {
              state.condition.sort = 'asc';
            } else {
              state.condition.sort = 'desc';
            }
            state.clear();
          },
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text(
                    '$title',
                    style: TextStyle(
                        color: state.condition.sortCondition == value
                            ? activeColor
                            : color),
                  ),
                  margin: EdgeInsets.only(right: 5),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(B2BIcons.triangle_up,
                        size: 8,
                        color: (state.condition.sortCondition == value &&
                                state.condition.sort == 'asc')
                            ? activeColor
                            : color),
                    Icon(
                      B2BIcons.triangle_down,
                      size: 8,
                      color: (state.condition.sortCondition == value &&
                              state.condition.sort == 'desc')
                          ? activeColor
                          : color,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
