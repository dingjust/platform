import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../../home/product/product.dart';

class ProductsView extends StatelessWidget {
  ProductCondition productCondition;
  String factoryUid;

  ProductsView({
    this.productCondition,
    this.factoryUid,
  });

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<OrderByProductBLoc>(context);

    //监听筛选条件更改
    bloc.conditionStream.listen((condition) {
      bloc.clear();
      productCondition.sortCondition = condition.value;
      //默认价格升序
      if (condition.value == 'minPrice') {
        productCondition.sort = 'ASC';
      } else {
        productCondition.sort = 'desc';
      }
      if (factoryUid == null) {
        OrderByProductBLoc.instance.getData(productCondition);
      } else {
        OrderByProductBLoc.instance.getCashProducts(factoryUid);
      }
    });

    //监听是否已经到底
    // bloc.bottomStream.listen((isBottom) {
    //   if (isBottom) {
    //     _scrollController.animateTo(_scrollController.offset - 70,
    //         duration: new Duration(milliseconds: 500), curve: Curves.easeOut);
    //   }
    // });

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
        _scrollController.animateTo(.0,
            duration: Duration(milliseconds: 200), curve: Curves.ease);
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        if (factoryUid == null) {
          bloc.loadingMore(productCondition);
        } else {
          bloc.loadingMoreByCastProducts(factoryUid);
        }
      }
    });

    return Container(
        decoration: BoxDecoration(color: Color.fromRGBO(245, 245, 245, 1)),
        child: RefreshIndicator(
          onRefresh: () async {
//            bloc.clear();
            if (factoryUid == null) {
              OrderByProductBLoc.instance.getData(productCondition);
            } else {
              OrderByProductBLoc.instance.getCashProducts(factoryUid);
            }
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              StreamBuilder<List<ApparelProductModel>>(
                  stream: bloc.stream,
                  initialData: null,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ApparelProductModel>> snapshot) {
                    //数据为空查询数据，显示加载条
                    if (snapshot.data == null) {
                      if (factoryUid == null) {
                        OrderByProductBLoc.instance.getData(productCondition);
                      } else {
                        OrderByProductBLoc.instance.getCashProducts(factoryUid);
                      }
                      return SliverToBoxAdapter(
                        child: ProgressIndicatorFactory
                            .buildPaddedProgressIndicator(),
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
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ApparelProductModel>> snapshot) {
                    if (snapshot.data != null && snapshot.data.isNotEmpty) {
                      List<RecommendProductItem> recommendProductItems =
                          snapshot.data
                              .map((product) => RecommendProductItem(
                                    model: product,
                                    showAddress: true,
                                  ))
                              .toList();

                      return SliverPadding(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, //Grid按两列显示
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0,
                            childAspectRatio: 0.60,
                          ),
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
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
                    child: ProgressIndicatorFactory
                        .buildPaddedOpacityProgressIndicator(
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
