package com.allfuneral.yandex_kassa

import android.app.Activity
import android.content.Intent
import android.util.Log
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry
import ru.yandex.money.android.sdk.*

const val REQUEST_TOKENIZE_CODE = 100


open class YandexKassa : ActivityAware, PluginRegistry.ActivityResultListener {
    private var binding: ActivityPluginBinding? = null
    private var callback: TokenizationResultCallback? = null

    private fun checkBinding(resultCallback: TokenizationResultCallback): Boolean {
        if (binding?.activity?.application == null) {
            resultCallback.failure("Fail to resolve Application on registration")
            return false
        }
        return true
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.binding = binding
        binding.addActivityResultListener(this)
    }

    fun startCheckout(paymentParameters: PaymentParameters, resultCallback: TokenizationResultCallback, testParameters: TestParameters, uiParameters: UiParameters) {
        if (!checkBinding(resultCallback)) return
        if (callback == null) {
            callback = resultCallback
            binding?.let {
                val intent: Intent = Checkout.createTokenizeIntent(
                        it.activity,
                        paymentParameters,
                        testParameters,
                        uiParameters
                )
                it.activity.startActivityForResult(intent, REQUEST_TOKENIZE_CODE)
            }
        }
    }


    fun startCheckoutWithCvcRepeatRequest(savedBankCardPaymentParameters: SavedBankCardPaymentParameters, resultCallback: TokenizationResultCallback, testParameters: TestParameters, uiParameters: UiParameters) {
        if (!checkBinding(resultCallback)) return
        if (callback == null) {
            callback = resultCallback
            binding?.let {
                val intent: Intent = Checkout.createSavedCardTokenizeIntent(
                        it.activity,
                        savedBankCardPaymentParameters,
                        testParameters,
                        uiParameters
                )
                it.activity.startActivityForResult(intent, REQUEST_TOKENIZE_CODE)
            }
        }
    }

    fun confirm3dsCheckout(paymentParameters: PaymentParameters, confirmationUri: String, resultCallback: TokenizationResultCallback, testParameters: TestParameters, uiParameters: UiParameters) {
        if (!checkBinding(resultCallback)) return
        if (callback == null) {
            callback = resultCallback
            binding?.let {
                //TODO: check if it is really needed
                Checkout.createTokenizeIntent(
                        it.activity,
                        paymentParameters,
                        testParameters,
                        uiParameters
                )
                val intent: Intent = Checkout.create3dsIntent(
                        it.activity,
                        confirmationUri
                )
                it.activity.startActivityForResult(intent, REQUEST_TOKENIZE_CODE)
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode != REQUEST_TOKENIZE_CODE) {
            callback = null
            return false
        }
        when (resultCode) {
            Activity.RESULT_OK -> {
                if (data != null && callback != null)
                    callback!!.success(Checkout.createTokenizationResult(data))
            }
            Activity.RESULT_CANCELED ->
                callback?.failure(binding!!.activity.getString(R.string.checkout_cancelled))

            Checkout.RESULT_ERROR -> {
                if (data != null && callback != null)
                    callback!!.failure(data.getStringExtra(Checkout.EXTRA_ERROR_DESCRIPTION)
                            ?: binding!!.activity.getString(R.string.checkout_general_error))
            }
            else -> {
                callback?.failure(binding!!.activity.getString(R.string.checkout_unknown_error))
                callback = null
                return false
            }
        }
        callback = null
        return true
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        this.binding?.removeActivityResultListener(this)
        this.binding = binding
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        binding?.removeActivityResultListener(this)
        binding = null
    }

    override fun onDetachedFromActivity() {
        binding?.removeActivityResultListener(this)
        binding = null
    }
}