import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class SingleMajorCategorySelectGridView extends StatefulWidget {
  SingleMajorCategorySelectGridView(
      {required this.categories, this.categorySelect, this.onItemTap});

  final List<CategoryModel> categories;
  CategoryModel? categorySelect;
  Function? onItemTap;

  _SingleMajorCategorySelectGridViewState createState() =>
      _SingleMajorCategorySelectGridViewState();
}

class _SingleMajorCategorySelectGridViewState extends State<SingleMajorCategorySelectGridView> {
  String? _selectRight;

  @override
  void initState() {
    super.initState();
  }

  Widget buildValueItem(CategoryModel category) {
    if (widget.categorySelect != null) {
      _selectRight = widget.categorySelect?.code;
    }
    return GestureDetector(
      onTap: () {
        setState(() {
//          _selectRight = category.code;
          widget.onItemTap!(category);
        });
      },
      child: _selectRight == category.code ? _buildSelectedWidget(category): _buildWidget(category),
    );
  }

  Container _buildSelectedWidget(CategoryModel category) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          category.thumbnail != null ? Stack(
            children: <Widget>[
              Container(
                  width: 60,
                  height: 60,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    image: DecorationImage(
                        image: NetworkImage('${category.thumbnail.actualUrl}'),
                        fit: BoxFit.cover),
                  )
              ),
              Stack(
                children: <Widget>[
                  Opacity(
                    opacity: 0.5,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: ShapeDecoration(
                        shadows: [BoxShadow(blurRadius: 5)],
                        color: Colors.black54,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    child: Center(
                      child: Icon(Icons.check,color: Color(0xffffd60c),),
                    ),
                  ),
                ],
              ),
            ],
          ):
          Container(
            width: 60,
            height: 60,
            decoration: ShapeDecoration(
              shadows: _selectRight == category.code ? [BoxShadow(color: Colors.grey,blurRadius: 5)] :[],
              color: Color.fromRGBO(243, 243, 243, 1),
              shape: CircleBorder(),
            ),
            child: Icon(
              B2BIcons.noPicture,
              color: Color.fromRGBO(200, 200, 200, 1),
              size: 40,
            ),
          ),
          SizedBox(height: 10,),
          Text(
            '${category.name}',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14,color: _selectRight == category.code
                ? Color.fromRGBO(255, 219, 0, 1)
                : Colors.black),
          )
        ],
      ),
    );
  }
  Container _buildWidget(CategoryModel category) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          category.thumbnail != null ? Container(
              width: 60,
              height: 60,
              decoration: ShapeDecoration(
                shadows: _selectRight == category.code ? [BoxShadow(color: Colors.grey,blurRadius: 5)] :[],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                image: DecorationImage(
                    image: NetworkImage('${category.thumbnail.actualUrl}'),
                    fit: BoxFit.cover),
              )
          ) :
          Container(
            width: 60,
            height: 60,
            decoration: ShapeDecoration(
              shadows: _selectRight == category.code ? [BoxShadow(color: Colors.grey,blurRadius: 5)] :[],
              color: Color.fromRGBO(243, 243, 243, 1),
              shape: CircleBorder(),
            ),
            child: Icon(
              B2BIcons.noPicture,
              color: Color.fromRGBO(200, 200, 200, 1),
              size: 40,
            ),
          ),
          SizedBox(height: 10,),
          Text(
            '${category.name}',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14,color: _selectRight == category.code
                ? Color.fromRGBO(255, 219, 0, 1)
                : Colors.black),
          )
        ],
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
          crossAxisCount: 3,
          padding: EdgeInsets.zero,
          children: List.generate(widget.categories.length, (index) {
            return buildValueItem(widget.categories[index]);
          }),
        ));
  }
}
