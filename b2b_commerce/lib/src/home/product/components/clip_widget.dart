import 'dart:math';

import 'package:flutter/material.dart';

class ClipWidget extends StatelessWidget {
  final Widget child;

  const ClipWidget({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TrianglePath(),
      child: Container(child: child),
    );
  }
}

class TrianglePath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(size.width - (size.height / (2 * tan(pi / 3))), 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - (size.height / (2 * tan(pi / 3))), size.height);
    path.lineTo(0, size.height);
    // if (index != 0) {
    //   path.lineTo(size.width / 3, size.height / 2);
    // }
    // path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
