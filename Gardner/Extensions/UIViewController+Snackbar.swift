//
//  UIViewController+Snackbar.swift
//  Gardner
//
//  Created by Rashid Khan on 06/05/2023.
//

import UIKit
import TTGSnackbar
import KRProgressHUD

extension UIViewController {
    func showSnackBar(message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            let snackbar = TTGSnackbar(message: message, duration: .middle)
            
            
            
            snackbar.show()
        }
    }
    
    func startActivityIndicator() {
        KRProgressHUD
            .set(style: .white)
            .set(maskType: .black)
            .show()
    }
    
    func stopActivityIndicator() {
        KRProgressHUD.dismiss()
    }

    func showConfirmationAlert(title: String, message: String, positiveActionTitle: String = "OK", positiveAction: (()->())?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        if let positiveAction = positiveAction {
            alert.addAction(UIAlertAction(title: positiveActionTitle, style: .destructive, handler: { action in
                positiveAction()
            }))
        }
        
        self.present(alert, animated: true)
    }
}
