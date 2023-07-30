//
//  StoreManager.swift
//  Shotty Bird iOS
//
//  Created by Jorge Tapia on 7/28/23.
//  Copyright © 2023 Komodo Life. All rights reserved.
//

import StoreKit

import StoreKit

/// The type of aler to display after an IAP operation.
enum StoreManagerAlertType {
    case purchased
    case restored
    case failed
    case disabled
    
    /// Builds an alert message for a given alert type.
    /// - Returns: An alert message.
    func message() -> String{
        switch self {
        case .purchased:
            return Constants.purchased
        case .restored:
            return Constants.purchaseRestored
        case .failed:
            return Constants.purchasesDisabled
        case .disabled:
            return Constants.purchaseFailed
        }
    }
}

/// Manager class for processing in-app purchases.
class StoreManager: NSObject {
    
    /// App Store Connect No Ads product ID.
    let noAdsProductID = "life.komodo.shottybird.noads"
    /// The IAP No Ads product.
    private(set) var noAdsProduct: SKProduct?
    /// Closure that handles the status of a purchase.
    var purchaseStatusHandler: ((StoreManagerAlertType) -> Void)?
    /// Shared manager instance.
    static let shared = StoreManager()
    
    private override init() {
        super.init()
    }
    
    /// Determines if in-app purchases can be made.
    /// - Returns: If purchases can be made: `true`. Otherwise: `false`.
    func canMakePurchases() -> Bool {
        SKPaymentQueue.canMakePayments()
    }
    
    /// Attempts to purchases No Ads.
    func purchaseNoAds() {
        if canMakePurchases() {
            guard let noAdsProduct = noAdsProduct else {
                return
            }
            let payment = SKPayment(product: noAdsProduct)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            purchaseStatusHandler?(.disabled)
        }
    }
    
    /// Restores purchases made.
    func restorePurchase(){
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    /// Fetch available IAP products.
    func fetchAvailableProducts(){
        let productIdentifiers: Set = [noAdsProductID]
        let request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
    }
    
    /// Fetches the No Ads product price in local currency.
    /// - Returns: The formatted product price.
    func fetchPurchasePrice() -> String {
        guard let noAdsProduct = noAdsProduct else {
            return "N/A"
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.formatterBehavior = .behavior10_4
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = noAdsProduct.priceLocale
        guard let formattedPrice = numberFormatter.string(from: noAdsProduct.price) else {
            return "N/A"
        }
        return noAdsProduct.localizedDescription + "\n\(formattedPrice)"
    }
}

// MARK: - SKProductsRequestDelegate

extension StoreManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard let noAdsProduct = response.products.first else {
            return
        }
        self.noAdsProduct = noAdsProduct
    }
}

// MARK: - SKPaymentTransactionObserver

extension StoreManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        guard let transaction = transactions.first else {
            return
        }
        switch transaction.transactionState {
        case .purchased:
            SKPaymentQueue.default().finishTransaction(transaction)
            purchaseStatusHandler?(.purchased)
        case .restored:
            SKPaymentQueue.default().finishTransaction(transaction)
        case .failed:
            SKPaymentQueue.default().finishTransaction(transaction)
            purchaseStatusHandler?(.failed)
        default:
            break
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        purchaseStatusHandler?(.restored)
    }
}

