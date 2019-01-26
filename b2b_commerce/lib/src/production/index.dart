import 'package:b2b_commerce/src/home/factory/factory.dart';
import 'package:b2b_commerce/src/home/home_section.dart';
import 'package:b2b_commerce/src/production/production.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class ProductionPage extends StatefulWidget {
  _ProductionPageState createState() => _ProductionPageState();
}

class _ProductionPageState extends State<ProductionPage> {
  List<PurchaseOrderModel> list = <PurchaseOrderModel>[
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
    }),
  ];

  //TODO:调用接口查询推荐工厂
  List<FactoryModel> factories = <FactoryModel>[
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: HomeSearchInputBox(),
        centerTitle: true,
        brightness: Brightness.dark,
        actions: <Widget>[
          IconButton(
            icon: const Icon(B2BIcons.message),
            color: Colors.orange,
            tooltip: 'message',
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          color: Colors.grey[200],
          child: ListView(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: RichText(
                      text: TextSpan(
                          text: '———',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                          children: <TextSpan>[
                            TextSpan(
                                text: '正在生产',
                                style: TextStyle(color: Colors.black)),
                            TextSpan(text: '———')
                          ]),
                    ),
                  )
                ],
              ),
              Column(
                children: list
                    .map((model) => ProductionItem(
                          order: model,
                        ))
                    .toList(),
              ),
              _buildRecommend()
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Text(
          '线下订单',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildRecommend() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: <Widget>[
          Container(
            width: 380,
            height: 150,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(
                      'http://dingjust.oss-cn-shenzhen.aliyuncs.com/%E5%BE%AE%E4%BF%A1%E5%9B%BE%E7%89%87_20190126151855.jpg'),
                  fit: BoxFit.cover,
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: RichText(
                  text: TextSpan(
                      text: '———',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                      children: <TextSpan>[
                        TextSpan(
                            text: '工厂推荐',
                            style: TextStyle(color: Colors.black)),
                        TextSpan(text: '———')
                      ]),
                ),
              )
            ],
          ),
          Column(
            children: factories
                .map((item) => FactoryItem(
                      model: item,
                    ))
                .toList(),
          )
        ],
      ),
    );
  }
}
