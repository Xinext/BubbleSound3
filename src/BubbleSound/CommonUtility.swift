//
//  CommonUtility.swift
//

import Foundation
import UIKit

/**
 - UIViewControllerへViewの回転機能を拡張
 */
extension UIViewController {

    /**
     指定されたデバイスの向きへ、Viewを回転させます。
     - parameter view: UIView
     - parameter orientation: UIDeviceOrientation
     */
    func rotateView( view: UIView, orientation: UIDeviceOrientation ) {
        
        var angle: CGFloat = 0
        
        switch UIDevice.current.orientation {
        case .portrait:
            angle = 0
        case .portraitUpsideDown:
            angle = 180
        case .landscapeLeft:
            angle = 90
        case .landscapeRight:
            angle = 270
        default:
            // faceUp,faceDown時は、可変させない
            break;
        }
        
        let radian = angle * CGFloat.pi / 180
        let transRotate = CGAffineTransform(rotationAngle: CGFloat(radian));
        view.transform = transRotate
    }

}


