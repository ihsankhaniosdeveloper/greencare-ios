//
//  AddressListingViewController.swift
//  Gardner
//
//  Created by Rashid Khan on 19/05/2023.
//

import UIKit

class AddressListingViewController: UIViewController {
    private var presenter: AddressListingPresenterType!
    
    static func make(presenter: AddressListingPresenterType) -> AddressListingViewController {
        let vc = AddressListingViewController(nibName: "AddressListingViewController", bundle: .main)
        
        vc.presenter = presenter
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "My Addresses"
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }

}
