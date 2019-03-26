import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'address/address_form.dart';

class MyAddressesPage extends StatelessWidget {
  bool isJumpSourec = false;
  AddressModel model = AddressModel();
  ScrollController _scrollController = new ScrollController();

  MyAddressesPage({this.isJumpSourec});

  @override
  Widget build(BuildContext context) {
    var bloc = AddressBLoC.instance;

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMoreByStatuses();
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

    return BLoCProvider<AddressBLoC>(
      bloc: AddressBLoC.instance,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: Text('地址管理'),
        ),
        body: AddressList(isJumpSourec: isJumpSourec,),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddressFormPage(address: model,newlyCreated: true,)),
            );
          },
        ),
      ),
    );
  }


}

class AddressList extends StatelessWidget {
  bool isJumpSourec = false;
  ScrollController _scrollController = new ScrollController();
  AddressList({this.isJumpSourec});

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<AddressBLoC>(context);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMoreByStatuses();
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

    return Container(
        decoration: BoxDecoration(color: Colors.grey[100]),
//        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: RefreshIndicator(
          onRefresh: () async {
            return await bloc.filterByStatuses();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            children: <Widget>[
              StreamBuilder<List<AddressModel>>(
                stream: bloc.stream,
                // initialData: null,
                builder: (BuildContext context, AsyncSnapshot<List<AddressModel>> snapshot) {
                  if (snapshot.data == null) {
                    bloc.filterByStatuses();
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 200),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data.map((address) {
                        return AddressItem(address,isJumpSourec);
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
                        "┑(￣Д ￣)┍ 已经到底了",
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
          ),
        ));
  }
}

class AddressItem extends StatelessWidget{
  bool isJumpSourec = false;
  final AddressModel item;
  AddressItem(this.item,this.isJumpSourec);

  @override
  Widget build(BuildContext context) {
    Widget _buildRow(String name, String telephone, bool isDefaultAddress) {
      List<Container> containers = <Container>[
        Container(
          padding: EdgeInsets.only(right: 22.0),
          child: Column(
            children: <Widget>[
              Text(name),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(right: 22.0),
          child: Column(
            children: <Widget>[
              Text(
                telephone,
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
      ];

      if (isDefaultAddress != null && isDefaultAddress) {
        containers.add(
          Container(
            padding: EdgeInsets.all(0),
            child: Column(
              children: <Widget>[
                Text(
                  '默认地址',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      }

      return Row(children: containers);
    }

    return ListTile(
      onTap: () {
        if(isJumpSourec){
          Navigator.of(context).pop(item);
        }else{
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddressFormPage(address: item),
            ),
          );
        }

      },
      title: _buildRow(
        item.fullname,
        item.cellphone,
        item.defaultAddress,
      ),
      subtitle: Text(item.details),
      trailing: Icon(Icons.chevron_right),
    );
  }
}
