import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'progress_work_sheet_response.g.dart';

/// 进度工单列表响应
@JsonSerializable()
class ProgressWorkSheetResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<ProgressWorkSheetModel> content;

  ProgressWorkSheetResponse(this.number, this.size, this.totalPages,
      this.totalElements, this.content);

  factory ProgressWorkSheetResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ProgressWorkSheetResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProgressWorkSheetResponseToJson(this);
}
