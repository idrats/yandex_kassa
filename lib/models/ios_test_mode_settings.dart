import 'package:flutter/widgets.dart';
import 'package:yandex_kassa/models/amount.dart';

import 'json_encodable.dart';

class IosTestModeSettings implements JsonEncodable {
  /// A Boolean value that determines whether payment authorization has been completed.
  final bool paymentAuthorizationPassed;

  /// Cards count.
  final int cardsCount;

  /// The amount to be paid.
  final Amount charge;

  /// A Boolean value that determines whether the payment will end with an error.
  final bool enablePaymentError;

  /// Creates instance of `IosTestModeSettings`.
  ///
  /// - Parameters:
  ///   - paymentAuthorizationPassed: A Boolean value that determines whether
  ///                                 payment authorization has been completed.
  ///   - cardsCount: Cards count.
  ///   - charge: The amount to be paid.
  ///   - enablePaymentError: A Boolean value that determines whether the payment will end with an error.
  ///
  /// - Returns: Instance of `IosTestModeSettings`.
  IosTestModeSettings(
      {@required this.charge,
      this.cardsCount = 1,
      this.enablePaymentError = false,
      this.paymentAuthorizationPassed: true});

  @override
  Map<String, dynamic> get json => {
        'paymentAuthorizationPassed': paymentAuthorizationPassed,
        'cardsCount': cardsCount,
        'charge': charge?.json,
        'enablePaymentError': enablePaymentError
      }..removeWhere((key, val) => val == null);

  @override
  String toString() => json.toString();
}
