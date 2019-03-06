import 'dart:async';

import 'package:models/models.dart';
import 'package:services/services.dart';

class QuoteOrdersBLoC extends BLoCBase {
  // 工厂模式
  factory QuoteOrdersBLoC() => _getInstance();

  static QuoteOrdersBLoC get instance => _getInstance();
  static QuoteOrdersBLoC _instance;

  QuoteOrdersBLoC._internal() {
    // 初始化
  }

  static QuoteOrdersBLoC _getInstance() {
    if (_instance == null) {
      _instance = new QuoteOrdersBLoC._internal();
    }
    return _instance;
  }

  static final Map<String, List<QuoteEntryModel>> _quotesMap = {
    'ALL': List<QuoteEntryModel>(),
    'SELLER_SUBMITTED': List<QuoteEntryModel>(),
    'BUYER_APPROVED': List<QuoteEntryModel>(),
    'BUYER_REJECTED': List<QuoteEntryModel>()
  };

  List<QuoteEntryModel> quotes(String status) => _quotesMap[status];

  var _controller = StreamController<List<QuoteEntryModel>>.broadcast();

  Stream<List<QuoteEntryModel>> get stream => _controller.stream;

  filterByStatuses(String status) async {
    //若没有数据则查询
    if (_quotesMap[status].isEmpty) {
      // TODO: 分页拿数据，response.data;
      _quotesMap[status]
          .addAll(await Future.delayed(const Duration(seconds: 1), () {
        return <QuoteEntryModel>[
          QuoteEntryModel(
            order: QuoteModel(
              code: '39492523423',
              state: QuoteState.SELLER_SUBMITTED,
              totalPrice: 54,
              totalQuantity: 554,
              unitPriceOfFabric: 15.00,
              unitPriceOfExcipients: 5.00,
              unitPriceOfProcessing: 15.00,
              costOfSamples: 200.00,
              costOfOther: 100.00,
              belongTo: FactoryModel(
                name: '广州旭日',
                starLevel: 3,
                contactAddress: AddressModel(
                    region: RegionModel(name: '广东省'),
                    city: CityModel(code: '', name: '广州市'),
                    cityDistrict: DistrictModel(code: '', name: '海珠区'),
                    cellphone: '',
                    fullname: '',
                    line1: ''),
                orderedSuccessRate: 0.3455,
                historyOrdersCount: 214,
              ),
              attachments: [
                MediaModel(url:
                    'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                    mediaType: 'jpg'),
                MediaModel(url:
                    'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                    mediaType: 'jpg'),
                MediaModel(url:
                    'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                    mediaType: 'jpg'),
                MediaModel(url:
                    'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                    mediaType: 'jpg')
              ],
              creationTime: DateTime.parse('2019-01-03 12:00'),
              expectedDeliveryDate: DateTime.parse('2019-01-24'),
              requirementOrderCode: '4513516134451',
            ),
            product: ApparelProductModel(
              name: '山本风少女长裙复古气质秋冬流行新款',
              skuID: 'NA89852631',
              thumbnail:
                  'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
              majorCategory: CategoryModel(name: '针织'),
              minorCategory: CategoryModel(name: '女装-T恤'),
            ),
          ),
          QuoteEntryModel(
            order: QuoteModel(
              code: '39492523423',
              state: QuoteState.BUYER_REJECTED,
              totalPrice: 54,
              totalQuantity: 554,
              unitPriceOfFabric: 15.00,
              unitPriceOfExcipients: 5.00,
              unitPriceOfProcessing: 15.00,
              costOfSamples: 200.00,
              costOfOther: 100.00,
              belongTo: FactoryModel(
                name: '广州旭日',
                starLevel: 3,
                contactAddress: AddressModel(
                    region: RegionModel(name: '广东省'),
                    city: CityModel(code: '', name: '广州市'),
                    cityDistrict: DistrictModel(code: '', name: '海珠区'),
                    cellphone: '',
                    fullname: '',
                    line1: ''),
                orderedSuccessRate: 0.3455,
                historyOrdersCount: 214,
              ),
              attachments: [
                MediaModel(
                    url: 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                    mediaType: 'jpg'),
                MediaModel(
                    url: 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                    mediaType: 'jpg'),
                MediaModel(
                    url: 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                    mediaType: 'jpg'),
                MediaModel(
                    url: 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                    mediaType: 'jpg')
              ],
              creationTime: DateTime.parse('2019-01-03 12:00'),
              expectedDeliveryDate: DateTime.parse('2019-01-24'),
              requirementOrderCode: '4513516134451',
            ),
            product: ApparelProductModel(
              // name: '山本风少女长裙复古气质秋冬流行新款',
              // skuID: 'NA89852631',
              // thumbnail:
              //     'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
              majorCategory: CategoryModel(name: '针织'),
              minorCategory: CategoryModel(name: '女装-T恤'),
            ),
          ),
          QuoteEntryModel(
            order: QuoteModel(
              code: '39492523423',
              state: QuoteState.BUYER_APPROVED,
              totalPrice: 54,
              totalQuantity: 554,
              unitPriceOfFabric: 15.00,
              unitPriceOfExcipients: 5.00,
              unitPriceOfProcessing: 15.00,
              costOfSamples: 200.00,
              costOfOther: 100.00,
              belongTo: FactoryModel(
                name: '广州旭日',
                starLevel: 3,
                contactAddress: AddressModel(
                    region: RegionModel(name: '广东省'),
                    city: CityModel(code: '', name: '广州市'),
                    cityDistrict: DistrictModel(code: '', name: '海珠区'),
                    cellphone: '',
                    fullname: '',
                    line1: ''),
                orderedSuccessRate: 0.3455,
                historyOrdersCount: 214,
              ),
              attachments: [
                MediaModel(
                    url: 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                    mediaType: 'jpg'),
                MediaModel(
                    url: 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                    mediaType: 'jpg'),
                MediaModel(
                    url: 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                    mediaType: 'jpg'),
                MediaModel(
                    url: 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                    mediaType: 'jpg')
              ],
              creationTime: DateTime.parse('2019-01-03 12:00'),
              expectedDeliveryDate: DateTime.parse('2019-01-24'),
              requirementOrderCode: '4513516134451',
            ),
            product: ApparelProductModel(
              name: '山本风少女长裙复古气质秋冬流行新款',
              skuID: 'NA89852631',
              thumbnail:
                  'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
              majorCategory: CategoryModel(name: '针织'),
              minorCategory: CategoryModel(name: '女装-T恤'),
            ),
          ),
          QuoteEntryModel(
            order: QuoteModel(
              code: '39492523423',
              state: QuoteState.SELLER_SUBMITTED,
              totalPrice: 54,
              totalQuantity: 554,
              unitPriceOfFabric: 15.00,
              unitPriceOfExcipients: 5.00,
              unitPriceOfProcessing: 15.00,
              costOfSamples: 200.00,
              costOfOther: 100.00,
              belongTo: FactoryModel(
                name: '广州旭日',
                starLevel: 3,
                contactAddress: AddressModel(
                    region: RegionModel(name: '广东省'),
                    city: CityModel(code: '', name: '广州市'),
                    cityDistrict: DistrictModel(code: '', name: '海珠区'),
                    cellphone: '',
                    fullname: '',
                    line1: ''),
                orderedSuccessRate: 0.3455,
                historyOrdersCount: 214,
              ),
              attachments: [
                MediaModel(
                    url: 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                    mediaType: 'jpg'),
                MediaModel(
                    url: 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                    mediaType: 'jpg'),
                MediaModel(
                    url: 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                    mediaType: 'jpg'),
                MediaModel(
                    url: 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                    mediaType: 'jpg')
              ],
              creationTime: DateTime.parse('2019-01-03 12:00'),
              expectedDeliveryDate: DateTime.parse('2019-01-24'),
              requirementOrderCode: '4513516134451',
            ),
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
    if (_quotesMap[status].length < 6) {
      _quotesMap[status]
          .add(await Future.delayed(const Duration(seconds: 1), () {
        return QuoteEntryModel(
          order: QuoteModel(
            code: '39492523423',
            state: QuoteState.SELLER_SUBMITTED,
            totalPrice: 54,
            totalQuantity: 554,
            unitPriceOfFabric: 15.00,
            unitPriceOfExcipients: 5.00,
            unitPriceOfProcessing: 15.00,
            costOfSamples: 200.00,
            costOfOther: 100.00,
            belongTo: FactoryModel(
              name: '广州旭日',
              starLevel: 3,
              contactAddress: AddressModel(
                  region: RegionModel(name: '广东省'),
                  city: CityModel(code: '', name: '广州市'),
                  cityDistrict: DistrictModel(code: '', name: '海珠区'),
                  cellphone: '',
                  fullname: '',
                  line1: ''),
              orderedSuccessRate: 0.3455,
              historyOrdersCount: 214,
            ),
            attachments: [
              MediaModel(
                  url: 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                  mediaType: 'jpg'),
              MediaModel(
                  url: 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                  mediaType: 'jpg'),
              MediaModel(
                  url: 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                  mediaType: 'jpg'),
              MediaModel(
                  url: 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                  mediaType: 'jpg')
            ],
            creationTime: DateTime.parse('2019-01-03'),
            expectedDeliveryDate: DateTime.parse('2019-01-24'),
            requirementOrderCode: '4513516134451',
          ),
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
      return QuoteEntryModel(
        order: QuoteModel(
          code: '39492523423',
          state: QuoteState.SELLER_SUBMITTED,
          totalPrice: 54,
          totalQuantity: 554,
          unitPriceOfFabric: 15.00,
          unitPriceOfExcipients: 5.00,
          unitPriceOfProcessing: 15.00,
          costOfSamples: 200.00,
          costOfOther: 100.00,
          belongTo: FactoryModel(
            name: '广州旭日',
            starLevel: 3,
            contactAddress: AddressModel(
                region: RegionModel(name: '广东省'),
                city: CityModel(code: '', name: '广州市'),
                cityDistrict: DistrictModel(code: '', name: '海珠区'),
                cellphone: '',
                fullname: '',
                line1: ''),
            orderedSuccessRate: 0.3455,
            historyOrdersCount: 214,
          ),
          attachments: [
            MediaModel(
                url: 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                mediaType: 'jpg'),
            MediaModel(
                url: 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                mediaType: 'jpg'),
            MediaModel(
                url: 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                mediaType: 'jpg'),
            MediaModel(
                url: 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                mediaType: 'jpg')
          ],
          creationTime: DateTime.parse('2019-01-03'),
          expectedDeliveryDate: DateTime.parse('2019-01-24'),
          requirementOrderCode: '4513516134451',
        ),
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
    _loadingController.close();
    _bottomController.close();
    _toTopBtnController.close();
    _returnToTopController.close();
  }
}
