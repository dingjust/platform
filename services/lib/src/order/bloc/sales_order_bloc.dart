import 'dart:async';

import 'package:models/models.dart';

class SalesOrderBLoC {
  Map<String, List<SalesOrderModel>> _ordersMap;

  SalesOrderBLoC() {
    _ordersMap = {
      "ALL": [],
      "PENDING_PAYMENT": [],
      "PENDING_DELIVERY": [],
      "SHIPPED": [],
      "COMPLETED": []
    };
  }

  List<SalesOrderModel> orders(String status) => _ordersMap[status];

  var _controller = StreamController<List<SalesOrderModel>>.broadcast();

  Stream<List<SalesOrderModel>> get stream => _controller.stream;

  var _loadingController = StreamController<bool>.broadcast();

  Stream<bool> get loadingStream => _loadingController.stream;

  var _bottomController = StreamController<bool>.broadcast();

  Stream<bool> get bottomStream => _bottomController.stream;

  filterByStatuses(String status) async {
    Set<String> statusesSet;
    // if (status== 'ALL') {
    //   bloc.filterByStatuses(statuses.map((status) {
    //     return status.code;
    //   }).toSet());
    // } else {
    //   Set.of([status.code]));
    // }

    //若没有数据则查询
    if (_ordersMap[status].length == 0) {
      // TODO: 分页拿数据，response.data;
      _ordersMap[status]
          .addAll(await Future.delayed(const Duration(seconds: 1), () {
        return <SalesOrderModel>[
          SalesOrderModel.fromJson({
            "code": "34938475200045",
            "status": "PENDING_PAYMENT",
            "totalQuantity": 10,
            "totalPrice": 300,
            "creationtime": DateTime.now().toString(),
            "entries": [
              {
                "product": {
                  "thumbnail":
                      "https://img.alicdn.com/imgextra/i3/1860270913/O1CN011IcC4vOIEr9xdXw_!!0-item_pic.jpg_430x430q90.jpg",
                  "code": "NA89852509",
                  "name": "山本风法少女长裙复古气质秋冬款",
                  "skuID": "NA89852509",
                },
              },
              {
                "product": {
                  "thumbnail":
                      "https://img.alicdn.com/imgextra/i3/1860270913/O1CN011IcC4vOIEr9xdXw_!!0-item_pic.jpg_430x430q90.jpg",
                  "code": "NA89852509",
                  "name": "山本风法少女长裙复古气质秋冬款",
                  "skuID": "NA89852509",
                },
              }
            ],
          }),
          SalesOrderModel.fromJson({
            "code": "34938475200045",
            "status": "PENDING_PAYMENT",
            "totalQuantity": 10,
            "totalPrice": 300,
            "creationtime": DateTime.now().toString(),
            "entries": [
              {
                "product": {
                  "thumbnail":
                      "https://img.alicdn.com/imgextra/i3/1860270913/O1CN011IcC4vOIEr9xdXw_!!0-item_pic.jpg_430x430q90.jpg",
                  "code": "NA89852509",
                  "name": "山本风法少女长裙复古气质秋冬款2",
                  "skuID": "NA89852509",
                },
              }
            ],
          }),
          SalesOrderModel.fromJson({
            "code": "34938475200045",
            "status": "PENDING_PAYMENT",
            "totalQuantity": 10,
            "totalPrice": 300,
            "creationtime": DateTime.now().toString(),
            "entries": [
              {
                "product": {
                  "thumbnail":
                      "https://img.alicdn.com/imgextra/i3/1860270913/O1CN011IcC4vOIEr9xdXw_!!0-item_pic.jpg_430x430q90.jpg",
                  "code": "NA89852509",
                  "name": "山本风法少女长裙复古气质秋冬款",
                  "skuID": "NA89852509",
                },
              },
              {
                "product": {
                  "thumbnail":
                      "https://img.alicdn.com/imgextra/i3/1860270913/O1CN011IcC4vOIEr9xdXw_!!0-item_pic.jpg_430x430q90.jpg",
                  "code": "NA89852509",
                  "name": "山本风法少女长裙复古气质秋冬款",
                  "skuID": "NA89852509",
                },
              }
            ],
          }),
          SalesOrderModel.fromJson({
            "code": "34938475200045",
            "status": "PENDING_PAYMENT",
            "totalQuantity": 10,
            "totalPrice": 300,
            "creationtime": DateTime.now().toString(),
            "entries": [
              {
                "product": {
                  "thumbnail":
                      "https://img.alicdn.com/imgextra/i3/1860270913/O1CN011IcC4vOIEr9xdXw_!!0-item_pic.jpg_430x430q90.jpg",
                  "code": "NA89852509",
                  "name": "山本风法少女长裙复古气质秋冬款2",
                  "skuID": "NA89852509",
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
      _ordersMap[status]
          .add(await Future.delayed(const Duration(seconds: 1), () {
        return SalesOrderModel.fromJson({
          "code": "34938475200045",
          "status": "PENDING_PAYMENT",
          "totalQuantity": 10,
          "totalPrice": 300,
          "creationtime": DateTime.now().toString(),
          "entries": [
            {
              "product": {
                "thumbnail":
                    "https://img.alicdn.com/imgextra/i3/1860270913/O1CN011IcC4vOIEr9xdXw_!!0-item_pic.jpg_430x430q90.jpg",
                "code": "NA89852509",
                "name": "山本风法少女长裙复古气质秋冬款",
                "skuID": "NA89852509",
              },
            },
            {
              "product": {
                "thumbnail":
                    "https://img.alicdn.com/imgextra/i3/1860270913/O1CN011IcC4vOIEr9xdXw_!!0-item_pic.jpg_430x430q90.jpg",
                "code": "NA89852509",
                "name": "山本风法少女长裙复古气质秋冬款",
                "skuID": "NA89852509",
              },
            }
          ],
        });
      }));
    }else{
      //通知显示已经到底部
      _bottomController.sink.add(true);
    }
    _loadingController.sink.add(false);
    _controller.sink.add(this._ordersMap[status]);
  }

  loadingStart() async {
    _loadingController.sink.add(true);
  }

  loadingEnd() async {
    _loadingController.sink.add(false);
  }

  dispose() {
    _controller.close();
  }
}
