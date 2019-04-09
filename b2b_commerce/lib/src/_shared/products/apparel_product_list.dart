import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/_shared/products/apparel_product_item.dart';
import 'package:b2b_commerce/src/business/orders/requirement_order_from.dart';
import 'package:b2b_commerce/src/business/products/apparel_product_form.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ApparelProductList extends StatefulWidget {
  ApparelProductList({Key key, this.status, this.isSelectOption})
      : super(key: key);
  final String status;

  //是否选择项
  final bool isSelectOption;

  final ScrollController scrollController = ScrollController();

  _ApparelProductListState createState() => _ApparelProductListState();
}

class _ApparelProductListState extends State<ApparelProductList>{

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<ApparelProductBLoC>(context);

    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels ==
          widget.scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMoreByStatuses(widget.status);
      }
    });

    //监听滚动事件，打印滚动位置
    widget.scrollController.addListener(() {
      if (widget.scrollController.offset < 500) {
        bloc.hideToTopBtn();
      } else if (widget.scrollController.offset >= 500) {
        bloc.showToTopBtn();
      }
    });

    //状态管理触发的返回顶部
    bloc.returnToTopStream.listen((data) {
      //返回到顶部时执行动画
      if (data) {
        widget.scrollController.animateTo(.0,
            duration: Duration(milliseconds: 200), curve: Curves.ease);
      }
    });

    return Container(
        decoration: BoxDecoration(color: Colors.grey[100]),
//        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: RefreshIndicator(
          onRefresh: () async {
            return await bloc.filterByStatuses(widget.status);
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: widget.scrollController,
            children: <Widget>[
              StreamBuilder<List<ApparelProductModel>>(
                stream: bloc.stream,
                // initialData: null,
                builder: (BuildContext context,
                    AsyncSnapshot<List<ApparelProductModel>> snapshot) {
                  if (snapshot.data == null) {
                    bloc.filterByStatuses(widget.status);
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 200),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data.map((product) {
                        return ApparelProductItem(
                          item: product,
                          isSelectOption: widget.isSelectOption,
                          status: widget.status,
                          onPrdouctDeleting: () => _onProudctDeleting(product),
                          onPrdouctUpdating: () => _onProudctUpdating(product),
                          onPrdouctProduction: () => _onProudctProduction(product),
                          onProductShlefing: () => _onProductShlefing(product),
                        );
                      }).toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                },
              ),
              StreamBuilder<bool>(
                stream: bloc.bottomStream,
                initialData: false,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.data) {
                    widget.scrollController.animateTo(widget.scrollController.offset - 70,
                        duration: new Duration(milliseconds: 500),
                        curve: Curves.easeOut);
                  }
                  return ScrolledToEndTips(hasContent: snapshot.data);
                },
              ),
              StreamBuilder<bool>(
                stream: bloc.loadingStream,
                initialData: false,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Center(
                      child: new Opacity(
                        opacity: snapshot.data ? 1.0 : 0,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }

  void _onProudctDeleting(ApparelProductModel product){
    ShowDialogUtil.showAlertDialog(context, '是否要删除商品', () async {
      await ProductRepositoryImpl().delete(product.code);
      Navigator.of(context).pop();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('删除商品成功'),
        duration: Duration(
          seconds: 2,
        ),
      ));
      ApparelProductBLoC.instance.filterByStatuses(widget.status);
    });
  }

  void _onProudctUpdating(ApparelProductModel product){
    ProductRepositoryImpl().detail(product.code).then((product) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BLoCProvider(
            bloc: ApparelProductBLoC.instance,
            child: ApparelProductFormPage(
              item: product,
              status: widget.status,
            ),
          ),
        ),
      );
    });
  }
  void _onProudctProduction(ApparelProductModel product){
    // TODO: 带到商品，跳到需求页面
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RequirementOrderFrom(
              product: product,
            )));
  }
  void _onProductShlefing(ApparelProductModel product){
    //TODO:商品上下架
    if (product.approvalStatus ==
        ArticleApprovalStatus.approved) {
      ProductRepositoryImpl().off(product.code).then((a) {
        ApparelProductBLoC.instance
            .filterByStatuses(widget.status);
      });
    } else if (product.approvalStatus ==
        ArticleApprovalStatus.unapproved) {
      ProductRepositoryImpl().on(product.code).then((a) {
        ApparelProductBLoC.instance
            .filterByStatuses(widget.status);
      });
    }
  }
}

//class _ToTopBtn extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    final bloc = ProductBlocProvider.of(context);
//
//    return StreamBuilder<bool>(
//        stream: bloc.toTopBtnStream,
//        initialData: false,
//        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
//          return snapshot.data
//              ? FloatingActionButton(
//                  child: Icon(
//                    Icons.arrow_upward,
//                    color: Colors.white,
//                  ),
//                  onPressed: () {
//                    bloc.returnToTop();
//                  },
//                  backgroundColor: Colors.blue,
//                )
//              : Container();
//        });
//  }
//}
