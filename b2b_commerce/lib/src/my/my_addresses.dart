import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../_shared/widgets/scrolled_to_end_tips.dart';

import './address/address_form.dart';

class MyAddressesPage extends StatelessWidget {
  MyAddressesPage({Key key, this.isJumpSource = false}) : super(key: key);

  final bool isJumpSource;
  final AddressModel model = AddressModel();
  final ScrollController _scrollController = new ScrollController();

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
        body: AddressList(
          isJumpSource: isJumpSource,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddressFormPage(address: model, newlyCreated: true)),
            );
          },
        ),
      ),
    );
  }
}

class AddressList extends StatelessWidget {
  AddressList({this.isJumpSource = false});

  final bool isJumpSource;
  final ScrollController _scrollController = new ScrollController();

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
                    return ProgressIndicatorFactory.buildPaddedProgressIndicator();
                  }
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data.map((address) {
                        return AddressItem(address, isJumpSource: isJumpSource);
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
                    _scrollController.animateTo(
                      _scrollController.offset - 70,
                      duration: new Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                    );
                  }
                  return ScrolledToEndTips(hasContent: snapshot.data);
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

class AddressItem extends StatelessWidget {
  AddressItem(this.item, {this.isJumpSource = false});

  final bool isJumpSource;
  final AddressModel item;

  @override
  Widget build(BuildContext context) {
    Widget _buildRow(String name, String telephone, bool isDefaultAddress) {
      List<Container> containers = <Container>[
        Container(
          padding: const EdgeInsets.only(right: 22.0),
          child: Column(
            children: <Widget>[
              Text(name),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(right: 22.0),
          child: Column(
            children: <Widget>[
              Text(
                telephone,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
      ];

      if (isDefaultAddress != null && isDefaultAddress) {
        containers.add(
          Container(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: <Widget>[
                const Text(
                  '默认地址',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
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
        if (isJumpSource) {
          Navigator.of(context).pop(item);
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddressFormPage(address: item)));
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
