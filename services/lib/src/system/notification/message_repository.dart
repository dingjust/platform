import 'dart:async';
import 'dart:core';

import 'package:models/models.dart';

abstract class MessageRepository {
  Future<List<MessageModel>> list();

  Future save(List<MessageModel> models);
}
