import 'package:flutter/material.dart';

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
            maxCrossAxisExtent: 240.0,
            childAspectRatio: 2.35, //宽高比为2
            crossAxisSpacing: 10,
          ),
          children: List.generate(
            items.length,
            (index) => GestureDetector(
                  child: EasyGridItem(item: items[index]),
                  onTap: items[index].onPressed,
                ),
          ),
        ));
  }
}

class EasyGridItem extends StatelessWidget {
  const EasyGridItem({Key key, @required this.item}) : super(key: key);

  final GridItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200],
            blurRadius: 5.0,
            spreadRadius: 2.0,
            offset: Offset(0, 3.0),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(5, 5, 15, 5),
        child: Center(
          child: Row(
            children: <Widget>[
              Expanded(
                child: ListTile(
                  title: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(32, 32, 32, 1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              item.icon,
            ],
          ),
        ),
      ),
    );
  }
}

class GridItem {
  ///标题
  final String title;

  ///图片
  final Image icon;

  ///触发函数
  final VoidCallback onPressed;

  GridItem({
    @required this.title,
    @required this.icon,
    @required this.onPressed,
  });
}
