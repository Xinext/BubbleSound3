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
    
    // MARK: - Private variable
    private var adMgr = AdModMgr()
    private var firstAppear: Bool = false
    
    // MARK: - ViewController Override
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    /**
     [EventHandler]デバイス回転時
     */
    @objc func changeDirection(notification: NSNotification){
        adMgr.AdjustPosition(viewWidth: outletADView.frame.size.width)    // 広告の表示
    }
}
