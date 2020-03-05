import 'package:b2b_commerce/src/_shared/products/apparel_product_item.dart';
import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/business/orders/requirement_order_from.dart';
import 'package:b2b_commerce/src/business/products/apparel_product_form.dart';
import 'package:b2b_commerce/src/my/my_help.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/order/PageEntry.dart';
import 'package:widgets/widgets.dart';

class ApparelProductList extends StatefulWidget {
  ApparelProductList({
    Key key,
    this.status,
    this.isSelectOption = false,
    this.keyword,
  }) : super(key: key);
  final String status;

  //是否选择项
  final bool isSelectOption;
  final String keyword;

  final ScrollController scrollController = ScrollController();

  _ApparelProductListState createState() => _ApparelProductListState();
}

class _ApparelProductListState extends State<ApparelProductList> {
  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<ApparelProductBLoC>(context);

    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels ==
          widget.scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.getDatasLoadingMore(status: widget.status,keyword: widget.keyword);
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
            ApparelProductBLoC.instance.clearProductsMapByStatus(widget.status);
            return await bloc.getDatas(status: widget.status,keyword: widget.keyword);
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: widget.scrollController,
            children: <Widget>[
              StreamBuilder<PageEntry>(
                stream: widget.status == null ? bloc.stream : bloc.stream.where((pageEntry) => pageEntry.status == widget.status),
                builder: (BuildContext context,
                    AsyncSnapshot<PageEntry> snapshot) {
                  if (snapshot.data == null) {
                    bloc.getDatas(status: widget.status,keyword: widget.keyword);
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 200),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }else
                  if (snapshot.data.data.length <= 0) {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 200),
                          child: Image.asset(
                            'temp/logo2.png',
                            package: 'assets',
                            width: 80,
                            height: 80,
                          ),
                        ),
                        Container(child: Text('您当前未有产品')),
                        Container(
                          child: Text('请点击右下角创建产品'),
                        ),
                        Container(
                          child: FlatButton(
                            color: Color.fromRGBO(255, 214, 12, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MyHelpPage()));
                            },
                            child: Text('如何创建产品？'),
                          ),
                        )
                      ],
                    );
                  }
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data.data.map((product) {
                        return ApparelProductItem(
                          item: product,
                          isSelectOption: widget.isSelectOption,
                          status: widget.status,
                          onPrdouctDeleting: () => _onProudctDeleting(product),
                          onPrdouctUpdating: () => _onProudctUpdating(product),
                          onPrdouctProduction: () =>
                              _onProudctProduction(product),
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
                  // if (snapshot.data) {
                  //   widget.scrollController.animateTo(widget.scrollController.offset - 70,
                  //       duration: new Duration(milliseconds: 500),
                  //       curve: Curves.easeOut);
                  // }
                  return ScrolledToEndTips(
                    hasContent: snapshot.data,
                    scrollController: widget.scrollController,
                  );
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

  void _onProudctDeleting(ApparelProductModel product) {
    ShowDialogUtil.showAlertDialog(context, '是否要删除产品', () async {
      await ProductRepositoryImpl().delete(product.code);
      Navigator.of(context).pop();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('删除产品成功'),
        duration: Duration(
          seconds: 2,
        ),
      ));

//      ApparelProductBLoC.instance.clearProductsMapByStatus(widget.status);
      ApparelProductBLoC.instance.deleteProductResetData(widget.status,product.code);
    });
  }

  void _onProudctUpdating(ApparelProductModel product) {
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

  void _onProudctProduction(ApparelProductModel product) {
    RequirementOrderModel orderModel =
    RequirementOrderModel(details: RequirementInfoModel(), attachments: []);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RequirementOrderFrom(
                  product: product,
                  isCreate: true,
                  order: orderModel,
                )));
  }

  void _onProductShlefing(ApparelProductModel product) {
    if (product.approvalStatus == ArticleApprovalStatus.approved) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return RequestDataLoading(
              requestCallBack: ProductRepositoryImpl().off(product.code),
              outsideDismiss: false,
              loadingText: '正在保存。。。',
              entrance: '',
            );
          }).then((value) {
        bool result = false;
        if (value != null && value != '') {
          result = false;
        } else {
          result = true;
        }
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return CustomizeDialog(
                dialogType: DialogType.RESULT_DIALOG,
                successTips: '下架成功',
                failTips: '下架失败',
                callbackResult: result,
                confirmAction: () {
                  Navigator.of(context).pop();
                },
              );
            });
        ApparelProductBLoC.instance.clearProductsMap();
        ApparelProductBLoC.instance.getDatas(status: widget.status);
      });
    } else if (product.approvalStatus == ArticleApprovalStatus.unapproved) {
      if (product.variants == null || product.variants.isEmpty) {
        _showValidateMsg(context, '颜色尺码为空不可上架');
        return;
      }

      if (UserBLoC.instance.currentUser.type == UserType.BRAND &&
          product.price == null) {
        _showValidateMsg(context, '产品价格为空不可上架');
        return;
      } else if (UserBLoC.instance.currentUser.type == UserType.FACTORY ){
          if(product.proofingFee == null || product.basicProduction == null || product.productionIncrement == null || product.productionDays == null) {
            _showValidateMsg(context, '价格设置资料未完善，不可上架');
            return;
          }else{
            bool b = false;
            if(product.steppedPrices == null || product.steppedPrices.isEmpty){
              print('${product.steppedPrices}-------');
              b = true;
            }else{
              print('${product.steppedPrices}======');
              for (var stepped in product.steppedPrices) {
                if(stepped.minimumQuantity == null || stepped.price == null){
                  b = true;
                  return;
                }
              }
            }

            if(b){
              _showValidateMsg(context, '价格设置资料未完善，不可上架');
              return;
            }

          }
      }



      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return RequestDataLoading(
              requestCallBack: ProductRepositoryImpl().on(product.code),
              outsideDismiss: false,
              loadingText: '正在保存。。。',
              entrance: '',
            );
          }).then((value) {
            print('value${value}');
        bool result = false;
        if (value != null && value != '') {
          result = false;
        } else {
          result = true;
        }
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return CustomizeDialog(
                dialogType: DialogType.RESULT_DIALOG,
                successTips: '上架成功',
                failTips: '上架失败',
                callbackResult: result,
                confirmAction: () {
                  Navigator.of(context).pop();
                },
              );
            });
            ApparelProductBLoC.instance.clearProductsMap();
            ApparelProductBLoC.instance.getDatas(status: widget.status);
      });
    }
  }

  //非空提示
  bool _showValidateMsg(BuildContext context, String message) {
    _validateMessage(context, '${message}');
    return false;
  }

  Future<void> _validateMessage(BuildContext context, String message) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.RESULT_DIALOG,
            failTips: '${message}',
            callbackResult: false,
            outsideDismiss: true,
          );
        });
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
