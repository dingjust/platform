import 'dart:async';

import 'package:models/models.dart';
import 'package:services/services.dart';

class QuoteOrdersBLoC extends BLoCBase {
  // 工厂模式
  factory QuoteOrdersBLoC() => _getInstance();

  static QuoteOrdersBLoC get instance => _getInstance();
  static QuoteOrdersBLoC _instance;

  QuoteOrdersBLoC._internal() {
    // 初始化
  }

  static QuoteOrdersBLoC _getInstance() {
    if (_instance == null) {
      _instance = new QuoteOrdersBLoC._internal();
    }
    return _instance;
  }

  static final Map<String, List<QuoteModel>> _quotesMap = {
    'ALL': List<QuoteModel>(),
    'SELLER_SUBMITTED': List<QuoteModel>(),
    'BUYER_APPROVED': List<QuoteModel>(),
    'BUYER_REJECTED': List<QuoteModel>()
  };

  List<QuoteModel> quotes(String status) => _quotesMap[status];

  var _controller = StreamController<List<QuoteModel>>.broadcast();

  Stream<List<QuoteModel>> get stream => _controller.stream;

  filterByStatuses(String status) async {
    //若没有数据则查询
    if (_quotesMap[status].isEmpty) {
      // TODO: 分页拿数据，response.data;
      _quotesMap[status]
          .addAll(await Future.delayed(const Duration(seconds: 1), () {
        return <QuoteModel>[];
      }));
    }
    _controller.sink.add(_quotesMap[status]);
  }

  loadingMoreByStatuses(String status) async {
    //模拟数据到底
    // if (_quotesMap[status].length < 6) {
    //   _quotesMap[status]
    //       .add(await Future.delayed(const Duration(seconds: 1), () {}));
    // } else {
    //   //通知显示已经到底部
    //   _bottomController.sink.add(true);
    // }
    // _loadingController.sink.add(false);
    // _controller.sink.add(_quotesMap[status]);
  }

  //下拉刷新
  Future refreshData(String status) async {
  //   _quotesMap[status].clear();
  //   _quotesMap[status].add(await Future.delayed(const Duration(seconds: 1), () {
  //  }));
  //   _controller.sink.add(_quotesMap[status]);
  }

  //页面控制

  var _loadingController = StreamController<bool>.broadcast();
  var _bottomController = StreamController<bool>.broadcast();
  var _toTopBtnController = StreamController<bool>.broadcast();
  var _returnToTopController = StreamController<bool>.broadcast();

  Stream<bool> get loadingStream => _loadingController.stream;

  Stream<bool> get bottomStream => _bottomController.stream;

  Stream<bool> get toTopBtnStream => _toTopBtnController.stream;

  Stream<bool> get returnToTopStream => _returnToTopController.stream;

  loadingStart() async {
    _loadingController.sink.add(true);
  }

  loadingEnd() async {
    _loadingController.sink.add(false);
  }

  showToTopBtn() async {
    _toTopBtnController.sink.add(true);
  }

  hideToTopBtn() async {
    _toTopBtnController.sink.add(false);
  }

  returnToTop() async {
    _returnToTopController.sink.add(true);
  }

  dispose() {
    _controller.close();
    _loadingController.close();
    _bottomController.close();
    _toTopBtnController.close();
    _returnToTopController.close();
  }
}
