//
//  UIView+Extension.swift
//  Gardner
//
//  Created by Rashid Khan on 05/05/2023.
//

import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }
}
