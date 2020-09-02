package com.allfuneral.yandex_kassa

import ru.yandex.money.android.sdk.PaymentMethodType
import ru.yandex.money.android.sdk.TokenizationResult

interface TokenizationResultCallback {
    fun success(tokenizationResult: TokenizationResult?)
    fun failure(error: String)
}

fun TokenizationResult.toMap(): HashMap<String, String> = hashMapOf(
        "token" to this.paymentToken,
        "paymentMethod" to when (this.paymentMethodType) {
            PaymentMethodType.SBERBANK -> "sberbank"
            PaymentMethodType.BANK_CARD -> "bank_card"
            PaymentMethodType.GOOGLE_PAY -> "google_pay"
            PaymentMethodType.YANDEX_MONEY -> "yandex_money"
        }
)

data class PaymentResult(val success: Boolean, val paymentData: TokenizationResult? = null, val error: String? = null) {
    fun toMap(): Map<String, *> {
        val result = hashMapOf(
                "success" to success,
                "data" to paymentData?.toMap(),
                "error" to error
        )

        result.values.removeAll(sequenceOf(null))
        return result
    }
}