import 'dart:async';
import 'package:models/models.dart';

class SuppliersBloc {
  SuppliersBloc();

  List<SupplierModel> _list = new List();

  var _controller = StreamController<List<SupplierModel>>.broadcast();

  Stream<List<SupplierModel>> get stream => _controller.stream;

  filter() async {
    if (_list.isEmpty) {
      //若没有数据则查询
      _list.addAll(await Future.delayed(const Duration(seconds: 1), () {
        return <SupplierModel>[
          SupplierModel.fromJson({
            'factory': {
              'profilePicture':
                  'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
              'uid': 'BB123456',
              'name': '草帽工厂',
              'starLevel': 5,
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
            },
            'orderCount': 50,
            'quoteCount': 30,
            'purchaseOrder': {
              'code': 'PO34938475200045',
              'status': 'WAIT_FOR_PROCESSING',
              'totalQuantity': 10,
              'totalPrice': 300,
              'creationtime': DateTime.now().toString(),
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
            },
            'quoteOrder': {
              'order': {
                'code': '39492523423',
                'state': 'SELLER_SUBMITTED',
                'totalPrice': 54,
                'totalQuantity': 554,
                'creationtime': DateTime.now().toString(),
                'expectedDeliveryDate': DateTime.now().toString(),
                'requirementOrderCode': '4513516134451',
              },
              'product': {
                'name': '山本风少女长裙复古气质秋冬流行新款',
                'skuID': 'NA89852631',
                'thumbnail':
                    'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
              },
            }
          }),
          SupplierModel.fromJson({
            'factory': {
              'profilePicture':
              'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
              'uid': 'BB123456',
              'name': '草帽工厂',
              'starLevel': 5,
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
            },
            'orderCount': 50,
            'quoteCount': 30,
            'purchaseOrder': {
              'code': 'PO34938475200045',
              'status': 'WAIT_FOR_PROCESSING',
              'totalQuantity': 10,
              'totalPrice': 300,
              'creationtime': DateTime.now().toString(),
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
            },
            'quoteOrder': {
              'order': {
                'code': '39492523423',
                'state': 'SELLER_SUBMITTED',
                'totalPrice': 54,
                'totalQuantity': 554,
                'creationtime': DateTime.now().toString(),
                'expectedDeliveryDate': DateTime.now().toString(),
                'requirementOrderCode': '4513516134451',
              },
              'product': {
                'name': '山本风少女长裙复古气质秋冬流行新款',
                'skuID': 'NA89852631',
                'thumbnail':
                'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
              },
            }
          }),
          SupplierModel.fromJson({
            'factory': {
              'profilePicture':
              'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
              'uid': 'BB123456',
              'name': '草帽工厂',
              'starLevel': 5,
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
            },
            'orderCount': 50,
            'quoteCount': 30,
            'purchaseOrder': {
              'code': 'PO34938475200045',
              'status': 'WAIT_FOR_PROCESSING',
              'totalQuantity': 10,
              'totalPrice': 300,
              'creationtime': DateTime.now().toString(),
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
            },
            'quoteOrder': {
              'order': {
                'code': '39492523423',
                'state': 'SELLER_SUBMITTED',
                'totalPrice': 54,
                'totalQuantity': 554,
                'creationtime': DateTime.now().toString(),
                'expectedDeliveryDate': DateTime.now().toString(),
                'requirementOrderCode': '4513516134451',
              },
              'product': {
                'name': '山本风少女长裙复古气质秋冬流行新款',
                'skuID': 'NA89852631',
                'thumbnail':
                'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
              },
            }
          }),
          SupplierModel.fromJson({
            'factory': {
              'profilePicture':
              'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
              'uid': 'BB123456',
              'name': '草帽工厂',
              'starLevel': 5,
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
                  'code': '1002',
                  'name': '毛衣',
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
            },
            'orderCount': 50,
            'quoteCount': 30,
            'purchaseOrder': {
              'code': 'PO34938475200045',
              'status': 'WAIT_FOR_PROCESSING',
              'totalQuantity': 10,
              'totalPrice': 300,
              'creationtime': DateTime.now().toString(),
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
            },
            'quoteOrder': {
              'order': {
                'code': '39492523423',
                'state': 'SELLER_SUBMITTED',
                'totalPrice': 54,
                'totalQuantity': 554,
                'creationtime': DateTime.now().toString(),
                'expectedDeliveryDate': DateTime.now().toString(),
                'requirementOrderCode': '4513516134451',
              },
              'product': {
                'name': '山本风少女长裙复古气质秋冬流行新款',
                'skuID': 'NA89852631',
                'thumbnail':
                'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
              },
            }
          }),
          SupplierModel.fromJson({
            'factory': {
              'profilePicture':
              'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
              'uid': 'BB123456',
              'name': '草帽工厂',
              'starLevel': 5,
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
            },
            'orderCount': 50,
            'quoteCount': 30,
            'purchaseOrder': {
              'code': 'PO34938475200045',
              'status': 'WAIT_FOR_PROCESSING',
              'totalQuantity': 10,
              'totalPrice': 300,
              'creationtime': DateTime.now().toString(),
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
            },
            'quoteOrder': {
              'order': {
                'code': '39492523423',
                'state': 'SELLER_SUBMITTED',
                'totalPrice': 54,
                'totalQuantity': 554,
                'creationtime': DateTime.now().toString(),
                'expectedDeliveryDate': DateTime.now().toString(),
                'requirementOrderCode': '4513516134451',
              },
              'product': {
                'name': '山本风少女长裙复古气质秋冬流行新款',
                'skuID': 'NA89852631',
                'thumbnail':
                'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
              },
            }
          }),
        ];
      }));
    }
    _controller.sink.add(this._list);
  }

  loadingMore() async {
    //模拟数据到底
    if (_list.length < 4) {
      _list.add(await Future.delayed(const Duration(seconds: 1), () {
        return SupplierModel.fromJson({
          'factory': {
            'profilePicture':
                'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
            'uid': 'BB123456',
            'name': '草帽工厂',
            'starLevel': 5,
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
          },
          'orderCount': 50,
          'quoteCount':30,
          'purchaseOrder': {
            'code': 'PO34938475200045',
            'status': 'WAIT_FOR_PROCESSING',
            'totalQuantity': 10,
            'totalPrice': 300,
            'creationtime': DateTime.now().toString(),
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
          },
          'quoteOrder': {
            'order': {
              'code': '39492523423',
              'state': 'SELLER_SUBMITTED',
              'totalPrice': 54,
              'totalQuantity': 554,
              'creationtime': DateTime.now().toString(),
              'expectedDeliveryDate': DateTime.now().toString(),
              'requirementOrderCode': '4513516134451',
            },
            'product': {
              'name': '山本风少女长裙复古气质秋冬流行新款',
              'skuID': 'NA89852631',
              'thumbnail':
                  'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
            },
          }
        });
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
