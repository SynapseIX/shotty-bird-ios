//
//  AdsManager.swift
//  Shotty Bird iOS
//
//  Created by Jorge Tapia on 7/31/23.
//  Copyright © 2023 Komodo Life. All rights reserved.
//

import GoogleMobileAds

/// Ad manager delegate.
@objc protocol AdsManagerDelegate {
    @objc optional func adsDidLoad()
    @objc optional func adsDidFailToLoad(error: Error)
    @objc optional func adWillShow()
    @objc optional func adDidDismiss(withReward: Bool)
    @objc optional func didFailToShowAd(error: Error)
}

/// Ads manager class.
final class AdsManager: NSObject {
    /// Shared manager instance
    static let shared = AdsManager()
    
    /// Rewarded interstitial ad instance.
    private var rewardedInterstitialAd: GADRewardedInterstitialAd?
    /// Non-rewarded interstitial ad instance.
    private var interstitialAd: GADInterstitialAd?
    /// Dtermines if an extra life should be awarded for Slayer.
    private var awardsExtraLife = false
    /// DSetermines if the manager has been initialized.
    private(set) var isInitialized = false
    /// Determines if ads are loaded.
    private(set) var adsAreLoaded = false
    
    /// The manager delegate object.
    var delegate: AdsManagerDelegate? {
        didSet {
            if delegate == nil {
                awardsExtraLife = false
            }
        }
    }
    
    private override init() {
        super.init()
    }
    
    /// Initializes de Google Mobile Ads SDK.
    func initialize() {
        Task {
            if await !StoreManager.shared.unlockRemoveAds() && !isInitialized {
                await GADMobileAds.sharedInstance().start()
                #if DEBUG
                    GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["a960bf9981e0d32eacbefcf6351bc84c"]
                #endif
                loadAds()
                isInitialized = true
            }
        }
    }
    
    func loadAds() {
        if !adsAreLoaded {
            Task {
                if await !StoreManager.shared.unlockRemoveAds() {
                    do {
                        // Rewarded interstitial
                        rewardedInterstitialAd = try await GADRewardedInterstitialAd.load(withAdUnitID: Constants.rewardedInterstitialAdUnitID,
                                                                                      request: GADRequest())
                        rewardedInterstitialAd?.fullScreenContentDelegate = self
                        // Non-rewarded interstital
                        interstitialAd = try await GADInterstitialAd.load(withAdUnitID: Constants.interstitialAdUnitID,
                                                                      request: GADRequest())
                        interstitialAd?.fullScreenContentDelegate = self
                        // Update manager
                        adsAreLoaded = true
                        // Notify delegate
                        delegate?.adsDidLoad?()
                    } catch {
                        delegate?.adsDidFailToLoad?(error: error)
                    }
                }
            }
        }
    }
    
    func showRewardedInterstitial() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let rootViewController = appDelegate.window?.rootViewController as? GameViewController else {
            return
        }
        rewardedInterstitialAd?.present(fromRootViewController: rootViewController) {
            self.awardsExtraLife = true
        }
    }
    
    func showInterstitial() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let rootViewController = appDelegate.window?.rootViewController as? GameViewController else {
            return
        }
        awardsExtraLife = false
        interstitialAd?.present(fromRootViewController: rootViewController)
    }
}

// MARK: - GADFullScreenContentDelegate

extension AdsManager: GADFullScreenContentDelegate {
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        delegate?.didFailToShowAd?(error: error)
    }
    
    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        delegate?.adWillShow?()
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        rewardedInterstitialAd = nil
        interstitialAd = nil
        adsAreLoaded = false
        loadAds()
        delegate?.adDidDismiss?(withReward: awardsExtraLife)
    }
}

