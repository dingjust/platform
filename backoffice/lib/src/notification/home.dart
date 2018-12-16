import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class NotificationHomePage extends StatefulWidget {
  final MessageRepository repository;

  NotificationHomePage({@required this.repository});

  @override
  State<StatefulWidget> createState() => new _NotificationHomePageState();
}

class _NotificationHomePageState extends State<NotificationHomePage> {
  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Hybris"),
      actions: <Widget>[
        IconButton(
          tooltip: '搜索',
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
        IconButton(
          tooltip: '即时聊天',
          icon: Icon(Icons.chat),
          onPressed: () {},
        ),
        PopupMenuButton(
          tooltip: '更多',
          icon: Icon(Icons.more_vert),
          onSelected: (String value) {},
          itemBuilder: (context) => <PopupMenuItem<String>>[
                PopupMenuItem(
                  value: '',
                  child: const Text('扫一扫'),
                ),
              ],
        ),
      ],
    );
  }

  Widget _buildMessages(BuildContext context) {
    Widget _buildMessage(MessageModel message) {
      return GestureDetector(
        onTap: null, // TODO: clickable
        child: Column(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.message),
              title: Text(message.title),
              subtitle: Text(message.description),
              trailing: Text(message.date),
            ),
            Divider(),
          ],
        ),
      );
    }

    return Column(
      children: <Widget>[
        _buildMessage(MessageModel('主题', description: '主题描述', date: '发生时间')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: ListView(
        children: [
          _buildMessages(context),
        ],
      ),
    );
  }
}
