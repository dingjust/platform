import 'package:flutter/material.dart';

class FactoryBottomBtn extends StatelessWidget {
  final VoidCallback onTap;

  final Color color;

  final String label;

  final String info;

  final Gradient gradient;

  const FactoryBottomBtn(
      {Key key, this.onTap, this.color, this.label, this.info, this.gradient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
          color: color,
          gradient: gradient,
          borderRadius: BorderRadius.circular(24)),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$label',
                style: TextStyle(
                    color: Color(0xff222222),
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              info != null
                  ? Text(
                      '$info',
                      style: TextStyle(color: Color(0xff666666), fontSize: 10),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
