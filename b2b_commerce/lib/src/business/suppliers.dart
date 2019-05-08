import 'package:b2b_commerce/src/home/factory/factory_list.dart';
import 'package:b2b_commerce/src/home/pool/requirement_pool_all.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import './search/suppliers_search.dart';
import './supplier/provider/suppliers_provider.dart';
import '../my/my_brand.dart';
import '../my/my_factory.dart';

class SuppliersPage extends StatefulWidget {
  _SuppliersPageState createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
  @override
  Widget build(BuildContext context) {
    return SuppliersBlocProvider(
        child: Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: true,
        elevation: 0.5,
        title: Text('合作商管理'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              B2BIcons.search,
              size: 20,
            ),
            onPressed: () => showSearch(context: context, delegate: SuppliersSearchDelegate()),
          ),
        ],
      ),
      body: Container(
        child: SuppliersList(),
      ),
      floatingActionButton: ToTopBtn(),
    ));
  }
}

class SuppliersList extends StatelessWidget {
  SuppliersList();

  final ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    final bloc = SuppliersBlocProvider.of(context);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        UserBLoC.instance.currentUser.type == UserType.BRAND
            ? bloc.loadingMoreByFactories()
            : bloc.loadingMoreByBrands();
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

    return UserBLoC.instance.currentUser.type == UserType.BRAND
        ? _buildFactoryContainer(bloc)
        : _buildBrandContainer(bloc);
  }

  Container _buildFactoryContainer(SuppliersBloc bloc) {
    return Container(
        decoration: BoxDecoration(color: Colors.grey[100]),
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: RefreshIndicator(
          onRefresh: () {
            return bloc.filterfactories();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            children: <Widget>[
              StreamBuilder<List<FactoryModel>>(
                stream: bloc.factoryStream,
                initialData: null,
                builder: (BuildContext context, AsyncSnapshot<List<FactoryModel>> snapshot) {
                  if (snapshot.data == null) {
                    bloc.filterfactories();
                    return ProgressIndicatorFactory.buildPaddedProgressIndicator();
                  }
                  if (snapshot.data.length >= 0) {
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
                        Container(
                            child: Text('您还没有合作商')
                        ),
                        Container(
                          child: FlatButton(
                            onPressed: () async {
                              List<CategoryModel> categories =
                              await ProductRepositoryImpl().majorCategories();
                              List<LabelModel> labels = await UserRepositoryImpl().labels();
                              labels = labels
                                  .where((label) =>
                              label.group == 'FACTORY' || label.group == 'PLATFORM')
                                  .toList();
                              if (categories != null && labels != null) {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (context) =>
                                        FactoryPage(
                                          FactoryCondition(
                                              starLevel: 0,
                                              adeptAtCategories: [],
                                              labels: [],
                                              cooperationModes: []),
                                          route: '全部工厂',
                                          categories: categories,
                                          labels: labels,
                                        ),
                                    ), ModalRoute.withName('/'));
                              }
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            color: Color.fromRGBO(255, 214, 12, 1),
                            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                            child: Text(
                              '查看工厂',
                              style: TextStyle(color: Color.fromRGBO(36, 38, 41, 1), fontSize: 16),
                            ),
                          ),
                        )
                      ],
                    );
                  }
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data.map((supplierModel) {
                        return SuppliersItem(
                          supplierModel,
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
                    _scrollController.animateTo(_scrollController.offset - 70,
                        duration: new Duration(milliseconds: 500), curve: Curves.easeOut);
                  }
                  return snapshot.data
                      ? Container(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
                          child: Center(
                            child: Text(
                              "人家可是有底线的。。。",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      : Container();
                },
              ),
              StreamBuilder<bool>(
                stream: bloc.loadingStream,
                initialData: false,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  return ProgressIndicatorFactory.buildPaddedOpacityProgressIndicator(
                    opacity: snapshot.data ? 1.0 : 0,
                  );
                },
              ),
            ],
          ),
        ));
  }

  Container _buildBrandContainer(SuppliersBloc bloc) {
    return Container(
        decoration: BoxDecoration(color: Colors.grey[100]),
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: RefreshIndicator(
          onRefresh: () {
            return bloc.filterbrands();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            children: <Widget>[
              StreamBuilder<List<BrandModel>>(
                stream: bloc.brandStream,
                initialData: null,
                builder: (BuildContext context, AsyncSnapshot<List<BrandModel>> snapshot) {
                  if (snapshot.data == null) {
                    bloc.filterbrands();
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 200),
                      child: ProgressIndicatorFactory.buildDefaultProgressIndicator(),
                    );
                  }
                  if (snapshot.data.length >= 0) {
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
                        Container(
                            child: Text('您还没有合作商')
                        ),
                        Container(
                          child: FlatButton(
                            onPressed: () async{
                              await ProductRepositoryImpl()
                                      .majorCategories()
                                  .then((categories) {
                                if (categories != null) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (context) =>
                                          RequirementPoolAllPage(categories: categories),
                                      ), ModalRoute.withName('/'));
                                }
                              });
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            color: Color.fromRGBO(255, 214, 12, 1),
                            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                            child: Text(
                              '查看最新需求',
                              style: TextStyle(color: Color.fromRGBO(36, 38, 41, 1),),
                            ),
                          ),
                        )
                      ],
                    );
                  }
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data.map((supplierModel) {
                        return BrandSuppliersItem(
                          supplierModel,
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
                    _scrollController.animateTo(_scrollController.offset - 70,
                        duration: new Duration(milliseconds: 500), curve: Curves.easeOut);
                  }
                  return snapshot.data
                      ? Container(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
                          child: Center(
                            child: Text(
                              "人家可是有底线的。。。",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      : Container();
                },
              ),
              StreamBuilder<bool>(
                stream: bloc.loadingStream,
                initialData: false,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  return ProgressIndicatorFactory.buildPaddedOpacityProgressIndicator(
                    opacity: snapshot.data ? 1.0 : 0,
                  );
                },
              ),
            ],
          ),
        ));
  }
}

class SuppliersItem extends StatelessWidget {
  final FactoryModel supplierModel;

  SuppliersItem(this.supplierModel);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: _buildList(context),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onTap: () async {
        //获取与该工厂最新的报价单
        QuoteModel quoteModel;
        QuoteOrdersResponse quoteResponse = await QuoteOrderRepository().getQuotesByFactory(supplierModel.uid, {
          'size': 1,
        });
        if (quoteResponse.content.length > 0) quoteModel = quoteResponse.content[0];

        //获取与该工厂最新的生产订单
        PurchaseOrderModel purchaseOrderModel;
        PurchaseOrdersResponse ordersResponse =
            await PurchaseOrderRepository().getPurchaseOrdersByFactory(supplierModel.uid, {
          'size': 1,
        });
        if (ordersResponse.content.length > 0) purchaseOrderModel = ordersResponse.content[0];

        //获取该工厂的现款产品
        ProductsResponse productsResponse = await ProductRepositoryImpl()
            .getProductsOfFactory({}, {'size': 3}, supplierModel.uid);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyFactoryPage(
                  supplierModel,
                  quoteModel: quoteModel,
                  purchaseOrder: purchaseOrderModel,
                  products: productsResponse.content,
                  isFactoryDetail: true,
                ),
          ),
        );
      },
    );
  }

  Widget _buildList(BuildContext context) {
    return ListTile(
      title: Text(
        supplierModel.name,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
//      subtitle: Text('合作单数：' + supplierModel.orderCount.toString(),
//          style: TextStyle(fontSize: 18, color: Color(0xFFFF9516))),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
//          Text(
//                supplierModel.contactAddress.region.name +
//                supplierModel.contactAddress.city.name +
//                supplierModel.contactAddress.cityDistrict.name,
//            style: TextStyle(fontSize: 16, color: Colors.black26),
//          ),
          Icon(
            Icons.chevron_right,
            color: Colors.black26,
          )
        ],
      ),
    );
  }
}

class BrandSuppliersItem extends StatelessWidget {
  final BrandModel supplierModel;

  BrandSuppliersItem(this.supplierModel);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: _buildList(context),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyBrandPage(
                  supplierModel,
                  isDetail: true,
                ),
          ),
        );
      },
    );
  }

  Widget _buildList(BuildContext context) {
    return ListTile(
      title: Text(
        supplierModel.name,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
//      subtitle: Text('合作单数：' + supplierModel.orderCount.toString(),
//          style: TextStyle(fontSize: 18, color: Color(0xFFFF9516))),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
//          Text(
//                supplierModel.contactAddress.region.name +
//                supplierModel.contactAddress.city.name +
//                supplierModel.contactAddress.cityDistrict.name,
//            style: TextStyle(fontSize: 16, color: Colors.black26),
//          ),
          Icon(
            Icons.chevron_right,
            color: Colors.black26,
          )
        ],
      ),
    );
  }
}

class ToTopBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = SuppliersBlocProvider.of(context);

    return StreamBuilder<bool>(
        stream: bloc.toTopBtnStream,
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return snapshot.data
              ? FloatingActionButton(
                  child: Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    bloc.returnToTop();
                  },
                  backgroundColor: Colors.blue,
                )
              : Container();
        });
  }
}
