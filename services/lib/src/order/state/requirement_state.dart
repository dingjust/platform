import 'package:core/core.dart';
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

  ///搜素关键字
  final String keyword;

  final double longtitude;

  final double latitude;

  RequirementState(
      {this.reviewState = RequirementReviewState.REVIEW_PASSED,
      this.type,
      this.keyword,
      this.longtitude,
      this.latitude});

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
    Map<String, dynamic> data = {'statuses': "PENDING_QUOTE"};
    if (reviewState != null) {
      data['reviewState'] = RequirementReviewStateMap[reviewState];
    }

    if (type != null) {
      data['orderType'] = RequirementOrderTypeMap[type];
    }

    if (keyword != null) {
      data['keyword'] = keyword;
    }

    if (latitude != null &&
        longtitude != null &&
        latitude > 0 &&
        longtitude > 0) {
      data['longtitude'] = longtitude;
      data['latitude'] = latitude;
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

  OrderRequirementState({
    this.type = RequirementOrderType.FINDING_ORDER,
    String keyword,
    RequirementReviewState reviewState,
    double longtitude,
    double latitude,
  }) : super(
      keyword: keyword,
      reviewState: reviewState,
      longtitude: longtitude,
      latitude: latitude);
}

class FactoryRequirementState extends RequirementState {
  final RequirementOrderType type;

  FactoryRequirementState({this.type = RequirementOrderType.FINDING_FACTORY,
    String keyword,
    RequirementReviewState reviewState,
    double longtitude,
    double latitude})
      : super(
      keyword: keyword,
      reviewState: reviewState,
      longtitude: longtitude,
      latitude: latitude);
}
