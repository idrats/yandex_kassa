//
//  Helpers.swift
//  Pods
//
//  Created by Ilya Drats on 31.08.2020.
//

import Foundation
import YandexCheckoutPayments

func fetchColor(_ color: [String: Any]?) -> UIColor? {
    if (color == nil) {
        return nil
    }
    let red = (color?["red"] as? Float ?? 0) / Float(255)
    let green = (color?["green"] as? Float ?? 0) / Float(255)
    let blue = (color?["blue"]  as? Float ?? 0) / Float(255)
    let alpha = (color?["alpha"]  as? Float ?? 0) / Float(255)
    let white = color?["white"]
    if (white != nil) {
        return UIColor(white: CGFloat((white  as? Int ?? 0) / 255), alpha: CGFloat(alpha))
    } else {
        return UIColor(red: CGFloat(red), green:CGFloat(green), blue: CGFloat(blue), alpha:CGFloat(alpha))
    }
}


func fetchTokenizationSettings(paymentMethodsJson: [String]?, showYandexCheckoutLogo: Bool) -> TokenizationSettings {
    
    var paymentTypes: PaymentMethodTypes = []
    if (paymentMethodsJson?.contains("bank_card") ?? false) {
        paymentTypes.insert(.bankCard)
    }
    if (paymentMethodsJson?.contains("yandex_money") ?? false) {
        paymentTypes.insert(.yandexMoney)
    }
    if (paymentMethodsJson?.contains("apple_pay") ?? false) {
        paymentTypes.insert(.applePay)
    }
    if (paymentMethodsJson?.contains("sberbank") ?? false) {
        paymentTypes.insert(.sberbank)
    }
    
    return TokenizationSettings(
        paymentMethodTypes: paymentTypes,
        showYandexCheckoutLogo: showYandexCheckoutLogo
    )
}

func fetchCurrency(_ currency: String?) -> Currency {
    switch currency {
    case "RUB":
        return .rub
    case "EUR":
        return .eur
    case "USD":
        return .usd
    default:
        return .rub
    }
}

func fetchAmount(_ amountJson: [String: Any]) -> Amount{
    let value = amountJson["value"] as! Double
    return Amount(value: Decimal(Double(round(100*value)/100)), currency: fetchCurrency(amountJson["currency"] as? String))
}

func fetchSavePaymentMethodMode(_ savePaymentMethodMode: String?) -> YandexCheckoutPayments.SavePaymentMethod{
    switch savePaymentMethodMode {
    case "userSelects":
        return .userSelects
    case "on":
        return .on
    case "off":
        return .off
    default:
        return .off
    }
}
