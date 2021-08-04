import 'package:b2b_commerce/src/home/product/components/products_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';
import 'package:core/core.dart';

import '../order_product_grid.dart';
import 'products_condition_page.dart';

import 'package:b2b_commerce/src/_shared/widgets/share_dialog.dart';
import 'package:b2b_commerce/src/common/mini_program_page_routes.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key key}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ProductState()),
        ],
        child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: ProductsSearchBar(),
              brightness: Brightness.light,
              centerTitle: true,
              elevation: 0.5,
              actions: [
                Builder(
                  builder: (context) => TextButton(
                    child: Text(
                      '筛选',
                      style: TextStyle(color: Colors.black54),
                    ),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
                IconButton(
                    icon: Icon(
                      B2BIconsV2.share,
                      color: Color.fromRGBO(0, 0, 0, 0.6),
                    ),
                    onPressed: onShare),
              ],
            ),
            endDrawer: Drawer(
                child: Builder(
              builder: (iContext) => ProductsConditionPage(
                state: Provider.of<ProductState>(iContext, listen: false),
              ),
            )),
            body: ProductGrid()));
  }

  ///分享
  void onShare() {
    String title = '钉单看款做货 原创设计 免费帮跟单';
    String description = "钉单看款做货，原创版衣快速生产就在钉单";

    const processUrl = 'image_process=resize,w_320/crop,mid,w_320,h_320';

    ShareDialog.showShareDialog(context,
        title: '$title',
        description: '$description',
        imageUrl: '${GlobalConfigs.LOGO_URL}',
        path: MiniProgramPageRoutes.products,
        url: GlobalConfigs.APP_TARO_CONTEXT_PATH);
  }
}
