import 'dart:async';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/home/factory/response/factory_response.dart';

class SuppliersBloc {
  SuppliersBloc();
  FactoriesResponse factoriesResponse;
  List<FactoryModel> _list = new List();

  var _controller = StreamController<List<FactoryModel>>.broadcast();

  Stream<List<FactoryModel>> get stream => _controller.stream;

  filter() async {
    if (_list.isEmpty) {
      //若没有数据则查询
      Response response = await http$.post(Apis.factories, data:{}, queryParameters: {});
      factoriesResponse = FactoriesResponse.fromJson(response.data);
    }
    _controller.sink.add(factoriesResponse.content);
  }

  loadingMore() async {
    //模拟数据到底
    if (_list.length < 4) {
      _list.add(await Future.delayed(const Duration(seconds: 1), () {
//        return FactoryModel.fromJson({
//          'factory': {
//            'profilePicture':
//                'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
//            'uid': 'BB123456',
//            'name': '草帽工厂',
//            'starLevel': 5,
//            'historyOrdersCount': 35,
//            'responseQuotedTime': 50,
//            'email': 'monkey.D.luffy@163.com',
//            'phone': '020-12345678',
//            'cooperationModes': ['FOB'],
//            'developmentCapacity': true,
//            'monthlyCapacityRanges': 'MCR003',
//            'latheQuantity': 5,
//            'contactPerson': 'luffy',
//            'contactPhone': '13123456789',
//            'address': '广东省广州市海珠区广州大道南',
//            'contactAddress': {
//              'fullname': "张三",
//              'cellphone': '13123456789',
//              'region': {'isocode': 'R123', 'name': '广东省'},
//              'city': {'code': 'C123', 'name': '广州市'},
//              'cityDistrict': {'code': 'D123', 'name': '海珠区'},
//              'line1': '广州大道南',
//            },
//            'categories': [
//              {
//                'code': '1001',
//                'name': '卫衣',
//              },
//              {
//                'code': '1002',
//                'name': '毛衣',
//              },
//            ],
//            'scaleRange': 'SR005',
//            'registrationDate': DateTime.parse('2018-05-05'),
//            'taxNumber': '41553315446687844',
//            'bankOfDeposit': '中国工商银行',
//            'certificate': [
//              {
//                'url':
//                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
//                'mediaType': 'jpg',
//              },
//              {
//                'url':
//                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
//                'mediaType': 'jpg',
//              },
//              {
//                'url':
//                    'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
//                'mediaType': 'jpg',
//              },
//            ],
//            'cooperativeBrands': [
//              {
//                'profilePicture':
//                    'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
//                'uid': 'BB123456',
//                'name': '草帽工厂',
//                'starLevel': 5,
//                'email': 'monkey.D.luffy@163.com',
//                'phone': '020-12345678',
//                'cooperationModes': ['FOB'],
//                'developmentCapacity': true,
//                'monthlyCapacityRanges': 'MCR003',
//                'latheQuantity': 5,
//                'contactPerson': 'luffy',
//                'contactPhone': '13123456789',
//              },
//              {
//                'profilePicture':
//                    'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
//                'uid': 'BB123456',
//                'name': '草帽工厂',
//                'starLevel': 5,
//                'email': 'monkey.D.luffy@163.com',
//                'phone': '020-12345678',
//                'cooperationModes': ['FOB'],
//                'developmentCapacity': true,
//                'monthlyCapacityRanges': 'MCR003',
//                'latheQuantity': 5,
//                'contactPerson': 'luffy',
//                'contactPhone': '13123456789',
//              },
//              {
//                'profilePicture':
//                    'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
//                'uid': 'BB123456',
//                'name': '草帽工厂',
//                'starLevel': 5,
//                'email': 'monkey.D.luffy@163.com',
//                'phone': '020-12345678',
//                'cooperationModes': ['FOB'],
//                'developmentCapacity': true,
//                'monthlyCapacityRanges': 'MCR003',
//                'latheQuantity': 5,
//                'contactPerson': 'luffy',
//                'contactPhone': '13123456789',
//              },
//              {
//                'profilePicture':
//                    'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
//                'uid': 'BB123456',
//                'name': '草帽工厂',
//                'starLevel': 5,
//                'email': 'monkey.D.luffy@163.com',
//                'phone': '020-12345678',
//                'cooperationModes': ['FOB'],
//                'developmentCapacity': true,
//                'monthlyCapacityRanges': 'MCR003',
//                'latheQuantity': 5,
//                'contactPerson': 'luffy',
//                'contactPhone': '13123456789',
//              },
//              {
//                'profilePicture':
//                    'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
//                'uid': 'BB123456',
//                'name': '草帽工厂',
//                'starLevel': 5,
//                'email': 'monkey.D.luffy@163.com',
//                'phone': '020-12345678',
//                'cooperationModes': ['FOB'],
//                'developmentCapacity': true,
//                'monthlyCapacityRanges': 'MCR003',
//                'latheQuantity': 5,
//                'contactPerson': 'luffy',
//                'contactPhone': '13123456789',
//              },
//              {
//                'profilePicture':
//                    'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
//                'uid': 'BB123456',
//                'name': '草帽工厂',
//                'starLevel': 5,
//                'email': 'monkey.D.luffy@163.com',
//                'phone': '020-12345678',
//                'cooperationModes': ['FOB'],
//                'developmentCapacity': true,
//                'monthlyCapacityRanges': 'MCR003',
//                'latheQuantity': 5,
//                'contactPerson': 'luffy',
//                'contactPhone': '13123456789',
//              },
//              {
//                'profilePicture':
//                    'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
//                'uid': 'BB123456',
//                'name': '草帽工厂',
//                'starLevel': 5,
//                'email': 'monkey.D.luffy@163.com',
//                'phone': '020-12345678',
//                'cooperationModes': ['FOB'],
//                'developmentCapacity': true,
//                'monthlyCapacityRanges': 'MCR003',
//                'latheQuantity': 5,
//                'contactPerson': 'luffy',
//                'contactPhone': '13123456789',
//              },
//            ],
//            'products': [
//              {
//                'name': '春秋薄款卫衣',
//                'thumbnails': [
//                  {'url': 'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg'},
//                  {'url': 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg'},
//                ],
//                'price': 33.3,
//              },
//              {
//                'name': '春秋薄款卫衣',
//                'thumbnails': [
//                  {'url': 'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg'},
//                  {'url': 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg'},
//                ],
//                'price': 33.3,
//              },
//              {
//                'name': '春秋薄款卫衣',
//                'thumbnails': [
//                  {'url': 'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg'},
//                  {'url': 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg'},
//                ],
//                'price': 33.3,
//              },
//              {
//                'name': '春秋薄款卫衣',
//                'thumbnails': [
//                  {'url': 'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg'},
//                  {'url': 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg'},
//                ],
//                'price': 33.3,
//              },
//              {
//                'name': '春秋薄款卫衣',
//                'thumbnails': [
//                  {'url': 'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg'},
//                  {'url': 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg'},
//                ],
//                'price': 33.3,
//              },
//            ]
//          },
//          'orderCount': 50,
//          'quoteCount': 30,
//          'purchaseOrder': {
//            'code': 'PO34938475200045',
//            'status': 'PENDING_PAYMENT',
//            'totalQuantity': 10,
//            'totalPrice': 300,
//            'creationtime': DateTime.parse('2018-05-05'),
//            'entries': [
//              {
//                'basePrice': 33.0,
//                'quantity': 23,
//                'totalPrice': 999.9,
//                'requirementOrderCode': 'RC34938475200045',
//                'product': {
//                  'code': 'NA89852509',
//                  'name': '山本风法少女长裙复古气质秋冬款2',
//                  'skuID': 'NA89852509',
//                  'thumbnail':
//                      'http://dingyue.nosdn.127.net/ZsKn=CkHLVpuKgUT6wW5uRECVu0=RSGVwrKTeNjszUCdk1538637061484compressflag.jpg'
//                },
//              }
//            ],
//          },
//          'quoteOrder': {
//            'order': {
//              'code': '39492523423',
//              'state': 'SELLER_SUBMITTED',
//              'totalPrice': 54,
//              'totalQuantity': 554,
//              'creationtime': DateTime.parse('2018-05-05'),
//              'expectedDeliveryDate': DateTime.parse('2018-05-05'),
//              'requirementOrderCode': '4513516134451',
//            },
//            'product': {
//              'name': '山本风少女长裙复古气质秋冬流行新款',
//              'skuID': 'NA89852631',
//              'thumbnail':
//                  'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
//            },
//          }
//        });
      }));
    } else {
      //通知显示已经到底部
      _bottomController.sink.add(true);
    }
    _loadingController.sink.add(false);
    _controller.sink.add(this._list);
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
