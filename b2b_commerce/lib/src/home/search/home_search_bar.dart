import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:flutter/material.dart';

class HomeSearchBar extends StatelessWidget {
  final double width;
  final double height;
  final String tips;
  final VoidCallback onTap;

  const HomeSearchBar({
    Key key,
    this.width = 400,
    this.height = 35,
    this.tips = '   搜索关键字',
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[300], width: 0.5),
        ),
        child: Row(
          children: <Widget>[
            Container(
              child: B2BV2Image.top_2(width: 16, height: 16),
            ),
            Text(
              tips,
              style: const TextStyle(color: Color(0xff999999), fontSize: 13),
            )
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context) {
    if (onTap != null) {
      onTap.call();
    } else {
      Navigator.of(context).pushNamed(AppRoutes.ROUTE_HOME_SEARCH);
    }
  }
}

class SearchBar extends StatelessWidget {
  // final double width;
  final double height;
  final String tips;
  final VoidCallback onTap;

  const SearchBar({
    Key key,
    // this.width = 400,
    this.height = 32,
    this.tips = '   搜索关键字',
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: Container(
        // width: width,
        height: height,
        margin: EdgeInsets.only(right: 12),
        padding: EdgeInsets.only(left: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0xffFED800), width: 0.5),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(
                  tips,
                  style: const TextStyle(color: Color(0xff222222),
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ))
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context) {
    if (onTap != null) {
      onTap.call();
    } else {
      Navigator.of(context).pushNamed(AppRoutes.ROUTE_HOME_SEARCH);
    }
  }
}
