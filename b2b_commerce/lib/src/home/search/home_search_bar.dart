import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

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
            const Icon(B2BIcons.search, color: Colors.grey, size: 18),
            Text(
              tips,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
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
