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
      return Container(
        // width: 72,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
            color: Color(0xffFED800), borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            LikeButton(
              isLiked: state.isFavorite(id),
              likeBuilder: (bool isLiked) {
                return Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Color(0xffFF4D4F) : Color(0xff222222),
                  size: 20,
                );
              },
              size: 20,
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
            ),
            Text(
              '收藏',
              style: TextStyle(
                  color: Color(0xff222222),
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      );
    });
  }
}
