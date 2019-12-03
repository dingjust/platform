import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class SingleMajorCategorySelect extends StatefulWidget {
  SingleMajorCategorySelect(
      {@required this.categories, this.categorySelect, this.onItemTap});

  final List<CategoryModel> categories;
  CategoryModel categorySelect;
  Function onItemTap;

  _SingleMajorCategorySelectState createState() =>
      _SingleMajorCategorySelectState();
}

class _SingleMajorCategorySelectState extends State<SingleMajorCategorySelect> {
  Color _color;
  String _selectRights;

  @override
  void initState() {
    if (widget.categorySelect != null) {
      _selectRights = widget.categorySelect?.code;
    }
    _color = Colors.black;

    super.initState();
  }

  Widget buildValueItem(CategoryModel category) {
    return GestureDetector(
      onTap: () {
        if (_selectRights == category.code) {
          setState(() {
            _selectRights = null;
            widget.onItemTap(null);
          });
        } else {
          setState(() {
            _selectRights = category.code;
            widget.onItemTap(category);
          });
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
//        decoration: BoxDecoration(
////            borderRadius: BorderRadius.circular(20),
//            border: Border.all(
//                color: _selectRights == category.code
//                    ? Color.fromRGBO(255, 219, 0, 1)
//                    : Colors.white)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 60,
              height: 60,
              decoration: _selectRights == category.code ? ShapeDecoration(
                shadows: [BoxShadow(color: Colors.grey,blurRadius: 5)],
                color: Color.fromRGBO(243, 243, 243, 1),
                shape: CircleBorder(),
              ): ShapeDecoration(
                color: Color.fromRGBO(243, 243, 243, 1),
                shape: CircleBorder(),
              ),
              child: category.thumbnail != null
                  ? Image.network(
                      '${category.thumbnail.actualUrl}',
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      B2BIcons.noPicture,
                      color: Color.fromRGBO(200, 200, 200, 1),
                      size: 40,
                    ),
            ),
            SizedBox(height: 10,),
            Text(
              '${category.name}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14,color: _selectRights == category.code
                  ? Color.fromRGBO(255, 219, 0, 1)
                  : Colors.black),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 10, top: 5),
        child: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 4,
          padding: EdgeInsets.zero,
          children: List.generate(widget.categories.length, (index) {
            return buildValueItem(widget.categories[index]);
          }),
        ));
  }
}
