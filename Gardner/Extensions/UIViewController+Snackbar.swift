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

    func showConfirmationAlert(title: String, message: String, positiveActionTitle: String = "OK", positiveAction: @escaping ()->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: positiveActionTitle, style: .destructive, handler: { action in
            positiveAction()
        }))
        
        self.present(alert, animated: true)
    }
}
