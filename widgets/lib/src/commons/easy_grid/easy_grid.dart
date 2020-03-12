import 'package:b2b_commerce/b2b_commerce.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class EasyGrid extends StatelessWidget {
  // 传入数据List,只能是List<Map>格式，Map的key为：title, picture(即图片url)
  final List<GridItem> items;

  // 组件高度
  final double height;

  // 组件是否滚动
  final bool scrollable;

  EasyGrid({
    Key key,
    @required this.items,
    this.height = 90,
    this.scrollable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        margin: EdgeInsets.all(5),
        child: GridView(
          physics: !scrollable ? NeverScrollableScrollPhysics() : null,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 250.0,
            childAspectRatio: 2.40, //宽高比为2
            crossAxisSpacing: 10,
          ),
          children: List.generate(
              items.length, (index) => EasyGridItem(item: items[index])),
        ));
  }
}

class EasyGridItem extends StatelessWidget {
  const EasyGridItem({Key key, @required this.item}) : super(key: key);

  final GridItem item;

  @override
  Widget build(BuildContext context) {
    if (item.authorizations == null || item.authorizations.isEmpty) {
      return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300],
                blurRadius: 5.0,
                spreadRadius: 2.0,
                offset: Offset(0, 3.0),
              ),
            ],
          ),
          child: FlatButton(
            onPressed: item.onPressed,
            child: Container(
              padding: EdgeInsets.fromLTRB(15, 5, 10, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 20,
                              color: Color.fromRGBO(32, 32, 32, 1),
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      )),
                  item.icon != null ? item.icon : Container(),
                ],
              ),
            ),
          ));
    } else {
      return AuthorizationDector(
        authorizations: item.authorizations,
        opacity: 1,
        message: '无操作权限',
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300],
                  blurRadius: 5.0,
                  spreadRadius: 2.0,
                  offset: Offset(0, 3.0),
                ),
              ],
            ),
            child: FlatButton(
              onPressed: item.onPressed,
              child: Container(
                padding: EdgeInsets.fromLTRB(15, 5, 10, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(32, 32, 32, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        )),
                    item.icon != null ? item.icon : Container(),
                  ],
                ),
              ),
            )),
      );
    }
  }
}

class GridItem {
  ///标题
  final String title;

  ///图片
  final Image icon;

  ///触发函数
  final VoidCallback onPressed;

  final List<Authorization> authorizations;

  GridItem({
    this.authorizations,
    @required this.title,
    this.icon,
    @required this.onPressed,
  });
}
