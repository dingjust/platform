import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

class ProductsScroll extends StatelessWidget {
  final double height;

  const ProductsScroll({Key key, this.height = 50}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductHomeState>(
        builder: (context, ProductHomeState homteState, _) => Container(
              height: height,
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://yijiayi.oss-cn-shenzhen.aliyuncs.com/product_home_banner.png'),
                    fit: BoxFit.fill,
                  )),
            ));
  }
}
