//
//  LoginPresenter.swift
//  Gardner
//
//  Created by Rashid Khan on 05/05/2023.
//

import Foundation

protocol LoginPresenterOutput: AnyObject, LoadingState {
    func loginPresenter(otpSendingSuccessWith message: String, mobileNumber: String)
    func loginPresenter(otpSendingFailedWith message: String)
    func loginPresenter(phoneNumberValidationFailed message: String)
}

protocol LoadingState {
    func showLoader()
    func hideLoader()
}

extension LoadingState {
    func showLoader() { }
    func hideLoader() { }
}

protocol LoginPresenterType: AnyObject {
    func login(countryCode: String?, mobileNumber: String?)
}



class LoginPresenter: LoginPresenterType {
    weak var outputs: LoginPresenterOutput?
    private var authService: AuthenticationServiceType
    
    init(authService: AuthenticationServiceType) {
        self.authService = authService
    }
    
    func login(countryCode: String?, mobileNumber: String?) {
        
        guard let countryCode = countryCode, let mobileNumber = mobileNumber, mobileNumber.isEmpty == false else {
            self.outputs?.loginPresenter(phoneNumberValidationFailed: "Mobile number couldn't be empty")
            return
        }
        
        self.outputs?.showLoader()
        let mobileNumberCountryCode = countryCode + mobileNumber
        
        authService.requestOTP(mobileNumber: mobileNumberCountryCode) { (result: Result<EmptyResonseDecodable, NetworkErrors>) in
            self.outputs?.hideLoader()
            
            switch result {
            case .success(_):
                self.outputs?.loginPresenter(otpSendingSuccessWith: "OTP sent successfully", mobileNumber: mobileNumberCountryCode)
                break
                
            case .failure(let error):
                self.outputs?.loginPresenter(otpSendingFailedWith: error.localizedDescription)
                break
            }
        }
    }
}
