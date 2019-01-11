import 'package:b2b_commerce/src/business/orders/purchase_detail.dart';
import 'package:b2b_commerce/src/business/search/purchase_order_search.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

const statuses = <EnumModel>[
  EnumModel('ALL', '全部'),
  EnumModel('WAIT_FOR_PROCESSING', '待处理'),
  EnumModel('PENDING_APPROVAL', '待确认'),
  EnumModel('IN_PRODUCTION', '生产中'),
  EnumModel('OUT_OF_STORE', '已出库'),
  EnumModel('COMPLETED', '已完成'),
];

final List<PurchaseOrderModel> orders = <PurchaseOrderModel>[
  PurchaseOrderModel.fromJson({
    'code': 'PO34938475200045',
    'status': 'WAIT_FOR_PROCESSING',
    'totalQuantity': 10,
    'totalPrice': 300,
    'creationtime' : DateTime.now().toString(),
    'expectedDeliveryDate':DateTime.now().toString(),
    'currentPhase':'SAMPLE_CONFIRM',
    'machiningType':'包工包料',
    'invoiceNeeded':true,
    'attachments':['附件1','附件2','附件3'],
    'remarks':'延期了12天',
    'belongTo': {
      'name':'京东工厂'
    },
    'productionProgresses':[
      {
        'phase': 'MATERIAL_PREPARATION',
        'quantity': 70,
        'sequence': 0,
        'estimatedDate': DateTime.now().toString(),
        'finishDate': DateTime.now().toString(),
        'remarks':'延期了12天',
        'medias': [
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg"
        ],
      },
      {
        'phase': 'SAMPLE_CONFIRM',
        'quantity': 70,
        'sequence': 1,
        'estimatedDate': DateTime.now().toString(),
        'finishDate': DateTime.now().toString(),
        'remarks':'延期了12天',
        'medias': [
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg"
        ],
      },
      {
        'phase': 'CUTTING',
        'quantity': 70,
        'sequence': 2,
        'estimatedDate': DateTime.now().toString(),
        'finishDate': DateTime.now().toString(),
        'remarks':'延期了12天',
        'medias': [
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg"
        ],
      },
      {
        'phase': 'STITCHING',
        'quantity': 70,
        'sequence': 3,
        'estimatedDate': DateTime.now().toString(),
        'finishDate': DateTime.now().toString(),
        'remarks':'延期了12天',
        'medias': [
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg"
        ],
      },
      {
        'phase': 'INSPECTION',
        'quantity': 70,
        'sequence': 4,
        'estimatedDate': DateTime.now().toString(),
        'finishDate': DateTime.now().toString(),
        'remarks':'延期了12天',
        'medias': [
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg"
        ],
      },
      {
        'phase': 'DELIVERY',
        'quantity': 70,
        'sequence': 5,
        'estimatedDate': DateTime.now().toString(),
        'finishDate': DateTime.now().toString(),
        'remarks':'延期了12天',
        'medias': [
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg"
        ],
      },
    ],
    'deliveryAddress': {
      'fullname': "张三",
      'cellphone': '13123456789',
      'region': {
        'isocode': 'R123',
        'name': '广东省'
      },
      'city': {
        'code': 'C123',
        'name': '广州市'
      },
      'cityDistrict': {
        'code': 'D123',
        'name': '海珠区'
      },
      'line1': '广州大道',
      'defaultAddress': true
    },
    'entries': [
      {
        'basePrice':33.0,
        'quantity':23,
        'totalPrice':999.9,
        'requirementOrderCode' :'RC34938475200045',
        'product': {
          'code': 'NA89852509',
          'name': '山本风法少女长裙复古气质秋冬款',
          'skuID': 'NA89852509',
          'thumbnail':'http://dingyue.nosdn.127.net/ZsKn=CkHLVpuKgUT6wW5uRECVu0=RSGVwrKTeNjszUCdk1538637061484compressflag.jpg'
        },
      },
      {
        'basePrice':33.0,
        'quantity':23,
        'totalPrice':999.9,
        'requirementOrderCode' :'RC34938475200045',
        'product': {
          'code': 'NA89852509',
          'name': '山本风法少女长裙复古气质秋冬款',
          'skuID': 'NA89852509',
          'thumbnail':'http://dingyue.nosdn.127.net/ZsKn=CkHLVpuKgUT6wW5uRECVu0=RSGVwrKTeNjszUCdk1538637061484compressflag.jpg'
        },
      }
    ],
  }),
  PurchaseOrderModel.fromJson({
    'code': 'PO34938475200045',
    'status': 'WAIT_FOR_PROCESSING',
    'totalQuantity': 10,
    'totalPrice': 300,
    'creationtime' : DateTime.now().toString(),
    'expectedDeliveryDate':DateTime.now().toString(),
    'currentPhase':'SAMPLE_CONFIRM',
    'machiningType':'包工包料',
    'invoiceNeeded':false,
    'attachments':['附件1','附件2'],
    'remarks':'延期了12天',
    'belongTo': {
      'name':'京东工厂'
    },
    'productionProgresses':[
      {
        'phase': 'MATERIAL_PREPARATION',
        'quantity': 70,
        'sequence': 0,
        'estimatedDate': DateTime.now().toString(),
        'finishDate': DateTime.now().toString(),
        'remarks':'延期了12天',
        'medias': [
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg"
        ],
      },
      {
        'phase': 'SAMPLE_CONFIRM',
        'quantity': 70,
        'sequence': 1,
        'estimatedDate': DateTime.now().toString(),
        'finishDate': DateTime.now().toString(),
        'remarks':'延期了12天',
        'medias': [
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg"
        ],
      },
      {
        'phase': 'CUTTING',
        'quantity': 70,
        'sequence': 2,
        'estimatedDate': DateTime.now().toString(),
        'finishDate': DateTime.now().toString(),
        'remarks':'延期了12天',
        'medias': [
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg"
        ],
      },
      {
        'phase': 'STITCHING',
        'quantity': 70,
        'sequence': 3,
        'estimatedDate': DateTime.now().toString(),
        'finishDate': DateTime.now().toString(),
        'remarks':'延期了12天',
        'medias': [
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg"
        ],
      },
      {
        'phase': 'INSPECTION',
        'quantity': 70,
        'sequence': 4,
        'estimatedDate': DateTime.now().toString(),
        'finishDate': DateTime.now().toString(),
        'remarks':'延期了12天',
        'medias': [
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg"
        ],
      },
      {
        'phase': 'DELIVERY',
        'quantity': 70,
        'sequence': 5,
        'estimatedDate': DateTime.now().toString(),
        'finishDate': DateTime.now().toString(),
        'remarks':'延期了12天',
        'medias': [
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg"
        ],
      },
    ],
    'deliveryAddress': {
      'fullname': "",
      'cellphone': '',
      'region': {
        'isocode': 'R123',
        'name': '广东省'
      },
      'city': {
        'code': 'C123',
        'name': '广州市'
      },
      'cityDistrict': {
        'code': 'D123',
        'name': '海珠区'
      },
      'line1': '广州大道',
      'defaultAddress': true
    },
    'entries': [
      {
        'basePrice':33.0,
        'quantity':23,
        'totalPrice':999.9,
        'requirementOrderCode' :'RC34938475200045',
        'product': {
          'code': 'NA89852509',
          'name': '山本风法少女长裙复古气质秋冬款2',
          'skuID': 'NA89852509',
          'thumbnail':'http://dingyue.nosdn.127.net/ZsKn=CkHLVpuKgUT6wW5uRECVu0=RSGVwrKTeNjszUCdk1538637061484compressflag.jpg'
        },
      }
    ],
  }),
  PurchaseOrderModel.fromJson({
    'code': 'PO34938475200045',
    'status': 'WAIT_FOR_PROCESSING',
    'totalQuantity': 10,
    'totalPrice': 300,
    'creationtime' : DateTime.now().toString(),
    'expectedDeliveryDate':DateTime.now().toString(),
    'currentPhase':'SAMPLE_CONFIRM',
    'machiningType':'包工包料',
    'invoiceNeeded':false,
    'attachments':['附件1','附件2'],
    'remarks':'延期了12天',
    'belongTo': {
      'name':'京东工厂'
    },
    'productionProgresses':[
      {
        'phase': 'MATERIAL_PREPARATION',
        'quantity': 70,
        'sequence': 0,
        'estimatedDate': DateTime.now().toString(),
        'finishDate': DateTime.now().toString(),
        'medias': [
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
        ],
        "remarks":"1234564564564"
      },
      {
        'phase': 'SAMPLE_CONFIRM',
        'quantity': 70,
        'sequence': 1,
        'estimatedDate': DateTime.now().toString(),
        'finishDate': DateTime.now().toString(),
        'medias': [
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg"
        ],
        "remarks":"1234564564564"
      },
      {
        'phase': 'CUTTING',
        'quantity': 70,
        'sequence': 2,
        'estimatedDate': DateTime.now().toString(),
        'finishDate': DateTime.now().toString(),
        'medias': [
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg"
        ],
        "remarks":"1234564564564"
      },
      {
        'phase': 'STITCHING',
        'quantity': 70,
        'sequence': 3,
        'estimatedDate': DateTime.now().toString(),
        'finishDate': DateTime.now().toString(),
        'medias': [
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg"
        ],
        "remarks":"1234564564564"
      },
      {
        'phase': 'INSPECTION',
        'quantity': 70,
        'sequence': 4,
        'estimatedDate': DateTime.now().toString(),
        'finishDate': DateTime.now().toString(),
        'medias': [
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg"
        ],
        "remarks":"1234564564564"
      },
      {
        'phase': 'DELIVERY',
        'quantity': 70,
        'sequence': 5,
        'estimatedDate': DateTime.now().toString(),
        'finishDate': DateTime.now().toString(),
        'medias': [
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg",
          "https://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/b7003af33a87e9502f2a82b910385343fbf2b421.jpg"
        ],
        "remarks":"1234564564564"
      },
    ],
    'deliveryAddress': {
      'fullname': "",
      'cellphone': '',
      'region': {
        'isocode': 'R123',
        'name': '广东省'
      },
      'city': {
        'code': 'C123',
        'name': '广州市'
      },
      'cityDistrict': {
        'code': 'D123',
        'name': '海珠区'
      },
      'line1': '广州大道',
      'defaultAddress': true
    },
    'entries': [
      {
        'basePrice':33.0,
        'quantity':23,
        'totalPrice':999.9,
        'requirementOrderCode' :'RC34938475200045',
        'product': {
          'code': 'NA89852509',
          'name': '山本风法少女长裙复古气质秋冬款2',
          'skuID': 'NA89852509',
          'thumbnail':'http://dingyue.nosdn.127.net/ZsKn=CkHLVpuKgUT6wW5uRECVu0=RSGVwrKTeNjszUCdk1538637061484compressflag.jpg'
        },
      }
    ],
  })
];

class PurchaseOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('采购订单'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => showSearch(context: context, delegate: PurchaseOrderSearchDelegate()),
          ),
        ],
      ),
      body: DefaultTabController(
        length: statuses.length,
        child: Scaffold(
          appBar: TabBar(
            unselectedLabelColor: Colors.black26,
            labelColor: Colors.black38,
            tabs: statuses.map((status) {
              return Tab(text: status.name);
            }).toList(),
            labelStyle: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
            isScrollable: true,
          ),
          body: TabBarView(
            children: <Widget>[
              PurchaseOrderList(statuses[0]),
              PurchaseOrderList(statuses[1]),
              PurchaseOrderList(statuses[2]),
              PurchaseOrderList(statuses[3]),
              PurchaseOrderList(statuses[4]),
              PurchaseOrderList(statuses[5]),
            ],
          ),
        ),
      ),
    );
  }
}

class PurchaseOrderList extends StatelessWidget{
  final EnumModel status;

  PurchaseOrderList(this.status);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: orders.map((order) {
        return PurchaseOrderItem(order);
      }).toList(),
    );
  }

}

class PurchaseOrderItem extends StatelessWidget {

  final PurchaseOrderModel order;

  PurchaseOrderItem(this.order);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        margin: EdgeInsets.all(6),
        child: Column(
          children: <Widget>[
            _buildOrderHeader(context),
            Column(
              children: _buildContent(context),
            ),
            _buildOrderBottom(context),
          ],
        ),
      ),
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PurchaseDetailPage(order: order),
          ),
        );
      },
    );
  }

  Widget _buildOrderHeader(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child:Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                      '采购订单号：' + order.code,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )
                ),
                Text(
                  PurchaseOrderStatusLocalizedMap[order.status],
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.green
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  '创建时间：' + order.creationTime.toString(),
                  style: TextStyle(
                      fontSize: 14
                  ),
                )
              ],
            )
          ],
        )
    );
  }

  List<Widget> _buildContent(BuildContext context){
    return order.entries.map((entry) {
      return Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Image.network(
                entry.product.thumbnail,
                width: 110,
                height: 110,
                fit: BoxFit.fill,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child:
                        Text(
                          entry.product.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:FontWeight.w500
                          ),
                        )
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child:
                        Text(
                          '货号：' + entry.product.skuID,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight:FontWeight.w500
                          ),
                        )
                      )
                    ],
                  )
                )
              )
            ],
          )
      );
    }).toList();
  }


  Widget _buildOrderBottom(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '共'+order.totalQuantity.toString()+'件商品   合计： ￥'+ order.totalPrice.toString(),
            style: TextStyle(
              fontSize: 16,
              color: Colors.red
            ),
          ),
        )
      ],
    );
  }

}

