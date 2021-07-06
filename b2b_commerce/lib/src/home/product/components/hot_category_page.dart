import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

import '../plate_products_page.dart';

///热门品类
class HoteCategoryPage extends StatefulWidget {
  final bool multiSelect;

  const HoteCategoryPage({Key key, this.multiSelect = false}) : super(key: key);

  @override
  _HoteCategoryPageState createState() => _HoteCategoryPageState();
}

class _HoteCategoryPageState extends State<HoteCategoryPage> {
  CategoryModel _selectMajorCategory;
  List<CategoryModel> _selectCategory;

  @override
  void initState() {
    _selectCategory = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CategoryModel>>(
        future: Provider.of<CategoryState>(context, listen: false)
            .getCascadedCategories(),
        initialData: [],
        builder: (BuildContext context,
            AsyncSnapshot<List<CategoryModel>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (_selectMajorCategory == null && snapshot.data.isNotEmpty) {
              _selectMajorCategory = snapshot.data.first;
            }

            return Scaffold(
              appBar: AppBar(
                brightness: Brightness.light,
                elevation: 0.5,
                title: Text('热门品类'),
                centerTitle: true,
              ),
              body: Column(
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    color: _selectMajorCategory?.code ==
                                            majorCategory.code
                                        ? Colors.white
                                        : Colors.grey[200],
                                    // alignment: Alignment.center,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: majorCategory.name
                                            .split('')
                                            .map(
                                              (str) => Text(
                                                '${str}',
                                                style: TextStyle(
                                                    color: _selectMajorCategory
                                                                ?.code ==
                                                            majorCategory.code
                                                        ? Colors.orange
                                                        : Colors.black,
                                                    fontSize: 12),
                                                textAlign: TextAlign.justify,
                                              ),
                                            )
                                            .toList())),
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
                                            childAspectRatio:
                                                1, //宽高比为1时，子widget
                                            crossAxisSpacing: 12,
                                            mainAxisSpacing: 12),
                                    children: _selectMajorCategory?.children
                                            ?.map((category) {
                                          return GestureDetector(
                                            onTap: () => _onTap(category),
                                            child: Container(
                                              padding: EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 0.5,
                                                    color: _selectCategory
                                                            .contains(category)
                                                        ? Color.fromRGBO(
                                                            255, 214, 12, 1)
                                                        : Colors.white,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Column(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: CachedNetworkImage(
                                                        imageUrl:
                                                            '${category?.thumbnail?.actualUrl ?? ''}',
                                                        fit: BoxFit.cover,
                                                        placeholder:
                                                            (context, url) =>
                                                                SpinKitRing(
                                                                  color: Colors
                                                                      .black12,
                                                                  lineWidth: 2,
                                                                  size: 30.0,
                                                                ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            SpinKitRing(
                                                              color: Colors
                                                                  .black12,
                                                              lineWidth: 2,
                                                              size: 30,
                                                            )),
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Text(
                                                          '${category.name}',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black),
                                                          textAlign:
                                                              TextAlign.center,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        })?.toList() ??
                                        [],
                                  ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }

  void _onTap(CategoryModel category) {
    setState(() {
      if (!_selectCategory.contains(category)) {
        if (widget.multiSelect) {
          _selectCategory.add(category);
        } else {
          if (_selectCategory.isEmpty) {
            _selectCategory.add(category);
          } else {
            _selectCategory = [category];
          }
        }
      } else {
        _selectCategory.remove(category);
      }
    });
    //TODO 点击回调
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlateProductsPage(
              condition: ProductCondition(_selectCategory, ''),
              title: '产品分类',
            )));
  }
}
