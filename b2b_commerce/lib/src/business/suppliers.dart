import 'package:b2b_commerce/src/business/search/suppliers_search.dart';
import 'package:b2b_commerce/src/business/supplier/provider/suppliers_provider.dart';
import 'package:b2b_commerce/src/my/my_factory.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class SuppliersPage extends StatefulWidget{
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
            title: Text('供应商管理'),
            actions: <Widget>[
              IconButton(
                icon: Icon(B2BIcons.search,size: 20,),
                onPressed: () =>
                    showSearch(
                        context: context, delegate: SuppliersSearchDelegate()),
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
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMore();
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

    return Container(
        decoration: BoxDecoration(color: Colors.grey[100]),
    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
    child: ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      children: <Widget>[
        StreamBuilder<List<FactoryModel>>(
          stream: bloc.stream,
          initialData: null,
          builder: (BuildContext context,
              AsyncSnapshot<List<FactoryModel>> snapshot) {
            if (snapshot.data == null) {
              bloc.filter();
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 200),
                child: Center(child: CircularProgressIndicator()),
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
                  duration: new Duration(milliseconds: 500),
                  curve: Curves.easeOut);
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
      onTap: () async{
        Response response = await http$.post(OrderApis.quotes,
          data: {
            "belongTos" : supplierModel.uid,
          },
          queryParameters: {
            'size': 1,
          });

        QuoteModel quoteModel;
        if (response != null && response.statusCode == 200) {
         QuoteOrdersResponse quoteResponse = QuoteOrdersResponse.fromJson(response.data);
         if(quoteResponse != null && quoteResponse.content.length > 0){
           quoteModel = quoteResponse.content[0];
         }
        }

        ProductsResponse productsResponse = await ProductRepositoryImpl().list({}, {'size': 3});

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyFactoryPage(supplierModel,quoteModel: quoteModel,products: productsResponse.content,),
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
            child: Icon(Icons.arrow_upward,color: Colors.white,),
            onPressed: () {
              bloc.returnToTop();
            },
            backgroundColor: Colors.blue,
          )
              : Container();
        });
  }
}