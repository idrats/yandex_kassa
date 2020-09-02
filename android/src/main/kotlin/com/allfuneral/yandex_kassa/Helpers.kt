package com.allfuneral.yandex_kassa

import android.graphics.Color
import ru.yandex.money.android.sdk.*
import java.math.BigDecimal
import java.util.*
import kotlin.collections.HashMap
import kotlin.collections.HashSet

fun fetchAmount(map: HashMap<*, *>?): Amount? {
    if (map == null) return null
    return Amount(
            BigDecimal.valueOf(map["value"] as Double),
            Currency.getInstance(map["currency"] as String)
    )
}


fun fetchSavePaymentMethod(mode: String?): SavePaymentMethod {
    when (mode) {
        "on" -> return SavePaymentMethod.ON
        "off" -> return SavePaymentMethod.OFF
        "userSelects" -> return SavePaymentMethod.USER_SELECTS
    }
    return SavePaymentMethod.OFF
}


fun fetchPaymentMethods(methods: List<String>?): Set<PaymentMethodType> {
    val result: HashSet<PaymentMethodType> = HashSet()
    if (methods?.contains("bank_card")!!) {
        result.add(PaymentMethodType.BANK_CARD)
    }
    if (methods.contains("sberbank")) {
        result.add(PaymentMethodType.SBERBANK)
    }
    if (methods.contains("yandex_money")) {
        result.add(PaymentMethodType.YANDEX_MONEY)
    }
    if (methods.contains("google_pay")) {
        result.add(PaymentMethodType.GOOGLE_PAY)
    }
    return result
}

fun fetchGooglePayParameters(parameters: List<String>?): Set<GooglePayCardNetwork> {
    val result: HashSet<GooglePayCardNetwork> = HashSet()
    if (parameters?.contains("AMEX")!!) {
        result.add(GooglePayCardNetwork.AMEX)
    } else if (parameters.contains("DISCOVER")) {
        result.add(GooglePayCardNetwork.DISCOVER)
    } else if (parameters.contains("JCB")) {
        result.add(GooglePayCardNetwork.JCB)
    } else if (parameters.contains("MASTERCARD")) {
        result.add(GooglePayCardNetwork.MASTERCARD)
    } else if (parameters.contains("VISA")) {
        result.add(GooglePayCardNetwork.VISA)
    } else if (parameters.contains("INTERAC")) {
        result.add(GooglePayCardNetwork.INTERAC)
    } else if (parameters.contains("OTHER")) {
        result.add(GooglePayCardNetwork.OTHER)
    }
    return result
}


fun fetchMockConfiguration(data: HashMap<*, *>?): MockConfiguration {
    val completeWithError = data?.get("complete_with_error") as Boolean?
    val paymentAuthPassed = data?.get("payment_auth_passed") as Boolean?
    val cardsCount = data?.get("cards_count") as Int?
    val amount = data?.get("amount") as HashMap<*, *>?
    return MockConfiguration(completeWithError = completeWithError ?: false,
            paymentAuthPassed = paymentAuthPassed ?: false,
            linkedCardsCount = cardsCount ?: 0,
            serviceFee = fetchAmount(amount)
    )
}


fun fetchTestParameters(data: HashMap<String, *>?): TestParameters {
    val showLogs = data?.get("show_logs") as Boolean?
    val googlePayTestEnvironment = data?.get("google_pay_test") as Boolean?
    val mockConfiguration = data?.get("mock_config") as HashMap<*, *>?
    return TestParameters(showLogs = showLogs ?: true,
            googlePayTestEnvironment = googlePayTestEnvironment ?: true,
            mockConfiguration = fetchMockConfiguration(mockConfiguration))
}


fun fetchColorScheme(data: HashMap<String, *>?): ColorScheme {
    if (data == null) return ColorScheme.getDefaultScheme()
    val color = Color.rgb(data["red"] as Int, data["green"] as Int, data["blue"] as Int)
    return ColorScheme(color)
}

fun fetchUiParameters(showLogo: Boolean, colorData: HashMap<String, *>?): UiParameters =
        UiParameters(showLogo = showLogo, colorScheme = fetchColorScheme(colorData))
