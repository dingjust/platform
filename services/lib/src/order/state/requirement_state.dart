import 'package:models/models.dart';
import 'package:services/src/state/state.dart';

import '../../../services.dart';

///需求信息状态管理
class RequirementState extends PageState {
  List<RequirementOrderModel> _requirements;

  ///是否前端显示
  final bool enableShow;

  ///需求审核状态
  final RequirementReviewState reviewState;

  ///需求类型
  final RequirementOrderType type;

  ///搜素关键字
  final String keyword;

  final double longitude;

  final double latitude;

  final String sortCondition;

  RequirementState(
      {this.reviewState,
      this.type,
      this.keyword,
      this.longitude,
      this.latitude,
      this.enableShow = true,
      //默认时间倒序
      this.sortCondition = 'creationtime,DESC'});

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
        params: {'page': 0, 'size': pageSize, "sort": sortCondition},
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
          "sort": sortCondition
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
        longitude != null &&
        latitude > 0 &&
        longitude > 0) {
      data['longitude'] = longitude;
      data['latitude'] = latitude;
    }

    if (enableShow != null) {
      data['enableShow'] = enableShow;
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
  OrderRequirementState({String keyword,
    RequirementReviewState reviewState,
    double longitude,
    double latitude,
    bool enableShow = true,
    String sortCondition = 'creationtime,DESC'})
      : super(
      keyword: keyword,
      reviewState: reviewState,
      longitude: longitude,
      latitude: latitude,
      enableShow: enableShow,
      type: RequirementOrderType.FINDING_ORDER,
      sortCondition: sortCondition);
}

class FactoryRequirementState extends RequirementState {
  FactoryRequirementState({String keyword,
    RequirementReviewState reviewState,
    double longitude,
    double latitude,
    bool enableShow = true,
    String sortCondition = 'creationtime,DESC'})
      : super(
      keyword: keyword,
      reviewState: reviewState,
      longitude: longitude,
      latitude: latitude,
      enableShow: enableShow,
      type: RequirementOrderType.FINDING_FACTORY,
      sortCondition: sortCondition);
}
