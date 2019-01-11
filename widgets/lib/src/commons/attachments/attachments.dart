import 'package:flutter/material.dart';

//横向滚动图片列表
class Attachments extends StatelessWidget {
  const Attachments(
      {Key key,
      @required this.list,
      this.width = 320,
      this.height = 100,
      this.imageWidth = 80,
      this.imageHeight = 80})
      : super(key: key);

  final List<String> list;

  final double width;
  final double height;
  final double imageWidth;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Icon(Icons.chevron_left, color: Colors.grey),
        Expanded(
          child: _buildAttachmentsListVie(width),
        ),
        Icon(Icons.chevron_right, color: Colors.grey)
      ],
    );
  }

  Widget _buildAttachmentsListVie(double width) {
    return Container(
      padding: EdgeInsets.all(10),
      height: height,
      width: width,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: list
            .map(
              (url) => Container(
                    width: imageWidth,
                    height: imageHeight,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                      image: DecorationImage(
                        image: NetworkImage(url),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            )
            .toList(),
      ),
    );
  }
}
