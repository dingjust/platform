import 'package:flutter/material.dart';

class EasyGrid extends StatefulWidget {
  //传入数据List,只能是List<Map>格式，Map的key为：title,subtitle,pic(即图片url)
  final List<dynamic> dataList;
  //标题字体样式
  final TextStyle titleFont;
  //副标题字体样式
  final TextStyle subtitleFont;

  EasyGrid({@required this.dataList,this.subtitleFont,this.titleFont});

  _EasyGridState createState() => _EasyGridState();
}

class _EasyGridState extends State<EasyGrid> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 300,
          margin: EdgeInsets.all(5),
          child: GridView.count(
              physics: new NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              //宽高比
              childAspectRatio: 5 / 2.5,
              children: List.generate(widget.dataList.length, (index) {
                return GestureDetector(
                    child:Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(5),
                    child: Center(
                      child:Row(
                        children: <Widget>[
                          Expanded(
                            child:ListTile(
                              title: Text(
                                  widget.dataList[index]['title'],
                                style: widget.titleFont == null ?
                                TextStyle(
                                  fontSize: 16,
                                  color: Colors.black
                                ) : widget.titleFont,
                              ),
                              subtitle: Text(widget.dataList[index]['subtitle'],
                                style: widget.subtitleFont == null ?
                                TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey
                                ) : widget.subtitleFont,
                              ),
                          )),
                          Image.network(
                              widget.dataList[index]['pic'],
                              width: 60,
                              height: 80,
                            ),
                        ],
                      ),
                    ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                  onTap: () {
                    print(widget.dataList[index]['title']+widget.dataList[index]['subtitle']+widget.dataList[index]['pic']);
                  },
                );
              })
          ),
        );
  }


}
