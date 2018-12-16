import 'dart:async';
import 'dart:core';

import 'package:meta/meta.dart';
import 'package:models/models.dart';

import 'message_file_storage.dart';
import 'message_repository.dart';
import 'message_web_client.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageFileStorage fileStorage;
  final MessageWebClient webClient;

  const MessageRepositoryImpl({
    @required this.fileStorage,
    this.webClient = const MessageWebClient(),
  });

  /// Loads models first from File storage. If they don't exist or encounter an
  /// error, it attempts to load the Models from a Web Client.
  @override
  Future<List<MessageModel>> list() async {
    try {
      return await fileStorage.load();
    } catch (e) {
      final models = await webClient.fetch();

      fileStorage.save(models);

      return models;
    }
  }

  // Persists models to local disk and the web
  @override
  Future save(List<MessageModel> models) {
    return Future.wait<dynamic>([
      fileStorage.save(models),
      webClient.post(models),
    ]);
  }
}
