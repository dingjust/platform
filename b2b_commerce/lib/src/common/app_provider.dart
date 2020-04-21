import 'dart:isolate';

import 'package:b2b_commerce/src/helper/certification_status.dart';
import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

///全局 Provider
class AppProvider {
  static List<SingleChildCloneableWidget> providers =
  <SingleChildCloneableWidget>[
    ChangeNotifierProvider(builder: (_) => MyCapacityState()),
    ChangeNotifierProvider(builder: (_) => ProductionProgressState()),
    ChangeNotifierProvider(builder: (_) => AmapState()),
    ChangeNotifierProvider(builder: (_) => NetState.instance),
    ChangeNotifierProvider(builder: (_) => ProductHomeState()),
    ChangeNotifierProvider(builder: (_) => ProductHomeCarouselsState()),
    ChangeNotifierProvider(builder: (_) => RecommendProductState()),
    Provider(
      builder: (_) => AddressState(),
    ),
    Provider(
      builder: (_) => CategoryState(),
    ),
    Provider(
      builder: (_) => MajorCategoryState(),
    ),
    Provider(
      builder: (_) => CarrierState(),
    ),
    Provider(
      builder: (_) => CertificationStatusHelper(),
    ),
    Provider(
      builder: (_) => LabelState(),
    ),
    Provider(
      builder: (_) => ColorState(),
    ),
    Provider(
      builder: (_) => SizeState(),
    ),
  ];

  ///预加载
  preloading(BuildContext context) async {
    DateTime start = DateTime.now();
    print(
        '[nbyjy]================================	预加载开始${DateFormatUtil
            .formatYMDHMS(start)}');

    Provider.of<ProductHomeState>(context).getData();
    Provider.of<ProductHomeCarouselsState>(context).getBodyData();
    Provider.of<ProductHomeCarouselsState>(context).getHeaderData();
    Provider
        .of<RecommendProductState>(context)
        .products;
    await Provider.of<CategoryState>(context).getCascadedCategories();
    await Provider.of<AddressState>(context).getRegions();
    await Provider.of<MajorCategoryState>(context).getMajorCategories();
    await Provider.of<CarrierState>(context).getCarriers();
    await Provider.of<LabelState>(context).getLabels();
    await Provider.of<ColorState>(context).getAllColors();
    await Provider.of<SizeState>(context).getAllSizes();
    // ReceivePort receivePort = ReceivePort();
    // await Isolate.spawn(dataLoader, receivePort.sendPort);

    // SendPort sendPort = await receivePort.first;

    // int result = await sendReceive(
    //     sendPort, 'https://jsonplaceholder.typicode.com/posts');
    DateTime end = DateTime.now();
    // print('================================	结果${result}}');
    print(
        '[nbyjy]================================	预加载结束${DateFormatUtil
            .formatYMDHMS(end)}');
    print(
        '[nbyjy]================================	相差${end
            .difference(start)
            .inSeconds}秒(${end
            .difference(start)
            .inMilliseconds})');
  }

  static dataLoader(SendPort sendPort) async {
    ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    int num = 999999999999999;

    await for (var msg in receivePort) {
      String requestURL = msg[0];
      SendPort callbackPort = msg[1];

      // int count = 0;
      // while (num > 0) {
      //   if (num % 2 == 0) {
      //     count++;
      //   }
      //   num--;
      // }
      await Future.delayed(Duration(seconds: 10));
      callbackPort.send(0);
    }
  }

  Future sendReceive(SendPort sendPort, String url) {
    ReceivePort receivePort = ReceivePort();
    sendPort.send([url, receivePort.sendPort]);
    return receivePort.first;
  }
}
