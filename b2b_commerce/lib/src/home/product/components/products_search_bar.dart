import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ProductsSearchBar extends StatelessWidget {
  final double width;
  final double height;
  final String tips;
  final VoidCallback onTap;
  final ValueChanged<String> onSearch;

  const ProductsSearchBar({
    Key key,
    this.width = 400,
    this.height = 35,
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
              Container(
                margin: EdgeInsets.only(left: 10),
                // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                // decoration: BoxDecoration(
                //     color: Colors.grey[100],
                //     borderRadius: BorderRadius.circular(5)),
                child: Text(
                  state.keyword ?? tips,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
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
