import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:yandex_kassa/models/amount.dart';
import 'package:yandex_kassa/models/android_color_scheme.dart';
import 'package:yandex_kassa/models/android_test_mode_settings.dart';
import 'package:yandex_kassa/models/google_pay_card_network.dart';
import 'package:yandex_kassa/models/ios_color_scheme.dart';
import 'package:yandex_kassa/models/ios_test_mode_settings.dart';
import 'package:yandex_kassa/models/json_encodable.dart';
import 'package:yandex_kassa/models/payment_method.dart';
import 'package:yandex_kassa/models/save_payment_method_mode.dart';

class PaymentParameters implements JsonEncodable {
  /// Total cost of the payment
  final Amount amount;

  /// The name of the purchase/shop (title)
  final String purchaseName;

  /// Description of the purchase (subtitle)
  final String purchaseDescription;

  /// Merchant token from Yandex.Checkout (https://kassa.yandex.ru/my/api-keys-settings)
  final String clientApplicationKey;

  /// Mode of saving payment method. Can be used for recurrent payments
  final SavePaymentMethodMode savePaymentMethodMode;

  /// Allowed payment methods
  final List<PaymentMethod> paymentMethods;

  /// Gateway id for the shop from Yandex.Money
  final String gatewayId;

  /// Return url of the page after 3ds secure payment. Supported only https. Should be used only for you custom Activity for 3ds url
  final String returnUrl;

  /// Phone number of the user. Is used for [PaymentMethod.sberbank] payment method. Should be in "+7XXXXXXXXXX" format
  final String userPhoneNumber;

  /// Shows Yandex.Checkout logo. Is true by default
  final bool showYandexCheckoutLogo;

// >>>>>>>IOS SPECIFIC FIELDS<<<<<<<
  /// IOS test mode settings
  final IosTestModeSettings iosTestModeSettings;

  /// ApplePay merchant id. Obligatory for [PaymentMethod.applePay]
  final String applePayMerchantIdentifier;

  /// Enables logging of network requests
  final bool isLoggingEnabled;

  /// Color scheme for essential elements, such as buttons, switches, etc. [IosColorScheme.blueRibbon] by default
  final IosColorScheme iosColorScheme;
// <<<<<<IOS SPECIFIC FIELDS>>>>>>>>

// >>>>>>>ANDROID SPECIFIC FIELDS<<<<<<<
  /// Android test mode settings
  final AndroidTestModeSettings androidTestModeSettings;

  /// Color scheme for essential elements, such as buttons, switches, etc. Should not be very light
  final AndroidColorScheme androidColorScheme;

  /// Shop id from Yandex.Checkout
  final String shopId;

  /// GooglePay card settings
  final List<GooglePayCardNetwork> googlePayParameters;
// <<<<<<ANDROID SPECIFIC FIELDS>>>>>>>>

  PaymentParameters({
    @required this.amount,
    @required this.purchaseName,
    @required this.purchaseDescription,
    @required this.clientApplicationKey,
    this.savePaymentMethodMode = SavePaymentMethodMode.userSelects,
    this.paymentMethods = const [PaymentMethod.bankCard],
    this.showYandexCheckoutLogo,
    this.gatewayId,
    this.returnUrl,
    this.userPhoneNumber,
    this.iosTestModeSettings,
    this.isLoggingEnabled,
    this.iosColorScheme,
    this.applePayMerchantIdentifier,
    this.androidTestModeSettings,
    this.androidColorScheme,
    this.shopId,
    this.googlePayParameters,
  }) {
    assert(amount != null);
    assert(purchaseName != null);
    assert(purchaseDescription != null);
    assert(clientApplicationKey != null);
    if (Platform.isAndroid) {
      assert(shopId != null);
      if (paymentMethods.contains(PaymentMethod.googlePay)) {
        assert(googlePayParameters != null);
      }
    }
    if (Platform.isIOS) {
      if (paymentMethods.contains(PaymentMethod.applePay)) {
        assert(applePayMerchantIdentifier != null);
      }
    }
  }

  @override
  Map<String, dynamic> get json => {
        'amount': amount.json,
        'purchaseName': purchaseName,
        'purchaseDescription': purchaseDescription,
        'clientApplicationKey': clientApplicationKey,
        'savePaymentMethodMode': savePaymentMethodMode.json,
        'paymentMethods':
            paymentMethods?.map((method) => method.json)?.toList(),
        'gatewayId': gatewayId,
        'returnUrl': returnUrl,
        'userPhoneNumber': userPhoneNumber,
        'showYandexCheckoutLogo': showYandexCheckoutLogo,
        'iosTestModeSettings': iosTestModeSettings?.json,
        'applePayMerchantIdentifier': applePayMerchantIdentifier,
        'isLoggingEnabled': isLoggingEnabled,
        'iosColorScheme': iosColorScheme?.json,
        'androidTestModeSettings': androidTestModeSettings?.json,
        'androidColorScheme': androidColorScheme?.json,
        'shopId': shopId,
        'googlePayParameters':
            googlePayParameters?.map((param) => param.json)?.toList()
      }..removeWhere((key, val) => val == null);

  @override
  String toString() => json.toString();
}
