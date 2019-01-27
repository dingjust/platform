import 'package:flutter/material.dart';

class EasyGrid extends StatefulWidget {
  //传入数据List,只能是List<Map>格式，Map的key为：title,subtitle,pic(即图片url)
  final List<GridItem> dataList;
  //标题字体样式
  final TextStyle titleFont;
  //副标题字体样式
  final TextStyle subtitleFont;

  ///组件高度
  final double height;

  ///子项宽度
  final double itemWidth;

  EasyGrid(
      {@required this.dataList,
      this.subtitleFont,
      this.titleFont,
      this.height = 300,
      this.itemWidth = 240.0});

  _EasyGridState createState() => _EasyGridState();
}

class _EasyGridState extends State<EasyGrid> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.height,
        margin: EdgeInsets.all(5),
        child: GridView(
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: widget.itemWidth,
              childAspectRatio: 2.35 //宽高比为2
              ),
          children: List.generate(widget.dataList.length, (index) {
            return GestureDetector(
                child: Container(
                  padding: EdgeInsets.fromLTRB(5, 5, 15, 5),
                  margin: EdgeInsets.all(3),
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: ListTile(
                          title: Text(
                            widget.dataList[index].title,
                            style: widget.titleFont == null
                                ? TextStyle(fontSize: 16, color: Colors.black)
                                : widget.titleFont,
                          ),
                          subtitle: widget.dataList[index].subtitle != null
                              ? Text(
                                  widget.dataList[index].subtitle,
                                  style: widget.subtitleFont == null
                                      ? TextStyle(
                                          fontSize: 14, color: Colors.grey)
                                      : widget.subtitleFont,
                                )
                              : null,
                        )),
                        widget.dataList[index].pic,
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onTap: widget.dataList[index].onPressed);
          }),
        ));
  }
}

class GridItem {
  ///标题
  final String title;

  ///子标题
  final String subtitle;

  ///图片
  final Image pic;

  ///触发函数
  final VoidCallback onPressed;

  GridItem(
      {@required this.title,
      this.subtitle,
      @required this.pic,
      @required this.onPressed});
}
