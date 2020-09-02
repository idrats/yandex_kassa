import "json_encodable.dart";

class PaymentMethod implements JsonEncodable {
  static const PaymentMethod bankCard = const PaymentMethod._('bank_card');
  static const PaymentMethod sberbank = const PaymentMethod._('sberbank');
  static const PaymentMethod yandexMoney =
      const PaymentMethod._('yandex_money');
  static const PaymentMethod applePay = const PaymentMethod._('apple_pay');
  static const PaymentMethod googlePay = const PaymentMethod._('google_pay');

  final String _method;
  const PaymentMethod._(this._method);

  factory PaymentMethod(String method) {
    if (method == null) return null;
    PaymentMethod _curMethod = PaymentMethod._(method);
    if (values.contains(_curMethod)) {
      return _curMethod;
    } else {
      throw ArgumentError('Unsupported payment method: $method.');
    }
  }

  String get value => _method;
  static const List<PaymentMethod> values = const [
    bankCard,
    sberbank,
    yandexMoney,
    applePay,
    googlePay
  ];

  @override
  bool operator ==(dynamic other) {
    if (other is PaymentMethod) {
      return other._method == _method;
    }
    return false;
  }

  @override
  int get hashCode => _method.hashCode;

  String get json => _method;

  @override
  String toString() => _method;
}
