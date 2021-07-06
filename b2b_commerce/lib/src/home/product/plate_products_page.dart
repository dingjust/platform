import 'package:b2b_commerce/src/_shared/widgets/category_selector.dart';
import 'package:b2b_commerce/src/business/search/history_search.dart';
import 'package:b2b_commerce/src/home/product/plate_products_view.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

import 'components/filter_bar.dart';
import 'components/product_condition_drawer.dart';

class PlateProductsPage extends StatefulWidget {
  final SeeProductPlateType type;

  final ProductType productType;

  final String title;

  ProductCondition condition;

  PlateProductsPage({
    this.type,
    Key key,
    this.productType,
    this.title,
    this.condition,
  }) {
    if (condition == null) {
      this.condition = ProductCondition([], '');
    }
  }

  @override
  _PlateProductsPageState createState() => _PlateProductsPageState();
}

class _PlateProductsPageState extends State<PlateProductsPage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey _stackKey = GlobalKey();
  GZXDropdownMenuController dropdownMenuController =
      GZXDropdownMenuController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PlateProductState>(
      create: (context) =>
          PlateProductState(type: widget.type, condition: widget.condition),
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          elevation: 0.5,
          title: _Title(
            type: widget.type,
            productType: widget.productType,
            title: widget.title,
          ),
          centerTitle: true,
          actions: <Widget>[_SearchBtn()],
        ),
        body: Scaffold(
            key: _scaffoldKey,
            endDrawer: Drawer(child: ProductConditionDrawer()),
            body: Stack(
              key: _stackKey,
              fit: StackFit.expand,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    ProductFilterBar(
                      openEndDrawer: () {
                        _scaffoldKey.currentState.openEndDrawer();
                      },
                      openSelector: () {
                        dropdownMenuController.show(0);
                      },
                    ),
                    Expanded(
                      flex: 1,
                      child: PlateProductsView(),
                    ),
                  ],
                ),
                _DownMenu(
                  dropdownMenuController: dropdownMenuController,
                )
              ],
            )),
      ),
    );
  }
}

class _DownMenu extends StatelessWidget {
  final GZXDropdownMenuController dropdownMenuController;

  const _DownMenu({Key key, this.dropdownMenuController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PlateProductState state =
        Provider.of<PlateProductState>(context, listen: false);

    return Builder(
      builder: (dropMenuContext) => GZXDropDownMenu(
        // controller用于控制menu的显示或隐藏
        controller: dropdownMenuController,
        // 下拉菜单显示或隐藏动画时长
        animationMilliseconds: 0,
        // 下拉菜单，高度自定义，你想显示什么就显示什么，完全由你决定，你只需要在选择后调用_dropdownMenuController.hide();即可
        menus: [
          GZXDropdownMenuBuilder(
              dropDownHeight: 40 * 8.0,
              dropDownWidget: Builder(
                builder: (selectContext) =>
                    CategorySelector(callBack: (category) {
                  if (category != null) {
                    state.condition.categories = [category];
                  } else {
                    state.condition.categories = [];
                  }
                  state.clear();
                  dropdownMenuController.hide();
                }),
              )),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final SeeProductPlateType type;

  final ProductType productType;

  final String title;

  const _Title({Key key, this.type, this.productType, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    PlateProductState state = Provider.of<PlateProductState>(
        context, listen: false);

    if (state.condition.keyword != null && state.condition.keyword != '') {
      return Text('搜索：${state.condition.keyword}');
    }

    if (type != null) {
      return Text('${SeeProductPlateTypeLocalizedMap[type]}');
    }

    if (productType != null) {
      return Text('${ProductTypeLocalizedMap[productType]}');
    }

    return Text(title ?? '看款下单');
  }
}

class _SearchBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PlateProductState state = Provider.of<PlateProductState>(
        context, listen: false);

    return IconButton(
        icon: Icon(Icons.search),
        onPressed: () async {
          dynamic result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HistorySearch(
                      historyKey:
                      GlobalConfigs.ORDER_PRODUCT_HISTORY_KEYWORD_KEY,
                      hintText: '请输入编码，名称，货号搜索',
                      keyword: state.condition.keyword,
                    )),
          );

          if (result != null) {
            state.condition.keyword = result;
            state.clear();
          }
        });
  }
}
