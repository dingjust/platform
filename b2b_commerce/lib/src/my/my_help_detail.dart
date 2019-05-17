import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyHelpDetailPage extends StatefulWidget {
  List<int> data = [1, 2, 3];

  @override
  _MyHelpDetailPageState createState() => _MyHelpDetailPageState();
}

class _MyHelpDetailPageState extends State<MyHelpDetailPage> {
  PageController pageController = PageController(initialPage: 0);
  Duration _animationDuration = Duration(milliseconds: 500);
  List<Widget> _indicators = [];
  int _curIndicatorsIndex = 0;
  int _curPageIndex = 0;

  List<HelpViewPage> helpViewPages;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    helpViewPages = widget.data
        .map(
          (data) => HelpViewPage(
                message: '步骤1：进入生产，点击y右下方‘线下订单’,然后点击创建asdadadadadadad',
                url:
                    'https://img.alicdn.com/imgextra/i4/2818445397/TB2kdpghCJjpuFjy0FdXXXmoFXa_!!2818445397.png',
              ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: const Text('如何创建订单?'),
      ),
      body: Column(
        children: <Widget>[
          _buildSubTitle(),
          Expanded(
              flex: 1,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Positioned(
                    child: PageView(
                        onPageChanged: _changePage,
                        controller: pageController,
                        children: helpViewPages),
                  ),
                  Positioned(
                    top: 300,
                    left: 0,
                    child: IconButton(
                      iconSize: 50,
                      icon: Icon(Icons.skip_previous),
                      onPressed: () {
                        pageController.previousPage(
                            curve: Curves.linear, duration: _animationDuration);
                      },
                      color: Colors.grey,
                    ),
                  ),
                  Positioned(
                    top: 300,
                    right: 0,
                    child: IconButton(
                      iconSize: 50,
                      icon: Icon(Icons.skip_next),
                      onPressed: () {
                        pageController.nextPage(
                            curve: Curves.linear, duration: _animationDuration);
                      },
                      color: Colors.grey,
                    ),
                  ),
                  _buildIndicators()
                ],
              ))
        ],
      ),
    );
  }

  Widget _buildSubTitle() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      color: Colors.white,
      child: Text('创建线下订单有利于帮助奥i的机器偶就围殴情节哦亲王杰饿哦偶家阿萨大大窘境请我阿克苏地区较为急哦急哦i奇迹我就而且哦'),
    );
  }

  _initIndicators() {
    _indicators.clear();
    for (int i = 0; i < widget.data.length; i++) {
      _indicators.add(SizedBox(
        width: 8.0,
        height: 8.0,
        child: Container(
          color: i == _curIndicatorsIndex ? Colors.black : Colors.grey,
        ),
      ));
    }
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
              width: widget.data.length * 16.0,
              height: 5.0,
              child: Row(
                children: _indicators,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
            ),
          )),
    );
  }

  _changePage(int index) {
    _curPageIndex = index;
    // 获取指示器索引
    _curIndicatorsIndex = index % widget.data.length;

    setState(() {});
  }
}

class HelpViewPage extends StatelessWidget {
  final String message;

  final String url;

  const HelpViewPage({Key key, this.message, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned(
          child: Container(
            padding: EdgeInsets.fromLTRB(50, 20, 50, 40),
            child: CachedNetworkImage(
                imageUrl: '${url}',
                fit: BoxFit.cover,
                placeholder: (context, url) => SpinKitRing(
                      color: Colors.black12,
                      lineWidth: 2,
                      size: 30.0,
                    ),
                errorWidget: (context, url, error) => SpinKitRing(
                      color: Colors.black12,
                      lineWidth: 2,
                      size: 30,
                    )),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.black54,
                  height: 80,
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Text(
                    '${message}',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
