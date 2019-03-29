import 'package:flutter/material.dart';
import 'package:widgets/src/commons/icon/b2b_commerce_icons.dart';

class AdvanceIconButton extends StatelessWidget {
  final Icon icon;
  final String title;
  final VoidCallback onPressed;
  final bool isHot;

  const AdvanceIconButton({
    Key key,
    @required this.icon,
    @required this.title,
    this.onPressed,
    this.isHot = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: isHot ? _buildHot() : _buildNormal(),
    );
  }

  Widget _buildHot() {
    return Container(
      width: 60,
      height: 60,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            child: Icon(
              B2BIcons.hot,
              size: 10,
              color: Color.fromRGBO(255, 46, 50, 1),
            ),
          ),
          Positioned(
            left: 5,
            top: 2,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  Container(
                    margin: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNormal() {
    return Container(
      height: 60,
      width: 60,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
