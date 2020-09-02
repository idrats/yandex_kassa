import "json_encodable.dart";

class Currency implements JsonEncodable {
  static const Currency rub = const Currency._('RUB');
  static const Currency usd = const Currency._('USD');
  static const Currency eur = const Currency._('EUR');

  final String _type;
  const Currency._(this._type);

  factory Currency(String type) {
    if (type == null) return null;
    Currency _curType = Currency._(type);
    if (values.contains(_curType)) {
      return _curType;
    } else {
      throw ArgumentError('Unsupported currency type: $type.');
    }
  }

  String get value => _type;
  static const List<Currency> values = const [rub, usd, eur];

  @override
  bool operator ==(dynamic other) {
    if (other is Currency) {
      return other._type == _type;
    }
    return false;
  }

  @override
  int get hashCode => _type.hashCode;

  String get json => _type;

  @override
  String toString() => _type;
}
