import 'dart:async';

import 'package:models/models.dart';
import 'package:services/services.dart';

class ProofingOrdersBLoC extends BLoCBase {
  // 工厂模式
  factory ProofingOrdersBLoC() => _getInstance();

  static ProofingOrdersBLoC get instance => _getInstance();
  static ProofingOrdersBLoC _instance;

  ProofingOrdersBLoC._internal() {
    // 初始化
  }

  static ProofingOrdersBLoC _getInstance() {
    if (_instance == null) {
      _instance = new ProofingOrdersBLoC._internal();
    }
    return _instance;
  }

  static final Map<String, List<ProofingModel>> _quotesMap = {
    'ALL': List<ProofingModel>(),
    'PENDING_PAYMENT': List<ProofingModel>(),
    'PENDING_DELIVERY': List<ProofingModel>(),
    'SHIPPED': List<ProofingModel>(),
    'COMPLETED': List<ProofingModel>()
  };

  List<ProofingModel> quotes(String status) => _quotesMap[status];

  var _controller = StreamController<List<ProofingModel>>.broadcast();

  Stream<List<ProofingModel>> get stream => _controller.stream;

  filterByStatuses(String status) async {
    //若没有数据则查询
    if (_quotesMap[status].isEmpty) {
      // TODO: 分页拿数据，response.data;
      _quotesMap[status]
          .addAll(await Future.delayed(const Duration(seconds: 1), () {
        return <ProofingModel>[
          ProofingModel(
            code: '1232323232',
            remarks: '请尽快支付打样费用，以免延期，谢谢！',
            factory: FactoryModel.fromJson(mockFactory),
            status: ProofingStatus.PENDING_PAYMENT,
            totalPrice: 54,
            totalQuantity: 554,
            order: RequirementOrderModel(
              code: '39492523423',
            ),
            deliveryAddress: AddressModel.fromJson({
              'fullname': "张三",
              'cellphone': '13123456789',
              'region': {'isocode': 'R123', 'name': '广东省'},
              'city': {'code': 'C123', 'name': '广州市'},
              'cityDistrict': {'code': 'D123', 'name': '海珠区'},
              'line1': '广州大道',
              'defaultAddress': true
            }),
            creationTime: DateTime.parse('2019-01-03'),
            product: ApparelProductModel(
              name: '山本风少女长裙复古气质秋冬流行新款',
              skuID: 'NA89852631',
              thumbnail:
                  'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
              majorCategory: CategoryModel(name: '针织'),
              minorCategory: CategoryModel(name: '女装-T恤'),
            ),
          ),
          ProofingModel(
            code: '1232323232',
            remarks: '请尽快支付打样费用，以免延期，谢谢！',
            factory: FactoryModel.fromJson(mockFactory),
            status: ProofingStatus.COMPLETED,
            totalPrice: 54,
            totalQuantity: 554,
            order: RequirementOrderModel(
              code: '39492523423',
            ),
            deliveryAddress: AddressModel.fromJson({
              'fullname': "张三",
              'cellphone': '13123456789',
              'region': {'isocode': 'R123', 'name': '广东省'},
              'city': {'code': 'C123', 'name': '广州市'},
              'cityDistrict': {'code': 'D123', 'name': '海珠区'},
              'line1': '广州大道',
              'defaultAddress': true
            }),
            creationTime: DateTime.parse('2019-01-03'),
            product: ApparelProductModel(
              name: '山本风少女长裙复古气质秋冬流行新款',
              skuID: 'NA89852631',
              thumbnail:
                  'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
              majorCategory: CategoryModel(name: '针织'),
              minorCategory: CategoryModel(name: '女装-T恤'),
            ),
          ),
          ProofingModel(
            code: '1232323232',
            remarks: '请尽快支付打样费用，以免延期，谢谢！',
            factory: FactoryModel.fromJson(mockFactory),
            status: ProofingStatus.SHIPPED,
            totalPrice: 54,
            totalQuantity: 554,
            deliveryAddress: AddressModel.fromJson({
              'fullname': "张三",
              'cellphone': '13123456789',
              'region': {'isocode': 'R123', 'name': '广东省'},
              'city': {'code': 'C123', 'name': '广州市'},
              'cityDistrict': {'code': 'D123', 'name': '海珠区'},
              'line1': '广州大道',
              'defaultAddress': true
            }),
            order: RequirementOrderModel(
              code: '39492523423',
            ),
            creationTime: DateTime.parse('2019-01-03'),
            product: ApparelProductModel(
              name: '山本风少女长裙复古气质秋冬流行新款',
              skuID: 'NA89852631',
              thumbnail:
                  'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
              majorCategory: CategoryModel(name: '针织'),
              minorCategory: CategoryModel(name: '女装-T恤'),
            ),
          ),
          ProofingModel(
            code: '1232323232',
            remarks: '请尽快支付打样费用，以免延期，谢谢！',
            factory: FactoryModel.fromJson(mockFactory),
            status: ProofingStatus.PENDING_PAYMENT,
            totalPrice: 54,
            totalQuantity: 554,
            order: RequirementOrderModel(
              code: '39492523423',
            ),
            deliveryAddress: AddressModel.fromJson({
              'fullname': "张三",
              'cellphone': '13123456789',
              'region': {'isocode': 'R123', 'name': '广东省'},
              'city': {'code': 'C123', 'name': '广州市'},
              'cityDistrict': {'code': 'D123', 'name': '海珠区'},
              'line1': '广州大道',
              'defaultAddress': true
            }),
            creationTime: DateTime.parse('2019-01-03'),
            product: ApparelProductModel(
              name: '山本风少女长裙复古气质秋冬流行新款',
              skuID: 'NA89852631',
              thumbnail:
                  'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
              majorCategory: CategoryModel(name: '针织'),
              minorCategory: CategoryModel(name: '女装-T恤'),
            ),
          ),
          ProofingModel(
            code: '1232323232',
            remarks: '请尽快支付打样费用，以免延期，谢谢！',
            factory: FactoryModel.fromJson(mockFactory),
            status: ProofingStatus.PENDING_DELIVERY,
            totalPrice: 54,
            totalQuantity: 554,
            order: RequirementOrderModel(
              code: '39492523423',
            ),
            deliveryAddress: AddressModel.fromJson({
              'fullname': "张三",
              'cellphone': '13123456789',
              'region': {'isocode': 'R123', 'name': '广东省'},
              'city': {'code': 'C123', 'name': '广州市'},
              'cityDistrict': {'code': 'D123', 'name': '海珠区'},
              'line1': '广州大道',
              'defaultAddress': true
            }),
            creationTime: DateTime.parse('2019-01-03'),
            product: ApparelProductModel(
              name: '山本风少女长裙复古气质秋冬流行新款',
              skuID: 'NA89852631',
              thumbnail:
                  'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
              majorCategory: CategoryModel(name: '针织'),
              minorCategory: CategoryModel(name: '女装-T恤'),
            ),
          ),
        ];
      }));
    }
    _controller.sink.add(_quotesMap[status]);
  }

  loadingMoreByStatuses(String status) async {
    //模拟数据到底
    if (_quotesMap[status].length < 12) {
      _quotesMap[status]
          .add(await Future.delayed(const Duration(seconds: 1), () {
        return ProofingModel(
          code: '1232323232',
          remarks: '请尽快支付打样费用，以免延期，谢谢！',
          factory: FactoryModel.fromJson(mockFactory),
          status: ProofingStatus.PENDING_PAYMENT,
          totalPrice: 54,
          totalQuantity: 554,
          order: RequirementOrderModel(
            code: '39492523423',
          ),
          deliveryAddress: AddressModel.fromJson({
            'fullname': "张三",
            'cellphone': '13123456789',
            'region': {'isocode': 'R123', 'name': '广东省'},
            'city': {'code': 'C123', 'name': '广州市'},
            'cityDistrict': {'code': 'D123', 'name': '海珠区'},
            'line1': '广州大道',
            'defaultAddress': true
          }),
          creationTime: DateTime.parse('2019-01-03'),
          product: ApparelProductModel(
            name: '山本风少女长裙复古气质秋冬流行新款',
            skuID: 'NA89852631',
            thumbnail:
                'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
            majorCategory: CategoryModel(name: '针织'),
            minorCategory: CategoryModel(name: '女装-T恤'),
          ),
        );
      }));
    } else {
      //通知显示已经到底部
      _bottomController.sink.add(true);
    }
    _loadingController.sink.add(false);
    _controller.sink.add(_quotesMap[status]);
  }

  //下拉刷新
  Future refreshData(String status) async {
    _quotesMap[status].clear();
    _quotesMap[status].add(await Future.delayed(const Duration(seconds: 1), () {
      return ProofingModel(
        code: '1232323232',
        remarks: '请尽快支付打样费用，以免延期，谢谢！',
        factory: FactoryModel.fromJson(mockFactory),
        status: ProofingStatus.PENDING_PAYMENT,
        totalPrice: 54,
        totalQuantity: 554,
        order: RequirementOrderModel(
          code: '39492523423',
        ),
        deliveryAddress: AddressModel.fromJson({
          'fullname': "张三",
          'cellphone': '13123456789',
          'region': {'isocode': 'R123', 'name': '广东省'},
          'city': {'code': 'C123', 'name': '广州市'},
          'cityDistrict': {'code': 'D123', 'name': '海珠区'},
          'line1': '广州大道',
          'defaultAddress': true
        }),
        creationTime: DateTime.parse('2019-01-03'),
        product: ApparelProductModel(
          name: '山本风少女长裙复古气质秋冬流行新款',
          skuID: 'NA89852631',
          thumbnail:
              'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
          majorCategory: CategoryModel(name: '针织'),
          minorCategory: CategoryModel(name: '女装-T恤'),
        ),
      );
    }));
    _controller.sink.add(_quotesMap[status]);
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

//mock数据待删除
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
  'address': '广东广州',
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
        {'url': 'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg'},
        {'url': 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg'},
      ],
      'price': 33.3,
    },
    {
      'name': '春秋薄款卫衣',
      'normal': [
        {'url': 'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg'},
        {'url': 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg'},
      ],
      'price': 33.3,
    },
    {
      'name': '春秋薄款卫衣',
      'normal': [
        {'url': 'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg'},
        {'url': 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg'},
      ],
      'price': 33.3,
    },
    {
      'name': '春秋薄款卫衣',
      'normal': [
        {'url': 'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg'},
        {'url': 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg'},
      ],
      'price': 33.3,
    },
    {
      'name': '春秋薄款卫衣',
      'normal': [
        {'url': 'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg'},
        {'url': 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg'},
      ],
      'price': 33.3,
    },
  ]
};
