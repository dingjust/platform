import 'package:b2b_commerce/src/_shared/widgets/share_dialog.dart';
import 'package:b2b_commerce/src/common/mini_program_page_routes.dart';
import 'package:b2b_commerce/src/home/product/components/products_page_dropdown_menu.dart';
import 'package:b2b_commerce/src/home/product/components/products_search_bar.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../order_product_grid.dart';
import 'products_condition_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key key}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<String> _dropDownHeaderItemStrings = ['女装', '男装', '运动户外', '更多筛选'];

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey _stackKey = GlobalKey();

  GZXDropdownMenuController _dropdownMenuController;

  @override
  void initState() {
    super.initState();
    _dropdownMenuController = GZXDropdownMenuController();
  }

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
              // centerTitle: true,
              elevation: 0,
              actions: [
                IconButton(
                    icon: Icon(
                      B2BIconsV2.share,
                      color: Color(0xff231815),
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
            body: Stack(
              key: _stackKey,
              fit: StackFit.expand,
              children: [
                NestedScrollView(
                  headerSliverBuilder: _sliverBuilder,
                  body: ProductStaggeredGrid(),
                ),
                ProductsDropDownMunu(
                  menus: ['女装', '男装', '运动户外'],
                  dropdownMenuController: _dropdownMenuController,
                )
              ],
            )));
  }

  List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverPersistentHeader(
          pinned: true,
          delegate: _SliverAppBarDelegate(
            GZXDropDownHeader(
              items: [
                GZXDropDownHeaderItem(_dropDownHeaderItemStrings[0]),
                GZXDropDownHeaderItem(_dropDownHeaderItemStrings[1]),
                GZXDropDownHeaderItem(_dropDownHeaderItemStrings[2]),
                GZXDropDownHeaderItem(_dropDownHeaderItemStrings[3],
                    iconData: B2BIconsV2.filter, iconSize: 15),
              ],
              stackKey: _stackKey,
              controller: _dropdownMenuController,
              onItemTap: (index) {
                if (index == 3) {
                  _scaffoldKey.currentState.openEndDrawer();
                }
              },
              dividerHeight: 0,
              color: Colors.white,
              dropDownStyle: TextStyle(fontSize: 13, color: Colors.orange),
              iconDropDownColor: Colors.orange,
              borderWidth: 0,
            ),
          )),
    ];
  }

  ///分享
  void onShare() {
    String title = '钉单看款做货 原创设计 免费帮跟单';
    String description = "钉单看款做货，原创版衣快速生产就在钉单";

    const processUrl = 'image_process=resize,w_320/crop,mid,w_320,h_320';

    ShareDialog.showShareDialog(context,
        title: '$title',
        description: '$description',
        imageUrl:
            'https://cdn-oss.nbyjy.net/%E7%9C%8B%E6%AC%BE%E4%B8%8B%E5%8D%95.jpg?x-oss-process=image/resize,resize,l_420',
        path: MiniProgramPageRoutes.products,
        url: GlobalConfigs.APP_TARO_CONTEXT_PATH);
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this.child);

  final Widget child;

  @override
  double get minExtent => 40;

  @override
  double get maxExtent => 40;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }
}
