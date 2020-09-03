import "json_encodable.dart";

class SavePaymentMethodMode implements JsonEncodable {
  static const SavePaymentMethodMode on = SavePaymentMethodMode._('on');
  static const SavePaymentMethodMode off = SavePaymentMethodMode._('off');
  static const SavePaymentMethodMode userSelects =
      SavePaymentMethodMode._('userSelects');

  final String _mode;
  const SavePaymentMethodMode._(this._mode);

  factory SavePaymentMethodMode(String mode) {
    if (mode == null) return null;
    SavePaymentMethodMode _curMode = SavePaymentMethodMode._(mode);
    if (values.contains(_curMode)) {
      return _curMode;
    } else {
      throw ArgumentError('Unsupported save payment method mode: $mode.');
    }
  }

  String get value => _mode;
  static const List<SavePaymentMethodMode> values = const [
    on,
    off,
    userSelects
  ];

  @override
  bool operator ==(dynamic other) {
    if (other is SavePaymentMethodMode) {
      return other._mode == _mode;
    }
    return false;
  }

  @override
  int get hashCode => _mode.hashCode;

  String get json => _mode;

  @override
  String toString() => _mode;
}
