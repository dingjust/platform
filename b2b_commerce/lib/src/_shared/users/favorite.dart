import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

class FavoriteIcon extends StatelessWidget {
  final int id;

  const FavoriteIcon({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, MyFavoriteState state, _) {
      return LikeButton(
        isLiked: state.isFavorite(id),
        onTap: (val) async {
          if (!val) {
            state.add(id);
            BotToast.showText(
                text: '收藏成功,可在“我的-我的收藏”查看和管理', align: Alignment.center);
          } else {
            state.del(id);
            BotToast.showText(text: '取消收藏', align: Alignment.center);
          }
          return !val;
        },
      );
    });
  }
}
