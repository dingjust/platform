import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

//横向滚动图片列表
class Attachments extends StatefulWidget {
  Attachments(
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

  _AttachmentsState createState() => _AttachmentsState();
}

class _AttachmentsState extends State<Attachments> {
  ScrollController _scrollController = new ScrollController();
  Color iconColorLeft = Colors.grey[200];
  Color iconColorRight = Colors.black;

  @override
  Widget build(BuildContext context) {
    //监听到底
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          iconColorRight = Colors.grey[200];
        });
      } else if (_scrollController.position.pixels == 0) {
        //监听开头
        setState(() {
          iconColorLeft = Colors.grey[200];
        });
      } else {
        setState(() {
          iconColorLeft = Colors.black;
          iconColorRight = Colors.black;
        });
      }
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: iconColorLeft,
          ),
          tooltip: '上一张',
          onPressed: () {
            _scrollController.animateTo(_scrollController.position.pixels - 100,
                duration: Duration(milliseconds: 200), curve: Curves.ease);
          },
        ),
        Expanded(
          child: _buildAttachmentsListVie(widget.width, context),
        ),
        IconButton(
          icon: Icon(
            Icons.chevron_right,
            color: iconColorRight,
          ),
          tooltip: '下一张',
          onPressed: () {
            _scrollController.animateTo(_scrollController.position.pixels + 100,
                duration: Duration(milliseconds: 200), curve: Curves.ease);
          },
        ),
      ],
    );
  }

  Widget _buildAttachmentsListVie(double width, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: widget.height,
      width: width,
      child: ListView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        children: widget.list
            .map(
              (url) => GestureDetector(
                    child: Container(
                      width: widget.imageWidth,
                      height: widget.imageHeight,
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
                    onTap: () {
                      onPreview(context, url);
                    },
                  ),
            )
            .toList(),
      ),
    );
  }

  void onPreview(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
            child: PhotoView(
          imageProvider: NetworkImage(url),
        ));
      },
    );
  }
}
