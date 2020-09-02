import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:yandex_kassa/yandex_kassa.dart';
import 'package:http_client/console.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

final idempotenceKey = 'some_unique_idempotence_key' +
    DateTime.now().microsecondsSinceEpoch.toString();
const shopId = '732903'; //'some_shop_id';
const clientAppKey =
    'test_NzMyOTAzaVjlEeQvWy6yTp3ed3DU94VzW4Cb9FuWclI'; //'live_MTkzODU2VY5GiyQq2GMPsCQ0PW7f_RSLtJYOT-mp_CA';
const secretKey =
    'test_-ywZU_E9PCAQYH-O7dpM8Z0v92EqItHjXzT0o-JFtRo'; //'your secret key';

class _MyAppState extends State<MyApp> {
  final paymentParameters = PaymentParameters(
      amount: Amount(5),
      purchaseName: 'Product name',
      purchaseDescription: 'Some detailed description of current purchase',
      clientApplicationKey: clientAppKey,
      iosColorScheme: IosColorScheme.redOrange,
      paymentMethods: [PaymentMethod.bankCard, PaymentMethod.sberbank],
      applePayMerchantIdentifier: "merchant.ru.yandex.mobile.msdk.debug",
      androidColorScheme: IosColorScheme.redOrange,
      // iosTestModeSettings: IosTestModeSettings(charge: Amount(3.1415926)),
      googlePayParameters: GooglePayCardNetwork.values,
      shopId: shopId,
      returnUrl:
          "https://4081d9747ee2.ngrok.io/v1.3/verifications/yandex_checkout",
      androidTestModeSettings: AndroidTestModeSettings(
          mockConfiguration: AndroidMockConfiguration(
              serviceFee: Amount(3.1415926),
              paymentAuthPassed: true,
              completeWithError: false,
              linkedCardsCount: 3)));

  TokenizationResult tokenizationResult;
  Map paymentResult;
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('ru', 'RU'),
      ],
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Stack(children: [
          Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                Spacer(),
                Container(
                    child: OutlineButton(
                        child: const Text('Open payment screen'),
                        onPressed: () async {
                          final result = await YandexKassa.startCheckout(
                              paymentParameters);
                          setState(() {
                            tokenizationResult = result;
                          });
                        })),
                if (tokenizationResult != null) ...[
                  (tokenizationResult.success
                      ? Text(
                          'Token has been successfully received\nToken: ${tokenizationResult?.paymentData?.token ?? ""}\nPayment method: ${tokenizationResult?.paymentData?.paymentMethod ?? ""}',
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        )
                      : Text(
                          'An error occured\n${tokenizationResult.error}',
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        )),
                  if (tokenizationResult?.success == true)
                    OutlineButton(
                      child: Text('Send Token'),
                      onPressed: () async {
                        final httpClient = ConsoleClient();
                        setState(() => loading = true);
                        Request request = Request(
                            'POST',
                            Uri.parse(
                                'https://payment.yandex.net/api/v3/payments'),
                            headers: Headers(),
                            body: json.encode({
                              "payment_token":
                                  tokenizationResult.paymentData.token,
                              "amount": paymentParameters.amount.jsonIso4217,
                              "confirmation": {
                                "type": "redirect",
                                "return_url":
                                    "https://4081d9747ee2.ngrok.io/v1.3/verifications/yandex_checkout"
                              },
                              "metadata": {"my_key": "my_val"},
                              "description":
                                  paymentParameters.purchaseDescription
                            }));
                        request.headers.add("Idempotence-Key", idempotenceKey);
                        request.headers.add(
                            'Authorization',
                            "Basic " +
                                base64Encode(
                                    utf8.encode("$shopId:$secretKey")));
                        request.headers.add('Content-Type', 'application/json');
                        Response response = await httpClient.send(request);
                        paymentResult =
                            json.decode(await response.readAsString());
                        setState(() => loading = false);
                      },
                    ),
                  if (paymentResult != null)
                    Text(
                      paymentResult.toString(),
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    )
                ],
                Spacer(),
              ])),
          if (loading)
            Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black26,
                child: Center(child: CircularProgressIndicator()))
        ]),
      ),
    );
  }
}
