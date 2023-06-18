//
//  SupportViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 18/06/2023.
//

import UIKit

class SupportViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }

    @IBAction func cancelButtonTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func sendButtonTap(_ sender: Any) {
        self.dismiss(animated: true)
        self.showSnackBar(message: "We received your valuable feedback, our egent will be get back to you soon.")
    }
    
}
