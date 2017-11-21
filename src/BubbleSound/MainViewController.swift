//
//  MainViewController.swift
//  BubbleSound
//

import UIKit
import GoogleMobileAds

class MainViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet weak var outletADView: UIView!
    @IBOutlet weak var outletADViewHightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var outletMainContentsView: UIView!
    
    // MARK: - Private variable
    private var adMgr = AdModMgr()
    private var firstAppear: Bool = false
    
    private var m_houseImageView: UIImageView? = nil
    
    // MARK: - ViewController Override
    /**
     [EventHandler]Viewの生成時
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.changeDirection), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        // 背景を生成
        initHouseImage()
    }

    /**
     [EventHandler]Viewが表示される直前時
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 最初に表示される時の処理
        if (firstAppear != true) {
            //outletMainContentsAreaView.isHidden = true  // メインコンテンツの準備ができるまで非表示
        }
        
        // 広告マネージャーの初期化
        adMgr.InitManager(pvc: self, adView: outletADView, hightLC: outletADViewHightLayoutConstraint)
    }

    /**
     [EventHandler]Viewが表示された直後時
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 最初に表示される時の処理
        if (firstAppear != true) {
            //outletMainContentsAreaView.isHidden = false // メインコンテンツの準備が完了したので表示
            adMgr.AdjustPosition(viewWidth: outletADView.frame.size.width)    // 広告の表示
            firstAppear = true
        }
    }
    
    /**
     [EventHandler]メモリエラー発生時
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     [EventHandler]デバイス回転時
     */
    @objc func changeDirection(notification: NSNotification){

        self.rotateView(view: m_houseImageView!, orientation: UIDevice.current.orientation)
    }
    
    // MARK: - Private method
    /**
     HouseImageViewの生成
     */
    private func initHouseImage() {
        
        // サイズ・位置の算出
        let ICON_SIZE = self.view.frame.size.width / 3.2
        let POS_X = (self.view.frame.width / 2) - (ICON_SIZE / 2)
        let POS_Y = (self.view.frame.height / 2) - (ICON_SIZE / 2)
        let viewRect = CGRect(x: POS_X, y: POS_Y, width: ICON_SIZE, height: ICON_SIZE)
        
        // SubViewの生成してイメージを設定
        m_houseImageView = UIImageView(frame: viewRect)
        let img = UIImage(named:"image/house.png")!
        m_houseImageView!.image = img
        
        // MainViewへ追加
        self.view.addSubview(m_houseImageView!)
    }
}
