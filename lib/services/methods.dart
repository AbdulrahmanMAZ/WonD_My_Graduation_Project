import 'package:flutter/material.dart';
import 'dart:math' as math;

radians(double a) {
  return a * math.pi / 180;
}

distance(lat1, lat2, lon1, lon2) {
  lon1 = radians(lon1);
  lon2 = radians(lon2);
  lat1 = radians(lat1);
  lat2 = radians(lat2);

  double dlon = lon2 - lon1;
  double dlat = lat2 - lat1;
  double a = math.pow(math.sin(dlat / 2), 2) +
      math.cos(lat1) * math.cos(lat2) * math.pow(math.sin(dlon / 2), 2);
  double c = 2 * math.asin(math.sqrt(a));

  double r = 6371;

  double result = (c * r);
  double result2 = double.parse((result).toStringAsFixed(1));

  return result2;
}
