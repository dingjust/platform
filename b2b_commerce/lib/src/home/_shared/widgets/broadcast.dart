import 'dart:async';

import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

class HomeBroadcast extends StatefulWidget {
  const HomeBroadcast({Key key}) : super(key: key);

  @override
  _HomeBroadcastState createState() => _HomeBroadcastState();
}

class _HomeBroadcastState extends State<HomeBroadcast>
    with SingleTickerProviderStateMixin {
  Timer _timer;
  Duration _duration = Duration(seconds: 5);
  Duration _animationDuration = Duration(milliseconds: 500);
  PageController _pageController = PageController();
  int _curPageIndex = 0;

  @override
  void initState() {
    super.initState();
    initTimer();
  }

  // 通过时间timer做轮询，达到自动播放的效果
  initTimer() {
    _timer = Timer.periodic(_duration, (timer) {
      _pageController.animateToPage(
        _curPageIndex + 1,
        duration: _animationDuration,
        curve: Curves.linear,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 12),
            child: B2BV2Image.notice(width: 18, height: 16),
          ),
          Expanded(
              child: Consumer(builder: (context, NotificationState state, _) {
            return Container(
                height: 16,
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  allowImplicitScrolling: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Text(
                      '${state.notifications[index].content}',
                      style: TextStyle(
                          color: Color(0xff666666),
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    );
                  },
                  itemCount: state.notifications.length,
                  onPageChanged: (index) {
                    if (index == state.notifications.length - 1) {
                      //轮播完
                      Future.delayed(_duration).then((value) {
                        setState(() {
                          _curPageIndex = 0;
                          _pageController.jumpToPage(0);
                        });
                        state.getData();
                      });
                    } else {
                      setState(() {
                        _curPageIndex = index;
                      });
                    }
                  },
                ));
          }))
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
