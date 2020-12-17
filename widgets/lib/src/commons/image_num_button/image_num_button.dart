import 'package:flutter/material.dart';

class ImageNumButton extends StatelessWidget {
  final Image image;

  final int number;

  final VoidCallback onPressed;

  final String title;

  final bool showNum;

  final double width;

  final double height;

  final EdgeInsetsGeometry imagePadding;

  final Color backgroundColor;

  const ImageNumButton(
      {Key key,
      this.image,
      this.number = 0,
      this.onPressed,
      this.title,
      this.showNum = false,
      this.width = 55,
      this.height = 90,
      this.backgroundColor = Colors.white,
      this.imagePadding = const EdgeInsets.all(10)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Material(
        color: backgroundColor,
        child: InkWell(
          onTap: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildImage(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      padding: imagePadding,
      height: height - 18,
      child: Stack(
        children: <Widget>[
          Container(
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
