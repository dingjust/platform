import 'package:models/models.dart';
import 'package:services/src/state/state.dart';

import '../../../services.dart';

///需求信息状态管理
class RequirementState extends PageState {
  List<RequirementOrderModel> _requirements;

  List<RequirementOrderModel> get requirements {
    if (_requirements == null) {
      getData();
    }
    return _requirements;
  }

  @override
  getData() {
    pageSize = 20;

    RequirementOrderRepository.getRequirementsAnonymous(
            params: {'page': 0, 'size': pageSize, "sort": "creationtime,DESC"},
            data: getParamsData())
        .then((response) {
      if (response != null) {
        _requirements = response.content;
        pageSize = response.size;
        currentPage = response.number;
        totalPages = response.totalPages;
        totalElements = response.totalElements;

        ///通知刷新
        notifyListeners();
      }
    });
  }

  @override
  loadMore() async {
    if (!lock) {
      //异步调用开始，通知加载组件
      workingStart();
      //接口调用：
      if (currentPage + 1 != totalPages) {
        await RequirementOrderRepository.getRequirementsAnonymous(params: {
          'page': ++currentPage,
          'size': pageSize,
          "sort": "creationtime,DESC"
        }, data: getParamsData())
            .then((response) {
          if (response != null) {
            _requirements.addAll(response.content);
            pageSize = response.size;
            currentPage = response.number;
            totalPages = response.totalPages;
            totalElements = response.totalElements;
          }
        });
      }
      //异步调用结束，通知加载组件
      workingEnd();
    }
  }

  Map<String, dynamic> getParamsData() {
    return {'statuses': "PENDING_QUOTE"};
  }

  @override
  clear() {
    _requirements = null;
    reset();
    notifyListeners();
  }
}
