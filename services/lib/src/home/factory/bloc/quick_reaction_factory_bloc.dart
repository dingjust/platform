import 'dart:async';

import 'package:models/models.dart';
import 'package:services/services.dart';

class FactoryBLoC extends BLoCBase {
  // 工厂模式
  factory FactoryBLoC() => _getInstance();

  static FactoryBLoC get instance => _getInstance();
  static FactoryBLoC _instance;

  FactoryBLoC._internal() {
    // 初始化
  }

  static FactoryBLoC _getInstance() {
    if (_instance == null) {
      _instance = new FactoryBLoC._internal();
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
    _factories.add(FactoryModel.fromJson(mockFactory));
    _controller.sink.add(_factories);
  }

  loadingMoreByCondition({String condition, bool isDESC}) async {}

  clear() async {
    //清空
    _factories.clear();
    _controller.sink.add(null);
  }

  //下拉刷新
  Future refreshData({String condition, bool isDESC}) async {}

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

///TODO：mock数据待删除
Map<String, dynamic> mockFactory = {
  'profilePicture': {
    'url': 'http://img.jf258.com/uploads/2015-05-14/030643325.jpg'
  },
  'populationScale': 'N01',
  'uid': 'BB123456',
  'name': '定制加(深圳)科技有限公司',
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
    {
      'code': '1001',
      'name': '卫衣',
    },
    {
      'code': '1002',
      'name': '毛衣',
    },
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
      'profilePicture': 'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
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
      'profilePicture': 'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
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
      'profilePicture': 'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
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
      'profilePicture': 'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
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
      'profilePicture': 'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
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
      'profilePicture': 'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
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
      'profilePicture': 'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
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
        {
          'url':
              'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg'
        },
        {'url': 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg'},
      ],
      'price': 33.3,
    },
    {
      'name': '春秋薄款卫衣',
      'normal': [
        {
          'url':
              'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg'
        },
        {'url': 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg'},
      ],
      'price': 33.3,
    },
    {
      'name': '春秋薄款卫衣',
      'normal': [
        {
          'url':
              'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg'
        },
        {'url': 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg'},
      ],
      'price': 33.3,
    },
    {
      'name': '春秋薄款卫衣',
      'normal': [
        {
          'url':
              'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg'
        },
        {'url': 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg'},
      ],
      'price': 33.3,
    },
    {
      'name': '春秋薄款卫衣',
      'normal': [
        {
          'url':
              'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg'
        },
        {'url': 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg'},
      ],
      'price': 33.3,
    },
  ]
};
