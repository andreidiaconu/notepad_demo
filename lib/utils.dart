import 'dart:ui';

import 'package:flutter/widgets.dart';

bool displayHasHinge(BuildContext context) {
  return MediaQuery.of(context)
      .displayFeatures
      .any((element) => element.type == DisplayFeatureType.hinge);
}
