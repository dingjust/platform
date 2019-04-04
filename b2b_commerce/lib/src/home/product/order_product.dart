import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../../_shared/widgets/scroll_to_top_button.dart';
import '../../home/product/product.dart';
import '../../home/search/order_product_search.dart';

class ProductsPage extends StatefulWidget {
  /// 品类
  CategoryModel categoryModel;

  ProductsPage({Key key, this.categoryModel}) : super(key: key);

  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  GlobalKey _ProductsPageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<OrderByProductBLoc>(
      key: _ProductsPageKey,
      bloc: OrderByProductBLoc.instance,
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          centerTitle: true,
          elevation: 0.5,
          title: Text(
            '看款下单',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                B2BIcons.search,
                size: 22,
              ),
              onPressed: () => showSearch(
                    context: context,
                    delegate: OrderProductSearchDelegate(),
                  ),
            ),
            // IconButton(
            //   icon: Icon(
            //     B2BIcons.condition,
            //     size: 18,
            //   ),
            //   onPressed: () {},
            // )
          ],
        ),
        body: ProductsView(
          categoryCode: widget.categoryModel.code,
        ),
        floatingActionButton: ScrollToTopButton<OrderByProductBLoc>(),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    OrderByProductBLoc.instance.clear();
    super.dispose();
  }
}

class ProductsView extends StatelessWidget {
  String categoryCode;

  ProductsView({this.categoryCode});

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<OrderByProductBLoc>(context);

    //监听是否已经到底
    bloc.bottomStream.listen((isBottom) {
      if (isBottom) {
        _scrollController.animateTo(_scrollController.offset - 70,
            duration: new Duration(milliseconds: 500), curve: Curves.easeOut);
      }
    });

    //监听滚动事件，打印滚动位置
    _scrollController.addListener(() {
      if (_scrollController.offset < 500) {
        bloc.hideToTopBtn();
      } else if (_scrollController.offset >= 500) {
        bloc.showToTopBtn();
      }
    });

    //状态管理触发的返回顶部
    bloc.returnToTopStream.listen((data) {
      //返回到顶部时执行动画
      if (data) {
        _scrollController.animateTo(.0, duration: Duration(milliseconds: 200), curve: Curves.ease);
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMore(categoryCode);
      }
    });

    return Container(
        decoration: BoxDecoration(color: Color.fromRGBO(245, 245, 245, 1)),
        child: RefreshIndicator(
          onRefresh: () async {
            bloc.clear();
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              StreamBuilder<List<ApparelProductModel>>(
                  stream: bloc.stream,
                  initialData: null,
                  builder: (BuildContext context, AsyncSnapshot<List<ApparelProductModel>> snapshot) {
                    //数据为空查询数据，显示加载条
                    if (snapshot.data == null) {
                      bloc.getData(categoryCode);
                      return SliverToBoxAdapter(
                        child: ProgressIndicatorFactory.buildPaddedProgressIndicator(),
                      );
                    } else {
                      return SliverToBoxAdapter(
                        child: Container(),
                      );
                    }
                  }),
              StreamBuilder<List<ApparelProductModel>>(
                  stream: bloc.stream,
                  initialData: bloc.products,
                  builder: (BuildContext context, AsyncSnapshot<List<ApparelProductModel>> snapshot) {
                    if (snapshot.data.isNotEmpty) {
                      List<RecommendProductItem> recommendProductItems = snapshot.data
                          .map((product) => RecommendProductItem(
                                model: product,
                                showAddress: true,
                              ))
                          .toList();

                      return SliverPadding(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                        sliver: SliverGrid(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, //Grid按两列显示
                            mainAxisSpacing: 12.0,
                            crossAxisSpacing: 12.0,
                            childAspectRatio: 0.65,
                          ),
                          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                            return recommendProductItems[index];
                          }, childCount: snapshot.data.length),
                        ),
                      );
                    } else {
                      return SliverPadding(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                      );
                    }
                  }),
              // StreamBuilder<bool>(
              //   stream: bloc.bottomStream,
              //   initialData: false,
              //   builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              //     if (snapshot.data) {
              //       _scrollController.animateTo(_scrollController.offset - 70,
              //           duration: new Duration(milliseconds: 500),
              //           curve: Curves.easeOut);
              //     }
              //     // return SliverToBoxAdapter(
              //     //   child: snapshot.data
              //     //       ? Container(
              //     //           padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
              //     //           child: Center(
              //     //             child: Text(
              //     //               "┑(￣Д ￣)┍ 已经到底了",
              //     //               style: TextStyle(color: Colors.grey),
              //     //             ),
              //     //           ),
              //     //         )
              //     //       : Container(),
              //     // );
              //     return
              //   },
              // ),
              StreamBuilder<bool>(
                stream: bloc.loadingStream,
                initialData: false,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  return SliverToBoxAdapter(
                    child: ProgressIndicatorFactory.buildPaddedOpacityProgressIndicator(
                      opacity: snapshot.data ? 1.0 : 0,
                    ),
                  );
                },
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 30,
                ),
              ),
            ],
          ),
        ));
  }
}
