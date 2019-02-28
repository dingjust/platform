import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

List<FactoryModel> factoryList = [
  FactoryModel.fromJson({
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
    ],
    'locationX' : 23.1078388750,
    'locationY' : 113.3064651489,
  }),
  FactoryModel.fromJson({
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
    ],
    'locationX' : 23.1037337084,
    'locationY' : 113.2886123657,
  }),
  FactoryModel.fromJson({
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
    ],
    'locationX' : 23.1091019780,
    'locationY' : 113.2841491699,
  }),
  FactoryModel.fromJson({
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
    ],
    'locationX' : 23.1037337094,
    'locationY' : 113.2886123677,
  }),
];

double locationX = 23.0942597682;
double locationY = 113.2995986938;


class FindFactoryByMap extends StatefulWidget {
  _FindFactoryByMapState createState() => _FindFactoryByMapState();
}

class _FindFactoryByMapState extends State<FindFactoryByMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('地图找厂'),
          actions: <Widget>[
          ],
        ),
        body:Container(
          child: FlutterAMap(locationX: locationX, locationY: locationY, factoryList: factoryList),
        )
    );
  }
//
//  Widget _buildMapView(BuildContext context){
//    return Container()
//  }

}