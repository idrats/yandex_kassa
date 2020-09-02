import 'package:yandex_kassa/models/json_encodable.dart';
import 'package:yandex_kassa/yandex_kassa.dart';

/// IOS Color Scheme. If [white] is not empty - [red], [green] and [blue] parameters will be ignored.
class IosColorScheme extends AndroidColorScheme implements JsonEncodable {
  static IosColorScheme black5 = IosColorScheme(white: 0, alpha: 13);
  static IosColorScheme black12 = IosColorScheme(white: 0, alpha: 31);
  static IosColorScheme black30 = IosColorScheme(white: 0, alpha: 77);
  static IosColorScheme black50 = IosColorScheme(white: 0, alpha: 128);
  static IosColorScheme black60 = IosColorScheme(white: 0, alpha: 153);
  static IosColorScheme black65 = IosColorScheme(white: 0, alpha: 166);
  static IosColorScheme black90 = IosColorScheme(white: 0, alpha: 230);
  static IosColorScheme geyser =
      IosColorScheme(red: 221, green: 227, blue: 229);
  static IosColorScheme greenHaze =
      IosColorScheme(red: 0, green: 152, blue: 95);
  static IosColorScheme white90 = IosColorScheme(white: 255, alpha: 230);
  static IosColorScheme codGray = IosColorScheme(white: 26);
  static IosColorScheme mineShaft = IosColorScheme(white: 34);
  static IosColorScheme warmGray = IosColorScheme(white: 153);
  static IosColorScheme alto = IosColorScheme(white: 219);
  static IosColorScheme mousegrey = IosColorScheme(white: 224);
  static IosColorScheme mercury = IosColorScheme(white: 225);
  static IosColorScheme gallery = IosColorScheme(white: 236);
  static IosColorScheme darkSkyBlue =
      IosColorScheme(red: 70, green: 142, blue: 229);
  static IosColorScheme lightGold =
      IosColorScheme(red: 254, green: 221, blue: 97);
  static IosColorScheme brightSun =
      IosColorScheme(red: 254, green: 217, blue: 68);
  static IosColorScheme redOrange =
      IosColorScheme(red: 255, green: 51, blue: 51);
  static IosColorScheme redOrange70 =
      IosColorScheme(red: 255, green: 51, blue: 51, alpha: 179);
  static IosColorScheme dandelion =
      IosColorScheme(red: 254, green: 216, blue: 93);
  static IosColorScheme dandelion80 =
      IosColorScheme(red: 255, green: 221, blue: 96, alpha: 204);
  static IosColorScheme blueRibbon =
      IosColorScheme(red: 0, green: 112, blue: 240);
  static IosColorScheme cerulean =
      IosColorScheme(red: 6, green: 151, blue: 198);
  static IosColorScheme battleshipGrey =
      IosColorScheme(red: 107, green: 117, blue: 136);
  static IosColorScheme dustyOrange =
      IosColorScheme(red: 233, green: 107, blue: 76);
  static IosColorScheme emeraldGreen =
      IosColorScheme(red: 0, green: 151, blue: 25);
  static IosColorScheme electricPurple =
      IosColorScheme(red: 140, green: 63, blue: 1);
  static IosColorScheme brightBlue =
      IosColorScheme(red: 0, green: 108, blue: 245);
  static IosColorScheme pine = IosColorScheme(red: 61, green: 73, blue: 41);
  static IosColorScheme burntSienna =
      IosColorScheme(red: 176, green: 60, blue: 22);
  static IosColorScheme darkIndigo =
      IosColorScheme(red: 8, green: 38, blue: 59);
  static IosColorScheme darkSlateBlue =
      IosColorScheme(red: 16, green: 58, blue: 74);
  static IosColorScheme charcoalGrey =
      IosColorScheme(red: 44, green: 42, blue: 45);
  static IosColorScheme marineBlue =
      IosColorScheme(red: 0, green: 143, blue: 174);
  static IosColorScheme slateBlue =
      IosColorScheme(red: 21, green: 42, blue: 96);
  static IosColorScheme uglyBlue =
      IosColorScheme(red: 43, green: 136, blue: 146);
  static IosColorScheme dullBlue =
      IosColorScheme(red: 76, green: 117, blue: 158);
  static IosColorScheme cararra = IosColorScheme(white: 247);
  static IosColorScheme mustard =
      IosColorScheme(red: 255, green: 219, blue: 77);
  static IosColorScheme creamBrulee =
      IosColorScheme(red: 255, green: 234, blue: 158);
  static IosColorScheme doveGray = IosColorScheme(white: 102);
  static IosColorScheme nobel = IosColorScheme(white: 179);
  static IosColorScheme blueRibbon50 =
      IosColorScheme(red: 0, green: 112, blue: 240, alpha: 128);
  static IosColorScheme jordyBlue =
      IosColorScheme(red: 135, green: 184, blue: 245);
  static IosColorScheme success = IosColorScheme(red: 0, green: 153, blue: 97);
  static IosColorScheme inverse = IosColorScheme(white: 255);
  static IosColorScheme inverseTranslucent =
      IosColorScheme(white: 255, alpha: 128);
  static IosColorScheme inverse30 = IosColorScheme(white: 255, alpha: 77);
  static IosColorScheme link = IosColorScheme(red: 0, green: 108, blue: 244);

  final int red;
  final int green;
  final int blue;
  final int white;
  final int alpha;
  IosColorScheme(
      {this.red = 0,
      this.green = 0,
      this.blue = 0,
      this.white,
      this.alpha = 255})
      : super(red: red, green: green, blue: blue);

  factory IosColorScheme.fromJson(Map json) {
    if (json == null) return null;
    return IosColorScheme(
        red: json['red'],
        green: json['green'],
        blue: json['blue'],
        white: json['white'],
        alpha: json['alpha']);
  }

  @override
  Map<String, int> get json => {
        'red': red,
        'green': green,
        'blue': blue,
        'white': white,
        'alpha': alpha
      }..removeWhere((key, val) => val == null);

  @override
  String toString() => json.toString();
}
