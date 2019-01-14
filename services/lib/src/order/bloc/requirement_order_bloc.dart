import 'dart:async';
import 'package:models/models.dart';

class RequirementOrderBLoC {
  Map<String, List<RequirementOrderModel>> _ordersMap;

  RequirementOrderBLoC() {
    _ordersMap = {
      "ALL": [],
      "PENDING_QUOTE": [],
      "COMPLETED": [],
      "CANCELLED": []
    };
  }

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
            "status": "PENDING_QUOTE",
            "totalQuantity": 10,
            "totalPrice": 300,
            "entries": [
              {
                "product": {
                  "code": "NA89852509",
                  "name": "山本风法少女长裙复古气质秋冬款",
                  "skuID": "NA89852509",
                  "majorCategory": {"name": "女装-T恤"},
                  "supercategories": [
                    {"name": "针织"}
                  ],
                  "thumbnail":
                      "https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp",
                },
                "entryNumber": 500,
              },
            ],
          }),
          RequirementOrderModel.fromJson({
            "code": "34938475200045",
            "status": "COMPLETED",
            "totalQuantity": 10,
            "totalPrice": 300,
            "entries": [
              {
                "product": {
                  "code": "NA89852509",
                  // "name": "山本风法少女长裙复古气质秋冬款",
                  // "skuID": "NA89852509",
                  "entryNumber": 500,
                  "majorCategory": {"name": "女装-T恤"},
                  "supercategories": [
                    {"name": "针织"}
                  ]
                },
                "entryNumber": 500,
              }
            ],
          }),
          RequirementOrderModel.fromJson({
            "code": "34938475200045",
            "status": "CANCELLED",
            "totalQuantity": 10,
            "totalPrice": 300,
            "entries": [
              {
                "product": {
                  "code": "NA89852509",
                  "name": "山本风法少女长裙复古气质秋冬款",
                  "skuID": "NA89852509",
                  "entryNumber": 500,
                  "majorCategory": {"name": "女装-T恤"},
                  "supercategories": [
                    {"name": "针织"}
                  ],
                  "thumbnail":
                      "https://img.alicdn.com/imgextra/i2/109570697/O1CN011H1GWjAIIrfgcfr_!!0-saturn_solar.jpg_220x220.jpg_.webp"
                },
                "entryNumber": 500,
              },
            ],
          }),
          RequirementOrderModel.fromJson({
            "code": "34938475200045",
            "status": "CANCELLED",
            "totalQuantity": 10,
            "totalPrice": 300,
            "entries": [
              {
                "product": {
                  "code": "NA89852509",
                  "name": "山本风法少女长裙复古气质秋冬款",
                  "skuID": "NA89852509",
                  "entryNumber": 500,
                  "majorCategory": {"name": "女装-T恤"},
                  "supercategories": [
                    {"name": "针织"}
                  ],
                  "thumbnail":
                      "https://img.alicdn.com/imgextra/i2/109570697/O1CN011H1GWjAIIrfgcfr_!!0-saturn_solar.jpg_220x220.jpg_.webp"
                },
                "entryNumber": 500,
              },
            ],
          }),
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
        return RequirementOrderModel.fromJson({
          "code": "34938475200045",
          "status": "CANCELLED",
          "totalQuantity": 10,
          "totalPrice": 300,
          "entries": [
            {
              "product": {
                "code": "NA89852509",
                "name": "山本风法少女长裙复古气质秋冬款",
                "skuID": "NA89852509",
                "entryNumber": 500,
                "majorCategory": {"name": "女装-T恤"},
                "supercategories": [
                  {"name": "针织"}
                ],
                "thumbnail":
                    "https://img.alicdn.com/imgextra/i2/109570697/O1CN011H1GWjAIIrfgcfr_!!0-saturn_solar.jpg_220x220.jpg_.webp"
              },
              "entryNumber": 500,
            },
          ],
        });
      }));
    } else {
      //通知显示已经到底部
      _bottomController.sink.add(true);
    }
    _loadingController.sink.add(false);
    _controller.sink.add(this._ordersMap[status]);
  }

  //页面控制

  var _loadingController = StreamController<bool>.broadcast();

  Stream<bool> get loadingStream => _loadingController.stream;

  var _bottomController = StreamController<bool>.broadcast();

  Stream<bool> get bottomStream => _bottomController.stream;

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
