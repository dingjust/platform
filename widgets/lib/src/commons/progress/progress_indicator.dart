import 'package:flutter/material.dart';

class ProgressIndicatorFactory {
  static Widget buildDefaultProgressIndicator() {
    return Center(child: CircularProgressIndicator());
  }

  static Widget buildPaddedProgressIndicator({double horizontal = 0, double vertical = 200}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: ProgressIndicatorFactory.buildDefaultProgressIndicator(),
    );
  }

  static Widget buildPaddedOpacityProgressIndicator({double padding = 8.0, double opacity = 0}) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Center(
        child: Opacity(
          opacity: opacity,
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
