//
//  UIViewController+Snackbar.swift
//  Gardner
//
//  Created by Rashid Khan on 06/05/2023.
//

import UIKit
import TTGSnackbar
import ProgressHUD

extension UIViewController {
    func showSnackBar(message: String) {
        let snackbar = TTGSnackbar(message: message, duration: .middle)

        snackbar.show()
    }
    
    func stopLoader() {
        ProgressHUD.dismiss()
    }
    
    func startLoader() {
        
        
        
        
        ProgressHUD.show("Loading ... ")
    }

}
