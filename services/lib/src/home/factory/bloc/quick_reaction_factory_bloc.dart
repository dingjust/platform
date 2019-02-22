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

  List<FactoryModel> _factories = [];

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
      _factories = (await Future.delayed(const Duration(seconds: 1), () {
        if (isDESC) {
          List<FactoryModel> list = [];
          for (int i = 10; i >= 0; i--) {
            FactoryModel model = FactoryModel.fromJson(mockFactory);
            model.name = '草帽工厂${i}';
            list.add(model);
          }
          return list;
        } else {
          List<FactoryModel> list = [];
          for (int i = 1; i <= 10; i++) {
            FactoryModel model = FactoryModel.fromJson(mockFactory);
            model.name = '草帽工厂${i}';
            list.add(model);
          }
          return list;
        }
      }));
    }
    _controller.sink.add(_factories);
  }

  loadingMoreByCondition({String condition, bool isDESC}) async {
    //模拟数据到底
    if (_factories.length < 15) {
      _factories.add(await Future.delayed(const Duration(seconds: 1), () {
        return FactoryModel.fromJson(mockFactory);
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
    _factories = (await Future.delayed(const Duration(seconds: 1), () {
      if (isDESC) {
        List<FactoryModel> list = [];
        for (int i = 10; i >= 0; i--) {
          FactoryModel model = FactoryModel.fromJson(mockFactory);
          model.name = '草帽工厂${i}';
          list.add(model);
        }
        return list;
      } else {
        List<FactoryModel> list = [];
        for (int i = 1; i <= 10; i++) {
          FactoryModel model = FactoryModel.fromJson(mockFactory);
          model.name = '草帽工厂${i}';
          list.add(model);
        }
        return list;
      }
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

  ///TODO：mock数据待删除
  Map<String, dynamic> mockFactory = {
    'profilePicture': 'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
    'uid': 'BB123456',
    'name': '草帽工厂',
    'starLevel': 5,
    'describe': '20年经验专业生产牛仔服装，价低质优，本月剩余小量空闲产能，欢迎报价',
    'historyOrdersCount': 35,
    'responseQuotedTime': 50,
    'email': 'monkey.D.luffy@163.com',
    'phone': '020-12345678',
    'cooperationModes': ['FOB'],
    'developmentCapacity': true,
    'monthlyCapacityRanges': 'MCR003',
    'latheQuantity': 5,
    'contactPerson': 'luffy',
    'contactPhone': '13123456789',
    'address': '广东省广州市海珠区广州大道南',
    'contactAddress': {
      'fullname': "张三",
      'cellphone': '13123456789',
      'region': {'isocode': 'R123', 'name': '广东省'},
      'city': {'code': 'C123', 'name': '广州市'},
      'cityDistrict': {'code': 'D123', 'name': '海珠区'},
      'line1': '广州大道南',
    },
    'categories': [
      {
        'code': '1001',
        'name': '卫衣',
      },
      {
        'code': '1002',
        'name': '毛衣',
      },
    ],
    'scaleRange': 'SR005',
    'registrationDate': DateTime.now().toString(),
    'taxNumber': '41553315446687844',
    'bankOfDeposit': '中国工商银行',
    'certificate': [
      {
        'url':
            'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
        'mediaType': 'jpg',
      },
      {
        'url':
            'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
        'mediaType': 'jpg',
      },
      {
        'url':
            'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
        'mediaType': 'jpg',
      },
    ],
    'cooperativeBrands': [
      {
        'profilePicture':
            'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
        'uid': 'BB123456',
        'name': '草帽工厂',
        'starLevel': 5,
        'email': 'monkey.D.luffy@163.com',
        'phone': '020-12345678',
        'cooperationModes': ['FOB'],
        'developmentCapacity': true,
        'monthlyCapacityRanges': 'MCR003',
        'latheQuantity': 5,
        'contactPerson': 'luffy',
        'contactPhone': '13123456789',
      },
      {
        'profilePicture':
            'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
        'uid': 'BB123456',
        'name': '草帽工厂',
        'starLevel': 5,
        'email': 'monkey.D.luffy@163.com',
        'phone': '020-12345678',
        'cooperationModes': ['FOB'],
        'developmentCapacity': true,
        'monthlyCapacityRanges': 'MCR003',
        'latheQuantity': 5,
        'contactPerson': 'luffy',
        'contactPhone': '13123456789',
      },
      {
        'profilePicture':
            'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
        'uid': 'BB123456',
        'name': '草帽工厂',
        'starLevel': 5,
        'email': 'monkey.D.luffy@163.com',
        'phone': '020-12345678',
        'cooperationModes': ['FOB'],
        'developmentCapacity': true,
        'monthlyCapacityRanges': 'MCR003',
        'latheQuantity': 5,
        'contactPerson': 'luffy',
        'contactPhone': '13123456789',
      },
      {
        'profilePicture':
            'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
        'uid': 'BB123456',
        'name': '草帽工厂',
        'starLevel': 5,
        'email': 'monkey.D.luffy@163.com',
        'phone': '020-12345678',
        'cooperationModes': ['FOB'],
        'developmentCapacity': true,
        'monthlyCapacityRanges': 'MCR003',
        'latheQuantity': 5,
        'contactPerson': 'luffy',
        'contactPhone': '13123456789',
      },
      {
        'profilePicture':
            'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
        'uid': 'BB123456',
        'name': '草帽工厂',
        'starLevel': 5,
        'email': 'monkey.D.luffy@163.com',
        'phone': '020-12345678',
        'cooperationModes': ['FOB'],
        'developmentCapacity': true,
        'monthlyCapacityRanges': 'MCR003',
        'latheQuantity': 5,
        'contactPerson': 'luffy',
        'contactPhone': '13123456789',
      },
      {
        'profilePicture':
            'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
        'uid': 'BB123456',
        'name': '草帽工厂',
        'starLevel': 5,
        'email': 'monkey.D.luffy@163.com',
        'phone': '020-12345678',
        'cooperationModes': ['FOB'],
        'developmentCapacity': true,
        'monthlyCapacityRanges': 'MCR003',
        'latheQuantity': 5,
        'contactPerson': 'luffy',
        'contactPhone': '13123456789',
      },
      {
        'profilePicture':
            'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
        'uid': 'BB123456',
        'name': '草帽工厂',
        'starLevel': 5,
        'email': 'monkey.D.luffy@163.com',
        'phone': '020-12345678',
        'cooperationModes': ['FOB'],
        'developmentCapacity': true,
        'monthlyCapacityRanges': 'MCR003',
        'latheQuantity': 5,
        'contactPerson': 'luffy',
        'contactPhone': '13123456789',
      },
    ],
    'products': [
      {
        'name': '春秋薄款卫衣',
        'normal': [
          'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548306578766&di=582a7f725bffd1d95852c70c07f8fd9c&imgtype=0&src=http%3A%2F%2Fimg009.hc360.cn%2Fg6%2FM06%2F71%2FEE%2FwKhQr1PjF5WEEgn9AAAAAJ0GDyw582.jpg'
        ],
        'price': 33.3,
      },
      {
        'name': '春秋薄款卫衣',
        'normal': [
          'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548306578766&di=582a7f725bffd1d95852c70c07f8fd9c&imgtype=0&src=http%3A%2F%2Fimg009.hc360.cn%2Fg6%2FM06%2F71%2FEE%2FwKhQr1PjF5WEEgn9AAAAAJ0GDyw582.jpg'
        ],
        'price': 33.3,
      },
      {
        'name': '春秋薄款卫衣',
        'normal': [
          'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548306578766&di=582a7f725bffd1d95852c70c07f8fd9c&imgtype=0&src=http%3A%2F%2Fimg009.hc360.cn%2Fg6%2FM06%2F71%2FEE%2FwKhQr1PjF5WEEgn9AAAAAJ0GDyw582.jpg'
        ],
        'price': 33.3,
      },
      {
        'name': '春秋薄款卫衣',
        'normal': [
          'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548306578766&di=582a7f725bffd1d95852c70c07f8fd9c&imgtype=0&src=http%3A%2F%2Fimg009.hc360.cn%2Fg6%2FM06%2F71%2FEE%2FwKhQr1PjF5WEEgn9AAAAAJ0GDyw582.jpg'
        ],
        'price': 33.3,
      },
      {
        'name': '春秋薄款卫衣',
        'normal': [
          'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548306578766&di=582a7f725bffd1d95852c70c07f8fd9c&imgtype=0&src=http%3A%2F%2Fimg009.hc360.cn%2Fg6%2FM06%2F71%2FEE%2FwKhQr1PjF5WEEgn9AAAAAJ0GDyw582.jpg'
        ],
        'price': 33.3,
      },
    ]
  };
}
