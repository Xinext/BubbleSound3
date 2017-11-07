//
//  AdModMgr.swift
//

import UIKit
import GoogleMobileAds

/**
 AdMod管理用 UIViewController
 - Author: xinext HF
 - Copyright: xinext
 - Date: 2017/11/07
 - Version: 2.0.0
 - Remark: ADMOD_UNITID 及び、ADMOD_TESTID を別途定義する必要があります。
           それぞれのIDはGoogle AdModの仕様に従って取得してください。
           また、リリース時は、ADMOD_TESTIDをセットしない様にTestModeをfalseへ設定してください。
 */
class AdModMgr: UIViewController, GADBannerViewDelegate {
    
    // MARK: - Internal variable
    let m_ADBannerView = GADBannerView(adSize:kGADAdSizeSmartBannerPortrait)
    
    
    // MARK: - Public method
    /**
     ADマネージャーの初期化
     - parameter pvc: ADをつけるUIViewの親UIViewController
     - parameter adView: 広告エリアのUIView
     - parameter hightLC: ADViewのHightNSLayoutConstraint
     */
    func InitManager(pvc: UIViewController, adView: UIView, hightLC: NSLayoutConstraint) {

        // Delegateを受け取るControllerを親ViewControllerへ登録
        pvc.addChildViewController(self)
        
        // AdMod初期設定
        m_ADBannerView.isHidden = true
        m_ADBannerView.adUnitID = ADMOD_UNITID
        m_ADBannerView.delegate = self
        m_ADBannerView.rootViewController = self
        
        // 広告Viewの生成
        let gadRequest:GADRequest = GADRequest()
        m_ADBannerView.load(gadRequest)
        
        // 広告Viewを追加
        adView.addSubview(m_ADBannerView)
        m_ADBannerView.isHidden = false
        
        // ContentsViewを広告の分だけ縮める
        hightLC.constant += m_ADBannerView.bounds.size.height
    }
    
    /**
     広告の表示位置を調整
     */
    func AdjustPosition(viewWidth: CGFloat) {
        m_ADBannerView.frame.origin.x = (viewWidth / 2) - (m_ADBannerView.frame.size.width / 2)
        m_ADBannerView.frame.origin.y = 0
    }
}
