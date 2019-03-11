import 'dart:async';

import 'package:models/models.dart';
import 'package:services/services.dart';

class RequirementQuoteDetailBLoC extends BLoCBase {
  static final List<QuoteModel> quotes = [];

  // 工厂模式
  factory RequirementQuoteDetailBLoC() => _getInstance();

  static RequirementQuoteDetailBLoC get instance => _getInstance();
  static RequirementQuoteDetailBLoC _instance;

  RequirementQuoteDetailBLoC._internal() {
    // 初始化
  }

  static RequirementQuoteDetailBLoC _getInstance() {
    if (_instance == null) {
      _instance = new RequirementQuoteDetailBLoC._internal();
    }
    return _instance;
  }

  List<QuoteModel> get quotesList => quotes;

  var _controller = StreamController<List<QuoteModel>>.broadcast();

  Stream<List<QuoteModel>> get stream => _controller.stream;

  getData() async {
    //若没有数据则查询
    if (quotes.isEmpty) {
      // TODO: 分页拿数据，response.data;
      this.quotesList.addAll(await Future.delayed(const Duration(seconds: 1), () {
            return <QuoteModel>[
              QuoteModel.fromJson({
                "code": "34938475200045",
                "creationtime": DateTime.now().millisecondsSinceEpoch,
                "belongTo": {"name": "广州好辣制衣厂", "starLevel": 3},
                "state": "BUYER_APPROVED",
                "totalPrice": 360.00,
                "deliveryAddress": {
                  "region": {"name": "广东"},
                  "city": {"name": "广州"},
                  "cityDistrict": {"name": "白云"}
                }
              }),
              QuoteModel.fromJson({
                "code": "34938475200045",
                "creationtime": DateTime.now().millisecondsSinceEpoch,
                "belongTo": {"name": "广州好辣制衣厂", "starLevel": 2},
                "state": "BUYER_REJECTED",
                "totalPrice": 360.00,
                "deliveryAddress": {
                  "region": {"name": "广东"},
                  "city": {"name": "广州"},
                  "cityDistrict": {"name": "白云"}
                }
              }),
              QuoteModel.fromJson({
                "code": "34938475200045",
                "creationtime": DateTime.now().millisecondsSinceEpoch,
                "belongTo": {"name": "广州好辣制衣厂", "starLevel": 4},
                "state": "SELLER_SUBMITTED",
                "totalPrice": 360.00,
                "deliveryAddress": {
                  "region": {"name": "广东"},
                  "city": {"name": "广州"},
                  "cityDistrict": {"name": "白云"}
                }
              }),
              QuoteModel.fromJson({
                "code": "34938475200045",
                "creationtime": DateTime.now().millisecondsSinceEpoch,
                "belongTo": {"name": "广州好辣制衣厂", "starLevel": 5},
                "state": "BUYER_APPROVED",
                "totalPrice": 360.00,
                "deliveryAddress": {
                  "region": {"name": "广东"},
                  "city": {"name": "广州"},
                  "cityDistrict": {"name": "白云"}
                }
              })
            ];
          }));
    }
    _controller.sink.add(this.quotesList);
  }

  loadingMore() async {
    //模拟数据到底
    if (this.quotesList.length < 10) {
      this.quotesList.add(await Future.delayed(const Duration(seconds: 1), () {
            return QuoteModel.fromJson({
              "code": "34938475200045",
              "creationtime": DateTime.now().millisecondsSinceEpoch,
              "belongTo": {"name": "广州好辣制衣厂", "starLevel": 5},
              "state": "BUYER_APPROVED",
              "totalPrice": 360.00,
              "deliveryAddress": {
                "region": {"name": "广东"},
                "city": {"name": "广州"},
                "cityDistrict": {"name": "白云"}
              }
            });
          }));
    } else {
      //通知显示已经到底部
      _bottomController.sink.add(true);
    }
    _loadingController.sink.add(false);
    _controller.sink.add(this.quotesList);
  }

  //下拉刷新
  Future refreshData() async {
    this.quotesList.clear();
    this.quotesList.add(await Future.delayed(const Duration(seconds: 1), () {
          return QuoteModel.fromJson({
            "code": "34938475200045",
            "creationtime": DateTime.now().millisecondsSinceEpoch,
            "belongTo": {"name": "广州好辣制衣厂", "starLevel": 5},
            "state": "BUYER_APPROVED",
            "totalPrice": 360.00,
            "deliveryAddress": {
              "region": {"name": "广东"},
              "city": {"name": "广州"},
              "cityDistrict": {"name": "白云"}
            }
          });
        }));
    _controller.sink.add(this.quotesList);
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
  }
}
