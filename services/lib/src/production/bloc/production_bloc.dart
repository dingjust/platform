import 'dart:async';

import 'package:models/models.dart';
import 'package:services/services.dart';

class ProductionBLoC extends BLoCBase {
  // 工厂模式
  factory ProductionBLoC() => _getInstance();

  static ProductionBLoC get instance => _getInstance();
  static ProductionBLoC _instance;

  ProductionBLoC._internal() {
    // 初始化
  }

  static ProductionBLoC _getInstance() {
    if (_instance == null) {
      _instance = new ProductionBLoC._internal();
    }
    return _instance;
  }

  static final List<PurchaseOrderModel> _purchaseOrders = [];

  static final List<FactoryModel> _recommendFactories = [];

  //维护筛选条件
  List<FilterConditionEntry> _orderType = [
    FilterConditionEntry(label: '全部', value: 'ALL', checked: true),
    FilterConditionEntry(label: '线上订单', value: 'ORDER_ONLINE'),
    FilterConditionEntry(label: '线下订单', value: 'ORDER_OFFLINE'),
  ];

  List<FilterConditionEntry> _currentStatus = [
    FilterConditionEntry(label: '全部', value: 'ALL', checked: true),
    FilterConditionEntry(label: '备料', value: 'MATERIAL_PREPARATION'),
    FilterConditionEntry(label: '裁剪', value: 'CUTTING'),
    FilterConditionEntry(label: '车缝', value: 'STITCHING'),
    FilterConditionEntry(label: '后整', value: 'AFTER_FINISHING'),
    FilterConditionEntry(label: '验货', value: 'INSPECTION'),
    FilterConditionEntry(label: '发货', value: 'DELIVERY'),
  ];

  DateTime _startDate;
  DateTime _endDate;

  List<PurchaseOrderModel> orders() => _purchaseOrders;

  List<FactoryModel> recommendFactories() => _recommendFactories;

  List<FilterConditionEntry> get orderType => _orderType;

  List<FilterConditionEntry> get currentStatus => _currentStatus;

  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;

  void setOrderType(List<FilterConditionEntry> conditions) {
    _orderType = conditions;
  }

  void setCurrentStatus(List<FilterConditionEntry> conditions) {
    _currentStatus = conditions;
  }

  void setStartDate(DateTime date) {
    _startDate = date;
  }

  void setEndDate(DateTime date) {
    _endDate = date;
  }

  var _controller = StreamController<List<PurchaseOrderModel>>.broadcast();

  var _recommendController = StreamController<List<FactoryModel>>.broadcast();

  Stream<List<PurchaseOrderModel>> get stream => _controller.stream;

  Stream<List<FactoryModel>> get factoryStream => _recommendController.stream;

  var conditionController = StreamController<FilterConditionEntry>.broadcast();

  Stream<FilterConditionEntry> get conditionStream =>
      conditionController.stream;

  getData() async {
    //若没有数据则查询
    if (_purchaseOrders.isEmpty) {
      // TODO: 分页拿数据，response.data;

      // TODO :根据_orderType、_currentStatus、_startDate、_endDate筛选条件

      _purchaseOrders
          .addAll(await Future.delayed(const Duration(seconds: 1), () {
        return <PurchaseOrderModel>[
          PurchaseOrderModel.fromJson({
            'code': 'PO34938475200045',
            'status': 'IN_PRODUCTION',
            'totalQuantity': 10,
            'totalPrice': 300,
            'creationtime': DateTime.now().toString(),
            'expectedDeliveryDate': DateTime.now().toString(),
            'currentPhase': 'CUTTING',
            'machiningType': '包工包料',
            'invoiceNeeded': true,
            'attachments': [
              {
                'url':
                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                'mediaType': 'jpg'
              },
              {
                'url':
                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                'mediaType': 'jpg'
              },
              {
                'url':
                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                'mediaType': 'jpg'
              },
            ],
            'remarks': '延期了12天',
            'belongTo': {
              'name': '京东工厂',
              'address': '广东省广州市白云区',
            },
            'productionProgresses': [
              {
                'phase': 'MATERIAL_PREPARATION',
                'quantity': 70,
                'sequence': 0,
                'estimatedDate': DateTime.now().toString(),
                'finishDate': DateTime.now().toString(),
                'remarks': '延期了12天',
                'medias': [
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                ],
              },
              {
                'phase': 'CUTTING',
                'quantity': 70,
                'sequence': 2,
                'estimatedDate': DateTime.now().toString(),
                'finishDate': DateTime.now().toString(),
                'remarks': '延期了12天',
                'medias': [
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                ],
              },
              {
                'phase': 'STITCHING',
                'quantity': 70,
                'sequence': 3,
                'estimatedDate': DateTime.now().toString(),
                'finishDate': DateTime.now().toString(),
                'remarks': '延期了12天',
                'medias': [
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                ],
              },
              {
                'phase': 'AFTER_FINISHING',
                'quantity': 70,
                'sequence': 1,
                'estimatedDate': DateTime.now().toString(),
                'finishDate': DateTime.now().toString(),
                'remarks': '延期了12天',
                'medias': [
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                ],
              },
              {
                'phase': 'INSPECTION',
                'quantity': 70,
                'sequence': 4,
                'estimatedDate': DateTime.now().toString(),
                'finishDate': DateTime.now().toString(),
                'remarks': '延期了12天',
                'medias': [
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                ],
              },
              {
                'phase': 'DELIVERY',
                'quantity': 70,
                'sequence': 5,
                'estimatedDate': DateTime.now().toString(),
                'finishDate': DateTime.now().toString(),
                'remarks': '延期了12天',
                'medias': [
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                ],
              },
            ],
            'deliveryAddress': {
              'fullname': "张三",
              'cellphone': '13123456789',
              'region': {'isocode': 'R123', 'name': '广东省'},
              'city': {'code': 'C123', 'name': '广州市'},
              'cityDistrict': {'code': 'D123', 'name': '海珠区'},
              'line1': '广州大道',
              'defaultAddress': true
            },
            'entries': [
              {
                'basePrice': 33.0,
                'quantity': 23,
                'totalPrice': 999.9,
                'requirementOrderCode': 'RC34938475200045',
                'product': {
                  'code': 'NA89852509',
                  'name': '山本风法少女长裙复古气质秋冬款',
                  'skuID': 'NA89852509',
                  'thumbnail':
                      'http://dingyue.nosdn.127.net/ZsKn=CkHLVpuKgUT6wW5uRECVu0=RSGVwrKTeNjszUCdk1538637061484compressflag.jpg'
                },
              }
            ],
          }),
          PurchaseOrderModel.fromJson({
            'code': 'PO34938475200045',
            'status': 'IN_PRODUCTION',
            'totalQuantity': 10,
            'totalPrice': 300,
            'creationtime': DateTime.now().toString(),
            'expectedDeliveryDate': DateTime.now().toString(),
            'currentPhase': 'MATERIAL_PREPARATION',
            'machiningType': '包工包料',
            'invoiceNeeded': true,
            'attachments': [
              {
                'url':
                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                'mediaType': 'jpg'
              },
              {
                'url':
                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                'mediaType': 'jpg'
              },
              {
                'url':
                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                'mediaType': 'jpg'
              },
            ],
            'remarks': '延期了12天',
            'belongTo': {
              'name': '京东工厂',
              'address': '广东省广州市白云区',
            },
            'productionProgresses': [
              {
                'phase': 'MATERIAL_PREPARATION',
                'quantity': 70,
                'sequence': 0,
                'estimatedDate': DateTime.now().toString(),
                'finishDate': DateTime.now().toString(),
                'remarks': '延期了12天',
                'medias': [
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                ],
              },
              {
                'phase': 'CUTTING',
                'quantity': 70,
                'sequence': 2,
                'estimatedDate': DateTime.now().toString(),
                'finishDate': DateTime.now().toString(),
                'remarks': '延期了12天',
                'medias': [
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                ],
              },
              {
                'phase': 'STITCHING',
                'quantity': 70,
                'sequence': 3,
                'estimatedDate': DateTime.now().toString(),
                'finishDate': DateTime.now().toString(),
                'remarks': '延期了12天',
                'medias': [
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                ],
              },
              {
                'phase': 'AFTER_FINISHING',
                'quantity': 70,
                'sequence': 1,
                'estimatedDate': DateTime.now().toString(),
                'finishDate': DateTime.now().toString(),
                'remarks': '延期了12天',
                'medias': [
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                ],
              },
              {
                'phase': 'INSPECTION',
                'quantity': 70,
                'sequence': 4,
                'estimatedDate': DateTime.now().toString(),
                'finishDate': DateTime.now().toString(),
                'remarks': '延期了12天',
                'medias': [
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                ],
              },
              {
                'phase': 'DELIVERY',
                'quantity': 70,
                'sequence': 5,
                'estimatedDate': DateTime.now().toString(),
                'finishDate': DateTime.now().toString(),
                'remarks': '延期了12天',
                'medias': [
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                ],
              },
            ],
            'deliveryAddress': {
              'fullname': "张三",
              'cellphone': '13123456789',
              'region': {'isocode': 'R123', 'name': '广东省'},
              'city': {'code': 'C123', 'name': '广州市'},
              'cityDistrict': {'code': 'D123', 'name': '海珠区'},
              'line1': '广州大道',
              'defaultAddress': true
            },
            'entries': [
              {
                'basePrice': 33.0,
                'quantity': 23,
                'totalPrice': 999.9,
                'requirementOrderCode': 'RC34938475200045',
                'product': {
                  'code': 'NA89852509',
                  'name': '山本风法少女长裙复古气质秋冬款',
                  'skuID': 'NA89852509',
                  'thumbnail':
                      'http://dingyue.nosdn.127.net/ZsKn=CkHLVpuKgUT6wW5uRECVu0=RSGVwrKTeNjszUCdk1538637061484compressflag.jpg'
                },
              }
            ],
          }),
          PurchaseOrderModel.fromJson({
            'code': 'PO34938475200045',
            'status': 'IN_PRODUCTION',
            'totalQuantity': 10,
            'totalPrice': 300,
            'creationtime': DateTime.now().toString(),
            'expectedDeliveryDate': DateTime.now().toString(),
            'currentPhase': 'DELIVERY',
            'machiningType': '包工包料',
            'invoiceNeeded': true,
            'attachments': [
              {
                'url':
                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                'mediaType': 'jpg'
              },
              {
                'url':
                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                'mediaType': 'jpg'
              },
              {
                'url':
                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                'mediaType': 'jpg'
              },
            ],
            'remarks': '延期了12天',
            'belongTo': {
              'name': '京东工厂',
              'address': '广东省广州市白云区',
            },
            'productionProgresses': [
              {
                'phase': 'MATERIAL_PREPARATION',
                'quantity': 70,
                'sequence': 0,
                'estimatedDate': DateTime.now().toString(),
                'finishDate': DateTime.now().toString(),
                'remarks': '延期了12天',
                'medias': [
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                ],
              },
              {
                'phase': 'CUTTING',
                'quantity': 70,
                'sequence': 2,
                'estimatedDate': DateTime.now().toString(),
                'finishDate': DateTime.now().toString(),
                'remarks': '延期了12天',
                'medias': [
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                ],
              },
              {
                'phase': 'STITCHING',
                'quantity': 70,
                'sequence': 3,
                'estimatedDate': DateTime.now().toString(),
                'finishDate': DateTime.now().toString(),
                'remarks': '延期了12天',
                'medias': [
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                ],
              },
              {
                'phase': 'AFTER_FINISHING',
                'quantity': 70,
                'sequence': 1,
                'estimatedDate': DateTime.now().toString(),
                'finishDate': DateTime.now().toString(),
                'remarks': '延期了12天',
                'medias': [
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                ],
              },
              {
                'phase': 'INSPECTION',
                'quantity': 70,
                'sequence': 4,
                'estimatedDate': DateTime.now().toString(),
                'finishDate': DateTime.now().toString(),
                'remarks': '延期了12天',
                'medias': [
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                ],
              },
              {
                'phase': 'DELIVERY',
                'quantity': 70,
                'sequence': 5,
                'estimatedDate': DateTime.now().toString(),
                'finishDate': DateTime.now().toString(),
                'remarks': '延期了12天',
                'medias': [
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                ],
              },
            ],
            'deliveryAddress': {
              'fullname': "张三",
              'cellphone': '13123456789',
              'region': {'isocode': 'R123', 'name': '广东省'},
              'city': {'code': 'C123', 'name': '广州市'},
              'cityDistrict': {'code': 'D123', 'name': '海珠区'},
              'line1': '广州大道',
              'defaultAddress': true
            },
            'entries': [
              {
                'basePrice': 33.0,
                'quantity': 23,
                'totalPrice': 999.9,
                'requirementOrderCode': 'RC34938475200045',
                'product': {
                  'code': 'NA89852509',
                  'name': '山本风法少女长裙复古气质秋冬款',
                  'skuID': 'NA89852509',
                  'thumbnail':
                      'http://dingyue.nosdn.127.net/ZsKn=CkHLVpuKgUT6wW5uRECVu0=RSGVwrKTeNjszUCdk1538637061484compressflag.jpg'
                },
              }
            ],
          }),
          PurchaseOrderModel.fromJson({
            'code': 'PO34938475200045',
            'status': 'IN_PRODUCTION',
            'totalQuantity': 10,
            'totalPrice': 300,
            'creationtime': DateTime.now().toString(),
            'expectedDeliveryDate': DateTime.now().toString(),
            'currentPhase': 'INSPECTION',
            'machiningType': '包工包料',
            'invoiceNeeded': true,
            'attachments': [
              {
                'url':
                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                'mediaType': 'jpg'
              },
              {
                'url':
                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                'mediaType': 'jpg'
              },
              {
                'url':
                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                'mediaType': 'jpg'
              },
            ],
            'remarks': '延期了12天',
            'belongTo': {
              'name': '京东工厂',
              'address': '广东省广州市白云区',
            },
            'productionProgresses': [
              {
                'phase': 'MATERIAL_PREPARATION',
                'quantity': 70,
                'sequence': 0,
                'estimatedDate': DateTime.now().toString(),
                'finishDate': DateTime.now().toString(),
                'remarks': '延期了12天',
                'medias': [
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                ],
              },
              {
                'phase': 'CUTTING',
                'quantity': 70,
                'sequence': 2,
                'estimatedDate': DateTime.now().toString(),
                'finishDate': DateTime.now().toString(),
                'remarks': '延期了12天',
                'medias': [
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                ],
              },
              {
                'phase': 'STITCHING',
                'quantity': 70,
                'sequence': 3,
                'estimatedDate': DateTime.now().toString(),
                'finishDate': DateTime.now().toString(),
                'remarks': '延期了12天',
                'medias': [
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                ],
              },
              {
                'phase': 'AFTER_FINISHING',
                'quantity': 70,
                'sequence': 1,
                'estimatedDate': DateTime.now().toString(),
                'finishDate': DateTime.now().toString(),
                'remarks': '延期了12天',
                'medias': [
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                ],
              },
              {
                'phase': 'INSPECTION',
                'quantity': 70,
                'sequence': 4,
                'estimatedDate': DateTime.now().toString(),
                'finishDate': DateTime.now().toString(),
                'remarks': '延期了12天',
                'medias': [
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                ],
              },
              {
                'phase': 'DELIVERY',
                'quantity': 70,
                'sequence': 5,
                'estimatedDate': DateTime.now().toString(),
                'finishDate': DateTime.now().toString(),
                'remarks': '延期了12天',
                'medias': [
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                  {
                    'url':
                        'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                    'mediaType': 'jpg'
                  },
                ],
              },
            ],
            'deliveryAddress': {
              'fullname': "张三",
              'cellphone': '13123456789',
              'region': {'isocode': 'R123', 'name': '广东省'},
              'city': {'code': 'C123', 'name': '广州市'},
              'cityDistrict': {'code': 'D123', 'name': '海珠区'},
              'line1': '广州大道',
              'defaultAddress': true
            },
            'entries': [
              {
                'basePrice': 33.0,
                'quantity': 23,
                'totalPrice': 999.9,
                'requirementOrderCode': 'RC34938475200045',
                'product': {
                  'code': 'NA89852509',
                  'name': '山本风法少女长裙复古气质秋冬款',
                  'skuID': 'NA89852509',
                  'thumbnail':
                      'http://dingyue.nosdn.127.net/ZsKn=CkHLVpuKgUT6wW5uRECVu0=RSGVwrKTeNjszUCdk1538637061484compressflag.jpg'
                },
              }
            ],
          }),
        ];
      }));
    }
    _controller.sink.add(_purchaseOrders);
  }

  getRecommendFactories() async {
    //若没有数据则查询
    if (_recommendFactories.isEmpty) {
      //TODO:查询推荐工厂接口

      _recommendFactories.addAll(<FactoryModel>[
        FactoryModel(
            historyOrdersCount: 214,
            name: '广州旭日4',
            starLevel: 4,
            describe: '20年经验专业生产牛仔服装，价低质优，本月剩余小量空闲产能，欢迎报价',
            profilePicture:
                'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
            categories: [
              CategoryModel(name: '牛仔'),
              CategoryModel(name: '衬衫'),
              CategoryModel(name: '夹克'),
            ]),
        FactoryModel(
            historyOrdersCount: 214,
            name: '广州旭日3',
            starLevel: 4,
            describe: '20年经验专业生产牛仔服装，价低质优，本月剩余小量空闲产能，欢迎报价',
            profilePicture:
                'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
            categories: [
              CategoryModel(name: '牛仔'),
              CategoryModel(name: '衬衫'),
              CategoryModel(name: '夹克'),
            ]),
        FactoryModel(
            historyOrdersCount: 214,
            name: '广州旭日2',
            starLevel: 4,
            describe: '20年经验专业生产牛仔服装，价低质优，本月剩余小量空闲产能，欢迎报价',
            profilePicture:
                'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
            categories: [
              CategoryModel(name: '牛仔'),
              CategoryModel(name: '衬衫'),
              CategoryModel(name: '夹克'),
            ]),
        FactoryModel(
            historyOrdersCount: 214,
            name: '广州旭日1',
            starLevel: 4,
            describe: '20年经验专业生产牛仔服装，价低质优，本月剩余小量空闲产能，欢迎报价',
            profilePicture:
                'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
            categories: [
              CategoryModel(name: '牛仔'),
              CategoryModel(name: '衬衫'),
              CategoryModel(name: '夹克'),
            ]),
        FactoryModel(
            historyOrdersCount: 214,
            name: '广州旭日0',
            starLevel: 4,
            describe: '20年经验专业生产牛仔服装，价低质优，本月剩余小量空闲产能，欢迎报价',
            profilePicture:
                'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
            categories: [
              CategoryModel(name: '牛仔'),
              CategoryModel(name: '衬衫'),
              CategoryModel(name: '夹克'),
            ]),
      ]);
    }
    _recommendController.sink.add(_recommendFactories);
  }

  clear() async {
    //清空
    _purchaseOrders.clear();
    _controller.sink.add(null);
  }

  //下拉刷新
  Future refreshData() async {
    _purchaseOrders.clear();
    //TODO :查询采购订单接口

    // TODO :根据_orderType、_currentStatus、_startDate、_endDate筛选条件

    _purchaseOrders.add(await Future.delayed(const Duration(seconds: 1), () {
      return PurchaseOrderModel.fromJson({
        'code': 'PO34938475200045',
        'status': 'IN_PRODUCTION',
        'totalQuantity': 10,
        'totalPrice': 300,
        'creationtime': DateTime.now().toString(),
        'expectedDeliveryDate': DateTime.now().toString(),
        'currentPhase': 'CUTTING',
        'machiningType': '包工包料',
        'invoiceNeeded': true,
        'attachments': [
          {
            'url':
                'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
            'mediaType': 'jpg'
          },
          {
            'url':
                'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
            'mediaType': 'jpg'
          },
          {
            'url':
                'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
            'mediaType': 'jpg'
          },
        ],
        'remarks': '延期了12天',
        'belongTo': {
          'name': '京东工厂',
          'address': '广东省广州市白云区',
        },
        'productionProgresses': [
          {
            'phase': 'MATERIAL_PREPARATION',
            'quantity': 70,
            'sequence': 0,
            'estimatedDate': DateTime.now().toString(),
            'finishDate': DateTime.now().toString(),
            'remarks': '延期了12天',
            'medias': [
              {
                'url':
                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                'mediaType': 'jpg'
              },
              {
                'url':
                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                'mediaType': 'jpg'
              },
              {
                'url':
                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                'mediaType': 'jpg'
              },
            ],
          },
          {
            'phase': 'SAMPLE_CONFIRM',
            'quantity': 70,
            'sequence': 1,
            'estimatedDate': DateTime.now().toString(),
            'finishDate': DateTime.now().toString(),
            'remarks': '延期了12天',
            'medias': [
              {
                'url':
                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                'mediaType': 'jpg'
              },
              {
                'url':
                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                'mediaType': 'jpg'
              },
              {
                'url':
                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                'mediaType': 'jpg'
              },
            ],
          },
          {
            'phase': 'CUTTING',
            'quantity': 70,
            'sequence': 2,
            'estimatedDate': DateTime.now().toString(),
            'finishDate': DateTime.now().toString(),
            'remarks': '延期了12天',
            'medias': [
              {
                'url':
                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                'mediaType': 'jpg'
              },
              {
                'url':
                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                'mediaType': 'jpg'
              },
              {
                'url':
                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                'mediaType': 'jpg'
              },
            ],
          },
          {
            'phase': 'STITCHING',
            'quantity': 70,
            'sequence': 3,
            'estimatedDate': DateTime.now().toString(),
            'finishDate': DateTime.now().toString(),
            'remarks': '延期了12天',
            'medias': [
              {
                'url':
                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                'mediaType': 'jpg'
              },
              {
                'url':
                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                'mediaType': 'jpg'
              },
              {
                'url':
                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                'mediaType': 'jpg'
              },
            ],
          },
          {
            'phase': 'INSPECTION',
            'quantity': 70,
            'sequence': 4,
            'estimatedDate': DateTime.now().toString(),
            'finishDate': DateTime.now().toString(),
            'remarks': '延期了12天',
            'medias': [
              {
                'url':
                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                'mediaType': 'jpg'
              },
              {
                'url':
                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                'mediaType': 'jpg'
              },
              {
                'url':
                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                'mediaType': 'jpg'
              },
            ],
          },
          {
            'phase': 'DELIVERY',
            'quantity': 70,
            'sequence': 5,
            'estimatedDate': DateTime.now().toString(),
            'finishDate': DateTime.now().toString(),
            'remarks': '延期了12天',
            'medias': [
              {
                'url':
                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                'mediaType': 'jpg'
              },
              {
                'url':
                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                'mediaType': 'jpg'
              },
              {
                'url':
                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
                'mediaType': 'jpg'
              },
            ],
          },
        ],
        'deliveryAddress': {
          'fullname': "张三",
          'cellphone': '13123456789',
          'region': {'isocode': 'R123', 'name': '广东省'},
          'city': {'code': 'C123', 'name': '广州市'},
          'cityDistrict': {'code': 'D123', 'name': '海珠区'},
          'line1': '广州大道',
          'defaultAddress': true
        },
        'entries': [
          {
            'basePrice': 33.0,
            'quantity': 23,
            'totalPrice': 999.9,
            'requirementOrderCode': 'RC34938475200045',
            'product': {
              'code': 'NA89852509',
              'name': '山本风法少女长裙复古气质秋冬款',
              'skuID': 'NA89852509',
              'thumbnail':
                  'http://dingyue.nosdn.127.net/ZsKn=CkHLVpuKgUT6wW5uRECVu0=RSGVwrKTeNjszUCdk1538637061484compressflag.jpg'
            },
          }
        ],
      });
    }));
    //TODO：查询推荐工厂接口
    _recommendFactories.clear();
    _recommendFactories.add(
      FactoryModel(
          historyOrdersCount: 214,
          name: '广州旭日2',
          starLevel: 4,
          describe: '20年经验专业生产牛仔服装，价低质优，本月剩余小量空闲产能，欢迎报价',
          profilePicture:
              'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
          categories: [
            CategoryModel(name: '牛仔'),
            CategoryModel(name: '衬衫'),
            CategoryModel(name: '夹克'),
          ]),
    );
    _controller.sink.add(_purchaseOrders);
    _recommendController.sink.add(_recommendFactories);
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
