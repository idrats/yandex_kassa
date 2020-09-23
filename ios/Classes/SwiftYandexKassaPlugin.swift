import Flutter
import UIKit
import Foundation
import PassKit
import YandexCheckoutPayments
import YandexCheckoutPaymentsApi
//import CardIO

public class SwiftYandexKassaPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "yandex_kassa", binaryMessenger: registrar.messenger())
        let instance = SwiftYandexKassaPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "startCheckout" || call.method == "confirm3dsCheckout" || call.method == "startCheckoutWithCvcRepeatRequest") {
            
            guard let args = call.arguments else {
                result(TokenizationResult(success: false, error: "iOS could not extract one of obligatory arguments " +
                    "(clientApplicationKey, paymentMethods, purchaseName, purchaseDescription, amount) \n" +
                    "in flutter channel method: (\(call.method))").toMap())
                return
            }
            if let myArgs = args as? [String: Any],
                let clientApplicationKey = myArgs["clientApplicationKey"] as? String,
                let paymentMethodsJson = myArgs["paymentMethods"] as? [String],
                let shopName = myArgs["purchaseName"] as? String,
                let purchaseDescription = myArgs["purchaseDescription"] as? String,
                let amountJson = myArgs["amount"] as? [String: Any]
            {
                
                let testSettingsJson = myArgs["iosTestModeSettings"] as? [String: Any]
                var testSettings: TestModeSettings?
                if (testSettingsJson != nil) {
                    testSettings = TestModeSettings(paymentAuthorizationPassed: testSettingsJson!["paymentAuthorizationPassed"] as? Bool ?? false,
                                                    cardsCount: testSettingsJson!["cardsCount"] as? Int ?? 0,
                                                    charge: fetchAmount(testSettingsJson!["charge"] as! [String: Any]),
                                                    enablePaymentError: testSettingsJson!["enablePaymentError"] as? Bool ?? false)
                }
                
                let mainSchemeColor = fetchColor(myArgs["iosColorScheme"] as? [String: Any])
                var customizationSettings = CustomizationSettings()
                if (mainSchemeColor != nil) {
                    customizationSettings = CustomizationSettings(mainScheme: mainSchemeColor!)
                }
                
                let vc = RootViewController()
                
                vc.modalPresentationStyle = .overCurrentContext
                UIApplication.shared.delegate!.window!!.rootViewController!.present(vc, animated: false, completion: nil)
                
                
                if (call.method == "startCheckout") {
                    vc.startCheckout(
                        clientApplicationKey: clientApplicationKey,
                        shopName: shopName,
                        purchaseDescription: purchaseDescription,
                        gatewayId: myArgs["gatewayId"] as? String,
                        amount: fetchAmount(amountJson),
                        tokenizationSettings: fetchTokenizationSettings(
                            paymentMethodsJson: paymentMethodsJson,
                            showYandexCheckoutLogo: myArgs["showYandexCheckoutLogo"] as? Bool ?? true
                        ),
                        testModeSettings: testSettings,
                        applePayMerchantIdentifier:  myArgs["applePayMerchantIdentifier"] as? String,
                        returnUrl: myArgs["returnUrl"] as? String,
                        isLoggingEnabled: myArgs["isLoggingEnabled"] as? Bool ?? false,
                        userPhoneNumber: myArgs["userPhoneNumber"] as? String,
                        customizationSettings: customizationSettings,
                        savePaymentMethod: fetchSavePaymentMethodMode(myArgs["savePaymentMethodMode"] as? String)
                        )
                    { (_ response: Result<PaymentData, PaymentProcessError>) in
                        switch response {
                        case .success(let res):
                            result(TokenizationResult(success: true, data: res).toMap())
                        case .failure(let error):
                            result(TokenizationResult(success: false, error: error.localizedDescription).toMap())
                        }
                        vc.dismiss(animated: true, completion: nil)
                    }
                } else if (call.method == "confirm3dsCheckout"){
                    vc.confirm3dsCheckout(
                        confirmationUrl: myArgs["confirmationUrl"] as! String,
                        clientApplicationKey: clientApplicationKey,
                        shopName: shopName,
                        purchaseDescription: purchaseDescription,
                        gatewayId: myArgs["gatewayId"] as? String,
                        amount: fetchAmount(amountJson),
                        tokenizationSettings: fetchTokenizationSettings(
                            paymentMethodsJson: paymentMethodsJson,
                            showYandexCheckoutLogo: myArgs["showYandexCheckoutLogo"] as? Bool ?? true
                        ),
                        testModeSettings: testSettings,
                        applePayMerchantIdentifier:  myArgs["applePayMerchantIdentifier"] as? String,
                        returnUrl: myArgs["returnUrl"] as? String,
                        isLoggingEnabled: myArgs["isLoggingEnabled"] as? Bool ?? false,
                        userPhoneNumber: myArgs["userPhoneNumber"] as? String,
                        customizationSettings: customizationSettings,
                        savePaymentMethod: fetchSavePaymentMethodMode(myArgs["savePaymentMethodMode"] as? String)
                        )
                    { (_ response: Result<Bool, PaymentProcessError>) in
                        switch response {
                        case .success(_):
                            result(TokenizationResult(success: true).toMap())
                        case .failure(let error):
                            result(TokenizationResult(success: false, error: error.localizedDescription).toMap())
                        }
                        vc.dismiss(animated: true, completion: nil)
                    }
                } else if (call.method == "startCheckoutWithCvcRepeatRequest") {
                    let bankCardRepeatModuleInputData = BankCardRepeatModuleInputData(
                        clientApplicationKey: clientApplicationKey,
                        shopName: shopName,
                        purchaseDescription: purchaseDescription,
                        paymentMethodId: myArgs["paymentId"] as! String,
                        amount: fetchAmount(amountJson),
                        testModeSettings: testSettings,
                        returnUrl: myArgs["returnUrl"] as? String,
                        isLoggingEnabled: myArgs["isLoggingEnabled"] as? Bool ?? false,
                        customizationSettings: customizationSettings,
                        savePaymentMethod: fetchSavePaymentMethodMode(myArgs["savePaymentMethodMode"] as? String)
                    )
                    vc.startCheckoutWithCvcRepeatRequest(bankCardRepeatModuleInputData)
                    { (_ response: Result<PaymentData, PaymentProcessError>) in
                        switch response {
                        case .success(let res):
                            result(TokenizationResult(success: true, data: res).toMap())
                        case .failure(let error):
                            result(TokenizationResult(success: false, error: error.localizedDescription).toMap())
                        }
                        vc.dismiss(animated: true, completion: nil)
                    }
                }
            } else {
                result(TokenizationResult(success: false, error: "iOS could not extract one of obligatory arguments " +
                    "(clientApplicationKey, paymentMethods, purchaseName, purchaseDescription, amount) \n" +
                    "in flutter channel method: (\(call.method))").toMap())
            }
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    
}

typealias TokenizationCompletionHandler = ((_ result: Result<PaymentData, PaymentProcessError>) -> Void)
typealias Confirmation3dsCompletionHandler = ((_ result: Result<Bool, PaymentProcessError>) -> Void)

struct TokenizationResult: Codable{
    var success: Bool
    var data: PaymentData?
    var error: String?
    func toMap() -> [String: Any?] {
        return ["success": success, "error": error, "data": data?.toMap()].filter { (elem) -> Bool in
            elem.value != nil
        }
    }
}

struct PaymentData: Codable {
    var token: String
    var paymentMethod: String
    func toMap() -> [String: Any?] {
        return ["token": token, "paymentMethod": paymentMethod].filter { (elem) -> Bool in
            elem.value != nil
        }
    }
}

/// Decoding errors.
public enum PaymentProcessError: Error {
    case cancelled
}

final class RootViewController: UIViewController {
    
    private var onPaymentCompletionHandler: TokenizationCompletionHandler?
    private var on3dsConfirmationCompletionHandler: Confirmation3dsCompletionHandler?
    
    //    weak var cardScanningDelegate: CardScanningDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.isOpaque = false
    }
    
    public func startCheckout(
        /// Client application key.
        clientApplicationKey: String,
        /// Name of shop.
        shopName: String,
        /// Purchase description.
        purchaseDescription: String,
        /// Gateway ID. Setup, is provided at check in Yandex Checkout.
        /// The cashier at the division of payment flows within a single account.
        gatewayId: String?,
        /// Amount of payment.
        amount: Amount,
        /// Tokenization settings.
        tokenizationSettings: TokenizationSettings,
        /// Test mode settings.
        testModeSettings: TestModeSettings?,
        /// Apple Pay merchant ID.
        applePayMerchantIdentifier: String?,
        /// Return url for close 3ds.
        returnUrl: String?,
        /// Enable logging
        isLoggingEnabled: Bool,
        /// User phone number.
        /// Example: +X XXX XXX XX XX
        userPhoneNumber: String?,
        /// Settings to customize SDK interface.
        customizationSettings: CustomizationSettings,
        /// Setting for saving payment method.
        savePaymentMethod: YandexCheckoutPayments.SavePaymentMethod,
        completionHandler: @escaping TokenizationCompletionHandler
    ) {
        onPaymentCompletionHandler = completionHandler
        let inputData: TokenizationFlow = .tokenization(TokenizationModuleInputData(
            clientApplicationKey: clientApplicationKey,
            shopName: shopName,
            purchaseDescription: purchaseDescription,
            amount: amount,
            gatewayId: gatewayId,
            tokenizationSettings: tokenizationSettings,
            testModeSettings: testModeSettings,
            applePayMerchantIdentifier: applePayMerchantIdentifier,
            returnUrl: returnUrl,
            isLoggingEnabled: isLoggingEnabled,
            userPhoneNumber: userPhoneNumber,
            customizationSettings: customizationSettings,
            savePaymentMethod:savePaymentMethod
            //                    cardScanning: self
        ))
        
        let viewController = TokenizationAssembly.makeModule(
            inputData: inputData,
            moduleOutput: self
        )
        
        present(viewController, animated: true, completion: nil)
    }
    
    public func confirm3dsCheckout(
        /// Confirmation ulr from made payment data
        confirmationUrl: String,
        /// Client application key.
        clientApplicationKey: String,
        /// Name of shop.
        shopName: String,
        /// Purchase description.
        purchaseDescription: String,
        /// Gateway ID. Setup, is provided at check in Yandex Checkout.
        /// The cashier at the division of payment flows within a single account.
        gatewayId: String?,
        /// Amount of payment.
        amount: Amount,
        /// Tokenization settings.
        tokenizationSettings: TokenizationSettings,
        /// Test mode settings.
        testModeSettings: TestModeSettings?,
        /// Apple Pay merchant ID.
        applePayMerchantIdentifier: String?,
        /// Return url for close 3ds.
        returnUrl: String?,
        /// Enable logging
        isLoggingEnabled: Bool,
        /// User phone number.
        /// Example: +X XXX XXX XX XX
        userPhoneNumber: String?,
        /// Settings to customize SDK interface.
        customizationSettings: CustomizationSettings,
        /// Setting for saving payment method.
        savePaymentMethod: YandexCheckoutPayments.SavePaymentMethod,
        completionHandler: @escaping Confirmation3dsCompletionHandler
    ) {
        on3dsConfirmationCompletionHandler = completionHandler
        let inputData: TokenizationFlow = .tokenization(TokenizationModuleInputData(
            clientApplicationKey: clientApplicationKey,
            shopName: shopName,
            purchaseDescription: purchaseDescription,
            amount: amount,
            gatewayId: gatewayId,
            tokenizationSettings: tokenizationSettings,
            testModeSettings: testModeSettings,
            applePayMerchantIdentifier: applePayMerchantIdentifier,
            returnUrl: returnUrl,
            isLoggingEnabled: isLoggingEnabled,
            userPhoneNumber: userPhoneNumber,
            customizationSettings: customizationSettings,
            savePaymentMethod:savePaymentMethod
        ))
        
        let viewController = TokenizationAssembly.makeModule(
            inputData: inputData,
            moduleOutput: self
        )
        viewController.start3dsProcess(requestUrl: confirmationUrl)
    }
    
    public func startCheckoutWithCvcRepeatRequest(_
        bankCardRepeatModuleInputData: BankCardRepeatModuleInputData,
                                                  completionHandler: @escaping TokenizationCompletionHandler
    ) {
        onPaymentCompletionHandler = completionHandler
        let inputData: TokenizationFlow = .bankCardRepeat(bankCardRepeatModuleInputData)
        
        let viewController = TokenizationAssembly.makeModule(
            inputData: inputData,
            moduleOutput: self
        )
        
        present(viewController, animated: true, completion: nil)
    }
}

extension RootViewController: TokenizationModuleOutput {
    func tokenizationModule(_ module: TokenizationModuleInput,
                            didTokenize token: Tokens,
                            paymentMethodType: PaymentMethodType) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.onPaymentCompletionHandler?(Result.success(PaymentData(token: token.paymentToken, paymentMethod: paymentMethodType.rawValue)))
            strongSelf.dismiss(animated: true, completion: nil)
        }
    }
    
    func didFinish(on module: TokenizationModuleInput,
                   with error: YandexCheckoutPaymentsError?) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.onPaymentCompletionHandler?(Result.failure(.cancelled))
            strongSelf.dismiss(animated: true)
        }
    }
    
    func didSuccessfullyPassedCardSec(on module: TokenizationModuleInput) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.on3dsConfirmationCompletionHandler?(Result.success(true))
            strongSelf.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - CardScanning
//
//extension RootViewController: CardScanning {
//    var cardScanningViewController: UIViewController? {
//
//        guard let controller = CardIOPaymentViewController(paymentDelegate: self) else {
//            return nil
//        }
//
//        controller.suppressScanConfirmation = true
//        controller.hideCardIOLogo = true
//        controller.disableManualEntryButtons = true
//        controller.collectCVV = false
//
//        return controller
//    }
//}
//
//// MARK: - CardIOPaymentViewControllerDelegate
//
//extension RootViewController: CardIOPaymentViewControllerDelegate {
//    public func userDidProvide(_ cardInfo: CardIOCreditCardInfo!,
//                               in paymentViewController: CardIOPaymentViewController!) {
//        let scannedCardInfo = ScannedCardInfo(number: cardInfo.cardNumber,
//                                              expiryMonth: "\(cardInfo.expiryMonth)",
//                                              expiryYear: "\(cardInfo.expiryYear)")
//        cardScanningDelegate?.cardScannerDidFinish(scannedCardInfo)
//    }
//
//    public func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
//        cardScanningDelegate?.cardScannerDidFinish(nil)
//    }
//}
