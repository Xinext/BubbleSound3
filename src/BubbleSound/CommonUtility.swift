//
//  CommonUtility.swift
//

import Foundation
import UIKit

/**
 - UIViewControllerへViewの回転機能を拡張
 */
extension UIView {

    /**
     指定されたデバイスの向きへ、Viewを回転させます。
     - parameter view: UIView
     - parameter orientation: UIDeviceOrientation
     */
    func rotateView( _ orientation: UIDeviceOrientation ) {
        
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
        self.transform = transRotate
    }

}

/**
 - ArrayへElement指定型のremove機能を追加
 */
extension Array where Element: Equatable {

    mutating func remove(object: Element) {
        if let index = index(of: object){
            self.remove(at: index)
            self.remove(object: object)
        }
    }
    
}


