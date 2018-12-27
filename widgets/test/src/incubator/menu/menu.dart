import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  final String title;
  final List<MenuItem> items;

  Menu(this.title, this.items);

  @override
  Widget build(BuildContext context) {
    List<MenuItem> columns = this.items.map((item) {
      return MenuItem(item.icon, item.title, item.routeTo);
    }).toList();

    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: columns,
          ),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String routeTo;

  MenuItem(this.icon, this.title, this.routeTo);

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeTo);
      },
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
