//
//  StoreManager.swift
//  Shotty Bird iOS
//
//  Created by Jorge Tapia on 7/28/23.
//  Copyright © 2023 Komodo Life. All rights reserved.
//

import StoreKit

/// In-app purchase transation error.
enum StoreKitError: Error {
    case failedVerification
    case unableToSync
    case unknownError
}

/// In-app purchase transaction status.
enum PurchaseStatus {
    case success(String)
    case pending
    case cancelled
    case failed(Error)
    case unknown
}

/// Footprint for store manager implementations.
protocol StoreKitManageable {
    func retrieveProducts() async
    func purchase(_ item: Product) async
    func verifyPurchase<T>(_ verificationResult: VerificationResult<T>) throws -> T
    func transactionStatusStream() -> Task<Void, Error>
}

/// Manager class for processing in-app purchases.
class StoreManager: ObservableObject {
    
    /// Shared manager instance.
    static let shared = StoreManager()
    /// The No Ads product ID.
    static let noAdsProductID = "life.komodo.shottybird.noads"
    
    @Published private(set) var items = [Product]()
    @Published var transactionCompletionStatus = false
    
    private let productIds = [StoreManager.noAdsProductID]
    private(set) var purchaseStatus: PurchaseStatus = .unknown
    private(set) var transactionListener: Task<Void, Error>?
    
    init() {
        transactionListener = transactionStatusStream()
        Task {
            await retrieveProducts()
        }
    }
    
    deinit {
        transactionListener?.cancel()
    }
    
    /// Retrieves all of the in-app products.
    func retrieveProducts() async {
        do {
            let products = try await Product.products(for: productIds)
            items = products.sorted(by: { $0.price < $1.price })
        } catch {
            print(error)
        }
    }
    
    /// Purchases the in-app product.
    /// - Parameter item: The product to purchase.
    func purchase(_ item: Product) async {
        do {
            let result = try await item.purchase()
            
            switch result {
            case .success(let verification):
                print("Purchase was a success, now it can be verified.")
                do {
                    let verificationResult = try verifyPurchase(verification)
                    purchaseStatus = .success(verificationResult.productID)
                    await verificationResult.finish()
                    transactionCompletionStatus = true
                } catch {
                    purchaseStatus = .failed(error)
                    transactionCompletionStatus = true
                }
            case .pending:
                print("Transaction is pending for some action from the users related to the account")
                purchaseStatus = .pending
                transactionCompletionStatus = false
            case .userCancelled:
                print("Use cancelled the transaction")
                purchaseStatus = .cancelled
                transactionCompletionStatus = false
            default:
                print("Unknown error")
                purchaseStatus = .failed(StoreKitError.unknownError)
                transactionCompletionStatus = false
            }
        } catch {
            print(error)
            purchaseStatus = .failed(error)
            transactionCompletionStatus = false
        }
    }
    
    /// Verifies a purchase.
    /// - Parameter verificationResult: The verification result.
    /// - Returns: A result with the verification status or an error.
    func verifyPurchase<T>(_ verificationResult: VerificationResult<T>) throws -> T {
        switch verificationResult {
        case .unverified(_, let error):
            throw error // Successful purchase but transaction/receipt can't be verified due to some conditions like jailbroken phone
        case .verified(let result):
            return result  // Successful purchase
        }
    }
    
    /// Handles Interruptions.
    func transactionStatusStream() -> Task<Void, Error> {
        Task.detached(priority: .background) { @MainActor [weak self] in
            do {
                for await result in Transaction.updates {
                    let transaction = try self?.verifyPurchase(result)
                    self?.purchaseStatus = .success(transaction?.productID ?? "Unknown product ID")
                    self?.transactionCompletionStatus = true
                    await transaction?.finish()
                }
            } catch {
                self?.transactionCompletionStatus = true
                self?.purchaseStatus = .failed(error)
            }
        }
    }
    
    /// Unlock in-app features.
    func unlockNoAds() async -> Bool {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                return false
            }
            return transaction.ownershipType == .purchased
        }
        return false
    }
    
    /// Attempts to restore purchases by syncing transactions.
    func restorePurchases() async -> Result<Bool, Error> {
        do {
            try await AppStore.sync()
            return .success(true)
        } catch {
            return .failure(error)
        }
    }
}

