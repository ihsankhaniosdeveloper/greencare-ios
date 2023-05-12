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
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }
    
    func roundWithShadow(corners : CACornerMask, radius : CGFloat , withShadow: Bool = false) {
        if withShadow {
            self.layer.shadowOffset = CGSize(width: 0, height: -2)
            self.layer.shadowOpacity = 0.5
            self.layer.shadowRadius = 2
            self.layer.shadowColor = UIColor.black.withAlphaComponent(0.29).cgColor
        }
        
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
    }
}
