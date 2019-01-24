import 'dart:async';

import 'package:models/models.dart';
import 'package:services/services.dart';

class PurchaseOrderBLoC extends BLoCBase {
  Map<String, List<PurchaseOrderModel>> _ordersMap;

  // 工厂模式
  factory PurchaseOrderBLoC() => _getInstance();

  static PurchaseOrderBLoC get instance => _getInstance();
  static PurchaseOrderBLoC _instance;

  PurchaseOrderBLoC._internal() {
    // 初始化
    _ordersMap = {
      'ALL': [],
      'WAIT_FOR_PROCESSING': [],
      'PENDING_APPROVAL': [],
      'IN_PRODUCTION': [],
      'OUT_OF_STORE': [],
      'COMPLETED': []
    };
  }

  static PurchaseOrderBLoC _getInstance() {
    if (_instance == null) {
      _instance = PurchaseOrderBLoC._internal();
    }
    return _instance;
  }

  List<PurchaseOrderModel> orders(String status) => _ordersMap[status];

  var _controller = StreamController<List<PurchaseOrderModel>>.broadcast();

  Stream<List<PurchaseOrderModel>> get stream => _controller.stream;

  filterByStatuses(String status) async {
    //若没有数据则查询
    if (_ordersMap[status].isEmpty) {
      // TODO: 分页拿数据，response.data;
      _ordersMap[status].addAll(await Future.delayed(const Duration(seconds: 1), () {
        return <PurchaseOrderModel>[
          PurchaseOrderModel.fromJson({
            'code': 'PO34938475200045',
            'status': 'IN_PRODUCTION',
            'totalQuantity': 10,
            'totalPrice': 300,
            'creationtime': DateTime.now().toString(),
            'expectedDeliveryDate': DateTime.now().toString(),
            'currentPhase': 'SAMPLE_CONFIRM',
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
              'address': {
                'region': {'name': '广东省'},
                'city': {'name': '广州市'},
                'cityDistrict': {'name': '白云区'},
              }
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
          }),
          PurchaseOrderModel.fromJson({
            'code': 'PO34938475200045',
            'status': 'IN_PRODUCTION',
            'totalQuantity': 10,
            'totalPrice': 300,
            'creationtime': DateTime.now().toString(),
            'expectedDeliveryDate': DateTime.now().toString(),
            'currentPhase': 'SAMPLE_CONFIRM',
            'machiningType': '包工包料',
            'invoiceNeeded': false,
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
              'address': {
                'region': {'name': '广东省'},
                'city': {'name': '广州市'},
                'cityDistrict': {'name': '白云区'},
              }
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
              'fullname': "",
              'cellphone': '',
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
                  'name': '山本风法少女长裙复古气质秋冬款2',
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
            'currentPhase': 'SAMPLE_CONFIRM',
            'machiningType': '包工包料',
            'invoiceNeeded': false,
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
              'address': {
                'region': {'name': '广东省'},
                'city': {'name': '广州市'},
                'cityDistrict': {'name': '白云区'},
              }
            },
            'productionProgresses': [
              {
                'phase': 'MATERIAL_PREPARATION',
                'quantity': 70,
                'sequence': 0,
                'estimatedDate': DateTime.now().toString(),
                'finishDate': DateTime.now().toString(),
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
                "remarks": "1234564564564"
              },
              {
                'phase': 'SAMPLE_CONFIRM',
                'quantity': 70,
                'sequence': 1,
                'estimatedDate': DateTime.now().toString(),
                'finishDate': DateTime.now().toString(),
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
                "remarks": "1234564564564"
              },
              {
                'phase': 'CUTTING',
                'quantity': 70,
                'sequence': 2,
                'estimatedDate': DateTime.now().toString(),
                'finishDate': DateTime.now().toString(),
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
                "remarks": "1234564564564"
              },
              {
                'phase': 'STITCHING',
                'quantity': 70,
                'sequence': 3,
                'estimatedDate': DateTime.now().toString(),
                'finishDate': DateTime.now().toString(),
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
                "remarks": "1234564564564"
              },
              {
                'phase': 'INSPECTION',
                'quantity': 70,
                'sequence': 4,
                'estimatedDate': DateTime.now().toString(),
                'finishDate': DateTime.now().toString(),
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
                "remarks": "1234564564564"
              },
              {
                'phase': 'DELIVERY',
                'quantity': 70,
                'sequence': 5,
                'estimatedDate': DateTime.now().toString(),
                'finishDate': DateTime.now().toString(),
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
                "remarks": "1234564564564"
              },
            ],
            'deliveryAddress': {
              'fullname': "",
              'cellphone': '',
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
                  'name': '山本风法少女长裙复古气质秋冬款2',
                  'skuID': 'NA89852509',
                  'thumbnail':
                      'http://dingyue.nosdn.127.net/ZsKn=CkHLVpuKgUT6wW5uRECVu0=RSGVwrKTeNjszUCdk1538637061484compressflag.jpg'
                },
              }
            ],
          })
        ];
      }));
    }
    _controller.sink.add(this._ordersMap[status]);
  }

  loadingMoreByStatuses(String status) async {
    //模拟数据到底
    if (_ordersMap[status].length < 6) {
      _ordersMap[status].add(await Future.delayed(const Duration(seconds: 1), () {
        return PurchaseOrderModel.fromJson({
          'code': 'PO34938475200045',
          'status': 'WAIT_FOR_PROCESSING',
          'totalQuantity': 10,
          'totalPrice': 300,
          'creationtime': DateTime.now().toString(),
          'expectedDeliveryDate': DateTime.now().toString(),
          'currentPhase': 'SAMPLE_CONFIRM',
          'machiningType': '包工包料',
          'invoiceNeeded': false,
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
            'address': {
              'region': {'name': '广东省'},
              'city': {'name': '广州市'},
              'cityDistrict': {'name': '白云区'},
            }
          },
          'productionProgresses': [
            {
              'phase': 'MATERIAL_PREPARATION',
              'quantity': 70,
              'sequence': 0,
              'estimatedDate': DateTime.now().toString(),
              'finishDate': DateTime.now().toString(),
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
              "remarks": "1234564564564"
            },
            {
              'phase': 'SAMPLE_CONFIRM',
              'quantity': 70,
              'sequence': 1,
              'estimatedDate': DateTime.now().toString(),
              'finishDate': DateTime.now().toString(),
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
              "remarks": "1234564564564"
            },
            {
              'phase': 'CUTTING',
              'quantity': 70,
              'sequence': 2,
              'estimatedDate': DateTime.now().toString(),
              'finishDate': DateTime.now().toString(),
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
              "remarks": "1234564564564"
            },
            {
              'phase': 'STITCHING',
              'quantity': 70,
              'sequence': 3,
              'estimatedDate': DateTime.now().toString(),
              'finishDate': DateTime.now().toString(),
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
              "remarks": "1234564564564"
            },
            {
              'phase': 'INSPECTION',
              'quantity': 70,
              'sequence': 4,
              'estimatedDate': DateTime.now().toString(),
              'finishDate': DateTime.now().toString(),
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
              "remarks": "1234564564564"
            },
            {
              'phase': 'DELIVERY',
              'quantity': 70,
              'sequence': 5,
              'estimatedDate': DateTime.now().toString(),
              'finishDate': DateTime.now().toString(),
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
              "remarks": "1234564564564"
            },
          ],
          'deliveryAddress': {
            'fullname': "",
            'cellphone': '',
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
                'name': '山本风法少女长裙复古气质秋冬款2',
                'skuID': 'NA89852509',
                'thumbnail':
                    'http://dingyue.nosdn.127.net/ZsKn=CkHLVpuKgUT6wW5uRECVu0=RSGVwrKTeNjszUCdk1538637061484compressflag.jpg'
              },
            }
          ],
        });
      }));
    } else {
      //通知显示已经到底部
      _bottomController.sink.add(true);
    }
    _loadingController.sink.add(false);
    _controller.sink.add(this._ordersMap[status]);
  }

  //下拉刷新
  Future refreshData(String status) async {
    _ordersMap[status].clear();
    _ordersMap[status].add(await Future.delayed(const Duration(seconds: 1), () {
      return PurchaseOrderModel.fromJson({
        'code': 'PO34938475200045',
        'status': 'WAIT_FOR_PROCESSING',
        'totalQuantity': 10,
        'totalPrice': 300,
        'creationtime': DateTime.now().toString(),
        'expectedDeliveryDate': DateTime.now().toString(),
        'currentPhase': 'SAMPLE_CONFIRM',
        'machiningType': '包工包料',
        'invoiceNeeded': false,
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
          'address': {
            'region': {'name': '广东省'},
            'city': {'name': '广州市'},
            'cityDistrict': {'name': '白云区'},
          }
        },
        'productionProgresses': [
          {
            'phase': 'MATERIAL_PREPARATION',
            'quantity': 70,
            'sequence': 0,
            'estimatedDate': DateTime.now().toString(),
            'finishDate': DateTime.now().toString(),
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
            "remarks": "1234564564564"
          },
          {
            'phase': 'SAMPLE_CONFIRM',
            'quantity': 70,
            'sequence': 1,
            'estimatedDate': DateTime.now().toString(),
            'finishDate': DateTime.now().toString(),
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
            "remarks": "1234564564564"
          },
          {
            'phase': 'CUTTING',
            'quantity': 70,
            'sequence': 2,
            'estimatedDate': DateTime.now().toString(),
            'finishDate': DateTime.now().toString(),
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
            "remarks": "1234564564564"
          },
          {
            'phase': 'STITCHING',
            'quantity': 70,
            'sequence': 3,
            'estimatedDate': DateTime.now().toString(),
            'finishDate': DateTime.now().toString(),
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
            "remarks": "1234564564564"
          },
          {
            'phase': 'INSPECTION',
            'quantity': 70,
            'sequence': 4,
            'estimatedDate': DateTime.now().toString(),
            'finishDate': DateTime.now().toString(),
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
            "remarks": "1234564564564"
          },
          {
            'phase': 'DELIVERY',
            'quantity': 70,
            'sequence': 5,
            'estimatedDate': DateTime.now().toString(),
            'finishDate': DateTime.now().toString(),
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
            "remarks": "1234564564564"
          },
        ],
        'deliveryAddress': {
          'fullname': "",
          'cellphone': '',
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
              'name': '山本风法少女长裙复古气质秋冬款2',
              'skuID': 'NA89852509',
              'thumbnail':
              'http://dingyue.nosdn.127.net/ZsKn=CkHLVpuKgUT6wW5uRECVu0=RSGVwrKTeNjszUCdk1538637061484compressflag.jpg'
            },
          }
        ],
      });
    }));
    _controller.sink.add(_ordersMap[status]);
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
