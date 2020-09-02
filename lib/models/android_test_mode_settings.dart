import 'package:flutter/widgets.dart';

import 'json_encodable.dart';
import 'package:yandex_kassa/models/amount.dart';

/// Test mode allows checking the SDK processes without real data.
/// You can see how the SDK works in various conditions and generate a test token.
/// Mobile SDK doesn’t require Internet connection in test mode.
class AndroidTestModeSettings implements JsonEncodable {
  /// Displaying logs for mobile SDK.
  final bool showLogs;

  /// Enables GooglePay test environment. Every transaction via Google Pay will use [WalletConstants.ENVIRONMENT_TEST].
  /// Details: https://developers.google.com/pay/api/android/guides/test-and-deploy/integration-checklist#about-the-test-environment.
  final bool googlePayTestEnvironment;

  /// Test configuration settings. If this parameter is specified, mobile SDK will work in offline mode and generate a test token, which is not applicable to real payments
  final AndroidMockConfiguration mockConfiguration;

  const AndroidTestModeSettings(
      {this.showLogs = false,
      this.googlePayTestEnvironment = false,
      @required this.mockConfiguration});

  @override
  Map<String, dynamic> get json => {
        'show_logs': showLogs,
        'google_pay_test': googlePayTestEnvironment,
        'mock_config': mockConfiguration.json
      }..removeWhere((key, val) => val == null);
}

/// Mock configuration for offline test mode
class AndroidMockConfiguration implements JsonEncodable {
  /// Tokenization always returns an error.
  final bool completeWithError;

  /// User is always authorized.
  final bool paymentAuthPassed;

  /// Number of cards linked to user’s wallet.
  final int linkedCardsCount;

  /// Service fee amount
  final Amount serviceFee;

  const AndroidMockConfiguration(
      {this.completeWithError = false,
      this.paymentAuthPassed = false,
      this.linkedCardsCount = 1,
      @required this.serviceFee});

  @override
  Map<String, dynamic> get json => {
        'complete_with_error': completeWithError,
        'payment_auth_passed': paymentAuthPassed,
        'cards_count': linkedCardsCount,
        'amount': serviceFee?.json
      }..removeWhere((key, val) => val == null);

  @override
  String toString() => json.toString();
}
