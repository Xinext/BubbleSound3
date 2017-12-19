//
//  BubbleView.swift
//  BubbleSound
//

import UIKit

// MARK: protocol
protocol BubbleViewDelegate: class {
    func WillBeatTarget( view: BubbleView )
    func DidBeatTarget( view: BubbleView )
}

class BubbleView: UIImageView {
    
    // MARK: delegate
    weak var delegate: BubbleViewDelegate?
    
    // MARK: private vriable
    private let m_orgFrameRect: CGRect
    private var m_moveSpeed_X: CGFloat
    private var m_moveSpeed_Y: CGFloat
    
    private let GRV_ACC: CGFloat = 0.3  // acceleration of gravity
    
    private var m_moveTimer: Timer?

    // MARK: public vriable
    enum BubbleType: String {
        case dog1 = "image/dog1.png"
        case dog2 = "image/dog2.png"
        case dog3 = "image/dog3.png"
        case dog4 = "image/dog4.png"
        case dog5 = "image/dog5.png"
        case baby = "image/baby.png"
        
        static let types: [BubbleType] = [.dog1, .dog2, .dog3, .dog4, .dog5, .baby]
    }
    
    let m_bubbleType: BubbleType
    
    // MARK: Initializer
    convenience init( pv: UIView ) {
        
        // frameの生成
        var imgSize: CGFloat
        if (pv.frame.size.width < pv.frame.size.height) {
            imgSize = pv.frame.size.width / 4
        }
        else {
            imgSize = pv.frame.size.height / 4
        }
        let px = pv.center.x - (imgSize / 2)
        let py = pv.center.y - (imgSize / 2)
        
        let viewRect = CGRect(x: px, y: py, width: imgSize, height: imgSize)
 
        // BubbleTypeの生成
        let randType = Int(arc4random_uniform(52) / 10)
        let bubbleType = BubbleView.BubbleType.types[randType]
        
        // 処理をイニシャライザへ移譲
        self.init( frame: viewRect, type: bubbleType )
    }
    
    /**
     for code
     - parameter frame: CGRect
     - parameter type: BubbleType
     */
    init( frame: CGRect, type: BubbleType ) {
        
        m_orgFrameRect = frame
        m_bubbleType = type
        
        m_moveSpeed_X = CGFloat(arc4random_uniform(20)) - 5.0
        m_moveSpeed_Y = CGFloat(arc4random_uniform(20)) - 5.0
        
        super.init(frame: frame)
        
        initView(type: type)
        self.isUserInteractionEnabled = true
        
        m_moveTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.onMoveTimer), userInfo: nil, repeats: true)
        m_moveTimer?.fire()
    }

    /**
     for storyboard
     This function has not implemented.
     So don't use this function.
     */
    required init(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }

    deinit {
        // タイマーの停止
        if m_moveTimer != nil {
            m_moveTimer?.invalidate()
            m_moveTimer = nil
        }
    }
    
    // MARK: private method
    /**
     Viewの初期化
     - parameter type: BubbleType
     */
    private func initView(type: BubbleType) {
        // 指定されたイメージを設定
        let img = UIImage(named:type.rawValue)!
        self.image = img
    }

    // MARK: - UIImageView Override
    /**
     [EventHandler]タッチ開始時
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // ターゲット命中をdelegate通知
        self.delegate?.WillBeatTarget(view: self)
        
        m_moveTimer?.invalidate()
        m_moveTimer = nil
        
        // ターゲット命中アニメーションスタート
        UIView.animate(withDuration: 0.5, animations: {
            // アニメーションの内容
            self.frame.size.height = self.frame.size.height / 2
            self.frame.size.width = self.frame.size.width / 2
            self.center = (self.superview?.center)!
            self.alpha = 0
            
        }, completion: { finished in
            // アニメーションの終了をdelegate通知
            self.delegate?.DidBeatTarget(view: self)
        })
    }
    
    // MARK: - Callback function
    /**
     [Callback]Bubble移動タイマー
     */
    @objc func onMoveTimer(tm: Timer) {

        if self.superview == nil {
            return
        }
        
        self.rotateView(UIDevice.current.orientation)
        
        switch UIDevice.current.orientation {
        case .portrait:
            m_moveSpeed_Y += GRV_ACC
        case .portraitUpsideDown:
            m_moveSpeed_Y -= GRV_ACC
        case .landscapeLeft:
            m_moveSpeed_X -= GRV_ACC
        case .landscapeRight:
            m_moveSpeed_X += GRV_ACC
        default:
            break
        }
        
        var viewRect = self.frame
        viewRect.origin.x += m_moveSpeed_X
        viewRect.origin.y += m_moveSpeed_Y
        
        let BUBBLE_SIZE = self.frame.size.width
        
        // y 座標が bottom より大きいなら地面と当たった事にする
        if(viewRect.origin.y > (self.superview?.frame.size.height)! - BUBBLE_SIZE){
            viewRect.origin.y = (self.superview?.frame.size.height)! - BUBBLE_SIZE    // y 座標を地面の位置まで戻す（めり込んでるので）
            m_moveSpeed_Y *= -1     // y 方向の速度の符号を反転させる
            m_moveSpeed_Y *= 1.0    // お好みの反発係数(0.0～1.0)を乗算
            m_moveSpeed_X *= 0.9    // お好みの摩擦係数(0.0～1.0)を x 方向の速度に乗算
        }
        
        // y 座標が 0 より小さいなら天井と当たった事にする
        if(viewRect.origin.y < 0){
            viewRect.origin.y = 0   // y 座標を地面の位置まで戻す（めり込んでるので）
            m_moveSpeed_Y *= -1     // y 方向の速度の符号を反転させる
            m_moveSpeed_Y *= 0.9    // お好みの反発係数(0.0～1.0)を乗算
        }
        
        // x 座標が 0 より小さいなら壁と当たった事にする
        if(viewRect.origin.x < 0){
            viewRect.origin.x = 0   // x 座標を壁の位置まで戻す（めり込んでるので）
            m_moveSpeed_X *= -1     // x 方向の速度の符号を反転させる
            m_moveSpeed_X *= 0.9    // お好みの反発係数(0.0～1.0)を乗算
        }
        
        // x 座標が witdh より大きいなら壁と当たった事にする
        if(viewRect.origin.x > (self.superview?.frame.size.width)! - BUBBLE_SIZE){
            viewRect.origin.x = (self.superview?.frame.size.width)! - BUBBLE_SIZE    // x 座標を壁の位置まで戻す（めり込んでるので）
            m_moveSpeed_X *= -1     // x 方向の速度の符号を反転させる
            m_moveSpeed_X *= 0.9    // お好みの反発係数(0.0～1.0)を乗算
        }
        
        // 座標をインスタンスの座標に反映
        self.frame = viewRect
    }
    
}
