import '../../../services.dart';

class BLocBus {
  ///所有BLoc重置
  static void systemBlocReset() {
    try {
      FactoryBLoC.instance.reset();
      OrderByProductBLoc.instance.reset();
      MyHelpBLoC.instance.reset();
      ProofingOrdersBLoC.instance.reset();
      PurchaseOrderBLoC.instance.reset();
      QuoteOrdersBLoC.instance.reset();
      QuoteOrdersBLoC.instance.reset();
      RequirementOrderBLoC.instance.reset();
      RequirementPoolBLoC.instance.reset();
      RequirementQuoteDetailBLoC.instance.reset();
      ApparelProductBLoC.instance.clearProductsMap();
      ApparelProductSearchResultBLoC.instance.reset();
      ProductionBLoC.instance.reset();
      ProductionSearchResultBLoC.instance.reset();
      // SuppliersBloc
      AddressBLoC.instance.reset();
      EmployeeBLoC.instance.reset();
    } catch (e) {
      print(e);
    }
  }
}
