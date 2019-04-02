import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  final String title;
  final List<Widget> items;

  Menu(this.title, this.items);

  @override
  Widget build(BuildContext context) {
    // List<MenuItem> columns = this.items.map((item) {
    //   return MenuItem(item.leading, item.title, item.routeTo);
    // }).toList();

    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        child: Column(
          children: items,
        ),
        color: Colors.white,
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final Widget leading;
  final String title;
  final String routeTo;

  MenuItem(this.leading, this.title, this.routeTo);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, routeTo),
      child: ListTile(
        trailing: Icon(Icons.chevron_right),
        title: Text(
          title,
        ),
        leading: leading,
      ),
    );
  }
}

class AdvanceMenu extends StatelessWidget {
  final String title;
  final List<AdvanceMenuItem> items;

  AdvanceMenu(this.title, this.items);

  @override
  Widget build(BuildContext context) {
    List<AdvanceMenuItem> columns = this.items.map((item) {
      return AdvanceMenuItem(item.image, item.title, item.routeTo);
    }).toList();

    return Container(
     /* width: double.infinity,*/
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10.0, 5.0, 0, 5.0),
            child: Text(title,
                style: TextStyle(
                    fontSize: 16.0, color: Color.fromRGBO(0, 0, 0, 1))),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: Wrap(
              spacing: 32.0,
              runSpacing: 20.0,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: columns,
            ),
          )
        ],
      ),
    );
  }
}

class AdvanceMenuItem extends StatelessWidget {
  final Image image;
  final String title;
  final String routeTo;

  AdvanceMenuItem(this.image, this.title, this.routeTo);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeTo);
      },
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image,
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              child: Text(
                title,
                style: TextStyle(
                  color: Color.fromRGBO(100, 100, 100, 1),
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
