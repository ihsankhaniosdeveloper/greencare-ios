//
//  LoginViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 26/04/2023.
//

import UIKit
import SKCountryPicker
import ProgressHUD

class LoginViewController: UIViewController {
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var viewCountryCode: UIStackView!
    
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var ivCountryFlag: UIImageView!
    
    private var presenter: LoginPresenterType!
    
    
    static func make(presenter: LoginPresenterType) -> LoginViewController {
        let vc = LoginViewController(nibName: "LoginViewController", bundle: .main)
        
        vc.presenter = presenter as! LoginPresenter
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (self.presenter as! LoginPresenter).outputs = self
        
        self.navigationController?.navigationBar.isHidden = true
        self.viewCountryCode.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCountryCodePicker(_:))))
        
        // Selecting default country
        if let country = CountryManager.shared.country(withDigitCode: "971") {
            self.updateCountryCode(country)
        }
    }
    
    @objc func showCountryCodePicker(_ sender: UITapGestureRecognizer) {
        CountryPickerController.presentController(on: self) { picker in
            picker.configuration.flagStyle = .corner
            picker.configuration.isCountryDialHidden = true
        } handler: { [weak self] country in
            guard let self = self else { return }
            
            self.updateCountryCode(country)
        }
    }
    
    private func updateCountryCode(_ country: Country) {
        self.ivCountryFlag.image = country.flag
        self.lblCountryCode.text = country.dialingCode
    }

    @IBAction func loginButtonTap(_ sender: Any) {
        self.view.endEditing(true)
        
        self.presenter.login(countryCode: self.lblCountryCode.text, mobileNumber: self.tfPhoneNumber.text)
    }
}

extension LoginViewController: LoginPresenterOutput {
    func loginPresenter(otpSendingFailedWith message: String) {
        self.showSnackBar(message: message)
    }
    
    func loginPresenter(otpSendingSuccessWith message: String) {
        let otpVC = OTPViewController(nibName: "OTPViewController", bundle: nil)
        self.navigationController?.pushViewController(otpVC, animated: true)
    }
    
    func loginPresenter(phoneNumberValidationFailed message: String) {
        self.showSnackBar(message: message)
    }
    
    func hideLoader() {
        ProgressHUD.dismiss()
    }
    
    func showLoader() {
        ProgressHUD.show("Loading ... ")
    }
}
