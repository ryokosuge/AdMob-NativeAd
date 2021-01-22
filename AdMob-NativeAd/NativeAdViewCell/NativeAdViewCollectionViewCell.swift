//
//  NativeAdViewCollectionViewCell.swift
//  AdMob-NativeAd
//
//  Created by ryokosuge on 2021/01/22.
//

import UIKit
import GoogleMobileAds

class NativeAdViewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nativeAdView: NativeAdView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func render(ad: GADUnifiedNativeAd) {
        nativeAdView?.render(ad: ad)
    }

}
