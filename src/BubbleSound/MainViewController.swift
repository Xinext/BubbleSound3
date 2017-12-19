//
//  MainViewController.swift
//  BubbleSound
//

import UIKit
import GoogleMobileAds

class MainViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var outletADViewHightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var outletGameAreaView: UIView!
    @IBOutlet weak var outletADAreaView: UIView!
    
    // MARK: - Private variable
    private var adMgr = AdModMgr()
    private var m_gc: GameController?
    private var firstAppear: Bool = false
    
    // MARK: - ViewController Override
    /**
     画面の自動回転をさせない
     */
    override var shouldAutorotate: Bool {
        get {
            return false
        }
    }
    
    /**
     画面をPortraitに固定する
     */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
    
    /**
     [EventHandler]Viewの生成時
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.changeDirection), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    /**
     [EventHandler]Viewが表示される直前時
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 最初に表示される時の処理
        if (firstAppear != true) {
            outletGameAreaView.isHidden = true  // メインコンテンツの準備ができるまで非表示
        }
    }

    /**
     [EventHandler]Viewが表示された直後時
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 最初に表示される時の処理
        if (firstAppear != true) {
            
            // 広告マネージャーの初期化
            adMgr.InitManager(pvc: self, adView: outletADAreaView, hightLC: outletADViewHightLayoutConstraint)
            adMgr.AdjustPosition(viewWidth: outletADAreaView.frame.size.width)
            
            // ゲームコントローラーの開始
            m_gc = GameController(gv: outletGameAreaView)

            // メインコンテンツの準備が完了したので表示
            outletGameAreaView.isHidden = false
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
        m_gc?.UpdateOrientation( UIDevice.current.orientation)
    }
}
