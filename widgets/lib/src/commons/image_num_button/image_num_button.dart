import 'package:flutter/material.dart';

class ImageNumButton extends StatelessWidget {
  final Image image;

  final int number;

  final VoidCallback onPressed;

  final String title;

  final bool showNum;

  final double width;

  final double height;

  const ImageNumButton(
      {Key key,
      this.image,
      this.number = 0,
      this.onPressed,
      this.title,
      this.showNum = false,
      this.width = 55,
      this.height = 80})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: Container(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildImage(),
            Container(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 5),
            child: image,
          ),
          Positioned(
              right: 0,
              child: Opacity(
                opacity: showNum ? 1.0 : 0,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                  child: Center(
                    child: Text(
                      '$number',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
