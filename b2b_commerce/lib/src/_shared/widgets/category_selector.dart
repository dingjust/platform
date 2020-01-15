import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

///品类选择器
class CategorySelector extends StatefulWidget {
  final Function(CategoryModel) callBack;

  const CategorySelector({Key key, this.callBack}) : super(key: key);

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  CategoryModel _selectMajorCategory;
  CategoryModel _selectCategory;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CategoryModel>>(
        future: Provider.of<CategoryState>(context).getCascadedCategories(),
        initialData: [],
        builder: (BuildContext context,
            AsyncSnapshot<List<CategoryModel>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 100,
                        color: Colors.grey[200],
                        child: ListView(
                          children: snapshot.data.map((majorCategory) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectMajorCategory = majorCategory;
                                });
                              },
                              child: Container(
                                  height: 40,
                                  color: _selectMajorCategory?.code ==
                                          majorCategory.code
                                      ? Colors.white
                                      : Colors.grey[200],
                                  alignment: Alignment.center,
                                  child: _selectMajorCategory?.code ==
                                          majorCategory.code
                                      ? Text(
                                          '${majorCategory.name}',
                                          style: TextStyle(
                                            color: Colors.orange,
                                          ),
                                        )
                                      : Text('${majorCategory.name}')),
                            );
                          }).toList(),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(10),
                          child: _selectMajorCategory == null
                              ? Container()
                              : GridView(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3, //横轴三个子widget
                                          childAspectRatio: 3, //宽高比为1时，子widget
                                          crossAxisSpacing: 12,
                                          mainAxisSpacing: 12),
                                  children: _selectMajorCategory?.children
                                          ?.map((category) {
                                        return Container(
                                            decoration: BoxDecoration(
                                                color: _selectCategory?.code ==
                                                        category.code
                                                    ? Color.fromRGBO(
                                                        255, 214, 12, 1)
                                                    : Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: InkWell(
                                              child: Center(
                                                child: Text(
                                                  '${category.name}',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  _selectCategory = category;
                                                });
                                                widget.callBack(category);
                                              },
                                            ));
                                      })?.toList() ??
                                      [],
                                ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top:
                              BorderSide(width: 0.5, color: Colors.grey[300]))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                          onPressed: () {
                            setState(() {
                              _selectCategory = null;
                              _selectMajorCategory = null;
                            });
                            widget.callBack(_selectCategory);
                          },
                          child: Text(
                            '重置',
                            style: TextStyle(color: Colors.grey),
                          )),
                    ],
                  ),
                )
              ],
            );
          }
        });
  }
}
