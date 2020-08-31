import 'dart:isolate';

import 'package:b2b_commerce/src/helper/app_version.dart';
import 'package:b2b_commerce/src/helper/certification_status.dart';
import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

///全局 Provider
class AppProvider {
  static List<SingleChildCloneableWidget> providers =
  <SingleChildCloneableWidget>[
    ChangeNotifierProvider(create: (_) => MyCapacityState()),
    ChangeNotifierProvider(create: (_) => ProductionProgressState()),
    ChangeNotifierProvider(create: (_) => AmapState()),
    ChangeNotifierProvider(create: (_) => NetState.instance),
    ChangeNotifierProvider(create: (_) => ProductHomeState()),
    ChangeNotifierProvider(create: (_) => ProductHomeCarouselsState()),
    ChangeNotifierProvider(create: (_) => RecommendProductState()),
    Provider(
      create: (_) => AddressState(),
    ),
    Provider(
      create: (_) => CategoryState(),
    ),
    Provider(
      create: (_) => MajorCategoryState(),
    ),
    Provider(
      create: (_) => CarrierState(),
    ),
    Provider(
      create: (_) => CertificationStatusHelper(),
    ),
    Provider(
      create: (_) => AppVersionHelper(),
    ),
    Provider(
      create: (_) => LabelState(),
    ),
    Provider(
      create: (_) => ColorState(),
    ),
    Provider(
      create: (_) => SizeState(),
    ),
  ];

  ///预加载
  preloading(BuildContext context) async {
    DateTime start = DateTime.now();
    print(
        '[nbyjy]================================	预加载开始${DateFormatUtil
            .formatYMDHMS(start)}');

    // Provider.of<ProductHomeState>(context).getData();
    // Provider.of<ProductHomeCarouselsState>(context).getBodyData();
    // Provider.of<ProductHomeCarouselsState>(context).getHeaderData();
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

    AppVersionHelper appVersionHelper = Provider.of<AppVersionHelper>(context);
    await appVersionHelper.getAppVersionInfo('nbyjy');
    // await appVersionHelper.checkVersion(
    //     context, AppBLoC.instance.packageInfo.version, 'nbyjy');
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
