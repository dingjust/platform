import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/home/factory/factory_list.dart';
import 'package:b2b_commerce/src/home/pool/requirement_pool_all.dart';
import 'package:b2b_commerce/src/home/pool/requirement_pool_recommend.dart';
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
  ///发布需求的邀请合作商报价
  final bool quoteInviting;

  ///邀请报价需求单号
  final String requirementCode;

  const SuppliersPage(
      {Key key, this.quoteInviting = false, this.requirementCode})
      : super(key: key);

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
//          IconButton(
//            icon: Icon(
//              B2BIcons.search,
//              size: 20,
//            ),
//            onPressed: () => showSearch(
//                context: context, delegate: SuppliersSearchDelegate()),
//          ),
        ],
      ),
      body: Container(
        child: SuppliersList(
          widget.quoteInviting,
          requirementCode: widget.requirementCode,
        ),
      ),
      floatingActionButton: ToTopBtn(),
    ));
  }
}

class SuppliersList extends StatelessWidget {
  ///发布需求的邀请合作商报价
  final bool quoteInviting;

  ///邀请报价需求单号
  final String requirementCode;

  SuppliersList(this.quoteInviting, {this.requirementCode});

  final ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    final bloc = SuppliersBlocProvider.of(context);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
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
        _scrollController.animateTo(.0,
            duration: Duration(milliseconds: 200), curve: Curves.ease);
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
                builder: (BuildContext context,
                    AsyncSnapshot<List<FactoryModel>> snapshot) {
                  if (snapshot.data == null) {
                    bloc.filterfactories();
                    return ProgressIndicatorFactory
                        .buildPaddedProgressIndicator();
                  }
                  if (snapshot.data.length <= 0) {
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
                        Container(child: Text('您还没有合作商')),
                        Container(
                          child: FlatButton(
                            onPressed: () async {
                              selectSuppliers(context);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            color: Color.fromRGBO(255, 214, 12, 1),
                            padding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 15),
                            child: Text(
                              '挑选合作商',
                              style: TextStyle(
                                  color: Color.fromRGBO(36, 38, 41, 1),
                                  fontSize: 16),
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
                          quoteInviting: quoteInviting,
                          requirementCode: requirementCode,
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
                  //   _scrollController.animateTo(_scrollController.offset - 70,
                  //       duration: new Duration(milliseconds: 500), curve: Curves.easeOut);
                  // }
                  return ScrolledToEndTips(
                    hasContent: snapshot.data,
                    scrollController: _scrollController,
                  );
                },
              ),
              StreamBuilder<bool>(
                stream: bloc.loadingStream,
                initialData: false,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  return ProgressIndicatorFactory
                      .buildPaddedOpacityProgressIndicator(
                    opacity: snapshot.data ? 1.0 : 0,
                  );
                },
              ),
            ],
          ),
        ));
  }

  void _jumpToQualityFactory(BuildContext context) async {
    List<CategoryModel> categories =
        await ProductRepositoryImpl().majorCategories();
    List<LabelModel> labels = await UserRepositoryImpl().labels();
    List<LabelModel> conditionLabels =
        labels.where((label) => label.name == '优选工厂').toList();
    labels = labels
        .where((label) => label.group == 'FACTORY' || label.group == 'PLATFORM')
        .toList();
    labels.add(LabelModel(name: '已认证', id: 1000000));
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FactoryPage(
              FactoryCondition(
                  starLevel: 0,
                  adeptAtCategories: [],
                  labels: conditionLabels,
                  cooperationModes: []),
              route: '优选工厂',
              categories: categories,
              labels: labels,
            ),
      ),
    );
  }

  void _jumpToRequirementPool(BuildContext context) async {
    await ProductRepositoryImpl().majorCategories().then((categories) {
      if (categories != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => RequirementPoolRecommend(
                  categories: categories,
                )));
      }
    });
  }

  void selectSuppliers(BuildContext context) {
    //品牌跳转到优选工厂
    if (UserBLoC.instance.currentUser.type == UserType.BRAND) {
      _jumpToQualityFactory(context);
    } else if (UserBLoC.instance.currentUser.type == UserType.FACTORY) {
      _jumpToRequirementPool(context);
    }
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
                builder: (BuildContext context,
                    AsyncSnapshot<List<BrandModel>> snapshot) {
                  if (snapshot.data == null) {
                    bloc.filterbrands();
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 200),
                      child: ProgressIndicatorFactory
                          .buildDefaultProgressIndicator(),
                    );
                  }
                  if (snapshot.data.length <= 0) {
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
                        Container(child: Text('您还没有合作商')),
                        Container(
                          child: FlatButton(
                            onPressed: () async {
                              await ProductRepositoryImpl()
                                  .majorCategories()
                                  .then((categories) {
                                if (categories != null) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RequirementPoolAllPage(
                                                categories: categories),
                                      ),
                                      ModalRoute.withName('/'));
                                }
                              });
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            color: Color.fromRGBO(255, 214, 12, 1),
                            padding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            child: Text(
                              '查看最新需求',
                              style: TextStyle(
                                color: Color.fromRGBO(36, 38, 41, 1),
                              ),
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
                  // if (snapshot.data) {
                  //   _scrollController.animateTo(_scrollController.offset - 70,
                  //       duration: new Duration(milliseconds: 500), curve: Curves.easeOut);
                  // }
                  return ScrolledToEndTips(
                    hasContent: snapshot.data,
                    scrollController: _scrollController,
                  );
                },
              ),
              StreamBuilder<bool>(
                stream: bloc.loadingStream,
                initialData: false,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  return ProgressIndicatorFactory
                      .buildPaddedOpacityProgressIndicator(
                    opacity: snapshot.data ? 1.0 : 0,
                  );
                },
              ),
            ],
          ),
        ));
  }
}

class SuppliersItem extends StatefulWidget {
  final FactoryModel supplierModel;

  ///邀请合作商报价
  bool quoteInviting;

  ///邀请报价需求单号
  String requirementCode;

  SuppliersItem(this.supplierModel, {this.quoteInviting, this.requirementCode});

  @override
  _SuppliersItemState createState() => _SuppliersItemState();
}

class _SuppliersItemState extends State<SuppliersItem> {
  ///是否已邀请
  bool invited = false;

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
            builder: (context) => MyFactoryPage(
                  factoryUid: widget.supplierModel.uid,
                  isFactoryDetail: true,
                  isSupplier: true,
                ),
          ),
        );
      },
    );
  }

  Widget _buildList(BuildContext context) {
    return ListTile(
      title: Text(
        widget.supplierModel.name,
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
          widget.quoteInviting
              ? FlatButton(
                  color: Color.fromRGBO(255, 214, 12, 1),
                  child: invited ? Text('已邀请报价') : Text('邀请报价'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
            onPressed: invited
                ? null
                : () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) {
                    return RequestDataLoading(
                      requestCallBack: RequirementOrderRepository()
                          .doRecommendation(widget.requirementCode,
                          widget.supplierModel.uid),
                      outsideDismiss: false,
                      loadingText: '邀请中。。。',
                      entrance: '0',
                    );
                  }).then((_) {
                    Navigator.pop(context);
                setState(() {
                  invited = true;
                });
              });
            },
          )
              : Icon(
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
                  supplierModel.uid,
                  isDetail: true,
                  isSupplier: true,
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
