import 'dart:math';

class DoubleUtil {
  static double getDecimalsValue(double val, int decimals) {
    int fac = pow(10, decimals);
    return (val * fac).round() / fac;
  }
}
