//
//  ApplicationTheme.swift
//  Gardner
//
//  Created by Rashid Khan on 05/05/2023.
//

import UIKit

protocol AppThemeType {
    var primaryColor: UIColor { get }
    var primaryLightColor: UIColor { get }
    
    var whiteColor: UIColor { get }
    var blackColor: UIColor { get }
    var lightBlackColor: UIColor { get }
}

struct DefaultTheme: AppThemeType {
    var primaryColor: UIColor { UIColor(named: "primaryColor")! }
    var primaryLightColor: UIColor { UIColor(named: "")! }
    var whiteColor: UIColor { UIColor(named: "whiteColor")! }
    var blackColor: UIColor { UIColor(named: "blackColor")! }
    var lightBlackColor: UIColor { UIColor(named: "lightBlackColor")! }
}

struct ApplicationTheme {
    static var currentTheme: AppThemeType = DefaultTheme()
}
