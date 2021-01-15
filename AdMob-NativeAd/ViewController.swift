//
//  ViewController.swift
//  AdMob-NativeAd
//
//  Created by ryokosuge on 2021/01/13.
//

import UIKit
import GoogleMobileAds
import NendAd

// test
// private let adUnitID = "ca-app-pub-3940256099942544/3986624511"
private let adUnitID = "ca-app-pub-3010029359415397/6960102359"

class ViewController: UIViewController {

    // Unified Native Ad View
    @IBOutlet weak var nativeAdView: GADUnifiedNativeAdView?

    // Media View
    @IBOutlet weak var mediaView: GADMediaView?

    // Media View Size Ratio Constraint
    @IBOutlet weak var sizeRatioConstraint: NSLayoutConstraint? {
        didSet {
            oldValue?.isActive = false
            sizeRatioConstraint?.isActive = true
        }
    }

    // Head Line Label
    @IBOutlet weak var headlineLabel: UILabel?

    // Body Label
    @IBOutlet weak var bodyLabel: UILabel?

    // Icon Image View
    @IBOutlet weak var iconImageView: UIImageView?

    // Call To Action Button
    @IBOutlet weak var callToActionButton: UIButton?

    // Native Ad Loader
    private lazy var loader: GADAdLoader = {
        // image option
        let imageOption = GADNativeAdImageAdLoaderOptions()

        // video option
        let videoOption = GADVideoOptions()

        // media option
        let mediaOption = GADNativeAdMediaAdLoaderOptions()

        let options = [imageOption, videoOption, mediaOption]

        let loader = GADAdLoader(adUnitID: adUnitID, rootViewController: self, adTypes: [GADAdLoaderAdType.unifiedNative], options: options)
        loader.delegate = self
        return loader
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNativeAdView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNativeAd()
    }

}

// MARK: - GADUnifiedNativeAdLoaderDelegate
extension ViewController: GADUnifiedNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        print("[AdMob-NativeAd]", #function, nativeAd)
        print("[AdMob-NativeAd]", "adNetworkClassName:  \(nativeAd.responseInfo.adNetworkClassName ?? "nil")")
        render(ad: nativeAd)
    }

    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("[AdMob-NativeAd]", #function, "error:    \(error)")
    }
    
}

// MARK: - GADUnifiedNativeAdDelegate
extension ViewController: GADUnifiedNativeAdDelegate {
    
    func nativeAdDidRecordImpression(_ nativeAd: GADUnifiedNativeAd) {
        // impression
        print("[AdMob-Native]", #function, nativeAd)
    }

    func nativeAdDidRecordClick(_ nativeAd: GADUnifiedNativeAd) {
        // click
        print("[AdMob-Native]", #function, nativeAd)
    }

    func nativeAdWillPresentScreen(_ nativeAd: GADUnifiedNativeAd) {
        // will present
        print("[AdMob-Native]", #function, nativeAd)
    }

    func nativeAdWillDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
        // will dismiss
        print("[AdMob-Native]", #function, nativeAd)
    }

    func nativeAdDidDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
        // did dismiss
        print("[AdMob-Native]", #function, nativeAd)
    }

    func nativeAdWillLeaveApplication(_ nativeAd: GADUnifiedNativeAd) {
        // leave application
        print("[AdMob-Native]", #function, nativeAd)
    }

    func nativeAdIsMuted(_ nativeAd: GADUnifiedNativeAd) {
        // muted
        print("[AdMob-Native]", #function, nativeAd)
    }

}

// MARK: - Action
extension ViewController {

    @IBAction private func refresh() {
        loadNativeAd()
    }

}

// MARK: - Private
extension ViewController {

    // xcode12.3だと何故かOutletが表示されないのでコードで紐付け
    private func setupNativeAdView() {
        nativeAdView?.mediaView = mediaView
        nativeAdView?.headlineView = headlineLabel
        nativeAdView?.bodyView = bodyLabel
        nativeAdView?.iconView = iconImageView
        nativeAdView?.callToActionView = callToActionButton
    }

    // 広告の読み込み
    private func loadNativeAd() {
        loader.load(GADRequest())
    }

    // 表示処理
    private func render(ad: GADUnifiedNativeAd) {
        if let view = mediaView {
            mediaView?.mediaContent = ad.mediaContent
            resizeMediaContent(aspectRatio: ad.mediaContent.aspectRatio, mediaView: view)
        }

        headlineLabel?.text = ad.headline
        bodyLabel?.text = ad.body
        callToActionButton?.setTitle(ad.callToAction, for: .normal)
        iconImageView?.image = ad.icon?.image
        nativeAdView?.nativeAd = ad
    }

    private func resizeMediaContent(aspectRatio: CGFloat, mediaView: UIView) {
        print("[AdMob-NativeAd]", "aspectRatio: \(aspectRatio)")
        let multiplier = 1.0 / aspectRatio
        let constraint = NSLayoutConstraint(item: mediaView,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: mediaView,
                                            attribute: .width,
                                            multiplier: multiplier,
                                            constant: 0)
        sizeRatioConstraint = constraint
    }

}
