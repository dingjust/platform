import 'dart:async';

import 'package:models/models.dart';

class SalesOrderBLoC {
  List<SalesOrderModel> _orders = [];

  List<SalesOrderModel> get orders => _orders;

  var _controller = StreamController<List<SalesOrderModel>>.broadcast();

  Stream<List<SalesOrderModel>> get stream => _controller.stream;

  filterByStatuses(Set<String> statuses) async {
    print('filter by statuses');
    // // TODO: call service
    // Response response = await http$.post('', data: statuses);

    //if (response.statusCode == 200) {

    // TODO: 分页拿数据，response.data;
    List<SalesOrderModel> orders = await Future.delayed(const Duration(seconds: 3), () {
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
        })
      ];
    });

    _controller.sink.add(orders);
    //}
  }

  dispose() {
    _controller.close();
  }
}
