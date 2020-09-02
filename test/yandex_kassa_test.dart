import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yandex_kassa/kassa.dart';
import 'package:yandex_kassa/models/payment_parameters.dart';
import 'package:yandex_kassa/yandex_kassa.dart';

void main() {
  final paymentParameters = PaymentParameters(
    amount: Amount(5),
    purchaseName: 'Product name',
    purchaseDescription: 'Some detailed description of current purchase',
    clientApplicationKey: 'live_MTkzODU2VY5GiyQq2GMPsCQ0PW7f_RSLtJYOT-mp_CA',
    iosColorScheme: IosColorScheme.redOrange,
    paymentMethods: PaymentMethod.values,
    applePayMerchantIdentifier: "merchant.ru.yandex.mobile.msdk.debug",
    iosTestModeSettings: IosTestModeSettings(charge: Amount(3.1415926)),
  );
  final tokenizationResult = TokenizationResult(
      paymentData: PaymentData(
          paymentMethod: PaymentMethod.bankCard, token: "some_fake_token"),
      success: true);

  const MethodChannel channel = MethodChannel('yandex_kassa');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return json.encode(tokenizationResult.json);
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    final result = await YandexKassa.startCheckout(paymentParameters);

    expect(result.json, tokenizationResult.json);
  });
}
