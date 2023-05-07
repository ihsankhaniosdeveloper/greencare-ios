//
//  OTPViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 02/05/2023.
//

import UIKit

class OTPViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var otpViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblResendCode: UILabel!
    @IBOutlet weak var otpView: UITextField!
    
    // MARK: Properties
    private var presenter: OTPPreseneterType!
    private var timer: Timer?
    private let OTP_FIELDS_COUNT = 4
    private var mobileNumber: String?
    
    // MARK: Initliazations
    static func make(mobileNumber: String?, presenter: OTPPreseneterType) -> OTPViewController {
        let vc = OTPViewController(nibName: "OTPViewController", bundle: .main)
        
        vc.mobileNumber = mobileNumber
        vc.presenter = presenter
        
        return vc
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (self.presenter as! OTPPresenter).outputs = self
        
        self.otpView.becomeFirstResponder()
        self.otpView.delegate = self
        
        self.lblResendCode.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resendCodeTap(_ :))))
        self.startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.timer?.invalidate()
    }
    
    // MARK: Actions
    @IBAction func backButtonTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmButtonTap(_ sender: Any) {
        self.presenter.verifyOTP(mobileNumber: self.mobileNumber, otp: self.otpView.text)
    }
    
    @objc func resendCodeTap(_ sender: UIGestureRecognizer) {
        if self.timer?.isValid == false {
            self.presenter.resendOTP(mobileNumber: self.mobileNumber)
        }
    }
}

// MARK: - Helpers
private extension OTPViewController {
    func startTimer() {
        var remainingSeconds = 59
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            remainingSeconds -= 1
            
            self.lblResendCode.text = "Resend Code: 00:" + String(format: "%02d", remainingSeconds)

            if remainingSeconds == 0 {
                timer.invalidate()
                
                self.lblResendCode.text = "Resend Code"
            }
        }

        timer?.fire()
    }
}

// MARK: - UITextField Delegates (Implemeted for OTP View)
extension OTPViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if (self.otpView.text?.count ?? 0) == self.OTP_FIELDS_COUNT {
                    self.otpView.resignFirstResponder()
                }
            }
        }
        
        return true
    }
}

// MARK: - Presenter Outputs
extension OTPViewController: OTPPresenterOutput {
    func otpPresenter(_otpVerificationSuccess loginResponse: LoginResponse) {
        if #available(iOS 13.0, *) {
            if let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as? SceneDelegate {
                sceneDelegate.decideRootViewController()
            }

        } else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.decideRootViewController()
            }
        }
    }
    
    func otpPresenter(_otpVerificationFailed message: String) {
        self.showSnackBar(message: message)
    }
    
    func otpPresenter(_otpResendSuccess message: String) {
        self.showSnackBar(message: message)
        self.startTimer()
    }
    
    func otpPresenter(_otpResendFailed message: String) {
        self.showSnackBar(message: message)
    }
    
    func showLoader() {
        self.startLoader()
    }
    
    func hideLoader() {
        self.stopLoader()
    }
}
