import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:models/models.dart';

import '../io/file_storage.dart';

class MessageFileStorage extends AbstractFileStorage {
  const MessageFileStorage(
    String tag,
    Future<Directory> Function() getDirectory,
  ) : super(tag, getDirectory);

  @override
  Future<List<dynamic>> load() async {
    final file = await getLocalFile();
    final string = await file.readAsString();
    final json = JsonDecoder().convert(string);

    return (json['models']).map<MessageModel>((model) => MessageModel.fromJson(model)).toList();
  }

  @override
  Future<File> save(List<dynamic> models) async {
    final file = await getLocalFile();

    return file.writeAsString(JsonEncoder().convert({
      'models': models.map((model) => model.toJson()).toList(),
    }));
  }
}
