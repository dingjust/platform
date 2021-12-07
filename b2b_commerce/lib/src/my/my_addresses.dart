import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import './address/address_form.dart';
import '../_shared/widgets/scrolled_to_end_tips.dart';

class MyAddressesPage extends StatelessWidget {
  MyAddressesPage({Key key, this.isJumpSource = false, this.title = '地址管理'})
      : super(key: key);

  final String title;
  final bool isJumpSource;
  final AddressModel model = AddressModel();
  final ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    var bloc = AddressBLoC.instance;

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
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
        _scrollController.animateTo(.0,
            duration: Duration(milliseconds: 200), curve: Curves.ease);
      }
    });

    return BLoCProvider<AddressBLoC>(
      bloc: AddressBLoC.instance,
      child: Scaffold(
        appBar: AppBarFactory.buildDefaultAppBar('$title'),
        body: AddressList(
          isJumpSource: isJumpSource,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddressFormPage(address: model, newlyCreated: true)),
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
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
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
        _scrollController.animateTo(.0,
            duration: Duration(milliseconds: 200), curve: Curves.ease);
      }
    });

    return Container(
        decoration: BoxDecoration(color: Color(0xFFF7F7F7)),
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: RefreshIndicator(
          onRefresh: () async {
            return await bloc.getAddressData();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            children: <Widget>[
              StreamBuilder<List<AddressModel>>(
                stream: bloc.stream,
                // initialData: null,
                builder: (BuildContext context,
                    AsyncSnapshot<List<AddressModel>> snapshot) {
                  if (snapshot.data == null) {
                    bloc.getAddressData();
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
                        Container(
                            child: Text(
                          '请添加送货地址',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        )),
                      ],
                    );
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
                  return Container();
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

class AddressItem extends StatelessWidget {
  AddressItem(this.item,
      {this.isJumpSource = false,
        this.textStyle =
        const TextStyle(color: Color(0xFFAA6E15), fontSize: 16)});

  final bool isJumpSource;
  final AddressModel item;

  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    if (item.region == null && item.city == null && item.cityDistrict == null) {
      return Container();
    }

    return GestureDetector(
      onTap: () {
        if (isJumpSource) {
          Navigator.of(context).pop(item);
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddressFormPage(address: item)));
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.only(top: 12),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 24),
                            child: Text('${item.fullname}', style: textStyle),
                          ),
                          Text('${item.cellphone}', style: textStyle)
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                              child: Text('${item.details}',
                                  style: TextStyle(
                                      color: Color(0xFF666666), fontSize: 14)))
                        ],
                      ),
                    )
                  ],
                )),
            Icon(
              B2BIcons.edit,
              size: 18,
              color: Color(0xFF999999),
            )
          ],
        ),
      ),
    );
  }
}
