import 'package:flutter/material.dart';

class PublishRequirementSuccessDialog extends StatefulWidget {
  _PublishRequirementSuccessDialogState createState() =>
      _PublishRequirementSuccessDialogState();
}

class _PublishRequirementSuccessDialogState
    extends State<PublishRequirementSuccessDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.5,
        title: Text('发布需求成功'),
      ),
    );
  }
}
