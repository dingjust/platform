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

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        child: Column(
          children: columns,
        ),
        color: Colors.white,
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
    return InkWell(
      onTap: () => Navigator.pushNamed(context, routeTo),
      child: ListTile(
        trailing: Icon(Icons.chevron_right),
        title: Text(title),
        leading: Icon(icon),
      ),
    );
  }
}
