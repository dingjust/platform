import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

/// 全局搜索框
class GlobalSearchInput<T> extends StatelessWidget {
  // final
  final double width;
  final double height;
  final String tips;

  final SearchDelegate<T> delegate;

  const GlobalSearchInput({
    Key key,
    this.delegate,
    this.width = 400,
    this.height = 35,
    this.tips = '   找点什么...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showSearch(context: context, delegate: delegate),
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[300], width: 0.5),
        ),
        child: Row(
          children: <Widget>[
            const Icon(B2BIcons.search, color: Colors.grey, size: 18),
            Text(
              tips,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
