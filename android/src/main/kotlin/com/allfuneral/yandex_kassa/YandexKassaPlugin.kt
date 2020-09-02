package com.allfuneral.yandex_kassa

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import ru.yandex.money.android.sdk.*


/** YandexKassaPlugin */
public class YandexKassaPlugin : FlutterPlugin, MethodCallHandler, YandexKassa() {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "yandex_kassa")
        channel.setMethodCallHandler(this);
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "yandex_kassa")
            channel.setMethodCallHandler(YandexKassaPlugin())
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

        when (call.method) {
            "startCheckout", "confirm3dsCheckout", "startCheckoutWithCvcRepeatRequest" -> {

                val amount = call.argument<HashMap<String, *>>("amount")
                val purchaseName = call.argument<String>("purchaseName")
                val purchaseDescription = call.argument<String>("purchaseDescription")
                val clientApplicationKey = call.argument<String>("clientApplicationKey")
                val savePaymentMethodMode = call.argument<String>("savePaymentMethodMode")
                val paymentMethods = call.argument<List<String>>("paymentMethods")
                val gatewayId = call.argument<String>("gatewayId")
                val returnUrl = call.argument<String>("returnUrl")
                val userPhoneNumber = call.argument<String>("userPhoneNumber")
                val showYandexCheckoutLogo = call.argument<Boolean?>("showYandexCheckoutLogo")
                val androidTestModeSettings = call.argument<HashMap<String, *>>("androidTestModeSettings")
                val androidColorScheme = call.argument<HashMap<String, *>>("androidColorScheme")
                val shopId = call.argument<String>("shopId")
                val googlePayParameters = call.argument<List<String>>("googlePayParameters")

                if (amount == null || purchaseName == null || purchaseDescription == null || clientApplicationKey == null || shopId == null || paymentMethods == null)
                    result.success(
                            PaymentResult(success = false, error = "Android could not extract one of obligatory arguments " +
                                    "(clientApplicationKey, paymentMethods, purchaseName, purchaseDescription, amount) \n" +
                                    "in flutter channel method: (openPaymentScreen)").toMap())
                val paymentParameters = PaymentParameters(
                        fetchAmount(amount)!!,
                        purchaseName!!,
                        purchaseDescription!!,
                        clientApplicationKey!!,
                        shopId!!,
                        fetchSavePaymentMethod(savePaymentMethodMode),
                        fetchPaymentMethods(paymentMethods),
                        gatewayId,
                        returnUrl,
                        userPhoneNumber,
                        GooglePayParameters(fetchGooglePayParameters(googlePayParameters))
                )

                if (call.method == "confirm3dsCheckout") {
                    val confirmationUrl = call.argument<String>("confirmationUrl")
                    confirm3dsCheckout(paymentParameters, confirmationUrl!!, fetchTokenizationResultHandler(result), fetchTestParameters(androidTestModeSettings), fetchUiParameters(showYandexCheckoutLogo
                            ?: true, androidColorScheme))
                } else {
                    if (call.method == "startCheckout") {
                        startCheckout(paymentParameters, fetchTokenizationResultHandler(result), fetchTestParameters(androidTestModeSettings), fetchUiParameters(showYandexCheckoutLogo
                                ?: true, androidColorScheme))
                    } else if (call.method == "startCheckoutWithCvcRepeatRequest") {
                        val paymentId = call.argument<String>("paymentId")
                        val savedBankCardPaymentParameters = SavedBankCardPaymentParameters(
                                fetchAmount(amount)!!,
                                purchaseName,
                                purchaseDescription,
                                clientApplicationKey,
                                shopId,
                                paymentId!!,  fetchSavePaymentMethod(savePaymentMethodMode))
                        startCheckoutWithCvcRepeatRequest(savedBankCardPaymentParameters, fetchTokenizationResultHandler(result), fetchTestParameters(androidTestModeSettings), fetchUiParameters(showYandexCheckoutLogo
                                ?: true, androidColorScheme))
                    }
                }
            }
            else -> result.notImplemented()
        }
    }

    private fun fetchTokenizationResultHandler(result: Result): TokenizationResultCallback {
        return object : TokenizationResultCallback {
            override fun success(tokenizationResult: TokenizationResult?) = result.success(
                    PaymentResult(success = true, paymentData = tokenizationResult).toMap())

            override fun failure(error: String) = result.success(
                    PaymentResult(success = false, error = error).toMap())
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

}
