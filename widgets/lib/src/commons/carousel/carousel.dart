import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';

/// 轮播图
class Carousel<T extends MediaModel> extends StatefulWidget {
  Carousel(this.items, this.height, {this.scrollDirection = Axis.horizontal});

  final List<T> items;
  final double height;
  final Axis scrollDirection;

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  static int length = 1000;

  int _curPageIndex = 0;
  int _curIndicatorsIndex = 0;

  PageController _pageController = PageController(initialPage: length ~/ 2);

  List<Widget> _indicators = [];
  List<MediaModel> _items = [];

  Timer _timer;
  Duration _duration = Duration(seconds: 3);
  Duration _animationDuration = Duration(milliseconds: 500);

  bool _isEndScroll = true;

  @override
  void initState() {
    super.initState();
    _curPageIndex = length ~/ 2;

    initTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  // 通过时间timer做轮询，达到自动播放的效果
  initTimer() {
    _timer = Timer.periodic(_duration, (timer) {
      if (_isEndScroll) {
        _pageController.animateToPage(
          _curPageIndex + 1,
          duration: _animationDuration,
          curve: Curves.linear,
        );
      }
    });
  }

  // 用于做banner循环
  _initItems() {
    for (int i = 0; i < length; i++) {
      _items.addAll(widget.items);
    }
  }

  _initIndicators() {
    _indicators.clear();
    for (int i = 0; i < widget.items.length; i++) {
      _indicators.add(SizedBox(
        width: 5.0,
        height: 5.0,
        child: Container(
          color: i == _curIndicatorsIndex ? Colors.white : Colors.grey,
        ),
      ));
    }
  }

  _changePage(int index) {
    _curPageIndex = index;
    // 获取指示器索引
    _curIndicatorsIndex = index % widget.items.length;

    setState(() {});
  }

  // 创建指示器
  Widget _buildIndicators() {
    _initIndicators();
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          // color: Colors.black45,
          height: 20.0,
          child: Center(
            child: SizedBox(
              width: widget.items.length * 16.0,
              height: 5.0,
              child: Row(
                children: _indicators,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
            ),
          )),
    );
  }

  Widget _buildPagerView() {
    _initItems();
    // 检查手指和自动播放的是否冲突，如果滚动停止开启自动播放，反之停止自动播放
    return NotificationListener(
        onNotification: (ScrollNotification scrollNotification) {
          if (scrollNotification is ScrollEndNotification ||
              scrollNotification is UserScrollNotification) {
            _isEndScroll = true;
          } else {
            _isEndScroll = false;
          }

          return false;
        },
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: widget.scrollDirection,
          itemBuilder: (BuildContext context, int index) {
            return _buildItem(context, index);
          },
          itemCount: _items.length,
          onPageChanged: (index) {
            _changePage(index);
          },
        ));
  }

  Widget _buildItem(BuildContext context, int index) {
    MediaModel item = _items[index];
    return GestureDetector(
      onTapDown: (down) {
        _isEndScroll = false;
      },
      onTapUp: (up) {
        _isEndScroll = true;
      },
      onTap: () {
//          Navigator.of(context).push(MaterialPageRoute(
//              builder: (context) => BannerJumpDetailPage())
//          );
      },
      child: CachedNetworkImage(
          imageUrl: item.url,
          fit: BoxFit.fill,
          placeholder: (context, url) =>
              SpinKitRing(
                color: Colors.black12,
                lineWidth: 2,
                size: 30.0,
              ),
          errorWidget: (context, url, error) =>
              SpinKitRing(
                color: Colors.black12,
                lineWidth: 2,
                size: 30,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //指示器覆盖在pager view上，所以用Stack
      child: Stack(
        children: <Widget>[
          _buildPagerView(),
          _buildIndicators(),
        ],
      ),
    );
  }
}
