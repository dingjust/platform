import 'package:flutter/material.dart';

class ColorSizeEntry {
  int id;

  final String size;

  final String color;

  final TextEditingController controller;

  ColorSizeEntry(this.size, this.color, this.controller, {this.id});
}
