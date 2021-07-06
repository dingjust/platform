import 'package:models/models.dart';
import 'package:services/src/state/state.dart';

import '../../../services.dart';

///需求信息状态管理
class RequirementState extends PageState {
  List<RequirementOrderModel> _requirements;

  ///需求状态
  final RequirementReviewState reviewState;

  ///需求类型
  final RequirementOrderType type;

  RequirementState(
      {this.reviewState = RequirementReviewState.REVIEW_PASSED, this.type});

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
    var data = {'statuses': "PENDING_QUOTE"};
    if (reviewState != null) {
      data['reviewState'] = RequirementReviewStateMap[reviewState];
    }

    if (type != null) {
      data['orderType'] = RequirementOrderTypeMap[type];
    }

    return data;
  }

  @override
  clear() {
    _requirements = null;
    reset();
    notifyListeners();
  }
}

class OrderRequirementState extends RequirementState {
  final RequirementOrderType type;

  OrderRequirementState({this.type = RequirementOrderType.FINDING_ORDER});
}

class FactoryRequirementState extends RequirementState {
  final RequirementOrderType type;

  FactoryRequirementState({this.type = RequirementOrderType.FINDING_FACTORY});
}
