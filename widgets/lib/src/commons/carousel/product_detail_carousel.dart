import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:widgets/src/commons/gallery/gallery_item.dart';
import 'package:widgets/src/commons/gallery/gallery_photo_view_wrapper.dart';

/// 轮播图
class ProductCarousel<T extends MediaModel> extends StatefulWidget {
  ProductCarousel(this.items, this.height);

  final List<T> items;
  final double height;

  @override
  _ProductCarouselState createState() => _ProductCarouselState();
}

class _ProductCarouselState extends State<ProductCarousel> {
  int _curPageIndex = 0;
  int _curIndicatorsIndex = 0;

  PageController _pageController;

  List<Widget> _indicators = [];
  List<MediaModel> _items = [];

  Timer _timer;
  Duration _duration = Duration(seconds: 3);
  Duration _animationDuration = Duration(milliseconds: 500);

  bool _isEndScroll = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.items.length ~/ 2);
    _curPageIndex = widget.items.length ~/ 2;

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
    for (int i = 0; i < widget.items.length; i++) {
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
    if (widget.items.length > 0)
      _curIndicatorsIndex = index % widget.items.length;

    setState(() {});
  }

  // 创建指示器
  Widget _buildIndicators() {
    _initIndicators();
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 10, 10),
          decoration: BoxDecoration(
              color: Colors.black26, borderRadius: BorderRadius.circular(20)),
          width: 50,
          height: 22.0,
          child: Center(
            child: Text(
              '${_curIndicatorsIndex + 1}/${widget.items.length}',
              style: TextStyle(color: Colors.white),
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
      onTap: () {
        /// TODO: router
//        RouteUtil.route2Detail(context, '${item.id}'); // 通过路由跳转到详情
      },
      child: GestureDetector(
        onTapDown: (down) {
          _isEndScroll = false;
        },
        onTapUp: (up) {
          _isEndScroll = true;
        },
        onTap: () {
          print('==');
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Container(
                      child: GalleryPhotoViewWrapper(
                        galleryItems: widget.items
                            .map((model) => GalleryItem(model: model))
                            .toList(),
                        backgroundDecoration: const BoxDecoration(
                          color: Colors.black,
                        ),
                        initialIndex: _curIndicatorsIndex,
                        scrollDirection: Axis.horizontal,
                      ),
                    )),
          );
        },
        child: CachedNetworkImage(
          imageUrl: item.url,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              SpinKitRing(
                color: Colors.black12,
                lineWidth: 2,
                size: 30,
              ),
          errorWidget: (context, url, error) =>
              SpinKitRing(
                color: Colors.black12,
                lineWidth: 2,
                size: 30,
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.height,
        //指示器覆盖在pager view上，所以用Stack
        child: Stack(
          children: <Widget>[
            _buildPagerView(),
            _buildIndicators(),
          ],
        ));
  }
}
