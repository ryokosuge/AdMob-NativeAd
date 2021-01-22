//
//  NativeAdLoader.swift
//  AdMob-NativeAd
//
//  Created by ryokosuge on 2021/01/22.
//

import Foundation
import GoogleMobileAds

public class NativeAdLoader: NSObject {

    let cacheCount: Int
    private let adLoader: GADAdLoader

    private var ads: [GADUnifiedNativeAd] = []

    init(adUnitID: String, rootViewController: UIViewController, cacheCount: Int) {
        self.cacheCount = cacheCount
        // image option
        let imageOption = GADNativeAdImageAdLoaderOptions()

        // video option
        let videoOption = GADVideoOptions()

        // media option
        let mediaOption = GADNativeAdMediaAdLoaderOptions()

        let options = [imageOption, videoOption, mediaOption]

        self.adLoader = GADAdLoader(adUnitID: adUnitID,
                                    rootViewController: rootViewController,
                                    adTypes: [.unifiedNative],
                                    options: options)

        super.init()
        self.adLoader.delegate = self
    }

    public func load() {
        loadNativeAdIfNeeded()
    }

    public func refresh() {
        ads.forEach { (ad) in
            ad.unregisterAdView()
        }
        ads.removeAll()
        loadNativeAdIfNeeded()
    }

    public func get(at index: Int) -> GADUnifiedNativeAd? {
        guard index < ads.count else {
            return nil
        }

        return ads[index]
    }

}

// MARK: - GADUnifiedNativeAdLoaderDelegate
extension NativeAdLoader: GADUnifiedNativeAdLoaderDelegate {

    public func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        print("[AdMob-NativeAd]", #function, nativeAd)
        print("[AdMob-NativeAd]", "adNetworkClassName:  \(nativeAd.responseInfo.adNetworkClassName ?? "nil")")
        ads.append(nativeAd)
        loadNativeAdIfNeeded()
    }

    public func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("[AdMob-NativeAd]", #function, "error:    \(error)")
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(3)) {[weak self] in
            self?.loadNativeAdIfNeeded()
        }
    }
    
}

// MARK: - private
extension NativeAdLoader {

    private func loadNativeAdIfNeeded() {
        guard ads.count <= cacheCount else {
            return
        }

        adLoader.load(GADRequest())
    }

}
