import 'package:flutter/material.dart';

class IntegralActivityItem extends StatelessWidget {
  final Widget leading;
  final Widget tail;
  final String title;
  final String descripiton;
  final String routeTo;
  final VoidCallback onTap;

  const IntegralActivityItem(
      {Key key,
      this.leading,
      this.tail,
      this.title,
      this.descripiton,
      this.routeTo,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          leading,
          Expanded(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '$title',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '$descripiton',
                      style: TextStyle(color: Color(0xffde7776), fontSize: 12),
                    ),
                    tail ?? Container()
                  ],
                )
              ],
            ),
          )),
          GestureDetector(
            onTap: () {
              if (routeTo != null) {
                Navigator.of(context).pushNamed(routeTo);
              } else if (onTap != null) {
                onTap.call();
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFFf57c07), Color(0xFFffb118)]),
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                '查看',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
