import 'package:core/core.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/state/state.dart';
import 'package:services/src/subcontract/repository/subcontract_repository_impl.dart';

///工厂产能状态管理
class SubContractPoolState extends PageState {
  String factoryUid;
  SubContractPoolState({this.factoryUid});
  Map<String,Object> _queryFormData = {};
  CategoryModel _category;
  CategoryModel _majorCategory;
  List<RegionModel> _regions;
  int _newDate;
  String _machiningType;
  String _keyword;
  String _type;
  List<SubContractModel> _subcontractModels;
  bool _showTopBtn = false;
  bool _showDateFilterMenu = false;

  List<SubContractModel> get subcontractModels {
    if (_subcontractModels == null) {
      getData();
    }
    return _subcontractModels;
  }

  bool get showTopBtn => _showTopBtn;

  set showTopBtn(bool value) {
    _showTopBtn = value;
    notifyListeners();
  }

  bool get showDateFilterMenu => _showDateFilterMenu;

  set showDateFilterMenu(bool value) {
    _showDateFilterMenu = value;
    notifyListeners();
  }

  Map<String, Object> get queryFormData => _queryFormData;

  set queryFormData(Map<String, Object> value) {
    _queryFormData = value;
  }

  @override
  void getData() async {
    print(_queryFormData);
    isDownEnd = false;
    var response = await SubContractRepositoryImpl().getSubcontractsByAllFactory(data:_queryFormData, params:{
      'page': currentPage,
      'size': pageSize,
    });

    if (response != null) {
      _subcontractModels = response.content;
      pageSize = response.size;
      currentPage = response.number;
      totalPages = response.totalPages;
      totalElements = response.totalElements;
    }

    ///通知刷新
    notifyListeners();
  }

  @override
  void loadMore() async {

    if (!lock) {
      //异步调用开始，通知加载组件
      workingStart();
      //接口调用：
      if (currentPage + 1 != totalPages) {
        isDownEnd = false;
        var response= await SubContractRepositoryImpl().getSubcontractsByAllFactory(data:_queryFormData, params:{
          'page': currentPage + 1,
          'size': pageSize,
        });

        if (response != null) {
          _subcontractModels.addAll(response.content);
          pageSize = response.size;
          currentPage = response.number;
          totalPages = response.totalPages;
          totalElements = response.totalElements;
        }

      }else{
        isDownEnd = true;
      }
      //异步调用结束，通知加载组件
      workingEnd();
    }
  }

  @override
  void clear() {
    _subcontractModels = null;
    reset();
    notifyListeners();
  }

  String get keyword {
    if(_keyword == null){
      _keyword = '';
    }
    return _keyword;
  }

  set keyword(String value) {
    _keyword = value;
    _queryFormData['keyword'] = _keyword;
    notifyListeners();
    clear();
  }

  int get newDate => _newDate;

  set newDate(int value) {
    _newDate = value;
    _showDateFilterMenu = !_showDateFilterMenu;
    int createdDateTo;
    int createdDateFrom;
    if(_newDate != null){
      createdDateTo = DateTime.now().millisecondsSinceEpoch;
      createdDateFrom = DateTime.now().subtract(Duration(days: _newDate)).millisecondsSinceEpoch;
    }

    _queryFormData['createdDateTo'] = createdDateTo;
    _queryFormData['createdDateFrom'] = createdDateFrom;
    print(_queryFormData);

    notifyListeners();
    clear();
  }

  List<RegionModel> get regions {
    if(_regions == null){
      _regions = [];
    }
    return _regions;
  }

  set regions(List<RegionModel> value) {
    _regions = value;
    if(_regions != null && _regions.length > 0){
      _queryFormData['productiveOrientations'] = _regions.map((region) => region.isocode).toList();
    }else{
      _queryFormData['productiveOrientations'] = null;
    }

    notifyListeners();
    clear();
  }

  CategoryModel get category => _category;

  set category(CategoryModel value) {
    _category = value;
    _queryFormData['categories'] = _category != null ? _category.code : null;
    print(_queryFormData);
    notifyListeners();
    clear();
  }

  CategoryModel get majorCategory => _majorCategory;

  set majorCategory(CategoryModel value) {
    _majorCategory = value;
    _queryFormData['majorCategories'] = _majorCategory != null ? _majorCategory.code : null;
    print(_queryFormData);
    notifyListeners();
  }

  String get type => _type;

  set type(String value) {
    _type = value;
    _queryFormData['types'] = _type;
    notifyListeners();
  }

  String get machiningType => _machiningType;

  set machiningType(String value) {
    _machiningType = value;
    _queryFormData['machiningTypes'] = _machiningType;
    notifyListeners();
  }

  void clearAllCondition(){
    _newDate = null;
    _regions = [];
    _category = null;
    _majorCategory = null;
    _type = null;
    _machiningType = null;
    _keyword = null;
    _queryFormData = {};
    notifyListeners();
    clear();
  }
}
