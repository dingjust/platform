import 'package:flutter/material.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

/// 当页面到底部时，显示的scroll to top按钮，用于快速回到顶部
class ScrollToTopButton<T extends BLoCBase> extends StatelessWidget {
  Widget _buildButton(T bloc) {
    return FloatingActionButton(
      child: Icon(
        Icons.arrow_upward,
        color: Colors.white,
      ),
      onPressed: () {
        bloc.returnToTop();
      },
      backgroundColor: Colors.blue,
    );
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<T>(context);

    return StreamBuilder<bool>(
      stream: bloc.toTopBtnStream,
      initialData: false,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return snapshot.data ? _buildButton(bloc) : Container();
      },
    );
  }
}
