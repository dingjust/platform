import 'package:flutter/material.dart';
import 'package:models/models.dart';

///表单状态管理
class ExternalOrderFormState with ChangeNotifier {
  List<ProductionTaskOrderModel> entries;

  List<ExternalOrderFormEntry> formEntries;

  ExternalOrderFormState({this.entries});

  ///更改entries
  void updateEntries(List<ProductionTaskOrderModel> values) {
    //构造entry
    formEntries = values.map((e) {
      //已存在
      if (formEntries != null) {
        ExternalOrderFormEntry exitEntry = formEntries.firstWhere(
            (element) => element.entry.product.code == e.product.code,
            orElse: () => null);
        if (exitEntry != null) {
          return exitEntry;
        }
      }

      Map controllerMap = {};
      Map nodeMap = {};
      e.colorSizeEntries.forEach((element) {
        if (controllerMap[element.color.code] == null) {
          controllerMap[element.color.code] = {};
        }
        controllerMap[element.color.code][element.size.code] =
            TextEditingController(
                text: '${element.quantity != 0 ? element.quantity : ''}');

        if (nodeMap[element.color.code] == null) {
          nodeMap[element.color.code] = {};
        }
        nodeMap[element.color.code][element.size.code] = FocusNode();
      });
      return ExternalOrderFormEntry(
          entry: e, controllerMap: controllerMap, nodeMap: nodeMap);
    }).toList();

    entries = values;

    notifyListeners();
  }

  Map getControllerMapByCode(String code) {
    if (formEntries != null) {
      ExternalOrderFormEntry formEntry = formEntries.firstWhere(
          (element) => element.entry.product.code == code,
          orElse: () => null);
      if (formEntry != null) {
        return formEntry.controllerMap;
      }
    }
    return null;
  }

  Map getNodeMapByCode(String code) {
    if (formEntries != null) {
      ExternalOrderFormEntry formEntry = formEntries.firstWhere(
          (element) => element.entry.product.code == code,
          orElse: () => null);
      if (formEntry != null) {
        return formEntry.nodeMap;
      }
    }
    return null;
  }
}

class ExternalOrderFormEntry {
  final ProductionTaskOrderModel entry;

  final Map controllerMap;

  final Map nodeMap;

  ExternalOrderFormEntry({this.entry, this.controllerMap, this.nodeMap});
}
