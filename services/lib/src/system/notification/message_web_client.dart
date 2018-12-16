import 'dart:async';

import 'package:models/models.dart';

class MessageWebClient {
  final Duration delay;

  const MessageWebClient([this.delay = const Duration(milliseconds: 3000)]);

  /// Mock that "fetches" some Models from a "web service" after a short delay
  Future<List<MessageModel>> fetch() async {
    return Future.delayed(
      delay,
      () => [
            MessageModel('1'),
            MessageModel('2'),
            MessageModel('3'),
            MessageModel('4'),
            MessageModel('5'),
          ],
    );
  }

  /// Mock that returns true or false for success or failure. In this case,
  /// it will "Always Succeed"
  Future<bool> post(List<MessageModel> models) async {
    return Future.value(true);
  }
}
