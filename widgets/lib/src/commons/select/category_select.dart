import 'package:flutter/material.dart';
import 'package:models/models.dart';

class CategorySelect extends StatefulWidget {
  List<CategoryModel> categorys;
  final bool multiple;
  final double verticalDividerOpacity;
  final bool hasButton;
  List<CategoryModel> categorySelect;

  ///分类选择动作
  final CategoryActionType categoryActionType;

  /// 跳转到工厂列表
  final ValueChanged<CategoryModel> onJumpToFactories;

  /// 跳转到产品列表
  final ValueChanged<CategoryModel> onJumpToProducts;

  CategorySelect({
    @required this.categorys,
    this.multiple = true,
    this.verticalDividerOpacity = 1,
    this.categorySelect,
    this.hasButton = false,
    this.categoryActionType,
    this.onJumpToFactories,
    this.onJumpToProducts,
  });

  CategorySelectState createState() => CategorySelectState();
}

class CategorySelectState extends State<CategorySelect> {
  //透明度0到1
  double _verticalDivider;

  //是否多选
  bool _multiple;
  List<Widget> _keyItem;
  List<CategoryModel> _valueItem = [];
  String _selectLeft;
  Color _color;
  List<String> _selectRights = [];

//  List<CategoryModel> _selectRights;

  void _handleJumpToFactories(CategoryModel model) {
    widget.onJumpToFactories(model);
  }

  void _handleJumpToProducts(CategoryModel model) {
    widget.onJumpToProducts(model);
  }

  @override
  void initState() {
    _verticalDivider = widget.verticalDividerOpacity;
    _multiple = widget.multiple;
    if (widget.categorySelect.isNotEmpty) {
      _selectLeft = widget.categorySelect[0].parent?.code;
      _selectRights =
          widget.categorySelect.map((category) => category.code).toList();
//      _valueItem = widget.categorySelect[0].parent.children;
      _valueItem = widget.categorys[0].children;
    } else {
      _selectLeft = widget.categorys[0].code;
      _valueItem = widget.categorys[0].children;
    }
    _color = Colors.black;
    // TODO: implement initState
    super.initState();
  }

  Widget buildValueItem(CategoryModel category) {
    return GestureDetector(
      onTap: () {
        switch (widget.categoryActionType) {
          case CategoryActionType.TO_FACTORIES:
            _handleJumpToFactories(category);
            break;
          case CategoryActionType.TO_PRODUCTS:
            _handleJumpToProducts(category);
            break;
          default:
            if (_selectRights.contains(category.code)) {
              setState(() {
                _selectRights.remove(category.code);
                widget.categorySelect.clear();
              });
            } else {
              if (_multiple) {
                setState(() {
                  _selectRights.add(category.code);
                  widget.categorySelect.add(category);
                });
              } else {
                setState(() {
                  widget.categorySelect.clear();
                  widget.categorySelect.add(category);
                  _selectRights.clear();
                  _selectRights.add(category.code);
                });
              }
            }
        }
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: _selectRights.contains(category.code)
                    ? Color.fromRGBO(255, 219, 0, 1)
                    : Colors.white)),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: Image.network(
                'https://img12.360buyimg.com/cms/jfs/t9163/239/228215842/27228/5758028d/59a3c8beN117bd14c.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Text(
              '${category.name}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _keyItem = widget.categorys.map((category) {
      if (_selectLeft == category.code) {
        _color = Color.fromRGBO(255, 214, 12, 1);
      } else {
        _color = Colors.black;
      }
      return GestureDetector(
        onTap: () {
          if (_selectLeft != category.code) {
            setState(() {
//                widget.categorySelect.clear();
              _selectLeft = category.code;
            });
          }

          _valueItem = category.children;
        },
        child: Container(
          width: 60,
          color: _selectLeft == category.code
              ? Colors.white
              : Color.fromRGBO(245, 244, 243, 1),
          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            height: 40,
            child: Text(
              category.name,
              style: TextStyle(color: _color),
            ),
          ),
        ),
      );
    }).toList();

    return Row(
      children: <Widget>[
        Container(
          width: 70,
          color: Color.fromRGBO(245, 244, 243, 1),
          child: ListView(
            children: _keyItem,
          ),
        ),
        Expanded(
          child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    sliver: SliverGrid(
                      //Grid
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, //Grid按两列显示
                        mainAxisSpacing: 5.0,
                        crossAxisSpacing: 30.0,
                        childAspectRatio: 0.6,
                      ),
                      delegate: new SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          //创建子widget
                          return buildValueItem(_valueItem[index]);
                        },
                        childCount: _valueItem.length,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Offstage(
                      offstage: !widget.hasButton,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconButton(
                            icon: Text('取消'),
                            onPressed: () {
                              setState(() {
                                widget.categorySelect.clear();
                                Navigator.pop(context);
                              });
                            },
                          ),
                          IconButton(
                            icon: Text(
                              '确定',
                              style: TextStyle(color: Color(0xffFF9516)),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
        )
      ],
    );
  }
}

/// 品类选择动作类型
enum CategoryActionType {
  ///没有动作
  none,

  /// 跳转到工厂列表
  TO_FACTORIES,

  /// 跳转到商品列表
  TO_PRODUCTS,
}
