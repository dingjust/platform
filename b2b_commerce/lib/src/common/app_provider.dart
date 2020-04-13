import 'package:b2b_commerce/src/helper/certification_status.dart';
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

//   loadData() async {
//     //	᭗ᬦspawnෛୌӞӻisolate҅ଚᕬਧᶉாොဩ
//     DateTime start = DateTime.now();
//     print(
//         '================================	开始${DateFormatUtil.formatYMDHMS(start)}');
//     ReceivePort receivePort = ReceivePort();
//     await Isolate.spawn(dataLoader, receivePort.sendPort);

//     //	឴ݐෛisolateጱፊލport
//     SendPort sendPort = await receivePort.first;
//     //	᧣አsendReceiveᛔਧԎොဩ
//     int result = await sendReceive(
//         sendPort, 'https://jsonplaceholder.typicode.com/posts');
//     DateTime end = DateTime.now();
//     print('================================	结果${result}}');
//     print(
//         '================================	结束${DateFormatUtil.formatYMDHMS(end)}');
//     print(
//         '================================	相差${end.difference(start).inSeconds}秒');
//   }

// //	isolateጱᕬਧොဩ
//   static dataLoader(SendPort sendPort) async {
//     //	ڠୌፊލport҅ଚਖ਼sendPortփᕳक़ኴአ๶᧣አ
//     ReceivePort receivePort = ReceivePort();
//     sendPort.send(receivePort.sendPort);

//     int num = 999999999999999;

//     await for (var msg in receivePort) {
//       String requestURL = msg[0];
//       SendPort callbackPort = msg[1];

//       // int count = 0;
//       // while (num > 0) {
//       //   if (num % 2 == 0) {
//       //     count++;
//       //   }
//       //   num--;
//       // }
//       await Future.delayed(Duration(seconds: 10));
//       callbackPort.send(0);
//     }
//   }

// //	ڠୌᛔ૩ጱፊލport҅ଚӬݻෛisolateݎᭆၾ௳
//   Future sendReceive(SendPort sendPort, String url) {
//     ReceivePort receivePort = ReceivePort();
//     sendPort.send([url, receivePort.sendPort]);
//     //	ളතکᬬࢧ꧊҅ᬬࢧᕳ᧣አᘏ
//     return receivePort.first;
//   }
}
