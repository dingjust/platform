import 'dart:async';
import 'package:models/models.dart';

class SuppliersBloc{

  SuppliersBloc();
  List<SupplierModel> _list = new List();

  var _controller = StreamController<List<SupplierModel>>.broadcast();

  Stream<List<SupplierModel>> get stream => _controller.stream;

  filter() async {
    if(_list.isEmpty) {
      //若没有数据则查询
      _list.addAll(await Future.delayed(const Duration(seconds: 1), () {
        return <SupplierModel>[
          SupplierModel.fromJson({
            'code': 'S100001',
            'name': '广州迷你裙制衣厂',
            'orderCount': 50,
            'address': {
              'fullname': "张三",
              'cellphone': '13123456789',
              'region': {'isocode': 'R123', 'name': '广东省'},
              'city': {'code': 'C123', 'name': '广州市'},
              'cityDistrict': {'code': 'D123', 'name': '海珠区'},
              'line1': '广州大道',
              'defaultAddress': true
            },
          }),
          SupplierModel.fromJson({
            'code': 'S100002',
            'name': '广州超短裙制衣厂',
            'orderCount': 60,
            'address': {
              'fullname': "张三",
              'cellphone': '13123456789',
              'region': {'isocode': 'R123', 'name': '广东省'},
              'city': {'code': 'C123', 'name': '广州市'},
              'cityDistrict': {'code': 'D123', 'name': '海珠区'},
              'line1': '广州大道',
              'defaultAddress': true
            }
          }),
          SupplierModel.fromJson({
            'code': 'S100003',
            'name': '广州卫衣制衣厂',
            'orderCount': 60,
            'address': {
              'fullname': "张三",
              'cellphone': '13123456789',
              'region': {'isocode': 'R123', 'name': '广东省'},
              'city': {'code': 'C123', 'name': '广州市'},
              'cityDistrict': {'code': 'D123', 'name': '海珠区'},
              'line1': '广州大道',
              'defaultAddress': true
            }
          }),
          SupplierModel.fromJson({
            'code': 'S100004',
            'name': '广州毛衣制衣厂',
            'orderCount': 60,
            'address': {
              'fullname': "张三",
              'cellphone': '13123456789',
              'region': {'isocode': 'R123', 'name': '广东省'},
              'city': {'code': 'C123', 'name': '广州市'},
              'cityDistrict': {'code': 'D123', 'name': '海珠区'},
              'line1': '广州大道',
              'defaultAddress': true
            }
          }),
          SupplierModel.fromJson({
            'code': 'S100005',
            'name': '广州羽绒制衣厂',
            'orderCount': 60,
            'address': {
              'fullname': "张三",
              'cellphone': '13123456789',
              'region': {'isocode': 'R123', 'name': '广东省'},
              'city': {'code': 'C123', 'name': '广州市'},
              'cityDistrict': {'code': 'D123', 'name': '海珠区'},
              'line1': '广州大道',
              'defaultAddress': true
            }
          }),
          SupplierModel.fromJson({
            'code': 'S100005',
            'name': '广州羽绒制衣厂',
            'orderCount': 60,
            'address': {
              'fullname': "张三",
              'cellphone': '13123456789',
              'region': {'isocode': 'R123', 'name': '广东省'},
              'city': {'code': 'C123', 'name': '广州市'},
              'cityDistrict': {'code': 'D123', 'name': '海珠区'},
              'line1': '广州大道',
              'defaultAddress': true
            }
          }),
          SupplierModel.fromJson({
            'code': 'S100005',
            'name': '广州羽绒制衣厂',
            'orderCount': 60,
            'address': {
              'fullname': "张三",
              'cellphone': '13123456789',
              'region': {'isocode': 'R123', 'name': '广东省'},
              'city': {'code': 'C123', 'name': '广州市'},
              'cityDistrict': {'code': 'D123', 'name': '海珠区'},
              'line1': '广州大道',
              'defaultAddress': true
            }
          }),
          SupplierModel.fromJson({
            'code': 'S100005',
            'name': '广州羽绒制衣厂',
            'orderCount': 60,
            'address': {
              'fullname': "张三",
              'cellphone': '13123456789',
              'region': {'isocode': 'R123', 'name': '广东省'},
              'city': {'code': 'C123', 'name': '广州市'},
              'cityDistrict': {'code': 'D123', 'name': '海珠区'},
              'line1': '广州大道',
              'defaultAddress': true
            }
          }),
          SupplierModel.fromJson({
            'code': 'S100005',
            'name': '广州羽绒制衣厂',
            'orderCount': 60,
            'address': {
              'fullname': "张三",
              'cellphone': '13123456789',
              'region': {'isocode': 'R123', 'name': '广东省'},
              'city': {'code': 'C123', 'name': '广州市'},
              'cityDistrict': {'code': 'D123', 'name': '海珠区'},
              'line1': '广州大道',
              'defaultAddress': true
            }
          }),
          SupplierModel.fromJson({
            'code': 'S100001',
            'name': '广州迷你裙制衣厂',
            'orderCount': 50,
            'address': {
              'fullname': "张三",
              'cellphone': '13123456789',
              'region': {'isocode': 'R123', 'name': '广东省'},
              'city': {'code': 'C123', 'name': '广州市'},
              'cityDistrict': {'code': 'D123', 'name': '海珠区'},
              'line1': '广州大道',
              'defaultAddress': true
            },
          }),
          SupplierModel.fromJson({
            'code': 'S100002',
            'name': '广州超短裙制衣厂',
            'orderCount': 60,
            'address': {
              'fullname': "张三",
              'cellphone': '13123456789',
              'region': {'isocode': 'R123', 'name': '广东省'},
              'city': {'code': 'C123', 'name': '广州市'},
              'cityDistrict': {'code': 'D123', 'name': '海珠区'},
              'line1': '广州大道',
              'defaultAddress': true
            }
          }),
          SupplierModel.fromJson({
            'code': 'S100003',
            'name': '广州卫衣制衣厂',
            'orderCount': 60,
            'address': {
              'fullname': "张三",
              'cellphone': '13123456789',
              'region': {'isocode': 'R123', 'name': '广东省'},
              'city': {'code': 'C123', 'name': '广州市'},
              'cityDistrict': {'code': 'D123', 'name': '海珠区'},
              'line1': '广州大道',
              'defaultAddress': true
            }
          }),
        ];
      }));
    }
    _controller.sink.add(this._list);
  }

  loadingMore() async {
    //模拟数据到底
    if (_list.length < 7) {
      _list.add(
          await Future.delayed(const Duration(seconds: 1), () {
            return SupplierModel.fromJson({
              'code': 'S100001',
              'name': '广州迷你裙制衣厂',
              'orderCount': 50,
              'address': {
                'fullname': "张三",
                'cellphone': '13123456789',
                'region': {'isocode': 'R123', 'name': '广东省'},
                'city': {'code': 'C123', 'name': '广州市'},
                'cityDistrict': {'code': 'D123', 'name': '海珠区'},
                'line1': '广州大道',
                'defaultAddress': true
              },
            });
          })
      );
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