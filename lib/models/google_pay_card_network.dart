class GooglePayCardNetwork {
  final String _network;

  const GooglePayCardNetwork._(this._network);

  static const GooglePayCardNetwork AMEX = const GooglePayCardNetwork._('AMEX');
  static const GooglePayCardNetwork DISCOVER =
      const GooglePayCardNetwork._('DISCOVER');
  static const GooglePayCardNetwork JCB = const GooglePayCardNetwork._('JCB');
  static const GooglePayCardNetwork MASTERCARD =
      const GooglePayCardNetwork._('MASTERCARD');
  static const GooglePayCardNetwork VISA = const GooglePayCardNetwork._('VISA');
  static const GooglePayCardNetwork INTERAC =
      const GooglePayCardNetwork._('INTERAC');
  static const GooglePayCardNetwork OTHER =
      const GooglePayCardNetwork._('OTHER');

  factory GooglePayCardNetwork(String network) {
    if (network == null) return null;
    GooglePayCardNetwork _curNetwork = GooglePayCardNetwork._(network);
    if (values.contains(_curNetwork)) {
      return _curNetwork;
    } else {
      throw ArgumentError('Unsupported GooglePay card network: $network.');
    }
  }

  String get value => _network;
  static const List<GooglePayCardNetwork> values = const [
    AMEX,
    DISCOVER,
    JCB,
    MASTERCARD,
    VISA,
    INTERAC,
    OTHER
  ];

  @override
  bool operator ==(dynamic other) {
    if (other is GooglePayCardNetwork) {
      return other._network == _network;
    }
    return false;
  }

  @override
  int get hashCode => _network.hashCode;

  String get json => _network;

  @override
  String toString() => _network;
}
