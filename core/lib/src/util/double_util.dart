import 'dart:math';

class DoubleUtil {
  static double getDecimalsValue(double val, int decimals) {
    int fac = pow(10, decimals) as int;
    return (val * fac).round() / fac;
  }
}
