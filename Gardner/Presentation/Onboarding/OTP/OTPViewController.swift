//
//  OTPViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 02/05/2023.
//

import UIKit
//import CHIOTPFieldOne

class OTPViewController: UIViewController {
    
    @IBOutlet weak var fieldViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupOtpView()
        
        self.view.backgroundColor = .red
        
        self.fieldViewHeightConstraint.constant = (self.view.frame.width - 88) / 6
    }
}
// (
private extension OTPViewController {
    func setupOtpView(){
//        otpView.backgroundColor = .red
//        self.otpView.fieldsCount = 6
//        self.otpView.fieldBorderWidth = 2
//        self.otpView.defaultBorderColor = UIColor.black
//        self.otpView.filledBorderColor = UIColor.green
//        self.otpView.cursorColor = UIColor.red
//        self.otpView.displayType = .square
//        self.otpView.fieldSize = (self.otpView.bounds.width) / 6
//        self.otpView.separatorSpace = 8
//        self.otpView.shouldAllowIntermediateEditing = false
////        self.otpView.delegate = self
//        self.otpView.initializeUI()
    }
}
