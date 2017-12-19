//
//  GameController.swift
//  BubbleSound
//

import UIKit
import AVFoundation

class GameController: NSObject, BubbleViewDelegate, AVAudioPlayerDelegate {

    // MARK: Const value
    let MAX_GENERATED_BUBBLE = 10
    
    let URL_SE_BABY: URL! = Bundle.main.url(forResource: "SE/baby", withExtension: "wav")
    let URL_SE_DOG: URL! = Bundle.main.url(forResource: "SE/dog1", withExtension: "wav")
    
    // MARK: private variable
    private var m_generateBubbleTimer: Timer?
    private var m_gv: UIView
    private var m_bubbleViewArray: [BubbleView]
    private var m_bubbleBeatPlayerArray: [AVAudioPlayer]
    private var m_houseImageView: UIImageView!

    // MARK: Initializer
    /**
     Initializer
     - parameter gvc: UIViewController - for game view
     */
    init( gv: UIView ){
       
        m_gv = gv
        m_bubbleViewArray = []
        m_bubbleBeatPlayerArray = []
        m_houseImageView = nil

        super.init()
        
        initHouseImage()
        
        m_generateBubbleTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(GameController.generateBubble), userInfo: nil, repeats: true)
        m_generateBubbleTimer?.fire()
    }
    
    /**
     deinit
     */
    deinit {
        // ***** 停止・解放処理 *****
        
        // タイマーの停止
        m_generateBubbleTimer?.invalidate()
        m_generateBubbleTimer = nil
        
        // 全BubbleViewの解放
        for view in m_bubbleViewArray {
            view.removeFromSuperview()
        }
        
        // 背景の消去
        if ( m_houseImageView != nil ) {
            m_houseImageView.removeFromSuperview()
        }
    }
    
    // MARK: Callback function
    /**
     [Callback] Generate bubble timer
     - tm: Timer
     */
    @objc func generateBubble(tm: Timer) {

        if ( m_bubbleViewArray.count < MAX_GENERATED_BUBBLE ) {
            let view = BubbleView(pv: m_gv)
            view.delegate = self
            m_gv.addSubview(view)
            m_bubbleViewArray.append(view)
        }
    }
    
    // MARK: Delegate
    // タップ開始
    func WillBeatTarget(view: BubbleView) {

        // SEの選択
        var url: URL
        if ( view.m_bubbleType == .baby ) {
            url = URL_SE_BABY!
        }
        else {
            url = URL_SE_DOG!
        }

        // AVAudioPlayerの生成
        var player: AVAudioPlayer?
        do {
            player = try AVAudioPlayer(contentsOf: url)
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
            return
        }
        
        // SEの再生
        m_bubbleBeatPlayerArray.append(player!)
        player?.play()
    }
    
    // タップ終了
    func DidBeatTarget(view: BubbleView) {
        
        m_bubbleViewArray.remove(object: view)
        view.removeFromSuperview()
    }
    
    // Sound終了
    func audioPlayerDidFinishPlaying( _ player: AVAudioPlayer, successfully flag: Bool) {
        m_bubbleBeatPlayerArray.remove(object: player)
    }
    
    // MARK: - Private method
    /**
     HouseImageViewの生成
     */
    private func initHouseImage() {
        
        // サイズ・位置の算出
        let ICON_SIZE = m_gv.frame.size.width / 3.2
        let POS_X = (m_gv.frame.width / 2) - (ICON_SIZE / 2)
        let POS_Y = (m_gv.frame.height / 2) - (ICON_SIZE / 2)
        let viewRect = CGRect(x: POS_X, y: POS_Y, width: ICON_SIZE, height: ICON_SIZE)
        
        // SubViewを生成してイメージを設定
        m_houseImageView = UIImageView(frame: viewRect)
        let img = UIImage(named:"image/house.png")!
        m_houseImageView?.image = img
        
        // GameViewへ追加
        m_gv.addSubview(m_houseImageView!)
    }
    
    // MARK: - Public method
    func UpdateOrientation(_ orientation: UIDeviceOrientation) {
        m_houseImageView?.rotateView(UIDevice.current.orientation)
    }

}
