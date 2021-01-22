//
//  NativeAdView.swift
//  AdMob-NativeAd
//
//  Created by ryokosuge on 2021/01/22.
//

import UIKit
import GoogleMobileAds

class NativeAdView: UIView {

    private var contentView: UIView?
    
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

    override var intrinsicContentSize: CGSize {
        let width = self.bounds.width
        let height = width / 16.0 * 9.0
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        setup()
    }

    // MARK: - Rendering
    // 表示処理
    public func render(ad: GADUnifiedNativeAd) {
        mediaView?.mediaContent = ad.mediaContent
        headlineLabel?.text = ad.headline
        bodyLabel?.text = ad.body
        callToActionButton?.setTitle(ad.callToAction, for: .normal)
        iconImageView?.image = ad.icon?.image
        nativeAdView?.nativeAd = ad
    }

}

// MARK: - Private
extension NativeAdView {

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

// MARK: - Setup

extension NativeAdView {

    private func loadNib() {
        guard let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView else {
            fatalError("not found \(String(describing: type(of: self))).xib")
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)

        contentView = view

        NSLayoutConstraint.activate([
            // TOP
            NSLayoutConstraint(item: self,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: view,
                               attribute: .top,
                               multiplier: 1,
                               constant: 0),
            // Leading
            NSLayoutConstraint(item: self,
                               attribute: .leading,
                               relatedBy: .equal,
                               toItem: view,
                               attribute: .leading,
                               multiplier: 1,
                               constant: 0),
            // Bottom
            NSLayoutConstraint(item: view,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .bottom,
                               multiplier: 1,
                               constant: 0),
            // Trailing
            NSLayoutConstraint(item: view,
                               attribute: .trailing,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .trailing,
                               multiplier: 1,
                               constant: 0)
        ])
    }

    // xcode12.3だと何故かOutletが表示されないのでコードで紐付け
    private func setup() {
        nativeAdView?.mediaView = mediaView
        nativeAdView?.headlineView = headlineLabel
        nativeAdView?.bodyView = bodyLabel
        nativeAdView?.iconView = iconImageView
        nativeAdView?.callToActionView = callToActionButton
    }

}
