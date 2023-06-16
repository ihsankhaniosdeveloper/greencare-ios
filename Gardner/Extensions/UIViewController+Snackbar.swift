//
//  UIViewController+Snackbar.swift
//  Gardner
//
//  Created by Rashid Khan on 06/05/2023.
//

import UIKit
import TTGSnackbar
import ProgressHUD

class Loader {
    static let shared = Loader()
    private var loader: LoaderViewController?
    private var viewContorller: UIViewController?
    private var isPresenterd: Bool = false
    
    func start(_ viewContorller: UIViewController) {
        if loader == nil {
            loader = LoaderViewController(nibName: "LoaderViewController", bundle: .main)
        }
        self.viewContorller = viewContorller
        loader?.modalPresentationStyle = .overFullScreen
        
        if self.isPresenterd == false {
            viewContorller.present(loader!, animated: false)
            self.isPresenterd = true
        }
    }
    
    func hides() {
        viewContorller?.dismiss(animated: false)
        self.isPresenterd = false
    }
}

extension UIViewController {
    func showSnackBar(message: String) {
        let snackbar = TTGSnackbar(message: message, duration: .middle)

        snackbar.show()
    }
    
    func stopLoader() {
        Loader.shared.hides()
    }
    
    func startLoader() {
//        Loader.shared.start(self)
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
