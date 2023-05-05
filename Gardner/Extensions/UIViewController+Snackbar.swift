//
//  UIViewController+Snackbar.swift
//  Gardner
//
//  Created by Rashid Khan on 06/05/2023.
//

import UIKit
import TTGSnackbar

extension UIViewController {
    func showSnackBar(message: String) {
        let snackbar = TTGSnackbar(message: message, duration: .middle)

        snackbar.show()
    }
}
