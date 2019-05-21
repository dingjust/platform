import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class MyHelpDetailPage extends StatefulWidget {
  final UserGuidelineModel userGuidelineModel;

  MyHelpDetailPage({Key key, this.userGuidelineModel}) : super(key: key);

  @override
  _MyHelpDetailPageState createState() => _MyHelpDetailPageState();
}

class _MyHelpDetailPageState extends State<MyHelpDetailPage> {
  PageController pageController = PageController(initialPage: 0);
  Duration _animationDuration = Duration(milliseconds: 500);
  List<Widget> _indicators = [];
  int _curIndicatorsIndex = 0;
  int _curPageIndex = 0;

  UserGuidelineModel guidelineDetailModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: Text('${widget.userGuidelineModel.name}'),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              _buildSubTitle(),
              FutureBuilder<UserGuidelineModel>(
                builder: (BuildContext context,
                    AsyncSnapshot<UserGuidelineModel> snapshot) {
                  if (snapshot.data != null) {
                    return Expanded(
                        flex: 1,
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            Positioned(
                              child: PageView(
                                  onPageChanged: _changePage,
                                  controller: pageController,
                                  children: snapshot.data.infos
                                      .map(
                                        (info) => HelpViewPage(
                                              message: '${info.description}',
                                              media: info.media,
                                            ),
                                      )
                                      .toList()),
                            ),
                            Positioned(
                              top: 300,
                              left: 0,
                              child: IconButton(
                                iconSize: 50,
                                icon: Icon(Icons.skip_previous),
                                onPressed: () {
                                  pageController.previousPage(
                                      curve: Curves.linear,
                                      duration: _animationDuration);
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
                                      curve: Curves.linear,
                                      duration: _animationDuration);
                                },
                                color: Colors.grey,
                              ),
                            ),
                            _buildIndicators()
                          ],
                        ));
                  } else {
                    return Expanded(
                      flex: 1,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
                initialData: null,
                future: _getData(),
              ),
            ],
          ),
        ));
  }

  Widget _buildSubTitle() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      color: Colors.white,
      child: Text('${widget.userGuidelineModel.description}'),
    );
  }

  _initIndicators() {
    _indicators.clear();
    for (int i = 0; i < guidelineDetailModel.infos.length; i++) {
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
              width: guidelineDetailModel.infos.length * 16.0,
              height: 5.0,
              child: Row(
                children: _indicators,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
            ),
          )),
    );
  }

  Future<UserGuidelineModel> _getData() async {
    if (guidelineDetailModel == null) {
      // 查询明细
      UserGuidelineModel detailModel = await UserGuidelineRepository()
          .getUserGuidelineDetail(widget.userGuidelineModel.id);
      guidelineDetailModel = detailModel;
    }
    return guidelineDetailModel;
  }

  _changePage(int index) {
    _curPageIndex = index;
    // 获取指示器索引
    _curIndicatorsIndex = index % guidelineDetailModel.infos.length;
    setState(() {});
  }
}

class HelpViewPage extends StatelessWidget {
  final String message;

  final MediaModel media;

  const HelpViewPage({Key key, this.message, this.media}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        media != null
            ? Positioned(
                child: Container(
                  padding: EdgeInsets.fromLTRB(50, 20, 50, 40),
                  child: CachedNetworkImage(
                      imageUrl: '${media.workingUrl()}',
                      fit: BoxFit.contain,
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
              )
            : Container(),
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
