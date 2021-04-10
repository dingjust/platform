import 'package:flutter/material.dart';

class FactoryTitle extends StatelessWidget {
  final String val;

  const FactoryTitle(this.val);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [
        Text(
          '$val',
          style: TextStyle(color: Colors.grey, fontSize: 18),
        ),
      ],
    ));
  }
}

class FactoryInfoRow extends StatelessWidget {
  final String label;

  final String val;

  const FactoryInfoRow({Key key, this.label, this.val}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (val == null || val == '') {
      return Container();
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            child: Text(label ?? ''),
          ),
          Expanded(
              child: Text(
            val ?? '',
            textAlign: TextAlign.right,
          ))
        ],
      ),
    );
  }
}

class FactoryDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      color: Colors.grey[50],
    );
  }
}

class FactoryBottomBtn extends StatelessWidget {
  final VoidCallback onTap;

  final Color color;

  final String label;

  final String info;

  const FactoryBottomBtn(
      {Key key, this.onTap, this.color, this.label, this.info})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$label',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                '$info',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              )
            ],
          ),
        ),
      ),
    );
  }
}
