/// TabPage实体类,用于装载Tab页信息
class PageEntry {
  /// 当前页
  int currentPage;

  /// 每页加载数据量
  int size;

  /// 装载数据列表
  List<dynamic> data;

  /// 总页数
  int totalPages;

  /// 总数
  int totalElements;

  ///状态
  String status;

  PageEntry({this.currentPage, this.size, this.data, this.totalPages,this.totalElements,this.status,});
}
