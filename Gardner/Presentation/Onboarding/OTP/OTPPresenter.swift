//
//  OTPPresenter.swift
//  Gardner
//
//  Created by Rashid Khan on 06/05/2023.
//

import Foundation

protocol OTPPresenterOutput: AnyObject, LoadingOutputs {
    func otpPresenter(_otpVerificationSuccess loginResponse: LoginResponse)
    func otpPresenter(_otpVerificationFailed message: String)
    func otpPresenter(_otpResendSuccess message: String)
    func otpPresenter(_otpResendFailed message: String)
}

protocol OTPPreseneterType: AnyObject {
    func verifyOTP(mobileNumber: String?, otp: String?)
    func resendOTP(mobileNumber: String?)
}

class OTPPresenter: OTPPreseneterType {
    weak var outputs: OTPPresenterOutput?
    private var authService: UserServiceType
    
    init(authService: UserServiceType) {
        self.authService = authService
    }
    
    func verifyOTP(mobileNumber: String?, otp: String?) {
        guard let mobileNumber = mobileNumber, let otp = otp, otp.isEmpty == false else {
            return
        }
        
        self.outputs?.startLoading()
        self.authService.verifyOTP(mobileNumber: mobileNumber, otp: otp) { (result: Result<LoginResponseWrapper, NetworkErrors>) in
            self.outputs?.stopLoading()

            switch result {

            case .success(let data):
                UserSession.instance.create(with: data.user)
                
                self.outputs?.otpPresenter(_otpVerificationSuccess: data.user)
                break


            case .failure(let error):
                self.outputs?.otpPresenter(_otpVerificationFailed: error.localizedDescription)
                break
            }
        }
    }
    
    func resendOTP(mobileNumber: String?) {
        guard let mobileNumber = mobileNumber else {
            self.outputs?.otpPresenter(_otpResendFailed: "Invalid mobile number, try again with different number")
            return
        }
        
        let pushToken = UserSession.instance.pushToken
        self.outputs?.startLoading()
        
        self.authService.requestOTP(mobileNumber: mobileNumber, pushToken: pushToken) { (result: Result<EmptyResonseDecodable, NetworkErrors>) in
            self.outputs?.stopLoading()
            
            switch result {
                
            case .success(_):
                self.outputs?.otpPresenter(_otpResendSuccess: "OTP sent successfully")
                break
                
            case .failure(let error):
                self.outputs?.otpPresenter(_otpResendFailed: error.localizedDescription)
                break
            }
        }
    }
}
