//
//  ViewController.swift
//  AdMob-NativeAd
//
//  Created by ryokosuge on 2021/01/13.
//

import UIKit
import GoogleMobileAds

private let adUnitID = "ca-app-pub-3010029359415397/6960102359"

private enum Content {
    case text(title: String, body: String)
    case ad(index: Int)
}

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView?

    // Native Ad Loader
    private lazy var loader: NativeAdLoader = {
        return NativeAdLoader(adUnitID: adUnitID, rootViewController: self, cacheCount: 10)
    }()

    private var contents: [Content] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loader.load()
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
        loader.refresh()
    }

}

// MARK: - Private
extension ViewController {

    private func setupView() {
        collectionView?.dataSource = self
        collectionView?.delegate = self

        registerCell(for: DefaultCollectionViewCell.self)
        registerCell(for: NativeAdViewCollectionViewCell.self)

        contents = (0..<100).map {
            return ($0 + 1) % 10 == 0 ? Content.ad(index: ($0 + 1) / 10 - 1) : Content.text(title: "title: \($0)", body: "body: \($0)")
        }
    }

    private func registerCell(for cellType: UICollectionViewCell.Type) {
        let nibName = String(describing: cellType)
        let nib = UINib(nibName: nibName, bundle: Bundle(for: cellType))
        collectionView?.register(nib, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }

    private func dequeueCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("not registered \(String(describing: T.self))")
        }
        return cell
    }

}

extension ViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 幅MAXは固定
        let width = collectionView.frame.width
        switch contents[indexPath.row] {
        case .text:
            // 適当に80固定
            return CGSize(width: width, height: 80)
        case .ad:
            // 16:9 + adInfoで80
            return CGSize(width: width, height: round(width * 9 / 16) + 80)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
}

extension ViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let content = contents[indexPath.row]
        switch content {
        case let .text(title, body):
            let cell: DefaultCollectionViewCell = dequeueCell(for: indexPath)
            cell.titleLabel?.text = title
            cell.detailLabel?.text = body
            return cell
        case .ad(let index):
            let cell: NativeAdViewCollectionViewCell = dequeueCell(for: indexPath)
            if let ad = loader.get(at: index) {
                cell.render(ad: ad)
            }
            return cell
        }
    }

}

extension UICollectionViewCell {

    static var reuseIdentifier: String {
        return String(describing: self)
    }

}
