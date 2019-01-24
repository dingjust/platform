import 'dart:async';

import 'package:models/models.dart';
import 'package:services/services.dart';

class QuickReactionFactoryBLoC extends BLoCBase {
  // 工厂模式
  factory QuickReactionFactoryBLoC() => _getInstance();

  static QuickReactionFactoryBLoC get instance => _getInstance();
  static QuickReactionFactoryBLoC _instance;

  QuickReactionFactoryBLoC._internal() {
    // 初始化
  }

  static QuickReactionFactoryBLoC _getInstance() {
    if (_instance == null) {
      _instance = new QuickReactionFactoryBLoC._internal();
    }
    return _instance;
  }

  static final List<FactoryModel> _factories = [];

  List<FactoryModel> get factories => _factories;

  var _controller = StreamController<List<FactoryModel>>.broadcast();

  Stream<List<FactoryModel>> get stream => _controller.stream;

  var conditionController = StreamController<FilterConditionEntry>.broadcast();

  Stream<FilterConditionEntry> get conditionStream =>
      conditionController.stream;

  filterByCondition({String condition, bool isDESC}) async {
    _factories.clear();
    //若没有数据则查询
    if (_factories.isEmpty) {
      // TODO: 分页拿数据，response.data;
      _factories.addAll(await Future.delayed(const Duration(seconds: 1), () {
        if (isDESC) {
          return <FactoryModel>[
            FactoryModel(
                historyOrdersCount: 214,
                name: '广州旭日4',
                starLevel: 4,
                profilePicture:
                    'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                categories: [
                  CategoryModel(name: '牛仔'),
                  CategoryModel(name: '衬衫'),
                  CategoryModel(name: '夹克'),
                  CategoryModel(name: '卫衣'),
                ]),
            FactoryModel(
                historyOrdersCount: 214,
                name: '广州旭日3',
                starLevel: 4,
                profilePicture:
                    'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                categories: [
                  CategoryModel(name: '牛仔'),
                  CategoryModel(name: '衬衫'),
                  CategoryModel(name: '夹克'),
                  CategoryModel(name: '卫衣'),
                ]),
            FactoryModel(
                historyOrdersCount: 214,
                name: '广州旭日2',
                starLevel: 4,
                profilePicture:
                    'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                categories: [
                  CategoryModel(name: '牛仔'),
                  CategoryModel(name: '衬衫'),
                  CategoryModel(name: '夹克'),
                  CategoryModel(name: '卫衣'),
                ]),
            FactoryModel(
                historyOrdersCount: 214,
                profilePicture:
                    'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                name: '广州旭日1',
                starLevel: 4,
                categories: [
                  CategoryModel(name: '牛仔'),
                  CategoryModel(name: '衬衫'),
                  CategoryModel(name: '夹克'),
                  CategoryModel(name: '卫衣'),
                ])
          ];
        } else {
          return <FactoryModel>[
            FactoryModel(
                historyOrdersCount: 214,
                name: '广州旭日1',
                starLevel: 4,
                profilePicture:
                    'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                categories: [
                  CategoryModel(name: '牛仔'),
                  CategoryModel(name: '衬衫'),
                  CategoryModel(name: '夹克'),
                  CategoryModel(name: '卫衣'),
                ]),
            FactoryModel(
                historyOrdersCount: 214,
                name: '广州旭日2',
                starLevel: 4,
                profilePicture:
                    'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                categories: [
                  CategoryModel(name: '牛仔'),
                  CategoryModel(name: '衬衫'),
                  CategoryModel(name: '夹克'),
                  CategoryModel(name: '卫衣'),
                ]),
            FactoryModel(
                historyOrdersCount: 214,
                name: '广州旭日3',
                starLevel: 4,
                profilePicture:
                    'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                categories: [
                  CategoryModel(name: '牛仔'),
                  CategoryModel(name: '衬衫'),
                  CategoryModel(name: '夹克'),
                  CategoryModel(name: '卫衣'),
                ]),
            FactoryModel(
                historyOrdersCount: 214,
                name: '广州旭日4',
                starLevel: 4,
                profilePicture:
                    'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                categories: [
                  CategoryModel(name: '牛仔'),
                  CategoryModel(name: '衬衫'),
                  CategoryModel(name: '夹克'),
                  CategoryModel(name: '卫衣'),
                ])
          ];
        }
      }));
    }
    _controller.sink.add(_factories);
  }

  loadingMoreByCondition({String condition, bool isDESC}) async {
    //模拟数据到底
    if (_factories.length < 6) {
      _factories.add(await Future.delayed(const Duration(seconds: 1), () {
        return FactoryModel(
            historyOrdersCount: 214,
            name: '广州旭日',
            starLevel: 4,
            profilePicture:
                'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
            categories: [
              CategoryModel(name: '牛仔'),
              CategoryModel(name: '衬衫'),
              CategoryModel(name: '夹克'),
              CategoryModel(name: '卫衣'),
            ]);
      }));
    } else {
      //通知显示已经到底部
      _bottomController.sink.add(true);
    }
    _loadingController.sink.add(false);
    _controller.sink.add(_factories);
  }

  clear() async {
    //清空
    _factories.clear();
    _controller.sink.add(null);
  }

  //下拉刷新
  Future refreshData({String condition, bool isDESC}) async {
    _factories.clear();
    _factories.add(await Future.delayed(const Duration(seconds: 1), () {
      return FactoryModel(
          historyOrdersCount: 214,
          name: '广州旭日',
          starLevel: 4,
          profilePicture:
              'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
          categories: [
            CategoryModel(name: '牛仔'),
            CategoryModel(name: '衬衫'),
            CategoryModel(name: '夹克'),
            CategoryModel(name: '卫衣'),
          ]);
    }));
    _controller.sink.add(_factories);
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
