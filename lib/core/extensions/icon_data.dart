import 'package:flutter/material.dart';

extension type const MaterialIconData(IconData _iconData) implements IconData {
  MaterialIconData.fromCode(int codePoint)
    : this(IconData(codePoint, fontFamily: 'MaterialIcons'));
}
