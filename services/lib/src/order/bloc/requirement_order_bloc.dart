import 'dart:async';

import 'package:models/models.dart';
import 'package:services/services.dart';

class RequirementOrderBLoC extends BLoCBase {
  // 工厂模式
  factory RequirementOrderBLoC() => _getInstance();

  static RequirementOrderBLoC get instance => _getInstance();
  static RequirementOrderBLoC _instance;

  RequirementOrderBLoC._internal() {
    // 初始化
  }

  static RequirementOrderBLoC _getInstance() {
    if (_instance == null) {
      _instance = new RequirementOrderBLoC._internal();
    }
    return _instance;
  }

  static final Map<String, List<RequirementOrderModel>> _ordersMap = {
    'ALL': List<RequirementOrderModel>(),
    'PENDING_QUOTE': List<RequirementOrderModel>(),
    'COMPLETED': List<RequirementOrderModel>(),
    'CANCELLED': List<RequirementOrderModel>()
  };

  List<RequirementOrderModel> orders(String status) => _ordersMap[status];

  var _controller = StreamController<List<RequirementOrderModel>>.broadcast();

  Stream<List<RequirementOrderModel>> get stream => _controller.stream;

  filterByStatuses(String status) async {
    //若没有数据则查询
    if (_ordersMap[status].isEmpty) {
      // TODO: 分页拿数据，response.data;
      _ordersMap[status]
          .addAll(await Future.delayed(const Duration(seconds: 1), () {
        return <RequirementOrderModel>[
          RequirementOrderModel.fromJson({
            "code": "34938475200045",
            'totalQuotesCount': 120,
            'totalQuantity': 200,
            "status": "PENDING_QUOTE",
            'details': {
              "expectedMachiningQuantity": 10,
              "maxExpectedPrice": 300,
              "expectedDeliveryDate": DateTime.now().toString(),
              'productName': '山本风法少女长裙复古气质秋冬款',
              'productSkuID': 'NA89852509',
              'pictures': [
                {
                  'url':
                      'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                  'mediaType': 'webp'
                },
                {
                  'url':
                      'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                  'mediaType': 'webp'
                },
                {
                  'url':
                      'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                  'mediaType': 'webp'
                },
              ],
              'majorCategory': {'name': '针织'},
              'category': {'name': '男装-T恤'},
              'proofingNeeded': true,
              'samplesNeeded': true,
              'invoiceNeeded': true,
              'productiveOrientations': ['广东东莞'],
              'machiningType': 'LIGHT_PROCESSING'
            },
            "creationtime": DateTime.parse('2019-03-01').toString(),
            "remarks": "交货时间 2019-01-01\n确定前请先与我厂沟通好样衣事宜，谢谢",
            "attachments": [
              {
                'url':
                    'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                'mediaType': 'webp'
              },
              {
                'url':
                    'http://zb.guaihou.com/zdoc/03J012-2%20%E7%8E%AF%E5%A2%83%E6%99%AF%E8%A7%82--%E7%BB%BF%E5%8C%96%E7%A7%8D%E6%A4%8D%E8%AE%BE%E8%AE%A1.pdf',
                'mediaType': 'pdf'
              },
              {
                'url':
                    'http://www.gzedu.gov.cn/gzsjyj/zsks/201901/4cbfd27ec7cf47ecb8867bad65a57040/files/ed312aa5e162435f928614b9c79d8fab.docx',
                'mediaType': 'docx'
              },
              {
                'url':
                    'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                'mediaType': 'webp'
              },
              {
                'url':
                    'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                'mediaType': 'webp'
              },
              {
                'url':
                    'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                'mediaType': 'webp'
              },
            ]
          }),
          RequirementOrderModel.fromJson({
            "code": "34938475200045",
            'totalQuotesCount': 120,
            'totalQuantity': 200,
            "status": "COMPLETED",
            'details': {
              "expectedMachiningQuantity": 10,
              "maxExpectedPrice": 300,
              "expectedDeliveryDate": DateTime.now().toString(),
              'productName': '山本风法少女长裙复古气质秋冬款',
              'productSkuID': 'NA89852509',
              'pictures': [
                {
                  'url':
                      'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                  'mediaType': 'webp'
                },
                {
                  'url':
                      'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                  'mediaType': 'webp'
                },
                {
                  'url':
                      'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                  'mediaType': 'webp'
                },
              ],
              'majorCategory': {'name': '针织'},
              'category': {'name': '男装-T恤'},
              'proofingNeeded': true,
              'samplesNeeded': true,
              'invoiceNeeded': true,
              'productiveOrientations': ['广东东莞'],
              'machiningType': 'LABOR_AND_MATERIAL'
            },
            "creationtime": DateTime.parse('2019-03-01').toString(),
            "remarks": "交货时间 2019-01-01\n确定前请先与我厂沟通好样衣事宜，谢谢",
            "attachments": [
              {
                'url':
                    'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                'mediaType': 'webp'
              },
              {
                'url':
                    'http://zb.guaihou.com/zdoc/03J012-2%20%E7%8E%AF%E5%A2%83%E6%99%AF%E8%A7%82--%E7%BB%BF%E5%8C%96%E7%A7%8D%E6%A4%8D%E8%AE%BE%E8%AE%A1.pdf',
                'mediaType': 'pdf'
              },
              {
                'url':
                    'http://www.gzedu.gov.cn/gzsjyj/zsks/201901/4cbfd27ec7cf47ecb8867bad65a57040/files/ed312aa5e162435f928614b9c79d8fab.docx',
                'mediaType': 'docx'
              },
              {
                'url':
                    'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                'mediaType': 'webp'
              },
              {
                'url':
                    'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                'mediaType': 'webp'
              },
              {
                'url':
                    'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                'mediaType': 'webp'
              },
            ]
          }),
          RequirementOrderModel.fromJson({
            "code": "34938475200045",
            'totalQuotesCount': 120,
            'totalQuantity': 200,
            "status": "CANCELLED",
            'details': {
              "expectedMachiningQuantity": 10,
              "maxExpectedPrice": 300,
              "expectedDeliveryDate": DateTime.now().toString(),
              'productName': '山本风法少女长裙复古气质秋冬款',
              'majorCategory': {'name': '针织'},
              'category': {'name': '男装-T恤'},
              'proofingNeeded': true,
              'samplesNeeded': true,
              'invoiceNeeded': true,
              'productiveOrientations': ['广东东莞'],
              'machiningType': 'LABOR_AND_MATERIAL'
            },
            "creationtime": DateTime.parse('2019-03-01').toString(),
            "remarks": "交货时间 2019-01-01\n确定前请先与我厂沟通好样衣事宜，谢谢",
            "attachments": [
              {
                'url':
                    'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                'mediaType': 'webp'
              },
              {
                'url':
                    'http://zb.guaihou.com/zdoc/03J012-2%20%E7%8E%AF%E5%A2%83%E6%99%AF%E8%A7%82--%E7%BB%BF%E5%8C%96%E7%A7%8D%E6%A4%8D%E8%AE%BE%E8%AE%A1.pdf',
                'mediaType': 'pdf'
              },
              {
                'url':
                    'http://www.gzedu.gov.cn/gzsjyj/zsks/201901/4cbfd27ec7cf47ecb8867bad65a57040/files/ed312aa5e162435f928614b9c79d8fab.docx',
                'mediaType': 'docx'
              },
              {
                'url':
                    'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                'mediaType': 'webp'
              },
              {
                'url':
                    'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                'mediaType': 'webp'
              },
              {
                'url':
                    'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                'mediaType': 'webp'
              },
            ]
          }),
          RequirementOrderModel.fromJson({
            "code": "34938475200045",
            'totalQuotesCount': 120,
            'totalQuantity': 200,
            "status": "CANCELLED",
            'details': {
              "expectedMachiningQuantity": 10,
              "maxExpectedPrice": 300,
              "expectedDeliveryDate": DateTime.now().toString(),
              'productName': '山本风法少女长裙复古气质秋冬款',
              'productSkuID': 'NA89852509',
              'pictures': [
                {
                  'url':
                      'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                  'mediaType': 'webp'
                },
                {
                  'url':
                      'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                  'mediaType': 'webp'
                },
                {
                  'url':
                      'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                  'mediaType': 'webp'
                },
              ],
              'majorCategory': {'name': '针织'},
              'category': {'name': '男装-T恤'},
              'proofingNeeded': true,
              'samplesNeeded': true,
              'invoiceNeeded': true,
              'productiveOrientations': ['广东东莞'],
              'machiningType': 'LABOR_AND_MATERIAL'
            },
            "creationtime": DateTime.parse('2019-03-01').toString(),
            "remarks": "交货时间 2019-01-01\n确定前请先与我厂沟通好样衣事宜，谢谢",
            "attachments": [
              {
                'url':
                    'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                'mediaType': 'webp'
              },
              {
                'url':
                    'http://zb.guaihou.com/zdoc/03J012-2%20%E7%8E%AF%E5%A2%83%E6%99%AF%E8%A7%82--%E7%BB%BF%E5%8C%96%E7%A7%8D%E6%A4%8D%E8%AE%BE%E8%AE%A1.pdf',
                'mediaType': 'pdf'
              },
              {
                'url':
                    'http://www.gzedu.gov.cn/gzsjyj/zsks/201901/4cbfd27ec7cf47ecb8867bad65a57040/files/ed312aa5e162435f928614b9c79d8fab.docx',
                'mediaType': 'docx'
              },
              {
                'url':
                    'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                'mediaType': 'webp'
              },
              {
                'url':
                    'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                'mediaType': 'webp'
              },
              {
                'url':
                    'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                'mediaType': 'webp'
              },
            ]
          }),
        ];
      }));
    }
    _controller.sink.add(_ordersMap[status]);
  }

  loadingMoreByStatuses(String status) async {
    //模拟数据到底
    if (_ordersMap[status].length < 6) {
      _ordersMap[status]
          .add(await Future.delayed(const Duration(seconds: 1), () {
        return RequirementOrderModel.fromJson({
          "code": "34938475200045",
          'totalQuotesCount': 120,
          'totalQuantity': 200,
          "status": "PENDING_QUOTE",
          'details': {
            "expectedMachiningQuantity": 10,
            "maxExpectedPrice": 300,
            "expectedDeliveryDate": DateTime.now().toString(),
            'productName': '山本风法少女长裙复古气质秋冬款',
            'productSkuID': 'NA89852509',
            'pictures': [
              {
                'url':
                    'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                'mediaType': 'webp'
              },
              {
                'url':
                    'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                'mediaType': 'webp'
              },
              {
                'url':
                    'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                'mediaType': 'webp'
              },
            ],
            'majorCategory': {'name': '针织'},
            'category': {'name': '男装-T恤'},
            'proofingNeeded': true,
            'samplesNeeded': true,
            'invoiceNeeded': true,
            'productiveOrientations': ['广东东莞'],
            'machiningType': 'LABOR_AND_MATERIAL'
          },
          "creationtime": DateTime.parse('2019-03-01').toString(),
          "remarks": "交货时间 2019-01-01\n确定前请先与我厂沟通好样衣事宜，谢谢",
          "attachments": [
            {
              'url':
                  'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
              'mediaType': 'webp'
            },
            {
              'url':
                  'http://zb.guaihou.com/zdoc/03J012-2%20%E7%8E%AF%E5%A2%83%E6%99%AF%E8%A7%82--%E7%BB%BF%E5%8C%96%E7%A7%8D%E6%A4%8D%E8%AE%BE%E8%AE%A1.pdf',
              'mediaType': 'pdf'
            },
            {
              'url':
                  'http://www.gzedu.gov.cn/gzsjyj/zsks/201901/4cbfd27ec7cf47ecb8867bad65a57040/files/ed312aa5e162435f928614b9c79d8fab.docx',
              'mediaType': 'docx'
            },
            {
              'url':
                  'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
              'mediaType': 'webp'
            },
            {
              'url':
                  'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
              'mediaType': 'webp'
            },
            {
              'url':
                  'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
              'mediaType': 'webp'
            },
          ]
        });
      }));
    } else {
      //通知显示已经到底部
      _bottomController.sink.add(true);
    }
    _loadingController.sink.add(false);
    _controller.sink.add(_ordersMap[status]);
  }

  //下拉刷新
  Future refreshData(String status) async {
    _ordersMap[status].clear();
    _ordersMap[status].add(await Future.delayed(const Duration(seconds: 1), () {
      return RequirementOrderModel.fromJson({
        "code": "34938475200045",
        'totalQuotesCount': 120,
        'totalQuantity': 200,
        "status": "PENDING_QUOTE",
        'details': {
          "expectedMachiningQuantity": 10,
          "maxExpectedPrice": 300,
          "expectedDeliveryDate": DateTime.now().toString(),
          'productName': '山本风法少女长裙复古气质秋冬款',
          'productSkuID': 'NA89852509',
          'pictures': [
            {
              'url':
                  'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
              'mediaType': 'webp'
            },
            {
              'url':
                  'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
              'mediaType': 'webp'
            },
            {
              'url':
                  'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
              'mediaType': 'webp'
            },
          ],
          'majorCategory': {'name': '针织'},
          'category': {'name': '男装-T恤'},
          'proofingNeeded': true,
          'samplesNeeded': true,
          'invoiceNeeded': true,
          'productiveOrientations': ['广东东莞'],
          'machiningType': 'LABOR_AND_MATERIAL'
        },
        "creationtime": DateTime.parse('2019-03-01').toString(),
        "remarks": "交货时间 2019-01-01\n确定前请先与我厂沟通好样衣事宜，谢谢",
        "attachments": [
          {
            'url':
                'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
            'mediaType': 'webp'
          },
          {
            'url':
                'http://zb.guaihou.com/zdoc/03J012-2%20%E7%8E%AF%E5%A2%83%E6%99%AF%E8%A7%82--%E7%BB%BF%E5%8C%96%E7%A7%8D%E6%A4%8D%E8%AE%BE%E8%AE%A1.pdf',
            'mediaType': 'pdf'
          },
          {
            'url':
                'http://www.gzedu.gov.cn/gzsjyj/zsks/201901/4cbfd27ec7cf47ecb8867bad65a57040/files/ed312aa5e162435f928614b9c79d8fab.docx',
            'mediaType': 'docx'
          },
          {
            'url':
                'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
            'mediaType': 'webp'
          },
          {
            'url':
                'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
            'mediaType': 'webp'
          },
          {
            'url':
                'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
            'mediaType': 'webp'
          },
        ]
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
