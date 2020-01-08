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
  ];
}
