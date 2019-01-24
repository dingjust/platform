import 'package:b2b_commerce/src/business/search/suppliers_search.dart';
import 'package:b2b_commerce/src/business/supplier/provider/suppliers_provider.dart';
import 'package:b2b_commerce/src/business/supplier/suppliers_detail.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class SuppliersPage extends StatefulWidget{
  _SuppliersPageState createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
  @override
  Widget build(BuildContext context) {
    return SuppliersBlocProvider(
        child: Scaffold(
          appBar: AppBar(
            title: Text('供应商管理'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
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
        StreamBuilder<List<SupplierModel>>(
          stream: bloc.stream,
          initialData: null,
          builder: (BuildContext context,
              AsyncSnapshot<List<SupplierModel>> snapshot) {
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
  final SupplierModel supplierModel;

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
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SuppliersDetail(supplierModel: supplierModel),
          ),
        );
      },
    );
  }

  Widget _buildList(BuildContext context) {
    return ListTile(
      title: Text(
        supplierModel.factory.name,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      subtitle: Text('合作单数：' + supplierModel.orderCount.toString(),
          style: TextStyle(fontSize: 18, color: Colors.orange)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
                supplierModel.factory.contactAddress.region.name +
                supplierModel.factory.contactAddress.city.name +
                supplierModel.factory.contactAddress.cityDistrict.name,
            style: TextStyle(fontSize: 16, color: Colors.black26),
          ),
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