import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ProductsSearchBar extends StatelessWidget {
  // final double width;
  final double height;
  final String tips;
  final VoidCallback onTap;
  final ValueChanged<String> onSearch;

  const ProductsSearchBar({
    Key key,
    // this.width = 400,
    this.height = 32,
    this.tips = '搜索关键字',
    this.onTap,
    this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductState>(
      builder: (context, ProductState state, _) => Container(
          child: GestureDetector(
        onTap: () => _onTap(context, state),
        child: Container(
          // width: width,
          height: height,
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          decoration: BoxDecoration(
            color: Color(0xffF0F0F0),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: <Widget>[
              const Icon(B2BIconsV2.search, color: Color(0xff999999), size: 16),
              Container(
                // margin: EdgeInsets.only(left: 10),
                child: Text(
                  state.keyword ?? tips,
                  style:
                      const TextStyle(color: Color(0xff999999), fontSize: 13),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  void _onTap(BuildContext context, ProductState state) {
    if (onTap != null) {
      onTap.call();
    } else {
      Navigator.of(context).pushNamed(AppRoutes.ROUTE_PRODUCTS_SEARCH,
          arguments: {'keyword': state.keyword}).then((keyword) {
        onSearch?.call(keyword);
        state
          ..keyword = keyword
          ..clear();
      });
    }
  }
}
