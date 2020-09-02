import 'package:flutter/foundation.dart';
import 'json_encodable.dart';

class AndroidColorScheme implements JsonEncodable {
  final int red;
  final int green;
  final int blue;
  AndroidColorScheme(
      {@required this.red, @required this.green, @required this.blue});

  factory AndroidColorScheme.fromJson(Map json) {
    if (json == null) return null;
    return AndroidColorScheme(
        red: json['red'], green: json['green'], blue: json['blue']);
  }

  @override
  Map<String, int> get json => {'red': red, 'green': green, 'blue': blue}
    ..removeWhere((key, val) => val == null);

  @override
  String toString() => json.toString();
}
